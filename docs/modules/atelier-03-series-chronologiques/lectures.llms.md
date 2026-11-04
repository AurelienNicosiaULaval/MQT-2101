# Lectures - Laboratoire 03

## Préparer la séance

Reprenez l’origine et l’horizon au module 06, les résultats de lissage du module 07 et la [tendance avec mois du module 08](../../modules/semaine-08-tendance-saisonnalite/lectures.llms.md#lecture-2). Le [guide](../../modules/atelier-03-series-chronologiques/guide-atelier.llms.md) et la [démonstration](../../modules/atelier-03-series-chronologiques/demonstrations.llms.md) accompagnent la mission.

## Comparer à une origine commune

Les 60 mois d’apprentissage sont connus à la fin de décembre 2024. Les douze observations suivantes servent à comparer les méthodes et à choisir; elles ne constituent pas un test final indépendant. Le naïf saisonnier reprend 2024 et le modèle de régression utilise un indice continu et le mois connu d’avance. Des retards fondés sur les observations de 2025 répondraient à un autre protocole.

## Lire une prévision, son intervalle et le coût

Une ME positive, avec observé moins prévu, indique une sous-prévision moyenne. La MAE et la RMSE expriment l’amplitude des erreurs en livraisons. Les intervalles du modèle combiné sont marginaux et dépendent de ses hypothèses. Le scénario de 2 \$ et 1 \$ par livraison d’écart est fictif : il invite à discuter de la décision sans constituer un tarif mesuré.

Les anciens exemples de température et de taux de change rappellent que fréquence, dates manquantes et calendrier doivent être vérifiés avant la modélisation. La [comparaison hebdomadaire antérieure](../../modules/atelier-03-series-chronologiques/demonstration-hebdomadaire.llms.md) demeure disponible. Les [exercices mensuels](../../modules/atelier-03-series-chronologiques/exercices.llms.md) reprennent une validation déjà examinée au module 08 et sont facultatifs.

## Sources ciblées

Hyndman et Athanasopoulos (2021), *Forecasting: Principles and Practice*, 3e éd. : [exactitude des prévisions](https://otexts.com/fpp3/toolbox.html#sec-accuracy) et [prédicteurs temporels](https://otexts.com/fpp3/regression.html#sec-useful-predictors). Le [dictionnaire](data/dictionnaires.md) présente les données simulées et leur reproduction.
