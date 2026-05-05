# Données simulées pour la semaine 01.
# Le jeu de données sert au diagnostic initial du cours.

options(warn = -1)

suppressPackageStartupMessages({
  library(tidyverse)
})

output_dir <- file.path("modules", "semaine-01-introduction", "data")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

diagnostic_succursales <- tibble(
  succursale = c("Québec", "Montréal", "Sherbrooke", "Trois-Rivières", "Gatineau"),
  region = c(
    "Capitale-Nationale",
    "Montréal",
    "Estrie",
    "Mauricie",
    "Outaouais"
  ),
  ventes_mensuelles = c(142295, 168615, 120156, 108458, 129858),
  clients = c(2280, 2568, 2013, 1842, 2188),
  panier_moyen = c(62.41, 65.66, 59.69, 58.88, 59.35),
  satisfaction = c(8.7, 7.9, 8.5, 7.4, 7.6),
  delai_livraison_jours = c(2.4, 2.5, 2.3, 3.4, 3.0),
  ruptures_stock = c(1, 3, 3, 5, 6)
)

readr::write_csv(
  diagnostic_succursales,
  file.path(output_dir, "diagnostic_succursales.csv")
)

message("Données créées : ", file.path(output_dir, "diagnostic_succursales.csv"))
