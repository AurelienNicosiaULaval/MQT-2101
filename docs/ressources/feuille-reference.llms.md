# Feuille de référence

# Feuille de référence

Une page à garder ouverte pendant les ateliers et les mini-rapports : questions à poser, code R minimal, interprétation et vérifications finales.

[Questions](#questions) [Code R](#code) [Mini-rapport](#rapport)

Lire

Comprendre ce que représente une ligne du tableau

Coder

Importer, nettoyer, résumer et visualiser

Dire

Interpréter sans dépasser les données

Vérifier

Relire avant de remettre une trace finale

## Avant d'analyser

Ces questions viennent avant le code. Elles évitent de modéliser une question mal définie.

### Données

- Que représente une ligne du tableau?
- Quelle est l'origine du jeu de données?
- Quelles variables sont numériques, catégorielles ou temporelles?
- Quelles valeurs sont manquantes ou suspectes?

### Question

- Quelle variable faut-il expliquer, prévoir ou comparer?
- Quelle décision l'analyse doit-elle éclairer?
- La conclusion sera-t-elle descriptive, prédictive ou causale?
- Quelle limite doit être nommée dès le départ?

## Patron R minimal

Ce code donne la structure générale. Remplacez les noms de fichiers et de variables par ceux de votre analyse.

Analyse courte

    # Load libraries
    library(tidyverse)
    library(janitor)
    library(broom)

    # Import data
    donnees <- read_csv("data/fichier.csv", show_col_types = FALSE) |>
      clean_names()

    # Inspect data
    glimpse(donnees)

    # Summarise
    donnees |>
      summarise(
        n = n(),
        moyenne = mean(variable, na.rm = TRUE),
        mediane = median(variable, na.rm = TRUE),
        ecart_type = sd(variable, na.rm = TRUE)
      )

    # Visualise
    donnees |>
      ggplot(aes(x = variable_x, y = variable_y)) +
      geom_point() +
      geom_smooth(method = "lm", se = FALSE) +
      theme_minimal()

    # Model
    modele <- lm(variable_y ~ variable_x, data = donnees)

    tidy(modele)
    glance(modele)

## Interpréter un résultat

Une interprétation utile suit une structure courte et explicite.

1.  01

    ### Résultat

    Nommer le résultat principal sans jargon inutile.

2.  02

    ### Contexte

    Dire ce que le résultat signifie dans la situation étudiée.

3.  03

    ### Décision

    Expliquer ce que le résultat suggère pour l'action ou la comparaison.

4.  04

    ### Limite

    Indiquer pourquoi la conclusion doit rester prudente.

## Utiliser l'IA avec prudence

Lorsque les consignes l'autorisent, l'IA peut aider à comprendre, déboguer et vérifier. Elle ne remplace pas la compréhension ni la responsabilité de l'équipe.

[Ouvrir le GPT du cours](https://chatgpt.com/g/g-6a0b2ec33d948191ad25b2f247b15de1-analyse-et-modelisation-des-donnees?ref=mini) [Règles IA](ia.llms.md)

### Bonne demande

Voici mon code et mon erreur. Peux-tu expliquer la cause probable et proposer une correction minimale?

### Bonne vérification

Voici mon interprétation. Peux-tu indiquer ce qui est imprécis, trop fort ou non appuyé par les données?

### À éviter

Demander une conclusion complète sans fournir sa propre tentative ni vérifier les résultats.

## Avant de remettre un mini-rapport

La trace finale doit être compréhensible, reproductible et défendable.

### Question et données

La question, la source des données, l'unité d'observation et les variables principales sont indiquées.

### Code reproductible

Le document se rend sans erreur, les bibliothèques sont chargées et les chemins fonctionnent.

### Interprétation prudente

La conclusion distingue description, association, prédiction et causalité.

### Limites

Au moins une limite importante des données, de la méthode ou de l'interprétation est nommée.

### IA déclarée

Si l'IA a influencé le livrable, la déclaration est complète et honnête.

### Résultat final

Les tableaux, graphiques et conclusions correspondent à la question de départ.

## Prévision temporelle

Avant le modèle, préciser cible, fréquence, origine, horizon et décision.

### Validation

- Entraînement avant test.
- Même période test pour toutes les méthodes.
- Référence naïve ou saisonnière.
- Aucune variable future indisponible.

### Mesures

- Erreur = observé - prévu.
- MAE : erreur absolue moyenne.
- RMSE : sensible aux grandes erreurs.
- Biais positif : sous-prévision moyenne.

## Classification binaire

Définir la classe positive avant de calculer les mesures.

### Matrice

- VP : positif correctement détecté.
- FP : intervention inutile.
- VN : négatif correctement écarté.
- FN : positif manqué.

### Mesures

- Sensibilité = VP / (VP + FN).
- Spécificité = VN / (VN + FP).
- Précision = VP / (VP + FP).
- Le seuil dépend du coût et de la capacité.
