#!/usr/bin/env Rscript

# Regenerate the capsule PDFs that are linked from the public site.
# The HTML decks must already have been rendered in docs/.

suppressPackageStartupMessages({
  library(fs)
  library(glue)
  library(purrr)
  library(stringr)
})

project_dir <- path_abs(".")
docs_dir <- path(project_dir, "docs")
chrome_path <- "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
server_port <- 9246L

if (!file_exists(chrome_path)) {
  stop("Google Chrome est introuvable à l'emplacement attendu.")
}

if (!dir_exists(docs_dir)) {
  stop("Le dossier docs/ est absent. Exécutez d'abord scripts/99_render_site.R.")
}

deck_sources <- dir_ls(
  path(project_dir, "modules"),
  recurse = TRUE,
  regexp = "semaine-0[1-5].*/media/qmd/capsule-[0-9]{2}-support\\.qmd$"
) |>
  sort()

if (length(deck_sources) != 30L) {
  stop(glue("30 supports PDF étaient attendus; {length(deck_sources)} ont été trouvés."))
}

server_log <- tempfile("mqt2101-pdf-server-", fileext = ".log")
server_pid <- system2(
  "python3",
  c("-m", "http.server", server_port, "--bind", "127.0.0.1", "--directory", docs_dir),
  stdout = server_log,
  stderr = server_log,
  wait = FALSE
)

on.exit({
  try(tools::pskill(server_pid), silent = TRUE)
  unlink(server_log)
}, add = TRUE)

Sys.sleep(1)

generate_pdf <- function(source_path) {
  relative_source <- path_rel(source_path, project_dir)
  relative_html <- relative_source |>
    str_replace("^modules/", "modules/") |>
    str_replace("\\.qmd$", ".html")
  relative_pdf <- relative_source |>
    str_replace("/media/qmd/", "/media/pdf/") |>
    str_replace("\\.qmd$", ".pdf")
  html_path <- path(docs_dir, relative_html)
  output_path <- path(project_dir, relative_pdf)
  url <- glue("http://127.0.0.1:{server_port}/{relative_html}?print-pdf")

  dir_create(path_dir(output_path), recurse = TRUE)

  if (
    file_exists(output_path) &&
      file_size(output_path) >= 50000 &&
      file_info(output_path)$modification_time >= file_info(html_path)$modification_time
  ) {
    message("PDF déjà synchronisé: ", relative_pdf)
    return(invisible(output_path))
  }

  success <- FALSE
  for (attempt in seq_len(3L)) {
    unlink(output_path)
    status <- system2(
      chrome_path,
      c(
        "--headless=new",
        "--disable-gpu",
        "--no-pdf-header-footer",
        "--run-all-compositor-stages-before-draw",
        "--virtual-time-budget=10000",
        glue("--print-to-pdf={output_path}"),
        url
      ),
      stdout = FALSE,
      stderr = FALSE
    )

    success <- identical(status, 0L) &&
      file_exists(output_path) &&
      file_size(output_path) >= 50000

    if (success) break
    Sys.sleep(1)
  }

  if (!success) {
    stop(glue("Échec de génération du PDF: {relative_pdf}"))
  }

  message("PDF synchronisé: ", relative_pdf)
  invisible(output_path)
}

walk(deck_sources, generate_pdf)
message("30 PDF de capsules ont été régénérés à partir des supports HTML validés.")
