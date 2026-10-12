# Calculs partagés par les supports du module 6.
# Toutes les comparaisons conservent la même origine et les mêmes observations.
library(tidyverse)
library(forecast)

mesures_erreur <- function(observe, prevision, apprentissage, periode = 1L) {
  stopifnot(length(observe) == length(prevision), length(observe) > 0L,
            !anyNA(observe), !anyNA(prevision),
            !anyNA(apprentissage), length(apprentissage) > periode)
  erreur <- observe - prevision
  echelle <- mean(abs(diff(apprentissage, lag = periode)))
  tibble(
    ME = mean(erreur), MAE = mean(abs(erreur)),
    RMSE = sqrt(mean(erreur^2)),
    MAPE = if (any(observe == 0)) NA_real_ else 100 * mean(abs(erreur / observe)),
    MASE = if (echelle == 0) NA_real_ else mean(abs(erreur)) / echelle
  )
}

prevoir_references <- function(historique, horizon, periode = 12L) {
  stopifnot(length(historique) >= periode, !anyNA(historique), horizon >= 1L)
  tibble(
    h = seq_len(horizon),
    naive = rep(tail(historique, 1), horizon),
    saisonniere = rep(tail(historique, periode), length.out = horizon)
  )
}

# À chaque origine, seul l'historique déjà observé est transmis à la méthode.
validation_mobile <- function(valeurs, debut_validation, horizons = c(1L, 6L),
                              periode = 12L) {
  stopifnot(debut_validation > periode, debut_validation <= length(valeurs),
            !anyNA(valeurs), all(horizons > 0L))
  map_dfr(horizons, function(h) {
    derniere_origine <- length(valeurs) - h
    if (derniere_origine < debut_validation - 1L) return(tibble())
    map_dfr(seq.int(debut_validation - 1L, derniere_origine), function(origine) {
      historique <- valeurs[seq_len(origine)]
      previsions <- prevoir_references(historique, h, periode)
      tibble(origine = origine, h = h, cible = origine + h,
             observe = valeurs[origine + h],
             naive = previsions$naive[h],
             saisonniere = previsions$saisonniere[h])
    })
  }) |>
    pivot_longer(c(naive, saisonniere), names_to = "methode", values_to = "prevision") |>
    mutate(erreur = observe - prevision)
}

charger_module06 <- function(chemin) {
  mois_fr <- c("janvier", "février", "mars", "avril", "mai", "juin",
               "juillet", "août", "septembre", "octobre", "novembre", "décembre")
  electricite <- read_csv(chemin, show_col_types = FALSE) |>
    mutate(date = as.Date(date),
           mois_label = factor(mois_label, levels = mois_fr)) |>
    arrange(date) |>
    mutate(indice = row_number())
  stopifnot(!anyNA(electricite[c("date", "consommation_kwh")]), !anyDuplicated(electricite$date),
            identical(electricite$date, seq.Date(min(electricite$date), max(electricite$date), by = "month")))
  apprentissage <- electricite |> filter(date < as.Date("2025-01-01"))
  validation <- electricite |> filter(date >= as.Date("2025-01-01"))
  serie <- ts(apprentissage$consommation_kwh, start = c(2020, 1), frequency = 12)
  refs <- prevoir_references(apprentissage$consommation_kwh, nrow(validation))
  modele_tendance <- tslm(serie ~ trend + I(trend^2))
  previsions_tendance <- forecast(modele_tendance, h = nrow(validation))
  evaluation <- validation |>
    mutate(naive = refs$naive, saisonniere = refs$saisonniere,
           tendance = as.numeric(previsions_tendance$mean)) |>
    pivot_longer(c(naive, saisonniere, tendance), names_to = "methode", values_to = "prevision") |>
    mutate(erreur = consommation_kwh - prevision)
  comparaison <- evaluation |>
    group_by(methode) |>
    group_modify(~ mesures_erreur(.x$consommation_kwh, .x$prevision, apprentissage$consommation_kwh, 12)) |>
    ungroup()
  mobile <- validation_mobile(electricite$consommation_kwh, nrow(apprentissage) + 1L)
  comparaison_mobile <- mobile |>
    group_by(h, methode) |>
    summarise(n = n(), ME = mean(erreur), MAE = mean(abs(erreur)),
              RMSE = sqrt(mean(erreur^2)), .groups = "drop")
  list(electricite = electricite, apprentissage = apprentissage, validation = validation,
       serie = serie, modele_tendance = modele_tendance,
       evaluation = evaluation, comparaison = comparaison,
       mobile = mobile, comparaison_mobile = comparaison_mobile)
}

nombre_fr <- function(x, decimales = 0L) {
  formatC(x, format = "f", digits = decimales, big.mark = " ", decimal.mark = ",")
}

couleurs_methodes <- c(naive = "#7A1C24", saisonniere = "#0B4F6C", tendance = "#8A6500")

graphique_serie <- function(donnees) {
  ggplot(donnees, aes(date, consommation_kwh / 1000)) +
    geom_line(colour = "#0B4F6C", linewidth = 0.8) +
    geom_point(colour = "#0B4F6C", size = 1.3) +
    labs(x = NULL, y = "Consommation mensuelle (MWh)") +
    theme_minimal(base_size = 17)
}

graphique_validation <- function(analyse) {
  ggplot(analyse$evaluation, aes(date, prevision / 1000, colour = methode)) +
    geom_line(linewidth = 0.8) +
    geom_line(data = analyse$validation, aes(date, consommation_kwh / 1000),
              inherit.aes = FALSE, colour = "black", linewidth = 0.9) +
    scale_colour_manual(values = couleurs_methodes) +
    labs(x = NULL, y = "Consommation (MWh)", colour = "Méthode",
         subtitle = "Noir : observations de 2025; origine fixée à décembre 2024") +
    theme_minimal(base_size = 17)
}
