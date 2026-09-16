# Lectures - Module 04

## Pour ce module

Reprenez les repères de [régression linéaire](../../modules/semaine-03-regression-lineaire/index.llms.md) : moyenne prédite, résidu, R², hypothèses et intervalle de prédiction. Consultez les [capsules](../../modules/semaine-04-regression-nonlineaire/capsules.llms.md), reproduisez les [démonstrations](../../modules/semaine-04-regression-nonlineaire/demonstrations.llms.md) et tentez les [exercices](../../modules/semaine-04-regression-nonlineaire/exercices.llms.md) avant leurs corrigés.

## Références complémentaires

- James, G., Witten, D., Hastie, T. et Tibshirani, R. (2021). [An Introduction to Statistical Learning with Applications in R, 2e édition](https://www.statlearning.com/). Chapitre 5 pour la validation; chapitre 7, section sur la régression polynomiale. L’édition R est de 2021; l’édition Python est de 2023.
- Hyndman, R. J. et Athanasopoulos, G. (2021). [Forecasting: Principles and Practice, 3e édition, section 5.8](https://otexts.com/fpp3/accuracy.html). Résidus, erreurs sur des observations mises de côté et RMSE.
- R Core Team, documentation officielle de [lm()](https://stat.ethz.ch/R-manual/R-patched/library/stats/html/lm.html) et [predict.lm()](https://stat.ethz.ch/R-manual/R-patched/library/stats/html/predict.lm.html), consultée le 15 septembre 2026.
- R Core Team, documentation de [log()](https://stat.ethz.ch/R-manual/R-patched/library/base/html/Log.html) : logarithme naturel par défaut.

## Repères de lecture

Le modèle quadratique et le modèle avec log(x) restent linéaires en leurs paramètres. Ils permettent une relation courbée tout en conservant une réponse quantitative. La validation sert ici à comparer des candidats; une nouvelle évaluation serait nécessaire pour confirmer la performance du choix final.

La régression logistique est traitée au [module 10](../../modules/semaine-10-classification-modeles-avances/index.llms.md). Les modèles à plateau imposé, les splines, les GAM, le probit et le Tobit ne sont pas développés dans ce module.
