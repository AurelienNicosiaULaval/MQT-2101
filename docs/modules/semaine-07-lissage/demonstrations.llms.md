# Démonstrations R - Module 07

## Préparation

``` r
library(tidyverse)
library(slider)
library(forecast)

data_path <- if (file.exists("data/demande_hebdomadaire_quebec.csv")) {
  "data/demande_hebdomadaire_quebec.csv"
} else {
  "modules/semaine-07-lissage/data/demande_hebdomadaire_quebec.csv"
}

demande <- read_csv(data_path, show_col_types = FALSE) |>
  mutate(semaine = as.Date(semaine)) |>
  arrange(semaine)
```

## 1. Lisser pour explorer

``` r
demande_lissee <- demande |>
  mutate(
    moyenne_mobile_4 = slide_dbl(
      demande,
      mean,
      .before = 3,
      .complete = TRUE
    )
  )

demande_lissee |>
  ggplot(aes(semaine)) +
  geom_line(aes(y = demande), colour = "#8A9AA6", linewidth = 0.6) +
  geom_line(aes(y = moyenne_mobile_4), colour = "#0B4F6C", linewidth = 1) +
  labs(
    title = "Demande et moyenne mobile arrière de quatre semaines",
    x = NULL,
    y = "Demande"
  ) +
  theme_minimal(base_size = 12)
```

![](demonstrations_files/figure-html/unnamed-chunk-1-1.png)

## 2. Séparer entraînement et test

``` r
horizon <- 13
entrainement <- demande |> slice_head(n = nrow(demande) - horizon)
test <- demande |> slice_tail(n = horizon)

serie_entrainement <- ts(entrainement$demande, frequency = 52)
```

## 3. Produire trois prévisions

``` r
prevision_naive <- rep(tail(entrainement$demande, 1), horizon)
prevision_mm4 <- rep(mean(tail(entrainement$demande, 4)), horizon)

modele_ses <- ses(serie_entrainement, h = horizon)
prevision_ses <- as.numeric(modele_ses$mean)

comparaison <- test |>
  transmute(
    semaine,
    observe = demande,
    naive = prevision_naive,
    moyenne_mobile_4 = prevision_mm4,
    lissage_exponentiel = prevision_ses
  )
```

## 4. Comparer les erreurs

``` r
mesures <- comparaison |>
  pivot_longer(
    cols = naive:lissage_exponentiel,
    names_to = "methode",
    values_to = "prevision"
  ) |>
  mutate(erreur = observe - prevision) |>
  group_by(methode) |>
  summarise(
    MAE = mean(abs(erreur)),
    RMSE = sqrt(mean(erreur^2)),
    biais = mean(erreur),
    .groups = "drop"
  ) |>
  arrange(MAE)

mesures
```

    # A tibble: 3 × 4
      methode               MAE  RMSE biais
      <chr>               <dbl> <dbl> <dbl>
    1 moyenne_mobile_4     100.  128.  82.6
    2 lissage_exponentiel  114.  144. 106.
    3 naive                185.  209. 185.

## 5. Visualiser la période test

``` r
comparaison |>
  pivot_longer(naive:lissage_exponentiel, names_to = "methode", values_to = "prevision") |>
  ggplot(aes(semaine)) +
  geom_line(aes(y = observe), colour = "black", linewidth = 1) +
  geom_line(aes(y = prevision, colour = methode), linewidth = 0.8) +
  labs(
    title = "Prévisions sur les treize semaines test",
    x = NULL,
    y = "Demande",
    colour = "Méthode"
  ) +
  theme_minimal(base_size = 12)
```

![](demonstrations_files/figure-html/unnamed-chunk-5-1.png)

## Interprétation

Le tableau permet de classer les méthodes pour cette période test. Il ne garantit pas que le classement sera identique la saison suivante. La trace finale doit donc expliquer le choix et nommer cette limite.
