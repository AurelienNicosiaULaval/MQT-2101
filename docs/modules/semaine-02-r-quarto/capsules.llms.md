# Capsules - Module 02

## Objectif

Cette page rassemble les vidéos et les supports des six capsules du module 02. Elles accompagnent les premiers gestes techniques dans R, RStudio et Quarto : préparer l’environnement, ouvrir un projet, importer un fichier CSV, inspecter un tableau, diagnostiquer les données et produire un mini-rapport reproductible.

Les capsules 1 à 3 préparent votre environnement et votre projet. Conservez ensuite les imports et les calculs dans votre fichier Quarto, créé à la capsule 3 et complété à la capsule 6. Les supports PDF et HTML contiennent les repères à consulter pendant la séance autonome. Les versions HTML permettent aussi de copier-coller le code dans RStudio.

Regardez les capsules dans l’ordre, de 1 à 6, en gardant RStudio ouvert pour reproduire les gestes. Vous pouvez mettre la vidéo en pause et passer entre les onglets Vidéo, PDF et HTML. Dans le support HTML, utilisez le bouton de copie d’un bloc de code ou sélectionnez le texte à copier. Le lien sous les diapositives permet d’ouvrir le support dans un nouvel onglet pour l’afficher en grand. Un lien permet aussi d’ouvrir chaque vidéo directement sur YouTube.

> **NOTE:**
>
> Suivez le [guide d’installation pour débuter sur Windows ou Mac](../../installation.llms.md). Si vos logiciels sont déjà installés, faites simplement les tests du guide. Revenez ensuite à cette page : les capsules vous montrent comment utiliser vos outils.

## Capsule 1 - Préparer son environnement de travail

Cette capsule vérifie que R et les packages de base fonctionnent correctement. Le rendu de votre propre mini-rapport sera vérifié à la capsule 6. Les démonstrations utilisent RStudio.

Durée : 6 min 29 s.

## Vidéo

[Ouvrir la capsule 1 sur YouTube](https://www.youtube.com/watch?v=Ge6PfRNMYYY)

## PDF

[Ouvrir le PDF](media/pdf/capsule-01-support.pdf)

## HTML

[Ouvrir le support HTML dans un nouvel onglet](media/qmd/capsule-01-support.llms.md)

À faire après la capsule : ouvrir RStudio, exécuter `1 + 1`, puis charger `tidyverse`, `janitor`, `lubridate` et `scales`.

## Capsule 2 - Se repérer dans RStudio

Cette capsule sert à reconnaître les zones de travail : console, éditeur, environnement, fichiers, graphiques et sortie Quarto.

Durée : 7 min 24 s.

## Vidéo

[Ouvrir la capsule 2 sur YouTube](https://www.youtube.com/watch?v=0BYESd3d56Y)

## PDF

[Ouvrir le PDF](media/pdf/capsule-02-support.pdf)

## HTML

[Ouvrir le support HTML dans un nouvel onglet](media/qmd/capsule-02-support.llms.md)

À faire après la capsule : associer chaque zone de l’interface à une action concrète, par exemple écrire, exécuter, afficher un objet ou trouver un fichier.

## Capsule 3 - Organiser un projet reproductible

Cette capsule montre pourquoi un projet R réduit les erreurs de chemins et aide à reprendre une analyse plus tard.

Durée : 11 min 27 s.

## Vidéo

[Ouvrir la capsule 3 sur YouTube](https://www.youtube.com/watch?v=7J8mH2QqO7c)

## PDF

[Ouvrir le PDF](media/pdf/capsule-03-support.pdf)

## HTML

[Ouvrir le support HTML dans un nouvel onglet](media/qmd/capsule-03-support.llms.md)

À faire après la capsule : créer ou ouvrir un projet R, placer le CSV dans `data/` et créer `rapport_semaine_02.qmd` à la racine du projet.

## Capsule 4 - Importer et inspecter un tableau

Cette capsule présente l’importation d’un fichier CSV et les premières vérifications : dimensions, noms de variables, types et unité d’observation.

Durée : 7 min 07 s.

## Vidéo

[Ouvrir la capsule 4 sur YouTube](https://www.youtube.com/watch?v=n0L82uugGlM)

## PDF

[Ouvrir le PDF](media/pdf/capsule-04-support.pdf)

## HTML

[Ouvrir le support HTML dans un nouvel onglet](media/qmd/capsule-04-support.llms.md)

À faire après la capsule : importer `ventes_operations_quebec.csv`, vérifier les 24 lignes et les 12 colonnes, puis écrire ce que représente une ligne du tableau.

## Capsule 5 - Résumer et diagnostiquer les données

Cette capsule montre comment repérer les valeurs manquantes et produire de premiers indicateurs descriptifs.

Durée : 10 min 50 s.

## Vidéo

[Ouvrir la capsule 5 sur YouTube](https://www.youtube.com/watch?v=Ju6gmv6iKy8)

## PDF

[Ouvrir le PDF](media/pdf/capsule-05-support.pdf)

## HTML

[Ouvrir le support HTML dans un nouvel onglet](media/qmd/capsule-05-support.llms.md)

À faire après la capsule : produire un tableau de valeurs manquantes et un premier résumé descriptif par succursale ou par canal principal.

## Capsule 6 - Produire un mini-rapport Quarto

Cette capsule rassemble les gestes précédents dans un document `.qmd` : titre, texte, code, sorties, graphiques et constats descriptifs.

Durée : 7 min 21 s.

## Vidéo

[Ouvrir la capsule 6 sur YouTube](https://www.youtube.com/watch?v=Ar1aJlmM39g)

## PDF

[Ouvrir le PDF](media/pdf/capsule-06-support.pdf)

## HTML

[Ouvrir le support HTML dans un nouvel onglet](media/qmd/capsule-06-support.llms.md)

À faire après la capsule : rendre le fichier Quarto en HTML, puis vérifier que le document contient le code d’importation, un diagnostic, un tableau, un graphique et deux constats.

## Après les capsules

Poursuivez avec les [démonstrations R](demonstrations.llms.md), puis les [exercices](exercices.llms.md). Les capsules donnent les repères; les démonstrations montrent la démarche complète sur le même fichier. Les exercices appliquent ensuite la démarche à un autre fichier, sur les retours et les délais d’une PME fictive.
