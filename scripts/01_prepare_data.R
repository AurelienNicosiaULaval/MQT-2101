# Squelette de préparation des données du cours MQT-2101.

source("R/helpers.R")

dir.create("donnees/brutes", recursive = TRUE, showWarnings = FALSE)
dir.create("donnees/preparees", recursive = TRUE, showWarnings = FALSE)
dir.create("donnees/simulees", recursive = TRUE, showWarnings = FALSE)

# TODO: Lire les données brutes avec read_course_csv() ou readxl::read_excel().
# TODO: Nettoyer les noms de variables avec janitor::clean_names().
# TODO: Documenter chaque transformation.
# TODO: Enregistrer les fichiers préparés dans donnees/preparees/.

create_example_data <- FALSE

if (create_example_data) {
  ventes_exemple <- data.frame(
    mois = seq.Date(as.Date("2025-01-01"), by = "month", length.out = 12),
    ventes = round(120000 + seq_len(12) * 1500 + rnorm(12, sd = 5000)),
    panier_moyen = round(55 + rnorm(12, sd = 4), 2)
  )

  readr::write_csv(ventes_exemple, "donnees/simulees/ventes_mensuelles_exemple.csv")
}

message("Squelette de préparation des données exécuté.")

