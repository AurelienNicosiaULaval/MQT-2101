# Préparation technique des supports, à partir des calculs publics du socle.
library(tidyverse)
library(broom)
source("R/fonctions-module08.R")
ventes <- read_csv("data/ventes_saisonnieres_quebec.csv", show_col_types = FALSE) |>
  preparer_calendrier()
stopifnot(nrow(ventes) == 72L)
apprentissage <- ventes |> slice_head(n = 60)
validation <- ventes |> slice_tail(n = 12)
# Les prédicteurs futurs sont construits sans les ventes ni le budget de validation.
futur <- calendrier_futur("2025-01-01", horizon = 12, dernier_indice = 60)
serie <- ts(apprentissage$ventes, frequency = 12, start = c(2020, 1))

# La cible, le calendrier et la séparation sont vérifiés avant l’ajustement.
apprentissage |> select(date, indice_temps, mois) |> slice(c(1, 2, 12, 13, 60))
modele_tendance <- lm(ventes ~ indice_temps, data = apprentissage)
modele_saison <- lm(ventes ~ mois, data = apprentissage,
                    contrasts = list(mois = "contr.treatment"))
modele_calendrier <- lm(ventes ~ indice_temps + mois, data = apprentissage,
                        contrasts = list(mois = "contr.treatment"))
modeles <- list(Tendance = modele_tendance, Saison = modele_saison,
                Calendrier = modele_calendrier)
model.matrix(modele_calendrier)[c(1, 2, 12), c(1, 2, 3, 13)]
tidy(modele_calendrier, conf.int = TRUE) |>
  filter(term %in% c("indice_temps", "moisdécembre"))

previsions <- imap_dfr(modeles, function(modele, nom) {
  tibble(date = futur$date, observe = validation$ventes, methode = nom,
         prevision = as.numeric(predict(modele, newdata = futur)))
}) |>
  bind_rows(tibble(date = futur$date, observe = validation$ventes,
                   methode = "Saisonnier_naif", prevision = tail(apprentissage$ventes, 12)))
scores <- previsions |> group_by(methode) |>
  group_modify(~ mesures08(.x$observe, .x$prevision)) |> ungroup() |> arrange(MAE)
scores

diagnostic <- apprentissage |>
  mutate(ajuste = fitted(modele_calendrier), residu = residuals(modele_calendrier))

residus_mensuels <- imap_dfr(modeles, function(modele, nom) {
  tibble(mois = apprentissage$mois, residu = residuals(modele), methode = nom)
}) |>
  group_by(methode, mois) |> summarise(residu_moyen = mean(residu), .groups = "drop")

ip <- predict(modele_calendrier, newdata = futur, interval = "prediction", level = 0.95)
ic <- predict(modele_calendrier, newdata = futur, interval = "confidence", level = 0.95)
previsions_intervalle <- futur |>
  select(date, indice_temps, mois) |>
  bind_cols(as_tibble(ip)) |>
  mutate(observe = validation$ventes, budget_cible = validation$budget_cible,
         ic_inf = ic[, "lwr"], ic_sup = ic[, "upr"],
         dans_intervalle = observe >= lwr & observe <= upr)

fr <- function(x, digits = 0) formatC(x, format = "f", digits = digits,
                                     big.mark = " ", decimal.mark = ",")
theme_set(theme_minimal(base_size = 18) +
          theme(panel.grid.minor = element_blank(), legend.position = "bottom"))

# Libellés français indépendants de la langue du système.
dates_fr <- function(x) {
  mois_courts <- c("janv.", "févr.", "mars", "avr.", "mai", "juin",
                   "juill.", "août", "sept.", "oct.", "nov.", "déc.")
  paste(mois_courts[as.integer(format(x, "%m"))], format(x, "%Y"))
}
