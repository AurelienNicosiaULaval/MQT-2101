# Reconstruit le dossier étudiant du laboratoire 01 depuis les sources du dépôt.
# Exécuter à la racine : Rscript scripts/19_prepare_labo01.R
# Dépendances : R et l'utilitaire zip, utilisé par utils::zip().

root <- normalizePath(".", winslash = "/", mustWork = TRUE)
starter_dir <- file.path(root, "assets/exemples/laboratoire-01")
csv_path <- file.path(root, "modules/atelier-01-r/data/ventes_pme_quebec.csv")
archive_path <- file.path(root, "assets/exemples/laboratoire-01.zip")
starter_names <- c("laboratoire-01.Rproj", "rapport-labo-01.qmd", "LIRE-MOI.txt")
source_paths <- c(file.path(starter_dir, starter_names), csv_path)
stopifnot(all(file.exists(source_paths)))

build_archive <- function() {
  build_dir <- tempfile("laboratoire-01-")
  dir.create(file.path(build_dir, "laboratoire-01/data"), recursive = TRUE)
  on.exit(unlink(build_dir, recursive = TRUE), add = TRUE)
  relative_paths <- c(
    file.path("laboratoire-01", starter_names),
    "laboratoire-01/data/ventes_pme_quebec.csv"
  )
  destination_paths <- file.path(build_dir, relative_paths)
  stopifnot(all(file.copy(source_paths, destination_paths)))

  # Fixer les métadonnées pour produire la même archive avec les mêmes sources.
  Sys.setFileTime(destination_paths, as.POSIXct("2026-09-11 12:00:00", tz = "UTC"))
  previous_dir <- setwd(build_dir)
  on.exit(setwd(previous_dir), add = TRUE)
  temporary_archive <- file.path(build_dir, "laboratoire-01.zip")
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
