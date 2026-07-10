# Aide-mémoire modélisation

# Aide-mémoire modélisation

Un modèle sert à éclairer une question. La méthode vient après la compréhension des données, de la variable réponse, du contexte et de la décision à soutenir.

[Démarche](#demarche) [Choisir le modèle](#choisir) [Valider](#valider)

01

Définir la question et la décision

02

Préparer les données et la variable réponse

03

Ajuster un modèle adapté

04

Valider, interpréter et communiquer

## Démarche commune

Cette séquence s'applique aux régressions, aux prévisions et aux modèles pour résultats binaires.

1.  01
    ### Formuler la question

    Décrire ce qu'il faut expliquer, prévoir ou comparer, et pourquoi cette question est utile.
2.  02
    ### Identifier la variable réponse

    Préciser l'unité, l'échelle, la fréquence temporelle et les valeurs possibles.
3.  03
    ### Préparer les variables utiles

    Nettoyer, transformer, coder les catégories et vérifier les valeurs manquantes.
4.  04
    ### Ajuster un modèle

    Choisir une méthode cohérente avec la réponse, les données et la question.
5.  05
    ### Valider

    Examiner les diagnostics, la performance et les limites avant de conclure.
6.  06
    ### Communiquer

    Relier le résultat à la décision et dire ce que le modèle ne permet pas d'affirmer.

## Choisir le bon type de modèle

Le choix dépend d'abord de la variable réponse et du type de question.

### Régression

Variable réponse numérique, comme ventes, coûts, temps d'attente, satisfaction ou quantité produite.

Association Interprétation Prédiction

### Séries chronologiques

Données ordonnées dans le temps, avec tendance, saisonnalité, autocorrélation ou horizon de prévision.

Temps Prévision Validation temporelle

### Classification

Variable réponse catégorielle ou binaire, comme achat oui/non, défaut oui/non ou départ client oui/non.

Probabilité Seuil Performance

## Valider avant d'interpréter

La validation dépend du modèle, mais l'idée générale reste la même : vérifier si le modèle est suffisamment fiable pour soutenir la conclusion proposée.

### Régression

Regarder les résidus, les valeurs atypiques, la forme de la relation et la cohérence des coefficients.

### Prévision

Comparer les prévisions à des observations gardées pour validation et choisir une mesure d'erreur adaptée.

### Classification

Examiner la matrice de confusion, la sensibilité, la spécificité ou une autre mesure cohérente avec la décision.

## Patron R général

Ce patron ne remplace pas le choix méthodologique. Il donne seulement une structure reproductible pour garder l'analyse lisible.

Structure

    # Load libraries
    library(tidyverse)
    library(broom)

    # Prepare data
    donnees_modelisation <- donnees |>
      filter(!is.na(y), !is.na(x1), !is.na(x2))

    # Fit model
    modele <- lm(y ~ x1 + x2, data = donnees_modelisation)

    # Validate and interpret
    tidy(modele)
    glance(modele)
    augment(modele)

## Conclusion prudente

Une conclusion de modélisation doit rester alignée sur la qualité des données et la méthode utilisée.

### Ce que le modèle indique

Présenter le résultat principal en unités compréhensibles.

### Ce que cela suggère

Relier le résultat à une décision, une comparaison ou une action possible.

### Ce qu'il faut vérifier

Nommer les limites, hypothèses, données manquantes ou risques d'interprétation.
