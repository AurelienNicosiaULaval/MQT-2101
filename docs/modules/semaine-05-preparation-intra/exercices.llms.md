# Exercices - Module 05

## Objectif

Ces exercices servent à vérifier votre autonomie avant l’examen intra. Travaillez d’abord sans ouvrir les solutions, puis comparez votre démarche. L’objectif est de pratiquer une réponse courte, claire et défendable.

## Préparation

Les exercices réutilisent les jeux de données des modules 03 et 04.

``` r
library(tidyverse)

campagnes <- read_csv(
  "modules/semaine-03-regression-lineaire/data/campagnes_marketing_quebec.csv",
  show_col_types = FALSE
)

saturation <- read_csv(
  "modules/semaine-04-regression-nonlineaire/data/achalandage_saturation_quebec.csv",
  show_col_types = FALSE
)
```

## Exercice 1 - Identifier la question

Pour chacune des formulations suivantes, dites s’il s’agit surtout de description, d’association, de prédiction ou de causalité. Ajoutez une phrase qui explique ce que vous feriez comme première étape.

1.  Décrire les ventes moyennes par succursale.
2.  Étudier la relation entre budget marketing et ventes.
3.  Estimer les ventes attendues pour un nouveau niveau d’achalandage.
4.  Conclure qu’une hausse de budget cause une hausse des ventes.

> **TIP:**
>
> 1.  Description : commencer par un tableau ou un graphique par succursale.
> 2.  Association : produire un nuage de points et ajuster un modèle si la forme le justifie.
> 3.  Prédiction : vérifier la plage observée avant d’utiliser un modèle pour un nouveau cas.
> 4.  Causalité : une simple régression observationnelle ne suffit pas; il faudrait un plan d’analyse permettant de soutenir une conclusion causale.

## Exercice 2 - Diagnostic minimal

Avec `campagnes`, produisez un diagnostic minimal avant toute modélisation :

- nombre de lignes et de colonnes;
- unité d’observation;
- variables principales;
- valeurs manquantes;
- graphique de départ.

``` r
dim(campagnes)
glimpse(campagnes)

campagnes |>
  summarise(across(everything(), ~ sum(is.na(.x)))) |>
  pivot_longer(
    cols = everything(),
    names_to = "variable",
    values_to = "nb_manquantes"
  )

ggplot(campagnes, aes(x = budget_marketing, y = ventes)) +
  geom_point() +
  theme_minimal()
```

> **TIP:**
>
> Une bonne réponse nomme l’unité d’observation avant de commenter les résultats. Elle précise ensuite que `ventes` est la variable réponse et que `budget_marketing` est une variable explicative possible. Le graphique sert à vérifier la forme de la relation avant d’ajuster une droite.

## Exercice 3 - Réponse descriptive courte

À partir de `campagnes`, produisez un résumé des ventes par région et rédigez une réponse descriptive de quatre phrases maximum.

``` r
ventes_region <- campagnes |>
  group_by(region) |>
  summarise(
    ventes_moyennes = mean(ventes, na.rm = TRUE),
    ventes_medianes = median(ventes, na.rm = TRUE),
    nb_observations = n(),
    .groups = "drop"
  ) |>
  arrange(desc(ventes_moyennes))

ventes_region
```

> **TIP:**
>
> La réponse doit rester descriptive. Elle peut comparer les ventes moyennes entre régions, mais elle ne doit pas conclure qu’une région cause de meilleures ventes. Elle doit mentionner la variable résumée, le regroupement utilisé et une limite de l’interprétation.

## Exercice 4 - Interpréter une pente

Ajustez une régression linéaire simple avec `campagnes`, puis rédigez une interprétation de la pente pour une hausse de 1 000 dollars de budget marketing.

``` r
modele_campagnes <- lm(ventes ~ budget_marketing, data = campagnes)

coef(modele_campagnes)["budget_marketing"] * 1000
summary(modele_campagnes)
```

> **TIP:**
>
> La phrase doit indiquer qu’une hausse de 1 000 dollars du budget marketing est associée à une variation moyenne estimée des ventes, selon le modèle ajusté. Elle doit éviter de dire que le budget cause nécessairement cette variation.

## Exercice 5 - Choisir entre deux modèles

Avec `saturation`, comparez un modèle linéaire et un modèle quadratique. Votre réponse doit utiliser au moins deux critères parmi les suivants : graphique, `R²`, RMSE, résidus, interprétation, extrapolation.

``` r
modele_lineaire <- lm(ventes ~ achalandage, data = saturation)

modele_quadratique <- lm(
  ventes ~ achalandage + I(achalandage^2),
  data = saturation
)

rmse <- function(modele) {
  sqrt(mean(residuals(modele)^2))
}

tibble(
  modele = c("Linéaire", "Quadratique"),
  r2 = c(
    summary(modele_lineaire)$r.squared,
    summary(modele_quadratique)$r.squared
  ),
  rmse = c(rmse(modele_lineaire), rmse(modele_quadratique))
)
```

> **TIP:**
>
> Une comparaison solide ne repose pas sur un seul chiffre. Le modèle retenu doit être appuyé par la forme du graphique, la taille des erreurs, les résidus et l’interprétation dans le contexte de saturation. Une limite d’extrapolation doit être mentionnée.

## Exercice 6 - Mini-réponse complète

Rédigez une réponse de six à huit lignes à partir de cette situation :

> Une succursale veut savoir si l’achalandage est associé aux ventes mensuelles. Le graphique montre une relation positive avec un léger ralentissement aux niveaux élevés d’achalandage. Le modèle quadratique réduit la RMSE par rapport au modèle linéaire. Les résidus du modèle quadratique ne montrent pas de structure évidente.

Votre réponse doit contenir :

- la question reformulée;
- la méthode utilisée;
- le résultat principal;
- un diagnostic ou une justification du modèle;
- une limite.

> **TIP:**
>
> Une réponse complète doit dire que la question porte sur l’association entre achalandage et ventes. Elle doit expliquer que la relation observée est positive, mais qu’elle semble ralentir aux niveaux élevés. Le modèle quadratique est défendable si la RMSE est plus faible et si les résidus ne montrent pas de structure évidente. La conclusion doit rester prudente : le modèle ne prouve pas que l’achalandage cause les ventes, et les prédictions hors de la plage observée seraient fragiles.
