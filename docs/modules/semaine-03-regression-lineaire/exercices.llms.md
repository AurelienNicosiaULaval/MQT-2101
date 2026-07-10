# Exercices - Module 03

## Objectif

Ces exercices servent à pratiquer la régression linéaire simple avec les données du module. Essayez chaque question avant d’ouvrir la solution.

## Préparation

``` r
library(tidyverse)

data_path <- "modules/semaine-03-regression-lineaire/data/campagnes_marketing_quebec.csv"
campagnes <- read_csv(data_path, show_col_types = FALSE)
```

## Exercice 1 - Identifier les variables

Pour la question « Les ventes moyennes sont-elles plus élevées lorsque le budget marketing est plus élevé? », identifiez :

- la variable réponse;
- la variable explicative;
- l’unité d’observation;
- une limite possible de l’analyse.

> **TIP:**
>
> La variable réponse est `ventes`. La variable explicative principale est `budget_marketing`. L’unité d’observation est une combinaison mois-région. Une limite importante est que l’association observée ne prouve pas que le budget cause directement les ventes, car d’autres facteurs peuvent intervenir.

## Exercice 2 - Nuage de points

Produisez un nuage de points des ventes selon le budget marketing. Ajoutez une droite de régression.

``` r
ggplot(campagnes, aes(x = budget_marketing, y = ventes)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "Ventes selon le budget marketing",
    x = "Budget marketing",
    y = "Ventes"
  ) +
  theme_minimal()
```

> **TIP:**
>
> Le graphique doit montrer la direction générale de la relation. Ici, on s’attend à une association positive. Avant de commenter les coefficients, il faut vérifier que la relation semble raisonnablement linéaire.

## Exercice 3 - Ajuster le modèle

Ajustez le modèle suivant :

``` r
modele <- lm(ventes ~ budget_marketing, data = campagnes)
summary(modele)
```

Interprétez la pente en une phrase.

> **TIP:**
>
> La pente décrit la variation moyenne estimée des ventes lorsque le budget marketing augmente d’une unité. Comme l’unité est le dollar, il est souvent plus clair de multiplier la pente par 1 000 pour interpréter une hausse de budget de 1 000 dollars.
>
> ``` r
> coef(modele)["budget_marketing"] * 1000
> ```

## Exercice 4 - Examiner les résidus

Créez une colonne de valeurs prédites et une colonne de résidus. Produisez un graphique des résidus selon les valeurs prédites.

``` r
campagnes_modele <- campagnes |>
  mutate(
    ventes_predites = predict(modele),
    residu = residuals(modele)
  )

ggplot(campagnes_modele, aes(x = ventes_predites, y = residu)) +
  geom_hline(yintercept = 0) +
  geom_point() +
  labs(
    title = "Résidus selon les ventes prédites",
    x = "Ventes prédites",
    y = "Résidu"
  ) +
  theme_minimal()
```

> **TIP:**
>
> On cherche des résidus répartis autour de zéro, sans structure forte. Un motif en courbe, une dispersion qui augmente ou quelques points très éloignés signaleraient que le modèle simple mérite d’être questionné.

## Exercice 5 - Conclusion courte

Rédigez une conclusion de quatre phrases :

1.  question étudiée;
2.  direction de la relation;
3.  interprétation de la pente;
4.  limite de l’analyse.

> **TIP:**
>
> Une réponse acceptable doit éviter de conclure trop vite à la causalité. Elle peut dire que les ventes sont positivement associées au budget marketing dans le jeu de données, que la pente quantifie cette association moyenne et que d’autres variables pourraient aussi expliquer les ventes.

## Exercice 6 - Mini-trace finale

Préparez une mini-trace finale qui tient en un court paragraphe et qui pourrait être relue sans voir votre code. Elle doit contenir :

- la question d’analyse;
- le sens de la relation observée dans le graphique;
- l’interprétation de la pente avec les unités;
- une phrase sur les résidus ou la qualité d’ajustement;
- une limite causale.

> **TIP:**
>
> Une mini-trace acceptable ne cherche pas à tout dire. Elle doit montrer que vous avez compris la question, le modèle et sa limite. Elle peut par exemple dire que les ventes sont plus élevées, en moyenne, lorsque le budget marketing est plus élevé, que la pente mesure cette association moyenne, que les résidus ne signalent pas de problème majeur pour une première analyse et que le modèle ne prouve pas à lui seul un effet causal du budget.
