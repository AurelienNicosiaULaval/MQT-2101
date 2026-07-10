# Guide Quarto

# Produire un rapport Quarto

Quarto permet de combiner texte, code R, tableaux, graphiques et interprétation dans un même document. C'est le format recommandé pour les mini-rapports.

[Structure minimale](#structure) [Mini-rapport 1](gabarit-mini-rapport-1.llms.md) [Mini-rapport 2](gabarit-mini-rapport-2.llms.md)

01

Créer un fichier .qmd

02

Écrire texte et code dans le même document

03

Rendre le document en HTML

04

Vérifier le résultat final

## Structure minimale

Le bloc YAML placé au début du fichier règle le titre, le format de sortie et les options de rendu. Pour les remises, l'option `embed-resources: true` garde les ressources intégrées au fichier HTML.

rapport.qmd

    ---
    title: "Analyse de cas"
    format:
      html:
        embed-resources: true
    execute:
      warning: false
      message: false
    ---

    # Question

    Écrire ici la question d'analyse.

    ```{r}
    # Load libraries
    library(tidyverse)
    ```

## Blocs essentiels d'un mini-rapport

Un document clair montre la démarche sans cacher les choix importants.

1.  01

    ### Question

    Formuler ce que l'analyse cherche à éclairer.

2.  02

    ### Données

    Décrire l'origine, l'unité d'observation, les variables et les limites.

3.  03

    ### Code et résultats

    Montrer le code minimal nécessaire et les sorties utiles.

4.  04

    ### Interprétation

    Relier les résultats à la question et indiquer les limites.

## Blocs de code R

Un bloc de code doit être reproductible : il charge les packages nécessaires, utilise des objets créés dans le document et produit un résultat vérifiable.

Bloc R

    ```{r}
    # Load libraries
    library(tidyverse)

    # Import data
    ventes <- read_csv("data/ventes.csv", show_col_types = FALSE)

    # Explore
    ventes |>
      summarise(
        n = n(),
        ventes_moyennes = mean(ventes, na.rm = TRUE)
      )
    ```

## Chemins de fichiers

Un chemin doit être écrit relativement au dossier du document ou au dossier de travail ouvert.

### Bon réflexe

Placer les données dans un dossier clair, par exemple `data/`, puis utiliser un chemin court comme `data/ventes.csv`.

### À vérifier

Le nom du fichier, les accents, les majuscules, l'extension `.csv` et l'emplacement exact du document.

### À éviter

Les chemins propres à un seul ordinateur, difficiles à reproduire par une autre personne de l'équipe.

## Rendre et vérifier

Le rendu doit être relancé avant la remise. Un rapport est prêt seulement si le HTML final s'ouvre et que les tableaux, graphiques, résultats et interprétations sont cohérents.

[Documentation officielle Quarto](https://quarto.org/docs/get-started/)

### Erreur de YAML

Vérifiez les deux lignes `---`, l'indentation et les deux-points.

### Objet introuvable

Relancez le document depuis le début. Le rendu part d'une session propre.

### Figure absente

Vérifiez que le bloc produit bien un graphique et qu'aucune erreur n'arrive avant la figure.
