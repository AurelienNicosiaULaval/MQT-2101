# Module 02

Premiers pas avec R, RStudio et Quarto

Séance autonome

## Premiers pas avec R, RStudio et Quarto

Importer, inspecter, résumer et visualiser un premier tableau de données. Cette semaine sert à installer les bases techniques nécessaires pour travailler de façon reproductible avec R. Le parcours vous guide depuis l’environnement de travail jusqu’à la production d’un mini-rapport Quarto.

Durée estimée

2 h 30 à 3 h

Outils

R, RStudio, Quarto

Données du parcours guidé

[ventes_operations_quebec.csv](../../donnees/#ventes-et-opérations-de-succursales-québécoises)

Trace finale

Mini-rapport Quarto

## On passe au concret

> **NOTE:**
>
> Cette semaine sert à franchir le premier vrai seuil du cours : partir d’un fichier de données et arriver à une page HTML courte, claire et reproductible.
>
> Vous allez apprendre les gestes qui reviendront partout ensuite : importer, inspecter, résumer, visualiser et expliquer ce que l’on observe.
>
> Ces gestes préparent les semaines sur la régression, la prévision, les séries chronologiques et l’évaluation de modèles. L’objectif n’est pas d’aller vite. L’objectif est de construire une méthode de travail fiable.

Départ un fichier CSV

→

Méthode du code R vérifiable

→

Arrivée un mini-rapport Quarto

Le fil conducteur reste appliqué à des données en administration : ventes, opérations, clients, prévision et performance organisationnelle. Lorsque les consignes l’autorisent, l’IA peut servir d’outil de questionnement ou de vérification, mais le raisonnement statistique, le code R et l’interprétation restent au centre du travail.

À la fin de la semaine

Vous devriez pouvoir importer le fichier [ventes_operations_quebec.csv](../../donnees/#ventes-et-opérations-de-succursales-québécoises), inspecter sa structure, repérer les valeurs manquantes, produire un résumé, créer un graphique et formuler deux constats descriptifs simples.

## Votre parcours

Le parcours ci-dessous construit un rapport guidé avec `ventes_operations_quebec.csv`. Après l’étape 9, passez aux exercices d’application : vous utiliserez `ventes_pme_quebec.csv` dans un projet distinct pour étudier les retours et les délais. Les deux fichiers sont simulés.

Les productions autonomes des supports reprennent les activités du parcours : il n’est pas nécessaire de les refaire deux fois. Les activités 2.1 à 2.10 détaillent les gestes présentés dans les six capsules.

> **NOTE:**
>
> Vous débutez avec R? Suivez le [guide d’installation pas à pas pour Windows ou Mac](../../installation.llms.md). Il précise les boutons à utiliser, les extensions à ajouter et les résultats attendus. R et RStudio sont gratuits; Quarto est inclus dans les versions récentes de RStudio.
>
> Votre point d’arrêt : RStudio s’ouvre, `1 + 1` donne `2`, les quatre packages se chargent et le petit fichier de test produit une page HTML. Revenez ensuite ici pour commencer la capsule 1. Ce test d’installation ne remplace pas votre mini-rapport, qui sera construit dans le parcours ci-dessous.

La durée indiquée pour le module est un repère; prévoyez du temps supplémentaire pour l’installation ou le dépannage.

> **NOTE:**
>
> Le support global de notes de cours est disponible en [HTML](../../modules/semaine-02-r-quarto/notes-cours.llms.md) et en [PDF](media/pdf/notes-cours.pdf). Il sert de synthèse du module; les supports détaillés sont associés aux capsules.

Revenez toujours à cette page pour garder le fil. Cliquez sur une carte pour ouvrir l’étape complète : objectif, ressource, action et activité associée.

1 Préparer son environnement de travail Vérifier que R, RStudio et les packages essentiels fonctionnent. [Capsule 1](capsules.llms.md#capsule-1---préparer-son-environnement-de-travail) Ouvrir l'étapeRéduire

Objectif Vérifier R et les packages nécessaires; le rendu Quarto sera testé à la capsule 6.

Ressource [Capsule 1](capsules.llms.md#capsule-1---préparer-son-environnement-de-travail)

Action Ouvrir RStudio, exécuter une commande simple dans la console et charger les quatre packages de la capsule 1.

Activité 2.1 - Vérifier que R fonctionne

Dans la console, exécutez une commande simple, par exemple `1 + 1`, puis chargez `tidyverse`, `janitor`, `lubridate` et `scales`. Notez le résultat et les éventuelles erreurs.

2 Se repérer dans RStudio Repérer la console, l'éditeur, l'environnement, les fichiers et les graphiques. [Capsule 2](capsules.llms.md#capsule-2---se-repérer-dans-rstudio) Ouvrir l'étapeRéduire

Objectif Reconnaître les principales zones de l'interface.

Ressource [Capsule 2](capsules.llms.md#capsule-2---se-repérer-dans-rstudio)

Action Identifier la console, l'éditeur, l'environnement, l'onglet Files et l'onglet Plots.

Activité 2.2 - Identifier les zones de RStudio

Associez chaque zone de RStudio à une action : écrire le rapport, exécuter du code, voir les objets, trouver les fichiers ou afficher un graphique.

3 Organiser un projet reproductible Utiliser un projet R et des chemins relatifs. [Capsule 3](capsules.llms.md#capsule-3---organiser-un-projet-reproductible) Ouvrir l'étapeRéduire

Objectif Comprendre pourquoi le projet R est la base de la reproductibilité.

Ressource [Capsule 3](capsules.llms.md#capsule-3---organiser-un-projet-reproductible)

Action Créer un projet R, placer le CSV dans `data` et créer le fichier `rapport_semaine_02.qmd` à la racine du projet.

Activité 2.3 - Expliquer l'utilité d'un projet R

Expliquez en deux ou trois phrases pourquoi un projet R réduit les erreurs de chemins et facilite la reprise d'une analyse.

4 Importer et inspecter un tableau Lire le fichier CSV et vérifier les dimensions du tableau. [Capsule 4](capsules.llms.md#capsule-4---importer-et-inspecter-un-tableau)[Démo 1](demonstrations.llms.md#démonstration-1---inspecter-le-tableau) Ouvrir l'étapeRéduire

Objectif Lire le fichier CSV dans R.

Ressource [Capsule 4](capsules.llms.md#capsule-4---importer-et-inspecter-un-tableau) [Préparation R](demonstrations.llms.md#préparation) [Démo 1](demonstrations.llms.md#démonstration-1---inspecter-le-tableau)

Action Exécuter le code d'importation et vérifier les dimensions du tableau.

Activité 2.4 - Importer les données

Importez le fichier [ventes_operations_quebec.csv](../../donnees/#ventes-et-opérations-de-succursales-québécoises), puis indiquez le nombre de lignes et de colonnes du tableau.

5 Inspecter le tableau Identifier les lignes, les colonnes et les types de variables. [Démo 1](demonstrations.llms.md#démonstration-1---inspecter-le-tableau) Ouvrir l'étapeRéduire

Objectif Comprendre la structure du tableau avant de calculer des résultats.

Ressource [Démo 1](demonstrations.llms.md#démonstration-1---inspecter-le-tableau)

Action Identifier l'unité d'observation, les variables numériques, les variables catégorielles et les variables de date ou de période.

Activité 2.5 - Inspecter les lignes, colonnes et types de variables

Indiquez ce que représente une ligne du tableau, puis classez les principales variables selon leur type.

6 Diagnostiquer les données Repérer les valeurs manquantes et signaler les précautions nécessaires. [Capsule 5](capsules.llms.md#capsule-5---résumer-et-diagnostiquer-les-données)[Démo 3](demonstrations.llms.md#démonstration-3---vérifier-les-valeurs-manquantes) Ouvrir l'étapeRéduire

Objectif Produire un diagnostic simple des données absentes avant de présenter les résultats descriptifs.

Ressource [Capsule 5](capsules.llms.md#capsule-5---résumer-et-diagnostiquer-les-données) [Démo 2](demonstrations.llms.md#démonstration-2---préparer-les-variables) [Démo 3](demonstrations.llms.md#démonstration-3---vérifier-les-valeurs-manquantes)

Action Utiliser `is.na()`, `summarise()` et `pivot_longer()` pour compter les valeurs manquantes et indiquer quelles variables sont touchées.

Activité 2.6 - Repérer les valeurs manquantes

Nommez les variables incomplètes et expliquez pourquoi ce diagnostic doit apparaître dans un rapport reproductible.

7 Produire les premiers résultats descriptifs Créer un tableau descriptif, un graphique simple et un premier constat. [Capsule 5](capsules.llms.md#capsule-5---résumer-et-diagnostiquer-les-données)[Capsule 6](capsules.llms.md#capsule-6---produire-un-mini-rapport-quarto)[Démo 4](demonstrations.llms.md#démonstration-4---résumer-un-tableau)[Démo 5](demonstrations.llms.md#démonstration-5---créer-un-graphique) Ouvrir l'étapeRéduire

Objectif Produire un tableau descriptif et un graphique simple.

Ressource [Capsule 5](capsules.llms.md#capsule-5---résumer-et-diagnostiquer-les-données) [Capsule 6](capsules.llms.md#capsule-6---produire-un-mini-rapport-quarto) [Démo 4](demonstrations.llms.md#démonstration-4---résumer-un-tableau) [Démo 5](demonstrations.llms.md#démonstration-5---créer-un-graphique)

Action Résumer les ventes par succursale ou par canal principal, puis construire un graphique avec `ggplot()` pour appuyer un premier constat descriptif.

Activité 2.7 - Produire un tableau descriptif

Produisez un tableau descriptif par succursale ou par canal principal, puis interprétez un résultat.

Activité 2.8 - Produire un graphique

Créez un graphique simple des ventes. Le titre et les axes doivent permettre de comprendre rapidement ce qui est comparé.

8 Structurer le fichier QMD Organiser le document Quarto commencé à l’étape 3. [Capsule 6](capsules.llms.md#capsule-6---produire-un-mini-rapport-quarto)[Guide Quarto](../../ressources/guide-quarto.llms.md) Ouvrir l'étapeRéduire

Objectif Construire un fichier Quarto lisible avant de produire la version HTML.

Ressource [Capsule 6](capsules.llms.md#capsule-6---produire-un-mini-rapport-quarto) [Guide Quarto](../../ressources/guide-quarto.llms.md)

Action Créer un fichier `.qmd` avec un titre, une courte introduction, des blocs de code R et des phrases d'interprétation.

Activité 2.9 - Structurer le fichier QMD

Complétez les sections du mini-rapport Quarto commencé à l’étape 3 : introduction, importation, inspection, valeurs manquantes, tableau, graphique et constats à compléter.

9 Finaliser le mini-rapport Produire le HTML final et vérifier que le document se relit bien. [Capsule 6](capsules.llms.md#capsule-6---produire-un-mini-rapport-quarto) Ouvrir l'étapeRéduire

Objectif Vérifier que le rapport est reproductible et compréhensible.

Ressource [Capsule 6](capsules.llms.md#capsule-6---produire-un-mini-rapport-quarto) [Lectures](lectures.llms.md)

Action Cliquer sur Render dans RStudio, puis relire le HTML produit.

Activité 2.10 - Formuler deux constats descriptifs

À partir du tableau descriptif et du graphique, formulez deux constats descriptifs simples. Chaque constat doit mentionner la variable observée.

## Exercices d’application

Une fois le rapport guidé terminé, réalisez les [exercices 1 à 5](../../modules/semaine-02-r-quarto/exercices.llms.md). Ils reprennent les mêmes gestes sur un autre fichier, avec une question sur la qualité opérationnelle. Gardez ce deuxième rapport dans le projet `diagnostic-retours-pme`.

## Ressources du module

[ CapsulesComprendre les gestes de base avant de les reproduire dans R.](capsules.llms.md) [ Démonstrations RReproduire le code pas à pas pour importer, inspecter, résumer et visualiser.](demonstrations.llms.md) [ ExercicesAppliquer la démarche à un nouveau cas sur les retours et les délais, puis vérifier les critères proposés.](exercices.llms.md) [ LecturesClarifier les notions techniques lorsque les capsules ou les exercices soulèvent une question.](lectures.llms.md)

> **WARNING:**
>
> - Travailler sans projet R.
> - Utiliser un chemin absolu propre à un ordinateur.
> - Oublier de charger les packages nécessaires.
> - Interpréter `NA` comme une valeur numérique.
> - Modifier le CSV à la main sans garder de trace.
> - Copier un graphique sans conserver le code.

## Trace finale

Le parcours guidé aboutit à `rapport_semaine_02.qmd` sur les ventes. Les exercices aboutissent à `rapport_retours_pme.qmd` sur la qualité opérationnelle. Il s’agit d’entraînements pour ce module; les consignes des mini-rapports évalués se trouvent dans la section [Évaluations](../../evaluations/index.llms.md).

> **IMPORTANT:**
>
> Le mini-rapport sert à montrer que vous pouvez transformer un fichier CSV en une première analyse reproductible. Il ne s’agit pas d’un long texte : le document doit rendre visibles les gestes essentiels du parcours, du code d’importation jusqu’aux constats descriptifs.

Ce que le rapport doit démontrer

### Je peux reprendre l'analyse du début à la fin.

Une autre personne doit pouvoir ouvrir votre fichier Quarto, exécuter le code, retrouver les données dans le projet, recalculer les résultats avec les packages nécessaires et comprendre vos deux constats descriptifs.

Importer Inspecter Diagnostiquer Résumer Visualiser Structurer le QMD Rendre Constater

Votre mini-rapport doit contenir :

- une courte introduction;
- le code d’importation;
- une inspection du tableau;
- un court diagnostic des valeurs manquantes;
- un tableau descriptif;
- un graphique;
- deux constats descriptifs;
- une question que vous aimeriez approfondir.

La trace sert à montrer ce que vous savez faire à la fin de la semaine. Elle n’a pas besoin d’être longue.

## Auto-vérification

Avant de passer à la semaine suivante, je peux dire que :

J’ai ouvert RStudio.

J’ai compris les principales zones de l’interface.

J’ai utilisé un projet R.

J’ai importé un fichier CSV.

J’ai inspecté les données.

J’ai repéré les valeurs manquantes.

J’ai produit un tableau descriptif.

J’ai produit un graphique.

J’ai structuré un fichier Quarto.

J’ai rendu un fichier Quarto.

J’ai formulé deux constats descriptifs.

> **NOTE:**
>
> Vous pouvez utiliser le [GPT du cours](https://chatgpt.com/g/g-6a0b2ec33d948191ad25b2f247b15de1-analyse-et-modelisation-des-donnees?ref=mini) pour relire votre mini-rapport. Son rôle est de repérer les éléments manquants, les imprécisions, les problèmes de reproductibilité et les questions à clarifier. Il ne doit pas réécrire le rapport à votre place.
>
> Suggestion de demande :
>
> > Voici mon mini-rapport Quarto pour la semaine 02. Vérifie si le document contient tous les éléments attendus, si le code semble reproductible et si mes constats sont assez clairs. Indique les éléments manquants, les passages imprécis et les questions que je devrais me poser. Ne réécris pas mon rapport à ma place.
>
> Après cette vérification, notez une correction apportée au rapport ou une question qui reste à clarifier.

## Je suis bloqué·e

Si vous êtes bloqué·e pendant l’installation, ouvrez le [dépannage du guide](../../installation.llms.md#depannage).

Pour le travail sur les données, vérifiez dans l’ordre :

1.  le dossier du projet;
2.  le chemin du fichier [ventes_operations_quebec.csv](../../donnees/#ventes-et-opérations-de-succursales-québécoises);
3.  le chargement des packages avec `library(tidyverse)`;
4.  le message d’erreur, surtout le nom de l’objet ou du fichier manquant;
5.  le code correspondant dans [les démonstrations R](../../modules/semaine-02-r-quarto/demonstrations.llms.md);
6.  la précision de votre question sur le forum, avec le code tenté et le message d’erreur complet.

## Pour aller plus loin

- Refaire les exercices avec un autre jeu de données public du cours.
- Modifier le graphique en changeant la variable de comparaison.
- Ajouter une statistique descriptive pertinente.
- Préparer [l’atelier 01](../../modules/atelier-01-r/index.llms.md), qui réutilise les mêmes gestes dans un diagnostic descriptif plus complet.
