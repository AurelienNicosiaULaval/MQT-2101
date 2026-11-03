# Fonctions fournies pour le module 08. Données entièrement simulées.
library(tidyverse)
library(broom)
mois_fr <- c("janvier", "février", "mars", "avril", "mai", "juin",
             "juillet", "août", "septembre", "octobre", "novembre", "décembre")

preparer_calendrier <- function(donnees) {
  donnees <- donnees |> mutate(date = as.Date(date)) |> arrange(date)
  stopifnot(!anyNA(donnees[c("date", "ventes")]),
            !anyDuplicated(donnees$date), all(donnees$ventes > 0),
            identical(donnees$date, seq.Date(min(donnees$date), by = "month",
                                            length.out = nrow(donnees))))
  donnees <- donnees |>
    mutate(indice_temps = row_number(),
           mois = factor(lubridate::month(date), levels = 1:12, labels = mois_fr),
           sinus = sin(2 * base::pi * indice_temps / 12),
           cosinus = cos(2 * base::pi * indice_temps / 12))
  # Un facteur non ordonné avec les contrastes de traitement, janvier comme référence.
  donnees
}

calendrier_futur <- function(debut, horizon, dernier_indice) {
  dates <- seq.Date(as.Date(debut), by = "month", length.out = horizon)
  resultat <- tibble(date = dates, indice_temps = dernier_indice + seq_len(horizon),
                     mois = factor(lubridate::month(dates), levels = 1:12, labels = mois_fr)) |>
    mutate(sinus = sin(2 * base::pi * indice_temps / 12),
           cosinus = cos(2 * base::pi * indice_temps / 12))
  resultat
}

# Prévisions ponctuelles comparées sur l’échelle originale, en dollars canadiens.
prevoir_original <- function(modele, futur, logarithme = FALSE) {
  eta <- as.numeric(predict(modele, newdata = futur))
  if (logarithme) exp(eta + sigma(modele)^2 / 2) else eta
}

mesures08 <- function(observe, prevision) {
  stopifnot(length(observe) == length(prevision), length(observe) > 0,
            all(is.finite(observe)), all(is.finite(prevision)))
  e <- observe - prevision
  tibble(ME = mean(e), MAE = mean(abs(e)), RMSE = sqrt(mean(e^2)))
}
