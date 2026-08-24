# Exercices - Module 05

## Objectif

Vérifier l’autonomie avant l’examen avec un cas qui n’est utilisé dans aucune capsule de préparation. Plusieurs questions contiennent volontairement une erreur de raisonnement ou de méthode à repérer.

Jeu de données de transfert : [ventes_pme_quebec.csv](../../donnees/#ventes-mensuelles-dune-pme-québécoise-fictive).

## Préparation

``` r
library(tidyverse)
library(broom)

data_path <- if (file.exists("../atelier-01-r/data/ventes_pme_quebec.csv")) {
  "../atelier-01-r/data/ventes_pme_quebec.csv"
} else {
  "modules/atelier-01-r/data/ventes_pme_quebec.csv"
}

pme <- read_csv(
  data_path,
  show_col_types = FALSE
) |>
  mutate(mois = as.Date(mois))
```

## Exercice 1 - Identifier la question

Pour chaque demande, indiquez le type de question et la première production pertinente. Les quatre réponses ne doivent pas être identiques.

1.  Comparer le taux de retour médian entre les saisons.
2.  Étudier l’association entre le nombre de clients et les ventes.
3.  Prévoir les ventes d’une succursale pour un volume de clients donné.
4.  Affirmer qu’une réduction du délai de livraison augmentera la satisfaction.

Pour la quatrième demande, expliquez pourquoi le fichier seul ne permet pas de répondre comme si une intervention avait été réalisée.

## Exercice 2 - Diagnostic minimal

Une personne commence son analyse avec ce code :

``` r
pme_incomplete <- pme |>
  drop_na() |>
  select(ventes, clients, satisfaction)

summary(pme_incomplete)
```

Repérez au moins quatre informations perdues ou décisions non justifiées. Proposez ensuite un diagnostic minimal qui conserve les dates, les groupes et le détail des valeurs manquantes avant toute suppression.

``` r
diagnostic_manquants <- pme |>
  summarise(across(everything(), ~ sum(is.na(.x)))) |>
  pivot_longer(
    cols = everything(),
    names_to = "variable",
    values_to = "valeurs_manquantes"
  ) |>
  arrange(desc(valeurs_manquantes))

diagnostic_manquants
```

## Exercice 3 - Réponse descriptive courte

Comparez `taux_retour` selon `saison` en utilisant une médiane, un intervalle interquartile et le nombre d’observations.

``` r
retours_saison <- pme |>
  group_by(saison) |>
  summarise(
    observations = n(),
    mediane = median(taux_retour, na.rm = TRUE),
    q1 = quantile(taux_retour, 0.25, na.rm = TRUE),
    q3 = quantile(taux_retour, 0.75, na.rm = TRUE),
    .groups = "drop"
  )

retours_saison
```

Rédigez une réponse de quatre phrases : question, méthode, constat et limite.

## Exercice 4 - Interpréter une pente

Ajustez `ventes ~ clients` et interprétez la pente pour 100 clients supplémentaires.

``` r
modele_clients <- lm(ventes ~ clients, data = pme)

tidy(modele_clients, conf.int = TRUE)
coef(modele_clients)[["clients"]] * 100
```

Ajoutez une phrase expliquant pourquoi l’augmentation du nombre de clients ne peut pas être isolée de la taille de la succursale ou du panier moyen dans cette analyse simple.

## Exercice 5 - Choisir entre deux modèles

Comparez une droite et une courbe quadratique pour la relation entre clients et ventes. Le modèle complexe doit être rejeté si son gain hors échantillon est négligeable.

``` r
entrainement <- pme |>
  filter(mois < max(mois))

test <- pme |>
  filter(mois == max(mois))

modele_simple <- lm(ventes ~ clients, data = entrainement)
modele_courbe <- lm(ventes ~ clients + I(clients^2), data = entrainement)

rmse <- function(observe, predit) {
  sqrt(mean((observe - predit)^2, na.rm = TRUE))
}

tibble(
  modele = c("Simple", "Quadratique"),
  RMSE_test = c(
    rmse(test$ventes, predict(modele_simple, newdata = test)),
    rmse(test$ventes, predict(modele_courbe, newdata = test))
  )
)
```

Justifiez le choix avec la RMSE, la forme graphique et l’interprétabilité.

## Exercice 6 - Mini-réponse complète

Corrigez la réponse suivante sans dépasser huit lignes :

> Le modèle quadratique est forcément meilleur parce qu’il contient plus de termes. Il prouve que l’ajout de clients augmente les ventes. On peut donc l’utiliser pour n’importe quelle taille de succursale.

La version corrigée doit contenir la question, les modèles comparés, le résultat hors échantillon, une limite causale et une limite d’extrapolation.
