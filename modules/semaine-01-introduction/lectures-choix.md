# Choix de lectures et exercices - Module 1

Document interne pour garder la trace des lectures et exercices associés au
module 1. Mise à jour : 2026-05-13.

## Objectif pédagogique

Le module 1 installe les bases nécessaires avant les modèles : unité
d'observation, variable, type de variable, préparation minimale d'une base,
résumé descriptif, histogramme, boxplot, comparaison prudente et limite
d'interprétation.

Les lectures de consolidation ne doivent donc pas ajouter une nouvelle matière
lourde. Elles servent à revenir rapidement aux définitions et aux gestes qui
soutiennent la trace de portfolio.

## Sources consultées

- Çetinkaya-Rundel, M., et Hardin, J. (2024). Introduction to Modern Statistics,
  2e édition. OpenIntro. https://openintro-ims.netlify.app/
- Wickham, H., Çetinkaya-Rundel, M., et Grolemund, G. (2023). R for Data
  Science, 2e édition. O'Reilly. https://r4ds.hadley.nz/
- Diez, D. M., Çetinkaya-Rundel, M., et Barr, C. D. (2019). OpenIntro
  Statistics, 4e édition. OpenIntro. https://www.openintro.org/book/os/
- Hyndman, R. J., et Athanasopoulos, G. (2021). Forecasting: Principles and
  Practice, 3e édition. OTexts. https://otexts.com/fpp3/
- James, G., Witten, D., Hastie, T., et Tibshirani, R. (2021). An Introduction
  to Statistical Learning with Applications in R, 2e édition. Springer.
  https://www.statlearning.com/

## Lectures retenues pour les étudiants

| Besoin du module 1 | Lecture retenue | Raison |
|---|---|---|
| Observation, unité d'observation, variable, type de variable, relation entre variables | Introduction to Modern Statistics, chapitre 1, sections 1.2 et 1.3 | Sections courtes, vocabulaire très proche de ce qui est demandé dans les exercices 1 et 4 |
| Moyenne, médiane, histogramme, boxplot, valeurs inhabituelles | Introduction to Modern Statistics, chapitre 5, sections 5.2, 5.3, 5.5, 5.6 et 5.9.1 | Correspond directement à l'étape 5 et au besoin de formuler un constat descriptif prudent |
| Comparaison d'une variable numérique selon un groupe | Introduction to Modern Statistics, chapitre 4, section 4.6; R for Data Science, chapitre 1, section 1.5.1 | Appuie l'étape 6 : comparaison par groupes et lecture prudente d'un boxplot |
| Graphiques avec `ggplot2` | R for Data Science, chapitre 1, sections 1.4 et 1.5.1 | Référence claire pour les histogrammes, boxplots et premiers choix de variables dans `ggplot2` |
| R de base et importation CSV | R for Data Science, chapitre 2, sections 2.1 à 2.4; chapitre 7, sections 7.1 à 7.3 | Facultatif, utile pour les étudiantes et étudiants qui ont besoin de revoir les gestes techniques avant la semaine 02 |

## Exercices proposés

Ces exercices sont facultatifs. Ils servent à approfondir la consolidation, pas
à ajouter un livrable supplémentaire.

| Difficulté | Exercices | Intérêt pédagogique |
|---|---|---|
| Facile | Introduction to Modern Statistics, chapitre 1, exercices 1, 3, 11 et 12; R for Data Science, chapitre 1, section 1.2.5, exercice 1 | Identifier les lignes, les colonnes, les variables, les types de variables et l'unité d'observation |
| Intermédiaire | Introduction to Modern Statistics, chapitre 5, exercices 6, 8, 10, 11 et 12; R for Data Science, chapitre 1, section 1.4.3, exercices 3 et 4 | Interpréter histogrammes et boxplots, comparer moyenne et médiane, repérer valeurs inhabituelles et réfléchir aux classes d'un histogramme |
| Plus difficile | Introduction to Modern Statistics, chapitre 4, exercices 7 et 9; R for Data Science, chapitre 1, section 1.5.5, exercice 7 | Travailler la comparaison, les proportions, la confusion possible entre association et explication, et l'effet de l'échelle de comparaison |

## Choix non retenus pour le module 1

OpenIntro Statistics n'a pas été retenu pour les lectures étudiantes de cette
semaine parce que Introduction to Modern Statistics est plus récent et plus
aligné avec le vocabulaire actuel du module.

Forecasting: Principles and Practice n'est pas requis ici. Il deviendra central
quand le cours abordera les séries chronologiques.

An Introduction to Statistical Learning n'est pas requis ici. Le niveau et les
objectifs sont plus adaptés aux modules de régression, validation et modèles
statistiques.

## Note pour les prochains modules

Pour chaque module, conserver le même format :

1. lectures ciblées dans la page `lectures.qmd`;
2. exercices facultatifs classés par difficulté;
3. justification interne dans un fichier `lectures-choix.md` ou équivalent.
