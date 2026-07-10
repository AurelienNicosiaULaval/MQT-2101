# Atelier 01

Explorer un tableau avec RStudio

Atelier en classe

## Explorer un tableau avec RStudio

Cet atelier n’est pas conçu comme une séance autonome complète. Il sert à pratiquer en classe les gestes vus dans les deux premiers modules : ouvrir un projet, importer un fichier CSV, inspecter un tableau, produire quelques résumés, visualiser, écrire des constats descriptifs et choisir une priorité de prochaine analyse.

Avant

Préparation courte

Pendant

2 h 30 à 3 h dans RStudio

Données

[ventes_pme_quebec.csv](../../donnees/#ventes-mensuelles-dune-pme-québécoise-fictive)

Après

Court rapport Quarto

> **NOTE:**
>
> La direction d’une PME québécoise veut savoir où concentrer ses efforts l’an prochain : le marketing, les opérations (ruptures de stock, délais) ou la saisonnalité. Vous disposez d’un tableau de ventes mensuelles. Cet atelier transforme ce tableau en une priorité défendable, plutôt qu’en simple intuition.

## Avant l’atelier

L’objectif est simplement d’arriver en classe avec un environnement prêt pour travailler. Il ne faut pas refaire tout le module 2 : il suffit de retrouver les gestes essentiels.

1

### Préparer RStudio

Ouvrir ou créer un projet R pour l'atelier et vérifier que les packages de base se chargent.

2

### Repérer le fichier

Vérifier que [ventes_pme_quebec.csv](../../donnees/#ventes-mensuelles-dune-pme-québécoise-fictive) est accessible dans le dossier de l'atelier.

3

### Démarrer le QMD

Créer un document Quarto minimal avec une section d'importation et une section de résultats.

> **NOTE:**
>
> Avant l’atelier, vérifiez surtout que vous pouvez reprendre les gestes de base du module 2 sans repartir de zéro. L’atelier est supervisé : il est normal de poser des questions, mais vous gagnerez du temps si les éléments suivants sont déjà prêts.

RStudio ou Positron ouvre sans problème.

Les packages `tidyverse` et `janitor` se chargent.

Vous savez où se trouve votre dossier de travail.

Vous savez créer ou ouvrir un fichier `.qmd`.

Vous savez exécuter un bloc de code dans Quarto.

Vous savez importer un fichier CSV avec `readr::read_csv()`.

Vous savez utiliser `glimpse()` ou `dim()` pour inspecter un tableau.

Vous avez relu les exercices 3 à 5 du module 2.

Ce qui doit être maîtrisé avant l’atelier :

[ ImporterLire un CSV et vérifier que le tableau apparaît dans l'environnement.](../semaine-02-r-quarto/index.llms.md#etape-4) [ InspecterNommer l'unité d'observation et reconnaître les types de variables.](../semaine-02-r-quarto/index.llms.md#etape-5) [ DiagnostiquerRepérer les valeurs manquantes et expliquer pourquoi elles comptent.](../semaine-02-r-quarto/index.llms.md#etape-6) [ Résumer et visualiserProduire un tableau descriptif, un graphique et une phrase prudente.](../semaine-02-r-quarto/index.llms.md#etape-7)

À revoir si nécessaire :

- [guide Quarto](../../ressources/guide-quarto.llms.md), pour créer et rendre un fichier `.qmd`;
- [démonstrations du module 2](../semaine-02-r-quarto/demonstrations.llms.md), pour l’importation CSV et `glimpse()`.

> **TIP:**
>
> Si vous arrivez avec RStudio ouvert, le fichier CSV accessible et un document Quarto créé, c’est suffisant pour commencer l’atelier.

> **IMPORTANT:**
>
> Les comparaisons plus exploratoires, par exemple satisfaction et ruptures de stock, ventes et dépenses marketing ou ventes selon la saison, seront travaillées pendant l’atelier avec accompagnement. Vous n’avez pas besoin de maîtriser ces analyses avant d’arriver. L’objectif est d’apprendre à passer d’un résultat à un constat descriptif prudent.

> **NOTE:**
>
> L’atelier commence par des gestes simples : inspecter les variables, vérifier les types, regarder l’effet des valeurs manquantes et produire des graphiques lisibles. Ces gestes servent ensuite une question de gestion : quelle priorité d’analyse recommander à la direction?

## Pendant l’atelier

Pendant la séance, l’important est de produire les éléments du rapport, pas de lire toutes les ressources dans l’ordre. Le guide complet est le fil principal de l’atelier : il contient les démonstrations, les moments « À vous », les pauses diagnostic et les éléments à conserver dans la trace finale.

[À ouvrir en classe](guide-atelier.llms.md)

### Guide complet de l'atelier

Suivre ce parcours pendant la séance. Les démonstrations sont intégrées directement dans le guide, puis reprises par des tâches à faire dans le rapport.

[Démarche guidée](demonstrations.llms.md)

### Démonstrations R

Revoir les tableaux, graphiques, sorties R et interprétations attendues.

[Pratique ciblée](exercices.llms.md)

### Exercices

Faire les points de pratique associés aux moments « À vous » du guide. Ce n'est pas un parcours séparé.

Le fil de travail en classe est le suivant.

Départ

### Importer le tableau

Lire le fichier CSV, vérifier les dimensions et nommer l'unité d'observation.

Étape 1

### Construire le dictionnaire

Repérer les types, les exemples de valeurs et les variables utiles pour la décision.

Étape 2

### Vérifier les valeurs manquantes

Produire un petit diagnostic et noter les précautions nécessaires.

Étape 3

### Construire un tableau synthèse

Résumer les ventes, les clients, le panier moyen, la satisfaction et les ruptures par succursale.

Étape 4

### Créer deux graphiques

Produire un graphique de comparaison et un graphique explorant une autre dimension du tableau.

Étape 5

### Choisir une priorité

Comparer marketing, opérations ou saisonnalité et formuler une recommandation prudente.

Fin

### Mettre en commun

Présenter une priorité, un résultat descriptif, une limite et une question pour la suite.

Ce qui doit être produit pendant l’atelier :

le code d’importation;

une inspection du tableau;

un dictionnaire rapide de variables clés;

un diagnostic des valeurs manquantes;

un tableau synthèse par succursale;

deux graphiques;

trois constats descriptifs;

une limite d’interprétation;

une recommandation de prochaine analyse.

> **NOTE:**
>
> Le guide complet est la page à suivre pendant l’atelier. Les démonstrations montrent une démarche complète; les exercices reprennent les parties à produire dans votre propre trace finale. Autrement dit, vous regardez une démonstration, vous faites le point « À vous » correspondant, puis vous gardez le résultat utile dans le rapport Quarto.

## Après l’atelier

Après la séance, il faut surtout nettoyer, vérifier et finaliser. Cette partie ne demande pas une nouvelle analyse complète.

> **IMPORTANT:**
>
> La trace finale prend la forme d’un court rapport Quarto reproductible. Le rapport doit montrer que vous êtes capable de passer d’un fichier CSV à une première exploration descriptive claire.

Le rapport doit contenir :

- une courte introduction;
- le code d’importation;
- une description du tableau;
- un dictionnaire rapide des variables clés;
- le diagnostic des valeurs manquantes;
- le tableau synthèse;
- deux graphiques;
- trois constats descriptifs;
- une limite d’interprétation;
- une recommandation de prochaine analyse.

Avant de considérer le fichier terminé :

Le document Quarto se génère sans erreur.

Les tableaux et graphiques sont lisibles.

Les constats sont descriptifs, pas causaux.

La limite d’interprétation est explicite.

Le fichier final est court et propre.

> **NOTE:**
>
> Vous pouvez utiliser le [GPT du cours](https://chatgpt.com/g/g-6a0b2ec33d948191ad25b2f247b15de1-analyse-et-modelisation-des-donnees?ref=mini) pour relire votre trace finale. Son rôle est de repérer les éléments manquants, les imprécisions, les problèmes de reproductibilité et les questions à clarifier. Il ne doit pas réécrire le rapport à votre place.
>
> Suggestion de demande :
>
> > Voici ma trace finale pour l’atelier 01. Vérifie si le document contient tous les éléments attendus, si le code semble reproductible et si mes constats sont assez clairs. Indique les éléments manquants, les passages imprécis et les questions que je devrais me poser. Ne réécris pas mon rapport à ma place.
>
> Après cette vérification, notez une correction apportée à votre trace ou une question qui reste à clarifier.

## Ressources utiles

[ Guide d'atelierParcours principal à suivre en classe, avec les moments « À vous ».](guide-atelier.llms.md) [ Démonstrations RDémarche complète avec sorties, tableaux, graphiques et interprétations.](demonstrations.llms.md) [ ExercicesConsignes courtes pour compléter ou reprendre la pratique.](exercices.llms.md)

## Je suis bloqué·e

Vérifiez d’abord :

1.  le dossier du projet R;
2.  le chemin du fichier CSV;
3.  le chargement des packages avec `library(tidyverse)` et `library(janitor)`;
4.  le nom exact des variables;
5.  le message d’erreur complet;
6.  le code correspondant dans le guide d’atelier.

## Pour la suite

Cet atelier prépare la séance sur la régression linéaire. Après avoir décrit un tableau, vous commencerez à vous demander si deux variables semblent liées et comment mesurer cette relation avec un modèle.
