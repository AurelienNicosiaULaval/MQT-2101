# Démonstrations R - Module 06

## Préparation

``` r
library(tidyverse)
library(lubridate)

data_path <- if (file.exists("data/ventes_mensuelles_quebec.csv")) {
  "data/ventes_mensuelles_quebec.csv"
} else {
  "modules/semaine-06-series-chronologiques-intro/data/ventes_mensuelles_quebec.csv"
}

ventes <- read_csv(data_path, show_col_types = FALSE) |>
  mutate(date = as.Date(date)) |>
  arrange(date)
```

## 1. Vérifier l’index temporel

``` r
glimpse(ventes)
```

    Rows: 72
    Columns: 8
    $ date            <date> 2020-01-01, 2020-02-01, 2020-03-01, 2020-04-01, 2020-…
    $ annee           <dbl> 2020, 2020, 2020, 2020, 2020, 2020, 2020, 2020, 2020, …
    $ mois            <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2, 3, 4, 5, …
    $ mois_label      <chr> "janvier", "février", "mars", "avril", "mai", "juin", …
    $ trimestre       <chr> "T1", "T1", "T1", "T2", "T2", "T2", "T3", "T3", "T3", …
    $ jours_ouverture <dbl> 27, 25, 26, 24, 27, 27, 27, 27, 26, 25, 24, 27, 27, 27…
    $ clients         <dbl> 3976, 3939, 4024, 4222, 4363, 4395, 4382, 4244, 4309, …
    $ ventes          <dbl> 273932, 283964, 282626, 307251, 296563, 296514, 308563…

``` r
ventes |>
  summarise(
    debut = min(date),
    fin = max(date),
    observations = n(),
    dates_distinctes = n_distinct(date),
    valeurs_manquantes = sum(is.na(ventes))
  )
```

    # A tibble: 1 × 5
      debut      fin        observations dates_distinctes valeurs_manquantes
      <date>     <date>            <int>            <int>              <int>
    1 2020-01-01 2025-12-01           72               72                  0

La fréquence mensuelle doit être confirmée par les dates, pas seulement par le nom du fichier.

## 2. Construire le graphique temporel

``` r
ggplot(ventes, aes(x = date, y = ventes)) +
  geom_line(colour = "#0B4F6C", linewidth = 0.8) +
  geom_point(colour = "#0B4F6C", size = 1.4) +
  scale_y_continuous(labels = scales::label_dollar(suffix = " $", prefix = "")) +
  labs(
    title = "Ventes mensuelles fictives",
    subtitle = "Données simulées, janvier 2020 à décembre 2025",
    x = NULL,
    y = "Ventes"
  ) +
  theme_minimal(base_size = 12)
```

![](demonstrations_files/figure-html/unnamed-chunk-2-1.png)

## 3. Examiner les mois comparables

``` r
ventes |>
  ggplot(aes(x = mois_label, y = ventes)) +
  geom_boxplot(fill = "#D9EEF2", colour = "#0B4F6C") +
  labs(
    title = "Distribution des ventes selon le mois",
    x = NULL,
    y = "Ventes"
  ) +
  theme_minimal(base_size = 12) +
  theme(axis.text.x = element_text(angle = 35, hjust = 1))
```

![](demonstrations_files/figure-html/unnamed-chunk-3-1.png)

Ce graphique suggère des différences saisonnières, mais ne remplace pas une évaluation de prévision.

## 4. Créer une période test

Les douze derniers mois représentent ici une évaluation rétrospective : on fait comme si les données s’arrêtaient en décembre 2024.

``` r
date_coupure <- as.Date("2025-01-01")

entrainement <- ventes |> filter(date < date_coupure)
test <- ventes |> filter(date >= date_coupure)

tibble(
  partie = c("Entraînement", "Test"),
  debut = c(min(entrainement$date), min(test$date)),
  fin = c(max(entrainement$date), max(test$date)),
  observations = c(nrow(entrainement), nrow(test))
)
```

    # A tibble: 2 × 4
      partie       debut      fin        observations
      <chr>        <date>     <date>            <int>
    1 Entraînement 2020-01-01 2024-12-01           60
    2 Test         2025-01-01 2025-12-01           12

## 5. Calculer une référence naïve

``` r
derniere_vente <- tail(entrainement$ventes, 1)

evaluation_naive <- test |>
  mutate(
    prevision = derniere_vente,
    erreur = ventes - prevision,
    erreur_absolue = abs(erreur)
  )

evaluation_naive |>
  summarise(
    MAE = mean(erreur_absolue),
    RMSE = sqrt(mean(erreur^2))
  )
```

    # A tibble: 1 × 2
         MAE   RMSE
       <dbl>  <dbl>
    1 25351. 31862.

## Interprétation décisionnelle

La méthode naïve sert de seuil minimal. Son erreur doit être traduite dans le contexte : une MAE de 30 000 dollars n’a pas la même conséquence pour une petite unité que pour une organisation dont les ventes mensuelles dépassent plusieurs millions.
