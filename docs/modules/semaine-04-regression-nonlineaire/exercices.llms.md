# Exercices - Module 04

## Objectif

Ces exercices servent à choisir et justifier un modèle lorsque la relation n’est pas bien résumée par une droite.

## Préparation

``` r
library(tidyverse)

data_path <- "modules/semaine-04-regression-nonlineaire/data/achalandage_saturation_quebec.csv"
saturation <- read_csv(data_path, show_col_types = FALSE)
```

## Exercice 1 - Lire le graphique

Produisez un graphique des ventes selon l’achalandage avec une droite linéaire et une courbe quadratique.

``` r
ggplot(saturation, aes(x = achalandage, y = ventes)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  geom_smooth(method = "lm", formula = y ~ x + I(x^2), se = FALSE) +
  theme_minimal()
```

Que suggère le graphique?

> **TIP:**
>
> Le graphique suggère une relation positive, mais possiblement courbée. Les ventes augmentent avec l’achalandage, puis la hausse semble ralentir lorsque l’achalandage devient élevé.

## Exercice 2 - Ajuster deux modèles

Ajustez un modèle linéaire et un modèle quadratique.

``` r
modele_lineaire <- lm(ventes ~ achalandage, data = saturation)

modele_quadratique <- lm(
  ventes ~ achalandage + I(achalandage^2),
  data = saturation
)

summary(modele_lineaire)
summary(modele_quadratique)
```

Comparez les deux modèles avec le `R²`.

> **TIP:**
>
> Le modèle quadratique devrait expliquer davantage de variation si la courbure est réelle. Le `R²` ne suffit toutefois pas à lui seul : il faut aussi regarder le graphique des prédictions et les résidus.

## Exercice 3 - Calculer la RMSE

Créez une fonction `rmse()` et comparez les erreurs des deux modèles.

``` r
rmse <- function(modele) {
  sqrt(mean(residuals(modele)^2))
}

tibble(
  modele = c("Linéaire", "Quadratique"),
  erreur_rmse = c(rmse(modele_lineaire), rmse(modele_quadratique))
)
```

> **TIP:**
>
> Une RMSE plus faible indique que les erreurs typiques sont plus petites sur l’échelle des ventes. Si le modèle quadratique a une RMSE plus faible et des résidus mieux répartis, il devient plus défendable.

## Exercice 4 - Interpréter la saturation

Expliquez en cinq lignes pourquoi la saturation opérationnelle peut produire une relation non linéaire entre achalandage et ventes.

> **TIP:**
>
> Lorsque l’achalandage augmente, les ventes augmentent généralement aussi. Mais à haut niveau d’achalandage, les files d’attente, les ruptures de stock, la fatigue du personnel ou les limites de capacité peuvent réduire l’effet marginal de clients supplémentaires. La relation peut alors ralentir.

## Exercice 5 - Conclusion prudente

Rédigez une conclusion qui recommande un modèle et mentionne une limite d’extrapolation.

> **TIP:**
>
> Une réponse acceptable doit justifier le choix du modèle par la forme graphique, les résidus ou une mesure d’erreur. Elle doit aussi préciser que la conclusion est valable surtout pour les niveaux d’achalandage observés et qu’une prédiction hors de cette plage serait fragile.

## Exercice 6 - Mini-trace de comparaison

Préparez une mini-trace finale de comparaison de modèles. Elle doit contenir :

- la forme observée dans le graphique;
- les modèles comparés;
- un argument graphique;
- un argument numérique ou un diagnostic;
- le modèle retenu;
- une limite d’extrapolation.

> **TIP:**
>
> Une réponse solide ne dit pas seulement que le modèle quadratique a un meilleur `R²`. Elle explique que la relation observée semble ralentir, que le modèle avec courbure décrit mieux cette forme, que les erreurs ou les résidus appuient ce choix, puis que les prédictions doivent rester dans la plage d’achalandage observée.
