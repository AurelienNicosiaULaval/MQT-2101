# Préparation technique des diapositives, à partir des blocs publics du module.
# Exécuter depuis la racine du projet téléchargé ou du module.
library(tidyverse)
library(slider)
library(forecast)

# Ouvrir le projet .Rproj fourni : R/ et data/ sont à côté du rapport.
source("R/fonctions-module07.R")
demande <- read_csv("data/demande_hebdomadaire_quebec.csv",
                    show_col_types = FALSE) |>
  mutate(semaine = as.Date(semaine)) |>
  arrange(semaine)
stopifnot(nrow(demande) == 104L, !anyNA(demande),
          !anyDuplicated(demande$semaine),
          all(diff(demande$semaine) == 7))
horizon <- 13L
apprentissage <- demande |> slice_head(n = 91)
validation <- demande |> slice_tail(n = horizon)
serie <- ts(apprentissage$demande, frequency = 52)

exemple <- tibble(observe = c(100, 100, 140, 140),
                  alpha_02 = niveau_ses(observe, 0.2),
                  alpha_08 = niveau_ses(observe, 0.8))
exemple
niveaux <- apprentissage |>
  mutate(alpha_02 = niveau_ses(demande, 0.2),
         alpha_08 = niveau_ses(demande, 0.8))

modele_ses <- ses(serie, h = horizon, initial = "optimal")
# Règles fixées avant de consulter les scores : origine unique, h = 1 à 13.
# MM4 : répéter la dernière moyenne observée, sans mise à jour future.
previsions <- tibble(
  semaine = validation$semaine,
  observe = validation$demande,
  Naive = rep(tail(apprentissage$demande, 1), horizon),
  MM4 = rep(mean(tail(apprentissage$demande, 4)), horizon),
  SES = as.numeric(modele_ses$mean),
  Saisonnier = as.numeric(snaive(serie, h = horizon)$mean)
)
erreurs <- previsions |>
  pivot_longer(Naive:Saisonnier, names_to = "methode", values_to = "prevision") |>
  mutate(erreur = observe - prevision)
scores <- erreurs |>
  group_by(methode) |>
  group_modify(~ mesures_erreurs(.x$observe, .x$prevision)) |>
  ungroup() |>
  arrange(MAE)

library(tidyverse)
library(slider)
library(forecast)

# Ouvrir le projet .Rproj fourni : R/ et data/ sont à côté du rapport.
source("R/fonctions-module07.R")
electricite <- read_csv("data/consommation_electrique_batiment_quebec.csv",
                        show_col_types = FALSE) |>
  mutate(date = as.Date(date)) |>
  arrange(date)
stopifnot(nrow(electricite) == 72L, !anyNA(electricite),
          !anyDuplicated(electricite$date),
          identical(electricite$date,
                    seq.Date(as.Date("2020-01-01"), by = "month", length.out = 72)))
horizon_e <- 12L
apprentissage_e <- electricite |> slice_head(n = 60)
validation_e <- electricite |> slice_tail(n = horizon_e)
serie_e <- ts(apprentissage_e$consommation_kwh, frequency = 12,
              start = c(2020, 1))

niveaux_e <- apprentissage_e |>
  mutate(alpha_02 = niveau_ses(consommation_kwh, 0.2),
         alpha_08 = niveau_ses(consommation_kwh, 0.8))
niveaux_e |> select(date, consommation_kwh, alpha_02, alpha_08) |> tail(4)
previsions_e <- tibble(
  date = validation_e$date,
  observe = validation_e$consommation_kwh,
  Naive = rep(tail(apprentissage_e$consommation_kwh, 1), horizon_e),
  MM3 = rep(mean(tail(apprentissage_e$consommation_kwh, 3)), horizon_e),
  SES02 = rep(tail(niveaux_e$alpha_02, 1), horizon_e),
  SES08 = rep(tail(niveaux_e$alpha_08, 1), horizon_e),
  Saisonnier = as.numeric(snaive(serie_e, h = horizon_e)$mean)
)

erreurs_e <- previsions_e |>
  pivot_longer(Naive:Saisonnier, names_to = "methode", values_to = "prevision") |>
  mutate(erreur = observe - prevision)
scores_e <- erreurs_e |>
  group_by(methode) |>
  group_modify(~ mesures_erreurs(.x$observe, .x$prevision,
                                cout_sous = 2, cout_sur = 1)) |>
  ungroup()

lissage <- apprentissage |>
  mutate(mm4 = slide_dbl(demande, mean, .before = 3, .complete = TRUE),
         mm13 = slide_dbl(demande, mean, .before = 12, .complete = TRUE))
modele_holt <- holt(serie, h = horizon, damped = TRUE)
fr <- function(x, digits = 1) formatC(x, digits = digits, format = "f",
                                     big.mark = " ", decimal.mark = ",")
theme_set(theme_minimal(base_size = 18) +
            theme(panel.grid.minor = element_blank(), legend.position = "bottom"))
