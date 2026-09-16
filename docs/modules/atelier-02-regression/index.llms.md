# Laboratoire 02

Choisir et défendre un modèle de régression

Deuxième laboratoire en classe

## Une droite suffit-elle pour décrire les ventes?

Vous reprenez la démarche du laboratoire 1 : comprendre les données, produire des résultats et répondre à une direction fictive. Cette fois, vous choisissez une relation à étudier, comparez deux modèles et défendez votre choix dans un court rapport Quarto.

> **NOTE:**
>
> Le dossier fourni contient l’importation et un début de rapport. À vous de choisir la variable explicative, de construire les graphiques, d’écrire les modèles et d’organiser les résultats. Les consignes et les indices restent disponibles dans le guide; l’enseignant vous accompagne pendant la séance.

Le laboratoire mobilise les modules 3 et 4. Il est formatif, sans points dans la note finale, et prépare les dernières vérifications du [mini-rapport 1](../../evaluations/mini-rapport-1.llms.md).

## Avant l’atelier

- Reprenez la rétroaction reçue au laboratoire 1 et choisissez un point à améliorer dans ce nouveau rapport.
- Revoyez les [repères du module 3](../../modules/semaine-03-regression-lineaire/index.llms.md) : droite, coefficients, R², résidus et prédiction.
- Revoyez les [repères du module 4](../../modules/semaine-04-regression-nonlineaire/index.llms.md) : quadratique, logarithme, comparaison et extrapolation.
- Téléchargez puis décompressez le [dossier de départ](../../assets/exemples/laboratoire-02.zip). Ouvrez `laboratoire-02.Rproj`, puis `rapport-labo-02.qmd` et cliquez sur Render.
- Apportez votre mini-rapport 1 en cours et une question précise, si vous en avez une.

La mission commence en classe. Si le premier rendu bloque, gardez le message d’erreur pour recevoir de l’aide.

## Pendant l’atelier

Le [guide de la mission](../../modules/atelier-02-regression/guide-atelier.llms.md) est le fil principal. Travaillez en binômes, avec un rapport par binôme; chaque personne doit pouvoir expliquer les deux modèles. Si vous travaillez seul, les mêmes productions sont attendues.

Le déroulement suivant présente les étapes de la séance.

| Étape | Travail | Résultat visé |
|----|----|----|
| 1 | Présentation et lancement | Comprendre la mission et les choix à faire |
| 2 | Données et question | Données vérifiées, variable explicative choisie |
| 3 | Exploration et droite de référence | Graphique, modèle et coefficients interprétés |
| 4 | Premier point de rétroaction | Expliquer le choix de la variante à essayer |
| 5 | Pause | Reprendre avec la comparaison |
| 6 | Variante et diagnostic | Deux modèles comparés et résidus examinés |
| 7 | Conclusion et relecture croisée | Une recommandation justifiée et une amélioration précise |
| 8 | Correction et rendu | HTML vérifié et bilan formatif |
| 9 | Questions sur le mini-rapport 1 | Vérifier un choix, une interprétation ou le dossier de remise |

Montrez votre tentative et expliquez ce que vous cherchez à obtenir lorsque vous demandez de l’aide.

## Production attendue

Un seul rapport, d’environ 500 à 700 mots hors code et tableaux, avec :

- une question et un diagnostic ciblé des données;
- un graphique de la relation, complété par les deux ajustements;
- une droite de référence et une variante quadratique ou logarithmique;
- un tableau comparatif et des interprétations en unités concrètes;
- un graphique de résidus pour le modèle retenu;
- une recommandation, une limite et un bilan de la rétroaction.

La longueur est un repère pour rester concis. Les attentes détaillées se trouvent dans le [guide](../../modules/atelier-02-regression/guide-atelier.llms.md#rapport-attendu). Vous pouvez retenir la droite si la variante n’apporte pas d’amélioration convaincante.

## Après l’atelier

Conservez le dossier complet avec le `.qmd`, le HTML et les données. Terminez les corrections discutées en classe et reportez les vérifications utiles à votre mini-rapport 1.

Le calendrier place ce laboratoire le jour de la remise du mini-rapport 1. Consultez les [consignes de l’évaluation](../../evaluations/mini-rapport-1.llms.md) et le [calendrier du cours](../../calendrier.llms.md) pour la remise. Le rapport de laboratoire est une pratique formative distincte.

## Ressources utiles

| Ressource | Quand l’utiliser |
|----|----|
| [Guide de la mission](../../modules/atelier-02-regression/guide-atelier.llms.md) | Question, étapes, indices et grille formative |
| [Présentation de lancement](../../modules/atelier-02-regression/presentation.llms.md) | Introduction en classe |
| [Dossier de départ : projet, QMD et CSV](../../assets/exemples/laboratoire-02.zip) | Pour commencer dans RStudio |
| [Aide R à la demande](../../modules/atelier-02-regression/demonstrations.llms.md) | Retrouver un geste après une première tentative |
| [Repères conceptuels](../../modules/atelier-02-regression/capsules.llms.md) | Vérifier une interprétation |
| [Exercices complémentaires](../../modules/atelier-02-regression/exercices.llms.md) | Pratique facultative sur un autre contexte |

## Auto-vérification

Je peux justifier ma variable explicative et la variante essayée.

Les deux modèles utilisent les mêmes lignes et les ventes en dollars.

Ma comparaison tient compte de l’ajustement, des résidus et de la simplicité.

Ma recommandation s’appuie sur deux résultats chiffrés et une limite précise.

Render refait l’analyse sans préparation dans la Console.
