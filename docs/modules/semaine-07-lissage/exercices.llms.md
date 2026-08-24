# Exercices - Module 07

## Préparation

Les capsules lissent une demande hebdomadaire. Les exercices utilisent une série mensuelle de ventes et demandent de choisir une méthode pour un budget annuel.

Jeu de données de transfert : [ventes_mensuelles_quebec.csv](../../donnees/#ventes_mensuelles_quebec).

``` r
library(tidyverse)
library(slider)
library(forecast)

data_path <- if (file.exists("../semaine-06-series-chronologiques-intro/data/ventes_mensuelles_quebec.csv")) {
  "../semaine-06-series-chronologiques-intro/data/ventes_mensuelles_quebec.csv"
} else {
  "modules/semaine-06-series-chronologiques-intro/data/ventes_mensuelles_quebec.csv"
}

ventes <- read_csv(
  data_path,
  show_col_types = FALSE
) |>
  mutate(date = as.Date(date)) |>
  arrange(date)
```

## Exercice 1 - Fenêtres de lissage

Comparez des moyennes mobiles arrière de 3 et 12 mois. Repérez le premier mois où les deux lissages donnent des messages nettement différents.

``` r
ventes_lissees <- ventes |>
  mutate(
    moyenne_mobile_3 = slide_dbl(
      ventes,
      mean,
      .before = 2,
      .complete = TRUE
    ),
    moyenne_mobile_12 = slide_dbl(
      ventes,
      mean,
      .before = 11,
      .complete = TRUE
    )
  )

ventes_lissees |>
  select(date, ventes, moyenne_mobile_3, moyenne_mobile_12) |>
  pivot_longer(-date, names_to = "serie", values_to = "valeur") |>
  ggplot(aes(x = date, y = valeur, colour = serie)) +
  geom_line() +
  labs(x = NULL, y = "Ventes", colour = NULL) +
  theme_minimal(base_size = 12)
```

Expliquez quelle fenêtre convient davantage à une réaction rapide et laquelle convient davantage à une lecture budgétaire de long terme.

## Exercice 2 - Lire le paramètre alpha

Réservez les douze derniers mois. Comparez deux lissages exponentiels simples avec des valeurs imposées de 0,2 et 0,8, plutôt que de seulement commenter ces valeurs qualitativement.

``` r
entrainement <- ventes |>
  slice_head(n = nrow(ventes) - 12)

test <- ventes |>
  slice_tail(n = 12)

serie_entrainement <- ts(
  entrainement$ventes,
  frequency = 12,
  start = c(min(entrainement$annee), min(entrainement$mois))
)

prevision_alpha_02 <- ses(
  serie_entrainement,
  h = nrow(test),
  alpha = 0.2,
  initial = "simple"
)

prevision_alpha_08 <- ses(
  serie_entrainement,
  h = nrow(test),
  alpha = 0.8,
  initial = "simple"
)
```

Avant de calculer les erreurs, prédisez laquelle réagira davantage à la dernière année et expliquez le risque correspondant.

## Exercice 3 - Mesures contradictoires

Comparez les deux lissages exponentiels et la dernière valeur observée avec la MAE, la RMSE et le biais.

``` r
predictions <- tibble(
  date = test$date,
  observe = test$ventes,
  alpha_02 = as.numeric(prevision_alpha_02$mean),
  alpha_08 = as.numeric(prevision_alpha_08$mean),
  derniere_valeur = tail(entrainement$ventes, 1)
) |>
  pivot_longer(
    cols = c(alpha_02, alpha_08, derniere_valeur),
    names_to = "methode",
    values_to = "prevision"
  ) |>
  mutate(erreur = observe - prevision)

comparaison <- predictions |>
  group_by(methode) |>
  summarise(
    MAE = mean(abs(erreur)),
    RMSE = sqrt(mean(erreur^2)),
    biais = mean(erreur),
    sous_previsions = sum(erreur > 0),
    .groups = "drop"
  )

comparaison
```

Une sous-prévision budgétaire est considérée deux fois plus coûteuse qu’une sur-prévision de même taille. Expliquez pourquoi la méthode ayant la plus petite MAE n’est pas automatiquement le meilleur choix.

## Exercice de synthèse

Rédigez une recommandation pour la préparation du budget annuel. Citez les trois mesures, le coût asymétrique, la stabilité attendue du lissage et une règle de surveillance mensuelle.
