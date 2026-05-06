# Rend le site Quarto du cours MQT-2101.

if (!requireNamespace("quarto", quietly = TRUE)) {
  stop("Le package R 'quarto' doit être installé. Lancer scripts/00_install_packages.R.")
}

quarto::quarto_render(input = ".")

docs_files <- list.files(
  "docs",
  pattern = "\\.(html|json|css)$",
  recursive = TRUE,
  full.names = TRUE
)

for (file in docs_files) {
  lines <- readLines(file, warn = FALSE)
  writeLines(sub("[ \t]+$", "", lines), file, useBytes = TRUE)
}

message("Site rendu dans le dossier docs/.")
