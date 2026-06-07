# Données simulées pour le module 03 et l'atelier 02.

suppressPackageStartupMessages({
  library(tidyverse)
  library(lubridate)
})

set.seed(210103)

module_03_dir <- file.path("modules", "semaine-03-regression-lineaire", "data")
atelier_02_dir <- file.path("modules", "atelier-02-regression", "data")

dir.create(module_03_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(atelier_02_dir, recursive = TRUE, showWarnings = FALSE)

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

# Module 03: campagnes marketing fictives.

regions_marketing <- tibble(
  region = c("Capitale-Nationale", "Montréal", "Estrie", "Mauricie", "Outaouais"),
  effet_region = c(4500, 9500, -1800, -2600, 1200),
  indice_marche = c(1.04, 1.22, 0.88, 0.84, 0.96)
)

campagnes_marketing_quebec <- crossing(
  mois = mois,
  regions_marketing
) |>
  mutate(
    mois_label = mois_fr[month(mois)],
    canal = sample(
      c("Recherche", "Réseaux sociaux", "Infolettre"),
      size = n(),
      replace = TRUE,
      prob = c(0.42, 0.38, 0.20)
    ),
    saison = case_when(
      month(mois) %in% c(11, 12) ~ "haute",
      month(mois) %in% c(1, 2, 7) ~ "moyenne",
      TRUE ~ "régulière"
    ),
    effet_saison = case_when(
      saison == "haute" ~ 8200,
      saison == "moyenne" ~ 3400,
      TRUE ~ 0
    ),
    rabais = round(runif(n(), min = 0, max = 0.18), 2),
    budget_marketing = round(
      rnorm(
        n(),
        mean = 5200 * indice_marche + if_else(saison == "haute", 1800, 0),
        sd = 850
      )
    ),
    budget_marketing = pmax(budget_marketing, 1800),
    visites_site = round(
      rnorm(
        n(),
        mean = 1800 + 0.78 * budget_marketing + 900 * rabais + 400 * indice_marche,
        sd = 430
      )
    ),
    ventes = round(
      36000 +
        8.6 * budget_marketing +
        2.1 * visites_site +
        26000 * rabais +
        effet_region +
        effet_saison +
        rnorm(n(), mean = 0, sd = 7200)
    ),
    satisfaction = round(
      pmin(
        10,
        pmax(
          1,
          rnorm(
            n(),
            mean = 6.1 + 0.000015 * ventes - 1.6 * rabais,
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
    region,
    canal,
    saison,
    budget_marketing,
    visites_site,
    rabais,
    ventes,
    satisfaction
  )

write_csv(
  campagnes_marketing_quebec,
  file.path(module_03_dir, "campagnes_marketing_quebec.csv")
)

# Atelier 02: performance de succursales fictives.

succursales <- tibble(
  succursale = c(
    "Québec",
    "Montréal",
    "Sherbrooke",
    "Trois-Rivières",
    "Gatineau",
    "Saguenay"
  ),
  region = c(
    "Capitale-Nationale",
    "Montréal",
    "Estrie",
    "Mauricie",
    "Outaouais",
    "Saguenay-Lac-Saint-Jean"
  ),
  surface_m2 = c(470, 560, 390, 365, 420, 350),
  indice_achalandage = c(1.05, 1.28, 0.90, 0.84, 0.96, 0.80)
)

performance_succursales_quebec <- crossing(
  mois = mois,
  succursales
) |>
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
      prob = c(0.38, 0.62)
    ),
    depenses_marketing = round(
      rnorm(
        n(),
        mean = 4300 * indice_achalandage +
          if_else(campagne_locale == "oui", 1600, 0) +
          if_else(saison == "haute", 1200, 0),
        sd = 700
      )
    ),
    depenses_marketing = pmax(depenses_marketing, 1200),
    achalandage = round(
      rnorm(
        n(),
        mean = 1350 * indice_achalandage +
          0.055 * depenses_marketing +
          if_else(saison == "haute", 260, 0),
        sd = 110
      )
    ),
    heures_personnel = round(
      rnorm(
        n(),
        mean = 360 + 0.055 * achalandage + 0.10 * surface_m2,
        sd = 22
      )
    ),
    ruptures_stock = pmax(
      0,
      rpois(
        n(),
        lambda = 1.7 +
          if_else(saison == "haute", 1.2, 0) -
          0.00015 * surface_m2
      )
    ),
    delai_service_minutes = round(
      pmax(
        2.5,
        rnorm(
          n(),
          mean = 7.2 + 0.0017 * achalandage - 0.010 * heures_personnel +
            0.42 * ruptures_stock,
          sd = 0.8
        )
      ),
      1
    ),
    satisfaction = round(
      pmin(
        10,
        pmax(
          1,
          rnorm(
            n(),
            mean = 9.1 - 0.18 * delai_service_minutes -
              0.11 * ruptures_stock +
              if_else(campagne_locale == "oui", 0.18, 0),
            sd = 0.45
          )
        )
      ),
      1
    ),
    ventes = round(
      18500 +
        42 * achalandage +
        4.3 * depenses_marketing +
        88 * heures_personnel -
        950 * ruptures_stock +
        5200 * if_else(campagne_locale == "oui", 1, 0) +
        rnorm(n(), mean = 0, sd = 6200)
    )
  ) |>
  select(
    mois,
    mois_label,
    saison,
    succursale,
    region,
    surface_m2,
    campagne_locale,
    depenses_marketing,
    achalandage,
    heures_personnel,
    ruptures_stock,
    delai_service_minutes,
    satisfaction,
    ventes
  )

write_csv(
  performance_succursales_quebec,
  file.path(atelier_02_dir, "performance_succursales_quebec.csv")
)

message("Données créées pour le module 03 et l'atelier 02.")
