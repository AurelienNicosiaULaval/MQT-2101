# Inventaire agrégé du matériel ancien.
# Le script ne publie pas les noms des fichiers contenus dans les archives.

archive_dir <- file.path("anciens_documents", "sources_privees", "archives_zip")
output_file <- file.path("anciens_documents", "inventaire_archives.csv")

if (!dir.exists(archive_dir)) {
  stop("Le dossier des archives est introuvable : ", archive_dir)
}

zip_files <- list.files(
  archive_dir,
  pattern = "\\.zip$",
  full.names = TRUE
)

target_module <- function(file_name) {
  rules <- c(
    "Atelier en classe 1" = "modules/atelier-01-r",
    "Atelier en classe 2" = "modules/atelier-02-regression",
    "Atelier en classe 3" = "modules/atelier-03-series-chronologiques",
    "Atelier en classe 4" = "modules/atelier-04-recapitulation",
    "Préparation à l'examen" = "evaluations et modules/semaine-05-preparation-intra",
    "Solutionnaires" = "solutions privées, hors rendu public",
    "Séance 02" = "modules/semaine-02-r-quarto",
    "Séance 03" = "modules/semaine-03-regression-lineaire",
    "Séance 04" = "modules/semaine-04-regression-nonlineaire",
    "Séance 05" = "modules/semaine-05-preparation-intra",
    "Séance 06" = "modules/semaine-06-series-chronologiques-intro",
    "Séance 07" = "modules/semaine-07-lissage",
    "Séance 08" = "modules/semaine-08-tendance-saisonnalite",
    "Séance 09" = "modules/semaine-09-variables-externes-autocorrelation",
    "Séance 10" = "modules/semaine-10-classification-modeles-avances",
    "Séance 11" = "modules/atelier-04-recapitulation",
    "Examen intra" = "archive sensible, ne pas publier",
    "Examen final" = "archive sensible, ne pas publier"
  )

  match <- names(rules)[vapply(names(rules), grepl, logical(1), x = file_name)]

  if (length(match) == 0) {
    return("à classer")
  }

  unname(rules[[match[1]]])
}

count_extensions <- function(file_names, extension) {
  sum(tolower(tools::file_ext(file_names)) == extension)
}

inventory <- lapply(zip_files, function(zip_file) {
  file_name <- basename(zip_file)
  is_sensitive <- grepl("Examen (intra|final)", file_name, ignore.case = TRUE)
  zip_listing <- utils::unzip(zip_file, list = TRUE)
  names_in_zip <- zip_listing$Name

  data.frame(
    archive = file_name,
    sensitive = is_sensitive,
    file_count = length(names_in_zip),
    csv_count = count_extensions(names_in_zip, "csv"),
    xlsx_count = count_extensions(names_in_zip, "xlsx"),
    rmd_count = count_extensions(names_in_zip, "rmd"),
    html_count = count_extensions(names_in_zip, "html"),
    pdf_count = count_extensions(names_in_zip, "pdf"),
    zip_count = count_extensions(names_in_zip, "zip"),
    suggested_target = target_module(file_name),
    stringsAsFactors = FALSE
  )
})

inventory <- do.call(rbind, inventory)

plan_pdf <- list.files(archive_dir, pattern = "\\.pdf$", full.names = FALSE)

if (length(plan_pdf) > 0) {
  inventory <- rbind(
    inventory,
    data.frame(
      archive = plan_pdf,
      sensitive = FALSE,
      file_count = 1L,
      csv_count = 0L,
      xlsx_count = 0L,
      rmd_count = 0L,
      html_count = 0L,
      pdf_count = 1L,
      zip_count = 0L,
      suggested_target = "plan-de-cours.qmd et calendrier.qmd",
      stringsAsFactors = FALSE
    )
  )
}

inventory <- inventory[order(inventory$archive), ]

utils::write.csv(inventory, output_file, row.names = FALSE, fileEncoding = "UTF-8")

message("Inventaire écrit dans : ", output_file)
