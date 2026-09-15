# Lectures - Module 03

## Pour suivre le module

- Le [parcours](../../modules/semaine-03-regression-lineaire/index.llms.md) précise l’ordre des six activités et le contenu de la trace finale.
- Les [capsules et leurs supports](../../modules/semaine-03-regression-lineaire/capsules.llms.md) expliquent les notions et les exemples.
- Les [démonstrations R](../../modules/semaine-03-regression-lineaire/demonstrations.llms.md) donnent le code complet du cas guidé.
- Les [exercices](../../modules/semaine-03-regression-lineaire/exercices.llms.md) proposent un autre cas et des corrigés à ouvrir après une tentative.
- Les [notes de cours](../../modules/semaine-03-regression-lineaire/notes-cours.llms.md), aussi disponibles en [PDF](media/pdf/notes-cours.pdf), servent de synthèse.

## Références pour approfondir

Les références suivantes sont des compléments en anglais. Consultez la partie correspondant à votre question; leur lecture intégrale n’est pas nécessaire pour réaliser les activités.

| Question | Référence | Passage utile |
|----|----|----|
| Comment R ajuste-t-il la droite? | R Core Team, documentation de [lm()](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/lm.html), consultée le 15 septembre 2026 | Formule, coefficients et résidus |
| Comment lire le test de la pente et le R²? | R Core Team, documentation de [summary.lm()](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/summary.lm.html), consultée le 15 septembre 2026 | Tableau `coefficients` : estimation, erreur-type, t, valeur p; définition de `r.squared` |
| Comment calculer un intervalle sur la pente? | R Core Team, documentation de [confint()](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/confint.html), consultée le 15 septembre 2026 | Méthode pour les modèles `lm` |
| Moyenne ou nouvelle observation? | R Core Team, documentation de [predict.lm()](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/predict.lm.html), consultée le 15 septembre 2026 | Options `confidence` et `prediction` |
| Que rechercher dans les résidus? | NIST/SEMATECH, [e-Handbook of Statistical Methods : Model Validation](https://www.itl.nist.gov/div898/handbook/pmd/section4/pmd44.htm), consulté le 15 septembre 2026 | Motifs des résidus et limites des indicateurs numériques |
| Comment ajouter une droite au graphique? | Équipe ggplot2, documentation de [geom_smooth()](https://ggplot2.tidyverse.org/reference/geom_smooth.html), consultée le 15 septembre 2026 | `method = "lm"`, groupes et bande d’incertitude |

## Repères de lecture

La pente se lit avec ses variables et ses unités. Le R² décrit l’ajustement sur les données utilisées. Les résidus aident à repérer des limites, mais un seul graphique ne vérifie pas toutes les hypothèses.

Les intervalles classiques reposent sur le modèle choisi et ses hypothèses. Les observations mensuelles répétées par région ou par succursale demandent notamment un examen de l’indépendance. Une association observée ne suffit pas à attribuer un effet causal à une intervention.
