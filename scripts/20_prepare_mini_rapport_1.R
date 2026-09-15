# Synchronise le modèle visible et son dossier téléchargeable.
# Exécuter à la racine : Rscript scripts/20_prepare_mini_rapport_1.R
# Dépendances : R et zip. Les rendus Quarto se vérifient séparément.

root <- normalizePath(".", winslash = "/", mustWork = TRUE)
starter_dir <- file.path(root, "assets/exemples/mini-rapport-1")
starter_names <- c(
  "mini-rapport-1.Rproj", "mini-rapport-1.qmd", "README.md", "data/LIRE-MOI.txt"
)
source_paths <- file.path(starter_dir, starter_names)
stopifnot(all(file.exists(source_paths)))

# Une seule source pour le fichier QMD et son aperçu copiable sur le site.
template_text <- paste(readLines(file.path(starter_dir, "mini-rapport-1.qmd"),
                                 warn = FALSE), collapse = "\n")
escape_html <- function(text) {
  text <- gsub("&", "&amp;", text, fixed = TRUE)
  text <- gsub("<", "&lt;", text, fixed = TRUE)
  text <- gsub(">", "&gt;", text, fixed = TRUE)
  gsub("`", "&#96;", text, fixed = TRUE)
}
page_path <- file.path(root, "ressources/gabarit-mini-rapport-1.qmd")
page <- paste(readLines(page_path, warn = FALSE), collapse = "\n")
start_marker <- "<!-- debut-modele-qmd -->"
end_marker <- "<!-- fin-modele-qmd -->"
start <- regexpr(start_marker, page, fixed = TRUE)[[1]]
end <- regexpr(end_marker, page, fixed = TRUE)[[1]]
stopifnot(start > 0L, end > start)
page <- paste0(
  substr(page, 1L, start + nchar(start_marker) - 1L),
  "\n      <pre><code>", escape_html(template_text), "</code></pre>\n      ",
  substr(page, end, nchar(page))
)
writeLines(page, page_path, useBytes = TRUE)

build_archive <- function() {
  build_dir <- tempfile("mini-rapport-1-")
  dir.create(file.path(build_dir, "mini-rapport-1/data"), recursive = TRUE)
  on.exit(unlink(build_dir, recursive = TRUE), add = TRUE)
  relative_paths <- file.path("mini-rapport-1", starter_names)
  destination_paths <- file.path(build_dir, relative_paths)
  stopifnot(all(file.copy(source_paths, destination_paths)))

  # Métadonnées fixes pour une archive identique à sources identiques.
  Sys.setFileTime(destination_paths, as.POSIXct("2026-01-01 12:00:00", tz = "UTC"))
  previous_dir <- setwd(build_dir)
  on.exit(setwd(previous_dir), add = TRUE)
  archive <- file.path(build_dir, "mini-rapport-1.zip")
  stopifnot(utils::zip(archive, files = relative_paths, flags = "-q -X") == 0L)
  stopifnot(setequal(utils::unzip(archive, list = TRUE)$Name, relative_paths))

  check_dir <- file.path(build_dir, "verification")
  utils::unzip(archive, exdir = check_dir)
  stopifnot(identical(
    unname(tools::md5sum(source_paths)),
    unname(tools::md5sum(file.path(check_dir, relative_paths)))
  ))
  stopifnot(file.copy(archive, file.path(root, "assets/exemples/mini-rapport-1.zip"),
                     overwrite = TRUE))
}

build_archive()
cat("Aperçu synchronisé et dossier du mini-rapport 1 vérifié.\n")
