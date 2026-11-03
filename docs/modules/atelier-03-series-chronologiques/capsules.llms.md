# Repères préparatoires - Laboratoire 03

## Des repères pour une mission unique

Dans un seul rapport Quarto, vérifiez la série et le calendrier, comparez les cinq prévisions sur les mêmes treize semaines, puis recommandez une méthode avec deux mesures, le coût simulé, un intervalle identifié, une limite et une règle de surveillance.

## Auto-vérification de la production

- J’ai précisé l’origine, les dates et les unités.
- Je compare les cinq méthodes sur les mêmes cibles.
- Je distingue l’intervalle du SES et la méthode retenue.
- Ma recommandation cite des résultats, une limite et un suivi.

Ces repères et le [guide](../../modules/atelier-03-series-chronologiques/guide-atelier.llms.md) accompagnent le même `rapport-labo-03.qmd`. Ils ne créent pas une nouvelle production. La page est écrite; aucune vidéo n’est disponible.

## Formuler la mission

Complétez : « À la fin de \_\_\_\_\_\_\_\_\_\_, prévoir \_\_\_\_\_\_\_\_\_\_ pour les \_\_\_\_\_\_\_\_\_\_ prochaines semaines afin de \_\_\_\_\_\_\_\_\_\_. » La phrase nomme l’origine, la cible, l’horizon, les unités et la décision.

Ici, le lundi indique le début de la semaine. La demande totale de la semaine commençant le 22 septembre est connue le dimanche 28 septembre. Les treize cibles suivantes commencent le 29 septembre. Le cas et cette validation ont déjà été examinés aux modules 06 et 07.

## Préserver le futur

Les cinq méthodes sont annoncées avant la comparaison. Les paramètres et la dernière fenêtre sont calculés sur l’apprentissage. Les dates et indices futurs sont connus; les demandes, prix et promotions futurs ne sont pas fournis aux méthodes. Une moyenne qui utilise une semaine située après l’origine ne répond pas à la même question.

Le bloc utilisé pour choisir est une validation, sans nouveau test final indépendant. Une performance devra être réexaminée à d’autres origines.

## Cinq repères de prévision

Naïve : dernière demande; MM4 : moyenne des quatre dernières semaines; SES : niveau lissé estimé sur le passé; naïve saisonnière : semaine correspondante à retard 52; tendance : droite sur un indice continu. Les quatre premières sont reprises du module 07, la dernière mobilise la régression du module 08. L’ancienne comparaison du module 07 avait moins de candidats : un classement peut changer quand la liste change.

Holt amorti ajoute une pente et reste accompagné dans l’[aide R](../../modules/atelier-03-series-chronologiques/demonstrations.llms.md#holt), sans être exigé pour ce rapport. La fréquence 52 ne rend pas le SES saisonnier.

## Erreurs, incertitude et coûts

Avec `erreur = observé - prévu`, ME positive signifie sous-prévision moyenne; MAE résume l’amplitude et RMSE donne plus de poids aux grands écarts. Ces mesures sont en unités de produit. Les intervalles à 80 % et 95 % illustrent ici le SES : ils ne sont pas automatiquement ceux d’une autre méthode retenue. Les intervalles sont conditionnels aux hypothèses et marginaux pour chaque semaine.

Le scénario conserve 18 \$ par unité sous-prévue et 5 \$ par unité sur-prévue. Ce sont des coûts fictifs; une recommandation précise aussi les informations opérationnelles manquantes.

## Auto-diagnostic

1.  Quelle mesure pénalise davantage une grande erreur isolée?
2.  Que signifie une ME positive si l’erreur est `observé - prévu`?
3.  Pourquoi le classement des méthodes peut-il changer à une autre période?

> **TIP:**
>
> 1.  La RMSE. 2. Une sous-prévision moyenne. 3. Les structures et les chocs de la série changent; une seule période de validation fournit une preuve limitée.

## Retrouver une aide

Le [guide de la mission](../../modules/atelier-03-series-chronologiques/guide-atelier.llms.md), l’[exemple R](../../modules/atelier-03-series-chronologiques/demonstrations.llms.md), les [lectures](../../modules/atelier-03-series-chronologiques/lectures.llms.md) et les [exercices facultatifs](../../modules/atelier-03-series-chronologiques/exercices.llms.md) complètent ces rappels. L’objectif est d’utiliser les acquis dans le rapport, pas d’ajouter une lecture intégrale pendant la séance.
