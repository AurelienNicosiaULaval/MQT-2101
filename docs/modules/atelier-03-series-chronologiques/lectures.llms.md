# Lectures - Laboratoire 03

## Avant et pendant la séance

Ces explications et les [repères](../../modules/atelier-03-series-chronologiques/capsules.llms.md) suffisent pour suivre le [guide](../../modules/atelier-03-series-chronologiques/guide-atelier.llms.md). Les passages externes sont facultatifs et ciblés; il n’est pas nécessaire de lire les chapitres entiers avant la séance.

| Question | Lecture française et vérification | Complément facultatif |
|----|----|----|
| Quand la semaine est-elle connue? | [Démonstration : audit](../../modules/atelier-03-series-chronologiques/demonstrations.llms.md#audit). Une date de début n’est pas la fin de la période. | [Module 06 : origine et horizon](../../modules/semaine-06-series-chronologiques-intro/lectures.llms.md). |
| Quels candidats sont disponibles? | [Démonstration : prévisions](../../modules/atelier-03-series-chronologiques/demonstrations.llms.md#previsions). La même origine et les mêmes cibles s’appliquent à tous. | [Module 07 : lissage](../../modules/semaine-07-lissage/lectures.llms.md) et [module 08 : tendance](../../modules/semaine-08-tendance-saisonnalite/lectures.llms.md#lecture-2). |
| Comment lire les résultats? | [Comparaison](../../modules/atelier-03-series-chronologiques/demonstrations.llms.md#comparaison). ME, MAE, RMSE et intervalle sont associés à des méthodes et unités précises. | Hyndman et Athanasopoulos (2021), [exactitude des prévisions](https://otexts.com/fpp3/toolbox.html#sec-accuracy). |
| Comment traduire un risque? | [Décision](../../modules/atelier-03-series-chronologiques/demonstrations.llms.md#decision). Le coût est un scénario fixé à l’avance, pas une facture observée. | [Module 07 : coût asymétrique](../../modules/semaine-07-lissage/lectures.llms.md). |

## Lire une comparaison temporelle

Le résidu est calculé sur les observations utilisées pour ajuster un modèle; l’erreur de prévision compare une observation future à une valeur émise auparavant. Des erreurs de même signe peuvent signaler une difficulté, mais treize semaines ne suffisent pas à prouver sa cause.

Choisir la plus petite MAE sur les mêmes semaines utilisées pour l’afficher peut donner une appréciation optimiste. Cette validation est déjà connue des modules 06 et 07. Avant une utilisation réelle, il faudrait comparer à d’autres origines et documenter ce qui était connu à chacune. Une seule ME peut masquer des erreurs positives et négatives qui se compensent.

## Lire l’incertitude et le coût

Un intervalle de prévision décrit une plage pour une observation future sous les hypothèses de la méthode nommée. Le rapport illustre le SES; les intervalles ne deviennent pas automatiquement ceux d’une autre méthode. Les intervalles marginaux de treize semaines ne garantissent pas une couverture simultanée de 95 % sur tout l’horizon.

Les 18 \$ et 5 \$ sont des coefficients fictifs par unité d’écart. Le coût calculé est la somme dans ce scénario, sans données réelles de commandes, stock ou délais. Une comparaison de prévisions aide une décision, mais ne détermine pas seule la quantité à commander.

## Compléments et ancien matériel

Le [cahier du module 07](../../modules/semaine-07-lissage/complements.llms.md) conserve les différences, la réintégration, Holt-Winters, ETS, BATS, TBATS et STL avec ETS; le [cahier du module 08](../../modules/semaine-08-tendance-saisonnalite/complements.llms.md) conserve les tendances plus souples, la décomposition, les harmoniques et la stationnarité. Ces prolongements demandent leurs prérequis et ne s’ajoutent pas à la mission.

Les anciens exercices sur la température et les taux de change utilisaient des séries quotidiennes. La fréquence et les dates manquantes doivent être vérifiées dans chaque jeu : enlever des dates sans examiner le calendrier ne rend pas les observations régulièrement espacées. Les archives anciennes et leurs données de tiers ne sont pas redistribuées ici.

## Sources ciblées

- Hyndman, R. J., et Athanasopoulos, G. (2021), Forecasting: Principles and Practice, 3e édition : [méthodes simples et exactitude](https://otexts.com/fpp3/toolbox.html#sec-accuracy), [prédicteurs temporels](https://otexts.com/fpp3/regression.html#sec-useful-predictors) et [lissage exponentiel](https://otexts.com/fpp3/exponential-smoothing.html#sec-ses).
- Équipe forecast, documentation de [`ses()` et `holt()`](https://pkg.robjhyndman.com/forecast/reference/ses.html), consultée le 27 octobre 2026. Les versions réellement exécutées sont dans le bilan interne; la documentation en ligne peut être plus récente.
- Les données sont simulées pour le cours à partir de `scripts/10_create_second_block_data.R`, graine 210110. Le [dictionnaire](data/dictionnaires.md) précise variables, unités et reproduction.

Les [consignes du mini-rapport 2](../../evaluations/mini-rapport-2.llms.md) définissent l’évaluation et les deux voies. Le laboratoire est une pratique distincte et son exemple ne remplace pas l’analyse autonome demandée.
