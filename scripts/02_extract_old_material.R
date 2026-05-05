# Extraction contrôlée du matériel ancien.
# Les fichiers existants ne sont pas écrasés.

archive_dir <- file.path("anciens_documents", "sources_privees", "archives_zip")
extract_dir <- file.path("anciens_documents", "sources_privees", "extraits")

if (!dir.exists(archive_dir)) {
  stop("Le dossier des archives est introuvable : ", archive_dir)
}

dir.create(extract_dir, recursive = TRUE, showWarnings = FALSE)

zip_files <- list.files(
  archive_dir,
  pattern = "\\.zip$",
  full.names = TRUE
)

if (length(zip_files) == 0) {
  message("Aucune archive ZIP trouvée.")
} else {
  for (zip_file in zip_files) {
    target_dir <- file.path(
      extract_dir,
      tools::file_path_sans_ext(basename(zip_file))
    )

    dir.create(target_dir, recursive = TRUE, showWarnings = FALSE)

    message("Extraction : ", basename(zip_file))
    utils::unzip(zip_file, exdir = target_dir, overwrite = FALSE)
  }
}

message("Extraction terminée. Vérifier le contenu avant toute intégration pédagogique.")

