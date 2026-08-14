# Exercices - Module 08

## Préparation

``` r
library(tidyverse)
library(broom)

data_path <- if (file.exists("data/ventes_saisonnieres_quebec.csv")) {
  "data/ventes_saisonnieres_quebec.csv"
} else {
  "modules/semaine-08-tendance-saisonnalite/data/ventes_saisonnieres_quebec.csv"
}

ventes <- read_csv(data_path, show_col_types = FALSE) |>
  mutate(date = as.Date(date), mois_label = factor(mois_label)) |>
  arrange(date)
```

## Exercice 1 - Isoler la tendance

Ajustez `ventes ~ indice_temps` sans mois. Examinez les résidus dans le temps et décrivez le motif manquant.

> **TIP:**
>
> ``` r
> modele_tendance <- lm(ventes ~ indice_temps, data = ventes)
>
> augment(modele_tendance, data = ventes) |>
>   ggplot(aes(date, .resid)) +
>   geom_hline(yintercept = 0, linetype = "dashed") +
>   geom_line(colour = "#0B4F6C") +
>   theme_minimal(base_size = 12)
> ```
>
> ![](exercices_files/figure-html/unnamed-chunk-2-1.png)
>
> Un motif récurrent selon les mois indique que la tendance seule est insuffisante.

## Exercice 2 - Interpréter une saison

Fixez janvier comme référence, ajustez tendance et mois, puis interprétez les coefficients de juillet et décembre.

> **TIP:**
>
> ``` r
> ventes <- ventes |>
>   mutate(mois_label = relevel(factor(mois_label), ref = "janvier"))
>
> modele_saisonnier <- lm(ventes ~ indice_temps + mois_label, data = ventes)
> tidy(modele_saisonnier) |>
>   filter(term %in% c("mois_labeljuillet", "mois_labeldécembre"))
> ```
>
>     # A tibble: 2 × 5
>       term               estimate std.error statistic       p.value
>       <chr>                 <dbl>     <dbl>     <dbl>         <dbl>
>     1 mois_labeldécembre   38121.     5563.      6.85 0.00000000480
>     2 mois_labeljuillet    -7710.     5540.     -1.39 0.169
>
> Chaque coefficient est une différence moyenne avec janvier, à indice de temps égal.

## Exercice 3 - Tester le modèle

Réservez les douze derniers mois, calculez MAE et taux de couverture de l’intervalle de prédiction à 95 %.

> **TIP:**
>
> ``` r
> entrainement <- ventes |> slice_head(n = nrow(ventes) - 12)
> test <- ventes |> slice_tail(n = 12)
> modele <- lm(ventes ~ indice_temps + mois_label, data = entrainement)
> pred <- as_tibble(predict(modele, newdata = test, interval = "prediction")) |>
>   bind_cols(test |> select(ventes))
>
> pred |>
>   summarise(
>     MAE = mean(abs(ventes - fit)),
>     couverture = mean(ventes >= lwr & ventes <= upr)
>   )
> ```
>
>     # A tibble: 1 × 2
>         MAE couverture
>       <dbl>      <dbl>
>     1 9891.          1

## Exercice de synthèse

Comparez les prévisions au `budget_cible`. Indiquez les mois où le budget semble le plus risqué et proposez une règle de révision mensuelle.
