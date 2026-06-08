# Données simulées pour le module 04.

suppressPackageStartupMessages({
  library(tidyverse)
  library(lubridate)
})

set.seed(210104)

output_dir <- file.path("modules", "semaine-04-regression-nonlineaire", "data")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

mois <- seq.Date(
  from = as.Date("2025-01-01"),
  to = as.Date("2025-12-01"),
  by = "month"
)

mois_fr <- c(
  "janvier",
  "février",
  "mars",
  "avril",
  "mai",
  "juin",
  "juillet",
  "août",
  "septembre",
  "octobre",
  "novembre",
  "décembre"
)

succursales <- tibble(
  succursale = c("Québec", "Montréal", "Sherbrooke", "Trois-Rivières", "Gatineau", "Saguenay"),
  region = c(
    "Capitale-Nationale",
    "Montréal",
    "Estrie",
    "Mauricie",
    "Outaouais",
    "Saguenay-Lac-Saint-Jean"
  ),
  surface_m2 = c(465, 590, 385, 360, 420, 345),
  capacite_reference = c(2450, 3300, 1850, 1720, 2050, 1600),
  indice_marche = c(1.04, 1.30, 0.90, 0.84, 0.98, 0.78)
)

achalandage_saturation <- crossing(mois = mois, succursales) |>
  mutate(
    mois_label = mois_fr[month(mois)],
    saison = case_when(
      month(mois) %in% c(11, 12) ~ "haute",
      month(mois) %in% c(1, 2, 7) ~ "moyenne",
      TRUE ~ "régulière"
    ),
    campagne_locale = sample(
      c("oui", "non"),
      size = n(),
      replace = TRUE,
      prob = c(0.42, 0.58)
    ),
    depenses_marketing = round(
      rnorm(
        n(),
        mean = 3900 * indice_marche +
          if_else(campagne_locale == "oui", 1700, 0) +
          if_else(saison == "haute", 1100, 0),
        sd = 640
      )
    ),
    depenses_marketing = pmax(depenses_marketing, 1200),
    achalandage = round(
      rnorm(
        n(),
        mean = capacite_reference *
          case_when(
            saison == "haute" ~ 1.08,
            saison == "moyenne" ~ 0.95,
            TRUE ~ 0.82
          ) +
          0.075 * depenses_marketing,
        sd = 155
      )
    ),
    achalandage = pmax(achalandage, 420),
    taux_occupation = round(achalandage / capacite_reference, 3),
    ruptures_stock = pmax(
      0,
      rpois(
        n(),
        lambda = 1.1 +
          2.3 * pmax(taux_occupation - 0.90, 0) +
          if_else(saison == "haute", 0.8, 0)
      )
    ),
    temps_attente_minutes = round(
      pmax(
        1.5,
        rnorm(
          n(),
          mean = 3.2 + 5.4 * pmax(taux_occupation - 0.72, 0)^2 +
            0.35 * ruptures_stock,
          sd = 0.55
        )
      ),
      1
    ),
    ventes = round(
      28000 +
        168000 * (1 - exp(-achalandage / 1750)) +
        3.8 * depenses_marketing -
        2100 * ruptures_stock +
        rnorm(n(), mean = 0, sd = 7200)
    ),
    panier_moyen = round(
      ventes / achalandage,
      2
    ),
    satisfaction = round(
      pmin(
        10,
        pmax(
          1,
          rnorm(
            n(),
            mean = 8.6 - 0.22 * temps_attente_minutes - 0.08 * ruptures_stock,
            sd = 0.45
          )
        )
      ),
      1
    )
  ) |>
  select(
    mois,
    mois_label,
    saison,
    succursale,
    region,
    surface_m2,
    capacite_reference,
    campagne_locale,
    depenses_marketing,
    achalandage,
    taux_occupation,
    ruptures_stock,
    temps_attente_minutes,
    panier_moyen,
    satisfaction,
    ventes
  )

write_csv(
  achalandage_saturation,
  file.path(output_dir, "achalandage_saturation_quebec.csv")
)

message("Données créées : ", file.path(output_dir, "achalandage_saturation_quebec.csv"))
