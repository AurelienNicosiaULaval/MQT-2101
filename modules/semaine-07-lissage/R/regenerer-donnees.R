# Reproduit les deux CSV du module 07 depuis le projet téléchargé.
# Les tirages de ventes mensuelles, non exportées, préservent la suite aléatoire
# du script 10 original avant la génération de la demande.
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

# Base historique de simulation conservée pour le module 08.
# Le module 06 utilise désormais sa propre série d’électricité (script 24).
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

write_course_csv(demande_hebdomadaire, "data/demande_hebdomadaire_quebec.csv")
# Série mensuelle entièrement simulée pour le cas guidé du module 6.
# Hypothèses pédagogiques, sans mesure d'un bâtiment ou d'un fournisseur réel.
library(tidyverse)
library(lubridate)

creer_consommation_module06 <- function() {
  # Préserver l'état aléatoire pour pouvoir appeler ce script depuis le script 10.
  graine_presente <- exists(".Random.seed", envir = .GlobalEnv, inherits = FALSE)
  if (graine_presente) graine_avant <- get(".Random.seed", envir = .GlobalEnv)
  on.exit({
    if (graine_presente) assign(".Random.seed", graine_avant, envir = .GlobalEnv)
    else if (exists(".Random.seed", envir = .GlobalEnv, inherits = FALSE))
      rm(".Random.seed", envir = .GlobalEnv)
  })
  set.seed(210106)
  mois_fr <- c("janvier", "février", "mars", "avril", "mai", "juin",
               "juillet", "août", "septembre", "octobre", "novembre", "décembre")
  dates <- seq.Date(as.Date("2020-01-01"), as.Date("2025-12-01"), by = "month")
  rang <- seq_along(dates)
  mois <- month(dates)
  jours <- as.integer(days_in_month(dates))
  # Niveau quotidien hypothétique, légère tendance et motif annuel imposé.
  # La composante hivernale domine; un petit supplément estival est simulé.
  niveau_quotidien <- 4500 + 10 * rang + 1900 * cos(2 * pi * (mois - 1) / 12) +
    500 * pmax(0, cos(2 * pi * (mois - 7) / 12))
  tibble(
    date = dates, annee = year(dates), mois = mois,
    mois_label = mois_fr[mois], trimestre = paste0("T", quarter(dates)),
    jours_mois = jours,
    consommation_kwh = as.integer(round(jours * niveau_quotidien + rnorm(72, 0, 5000)))
  )
}

consommation_module06 <- creer_consommation_module06()
stopifnot(nrow(consommation_module06) == 72L,
          !anyNA(consommation_module06),
          all(consommation_module06$consommation_kwh > 0))
destination_module06 <- "data/consommation_electrique_batiment_quebec.csv"
dir.create(dirname(destination_module06), recursive = TRUE, showWarnings = FALSE)
write_csv(consommation_module06, destination_module06)
message("Données simulées créées : ", destination_module06)
