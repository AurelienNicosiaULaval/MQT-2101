# Reconstruit le dossier étudiant du laboratoire 02 depuis les sources du dépôt.
# Exécuter à la racine : Rscript scripts/21_prepare_labo02.R
# Dépendances : R et l'utilitaire zip, utilisé par utils::zip().

root <- normalizePath(".", winslash = "/", mustWork = TRUE)
starter_dir <- file.path(root, "assets/exemples/laboratoire-02")
csv_path <- file.path(root, "modules/atelier-02-regression/data/livraisons_regionales_quebec.csv")
dictionary_path <- file.path(root, "modules/atelier-02-regression/data/dictionnaire-livraisons.md")
archive_path <- file.path(root, "assets/exemples/laboratoire-02.zip")
starter_names <- c("laboratoire-02.Rproj", "rapport-labo-02.qmd", "LIRE-MOI.txt", "aide-regression.R")
saturation_path <- file.path(root, "modules/semaine-04-regression-nonlineaire/data/achalandage_saturation_quebec.csv")
source_paths <- c(file.path(starter_dir, starter_names), csv_path, dictionary_path, saturation_path)
stopifnot(all(file.exists(source_paths)))

build_archive <- function() {
  build_dir <- tempfile("laboratoire-02-")
  dir.create(file.path(build_dir, "laboratoire-02/data"), recursive = TRUE)
  on.exit(unlink(build_dir, recursive = TRUE), add = TRUE)
  relative_paths <- c(
    file.path("laboratoire-02", starter_names),
    "laboratoire-02/data/livraisons_regionales_quebec.csv",
    "laboratoire-02/data/dictionnaire-livraisons.md",
    "laboratoire-02/data/achalandage_saturation_quebec.csv"
  )
  destination_paths <- file.path(build_dir, relative_paths)
  stopifnot(all(file.copy(source_paths, destination_paths)))

  # Fixer les métadonnées pour produire la même archive avec les mêmes sources.
  Sys.setFileTime(destination_paths, as.POSIXct("2026-10-01 12:00:00", tz = "UTC"))
  previous_dir <- setwd(build_dir)
  on.exit(setwd(previous_dir), add = TRUE)
  temporary_archive <- file.path(build_dir, "laboratoire-02.zip")
  status <- utils::zip(temporary_archive, files = relative_paths, flags = "-q -X")
  stopifnot(status == 0L)

  # Vérifier le contenu exact et les octets de chaque fichier avant livraison.
  listing <- utils::unzip(temporary_archive, list = TRUE)
  stopifnot(setequal(listing$Name, relative_paths))
  check_dir <- file.path(build_dir, "verification")
  utils::unzip(temporary_archive, exdir = check_dir)
  extracted_paths <- file.path(check_dir, relative_paths)
  stopifnot(identical(
    unname(tools::md5sum(source_paths)),
    unname(tools::md5sum(extracted_paths))
  ))
  stopifnot(file.copy(temporary_archive, archive_path, overwrite = TRUE))
}

build_archive()
cat("Dossier étudiant vérifié :", archive_path, "\n")
