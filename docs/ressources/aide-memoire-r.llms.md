# Aide-mémoire R

# Aide-mémoire R

Les patrons ci-dessous couvrent les opérations les plus fréquentes du cours : importer, inspecter, transformer, résumer, visualiser et ajuster un modèle simple.

[Importer](#importer) [Transformer](#transformer) [Modéliser](#modeliser)

read

Importer et inspecter

dplyr

Filtrer, créer, grouper et résumer

ggplot

Visualiser les distributions et relations

lm

Ajuster et interpréter un premier modèle

## Importer et inspecter

Commencez par lire le fichier, nettoyer les noms de colonnes et vérifier la structure du tableau.

Importer

    # Load libraries
    library(tidyverse)
    library(janitor)

    # Import data
    donnees <- read_csv("data/fichier.csv", show_col_types = FALSE) |>
      clean_names()

    # Inspect data
    glimpse(donnees)
    summary(donnees)

## Transformer un tableau

Les verbes suivants suffisent pour la majorité des préparations de données du cours.

### Filtrer des lignes

filter()

    donnees_filtrees <- donnees |>
      filter(!is.na(ventes), region == "Quebec")

### Créer des variables

mutate()

    donnees_calculees <- donnees |>
      mutate(
        marge = revenus - couts,
        taux_marge = marge / revenus
      )

### Choisir des colonnes

select()

    donnees_courtes <- donnees |>
      select(date, region, revenus, couts)

## Résumer et comparer

Un résumé doit indiquer la taille du groupe et utiliser `na.rm = TRUE` lorsque des valeurs manquantes sont possibles.

group_by() et summarise()

    resume_region <- donnees |>
      group_by(region) |>
      summarise(
        n = n(),
        revenus_moyens = mean(revenus, na.rm = TRUE),
        revenus_medians = median(revenus, na.rm = TRUE),
        ecart_type = sd(revenus, na.rm = TRUE),
        .groups = "drop"
      ) |>
      arrange(desc(revenus_moyens))

    resume_region

## Visualiser

Un graphique doit servir une question précise : distribution, comparaison, évolution ou relation.

### Distribution

Histogramme

    donnees |>
      ggplot(aes(x = revenus)) +
      geom_histogram(bins = 30) +
      labs(
        title = "Distribution des revenus",
        x = "Revenus",
        y = "Nombre d'observations"
      ) +
      theme_minimal()

### Relation

Nuage de points

    donnees |>
      ggplot(aes(x = publicite, y = ventes)) +
      geom_point() +
      geom_smooth(method = "lm", se = FALSE) +
      labs(
        title = "Relation entre publicité et ventes",
        x = "Dépenses publicitaires",
        y = "Ventes"
      ) +
      theme_minimal()

## Modéliser simplement

Le modèle linéaire sert à décrire une association moyenne entre une variable réponse et une ou plusieurs variables explicatives. Il ne prouve pas automatiquement une relation causale.

Régression linéaire

    # Load libraries
    library(tidyverse)
    library(broom)

    # Fit model
    modele <- lm(ventes ~ publicite + prix, data = donnees)

    # Model outputs
    tidy(modele)
    glance(modele)
    augment(modele)

## Erreurs fréquentes

La correction minimale est souvent très simple si on lit le message d'erreur attentivement.

### Variable mal nommée

Utilisez `names(donnees)` ou `glimpse(donnees)` pour vérifier le nom exact.

### Package non chargé

Ajoutez la ligne `library(package)` au début du script ou du document.

### Valeurs manquantes

Décidez si elles doivent être retirées, imputées ou simplement ignorées dans certains calculs.
