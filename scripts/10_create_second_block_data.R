# Crée les jeux de données simulés des modules 06 à 10 et des ateliers 03 et 04.
# Tous les jeux sont déterministes, fictifs et destinés exclusivement à l'enseignement.

suppressPackageStartupMessages({
  library(tidyverse)
  library(lubridate)
})

set.seed(210110)

write_course_csv <- function(data, path) {
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  readr::write_csv(data, path)
  message("Données créées : ", path)
}

mois_fr <- c(
  "janvier", "février", "mars", "avril", "mai", "juin",
  "juillet", "août", "septembre", "octobre", "novembre", "décembre"
)

# Module 06 : première lecture d'une série mensuelle.
dates_mensuelles <- seq.Date(as.Date("2020-01-01"), as.Date("2025-12-01"), by = "month")
t_mois <- seq_along(dates_mensuelles)
saison_mois <- c(-0.10, -0.07, -0.02, 0.01, 0.04, 0.07, 0.03, 0.02, 0.08, 0.12, 0.23, 0.31)

ventes_mensuelles <- tibble(
  date = dates_mensuelles,
  annee = year(date),
  mois = month(date),
  mois_label = factor(mois_fr[mois], levels = mois_fr),
  trimestre = paste0("T", quarter(date)),
  jours_ouverture = sample(24:27, length(date), replace = TRUE),
  clients = round(
    4100 + 24 * t_mois + 1250 * saison_mois[mois] + rnorm(length(date), 0, 150)
  ),
  ventes = round(
    205000 + 2350 * t_mois + 92000 * saison_mois[mois] +
      19 * clients + rnorm(length(date), 0, 9500)
  )
) |>
  mutate(
    ventes = pmax(ventes, 100000),
    clients = pmax(clients, 1000)
  )

write_course_csv(
  ventes_mensuelles,
  "modules/semaine-06-series-chronologiques-intro/data/ventes_mensuelles_quebec.csv"
)

# Module 07 et atelier 03 : demande hebdomadaire avec tendance, saisonnalité et promotions.
dates_hebdomadaires <- seq.Date(as.Date("2024-01-01"), by = "week", length.out = 104)
t_sem <- seq_along(dates_hebdomadaires)
promotion_sem <- rbinom(length(t_sem), 1, 0.22)

demande_hebdomadaire <- tibble(
  semaine = dates_hebdomadaires,
  numero_semaine = isoweek(semaine),
  promotion = if_else(promotion_sem == 1, "oui", "non"),
  prix_moyen = round(42 - 3.2 * promotion_sem + rnorm(length(t_sem), 0, 0.75), 2),
  demande = round(
    1150 + 3.1 * t_sem + 135 * sin(2 * pi * t_sem / 52) +
      180 * promotion_sem + rnorm(length(t_sem), 0, 55)
  )
) |>
  mutate(demande = pmax(demande, 400))

write_course_csv(
  demande_hebdomadaire,
  "modules/semaine-07-lissage/data/demande_hebdomadaire_quebec.csv"
)
write_course_csv(
  demande_hebdomadaire,
  "modules/atelier-03-series-chronologiques/data/demande_hebdomadaire_quebec.csv"
)

# Module 08 : série mensuelle avec tendance et saisonnalité plus marquées.
ventes_saisonnieres <- ventes_mensuelles |>
  transmute(
    date,
    annee,
    mois,
    mois_label,
    trimestre,
    indice_temps = row_number(),
    ventes = round(ventes * (1 + 0.04 * sin(2 * pi * indice_temps / 12))),
    budget_cible = round(220000 + 2600 * indice_temps + 85000 * saison_mois[mois])
  )

write_course_csv(
  ventes_saisonnieres,
  "modules/semaine-08-tendance-saisonnalite/data/ventes_saisonnieres_quebec.csv"
)

# Module 09 : prévision avec variables externes et erreurs autocorrélées.
promotion_mois <- rbinom(length(t_mois), 1, 0.30)
indice_confiance <- 100 + cumsum(rnorm(length(t_mois), 0.05, 0.55))
erreur_ar <- as.numeric(arima.sim(model = list(ar = 0.58), n = length(t_mois), sd = 7500))
prix_moyen <- 58 + 0.06 * t_mois - 4.2 * promotion_mois + rnorm(length(t_mois), 0, 0.8)

ventes_promotions <- tibble(
  date = dates_mensuelles,
  annee = year(date),
  mois = month(date),
  mois_label = factor(mois_fr[mois], levels = mois_fr),
  tendance = t_mois,
  promotion = if_else(promotion_mois == 1, "oui", "non"),
  prix_moyen = round(prix_moyen, 2),
  indice_confiance = round(indice_confiance, 1),
  budget_marketing = round(14500 + 5200 * promotion_mois + rnorm(length(t_mois), 0, 1200)),
  ventes = round(
    320000 + 3100 * t_mois + 62000 * saison_mois[mois] +
      48000 * promotion_mois - 5400 * (prix_moyen - 58) +
      2800 * (indice_confiance - 100) + erreur_ar
  )
) |>
  mutate(
    budget_marketing = pmax(budget_marketing, 5000),
    ventes = pmax(ventes, 120000)
  )

write_course_csv(
  ventes_promotions,
  "modules/semaine-09-variables-externes-autocorrelation/data/ventes_promotions_quebec.csv"
)

# Module 10 : clientèle fictive et départ dans les 90 jours.
n_clients <- 650
anciennete <- pmax(1, round(rgamma(n_clients, shape = 2.5, scale = 12)))
utilisation <- pmax(0, round(rnorm(n_clients, 14, 5), 1))
tickets <- rpois(n_clients, lambda = 1.5)
satisfaction <- pmin(10, pmax(1, round(rnorm(n_clients, 7.3 - 0.22 * tickets, 1.2), 1)))
contrat <- sample(c("mensuel", "annuel"), n_clients, replace = TRUE, prob = c(0.62, 0.38))
rabais <- sample(c("aucun", "fidélité", "rétention"), n_clients, replace = TRUE, prob = c(0.56, 0.32, 0.12))
# Le taux de départ est volontairement assez élevé pour permettre une vraie
# comparaison de seuils en classe, tout en restant minoritaire.
logit_depart <- 2.10 - 0.030 * anciennete - 0.10 * utilisation + 0.55 * tickets -
  0.38 * satisfaction + 1.00 * (contrat == "mensuel") + 0.55 * (rabais == "rétention")
prob_depart <- plogis(logit_depart)

fidelisation_clients <- tibble(
  client_id = sprintf("CL%04d", seq_len(n_clients)),
  anciennete_mois = anciennete,
  utilisation_mensuelle = utilisation,
  tickets_service_6m = tickets,
  satisfaction = satisfaction,
  type_contrat = contrat,
  rabais_actuel = rabais,
  valeur_mensuelle = round(pmax(18, rnorm(n_clients, 72 + 1.3 * utilisation, 18)), 2),
  depart_90j = rbinom(n_clients, 1, prob_depart)
)

write_course_csv(
  fidelisation_clients,
  "modules/semaine-10-classification-modeles-avances/data/fidelisation_clients_quebec.csv"
)

# Atelier 04 : cas intégrateur permettant prévision ou classification.
succursales <- tibble(
  succursale = c("Québec", "Montréal", "Sherbrooke", "Gatineau"),
  capacite = c(2400, 3300, 1850, 2100),
  effet_local = c(8000, 21000, -5000, 2000)
)

cas_integrateur <- tidyr::crossing(date = dates_mensuelles, succursales) |>
  arrange(succursale, date) |>
  group_by(succursale) |>
  mutate(
    indice_temps = row_number(),
    mois = month(date),
    promotion = sample(c("oui", "non"), n(), replace = TRUE, prob = c(0.28, 0.72)),
    achalandage = round(
      capacite * (0.76 + 0.0025 * indice_temps + 0.12 * saison_mois[mois]) +
        if_else(promotion == "oui", 260, 0) + rnorm(n(), 0, 90)
    ),
    ruptures_stock = rpois(n(), pmax(0.5, 0.8 + achalandage / capacite)),
    temps_attente = round(
      pmax(1.5, 3.2 + 4.6 * pmax(achalandage / capacite - 0.78, 0) +
        0.35 * ruptures_stock + rnorm(n(), 0, 0.6)),
      1
    ),
    satisfaction = round(pmin(10, pmax(1, 9.2 - 0.38 * temps_attente + rnorm(n(), 0, 0.5))), 1),
    ventes = round(
      45000 + 66 * achalandage + effet_local +
        if_else(promotion == "oui", 18000, 0) - 2600 * ruptures_stock + rnorm(n(), 0, 6500)
    ),
    taux_utilisation = achalandage / capacite,
    service_insuffisant_mois_suivant = rbinom(
      n(), 1, plogis(
        -3.70 + 0.62 * temps_attente + 0.32 * ruptures_stock -
          0.16 * satisfaction + 0.35 * (promotion == "oui")
      )
    )
  ) |>
  ungroup() |>
  select(
    date, succursale, indice_temps, promotion, capacite, achalandage,
    ruptures_stock, temps_attente, satisfaction, taux_utilisation, ventes,
    service_insuffisant_mois_suivant
  )

write_course_csv(
  cas_integrateur,
  "modules/atelier-04-recapitulation/data/cas_integrateur_quebec.csv"
)
