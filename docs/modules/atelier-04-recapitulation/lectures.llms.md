# Lectures et repères - Laboratoire 04

## Relier cible et décision

Une question sur les ventes porte sur un montant en dollars; une question sur un service insuffisant porte sur une étiquette 0 ou 1. Le modèle ne détermine pas la question. Pour une prévision, l’origine et les variables disponibles précèdent le choix de la méthode.

## Reprendre la preuve temporelle

La référence saisonnière compare chaque mois de 2025 à son correspondant de 2024. ME garde le signe observé moins prévu; MAE et RMSE résument des écarts en dollars. Les observations du même lieu au fil des mois sont dépendantes. Le bloc utilisé plusieurs fois pour comparer ou ajuster des choix ne devient pas un nouveau test indépendant.

## Reprendre la classification

La classe positive est l’étiquette simulée de service insuffisant le mois suivant. Sensibilité = VP/(VP+FN), spécificité = VN/(VN+FP), précision = VP/(VP+FP). Les mesures à dénominateur nul sont indéfinies. Un seuil évalué avant la période cible peut conduire à une proportion différente de 20 %; une capacité stricte nécessite une règle opérationnelle appropriée.

## Interpréter et communiquer

Une moyenne globale peut masquer des écarts par succursale. Des différences de ciblage demandent une analyse de contexte et de dénominateurs; elles ne suffisent pas à conclure à l’iniquité. Une association n’est pas une preuve causale et un score de risque ne mesure pas l’effet d’une intervention. La recommandation énonce une limite et un suivi.

## Pour approfondir

Les [compléments du module 07](../../modules/semaine-07-lissage/complements.llms.md) conservent les familles de lissage et les modèles plus avancés; ceux du [module 08](../../modules/semaine-08-tendance-saisonnalite/complements.llms.md) traitent de décomposition, tendances et différenciation. Le [module 10](../../modules/semaine-10-classification-modeles-avances/complements.llms.md) approfondit cotes, calibration, réseaux et retards. Ces compléments ne s’ajoutent pas à la synthèse obligatoire du laboratoire.

Hyndman et Athanasopoulos (2021), *Forecasting: Principles and Practice*, [boîte à outils, section 5.8](https://otexts.com/fpp3/toolbox.html) et [régression temporelle](https://otexts.com/fpp3/regression.html). James, Witten, Hastie et Tibshirani (2021), [*An Introduction to Statistical Learning*](https://www.statlearning.com/), chapitre 4; [sensibilité dans yardstick](https://yardstick.tidymodels.org/reference/sens.html).
