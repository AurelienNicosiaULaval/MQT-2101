# Gabarit du mini-rapport 2

# Gabarit du mini-rapport 2

Ce gabarit soutient une analyse reproductible selon une voie de prévision temporelle ou de classification binaire, avec validation hors échantillon et décision.

[Structure attendue](#structure) [Modèle .qmd](#modele-qmd) [Déclaration IA](declaration-ia.llms.md) [Grille](../evaluations/grille-mini-rapports.llms.md)

01

Question et horizon

02

Structure temporelle ou prédictive

03

Méthode et validation

04

Interprétation et limites

## Structure attendue

Le mini-rapport doit expliquer ce qui est prévu, comment la performance est évaluée et ce que la prévision permet de décider.

1.  01

    ### Question

    Définir la cible, l'horizon et la décision à soutenir.

2.  02

    ### Données

    Présenter la fréquence, la période couverte, les variables et les limites.

3.  03

    ### Validation

    Comparer le modèle à des données non utilisées de la même manière.

4.  04

    ### Conclusion

    Relier la performance et la prévision à une décision prudente.

## Flux de travail recommandé

Pour une série temporelle, l'ordre des observations fait partie de l'information. La validation doit donc respecter le temps.

### Définir l'horizon

Préciser si la prévision porte sur une semaine, un mois, un trimestre ou une autre période.

### Visualiser la série

Regarder tendance, saisonnalité, rupture possible et valeurs atypiques avant de modéliser.

### Valider avec prudence

Utiliser une période de validation plus récente lorsque la structure temporelle l'exige.

## Modèle .qmd

Ce modèle peut être adapté à une analyse de prévision ou à une autre démarche prédictive indiquée dans la consigne.

mini-rapport-2.qmd

    ---
    title: "Mini-rapport 2"
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

    ## Voie choisie

    Indiquer « prévision temporelle » ou « classification binaire » et justifier ce choix en fonction de la cible et de la décision.

    ## Question d'analyse

    Formuler la cible, l'horizon ou la fenêtre de l'événement, et la décision que l'analyse doit éclairer.

    ## Données

    Décrire l'origine du jeu de données, l'unité d'observation, la fréquence temporelle,
    les variables principales et les limites connues.

    ```{r}
    # Load libraries
    library(tidyverse)
    library(janitor)

    # Import data
    donnees_brutes <- read_csv("data/votre_fichier.csv", show_col_types = FALSE)

    # Clean data
    donnees <- donnees_brutes |>
      clean_names()

    glimpse(donnees)
    ```

    ## Exploration temporelle

    Décrire la structure temporelle : période couverte, fréquence, tendance, saisonnalité et valeurs atypiques.

    ```{r}
    donnees |>
      ggplot(aes(x = date, y = valeur)) +
      geom_line() +
      labs(
        title = "Évolution de la valeur dans le temps",
        x = NULL,
        y = "Valeur"
      ) +
      theme_minimal()
    ```

    ## Méthode

    Présenter la méthode utilisée et justifier le choix.

    ```{r}
    # Exemple minimal à adapter selon la méthode choisie
    donnees_modele <- donnees |>
      arrange(date)
    ```

    ## Validation

    Présenter une séparation hors échantillon. Pour la prévision, respecter l'ordre du temps et comparer une référence simple avec MAE et RMSE. Pour la classification, définir la classe positive et comparer au moins deux seuils avec sensibilité, spécificité, précision et proportion ciblée.

    ```{r}
    # Ajouter le code de validation utilisé par l'équipe
    ```

    ## Interprétation

    Interpréter les résultats en langage clair.

    ## Recommandation ou conclusion

    Relier la conclusion à la question de départ et à l'horizon de décision.

    ## Limites

    Nommer au moins deux limites de l'analyse.

    ## Déclaration d'usage de l'IA

    Compléter la déclaration si l'IA a influencé le livrable. Sinon, écrire explicitement qu'aucun usage d'IA n'a influencé le code, l'analyse, l'interprétation, la documentation ou le texte.

## Vérification finale

Avant la remise, chaque élément ci-dessous devrait être vérifié par l'équipe.

### L'horizon est clair

La cible et la période de prévision sont précisées.

### La série est visualisée

Tendance, saisonnalité et valeurs atypiques sont examinées.

### La validation est cohérente

La mesure d'erreur ou de performance correspond à la question.

### La conclusion est prudente

La recommandation tient compte des limites et de l'incertitude.

### Le rapport se rend

Le fichier HTML final est produit sans erreur.

### L'IA est déclarée

La déclaration est complétée si l'aide reçue a influencé le livrable.
