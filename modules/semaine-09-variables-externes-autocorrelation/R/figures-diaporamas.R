# Régénérer les figures françaises des diapositives.
# Exécuter depuis la racine du dépôt ou du module.
# Calculs conservés depuis demonstrations.qmd.

library(tidyverse)
library(forecast)

racines <- c(".", "modules/semaine-09-variables-externes-autocorrelation")
racine <- racines[file.exists(file.path(racines, "data/ventes_promotions_quebec.csv"))][1]
stopifnot(!is.na(racine))
ventes <- read_csv(file.path(racine, "data/ventes_promotions_quebec.csv"), show_col_types = FALSE) |>
  mutate(date = as.Date(date), promotion = factor(promotion, levels = c("non", "oui")),
         mois = factor(mois, levels = 1:12)) |>
  arrange(date)
stopifnot(nrow(ventes) == 72, !anyDuplicated(ventes$date),
          all(!is.na(ventes)), all(ventes$date == seq.Date(as.Date("2020-01-01"), by = "month", length.out = 72)))
entrainement <- ventes |> slice_head(n = 60)
validation <- ventes |> slice_tail(n = 12)

ventes |> select(date, ventes, promotion, prix_moyen, indice_confiance) |> slice_head(n = 4)

modele_lm <- lm(ventes ~ tendance + promotion + prix_moyen + indice_confiance + mois,
                data = entrainement)
coef(summary(modele_lm))[c("tendance", "promotionoui", "prix_moyen", "indice_confiance"), ]

residus_lm <- residuals(modele_lm)
plot(entrainement$date, residus_lm, type = "l", xlab = "Mois", ylab = "Résidu (dollars)")
abline(h = 0, lty = 2)
acf(residus_lm, lag.max = 12, main = "ACF des résidus")
Box.test(residus_lm, lag = 12, type = "Ljung-Box", fitdf = 0)

formule_x <- ~ tendance + promotion + prix_moyen + indice_confiance + mois
x_train <- model.matrix(formule_x, data = entrainement)[, -1, drop = FALSE]
x_validation <- model.matrix(formule_x, data = validation)[, -1, drop = FALSE]
stopifnot(identical(colnames(x_train), colnames(x_validation)))
modele_ar1 <- Arima(entrainement$ventes, xreg = x_train, order = c(1, 0, 0), include.mean = TRUE)
prevision_ar1 <- forecast(modele_ar1, xreg = x_validation, h = nrow(validation), level = c(80, 95))
comparaison <- validation |>
  transmute(date, observe = ventes, regression = as.numeric(predict(modele_lm, newdata = validation)),
            erreurs_ar1 = as.numeric(prevision_ar1$mean)) |>
  pivot_longer(c(regression, erreurs_ar1), names_to = "methode", values_to = "prevision") |>
  mutate(erreur = observe - prevision)
scores <- comparaison |>
  group_by(methode) |>
  summarise(ME = mean(erreur), MAE = mean(abs(erreur)), RMSE = sqrt(mean(erreur^2)), .groups = "drop")
scores

innovations <- residuals(modele_ar1)
acf(innovations, lag.max = 12, main = "ACF des innovations du modèle AR(1)")
Box.test(innovations, lag = 12, type = "Ljung-Box", fitdf = 1)

comparaison |> ggplot(aes(date, observe)) +
  geom_line(colour = "black") + geom_line(aes(y = prevision, colour = methode)) +
  labs(x = "Mois de 2025", y = "Ventes (dollars)", colour = "Modèle") + theme_minimal()

scenario <- tibble(tendance = 61, mois = factor(1, levels = 1:12),
                   promotion = factor(c("non", "oui"), levels = c("non", "oui")),
                   prix_moyen = 60, indice_confiance = 100)
scenario <- scenario |> mutate(prevision = as.numeric(predict(modele_lm, newdata = scenario)))
scenario

# Figures projetées : mêmes calculs que la démonstration, libellés français.
mois_courts <- c("janv.", "févr.", "mars", "avr.", "mai", "juin", "juill.", "août", "sept.", "oct.", "nov.", "déc.")
dates_fr <- function(x) paste(mois_courts[as.integer(format(x, "%m"))], format(x, "%Y"))
theme_set(theme_minimal(base_size = 19) + theme(panel.grid.minor = element_blank(), legend.position = "bottom"))
autocorrelations <- acf(residus_lm, lag.max = 12, plot = FALSE)
acf_trace <- tibble(retard = as.numeric(autocorrelations$lag), autocorrelation = as.numeric(autocorrelations$acf))
repere <- qnorm(0.975) / sqrt(length(residus_lm))
figure_acf <- ggplot(acf_trace, aes(retard, autocorrelation)) +
  geom_hline(yintercept = 0, colour = "grey55") +
  geom_hline(yintercept = c(-repere, repere), colour = "#0B4F6C", linetype = "dashed") +
  geom_segment(aes(xend = retard, yend = 0), linewidth = 0.8) +
  scale_x_continuous(breaks = seq(0, 12, 2)) +
  scale_y_continuous(labels = scales::label_number(decimal.mark = ",")) +
  labs(x = "Retard (mois)", y = "Autocorrélation des résidus")
# Les deux diagnostics sont présentés dans l’ordre de lecture de la capsule.
figure_temps <- ggplot(entrainement, aes(date, residus_lm / 1000)) +
  geom_hline(yintercept = 0, colour = "grey55") +
  geom_line(colour = "#0B4F6C", linewidth = 0.8) +
  scale_x_date(breaks = as.Date(c("2020-01-01", "2022-01-01", "2024-01-01")), date_labels = "%Y") +
  labs(x = "Année", y = "Résidu (milliers de $ CA)")
diagnostics <- gridExtra::arrangeGrob(
  figure_temps, figure_acf,
  ncol = 2, widths = c(1.05, 1)
)
ggsave(file.path(racine, "media/acf-residus.png"), diagnostics,
       width = 11, height = 4.5, dpi = 160, bg = "white")

# Les scores de la légende sont calculés avec les mêmes séries que les courbes.
ordre <- c("regression", "erreurs_ar1")
scores_ordonnes <- scores[match(ordre, scores$methode), ]
dollars <- scales::label_number(accuracy = 1, big.mark = " ", suffix = " $")
legende <- paste0(c("Régression ordinaire", "Erreurs AR(1)"),
                  "     MAE ", dollars(scores_ordonnes$MAE),
                  "     RMSE ", dollars(scores_ordonnes$RMSE))
figure_comparaison <- ggplot() +
  geom_line(data = validation, aes(date, ventes / 1000), colour = "black", linewidth = 1.15) +
  geom_line(data = comparaison, aes(date, prevision / 1000, colour = methode,
                                    linetype = methode), linewidth = 0.8) +
  scale_colour_manual(values = c(regression = "#0B4F6C", erreurs_ar1 = "#B33F45"),
                      breaks = ordre, labels = legende, name = NULL) +
  scale_linetype_manual(values = c(regression = "solid", erreurs_ar1 = "dashed"),
                        breaks = ordre, labels = legende, name = NULL) +
  guides(colour = guide_legend(ncol = 1), linetype = guide_legend(ncol = 1)) +
  scale_x_date(breaks = validation$date[c(1, 4, 7, 10, 12)], labels = dates_fr) +
  scale_y_continuous(labels = scales::label_number(decimal.mark = ",", big.mark = " ")) +
  labs(x = NULL, y = "Ventes (milliers de $ CA)") +
  theme(legend.text = element_text(size = 16))
ggsave(file.path(racine, "media/comparaison.png"), figure_comparaison,
       width = 11, height = 4.5, dpi = 160, bg = "white")

plages <- entrainement |>
  group_by(promotion) |>
  summarise(minimum = min(prix_moyen), maximum = max(prix_moyen), .groups = "drop")
prix_fr <- scales::label_number(accuracy = 0.01, decimal.mark = ",")
figure_prix <- ggplot(plages, aes(y = promotion)) +
  geom_vline(xintercept = 60, linetype = "dashed", colour = "#B33F45", linewidth = 0.8) +
  geom_segment(aes(x = minimum, xend = maximum, yend = promotion),
               colour = "#0B4F6C", linewidth = 2) +
  geom_text(aes(x = minimum, label = prix_fr(minimum)), hjust = 1.1, size = 6) +
  geom_text(aes(x = maximum, label = prix_fr(maximum)), hjust = -0.1, size = 6) +
  scale_x_continuous(limits = c(51, 65), breaks = seq(52, 64, 2)) +
  scale_y_discrete(limits = c("oui", "non"), labels = c(oui = "Avec promotion", non = "Sans promotion")) +
  labs(x = "Prix par unité ($ CA)", y = NULL, title = "Prix observés pendant l’apprentissage",
       subtitle = "À 60 $, le scénario avec promotion dépasse le maximum observé de 57,86 $.") +
  theme(plot.title = element_text(face = "bold", size = 20),
        plot.subtitle = element_text(size = 17), panel.grid.major.y = element_blank(),
        plot.margin = margin(6, 12, 6, 8))
ggsave(file.path(racine, "media/prix-scenario.png"), figure_prix,
       width = 11, height = 3.1, dpi = 160, bg = "white")
stopifnot(round(coef(modele_lm)["promotionoui"]) == 47566,
          identical(round(scenario$prevision), c(498619, 546185)),
          round(scores$MAE[scores$methode == "regression"]) == 5088,
          round(scores$MAE[scores$methode == "erreurs_ar1"]) == 5380)
