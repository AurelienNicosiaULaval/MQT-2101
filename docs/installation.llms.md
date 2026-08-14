# Installation

# Installer l'environnement de travail

L'objectif est simple : ouvrir un projet, exécuter du code R, produire des graphiques et rendre un document Quarto sans friction technique.

[Vérifier l'installation](#verification) [Guide RStudio](ressources/guide-rstudio.llms.md) [Guide Quarto](ressources/guide-quarto.llms.md)

01

Installer R

02

Choisir RStudio ou Positron

03

Installer Quarto

04

Vérifier les packages

## Les outils à avoir sur son ordinateur

Installez les logiciels dans cet ordre. Les liens pointent vers les pages officielles.

R

### R

Le moteur statistique utilisé pour importer, transformer, visualiser et modéliser les données.

[Télécharger R](https://cran.r-project.org/)

IDE

### RStudio ou Positron

L'interface de travail pour écrire du code, gérer les fichiers et exécuter les analyses.

[RStudio](https://posit.co/downloads/) [Positron](https://positron.posit.co/download.html)

Q

### Quarto

Le système de rédaction reproductible utilisé pour combiner texte, code, tableaux et graphiques.

[Installer Quarto](https://quarto.org/docs/get-started/)

Pkg

### Packages R

Les bibliothèques nécessaires aux analyses, graphiques, documents Quarto et modèles du cours.

[Installer les packages](#packages-title)

## Ordre recommandé

Suivez la séquence ci-dessous avant le premier atelier. Elle évite la plupart des problèmes classiques.

1.  01
    ### Installer R en premier

    R doit être installé avant l'environnement de développement pour être détecté correctement.
2.  02
    ### Installer RStudio ou Positron

    Un seul des deux suffit. RStudio est le choix le plus classique; Positron est une option moderne compatible avec R.
3.  03
    ### Installer Quarto

    Après l'installation, redémarrez l'environnement de développement pour que Quarto soit reconnu.
4.  04
    ### Installer les packages du cours

    À partir de la racine du projet, exécutez le script d'installation fourni avec le site.

## Packages R du cours

Le dépôt contient un script qui vérifie les packages nécessaires et installe ceux qui manquent. Lancez-le depuis la racine du projet.

Console R

    source("scripts/00_install_packages.R")

[Télécharger le script d'installation](scripts/00_install_packages.R)

## Vérification rapide

Si ce code s'exécute et produit un graphique, l'environnement de base est prêt pour le cours.

Test minimal

    library(tidyverse)

    tibble(
      mois = c("janvier", "février", "mars"),
      ventes = c(125000, 131000, 128500)
    ) |>
      ggplot(aes(mois, ventes, group = 1)) +
      geom_line() +
      geom_point()

## Dépannage express

Les messages d'erreur d'installation sont souvent causés par l'ordre d'installation, le dossier de travail ou un redémarrage oublié.

### R n'est pas détecté

Installez R, puis redémarrez RStudio ou Positron. Si le problème persiste, vérifiez que l'application utilise bien la version de R installée.

### Quarto n'est pas trouvé

Redémarrez l'environnement de développement et exécutez `quarto check` dans un terminal.

### Le script est introuvable

Ouvrez le projet à sa racine avant d'exécuter `source("scripts/00_install_packages.R")`.

### Un package ne compile pas sous Windows

Si R demande des outils de compilation, consultez la page officielle [Rtools](https://cran.r-project.org/bin/windows/Rtools/).
