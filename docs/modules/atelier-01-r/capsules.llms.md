# Repères - Atelier 01

## Rôle de cette page

Cette page présente les courts repères conceptuels à mobiliser pendant l’atelier. Les repères ne remplacent pas le travail en classe : ils servent à clarifier les gestes qui seront pratiqués dans RStudio.

## Repère 1 - Du tableau au diagnostic descriptif

*Pourquoi ça compte* : avant de promettre une explication à la direction, il faut savoir ce qu’un simple tableau permet de dire, et ce qu’il ne permet pas encore de conclure.

Objectif : comprendre ce qu’un diagnostic descriptif peut fournir avant une analyse plus avancée.

À couvrir :

- unité d’observation;
- variable et type de variable;
- indicateur descriptif;
- différence entre constater, comparer et expliquer;
- limite d’une analyse purement descriptive.

Activité :

- écrire une phrase qui décrit ce que représente une ligne du tableau [ventes_pme_quebec.csv](../../donnees/#ventes-mensuelles-dune-pme-québécoise-fictive).

## Repère 2 - Importation et inspection

*Pourquoi ça compte* : un fichier mal importé suffit pour que tous vos chiffres portent sur un tableau que vous ne connaissez pas vraiment.

Objectif : importer un fichier CSV et vérifier rapidement la structure du tableau.

À couvrir :

- chemin relatif dans un projet R;
- `readr::read_csv()`;
- `janitor::clean_names()`;
- `glimpse()`;
- nombre de lignes, nombre de colonnes et types de variables.

Activité :

- importer le fichier CSV et noter les dimensions du tableau.

## Repère 3 - Valeurs manquantes et indicateurs

*Pourquoi ça compte* : une colonne incomplète peut faire ressortir la mauvaise succursale comme la plus performante.

Objectif : repérer les valeurs manquantes et produire des indicateurs descriptifs utiles.

À couvrir :

- diagnostic des valeurs manquantes;
- utilisation prudente de `na.rm = TRUE`;
- regroupement avec `group_by()`;
- résumé avec `summarise()`;
- choix d’un indicateur adapté à la question.

Activité :

- produire un tableau synthèse par succursale et choisir deux indicateurs à commenter.

## Repère 4 - Graphiques et constats

*Pourquoi ça compte* : un graphique clair montre rapidement ce qu’un tableau cache; un graphique trompeur peut faire conclure trop vite.

Objectif : transformer un tableau de résultats en graphiques et en constats descriptifs.

À couvrir :

- graphique de comparaison;
- graphique de relation descriptive;
- titre, axes et unités;
- distinction entre association descriptive et explication;
- formulation d’un constat avec une limite.

Activité :

- écrire un constat descriptif à partir d’un graphique et nommer ce que ce graphique ne permet pas de conclure.

## Repère 5 - De l’exploration à la priorité

*Pourquoi ça compte* : la direction n’attend pas une longue liste de chiffres, mais une priorité défendable pour la prochaine analyse.

Objectif : transformer plusieurs résultats descriptifs en priorité de prochaine analyse.

À couvrir :

- différence entre résultat descriptif et recommandation finale;
- choix d’une priorité : marketing, opérations ou saisonnalité;
- nécessité d’appuyer la priorité par un tableau ou un graphique;
- formulation d’une limite;
- lien avec les modèles qui viendront ensuite.

Activité :

- choisir une priorité de prochaine analyse et écrire la phrase : « La prochaine analyse devrait prioriser…, parce que… ».
