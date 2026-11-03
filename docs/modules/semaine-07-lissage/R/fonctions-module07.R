# Fonctions du module 07. Les données sont simulées pour l’enseignement.
library(tidyverse)
library(slider)
library(forecast)

# Initialisation explicite : le premier niveau est la première observation.
niveau_ses <- function(y, alpha) {
  stopifnot(length(y) > 0, !anyNA(y), all(is.finite(y)),
            length(alpha) == 1, alpha > 0, alpha < 1)
  niveau <- numeric(length(y))
  niveau[1] <- y[1]
  if (length(y) > 1) {
    for (t in 2:length(y)) {
      niveau[t] <- alpha * y[t] + (1 - alpha) * niveau[t - 1]
    }
  }
  niveau
}

# Convention commune : erreur = observation - prévision.
# Le coût est un scénario pédagogique, dans une unité de coût fictive.
mesures_erreurs <- function(observe, prevision, cout_sous = 1, cout_sur = 1) {
  stopifnot(length(observe) == length(prevision), length(observe) > 0,
            all(is.finite(observe)), all(is.finite(prevision)),
            cout_sous >= 0, cout_sur >= 0)
  erreur <- observe - prevision
  tibble(ME = mean(erreur), MAE = mean(abs(erreur)),
         RMSE = sqrt(mean(erreur^2)),
         cout_moyen = mean(cout_sous * pmax(erreur, 0) +
                             cout_sur * pmax(-erreur, 0)),
         sous_previsions = sum(erreur > 0))
}
