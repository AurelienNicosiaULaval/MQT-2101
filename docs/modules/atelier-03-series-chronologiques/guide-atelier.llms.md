# Guide en classe - Atelier 03

## Question centrale

> Quelle méthode fournit une prévision assez précise et assez stable pour planifier la demande des treize prochaines semaines?

## Préparation

``` r
library(tidyverse)
library(slider)
library(forecast)

data_path <- if (file.exists("data/demande_hebdomadaire_quebec.csv")) {
  "data/demande_hebdomadaire_quebec.csv"
} else {
  "modules/atelier-03-series-chronologiques/data/demande_hebdomadaire_quebec.csv"
}

demande <- read_csv(data_path, show_col_types = FALSE) |>
  mutate(semaine = as.Date(semaine)) |>
  arrange(semaine)
```

## Étape 1 - Auditer le temps

``` r
demande |>
  summarise(
    debut = min(semaine),
    fin = max(semaine),
    semaines = n(),
    dates_uniques = n_distinct(semaine),
    valeurs_manquantes = sum(is.na(demande))
  )
```

    # A tibble: 1 × 5
      debut      fin        semaines dates_uniques valeurs_manquantes
      <date>     <date>        <int>         <int>              <int>
    1 2024-01-01 2025-12-22      104           104                  0

> **TIP:**
>
> Écrivez l’unité d’observation, la fréquence, la période, la cible et l’horizon.

## Étape 2 - Explorer

``` r
ggplot(demande, aes(semaine, demande)) +
  geom_line(colour = "#0B4F6C") +
  geom_point(aes(shape = promotion), size = 1.5) +
  labs(title = "Demande hebdomadaire fictive", x = NULL, y = "Unités", shape = "Promotion") +
  theme_minimal(base_size = 12)
```

![](guide-atelier_files/figure-html/unnamed-chunk-2-1.png)

> **TIP:**
>
> Décrivez un motif stable, un motif incertain et une limite du graphique.

## Étape 3 - Geler la période test

``` r
horizon <- 13
entrainement <- demande |> slice_head(n = nrow(demande) - horizon)
test <- demande |> slice_tail(n = horizon)
```

Notez explicitement la dernière date d’entraînement et la première date de test.

## Étape 4 - Construire les références

``` r
serie <- ts(entrainement$demande, frequency = 52)

previsions <- test |>
  transmute(
    semaine,
    observe = demande,
    naive = tail(entrainement$demande, 1),
    moyenne_4 = mean(tail(entrainement$demande, 4)),
    SES = as.numeric(ses(serie, h = horizon)$mean),
    Holt = as.numeric(holt(serie, h = horizon, damped = TRUE)$mean)
  )
```

## Étape 5 - Comparer

``` r
evaluation <- previsions |>
  pivot_longer(naive:Holt, names_to = "methode", values_to = "prevision") |>
  mutate(erreur = observe - prevision)

tableau_mesures <- evaluation |>
  group_by(methode) |>
  summarise(
    MAE = mean(abs(erreur)),
    RMSE = sqrt(mean(erreur^2)),
    biais = mean(erreur),
    erreur_max = max(abs(erreur)),
    .groups = "drop"
  ) |>
  arrange(MAE)

tableau_mesures
```

    # A tibble: 4 × 5
      methode     MAE  RMSE biais erreur_max
      <chr>     <dbl> <dbl> <dbl>      <dbl>
    1 moyenne_4  100.  128.  82.6       264.
    2 SES        114.  144. 106.        287.
    3 Holt       152.  189. 152.        354.
    4 naive      185.  209. 185.        366 

``` r
evaluation |>
  ggplot(aes(semaine)) +
  geom_line(aes(y = observe), colour = "black", linewidth = 1) +
  geom_line(aes(y = prevision, colour = methode), linewidth = 0.8) +
  labs(title = "Comparaison sur la période test", x = NULL, y = "Demande", colour = "Méthode") +
  theme_minimal(base_size = 12)
```

![](guide-atelier_files/figure-html/unnamed-chunk-6-1.png)

> **TIP:**
>
> Choisissez une méthode et citez au moins deux mesures. Expliquez une raison de ne pas suivre aveuglément le classement.

## Étape 6 - Traduire en décision

Supposez qu’une unité sous-prévue coûte 18 dollars en urgence et qu’une unité sur-prévue coûte 5 dollars en stockage.

``` r
couts <- evaluation |>
  mutate(
    cout = if_else(erreur > 0, 18 * erreur, 5 * abs(erreur))
  ) |>
  group_by(methode) |>
  summarise(cout_total = sum(cout), .groups = "drop") |>
  arrange(cout_total)

couts
```

    # A tibble: 4 × 2
      methode   cout_total
      <chr>          <dbl>
    1 moyenne_4     21944.
    2 SES           25997.
    3 Holt          35578.
    4 naive         43254 

> **IMPORTANT:**
>
> Votre recommandation doit nommer la méthode, la preuve test, le coût simulé, une limite et le moment où la méthode sera réévaluée.

## Vérification finale

Le fichier se rend en HTML.

Les dates et unités sont explicites.

La période test n’a pas servi à l’ajustement.

Le graphique et le tableau racontent la même histoire.

La recommandation tient compte du coût asymétrique.
