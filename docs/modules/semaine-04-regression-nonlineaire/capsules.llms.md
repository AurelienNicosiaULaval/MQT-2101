# Capsules - Module 04

## Objectif

Les six capsules construisent une comparaison de modèles sur le lien entre l’achalandage et les ventes. Les données sont simulées. Le code complet est dans les [démonstrations R](../../modules/semaine-04-regression-nonlineaire/demonstrations.llms.md).

Ouvrez le PDF ou le support HTML avec code copiable, puis réalisez la production autonome dans `comparaison_achalandage.qmd`. Les activités 4.1 à 4.6 du parcours reprennent ces productions : il suffit de les faire une fois. Les vidéos ne sont pas encore disponibles.

Les exercices liés sous certaines capsules utilisent un autre cas, sur l’utilisation et l’attente. Ils alimentent le projet distinct `comparaison-attente`, avec des corrigés à ouvrir après une première tentative.

## Capsule 1 - Reconnaître une relation non linéaire

Une direction veut estimer ses ventes. Une droite suppose une variation moyenne constante; les données peuvent suggérer un ralentissement.

## Vidéo

La vidéo n’est pas encore disponible. Vous pouvez consulter les supports ci-dessous.

## PDF

[Ouvrir le PDF](media/pdf/capsule-01-support.pdf)

## HTML

[Ouvrir le support HTML dans un nouvel onglet](media/qmd/capsule-01-support.llms.md)

À faire après la capsule : Produisez le nuage achalandage-ventes sur janvier à septembre. Décrivez la direction, une courbure possible et la dispersion. Nommez les unités et une limite.

> **NOTE:**
>
> Faites l’[exercice 1](../../modules/semaine-04-regression-nonlineaire/exercices.llms.md#exercice-1---lire-le-graphique) sur le cas d’attente. Commencez par la [préparation du projet](../../modules/semaine-04-regression-nonlineaire/exercices.llms.md#préparation). Tentez votre réponse avant d’ouvrir le corrigé.

## Capsule 2 - Comprendre la saturation

La capacité, l’attente et les ruptures de stock peuvent éclairer le contexte. Un graphique ne permet pas d’isoler leur effet causal.

## Vidéo

La vidéo n’est pas encore disponible. Vous pouvez consulter les supports ci-dessous.

## PDF

[Ouvrir le PDF](media/pdf/capsule-02-support.pdf)

## HTML

[Ouvrir le support HTML dans un nouvel onglet](media/qmd/capsule-02-support.llms.md)

À faire après la capsule : Choisissez un indice parmi le taux d’occupation, l’attente et les ruptures de stock. Décrivez ce qu’il mesure, une hypothèse opérationnelle et une autre explication possible.

## Capsule 3 - Ajouter une transformation simple

Une droite, une courbe quadratique et un logarithme imposent des formes différentes. Le choix doit rester lisible sur l’échelle des ventes.

## Vidéo

La vidéo n’est pas encore disponible. Vous pouvez consulter les supports ci-dessous.

## PDF

[Ouvrir le PDF](media/pdf/capsule-03-support.pdf)

## HTML

[Ouvrir le support HTML dans un nouvel onglet](media/qmd/capsule-03-support.llms.md)

À faire après la capsule : Ajustez les trois modèles sur janvier à septembre. Avec le modèle quadratique, comparez la hausse prédite de 2 000 à 2 100 visites à celle de 3 000 à 3 100 visites.

> **NOTE:**
>
> Faites l’[exercice 2](../../modules/semaine-04-regression-nonlineaire/exercices.llms.md#exercice-2---ajuster-deux-modèles) sur le cas d’attente. Tentez votre réponse avant d’ouvrir le corrigé.

## Capsule 4 - Comparer plusieurs modèles

Une courbe peut réduire les résidus d’apprentissage sans mieux prédire. Les mêmes mois de validation doivent servir à comparer tous les candidats.

## Vidéo

La vidéo n’est pas encore disponible. Vous pouvez consulter les supports ci-dessous.

## PDF

[Ouvrir le PDF](media/pdf/capsule-04-support.pdf)

## HTML

[Ouvrir le support HTML dans un nouvel onglet](media/qmd/capsule-04-support.llms.md)

À faire après la capsule : Construisez un tableau avec le R² d’apprentissage et les RMSE d’apprentissage et de validation des trois modèles. Proposez un choix provisoire et deux limites.

> **NOTE:**
>
> Faites l’[exercice 3](../../modules/semaine-04-regression-nonlineaire/exercices.llms.md#exercice-3---calculer-la-rmse) sur le cas d’attente. Tentez votre réponse avant d’ouvrir le corrigé.

## Capsule 5 - Prédire et éviter l’extrapolation

Des modèles proches sur les données peuvent diverger fortement au-delà. Un intervalle calculé ne garantit pas la bonne forme de la courbe.

## Vidéo

La vidéo n’est pas encore disponible. Vous pouvez consulter les supports ci-dessous.

## PDF

[Ouvrir le PDF](media/pdf/capsule-05-support.pdf)

## HTML

[Ouvrir le support HTML dans un nouvel onglet](media/qmd/capsule-05-support.llms.md)

À faire après la capsule : Prédisez les ventes pour 2 500 visites avec le modèle quadratique et son intervalle de prédiction. Comparez ensuite les trois prédictions à 6 000 visites et expliquez pourquoi elles ne justifient pas une recommandation.

> **NOTE:**
>
> Faites l’[exercice 4](../../modules/semaine-04-regression-nonlineaire/exercices.llms.md#exercice-4---interpréter-la-saturation) sur le cas d’attente. Tentez votre réponse avant d’ouvrir le corrigé.

## Capsule 6 - Communiquer le choix du modèle

La direction a besoin d’un résultat chiffré, d’une plage d’utilisation et d’une limite. Le classement des modèles ne constitue pas à lui seul une décision de gestion.

## Vidéo

La vidéo n’est pas encore disponible. Vous pouvez consulter les supports ci-dessous.

## PDF

[Ouvrir le PDF](media/pdf/capsule-06-support.pdf)

## HTML

[Ouvrir le support HTML dans un nouvel onglet](media/qmd/capsule-06-support.llms.md)

À faire après la capsule : Rédigez cinq phrases : question, forme observée, comparaison chiffrée, plage d’utilisation et limite. Ajoutez au rapport une donnée à recueillir avant toute décision de capacité.

> **NOTE:**
>
> Faites les [exercices 5 et 6](../../modules/semaine-04-regression-nonlineaire/exercices.llms.md#exercice-5---conclusion-prudente) sur le cas d’attente. Tentez votre réponse avant d’ouvrir le corrigé.

## Après les capsules

Terminez les exercices restants et relisez vos conclusions. Les [notes de cours](../../modules/semaine-04-regression-nonlineaire/notes-cours.llms.md), également disponibles en [PDF](media/pdf/notes-cours.pdf), rassemblent les repères du module.
