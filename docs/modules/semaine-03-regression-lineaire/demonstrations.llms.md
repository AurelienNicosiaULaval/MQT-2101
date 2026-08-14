# Démonstrations R - Module 03

## Objectif

Cette page montre une analyse reproductible de régression linéaire simple. Le but n’est pas de mémoriser le code, mais de comprendre la séquence :

1.  importer;
2.  visualiser;
3.  ajuster;
4.  interpréter;
5.  diagnostiquer;
6.  formuler une conclusion prudente.

## Préparation

``` r
library(tidyverse)

data_path <- if (file.exists("data/campagnes_marketing_quebec.csv")) {
  "data/campagnes_marketing_quebec.csv"
} else {
  "modules/semaine-03-regression-lineaire/data/campagnes_marketing_quebec.csv"
}

campagnes <- read_csv(data_path, show_col_types = FALSE)
```

## Inspecter le tableau

``` r
glimpse(campagnes)
```

    Rows: 60
    Columns: 10
    $ mois             <date> 2025-01-01, 2025-01-01, 2025-01-01, 2025-01-01, 2025…
    $ mois_label       <chr> "janvier", "janvier", "janvier", "janvier", "janvier"…
    $ region           <chr> "Capitale-Nationale", "Estrie", "Mauricie", "Montréal…
    $ canal            <chr> "Infolettre", "Infolettre", "Recherche", "Réseaux soc…
    $ saison           <chr> "moyenne", "moyenne", "moyenne", "moyenne", "moyenne"…
    $ budget_marketing <dbl> 5814, 3775, 5497, 6215, 5703, 3246, 4927, 2497, 6515,…
    $ visites_site     <dbl> 6393, 5235, 6880, 8106, 7107, 4958, 6154, 4117, 7606,…
    $ rabais           <dbl> 0.00, 0.15, 0.13, 0.17, 0.17, 0.13, 0.15, 0.08, 0.17,…
    $ ventes           <dbl> 121915, 93518, 95109, 121125, 108469, 82306, 95280, 5…
    $ satisfaction     <dbl> 7.7, 7.4, 7.5, 7.7, 7.7, 7.1, 7.3, 7.2, 8.5, 7.2, 8.3…

``` r
campagnes |>
  summarise(
    observations = n(),
    budget_moyen = mean(budget_marketing),
    ventes_moyennes = mean(ventes),
    ventes_min = min(ventes),
    ventes_max = max(ventes)
  )
```

    # A tibble: 1 × 5
      observations budget_moyen ventes_moyennes ventes_min ventes_max
             <int>        <dbl>           <dbl>      <dbl>      <dbl>
    1           60        5470.         104212.      56608     153315

## Visualiser la relation

``` r
ggplot(campagnes, aes(x = budget_marketing, y = ventes)) +
  geom_point(aes(colour = region), alpha = 0.8, size = 2.4) +
  geom_smooth(method = "lm", se = FALSE, colour = "#0B4F6C", linewidth = 1.1) +
  labs(
    title = "Ventes selon le budget marketing",
    x = "Budget marketing",
    y = "Ventes",
    colour = "Région"
  ) +
  theme_minimal(base_size = 12) +
  theme(panel.grid.minor = element_blank())
```

![](demonstrations_files/figure-html/nuage-budget-ventes-1.png)

Le graphique suggère une association positive : les campagnes avec un budget plus élevé tendent aussi à avoir des ventes plus élevées.

## Ajuster le modèle

``` r
modele_budget <- lm(ventes ~ budget_marketing, data = campagnes)

summary(modele_budget)
```


    Call:
    lm(formula = ventes ~ budget_marketing, data = campagnes)

    Residuals:
         Min       1Q   Median       3Q      Max
    -16277.1  -6353.5   -347.8   6892.4  17632.8

    Coefficients:
                      Estimate Std. Error t value Pr(>|t|)
    (Intercept)      2.992e+04  4.632e+03    6.46 2.35e-08 ***
    budget_marketing 1.358e+01  8.236e-01   16.49  < 2e-16 ***
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 8339 on 58 degrees of freedom
    Multiple R-squared:  0.8242,    Adjusted R-squared:  0.8212
    F-statistic: 271.9 on 1 and 58 DF,  p-value: < 2.2e-16

## Interpréter les coefficients

``` r
coefficients_modele <- coef(modele_budget)

coefficients_modele
```

         (Intercept) budget_marketing
           29922.107           13.582

La pente estimée correspond à la variation moyenne des ventes associée à une augmentation d’une unité de budget marketing, dans ce jeu de données.

Comme le budget est en dollars, une augmentation de 1 dollar est peu parlante. On peut reformuler la pente pour 1 000 dollars.

``` r
pente_1000 <- coefficients_modele["budget_marketing"] * 1000

pente_1000
```

    budget_marketing
               13582

Interprétation attendue : pour 1 000 dollars de budget marketing supplémentaire, le modèle estime une augmentation moyenne des ventes d’environ 1.3582^{4} dollars, dans ces données.

## Qualité d’ajustement

``` r
resume_modele <- summary(modele_budget)

resume_modele$r.squared
```

    [1] 0.8242079

Le `R²` indique la proportion de variation des ventes expliquée par la droite utilisant seulement le budget marketing.

## Résidus et valeurs ajustées

``` r
campagnes_modele <- campagnes |>
  mutate(
    ventes_predites = predict(modele_budget),
    residu = residuals(modele_budget)
  )

campagnes_modele |>
  select(region, mois_label, budget_marketing, ventes, ventes_predites, residu) |>
  slice_head(n = 8)
```

    # A tibble: 8 × 6
      region             mois_label budget_marketing ventes ventes_predites residu
      <chr>              <chr>                 <dbl>  <dbl>           <dbl>  <dbl>
    1 Capitale-Nationale janvier                5814 121915         108888. 13027.
    2 Estrie             janvier                3775  93518          81194. 12324.
    3 Mauricie           janvier                5497  95109         104582. -9473.
    4 Montréal           janvier                6215 121125         114334.  6791.
    5 Outaouais          janvier                5703 108469         107380.  1089.
    6 Capitale-Nationale février                3246  82306          74009.  8297.
    7 Estrie             février                4927  95280          96841. -1561.
    8 Mauricie           février                2497  56608          63836. -7228.

``` r
ggplot(campagnes_modele, aes(x = ventes_predites, y = residu)) +
  geom_hline(yintercept = 0, colour = "#7A1C24", linewidth = 0.9) +
  geom_point(alpha = 0.8, size = 2.4, colour = "#0B4F6C") +
  labs(
    title = "Résidus selon les ventes prédites",
    x = "Ventes prédites",
    y = "Résidu"
  ) +
  theme_minimal(base_size = 12) +
  theme(panel.grid.minor = element_blank())
```

![](demonstrations_files/figure-html/diagnostic-residus-module-03-1.png)

Un bon diagnostic de base vérifie si les résidus sont dispersés autour de zéro sans motif évident. Si les résidus augmentent, diminuent ou forment une courbe, le modèle linéaire simple peut être insuffisant.

## Prédire pour de nouveaux budgets

``` r
nouveaux_budgets <- tibble(
  budget_marketing = c(4000, 6000, 8000)
)

predict(
  modele_budget,
  newdata = nouveaux_budgets,
  interval = "prediction"
)
```

            fit       lwr      upr
    1  84250.11  67245.43 101254.8
    2 111414.12  94560.27 128268.0
    3 138578.12 121237.71 155918.5

Une prédiction doit être interprétée comme une estimation incertaine. Elle est plus crédible pour des budgets comparables à ceux observés dans les données.

## Conclusion prudente

> **TIP:**
>
> Dans ces données simulées, les ventes sont positivement associées au budget marketing. La pente du modèle donne une estimation de l’augmentation moyenne des ventes lorsque le budget augmente. Cette relation reste une association observée: elle ne suffit pas à prouver un effet causal du budget sur les ventes.
