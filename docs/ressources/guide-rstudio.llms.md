# Guide RStudio ou Positron

# Travailler dans RStudio ou Positron

Le but est de garder un environnement de travail propre : fichiers au bon endroit, code facile à relancer et erreurs plus faciles à comprendre.

[Routine de travail](#routine) [Guide Quarto](guide-quarto.llms.md) [Aide-mémoire R](aide-memoire-r.llms.md)

01

Ouvrir le bon dossier de travail

02

Exécuter un script R

03

Installer et charger des packages

04

Lire les messages d'erreur

## Routine de travail

Cette séquence évite la majorité des problèmes de chemins, de fichiers introuvables et de code non reproductible.

1.  01
    ### Ouvrir le dossier du cours

    Ouvrez le dossier qui contient les fichiers du cours avant de lancer votre script ou votre document Quarto.
2.  02
    ### Créer un fichier de travail

    Utilisez un script `.R` pour explorer ou un fichier `.qmd` pour produire une trace reproductible.
3.  03
    ### Exécuter le code du haut vers le bas

    Relancez les bibliothèques, l'importation, le nettoyage, les graphiques et les modèles dans l'ordre.
4.  04
    ### Vérifier les objets créés

    Après une importation ou une transformation, inspectez les données avec `glimpse()`, `count()` ou `summary()`.

## Packages

Un package doit être installé une seule fois sur l'ordinateur, puis chargé à chaque nouvelle session. Les scripts et rapports doivent toujours charger explicitement les bibliothèques utilisées.

Console R

    install.packages("tidyverse")
    install.packages("janitor")

    library(tidyverse)
    library(janitor)

## Script minimal

Un bon script garde toujours les mêmes blocs : bibliothèques, importation, inspection, préparation, analyse et interprétation.

Fichier analyse.R

    # Load libraries
    library(tidyverse)
    library(janitor)

    # Import data
    donnees <- read_csv("data/fichier.csv", show_col_types = FALSE) |>
      clean_names()

    # Inspect data
    glimpse(donnees)

    # Summarise
    donnees |>
      summarise(
        n = n(),
        moyenne = mean(variable, na.rm = TRUE)
      )

## Lire une erreur sans paniquer

Une erreur donne souvent l'indice exact du problème. Commencez par la première ligne du message.

### `object not found`

Un objet n'existe pas dans la session. Relancez les blocs précédents ou vérifiez l'orthographe du nom.

### `could not find function`

Le package qui contient la fonction n'est pas chargé. Ajoutez ou relancez `library(nom_du_package)`.

### `file does not exist`

Le chemin vers le fichier est incorrect ou le dossier de travail n'est pas le bon.

## Avant de demander de l'aide

Une demande claire accélère beaucoup le dépannage.

### Inclure le message d'erreur complet

Copiez le texte exact de l'erreur, sans reformulation.

### Montrer le code minimal

Incluez seulement les lignes nécessaires pour reproduire le problème.

### Décrire le résultat attendu

Expliquez ce que le code devait produire : tableau, graphique, modèle ou rendu Quarto.
