# Aide après une tentative : exemple distinct du module 04.
# Ouvrir laboratoire-02.Rproj, puis exécuter tout ce script.
# Ce script n'analyse pas les données de votre mission.
# Dépendance : tidyverse déjà utilisé dans le cours.
library(tidyverse)

# Importer et vérifier les données de l'exemple.
chemin <- "data/achalandage_saturation_quebec.csv"
if (!file.exists(chemin)) stop("Ouvrez le projet décompressé et vérifiez le dossier data/.")
saturation <- read_csv(chemin, show_col_types = FALSE) |>
  mutate(mois = as.Date(mois), achalandage_milliers = achalandage / 1000)
print(saturation |> summarise(n = n(), debut = min(mois), fin = max(mois),
                              succursales = n_distinct(succursale)))
print(colSums(is.na(saturation)))
print(saturation |> count(succursale, mois) |> filter(n > 1))
stopifnot(!anyNA(saturation[c("ventes", "achalandage_milliers")]),
          all(saturation$achalandage_milliers > 0))

# Ajuster sur les mêmes observations; les ventes restent en dollars.
modele_reference <- lm(ventes ~ achalandage_milliers, data = saturation)
modele_variante <- lm(ventes ~ achalandage_milliers + I(achalandage_milliers^2),
                      data = saturation)
stopifnot(identical(rownames(model.frame(modele_reference)),
                    rownames(model.frame(modele_variante))))
print(coef(modele_reference))
print(summary(modele_reference)$r.squared)
# 100 visites = 0,1 millier : variation moyenne estimée par la droite.
print(unname(coef(modele_reference)["achalandage_milliers"] * 0.1))

# Comparer l'ajustement, sans prétendre à une validation future.
comparaison <- tibble(
  modele = c("Droite", "Quadratique"),
  n = c(nobs(modele_reference), nobs(modele_variante)),
  r2_ajuste = c(summary(modele_reference)$adj.r.squared,
                summary(modele_variante)$adj.r.squared),
  rmse_ajustement_dollars = c(sqrt(mean(residuals(modele_reference)^2)),
                            sqrt(mean(residuals(modele_variante)^2)))
)
print(comparaison)

# Tracer dans la plage observée uniquement.
plage <- range(saturation$achalandage_milliers)
grille <- tibble(achalandage_milliers = seq(plage[1], plage[2], length.out = 100))
courbes <- grille |>
  mutate(Droite = predict(modele_reference, newdata = grille),
         Quadratique = predict(modele_variante, newdata = grille)) |>
  pivot_longer(c(Droite, Quadratique), names_to = "modele", values_to = "ventes_estimees")
graphique_relation <- ggplot(saturation, aes(achalandage_milliers, ventes)) +
  geom_point(aes(colour = succursale), alpha = 0.7) +
  geom_line(data = courbes, aes(y = ventes_estimees, linetype = modele), linewidth = 0.9) +
  labs(title = "Exemple du module 04 : comparer deux ajustements",
       x = "Achalandage mensuel (milliers de visites)", y = "Ventes mensuelles ($ CA)",
       colour = "Succursale", linetype = "Modèle") + theme_minimal()
print(graphique_relation)

# Interpréter une courbe par deux prédictions, pas par une pente constante.
scenarios <- tibble(achalandage_milliers = as.numeric(
  quantile(saturation$achalandage_milliers, c(0.25, 0.75))))
scenarios <- scenarios |>
  mutate(ventes_estimees = predict(modele_variante, newdata = scenarios))
print(scenarios)
print(diff(scenarios$ventes_estimees))

# Examiner les résidus de la variante, sans imposer son choix final.
diagnostic <- saturation |>
  mutate(valeur_ajustee = fitted(modele_variante), residu = residuals(modele_variante))
graphique_residus <- ggplot(diagnostic, aes(valeur_ajustee, residu, colour = succursale)) +
  geom_hline(yintercept = 0, linetype = "dashed") + geom_point(alpha = 0.8) +
  labs(title = "Exemple du module 04 : résidus de la quadratique",
       x = "Ventes ajustées ($ CA)", y = "Résidu ($ CA)", colour = "Succursale") +
  theme_minimal()
print(graphique_residus)

# La comparaison utilise toutes les données de cet exemple pour l'ajustement.
# Elle diffère de la validation sur les derniers mois montrée au module 04.
# Revenir ensuite à votre mission : vos choix, votre code et votre conclusion.
