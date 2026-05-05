# Rend le site Quarto du cours MQT-2101.

if (!requireNamespace("quarto", quietly = TRUE)) {
  stop("Le package R 'quarto' doit être installé. Lancer scripts/00_install_packages.R.")
}

quarto::quarto_render(input = ".")

message("Site rendu dans le dossier docs/.")

