# Données simulées pour l'atelier 01.
# Le jeu de données représente une PME québécoise fictive.

suppressPackageStartupMessages({
  library(tidyverse)
  library(lubridate)
})

set.seed(2101)

output_dir <- file.path("modules", "atelier-01-r", "data")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

succursales <- tibble(
  succursale = c("Québec", "Montréal", "Sherbrooke", "Trois-Rivières", "Gatineau"),
  region = c(
    "Capitale-Nationale",
    "Montréal",
    "Estrie",
    "Mauricie",
    "Outaouais"
  ),
  surface_m2 = c(460, 520, 390, 360, 410),
  indice_achalandage = c(1.05, 1.22, 0.88, 0.82, 0.94)
)

mois <- seq.Date(
  from = as.Date("2025-01-01"),
  to = as.Date("2025-12-01"),
  by = "month"
)

effets_mois <- tibble(
  mois = mois,
  saison = case_when(
    month(mois) %in% c(11, 12) ~ "haute",
    month(mois) %in% c(1, 2, 7) ~ "moyenne",
    TRUE ~ "reguliere"
  ),
  effet_saison = case_when(
    saison == "haute" ~ 1.18,
    saison == "moyenne" ~ 1.05,
    TRUE ~ 1
  )
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

ventes_pme_quebec <- tidyr::crossing(
  mois = mois,
  succursales
) |>
  left_join(effets_mois, by = "mois") |>
  mutate(
    mois_label = mois_fr[month(mois)],
    campagne_locale = rbinom(n(), size = 1, prob = 0.35),
    depenses_marketing = round(
      runif(n(), min = 1800, max = 6200) *
        if_else(campagne_locale == 1, 1.35, 1)
    ),
    clients = round(
      rnorm(
        n(),
        mean = 1850 * indice_achalandage * effet_saison +
          0.06 * depenses_marketing,
        sd = 120
      )
    ),
    panier_moyen = round(
      rnorm(
        n(),
        mean = 58 + 0.006 * depenses_marketing / 10 +
          if_else(saison == "haute", 5, 0),
        sd = 4.5
      ),
      2
    ),
    ventes = round(clients * panier_moyen),
    delai_livraison_jours = round(
      pmax(
        1.2,
        rnorm(
          n(),
          mean = 3.4 + if_else(saison == "haute", 0.8, 0) -
            0.002 * surface_m2,
          sd = 0.45
        )
      ),
      1
    ),
    ruptures_stock = pmax(
      0,
      rpois(n(), lambda = 2.2 + if_else(saison == "haute", 1.4, 0))
    ),
    satisfaction = round(
      pmin(
        10,
        pmax(
          1,
          rnorm(
            n(),
            mean = 8.4 - 0.24 * delai_livraison_jours -
              0.10 * ruptures_stock +
              if_else(campagne_locale == 1, 0.25, 0),
            sd = 0.55
          )
        )
      ),
      1
    ),
    taux_retour = round(
      pmin(
        0.18,
        pmax(
          0.01,
          rnorm(
            n(),
            mean = 0.045 + 0.006 * ruptures_stock -
              0.003 * satisfaction,
            sd = 0.012
          )
        )
      ),
      3
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
    clients,
    panier_moyen,
    ventes,
    delai_livraison_jours,
    ruptures_stock,
    satisfaction,
    taux_retour
  )

# Quelques valeurs manquantes réalistes pour alimenter le diagnostic.
ventes_pme_quebec$satisfaction[c(8, 27, 43)] <- NA_real_
ventes_pme_quebec$delai_livraison_jours[c(19, 51)] <- NA_real_

readr::write_csv(
  ventes_pme_quebec,
  file.path(output_dir, "ventes_pme_quebec.csv")
)

message("Données créées : ", file.path(output_dir, "ventes_pme_quebec.csv"))
