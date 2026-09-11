# Laboratoire 01

Une mission d’analyse avec R et Quarto

Premier laboratoire en classe

## Quelle analyse proposer à la direction?

Après une courte présentation, vous explorerez les données d’une PME québécoise fictive. Votre mission sera de choisir une priorité de prochaine analyse et de la justifier dans un court rapport Quarto.

> **NOTE:**
>
> Ce travail sert à pratiquer les acquis des modules 1 et 2 et à recevoir une rétroaction. Il ne compte pas dans la note finale. Vous pourrez corriger votre démarche pendant la séance et préciser ce qui reste à travailler.

## Avant l’atelier

Préparez vos fichiers avant la séance. La mission commence en classe.

Apportez votre ordinateur et son chargeur.

Vérifiez que R, RStudio ou Positron et Quarto fonctionnent, à l’aide de la [page Installation](../../installation.llms.md).

Vérifiez que `library(tidyverse)` et `library(janitor)` s’exécutent.

Téléchargez le [dossier de départ du laboratoire](../../assets/exemples/laboratoire-01.zip), puis décompressez-le.

Ouvrez `laboratoire-01.Rproj`, puis `rapport-labo-01.qmd` et cliquez sur Render. Le gabarit doit produire un HTML avant même que vous commenciez l’analyse.

En cas de difficulté, consultez le [guide Quarto](../../ressources/guide-quarto.llms.md). Si le problème persiste, venez avec vos fichiers et le message d’erreur pour le signaler dès votre arrivée.

Les notions utiles sont l’unité d’observation, les types de variables, les valeurs manquantes, les résumés descriptifs et les graphiques. Les [exercices corrigés du module 2](../../modules/semaine-02-r-quarto/exercices.llms.md) restent disponibles pour revoir un geste précis.

## Pendant l’atelier

Ouvrez le [guide de la mission](../../modules/atelier-01-r/guide-atelier.llms.md). Il rassemble les consignes, les étapes, le contenu du rapport et la grille formative. Gardez-le à côté de votre document Quarto pendant le travail.

| Étape | Activité | Résultat visé |
|----|----|----|
| 1 | Courte présentation et lancement de la mission | Comprendre la question et le rapport attendu |
| 2 | Prise en main du dossier | Premier HTML, importation et unité d’observation |
| 3 | Diagnostic et tableau synthèse | Données vérifiées et comparaison des succursales |
| 4 | Premier point de rétroaction | Une vérification ou une correction à appliquer |
| 5 | Pause | Reprendre ensuite avec les graphiques |
| 6 | Deux graphiques et choix d’une priorité | Résultats utiles à la mission |
| 7 | Rédaction de la réponse à la direction | Trois constats chiffrés, une priorité et une limite |
| 8 | Relecture croisée et rétroaction | Un point réussi et une amélioration précise |
| 9 | Corrections, Render et bilan | Rapport lisible et prochaine étape personnelle |

Ces repères permettent d’avancer ensemble. Si vous bloquez, demandez de l’aide en montrant votre tentative, le résultat obtenu et votre question.

## Production attendue

Un seul rapport Quarto répond à la mission. Il réunit la description et le diagnostic des données, un tableau comparatif, deux graphiques commentés, trois constats chiffrés et une priorité de prochaine analyse justifiée. Le [gabarit fourni](../../assets/exemples/laboratoire-01.zip) contient déjà les sections à compléter et l’importation.

Visez environ 400 à 600 mots, hors code et tableaux. Cette longueur est un repère pour rester concis, pas un critère de notation. Les éléments attendus et les modalités de fin de séance se trouvent dans le [guide de la mission](../../modules/atelier-01-r/guide-atelier.llms.md#rapport-attendu).

## Après l’atelier

Conservez ensemble le `.qmd`, le `.html` et le dossier `data/`. Reprenez le point d’amélioration relevé pendant la rétroaction et notez une question à clarifier. Cette démarche vous prépare à la rédaction du [mini-rapport 1](../../evaluations/mini-rapport-1.llms.md), dont les consignes et l’évaluation sont distinctes.

## Ressources utiles

| Ressource | Quand l’utiliser |
|----|----|
| [Guide de la mission](../../modules/atelier-01-r/guide-atelier.llms.md) | Fil principal de la séance |
| [Présentation de lancement](../../modules/atelier-01-r/presentation.llms.md) | Support de la courte introduction en classe |
| [Dossier de départ : projet, QMD et CSV](../../assets/exemples/laboratoire-01.zip) | Pour commencer directement dans RStudio |
| [Démonstrations R](../../modules/atelier-01-r/demonstrations.llms.md) | Aide ponctuelle après une première tentative |
| [Repères conceptuels](../../modules/atelier-01-r/capsules.llms.md) | Pour retrouver une notion des modules 1 et 2 |
| [Exercices complémentaires](../../modules/atelier-01-r/exercices.llms.md) | Pratique facultative après la mission |

## Auto-vérification

Mon HTML répond à la mission avec des résultats produits dans mon `.qmd`.

Je peux expliquer ce que représente une ligne et ce que mes indicateurs résument.

J’ai tenu compte des valeurs manquantes et nommé une limite.

Ma priorité renvoie à des résultats précis de mon rapport.

J’ai appliqué une correction après la rétroaction ou noté la question qui reste ouverte.
