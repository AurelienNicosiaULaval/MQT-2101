# Vérifie les sources étudiantes et les fichiers rendus correspondants.
# Exécuter après le rendu, depuis la racine du projet :
# Rscript scripts/14_validate_site_output.R

if (!dir.exists("docs")) {
  stop("Le dossier docs est absent. Rendre le site avant cette validation.")
}

render_sources <- c(
  "index.qmd",
  "plan-de-cours.qmd",
  "calendrier.qmd",
  "installation.qmd",
  list.files("modules", pattern = "[.]qmd$", recursive = TRUE, full.names = TRUE),
  list.files("evaluations", pattern = "[.]qmd$", recursive = TRUE, full.names = TRUE),
  list.files("ressources", pattern = "[.]qmd$", recursive = TRUE, full.names = TRUE),
  "donnees/index.qmd"
)
render_sources <- sort(unique(render_sources[!grepl("solutions[.]qmd$", render_sources)]))

errors <- character()
links_checked <- 0L
downloads_found <- 0L
root <- normalizePath(".", winslash = "/", mustWork = TRUE)

add_error <- function(message) {
  errors <<- c(errors, message)
}

extract_links <- function(text) {
  markdown_matches <- gregexpr("\\]\\(([^)[:space:]]+)", text, perl = TRUE)[[1]]
  markdown_links <- if (identical(markdown_matches, -1L)) {
    character()
  } else {
    sub("^\\]\\(", "", regmatches(text, list(markdown_matches))[[1]])
  }

  html_matches <- gregexpr("(?i)(?:href|src)=[\"'][^\"']+[\"']", text, perl = TRUE)[[1]]
  html_links <- if (identical(html_matches, -1L)) {
    character()
  } else {
    tokens <- sub("^[^=]+=[\"']", "", regmatches(text, list(html_matches))[[1]])
    sub("[\"']$", "", tokens)
  }

  unique(c(markdown_links, html_links))
}

local_path_for_link <- function(link, source) {
  link <- gsub("&amp;", "&", link, fixed = TRUE)
  link <- utils::URLdecode(link)
  link <- sub("[?#].*$", "", link)

  if (!nzchar(link)) return(NULL)
  if (grepl("^(?:https?:|mailto:|tel:|javascript:|data:)", link, ignore.case = TRUE)) return(NULL)
  if (startsWith(link, "/")) return(NULL)

  link_parent <- normalizePath(
    file.path(dirname(source), dirname(link)),
    winslash = "/",
    mustWork = FALSE
  )
  candidate <- file.path(link_parent, basename(link))
  if (!startsWith(candidate, paste0(root, "/")) && candidate != root) {
    add_error(paste0(source, " -> ", link, " : cible hors du dépôt."))
    return(NULL)
  }

  substring(candidate, nchar(root) + 2L)
}

for (source in render_sources) {
  if (!file.exists(source)) {
    add_error(paste0("Source de rendu absente : ", source))
    next
  }

  output <- file.path("docs", sub("[.]qmd$", ".html", source))
  if (!file.exists(output)) {
    add_error(paste0("Sortie HTML absente : ", output))
  }

  text <- paste(readLines(source, warn = FALSE), collapse = "\n")
  links <- extract_links(text)
  downloads_found <- downloads_found + sum(grepl("download", text, fixed = TRUE))

  for (link in links) {
    local_path <- local_path_for_link(link, source)
    if (is.null(local_path)) next
    links_checked <- links_checked + 1L

    local_path <- sub("/$", "", local_path)
    extension <- tolower(tools::file_ext(local_path))

    if (extension == "html") {
      target <- file.path("docs", local_path)
    } else if (extension == "qmd") {
      target <- local_path
    } else if (nzchar(extension)) {
      target <- local_path
    } else {
      candidates <- c(
        local_path,
        file.path(local_path, "index.qmd"),
        file.path("docs", local_path, "index.html")
      )
      target <- candidates[file.exists(candidates)][1]
      if (is.na(target)) target <- local_path
    }

    if (!file.exists(target)) {
      add_error(paste0(source, " -> ", link, " : cible locale absente."))
    }
  }

  if (grepl("\\b(?:TODO|FIXME)\\b", text, perl = TRUE)) {
    add_error(paste0(source, " : marqueur TODO ou FIXME dans une source étudiante."))
  }
}

solution_outputs <- list.files("docs", pattern = "solutions[.]html$", recursive = TRUE, full.names = TRUE)
if (length(solution_outputs)) {
  add_error(paste0("Solution publiée par erreur : ", paste(solution_outputs, collapse = ", ")))
}

duplicate_names <- list.files(".", pattern = "(?: 2[.](?:qmd|csv)|[.]gitkeep 2)$", recursive = TRUE, full.names = TRUE)
duplicate_names <- duplicate_names[!startsWith(duplicate_names, "./docs/")]
if (length(duplicate_names)) {
  add_error(paste0("Nom de copie système détecté : ", paste(duplicate_names, collapse = ", ")))
}

installer_source <- "scripts/00_install_packages.R"
installer_output <- "docs/scripts/00_install_packages.R"
if (!file.exists(installer_output) ||
    unname(tools::md5sum(installer_source)) != unname(tools::md5sum(installer_output))) {
  add_error("Le script d'installation publié est absent ou différent de sa source.")
}

cat("Validation du site rendu MQT-2101\n")
cat("Sources étudiantes :", length(render_sources), "\n")
cat("Références locales vérifiées :", links_checked, "\n")
cat("Attributs de téléchargement repérés :", downloads_found, "\n")
cat("Erreurs :", length(errors), "\n")

if (length(errors)) {
  cat(paste0("- ", errors, collapse = "\n"), "\n")
  quit(status = 1)
}

cat("Sources et sorties du site validées.\n")
