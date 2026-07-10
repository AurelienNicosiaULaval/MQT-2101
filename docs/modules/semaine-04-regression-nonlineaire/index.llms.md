# Module 04

Régression non linéaire et transformations

Séance autonome

## Régression non linéaire et transformations

Reconnaître une relation qui n’est pas bien résumée par une droite, choisir une transformation simple et comparer plusieurs modèles sans perdre l’interprétation d’affaires.

Durée estimée

2 h 30 à 3 h

Outils

R, graphiques, transformations

Données

[achalandage_saturation_quebec.csv](../../donnees/#achalandage-et-saturation-de-succursales-fictives)

Trace finale

Comparaison de modèles

## On passe au concret

> **NOTE:**
>
> Une direction observe que les ventes augmentent lorsque l’achalandage augmente, mais cette hausse semble ralentir lorsque les succursales approchent leur capacité. Une droite peut alors exagérer les ventes attendues aux très hauts niveaux d’achalandage.
>
> Le module sert à décider si un modèle linéaire simple est suffisant ou si une transformation, par exemple un terme quadratique ou un logarithme, décrit mieux la relation.

À la fin du module, vous devriez pouvoir :

- repérer une courbure dans un nuage de points;
- expliquer pourquoi une droite peut être trompeuse en présence de saturation;
- ajuster un modèle linéaire, un modèle quadratique et un modèle logarithmique;
- comparer les modèles avec un graphique, les résidus et une mesure d’erreur;
- interpréter les résultats sur l’échelle originale des données;
- éviter l’extrapolation au-delà des valeurs observées.

## Votre parcours

> **NOTE:**
>
> Le support global de notes de cours est disponible en [HTML](../../modules/semaine-04-regression-nonlineaire/notes-cours.llms.md) et en [PDF](media/pdf/notes-cours.pdf). Il sert de synthèse du module; les supports détaillés sont associés aux capsules.

Revenez toujours à cette page pour garder le fil. Cliquez sur une carte pour ouvrir l’étape complète : objectif, ressource, action et activité associée.

1Reconnaître la courbureVoir pourquoi une droite ne suffit pas toujours.[Capsule 1](capsules.llms.md#capsule-1---reconnaître-une-relation-non-linéaire)[Démo](demonstrations.llms.md#visualiser-la-courbure)[Ex. 1](exercices.llms.md#exercice-1---lire-le-graphique)Ouvrir l'étapeRéduire

Objectif Repérer visuellement une relation avec courbure ou saturation.

Ressource [Capsule 1](capsules.llms.md#capsule-1---reconnaître-une-relation-non-linéaire) [Démonstration](demonstrations.llms.md#visualiser-la-courbure) [Exercice 1](exercices.llms.md#exercice-1---lire-le-graphique)

Action Produire le nuage de points entre achalandage et ventes.

Activité 4.1 - Forme observée

Décrivez la relation avec les mots hausse, ralentissement et saturation.

2Relier la saturation au contexteUtiliser capacité, attente et ruptures de stock pour interpréter la forme.[Capsule 2](capsules.llms.md#capsule-2---comprendre-la-saturation)Ouvrir l'étapeRéduire

Objectif Expliquer pourquoi une relation peut ralentir à haut achalandage.

Ressource [Capsule 2](capsules.llms.md#capsule-2---comprendre-la-saturation)

Action Identifier les variables qui peuvent signaler une contrainte opérationnelle.

Activité 4.2 - Indices de saturation

Associez \`taux_occupation\`, \`temps_attente_minutes\` ou \`ruptures_stock\` à une hypothèse de saturation.

3Transformer la relationAjouter un terme quadratique ou un logarithme lorsque la forme le justifie.[Capsule 3](capsules.llms.md#capsule-3---ajouter-une-transformation-simple)[Démo](demonstrations.llms.md#ajuster-trois-modèles)[Ex. 2](exercices.llms.md#exercice-2---ajuster-deux-modèles)Ouvrir l'étapeRéduire

Objectif Comprendre ce qu'un terme quadratique ou logarithmique change dans le modèle.

Ressource [Capsule 3](capsules.llms.md#capsule-3---ajouter-une-transformation-simple) [Démonstration](demonstrations.llms.md#ajuster-trois-modèles) [Exercice 2](exercices.llms.md#exercice-2---ajuster-deux-modèles)

Action Ajuster au moins deux modèles candidats.

Activité 4.3 - Transformation

Expliquez ce qu'une courbe permet de représenter qu'une droite ne représente pas.

4Comparer les modèlesUtiliser graphique, résidus et RMSE pour justifier un choix.[Capsule 4](capsules.llms.md#capsule-4---comparer-plusieurs-modèles)[Démo](demonstrations.llms.md#comparer-lajustement)[Ex. 3](exercices.llms.md#exercice-3---calculer-la-rmse)Ouvrir l'étapeRéduire

Objectif Comparer sans se limiter au plus grand R².

Ressource [Capsule 4](capsules.llms.md#capsule-4---comparer-plusieurs-modèles) [Démonstration](demonstrations.llms.md#comparer-lajustement) [Exercice 3](exercices.llms.md#exercice-3---calculer-la-rmse)

Action Comparer au moins deux modèles avec un critère visuel et un critère numérique.

Activité 4.4 - Grille de comparaison

Remplissez trois cases : graphique, erreur, interprétation.

5Prédire avec prudenceComprendre la plage observée et la limite d'extrapolation.[Capsule 5](capsules.llms.md#capsule-5---prédire-et-éviter-lextrapolation)[Démo](demonstrations.llms.md#superposer-les-prédictions)Ouvrir l'étapeRéduire

Objectif Utiliser les prédictions sans sortir abusivement des données observées.

Ressource [Capsule 5](capsules.llms.md#capsule-5---prédire-et-éviter-lextrapolation) [Démonstration](demonstrations.llms.md#superposer-les-prédictions)

Action Superposer les prédictions dans la plage observée.

Activité 4.5 - Extrapolation

Rédigez une phrase qui interdit d'utiliser le modèle loin hors de la plage observée sans données supplémentaires.

6Communiquer le choixTransformer la comparaison technique en recommandation prudente.[Capsule 6](capsules.llms.md#capsule-6---communiquer-le-choix-du-modèle)[Démo](demonstrations.llms.md#conclusion-prudente)[Ex. 5](exercices.llms.md#exercice-5---conclusion-prudente)Ouvrir l'étapeRéduire

Objectif Justifier un modèle dans une conclusion utile pour la décision.

Ressource [Capsule 6](capsules.llms.md#capsule-6---communiquer-le-choix-du-modèle) [Démonstration](demonstrations.llms.md#conclusion-prudente) [Exercice 5](exercices.llms.md#exercice-5---conclusion-prudente)

Action Rédiger une conclusion qui relie courbure, saturation, décision et limite.

Activité 4.6 - Conclusion appliquée

Rédigez : forme observée, modèle retenu, argument, décision possible, limite.

## Avant de commencer

Téléchargez ou repérez le fichier [`achalandage_saturation_quebec.csv`](data/achalandage_saturation_quebec.csv). Chaque ligne représente une combinaison mois-succursale pour des succursales fictives.

Variables centrales :

- `ventes` : variable réponse;
- `achalandage` : variable explicative principale;
- `taux_occupation` : niveau d’utilisation de la capacité de référence;
- `temps_attente_minutes` et `ruptures_stock` : signes possibles de saturation;
- `depenses_marketing`, `succursale`, `saison` : variables de contexte.

## Trace finale

Votre trace finale doit inclure :

1.  la question d’analyse;
2.  un graphique montrant la relation entre achalandage et ventes;
3.  une comparaison entre au moins deux modèles;
4.  un argument clair pour choisir un modèle;
5.  une limite sur l’extrapolation;
6.  une interprétation prudente liée à la décision.

> **TIP:**
>
> Une bonne conclusion ressemble à ceci : « Les ventes augmentent avec l’achalandage, mais la relation semble ralentir aux niveaux élevés. Un modèle avec courbure décrit mieux cette saturation qu’une droite, sans prouver à lui seul la cause de cette saturation. »

## Ressources du module

[CapsulesSix capsules courtes avec supports HTML/PDF sur courbure, saturation et transformations.](capsules.llms.md) [Notes de coursSynthèse globale du module en format RevealJS.](notes-cours.llms.md) [Démonstrations RComparer plusieurs modèles sur les mêmes données.](demonstrations.llms.md) [ExercicesChoisir un modèle, justifier le choix et formuler une limite.](exercices.llms.md) [LecturesApprofondir transformations, diagnostics et interprétation.](lectures.llms.md)

> **WARNING:**
>
> - Choisir automatiquement le modèle qui a le plus grand `R²`.
> - Oublier que le modèle quadratique peut devenir irréaliste hors de la plage observée.
> - Interpréter une courbe comme une preuve de saturation causée par un seul facteur.
> - Comparer des modèles sans regarder les prédictions superposées aux données.
> - Présenter une transformation sans expliquer ce qu’elle change dans l’interprétation.
> - Faire une recommandation opérationnelle sans mentionner la limite d’extrapolation.

## Auto-vérification

Avant de passer au module suivant, je peux dire que :

J’ai reconnu une relation non linéaire dans un graphique.

J’ai expliqué l’idée de saturation dans un contexte d’affaires.

J’ai ajusté au moins deux modèles candidats.

J’ai comparé les modèles avec un graphique et une mesure d’erreur.

J’ai nommé une limite d’extrapolation.

J’ai formulé une recommandation prudente.

> **NOTE:**
>
> Vous pouvez utiliser le [GPT du cours](https://chatgpt.com/g/g-6a0b2ec33d948191ad25b2f247b15de1-analyse-et-modelisation-des-donnees?ref=mini) pour relire votre comparaison de modèles. Son rôle est de signaler les arguments incomplets, les diagnostics manquants et les conclusions qui dépassent les données. Il ne doit pas choisir le modèle à votre place sans justification.
>
> Suggestion de demande :
>
> > Voici ma comparaison de modèles pour le module 04. Vérifie si j’utilise au moins un argument graphique, un argument numérique, un diagnostic et une limite d’extrapolation. Indique les passages à clarifier, sans rédiger la conclusion à ma place.
>
> Après cette vérification, notez l’argument le plus faible de votre comparaison et améliorez-le.

## Je suis bloqué·e

Avant de demander de l’aide, vérifiez dans l’ordre :

1.  le chargement de `tidyverse`;
2.  le chemin vers `achalandage_saturation_quebec.csv`;
3.  le nuage de points entre `achalandage` et `ventes`;
4.  le modèle linéaire;
5.  le modèle quadratique ou logarithmique;
6.  le graphique des prédictions;
7.  les résidus et la RMSE;
8.  la plage des valeurs d’achalandage observées.

## Pour aller plus loin

- Comparer une conclusion basée seulement sur le `R²` avec une conclusion qui utilise aussi les résidus.
- Identifier une situation d’affaires où une relation saturée serait plausible.
- Reprendre la conclusion en précisant ce qui relève du résultat statistique et ce qui relève de la décision de gestion.
