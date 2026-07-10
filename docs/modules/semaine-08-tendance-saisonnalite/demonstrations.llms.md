# Démonstrations R - Module 08

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
  mutate(
    date = as.Date(date),
    mois_label = factor(
      mois_label,
      levels = c("janvier", "février", "mars", "avril", "mai", "juin",
                 "juillet", "août", "septembre", "octobre", "novembre", "décembre")
    )
  ) |>
  arrange(date)
```

## 1. Visualiser les deux structures

``` r
ggplot(ventes, aes(date, ventes)) +
  geom_line(colour = "#0B4F6C") +
  labs(title = "Ventes mensuelles avec tendance et saisonnalité", x = NULL, y = "Ventes") +
  theme_minimal(base_size = 12)
```

![](demonstrations_files/figure-html/unnamed-chunk-1-1.png)

``` r
ggplot(ventes, aes(mois_label, ventes)) +
  geom_boxplot(fill = "#D9EEF2", colour = "#0B4F6C") +
  labs(title = "Ventes selon le mois", x = NULL, y = "Ventes") +
  theme_minimal(base_size = 12) +
  theme(axis.text.x = element_text(angle = 35, hjust = 1))
```

![](demonstrations_files/figure-html/unnamed-chunk-2-1.png)

## 2. Créer entraînement et test

``` r
entrainement <- ventes |> slice_head(n = nrow(ventes) - 12)
test <- ventes |> slice_tail(n = 12)
```

## 3. Ajuster la tendance saisonnière

``` r
modele <- lm(ventes ~ indice_temps + mois_label, data = entrainement)

tidy(modele, conf.int = TRUE) |>
  filter(term %in% c("indice_temps", "mois_labeldécembre"))
```

    # A tibble: 2 × 7
      term               estimate std.error statistic  p.value conf.low conf.high
      <chr>                 <dbl>     <dbl>     <dbl>    <dbl>    <dbl>     <dbl>
    1 indice_temps          2884.      71.9     40.1  5.03e-38    2740.     3029.
    2 mois_labeldécembre   32705.    6026.       5.43 1.96e- 6   20582.    44829.

## 4. Prévoir la période test

``` r
saison_naive <- entrainement |>
  slice_tail(n = 12) |>
  pull(ventes)

predictions <- predict(modele, newdata = test, interval = "prediction") |>
  as_tibble() |>
  bind_cols(test |> select(date, ventes)) |>
  mutate(
    erreur = ventes - fit,
    erreur_saison_naive = ventes - saison_naive
  )

predictions |>
  summarise(
    MAE_modele = mean(abs(erreur)),
    RMSE_modele = sqrt(mean(erreur^2)),
    MAE_saison_naive = mean(abs(erreur_saison_naive))
  )
```

    # A tibble: 1 × 3
      MAE_modele RMSE_modele MAE_saison_naive
           <dbl>       <dbl>            <dbl>
    1      9891.      11280.           29067.

## 5. Représenter l’incertitude

``` r
ggplot(predictions, aes(date)) +
  geom_ribbon(aes(ymin = lwr, ymax = upr), fill = "#BFDDE5", alpha = 0.6) +
  geom_line(aes(y = fit), colour = "#0B4F6C", linewidth = 1) +
  geom_point(aes(y = ventes), colour = "black") +
  labs(
    title = "Prévisions et observations de la période test",
    subtitle = "Ruban : intervalle de prédiction à 95 %",
    x = NULL,
    y = "Ventes"
  ) +
  theme_minimal(base_size = 12)
```

![](demonstrations_files/figure-html/unnamed-chunk-6-1.png)

## Interprétation

Le modèle doit être retenu seulement si sa performance test et ses diagnostics sont acceptables. L’intervalle rappelle qu’une prévision budgétaire est une plage de résultats possibles, pas une promesse.
