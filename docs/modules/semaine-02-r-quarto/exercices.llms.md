# Exercices - Semaine 02

## Objectif

Créer un premier rapport Quarto reproductible à partir d’un tableau de données d’affaires.

Chaque exercice produit un élément de la trace finale courte. L’objectif n’est pas de faire cinq productions séparées, mais de construire progressivement le mini-rapport Quarto de la semaine 02.

## Exercice 1 - Créer le projet et importer les données

Fichier : [ventes_operations_quebec.csv](../../donnees/#ventes-et-opérations-de-succursales-québécoises).

``` r
library(tidyverse)
library(janitor)

data_path <- if (file.exists("data/ventes_operations_quebec.csv")) {
  "data/ventes_operations_quebec.csv"
} else {
  "modules/semaine-02-r-quarto/data/ventes_operations_quebec.csv"
}

ventes_operations <- readr::read_csv(
  data_path,
  show_col_types = FALSE
) |>
  clean_names()

glimpse(ventes_operations)
```

À faire :

- créer un projet R;
- placer le fichier dans le dossier `data`;
- importer le fichier;
- vérifier le nombre de lignes et de colonnes;
- nommer l’unité d’observation.

## Exercice 2 - Identifier les types de variables

Classer les variables suivantes :

- `mois`;
- `succursale`;
- `region`;
- `campagne_locale`;
- `canal_principal`;
- `clients`;
- `panier_moyen`;
- `ventes`;
- `satisfaction`.

À faire :

- distinguer variables numériques, catégorielles et dates;
- factoriser les variables catégorielles;
- expliquer pourquoi cette étape est utile.

## Exercice 3 - Repérer les valeurs manquantes

``` r
ventes_operations |>
  summarise(across(everything(), \(x) sum(is.na(x)))) |>
  pivot_longer(
    cols = everything(),
    names_to = "variable",
    values_to = "valeurs_manquantes"
  ) |>
  filter(valeurs_manquantes > 0)
```

À faire :

- nommer les variables incomplètes;
- expliquer une conséquence possible sur le diagnostic;
- indiquer comment signaler ce problème dans un rapport.

## Exercice 4 - Produire un tableau descriptif

``` r
ventes_operations |>
  group_by(succursale) |>
  summarise(
    ventes_totales = sum(ventes, na.rm = TRUE),
    clients_totaux = sum(clients, na.rm = TRUE),
    satisfaction_moyenne = mean(satisfaction, na.rm = TRUE),
    .groups = "drop"
  )
```

À faire :

- produire un tableau par succursale;
- interpréter deux résultats;
- nommer une limite.

## Exercice 5 - Produire un graphique

``` r
ventes_operations |>
  group_by(canal_principal) |>
  summarise(
    ventes_totales = sum(ventes, na.rm = TRUE),
    .groups = "drop"
  ) |>
  ggplot(aes(ventes_totales, canal_principal)) +
  geom_col() +
  labs(
    title = "Ventes par canal principal",
    x = "Ventes",
    y = NULL
  )
```

À faire :

- ajouter un titre clair;
- vérifier les axes;
- écrire un constat descriptif.

## Trace finale courte

Produire un mini-rapport Quarto contenant :

- une courte introduction;
- le code d’importation;
- une inspection du tableau;
- un diagnostic des valeurs manquantes;
- un tableau descriptif;
- un graphique;
- deux constats descriptifs;
- une question que vous aimeriez approfondir.

## Modèle de solution cachée à utiliser

Les solutions doivent rester cachées par défaut pour encourager une vraie tentative avant consultation.

> **TIP:**
>
> La solution détaillée sera ajoutée dans le fichier de solution hors rendu public après la séance.
>
> ``` r
> # Les solutions publiques ne sont pas affichées dans cette page.
> ```
