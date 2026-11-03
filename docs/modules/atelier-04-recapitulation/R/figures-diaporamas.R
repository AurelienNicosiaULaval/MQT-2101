# Régénérer les figures françaises des diapositives.
# Exécuter depuis la racine du dépôt ou du module.
# Calculs conservés depuis demonstrations.qmd.

library(tidyverse)
library(lubridate)

racines <- c(".", "modules/atelier-04-recapitulation")
racine <- racines[file.exists(file.path(racines, "data/cas_integrateur_quebec.csv"))][1]
stopifnot(!is.na(racine))
cas <- read_csv(file.path(racine, "data/cas_integrateur_quebec.csv"), show_col_types = FALSE) |>
  mutate(date = as.Date(date), succursale = factor(succursale),
         promotion = factor(promotion, levels = c("non", "oui")),
         mois = factor(month(date), levels = 1:12)) |> arrange(date, succursale)
stopifnot(nrow(cas) == 288, n_distinct(cas$succursale) == 4,
          !anyDuplicated(cas[c("date", "succursale")]), !anyNA(cas))
cas |> summarise(lignes = n(), debut = min(date), fin = max(date),
                  succursales = n_distinct(succursale), mois = n_distinct(date))

cas |> count(succursale)
cas |> group_by(succursale) |> summarise(mois = n_distinct(date), .groups = "drop")

# Explorer uniquement la période qui précède la validation de 2025.
cas |> filter(date < as.Date("2025-01-01")) |>
  ggplot(aes(date, ventes, colour = succursale)) + geom_line() +
  facet_wrap(~ succursale, scales = "free_y") +
  labs(x = "Mois", y = "Ventes (dollars)", colour = NULL) +
  theme_minimal(base_size = 11) + theme(legend.position = "none")

apprentissage_a <- cas |> filter(date < as.Date("2025-01-01"))
validation_a <- cas |> filter(date >= as.Date("2025-01-01"))
modele_ventes <- lm(ventes ~ indice_temps + succursale + mois, data = apprentissage_a)
reference_a <- apprentissage_a |> filter(year(date) == 2024) |>
  transmute(date = date %m+% years(1), succursale, reference = ventes)
stopifnot(nrow(validation_a) == 48, nrow(reference_a) == 48)
comparaison_a <- validation_a |>
  mutate(regression = as.numeric(predict(modele_ventes, newdata = validation_a))) |>
  left_join(reference_a, by = c("date", "succursale")) |>
  pivot_longer(c(regression, reference), names_to = "methode", values_to = "prevision") |>
  mutate(erreur = ventes - prevision)
stopifnot(!anyNA(comparaison_a$prevision), nrow(comparaison_a) == 96)
scores_a <- comparaison_a |> group_by(methode) |>
  summarise(ME = mean(erreur), MAE = mean(abs(erreur)), RMSE = sqrt(mean(erreur^2)), .groups = "drop")
scores_a

comparaison_a |> group_by(succursale, methode) |>
  summarise(MAE = mean(abs(erreur)), .groups = "drop")

mesures_binaires <- function(observe, prediction) {
  stopifnot(length(observe) == length(prediction), all(observe %in% c(0, 1)),
            all(prediction %in% c(0, 1)))
  vp <- sum(observe == 1 & prediction == 1); fp <- sum(observe == 0 & prediction == 1)
  vn <- sum(observe == 0 & prediction == 0); fn <- sum(observe == 1 & prediction == 0)
  ratio <- function(a, b) if (b == 0) NA_real_ else a / b
  tibble(VP = vp, FP = fp, VN = vn, FN = fn,
         sensibilite = ratio(vp, vp + fn), specificite = ratio(vn, vn + fp),
         precision = ratio(vp, vp + fp), proportion_ciblee = mean(prediction == 1))
}

apprentissage_b <- cas |> filter(date <= as.Date("2023-11-01"))
validation_b <- cas |> filter(date >= as.Date("2024-01-01"), date <= as.Date("2024-11-01"))
evaluation_b <- cas |> filter(date >= as.Date("2025-01-01"))
modele_service <- glm(service_insuffisant_mois_suivant ~ temps_attente + ruptures_stock +
                        satisfaction + taux_utilisation, data = apprentissage_b, family = binomial())
stopifnot(modele_service$converged, all(is.finite(coef(modele_service))))
validation_b <- validation_b |>
  mutate(prob_risque = as.numeric(predict(modele_service, newdata = validation_b, type = "response")))
# Seuil défini sur les scores de 2024, sans utiliser les étiquettes de 2025.
seuil_b <- as.numeric(quantile(validation_b$prob_risque, 0.80))
evaluation_b <- evaluation_b |>
  mutate(prob_risque = as.numeric(predict(modele_service, newdata = evaluation_b, type = "response")),
         prediction = as.integer(prob_risque >= seuil_b))
classe_majoritaire <- as.integer(mean(apprentissage_b$service_insuffisant_mois_suivant) > 0.5)
mesure_b <- mesures_binaires(evaluation_b$service_insuffisant_mois_suivant, evaluation_b$prediction)
reference_b <- mesures_binaires(evaluation_b$service_insuffisant_mois_suivant,
                                 rep(classe_majoritaire, nrow(evaluation_b)))
seuil_b
mesure_b |> select(VP, FP, VN, FN)
mesure_b |> select(sensibilite, specificite, precision, proportion_ciblee)
reference_b |> select(VP, FP, VN, FN, sensibilite, precision)

evaluation_b |> group_by(succursale) |>
  summarise(observations = n(), cibles = sum(prediction),
            taux_cible = mean(prediction), positifs = sum(service_insuffisant_mois_suivant),
            .groups = "drop")

# Figures projetées : mêmes calculs que la démonstration, libellés français.
theme_set(theme_minimal(base_size = 19) + theme(panel.grid.minor = element_blank(), legend.position = "bottom"))
figure_ventes <- scores_a |>
  mutate(methode = recode(methode, reference = "Naïf saisonnier", regression = "Tendance, mois et succursale")) |>
  ggplot(aes(methode, MAE, fill = methode)) + geom_col(width = .6, show.legend = FALSE) +
  scale_fill_manual(values = c("Naïf saisonnier" = "#B33F45", "Tendance, mois et succursale" = "#0B4F6C")) +
  scale_y_continuous(labels = scales::label_number(decimal.mark = ",", big.mark = " ")) +
  labs(x = NULL, y = "Erreur absolue moyenne ($ CA)")
ggsave(file.path(racine, "media/voie-a.png"), figure_ventes, width = 11, height = 4.5, dpi = 160)
repartition <- evaluation_b |> group_by(succursale) |>
  summarise(observations = n(), cibles = sum(prediction), .groups = "drop") |>
  pivot_longer(c(observations, cibles), names_to = "type", values_to = "nombre")
figure_service <- ggplot(repartition, aes(succursale, nombre, fill = type)) +
  geom_col(position = "dodge", width = .7) +
  scale_fill_manual(values = c(observations = "#BFDDE5", cibles = "#0B4F6C"),
                    breaks = c("observations", "cibles"), labels = c("Observations", "Interventions")) +
  scale_y_continuous(breaks = 0:12) +
  labs(x = "Succursale", y = "Nombre de mois", fill = NULL)
ggsave(file.path(racine, "media/voie-b.png"), figure_service, width = 11, height = 4.5, dpi = 160)
stopifnot(nrow(evaluation_b) == 48, sum(evaluation_b$prediction) == 14)
