# Gabarit du mini-rapport 1

# Gabarit du mini-rapport 1

Ce gabarit soutient une analyse reproductible centrée sur la préparation des données, l'exploration, la visualisation, la régression et l'interprétation.

[Structure attendue](#structure) [Modèle .qmd](#modele-qmd) [Déclaration IA](declaration-ia.llms.md) [Grille](../evaluations/grille-mini-rapports.llms.md)

01

Question et données

02

Préparation et exploration

03

Visualisation et régression

04

Interprétation et limites

## Structure attendue

Le mini-rapport doit montrer une démarche courte, claire et défendable.

1.  01

    ### Question

    Définir ce que l'analyse cherche à éclairer.

2.  02

    ### Données

    Présenter la source, l'unité d'observation, les variables et les limites.

3.  03

    ### Analyse

    Préparer, explorer, visualiser et ajuster une régression pertinente.

4.  04

    ### Conclusion

    Interpréter avec prudence et nommer les limites.

## Flux de travail recommandé

Travaillez dans Quarto dès le début pour éviter de reconstruire le rapport à la fin.

### Choisir une question précise

La question doit pouvoir être étudiée avec les variables disponibles.

### Nettoyer seulement ce qui est nécessaire

Documentez les transformations importantes et leur justification.

### Interpréter en unités réelles

Les coefficients de régression doivent être traduits dans le contexte du problème.

## Modèle .qmd

Ce modèle peut être adapté au jeu de données de votre équipe.

mini-rapport-1.qmd

    ---
    title: "Mini-rapport 1"
    author: "Équipe : à compléter"
    format:
      html:
        embed-resources: true
    execute:
      warning: false
      message: false
    ---

    ## Identification

    - Équipe :
    - Membres :
    - Jeu de données :
    - Date :

    ## Contribution de l'équipe

    - Membre 1 :
    - Membre 2 :
    - Membre 3, si applicable :

    ## Question d'analyse

    Formuler la question que l'analyse vise à éclairer.

    ## Données

    Décrire l'origine, le droit d'utilisation, l'unité d'observation, les variables principales,
    les contrôles de qualité et les limites connues.

    ```{r}
    # Load libraries
    library(tidyverse)
    library(janitor)
    library(broom)

    # Import data
    donnees_brutes <- read_csv("data/votre_fichier.csv", show_col_types = FALSE)

    # Clean data
    donnees <- donnees_brutes |>
      clean_names()

    glimpse(donnees)
    ```

    ## Préparation

    Décrire les transformations importantes.

    ```{r}
    donnees_analyse <- donnees |>
      filter(!is.na(variable_y), !is.na(variable_x))
    ```

    ## Exploration descriptive

    ```{r}
    donnees_analyse |>
      summarise(
        n = n(),
        moyenne_y = mean(variable_y, na.rm = TRUE),
        mediane_y = median(variable_y, na.rm = TRUE),
        ecart_type_y = sd(variable_y, na.rm = TRUE)
      )
    ```

    ## Visualisation

    ```{r}
    donnees_analyse |>
      ggplot(aes(x = variable_x, y = variable_y)) +
      geom_point() +
      geom_smooth(method = "lm", se = FALSE) +
      labs(
        title = "Relation entre variable_x et variable_y",
        x = "Variable explicative",
        y = "Variable réponse"
      ) +
      theme_minimal()
    ```

    ## Régression

    ```{r}
    modele <- lm(variable_y ~ variable_x, data = donnees_analyse)

    tidy(modele)
    glance(modele)
    ```

    Comparer le modèle principal à un modèle simple de référence et présenter au moins un diagnostic des résidus.

    ## Interprétation

    Interpréter le résultat principal en langage clair.

    ## Recommandation ou conclusion

    Relier la conclusion à la question de départ.

    ## Limites

    Nommer au moins deux limites de l'analyse.

    ## Déclaration d'usage de l'IA

    Compléter la déclaration si l'IA a influencé le livrable. Sinon, écrire explicitement qu'aucun usage d'IA n'a influencé le code, l'analyse, l'interprétation, la documentation ou le texte.

## Vérification finale

Avant la remise, chaque élément ci-dessous devrait être vérifié par l'équipe.

### Le rapport se rend

Le fichier HTML final est produit sans erreur.

### La question est claire

La conclusion répond à la question annoncée.

### Le code est minimal

Le rapport contient le code nécessaire, sans blocs inutiles.

### La régression est interprétée

Les coefficients importants sont expliqués en unités concrètes.

### Les limites sont présentes

Les limites des données et de la méthode sont nommées.

### L'IA est déclarée

La déclaration est complétée si l'aide reçue a influencé le livrable.
