# Démonstrations R - Module 04

## Objectif

Cette page montre comment comparer un modèle linéaire simple à deux modèles avec transformation. La question est la même pour chaque modèle : quelle forme décrit le mieux la relation entre l’achalandage et les ventes?

## Préparation

``` r
library(tidyverse)

data_path <- if (file.exists("data/achalandage_saturation_quebec.csv")) {
  "data/achalandage_saturation_quebec.csv"
} else {
  "modules/semaine-04-regression-nonlineaire/data/achalandage_saturation_quebec.csv"
}

saturation <- read_csv(data_path, show_col_types = FALSE)
```

## Inspecter les données

``` r
glimpse(saturation)
```

    Rows: 72
    Columns: 16
    $ mois                  <date> 2025-01-01, 2025-01-01, 2025-01-01, 2025-01-01,…
    $ mois_label            <chr> "janvier", "janvier", "janvier", "janvier", "jan…
    $ saison                <chr> "moyenne", "moyenne", "moyenne", "moyenne", "moy…
    $ succursale            <chr> "Gatineau", "Montréal", "Québec", "Saguenay", "S…
    $ region                <chr> "Outaouais", "Montréal", "Capitale-Nationale", "…
    $ surface_m2            <dbl> 420, 590, 465, 345, 385, 360, 420, 590, 465, 345…
    $ capacite_reference    <dbl> 2050, 3300, 2450, 1600, 1850, 1720, 2050, 3300, …
    $ campagne_locale       <chr> "non", "non", "oui", "non", "non", "non", "oui",…
    $ depenses_marketing    <dbl> 3706, 5215, 5469, 3543, 2778, 4173, 4259, 5638, …
    $ achalandage           <dbl> 2366, 3715, 2509, 1777, 2040, 2028, 2024, 3833, …
    $ taux_occupation       <dbl> 1.154, 1.126, 1.024, 1.111, 1.103, 1.179, 0.987,…
    $ ruptures_stock        <dbl> 3, 1, 2, 2, 2, 2, 1, 2, 1, 1, 2, 0, 1, 0, 1, 1, …
    $ temps_attente_minutes <dbl> 5.5, 4.3, 4.3, 6.0, 5.1, 5.4, 3.6, 4.4, 3.7, 4.0…
    $ panier_moyen          <dbl> 70.02, 51.39, 69.78, 82.64, 74.49, 78.92, 77.54,…
    $ satisfaction          <dbl> 7.6, 7.8, 7.1, 7.0, 6.9, 7.6, 8.5, 7.8, 8.3, 8.4…
    $ ventes                <dbl> 165671, 190921, 175077, 146858, 151957, 160044, …

``` r
saturation |>
  summarise(
    observations = n(),
    succursales = n_distinct(succursale),
    achalandage_moyen = mean(achalandage),
    ventes_moyennes = mean(ventes),
    taux_occupation_moyen = mean(taux_occupation)
  )
```

    # A tibble: 1 × 5
      observations succursales achalandage_moyen ventes_moyennes
             <int>       <int>             <dbl>           <dbl>
    1           72           6             2264.         161210.
    # ℹ 1 more variable: taux_occupation_moyen <dbl>

## Visualiser la courbure

``` r
ggplot(saturation, aes(x = achalandage, y = ventes)) +
  geom_point(aes(colour = succursale), alpha = 0.8, size = 2.4) +
  geom_smooth(method = "lm", se = FALSE, colour = "#7A1C24", linewidth = 1) +
  geom_smooth(
    method = "lm",
    formula = y ~ x + I(x^2),
    se = FALSE,
    colour = "#0B4F6C",
    linewidth = 1
  ) +
  labs(
    title = "Ventes selon l'achalandage",
    subtitle = "Droite linéaire et courbe quadratique",
    x = "Achalandage mensuel",
    y = "Ventes",
    colour = "Succursale"
  ) +
  theme_minimal(base_size = 12) +
  theme(panel.grid.minor = element_blank())
```

![](demonstrations_files/figure-html/nuage-saturation-1.png)

Le graphique suggère que la relation est positive, mais que la pente semble ralentir lorsque l’achalandage devient élevé.

## Ajuster trois modèles

``` r
modele_lineaire <- lm(ventes ~ achalandage, data = saturation)

modele_quadratique <- lm(
  ventes ~ achalandage + I(achalandage^2),
  data = saturation
)

modele_log <- lm(
  ventes ~ log(achalandage),
  data = saturation
)
```

``` r
summary(modele_lineaire)$coefficients
```

                    Estimate  Std. Error  t value     Pr(>|t|)
    (Intercept) 104578.86999 3848.737465 27.17225 6.452685e-39
    achalandage     25.01099    1.632425 15.32137 4.714261e-24

``` r
summary(modele_quadratique)$coefficients
```

                          Estimate   Std. Error   t value     Pr(>|t|)
    (Intercept)       4.699548e+04 1.175528e+04  3.997818 1.580797e-04
    achalandage       7.307855e+01 9.521030e+00  7.675487 7.836463e-11
    I(achalandage^2) -9.220373e-03 1.806458e-03 -5.104118 2.803390e-06

``` r
summary(modele_log)$coefficients
```

                      Estimate Std. Error   t value     Pr(>|t|)
    (Intercept)      -318150.2  27136.966 -11.72387 3.554137e-18
    log(achalandage)   62361.6   3528.144  17.67547 1.621144e-27

## Comparer l’ajustement

``` r
rmse <- function(modele) {
  sqrt(mean(residuals(modele)^2))
}

comparaison <- tibble(
  modele = c("Linéaire", "Quadratique", "Logarithmique"),
  r_carre = c(
    summary(modele_lineaire)$r.squared,
    summary(modele_quadratique)$r.squared,
    summary(modele_log)$r.squared
  ),
  erreur_rmse = c(
    rmse(modele_lineaire),
    rmse(modele_quadratique),
    rmse(modele_log)
  )
)

comparaison
```

    # A tibble: 3 × 3
      modele        r_carre erreur_rmse
      <chr>           <dbl>       <dbl>
    1 Linéaire        0.770       8976.
    2 Quadratique     0.833       7647.
    3 Logarithmique   0.817       8012.

Le `R²` résume la proportion de variation expliquée. La RMSE mesure l’erreur typique de prédiction sur l’échelle des ventes. Une RMSE plus faible indique des résidus généralement plus petits.

## Superposer les prédictions

``` r
grille_achalandage <- tibble(
  achalandage = seq(
    min(saturation$achalandage),
    max(saturation$achalandage),
    length.out = 120
  )
)

predictions <- bind_rows(
  grille_achalandage |>
    mutate(
      modele = "Linéaire",
      ventes_predites = predict(modele_lineaire, newdata = grille_achalandage)
    ),
  grille_achalandage |>
    mutate(
      modele = "Quadratique",
      ventes_predites = predict(modele_quadratique, newdata = grille_achalandage)
    ),
  grille_achalandage |>
    mutate(
      modele = "Logarithmique",
      ventes_predites = predict(modele_log, newdata = grille_achalandage)
    )
)
```

``` r
ggplot(saturation, aes(x = achalandage, y = ventes)) +
  geom_point(alpha = 0.45, colour = "#40515C") +
  geom_line(
    data = predictions,
    aes(y = ventes_predites, colour = modele),
    linewidth = 1.1
  ) +
  labs(
    title = "Comparaison des prédictions",
    x = "Achalandage mensuel",
    y = "Ventes prédites",
    colour = "Modèle"
  ) +
  theme_minimal(base_size = 12) +
  theme(panel.grid.minor = element_blank())
```

![](demonstrations_files/figure-html/graphique-predictions-module-04-1.png)

## Diagnostiquer les résidus

``` r
residus_modeles <- bind_rows(
  saturation |>
    mutate(
      modele = "Linéaire",
      ventes_predites = predict(modele_lineaire),
      residu = residuals(modele_lineaire)
    ),
  saturation |>
    mutate(
      modele = "Quadratique",
      ventes_predites = predict(modele_quadratique),
      residu = residuals(modele_quadratique)
    ),
  saturation |>
    mutate(
      modele = "Logarithmique",
      ventes_predites = predict(modele_log),
      residu = residuals(modele_log)
    )
)
```

``` r
ggplot(residus_modeles, aes(x = ventes_predites, y = residu)) +
  geom_hline(yintercept = 0, colour = "#7A1C24", linewidth = 0.9) +
  geom_point(alpha = 0.7, colour = "#0B4F6C") +
  facet_wrap(vars(modele)) +
  labs(
    title = "Résidus selon les ventes prédites",
    x = "Ventes prédites",
    y = "Résidu"
  ) +
  theme_minimal(base_size = 12) +
  theme(panel.grid.minor = element_blank())
```

![](demonstrations_files/figure-html/graphique-residus-module-04-1.png)

## Conclusion prudente

> **TIP:**
>
> Dans ces données simulées, les ventes augmentent avec l’achalandage, mais la relation semble ralentir lorsque l’achalandage est élevé. Un modèle avec courbure ou une transformation logarithmique peut mieux représenter cette saturation qu’une droite. La conclusion doit rester limitée à la plage observée et ne doit pas être extrapolée à des achalandages beaucoup plus élevés.
