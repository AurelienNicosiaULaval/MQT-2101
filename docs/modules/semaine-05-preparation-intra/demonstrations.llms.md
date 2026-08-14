# Démonstrations R - Module 05

## Objectif

Cette page montre une réponse de révision complète avec un jeu de données déjà utilisé dans le cours. L’objectif est de pratiquer le format attendu : code, résultat et interprétation.

## Préparation

``` r
library(tidyverse)

data_path <- if (file.exists("../atelier-02-regression/data/performance_succursales_quebec.csv")) {
  "../atelier-02-regression/data/performance_succursales_quebec.csv"
} else {
  "modules/atelier-02-regression/data/performance_succursales_quebec.csv"
}

performance <- read_csv(data_path, show_col_types = FALSE)
```

## Question de révision

> Les ventes mensuelles des succursales sont-elles associées à l’achalandage et aux ruptures de stock?

Cette question porte sur une association. Elle ne permet pas, à elle seule, de conclure que l’achalandage ou les ruptures causent les ventes.

## Inspecter le tableau

``` r
glimpse(performance)
```

    Rows: 72
    Columns: 14
    $ mois                  <date> 2025-01-01, 2025-01-01, 2025-01-01, 2025-01-01,…
    $ mois_label            <chr> "janvier", "janvier", "janvier", "janvier", "jan…
    $ saison                <chr> "moyenne", "moyenne", "moyenne", "moyenne", "moy…
    $ succursale            <chr> "Gatineau", "Montréal", "Québec", "Saguenay", "S…
    $ region                <chr> "Outaouais", "Montréal", "Capitale-Nationale", "…
    $ surface_m2            <dbl> 420, 560, 470, 350, 390, 365, 420, 560, 470, 350…
    $ campagne_locale       <chr> "oui", "oui", "non", "non", "oui", "non", "non",…
    $ depenses_marketing    <dbl> 5977, 6162, 4978, 2981, 5061, 3279, 4677, 4693, …
    $ achalandage           <dbl> 1653, 2043, 1864, 1202, 1362, 1369, 1486, 2179, …
    $ heures_personnel      <dbl> 483, 528, 499, 450, 476, 493, 498, 577, 495, 465…
    $ ruptures_stock        <dbl> 1, 1, 2, 1, 0, 1, 0, 1, 6, 3, 0, 2, 1, 0, 1, 2, …
    $ delai_service_minutes <dbl> 5.5, 6.8, 3.8, 5.4, 3.8, 5.5, 5.0, 6.2, 6.5, 5.3…
    $ satisfaction          <dbl> 7.7, 8.0, 7.7, 7.4, 8.7, 8.4, 8.6, 8.3, 7.1, 7.6…
    $ ventes                <dbl> 163260, 180567, 166706, 126460, 151254, 132775, …

``` r
performance |>
  summarise(
    observations = n(),
    succursales = n_distinct(succursale),
    ventes_moyennes = mean(ventes),
    achalandage_moyen = mean(achalandage),
    ruptures_moyennes = mean(ruptures_stock)
  )
```

    # A tibble: 1 × 5
      observations succursales ventes_moyennes achalandage_moyen ruptures_moyennes
             <int>       <int>           <dbl>             <dbl>             <dbl>
    1           72           6         154199.             1642.              1.93

Interprétation : chaque ligne représente une combinaison mois-succursale. Les variables `ventes`, `achalandage` et `ruptures_stock` sont numériques.

## Visualiser avant de modéliser

``` r
ggplot(performance, aes(x = achalandage, y = ventes)) +
  geom_point(aes(colour = ruptures_stock), alpha = 0.8, size = 2.4) +
  geom_smooth(method = "lm", se = FALSE, colour = "#0B4F6C", linewidth = 1.1) +
  labs(
    title = "Ventes selon l'achalandage",
    subtitle = "La couleur indique le nombre de ruptures de stock",
    x = "Achalandage mensuel",
    y = "Ventes",
    colour = "Ruptures"
  ) +
  theme_minimal(base_size = 12) +
  theme(panel.grid.minor = element_blank())
```

![](demonstrations_files/figure-html/graphique-module-05-1.png)

Le graphique suggère une association positive entre achalandage et ventes. La couleur permet aussi de vérifier si les ruptures semblent concentrées dans certaines zones du graphique.

## Ajuster un modèle

``` r
modele <- lm(
  ventes ~ achalandage + ruptures_stock,
  data = performance
)

summary(modele)
```


    Call:
    lm(formula = ventes ~ achalandage + ruptures_stock, data = performance)

    Residuals:
         Min       1Q   Median       3Q      Max
    -17740.1  -5714.9   -679.8   6558.4  16708.6

    Coefficients:
                    Estimate Std. Error t value Pr(>|t|)
    (Intercept)    52567.578   5286.163   9.944 5.87e-15 ***
    achalandage       64.147      3.159  20.307  < 2e-16 ***
    ruptures_stock -1919.406    647.063  -2.966  0.00414 **
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 7999 on 69 degrees of freedom
    Multiple R-squared:  0.8568,    Adjusted R-squared:  0.8527
    F-statistic: 206.5 on 2 and 69 DF,  p-value: < 2.2e-16

## Lire les coefficients

``` r
coef(modele)
```

       (Intercept)    achalandage ruptures_stock
       52567.57794       64.14725    -1919.40640

Interprétation attendue :

- le coefficient de `achalandage` décrit l’association moyenne entre une unité supplémentaire d’achalandage et les ventes, à nombre de ruptures constant;
- le coefficient de `ruptures_stock` décrit l’association moyenne entre une rupture de stock supplémentaire et les ventes, à achalandage constant.

## Vérifier les résidus

``` r
performance_modele <- performance |>
  mutate(
    ventes_predites = predict(modele),
    residu = residuals(modele)
  )
```

``` r
ggplot(performance_modele, aes(x = ventes_predites, y = residu)) +
  geom_hline(yintercept = 0, colour = "#7A1C24", linewidth = 0.9) +
  geom_point(alpha = 0.8, colour = "#0B4F6C", size = 2.4) +
  labs(
    title = "Résidus selon les ventes prédites",
    x = "Ventes prédites",
    y = "Résidu"
  ) +
  theme_minimal(base_size = 12) +
  theme(panel.grid.minor = element_blank())
```

![](demonstrations_files/figure-html/graphique-residus-module-05-1.png)

## Réponse synthèse

> **TIP:**
>
> Les ventes mensuelles semblent positivement associées à l’achalandage. Le modèle ajusté inclut aussi les ruptures de stock afin de tenir compte d’une contrainte opérationnelle. Les coefficients doivent être lus comme des associations moyennes, pas comme des effets causaux démontrés. Le graphique des résidus sert à vérifier si le modèle laisse une structure visible non expliquée.
