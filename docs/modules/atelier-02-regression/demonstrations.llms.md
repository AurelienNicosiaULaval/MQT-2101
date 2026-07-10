# Démonstrations R - Atelier 02

## Objectif

Cette page montre comment passer d’un tableau de performance de succursales à une recommandation fondée sur une régression.

> **NOTE:**
>
> Cette page sert de référence pendant l’atelier. Lisez l’objectif de chaque démonstration, exécutez le code, puis écrivez l’interprétation dans votre propre fichier Quarto. Le code seul ne suffit pas : chaque résultat doit être relié à la question d’affaires.

## Vue d’ensemble

Les démonstrations suivent le même ordre que la trace finale :

1.  comprendre le tableau;
2.  visualiser la relation principale;
3.  ajuster un modèle simple;
4.  ajouter des variables de contexte;
5.  comparer les modèles;
6.  diagnostiquer les résidus;
7.  formuler une recommandation prudente.

## Préparation

``` r
library(tidyverse)

data_path <- if (file.exists("data/performance_succursales_quebec.csv")) {
  "data/performance_succursales_quebec.csv"
} else {
  "modules/atelier-02-regression/data/performance_succursales_quebec.csv"
}

performance <- read_csv(data_path, show_col_types = FALSE)
```

## Démonstration 1 - Comprendre les données

Objectif : vérifier le contenu du tableau avant de modéliser. Une ligne représente une observation mensuelle pour une succursale fictive.

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
    depenses_moyennes = mean(depenses_marketing)
  )
```

    # A tibble: 1 × 5
      observations succursales ventes_moyennes achalandage_moyen depenses_moyennes
             <int>       <int>           <dbl>             <dbl>             <dbl>
    1           72           6         154199.             1642.             5158.

> **WARNING:**
>
> Ne commencez pas par `lm()` sans avoir vérifié l’unité d’observation et les variables disponibles. Une bonne interprétation dépend d’abord d’une bonne lecture du tableau.

## Démonstration 2 - Explorer une relation principale

Objectif : produire un graphique qui permet de voir la relation entre achalandage et ventes avant d’ajuster le modèle.

``` r
ggplot(performance, aes(x = achalandage, y = ventes)) +
  geom_point(aes(colour = succursale), alpha = 0.8, size = 2.4) +
  geom_smooth(method = "lm", se = FALSE, colour = "#0B4F6C", linewidth = 1.1) +
  labs(
    title = "Ventes selon l'achalandage",
    x = "Achalandage mensuel",
    y = "Ventes",
    colour = "Succursale"
  ) +
  theme_minimal(base_size = 12) +
  theme(panel.grid.minor = element_blank())
```

![](demonstrations_files/figure-html/graphique-achalandage-ventes-demo-1.png)

> **CAUTION:**
>
> Le nuage de points peut suggérer une relation positive. Il ne permet pas, à lui seul, de dire que l’achalandage cause les ventes.

## Démonstration 3 - Ajuster un modèle simple

Objectif : quantifier l’association moyenne entre l’achalandage et les ventes.

``` r
modele_simple <- lm(ventes ~ achalandage, data = performance)

summary(modele_simple)
```


    Call:
    lm(formula = ventes ~ achalandage, data = performance)

    Residuals:
         Min       1Q   Median       3Q      Max 
    -18695.7  -4922.6   -294.8   5934.3  18386.3 

    Coefficients:
                Estimate Std. Error t value Pr(>|t|)    
    (Intercept) 50540.53    5526.11   9.146 1.43e-13 ***
    achalandage    63.12       3.31  19.069  < 2e-16 ***
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 8433 on 70 degrees of freedom
    Multiple R-squared:  0.8386,    Adjusted R-squared:  0.8363 
    F-statistic: 363.6 on 1 and 70 DF,  p-value: < 2.2e-16

La pente du modèle simple indique la variation moyenne estimée des ventes pour une unité supplémentaire d’achalandage mensuel.

``` r
coef(modele_simple)["achalandage"]
```

    achalandage 
       63.12511 

> **TIP:**
>
> Dans ce modèle simple, une unité supplémentaire d’achalandage est associée à une variation moyenne estimée des ventes égale à la pente. Cette interprétation doit être formulée avec les unités réelles du contexte.

## Démonstration 4 - Ajouter le contexte

Un modèle enrichi peut inclure d’autres variables plausibles. Ici, on ajoute les dépenses marketing, les heures de personnel et les ruptures de stock.

``` r
modele_enrichi <- lm(
  ventes ~ achalandage + depenses_marketing + heures_personnel + ruptures_stock,
  data = performance
)

summary(modele_enrichi)
```


    Call:
    lm(formula = ventes ~ achalandage + depenses_marketing + heures_personnel + 
        ruptures_stock, data = performance)

    Residuals:
        Min      1Q  Median      3Q     Max 
    -8940.3 -2956.8  -437.2  2763.3 12110.6 

    Coefficients:
                         Estimate Std. Error t value Pr(>|t|)    
    (Intercept)         5098.7691  9382.6231   0.543    0.589    
    achalandage           34.7889     3.6456   9.543 4.12e-14 ***
    depenses_marketing     5.9455     0.6318   9.411 7.08e-14 ***
    heures_personnel     131.4254    25.6218   5.129 2.68e-06 ***
    ruptures_stock     -1947.2759   404.7535  -4.811 8.89e-06 ***
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 4995 on 67 degrees of freedom
    Multiple R-squared:  0.9458,    Adjusted R-squared:  0.9426 
    F-statistic: 292.3 on 4 and 67 DF,  p-value: < 2.2e-16

Les coefficients du modèle enrichi se lisent en gardant constantes les autres variables incluses dans la formule. Cette formulation est importante, car elle évite de comparer naïvement des succursales qui n’ont pas le même achalandage ou la même dotation en personnel.

> **WARNING:**
>
> Dans un modèle enrichi, un coefficient ne se lit pas comme une comparaison brute. Il se lit conditionnellement aux autres variables incluses dans la formule.

## Démonstration 5 - Comparer les modèles

Objectif : comparer le modèle simple et le modèle enrichi sans choisir seulement le `R²` le plus élevé.

``` r
tibble(
  modele = c("Simple", "Enrichi"),
  r_carre = c(summary(modele_simple)$r.squared, summary(modele_enrichi)$r.squared),
  r_carre_ajuste = c(
    summary(modele_simple)$adj.r.squared,
    summary(modele_enrichi)$adj.r.squared
  )
)
```

    # A tibble: 2 × 3
      modele  r_carre r_carre_ajuste
      <chr>     <dbl>          <dbl>
    1 Simple    0.839          0.836
    2 Enrichi   0.946          0.943

Le modèle enrichi peut mieux expliquer les ventes, mais il doit rester lisible. Dans une analyse appliquée, le meilleur modèle n’est pas seulement celui qui a le `R²` le plus élevé. C’est aussi celui qui soutient une interprétation utile.

## Démonstration 6 - Diagnostiquer les résidus

Objectif : vérifier si les erreurs du modèle enrichi montrent une structure qui fragilise la recommandation.

``` r
performance_modele <- performance |>
  mutate(
    ventes_predites = predict(modele_enrichi),
    residu = residuals(modele_enrichi)
  )
```

``` r
ggplot(performance_modele, aes(x = ventes_predites, y = residu)) +
  geom_hline(yintercept = 0, colour = "#7A1C24", linewidth = 0.9) +
  geom_point(alpha = 0.8, size = 2.4, colour = "#0B4F6C") +
  labs(
    title = "Résidus du modèle enrichi",
    x = "Ventes prédites",
    y = "Résidu"
  ) +
  theme_minimal(base_size = 12) +
  theme(panel.grid.minor = element_blank())
```

![](demonstrations_files/figure-html/graphique-residus-atelier-02-1.png)

> **IMPORTANT:**
>
> Des résidus répartis autour de zéro rendent le modèle plus défendable pour une première analyse. Un motif clair dans les résidus doit être mentionné comme limite, même si les coefficients semblent intéressants.

## Démonstration 7 - Préparer une recommandation

> **TIP:**
>
> Les données suggèrent que l’achalandage est fortement associé aux ventes. Les dépenses marketing et les heures de personnel peuvent aussi être considérées dans l’interprétation du modèle enrichi. La recommandation doit toutefois rester prudente, car ces données simulées sont observationnelles et ne prouvent pas un effet causal.

## Synthèse pour la trace finale

Votre trace finale doit relier les éléments suivants :

- question d’affaires;
- graphique;
- modèle;
- coefficient interprété;
- diagnostic;
- recommandation;
- limite.

> **TIP:**
>
> Les données suggèrent de prioriser \[facteur\], car \[résultat du modèle ou du graphique\]. Cette recommandation doit rester prudente : le modèle décrit une association observée et une validation complémentaire serait nécessaire avant de conclure à un effet causal.
