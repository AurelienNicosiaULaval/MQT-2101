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
destination_module06 <- "modules/semaine-06-series-chronologiques-intro/data/consommation_electrique_batiment_quebec.csv"
dir.create(dirname(destination_module06), recursive = TRUE, showWarnings = FALSE)
write_csv(consommation_module06, destination_module06)
message("Données simulées créées : ", destination_module06)
