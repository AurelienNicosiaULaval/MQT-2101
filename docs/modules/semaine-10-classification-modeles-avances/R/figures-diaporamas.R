# Régénérer les figures françaises des diapositives.
# Exécuter depuis la racine du dépôt ou du module.
# Calculs conservés depuis demonstrations.qmd.

library(tidyverse)

racines <- c(".", "modules/semaine-10-classification-modeles-avances")
racine <- racines[file.exists(file.path(racines, "data/fidelisation_clients_quebec.csv"))][1]
stopifnot(!is.na(racine))
clients <- read_csv(file.path(racine, "data/fidelisation_clients_quebec.csv"), show_col_types = FALSE) |>
  mutate(type_contrat = factor(type_contrat, levels = c("annuel", "mensuel")),
         rabais_actuel = factor(rabais_actuel, levels = c("aucun", "fidélité", "rétention")))
stopifnot(nrow(clients) == 650, !anyDuplicated(clients$client_id),
          !anyNA(clients), all(clients$depart_90j %in% c(0, 1)))
set.seed(210110)
clients <- clients |> group_by(depart_90j) |>
  mutate(tirage = sample.int(n()),
         partition = case_when(tirage <= floor(0.60 * n()) ~ "apprentissage",
                               tirage <= floor(0.80 * n()) ~ "validation",
                               TRUE ~ "test")) |> ungroup()
apprentissage <- clients |> filter(partition == "apprentissage")
validation <- clients |> filter(partition == "validation")
test <- clients |> filter(partition == "test")
stopifnot(length(intersect(apprentissage$client_id, validation$client_id)) == 0,
          length(intersect(apprentissage$client_id, test$client_id)) == 0,
          length(intersect(validation$client_id, test$client_id)) == 0)
clients |> count(partition, depart_90j)

modele <- glm(depart_90j ~ anciennete_mois + utilisation_mensuelle + tickets_service_6m +
                satisfaction + type_contrat + rabais_actuel,
              data = apprentissage, family = binomial())
stopifnot(modele$converged, all(is.finite(coef(modele))))
exp(coef(modele))
profils <- tibble(anciennete_mois = c(24, 24), utilisation_mensuelle = c(12, 12),
                  tickets_service_6m = c(1, 3), satisfaction = c(7, 7),
                  type_contrat = factor(c("mensuel", "mensuel"), levels = levels(clients$type_contrat)),
                  rabais_actuel = factor(c("aucun", "aucun"), levels = levels(clients$rabais_actuel)))
profils |> mutate(probabilite = predict(modele, newdata = profils, type = "response")) |>
  select(tickets_service_6m, probabilite)

mesures_seuil <- function(observe, probabilite, seuil, cout_fp = 1, cout_fn = 4) {
  stopifnot(length(observe) == length(probabilite), all(observe %in% c(0, 1)),
            all(is.finite(probabilite)), all(probabilite >= 0 & probabilite <= 1))
  predit <- as.integer(probabilite >= seuil)
  vp <- sum(predit == 1 & observe == 1); fp <- sum(predit == 1 & observe == 0)
  vn <- sum(predit == 0 & observe == 0); fn <- sum(predit == 0 & observe == 1)
  ratio <- function(a, b) if (b == 0) NA_real_ else a / b
  tibble(seuil, VP = vp, FP = fp, VN = vn, FN = fn,
         exactitude = ratio(vp + vn, length(observe)), sensibilite = ratio(vp, vp + fn),
         specificite = ratio(vn, vn + fp), precision = ratio(vp, vp + fp),
         proportion_ciblee = ratio(vp + fp, length(observe)), cout = cout_fp * fp + cout_fn * fn)
}

validation <- validation |> mutate(probabilite = predict(modele, newdata = validation, type = "response"))
resultats_validation <- bind_rows(mesures_seuil(validation$depart_90j, validation$probabilite, 0.30),
                                 mesures_seuil(validation$depart_90j, validation$probabilite, 0.50))
resultats_validation |> select(seuil, VP, FP, VN, FN, cout)
resultats_validation |> select(seuil, sensibilite, specificite, precision, proportion_ciblee)
seuil_retenu <- resultats_validation |> arrange(cout, seuil) |> slice(1) |> pull(seuil)
seuil_retenu

test <- test |> mutate(probabilite = predict(modele, newdata = test, type = "response"))
resultat_test <- mesures_seuil(test$depart_90j, test$probabilite, seuil_retenu)
resultat_test |> select(seuil, VP, FP, VN, FN, cout)
resultat_test |> select(seuil, sensibilite, specificite, precision, proportion_ciblee)
# Référence : toujours prédire la classe majoritaire de l’apprentissage.
# Une égalité est départagée en faveur de la classe 0.
classe_majoritaire <- as.integer(mean(apprentissage$depart_90j) > 0.5)
seuil_reference <- if (classe_majoritaire == 1) 0 else 1.01
reference <- mesures_seuil(test$depart_90j, test$probabilite, seuil_reference)
reference |> select(VP, FP, VN, FN, exactitude, sensibilite, precision)
calibration <- test |> mutate(groupe = ntile(probabilite, 5)) |> group_by(groupe) |>
  summarise(n = n(), probabilite_moyenne = mean(probabilite),
            frequence_depart = mean(depart_90j), .groups = "drop")
calibration
brier <- mean((test$probabilite - test$depart_90j)^2)
brier
# Règle alternative fixée à l’avance : au plus 15 % des clients test.
# En cas d’égalité de probabilités, trier selon client_id.
n_capacite <- floor(0.15 * nrow(test))
selection <- test |> arrange(desc(probabilite), client_id) |> slice_head(n = n_capacite)
tibble(clients = nrow(test), cibles = nrow(selection),
       departs_detectes = sum(selection$depart_90j), precision = mean(selection$depart_90j))

# Figures projetées : mêmes calculs que la démonstration, libellés français.
theme_set(theme_minimal(base_size = 19) + theme(panel.grid.minor = element_blank()))
logistique <- tibble(score = seq(-6, 6, length.out = 301), probabilite = plogis(score))
figure_logistique <- ggplot(logistique, aes(score, probabilite)) +
  geom_line(colour = "#0B4F6C", linewidth = 1.1) +
  scale_y_continuous(breaks = seq(0, 1, .25), labels = scales::label_number(decimal.mark = ",")) +
  labs(x = "Score linéaire du modèle", y = "Probabilité de départ")
ggsave(file.path(racine, "media/courbe-logistique.png"), figure_logistique, width = 11, height = 4.5, dpi = 160)
figure_calibration <- ggplot(calibration, aes(probabilite_moyenne, frequence_depart)) +
  geom_abline(slope = 1, intercept = 0, colour = "grey55", linetype = "dashed") +
  geom_line(colour = "#0B4F6C") + geom_point(size = 3, colour = "#0B4F6C") +
  scale_x_continuous(limits = c(0, 1), breaks = seq(0, 1, .25), labels = scales::label_number(decimal.mark = ",")) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, .25), labels = scales::label_number(decimal.mark = ",")) +
  labs(x = "Probabilité moyenne prédite", y = "Fréquence de départ observée")
ggsave(file.path(racine, "media/calibration.png"), figure_calibration, width = 11, height = 4.5, dpi = 160)
stopifnot(seuil_retenu == .30, resultat_test$VP == 22, resultat_test$FP == 28,
          resultat_test$VN == 63, resultat_test$FN == 18)
