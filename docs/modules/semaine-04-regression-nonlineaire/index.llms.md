# Module 04

Régression non linéaire et transformations

Séance autonome

## Régression non linéaire et transformations

Reconnaître une courbure, ajuster trois formes candidates et justifier un choix avec des graphiques, des erreurs de validation et des limites explicites.

Organisation

À votre rythme

Outils

R, RStudio et Quarto

Cas guidé

Achalandage et ventes

Trace finale

Comparaison de modèles

## On passe au concret

> **NOTE:**
>
> Une direction veut décrire le lien entre l’achalandage et les ventes mensuelles de ses succursales. Une droite suppose une hausse constante. Les données peuvent suggérer un ralentissement, sans prouver un plafond ni sa cause. Quelle forme est la plus défendable : droite, quadratique ou logarithme?

À la fin du module, vous devriez pouvoir lire une courbure, ajuster ces trois formes avec `lm()`, comparer leurs erreurs sur les mêmes observations mises de côté, interpréter une prédiction et rédiger une conclusion prudente.

La réponse reste quantitative. Ces transformations de x sont linéaires en leurs coefficients. La [régression logistique du module 10](../../modules/semaine-10-classification-modeles-avances/index.llms.md) répond à une autre question : modéliser une probabilité pour une réponse binaire.

## Avant de commencer

Créez le projet RStudio `comparaison-achalandage`, placez [achalandage_saturation_quebec.csv](data/achalandage_saturation_quebec.csv) dans `data`, puis créez `comparaison_achalandage.qmd` à la racine. La [préparation des démonstrations](../../modules/semaine-04-regression-nonlineaire/demonstrations.llms.md#préparation) détaille les clics et le code.

Une ligne correspond à une succursale fictive pendant un mois : 72 observations, six succursales et douze mois en 2025. L’achalandage compte des visites; les ventes sont en dollars canadiens. Les taux d’occupation, l’attente et les ruptures de stock donnent le contexte.

Fixez la séparation avant la comparaison : janvier à septembre pour l’apprentissage, octobre à décembre pour la validation. Les modèles des capsules et des démonstrations utilisent exactement cette séparation.

## Votre parcours

Suivez les six capsules dans l’ordre. Les activités 4.1 à 4.6 correspondent aux productions autonomes de fin de capsule : il n’est pas nécessaire de les refaire. Elles construisent le rapport guidé sur les ventes.

Les liens « Ex. » indiquent quand passer au cas distinct sur l’attente, dans le projet `comparaison-attente`. Suivez d’abord la [préparation des exercices](../../modules/semaine-04-regression-nonlineaire/exercices.llms.md#préparation). Les corrigés sont fermés par défaut et se consultent après une tentative.

Les supports sont disponibles en HTML et PDF, avec du code copiable dans les versions HTML. Les vidéos ne sont pas encore disponibles.

> **NOTE:**
>
> La synthèse est disponible en [HTML](../../modules/semaine-04-regression-nonlineaire/notes-cours.llms.md) et en [PDF](media/pdf/notes-cours.pdf). Les supports détaillés sont associés aux capsules.

Cliquez sur une carte pour ouvrir l’étape complète : objectif, ressource, action et activité associée.

1Reconnaître une relation non linéaire La hausse reste-t-elle la même à tous les niveaux d’achalandage?[Capsule 1](capsules.llms.md#capsule-1---reconnaître-une-relation-non-linéaire)[Démo](demonstrations.llms.md#visualiser-la-courbure)[Ex. 1](exercices.llms.md#exercice-1---lire-le-graphique) Ouvrir l’étapeRéduire

Objectif Définir la question et les unités.

Ressource [Capsule 1](capsules.llms.md#capsule-1---reconnaître-une-relation-non-linéaire) et [démonstration R](demonstrations.llms.md#visualiser-la-courbure).

Action Réaliser la production dans votre rapport guidé.

Activité 4.1 - Reconnaître une relation non linéaire

Produisez le nuage achalandage-ventes sur janvier à septembre. Décrivez la direction, une courbure possible et la dispersion. Nommez les unités et une limite.

Exercice distinct Passez à l’[exercice 1](exercices.llms.md#exercice-1---lire-le-graphique) sur l’attente; tentez une réponse avant d’ouvrir le corrigé.

2Comprendre la saturation Un ralentissement des ventes prouve-t-il un manque de capacité?[Capsule 2](capsules.llms.md#capsule-2---comprendre-la-saturation)[Démo](demonstrations.llms.md#relier-la-forme-au-contexte) Ouvrir l’étapeRéduire

Objectif Relier un indice au contexte.

Ressource [Capsule 2](capsules.llms.md#capsule-2---comprendre-la-saturation) et [démonstration R](demonstrations.llms.md#relier-la-forme-au-contexte).

Action Réaliser la production dans votre rapport guidé.

Activité 4.2 - Comprendre la saturation

Choisissez un indice parmi le taux d’occupation, l’attente et les ruptures de stock. Décrivez ce qu’il mesure, une hypothèse opérationnelle et une autre explication possible.

3Ajouter une transformation simple Comment représenter une hausse qui ralentit?[Capsule 3](capsules.llms.md#capsule-3---ajouter-une-transformation-simple)[Démo](demonstrations.llms.md#ajuster-trois-modèles)[Ex. 2](exercices.llms.md#exercice-2---ajuster-deux-modèles) Ouvrir l’étapeRéduire

Objectif Écrire trois modèles candidats.

Ressource [Capsule 3](capsules.llms.md#capsule-3---ajouter-une-transformation-simple) et [démonstration R](demonstrations.llms.md#ajuster-trois-modèles).

Action Réaliser la production dans votre rapport guidé.

Activité 4.3 - Ajouter une transformation simple

Ajustez les trois modèles sur janvier à septembre. Avec le modèle quadratique, comparez la hausse prédite de 2 000 à 2 100 visites à celle de 3 000 à 3 100 visites.

Exercice distinct Passez à l’[exercice 2](exercices.llms.md#exercice-2---ajuster-deux-modèles) sur l’attente; tentez une réponse avant d’ouvrir le corrigé.

4Comparer plusieurs modèles Le modèle le plus souple prédit-il mieux les mois suivants?[Capsule 4](capsules.llms.md#capsule-4---comparer-plusieurs-modèles)[Démo](demonstrations.llms.md#comparer-lajustement)[Ex. 3](exercices.llms.md#exercice-3---calculer-la-rmse) Ouvrir l’étapeRéduire

Objectif Séparer apprentissage et validation.

Ressource [Capsule 4](capsules.llms.md#capsule-4---comparer-plusieurs-modèles) et [démonstration R](demonstrations.llms.md#comparer-lajustement).

Action Réaliser la production dans votre rapport guidé.

Activité 4.4 - Comparer plusieurs modèles

Construisez un tableau avec le R² d’apprentissage et les RMSE d’apprentissage et de validation des trois modèles. Proposez un choix provisoire et deux limites.

Exercice distinct Passez à l’[exercice 3](exercices.llms.md#exercice-3---calculer-la-rmse) sur l’attente; tentez une réponse avant d’ouvrir le corrigé.

5Prédire et éviter l’extrapolation Que vaut une prédiction à un niveau d’achalandage jamais observé?[Capsule 5](capsules.llms.md#capsule-5---prédire-et-éviter-lextrapolation)[Démo](demonstrations.llms.md#prédire-et-vérifier-la-plage)[Ex. 4](exercices.llms.md#exercice-4---interpréter-la-saturation) Ouvrir l’étapeRéduire

Objectif Délimiter la plage d’apprentissage.

Ressource [Capsule 5](capsules.llms.md#capsule-5---prédire-et-éviter-lextrapolation) et [démonstration R](demonstrations.llms.md#prédire-et-vérifier-la-plage).

Action Réaliser la production dans votre rapport guidé.

Activité 4.5 - Prédire et éviter l’extrapolation

Prédisez les ventes pour 2 500 visites avec le modèle quadratique et son intervalle de prédiction. Comparez ensuite les trois prédictions à 6 000 visites et expliquez pourquoi elles ne justifient pas une recommandation.

Exercice distinct Passez à l’[exercice 4](exercices.llms.md#exercice-4---interpréter-la-saturation) sur l’attente; tentez une réponse avant d’ouvrir le corrigé.

6Communiquer le choix du modèle Comment justifier un choix sans promettre plus que les données?[Capsule 6](capsules.llms.md#capsule-6---communiquer-le-choix-du-modèle)[Démo](demonstrations.llms.md#conclusion-prudente)[Ex. 5 et 6](exercices.llms.md#exercice-5---conclusion-prudente) Ouvrir l’étapeRéduire

Objectif Rassembler les résultats utiles.

Ressource [Capsule 6](capsules.llms.md#capsule-6---communiquer-le-choix-du-modèle) et [démonstration R](demonstrations.llms.md#conclusion-prudente).

Action Réaliser la production dans votre rapport guidé.

Activité 4.6 - Communiquer le choix du modèle

Rédigez cinq phrases : question, forme observée, comparaison chiffrée, plage d’utilisation et limite. Ajoutez au rapport une donnée à recueillir avant toute décision de capacité.

Exercice distinct Passez aux [exercices 5 et 6](exercices.llms.md#exercice-5---conclusion-prudente) sur l’attente; tentez une réponse avant d’ouvrir le corrigé.

## Exercices d’application

Les [six exercices et leurs corrigés détaillés](../../modules/semaine-04-regression-nonlineaire/exercices.llms.md) étudient le taux d’utilisation et le temps d’attente dans quatre succursales fictives. Le choix du modèle doit être justifié par les résultats de ce nouveau cas. Les exercices réalisés au fil des capsules ne sont pas à refaire.

## Trace finale

Le rapport guidé `comparaison_achalandage.qmd` rassemble :

1.  la question, les unités et la séparation des périodes;
2.  le nuage d’apprentissage et les trois modèles;
3.  les erreurs d’apprentissage et de validation;
4.  les résidus et leur interprétation;
5.  une prédiction dans la plage connue et une comparaison en extrapolation;
6.  une conclusion chiffrée, sa limite et une prochaine collecte.

Le rapport distinct `comparaison_attente.qmd` est précisé à l’[exercice 6](../../modules/semaine-04-regression-nonlineaire/exercices.llms.md#exercice-6---mini-trace-de-comparaison). Redémarrez R puis utilisez Render pour vérifier les deux documents. Ce sont des entraînements; les consignes des travaux évalués restent dans [Évaluations](../../evaluations/index.llms.md).

## Ressources du module

- [Capsules et supports HTML/PDF](../../modules/semaine-04-regression-nonlineaire/capsules.llms.md)
- [Synthèse](../../modules/semaine-04-regression-nonlineaire/notes-cours.llms.md)
- [Démonstrations R complètes](../../modules/semaine-04-regression-nonlineaire/demonstrations.llms.md)
- [Exercices et solutions détaillées](../../modules/semaine-04-regression-nonlineaire/exercices.llms.md)
- [Lectures et documentation](../../modules/semaine-04-regression-nonlineaire/lectures.llms.md)

> **WARNING:**
>
> - Choisir automatiquement le plus grand R² d’apprentissage.
> - Réajuster un modèle sur la validation avant de calculer son erreur.
> - Interpréter une courbe comme une preuve de saturation ou de causalité.
> - Confondre logarithmique et logistique.
> - Confondre 10 % relatifs et 10 points de pourcentage.
> - Croire qu’un intervalle de prédiction rend l’extrapolation fiable.

## Auto-vérification

J’ai identifié les variables, les unités et la forme du nuage.

Mes trois modèles utilisent les mêmes observations d’apprentissage.

J’ai calculé les erreurs sur la même période de validation.

J’ai lu les résidus et les limites liées aux succursales répétées.

Je distingue une courbure d’un plateau.

Je sais justifier un modèle simple quand la complexité n’apporte pas de gain utile.

Mes deux rapports se recalculent après redémarrage de R.

> **NOTE:**
>
> Après une première tentative, vous pouvez demander au [GPT du cours](https://chatgpt.com/g/g-6a0b2ec33d948191ad25b2f247b15de1-analyse-et-modelisation-des-donnees?ref=mini) de vérifier votre comparaison. Demandez-lui de repérer une confusion entre apprentissage et validation, une unité manquante ou une conclusion trop forte, sans rédiger la réponse à votre place. Corrigez ensuite votre propre raisonnement.

## Je suis bloqué·e

Vérifiez le chargement de `tidyverse`, le dossier `data`, les noms des variables, les dates de séparation et les unités. Le nom de la variable fourni à `predict()` doit correspondre à celui de la formule. Reprenez les [démonstrations](../../modules/semaine-04-regression-nonlineaire/demonstrations.llms.md) dans l’ordre avec une session R redémarrée.

## Pour aller plus loin

Examinez la stabilité du classement sur d’autres périodes, sans recycler indéfiniment la même validation. Les dépendances temporelles seront approfondies dans les modules de séries chronologiques; la réponse binaire et la logistique sont au module 10.
