# Rend le site Quarto du cours MQT-2101.

if (!requireNamespace("quarto", quietly = TRUE)) {
  stop("Le package R 'quarto' doit être installé. Lancer scripts/00_install_packages.R.")
}

quarto::quarto_render(input = ".")

docs_files <- list.files(
  "docs",
  pattern = "\\.(html|json|css|js|xml|md)$",
  recursive = TRUE,
  full.names = TRUE
)

for (file in docs_files) {
  lines <- readLines(file, warn = FALSE)
  writeLines(sub("[ \t]+$", "", lines), file, useBytes = TRUE)
}

html_files <- docs_files[grepl("\\.html$", docs_files)]
site_libs_is_used <- any(vapply(
  html_files,
  function(file) {
    any(grepl("site_libs", readLines(file, warn = FALSE), fixed = TRUE))
  },
  logical(1)
))

if (dir.exists("docs/site_libs") && !site_libs_is_used) {
  unlink("docs/site_libs", recursive = TRUE)
}

message("Site rendu dans le dossier docs/.")
