# Guide RStudio

# Faire ses premiers pas dans RStudio

Commencez par le [guide d'installation pas à pas](../installation.llms.md) si R et RStudio ne sont pas encore prêts. Cette page vous aide ensuite à retrouver les boutons utilisés dans les capsules.

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
    ### Créer ou rouvrir votre projet

    À la capsule 3, choisissez File \> New Project \> New Directory \> New Project. Nommez le dossier `projet-semaine-02`, choisissez son emplacement avec Browse, puis cliquez sur Create Project. Aux séances suivantes, rouvrez le fichier `projet-semaine-02.Rproj` dans ce dossier.
2.  02
    ### Créer un fichier de travail

    Pour le rapport du module 2 : File \> New File \> Quarto Document, choisissez HTML, puis Create. Enregistrez le fichier sous le nom `rapport_semaine_02.qmd`, dans le même dossier que le fichier `.Rproj`. Pour un script R : File \> New File \> R Script.
3.  03
    ### Exécuter le code du haut vers le bas

    Dans un script R, cliquez sur une ligne, puis sur Run pour l'exécuter. Dans un document Quarto, utilisez le triangle à droite du bloc R. Relancez les blocs dans l'ordre, du haut vers le bas. Le bouton Render exécute tout le document pour produire le rapport.
4.  04
    ### Vérifier les objets créés

    Après une importation ou une transformation, inspectez les données avec `glimpse()`, `count()` ou `summary()`.

## Charger les extensions déjà installées

Une extension, ou package, doit être installée une fois, puis chargée à chaque nouvelle séance avec `library(...)`. Pour l'installation par les menus, suivez [l'étape 3 du guide](../installation.llms.md#packages-title). Placez les lignes ci-contre au début de votre script ou du premier bloc R de votre rapport.

Console R

    library(tidyverse)
    library(janitor)
    library(lubridate)
    library(scales)

## Un premier script à exécuter

Cliquez sur File \> New File \> R Script. Copiez le code ci-contre dans le document, sélectionnez-le, puis cliquez sur Run. Il utilise trois valeurs fictives; aucun fichier de données n'est nécessaire. Vous devez obtenir une moyenne d’environ 128 167.

Fichier analyse.R

    # Charger les fonctions nécessaires.
    library(tidyverse)

    # Créer trois valeurs fictives pour essayer R.
    ventes <- tibble(
      montant = c(125000, 131000, 128500)
    )

    # Calculer la moyenne.
    ventes |>
      summarise(moyenne = mean(montant))

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
