# Extraction contrôlée du matériel ancien.
# Les fichiers existants ne sont pas écrasés.
# Par défaut, les archives d'examen sont ignorées parce qu'elles peuvent
# contenir des fichiers nominatifs.

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

include_sensitive <- identical(
  Sys.getenv("INCLUDE_SENSITIVE_OLD_MATERIAL"),
  "true"
)

sensitive_archives <- grepl(
  "Examen (intra|final)",
  basename(zip_files),
  ignore.case = TRUE
)

if (!include_sensitive && any(sensitive_archives)) {
  skipped <- basename(zip_files[sensitive_archives])
  message(
    "Archives sensibles ignorées par défaut : ",
    paste(skipped, collapse = ", ")
  )
  zip_files <- zip_files[!sensitive_archives]
}

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

if (!include_sensitive) {
  message(
    "Pour extraire aussi les archives sensibles localement, définir ",
    "INCLUDE_SENSITIVE_OLD_MATERIAL=true avant d'exécuter ce script."
  )
}
