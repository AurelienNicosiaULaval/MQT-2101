# Exercices - Semaine 02

## Objectif

Créer un rapport Quarto reproductible à partir d’un nouveau cas. Les capsules utilisent `ventes_operations_quebec.csv`; les exercices utilisent plutôt les ventes mensuelles d’une PME fictive et portent sur la qualité opérationnelle.

Jeu de données de transfert : [ventes_pme_quebec.csv](../../donnees/#ventes-mensuelles-dune-pme-québécoise-fictive).

## Exercice 1 - Créer le projet et importer les données

Créez un projet distinct nommé `diagnostic-retours-pme`, ajoutez un dossier `data`, puis importez le fichier.

``` r
library(tidyverse)
library(janitor)

ventes_pme <- read_csv(
  "data/ventes_pme_quebec.csv",
  show_col_types = FALSE
) |>
  clean_names() |>
  mutate(mois = as.Date(mois))

glimpse(ventes_pme)
```

À faire :

- vérifier les dimensions du tableau;
- confirmer que chaque ligne correspond à une succursale pour un mois;
- vérifier l’étendue des dates;
- rédiger une phrase expliquant pourquoi le chemin relatif rend le projet plus facile à partager.

## Exercice 2 - Identifier les types de variables

Classez `mois`, `saison`, `succursale`, `campagne_locale`, `clients`, `delai_livraison_jours`, `satisfaction` et `taux_retour`.

Ajoutez ensuite deux décisions de préparation :

- quelles variables convertir en facteurs;
- quelles variables conserver numériques même si elles prennent peu de valeurs.

Votre justification doit s’appuyer sur le sens des variables, et non seulement sur leur apparence dans R.

## Exercice 3 - Repérer les valeurs manquantes

Produisez un audit qui donne à la fois le nombre et la proportion de valeurs manquantes.

``` r
audit_manquants <- ventes_pme |>
  summarise(
    across(
      everything(),
      list(
        nombre = ~ sum(is.na(.x)),
        proportion = ~ mean(is.na(.x))
      )
    )
  ) |>
  pivot_longer(
    cols = everything(),
    names_to = c("variable", ".value"),
    names_pattern = "(.*)_(nombre|proportion)$"
  ) |>
  filter(nombre > 0)

audit_manquants
```

Expliquez pourquoi supprimer toutes les lignes incomplètes pourrait modifier plus d’une analyse, même si une seule variable est étudiée au départ.

## Exercice 4 - Produire un tableau descriptif

La question est maintenant : « Les retours et les délais sont-ils plus élevés pendant la haute saison? »

``` r
resume_saison <- ventes_pme |>
  group_by(saison) |>
  summarise(
    observations = n(),
    taux_retour_median = median(taux_retour, na.rm = TRUE),
    delai_median = median(delai_livraison_jours, na.rm = TRUE),
    satisfaction_mediane = median(satisfaction, na.rm = TRUE),
    .groups = "drop"
  )

resume_saison
```

Rédigez deux constats descriptifs et une limite. Ne transformez pas la saison en explication causale.

## Exercice 5 - Produire un graphique

Choisissez un seul des deux graphiques suivants selon la question posée :

1.  comparer la distribution du taux de retour entre les saisons;
2.  étudier la relation entre le délai de livraison et la satisfaction.

``` r
graphique_saisons <- ggplot(
  ventes_pme,
  aes(x = saison, y = taux_retour)
) +
  geom_boxplot(fill = "#0B4F6C", alpha = 0.8) +
  labs(x = NULL, y = "Taux de retour") +
  theme_minimal(base_size = 12)

graphique_service <- ventes_pme |>
  filter(!is.na(delai_livraison_jours), !is.na(satisfaction)) |>
  ggplot(aes(x = delai_livraison_jours, y = satisfaction)) +
  geom_point(aes(colour = saison), alpha = 0.8) +
  labs(
    x = "Délai de livraison, en jours",
    y = "Satisfaction",
    colour = "Saison"
  ) +
  theme_minimal(base_size = 12)
```

Présentez le graphique choisi, justifiez votre choix en une phrase et écrivez un constat qui ne répète pas simplement le titre.

## Trace finale courte

Produisez un mini-rapport Quarto sur la qualité opérationnelle contenant :

- le code d’importation et une vérification des dimensions;
- un audit des valeurs manquantes;
- le tableau par saison;
- un graphique choisi en fonction d’une question précise;
- deux constats, une limite et une prochaine vérification.

Le rapport ne doit reprendre ni le fichier, ni le tableau par succursale, ni le graphique par canal utilisés dans les capsules.

## Modèle de solution cachée à utiliser

Les solutions détaillées restent dans la page réservée aux solutions. Avant de la consulter, le fichier `.qmd` de l’étudiant doit se rendre sans erreur du début à la fin.
