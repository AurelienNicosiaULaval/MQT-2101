# Exercices - Module 06

## Préparation

``` r
library(tidyverse)

data_path <- if (file.exists("data/ventes_mensuelles_quebec.csv")) {
  "data/ventes_mensuelles_quebec.csv"
} else {
  "modules/semaine-06-series-chronologiques-intro/data/ventes_mensuelles_quebec.csv"
}

ventes <- read_csv(data_path, show_col_types = FALSE) |>
  mutate(date = as.Date(date)) |>
  arrange(date)
```

## Exercice 1 - Décrire la structure temporelle

Indiquez l’unité d’observation, la fréquence, la période couverte, la cible potentielle et deux vérifications de qualité nécessaires.

> **TIP:**
>
> Chaque ligne représente un mois. La fréquence est mensuelle et la période va de janvier 2020 à décembre 2025. Une cible possible est la vente mensuelle future. Il faut notamment vérifier l’unicité des dates, les valeurs manquantes, les intervalles réguliers et la plausibilité des valeurs.

## Exercice 2 - Visualiser et annoter

Produisez un graphique temporel et ajoutez une ligne verticale au début de 2025.

> **TIP:**
>
> ``` r
> ggplot(ventes, aes(date, ventes)) +
>   geom_line(colour = "#0B4F6C") +
>   geom_vline(xintercept = as.Date("2025-01-01"), linetype = "dashed") +
>   labs(
>     title = "Ventes mensuelles et début de la période test",
>     x = NULL,
>     y = "Ventes"
>   ) +
>   theme_minimal(base_size = 12)
> ```
>
> ![](exercices_files/figure-html/unnamed-chunk-1-1.png)

## Exercice 3 - Comparer deux horizons

Pour chacune des décisions suivantes, proposez une cible et un horizon : planifier le personnel du mois prochain; négocier un contrat d’approvisionnement annuel.

> **TIP:**
>
> Le personnel exige une prévision à court terme, par exemple les ventes ou l’achalandage du prochain mois. Le contrat annuel exige plusieurs mois, idéalement une trajectoire mensuelle ou un total annuel avec incertitude. La même méthode n’est pas automatiquement optimale pour les deux décisions.

## Exercice 4 - Évaluer la prévision naïve

Utilisez les douze derniers mois comme test. Calculez MAE et RMSE pour une prévision égale à la dernière valeur d’entraînement.

> **TIP:**
>
> ``` r
> entrainement <- ventes |> slice_head(n = nrow(ventes) - 12)
> test <- ventes |> slice_tail(n = 12)
> reference <- tail(entrainement$ventes, 1)
>
> test |>
>   mutate(
>     prevision = reference,
>     erreur = ventes - prevision
>   ) |>
>   summarise(
>     MAE = mean(abs(erreur)),
>     RMSE = sqrt(mean(erreur^2))
>   )
> ```
>
>     # A tibble: 1 × 2
>          MAE   RMSE
>        <dbl>  <dbl>
>     1 25351. 31862.

## Exercice de synthèse

Rédigez une recommandation de cinq phrases maximum expliquant si la méthode naïve suffit pour une décision de budget mensuel. Votre réponse doit citer une mesure d’erreur, une caractéristique graphique et une limite.
