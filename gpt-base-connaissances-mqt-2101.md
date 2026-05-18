# Base de connaissances pour l'assistant du cours

Ce document sert de matériel de référence pour un assistant pédagogique utilisé dans un cours universitaire d'analyse et de modélisation des données.

Il ne remplace pas les consignes de l'enseignant, les consignes d'évaluation ni le plan de cours institutionnel. Si une information n'est pas présente dans ce document, dans le site du cours ou dans une consigne fournie par l'étudiante ou l'étudiant, l'assistant doit dire qu'il ne sait pas.

## Site du cours

Source principale :

https://aureliennicosiaulaval.github.io/MQT-2101/

Pages utiles :

- Accueil : https://aureliennicosiaulaval.github.io/MQT-2101/
- Plan de cours : https://aureliennicosiaulaval.github.io/MQT-2101/plan-de-cours.html
- Calendrier : https://aureliennicosiaulaval.github.io/MQT-2101/calendrier.html
- Évaluations : https://aureliennicosiaulaval.github.io/MQT-2101/evaluations/
- Données : https://aureliennicosiaulaval.github.io/MQT-2101/donnees/
- Lectures et ressources : https://aureliennicosiaulaval.github.io/MQT-2101/ressources/lectures.html
- IA et apprentissage : https://aureliennicosiaulaval.github.io/MQT-2101/ressources/ia.html
- Déclaration d'usage de l'IA : https://aureliennicosiaulaval.github.io/MQT-2101/ressources/declaration-ia.html

Notes de cours disponibles :

- Semaine 01, notes HTML : https://aureliennicosiaulaval.github.io/MQT-2101/modules/semaine-01-introduction/notes-cours.html
- Semaine 01, notes PDF : https://aureliennicosiaulaval.github.io/MQT-2101/modules/semaine-01-introduction/media/pdf/notes-cours.pdf
- Semaine 02, notes HTML : https://aureliennicosiaulaval.github.io/MQT-2101/modules/semaine-02-r-quarto/notes-cours.html
- Semaine 02, notes PDF : https://aureliennicosiaulaval.github.io/MQT-2101/modules/semaine-02-r-quarto/media/pdf/notes-cours.pdf

## Sujet et orientation du cours

Le cours porte sur l'analyse appliquée des données, la modélisation, la prévision et l'utilisation de R pour soutenir la prise de décision d'affaires.

Les thèmes principaux sont :

- exploration de données;
- régression;
- prévision;
- séries chronologiques;
- modèles pour résultats binaires;
- communication de résultats utiles pour la décision.

Le cours s'adresse principalement à des étudiantes et étudiants en génie et en administration.

Les exemples et mini-cas peuvent porter sur :

- performance opérationnelle;
- systèmes;
- production;
- ventes;
- achalandage;
- campagnes marketing;
- satisfaction client;
- demande;
- inventaire;
- finance;
- ressources humaines;
- performance organisationnelle.

## Objectif général

Développer la capacité d'analyser des données d'affaires avec R, de construire des modèles appropriés et de communiquer les résultats dans un langage utile pour la décision.

## Objectifs spécifiques

- Préparer et décrire un tableau de données d'affaires.
- Interpréter des relations entre variables.
- Ajuster et évaluer des modèles de régression.
- Produire des prévisions à court ou moyen terme.
- Comparer des modèles selon leur utilité décisionnelle.
- Présenter une recommandation claire à un public de gestion.

## Progression du cours

Le calendrier est préparé pour la session d'automne 2026. Les dates précises et les échéances doivent être vérifiées dans le plan de cours institutionnel et dans les consignes diffusées aux étudiantes et étudiants.

| Semaine | Type | Contenu principal | Évaluation ou trace |
|---|---|---|---|
| 1 | Module | Introduction au cours, objectifs, quiz diagnostique et compétences statistiques | Trace finale de départ |
| 2 | Module | Introduction à l'analyse et au traitement des données avec R, RStudio et Quarto | Mini-rapport formatif |
| 3 | Atelier | Explorer un tableau de données et produire de premières synthèses | Trace finale d'atelier |
| 4 | Module | Régression linéaire pour expliquer une variable d'intérêt | Questionnaire formatif sur la régression |
| 5 | Module | Régression non linéaire, transformations et interprétation | Préparation du mini-rapport 1 |
| 6 | Atelier | Étude de cas appliquée en régression | Mini-rapport 1 en préparation |
| 7 | Préparation | Consolidation des notions de régression | Examen intra individuel en personne |
| 8 | Module | Introduction à la prévision et aux séries chronologiques | Démarrage du bloc prévision |
| 9 | Pause pédagogique | Consolidation et finalisation du mini-rapport 1 | Remise du mini-rapport 1 après la relâche |
| 10 | Module | Méthodes de lissage pour la prévision à court terme | Questionnaire formatif sur les séries chronologiques |
| 11 | Module | Modèles avec tendance et saisonnalité | Préparation du mini-rapport 2 |
| 12 | Atelier | Prévision des ventes, de la demande ou d'une mesure opérationnelle | Mini-rapport 2 en préparation |
| 13 | Module | Prévision avec variables externes, autocorrélation et interprétation | Validation des choix de prévision |
| 14 | Module | Résultats binaires, classification et modèles avancés | Ouverture classification pour le mini-rapport 2 |
| 15 | Atelier | Atelier intégrateur, récapitulation et préparation finale | Préparation finale |
| 16 | Évaluation | Examen final individuel en personne | Remise du mini-rapport 2 après l'examen final, selon le calendrier de référence |

## Évaluations prévues

| Évaluation | Type | Pondération | Modalité | IA |
|---|---|---:|---|---|
| Mini-rapport 1 | Équipe de 2 à 3 | 15 % | Analyse de données, exploration et régression | Permise, déclarée |
| Examen intra | Individuel | 30 % | En personne | Non permise |
| Mini-rapport 2 | Équipe de 2 à 3 | 15 % | Prévision, séries chronologiques et ouverture classification | Permise, déclarée |
| Examen final | Individuel | 40 % | En personne | Non permise |

Les questionnaires sur la régression et les séries chronologiques sont des exercices formatifs non évalués.

## Mini-rapports

Les mini-rapports sont remis en équipe de 2 à 3 personnes.

Chaque équipe choisit son jeu de données, mais ce choix doit être validé par l'enseignant avant l'analyse. La procédure de validation sera précisée plus tard.

Chaque mini-rapport doit être remis avec :

- le fichier source `.qmd`;
- le rendu final, idéalement en HTML;
- les fichiers de données nécessaires si le jeu de données n'est pas accessible publiquement;
- une déclaration d'usage de l'IA lorsque l'IA a influencé le code, l'analyse, l'interprétation ou le texte.

## Politique d'utilisation de l'IA

Principe général :

L'IA générative est un outil de soutien à l'apprentissage. Elle peut expliquer, proposer, relire et aider à déboguer. Elle ne remplace pas la compréhension, la vérification et la responsabilité intellectuelle.

Règle simple :

Une étudiante ou un étudiant peut utiliser l'IA si elle ou il peut ensuite expliquer, vérifier, modifier et défendre ce que l'IA a aidé à produire. Si le résultat n'est pas compris, il n'est pas prêt à être remis.

Statuts d'IA :

| Activité | Statut IA |
|---|---|
| Examen intra individuel en personne | Non permise |
| Examen final individuel en personne | Non permise |
| Mini-rapport 1 en équipe | Permise, déclarée |
| Mini-rapport 2 en équipe | Permise, déclarée |
| Questionnaires formatifs | Permise |
| Exercices, ateliers formatifs et travail personnel | Permise |

Usages permis :

- Comprendre une erreur R.
- Demander une explication d'un concept statistique.
- Obtenir une première piste de code à tester.
- Comparer deux stratégies d'analyse.
- Relire une interprétation.
- Repérer des limites dans une conclusion.
- Préparer une checklist de vérification.

Usages interdits :

- Remettre du code non compris.
- Masquer une contribution importante de l'IA.
- Inventer ou embellir des résultats.
- Déléguer la justification statistique ou méthodologique.
- Copier une réponse sans validation.
- Soumettre des données confidentielles, nominatives ou sensibles dans un outil externe non approuvé.
- Utiliser l'IA pour contourner une consigne individuelle.

## Déclaration d'usage de l'IA

Chaque mini-rapport qui utilise l'IA de façon significative doit contenir une déclaration d'usage de l'IA.

La déclaration doit indiquer :

- l'outil utilisé;
- la tâche demandée;
- le résumé de l'aide obtenue;
- les vérifications faites;
- les modifications intégrées au projet.

Gabarit :

https://aureliennicosiaulaval.github.io/MQT-2101/ressources/declaration-ia.html

## Rôle attendu de l'assistant pédagogique

L'assistant doit agir comme tuteur pédagogique.

Il peut :

- guider par questions et indices;
- aider à comprendre les notions;
- aider à lire ou déboguer du code R;
- proposer des vérifications;
- soutenir la réflexion statistique;
- aider à interpréter des résultats;
- aider à vérifier la cohérence d'une analyse.

Il ne doit pas :

- produire un mini-rapport complet à la place d'une équipe;
- contourner une consigne d'examen, de quiz ou d'évaluation individuelle;
- inventer une consigne, une date, une pondération, une source ou un résultat;
- remplacer le jugement statistique de l'étudiante ou de l'étudiant.

Si une demande ressemble à une tentative d'obtenir une solution complète à un travail noté, l'assistant doit proposer une démarche guidée, des indices progressifs ou une vérification de la tentative fournie.

Si la personne fournit sa propre tentative, l'assistant peut l'aider à l'améliorer.

## R et Quarto

Le langage de programmation principal est R.

Les outils privilégiés sont :

- tidyverse;
- ggplot2;
- dplyr;
- tidyr;
- purrr;
- readr;
- tidymodels;
- forecast;
- fable;
- tsibble;
- Quarto.

Les réponses avec du code doivent :

- charger explicitement les bibliothèques nécessaires;
- fournir du code complet, exécutable et reproductible;
- utiliser des noms de variables clairs;
- commenter seulement lorsque cela aide vraiment;
- expliquer les erreurs R en donnant la cause probable, la correction minimale et la raison de la correction.

Structure recommandée pour un exemple R :

```r
# Load libraries
library(tidyverse)

# Import data
data <- read_csv("data.csv")

# Clean data
data_clean <- data |>
  filter(!is.na(value))

# Analysis
model <- lm(y ~ x, data = data_clean)

summary(model)
```

Pour un exemple de document Quarto, fournir un fichier `.qmd` complet. Le YAML doit inclure :

```yaml
embed-resources: true
```

## Démarche statistique recommandée

Lorsque pertinent, structurer une analyse selon les étapes suivantes :

1. compréhension des données;
2. préparation des données;
3. exploration;
4. modélisation;
5. validation;
6. interprétation.

Toujours distinguer :

- description;
- association;
- prédiction;
- causalité.

Toujours signaler les limites des analyses et encourager les diagnostics, la validation, les graphiques et l'interprétation prudente.

## Jeux de données disponibles

| Jeu de données | Fichier | Module | Description |
|---|---|---|---|
| Naissances quotidiennes aux États-Unis | `birth_us.csv` | Semaine 01 | Observations quotidiennes de naissances aux États-Unis |
| Sécurité aérienne par compagnie | `safety_airlines.csv` | Semaine 01 | Données descriptives par compagnie aérienne |
| Ventes et opérations de succursales québécoises | `ventes_operations_quebec.csv` | Semaine 02 | Données simulées où chaque ligne représente une succursale pour un mois |
| Ventes mensuelles d'une PME québécoise fictive | `ventes_pme_quebec.csv` | Atelier 01 | Données simulées sur les ventes mensuelles d'une PME québécoise fictive dans cinq succursales |

Page des données :

https://aureliennicosiaulaval.github.io/MQT-2101/donnees/

## Lectures principales

- Hyndman, R. J., et Athanasopoulos, G. (2021). Forecasting: Principles and Practice, 3e édition. OTexts. https://otexts.com/fpp3/
- Wickham, H., Çetinkaya-Rundel, M., et Grolemund, G. (2023). R for Data Science, 2e édition. O'Reilly. https://r4ds.hadley.nz/
- James, G., Witten, D., Hastie, T., et Tibshirani, R. (2021). An Introduction to Statistical Learning with Applications in R, 2e édition. Springer. https://www.statlearning.com/

## Lectures complémentaires

- Diez, D. M., Çetinkaya-Rundel, M., et Barr, C. D. (2019). OpenIntro Statistics, 4e édition. OpenIntro. https://www.openintro.org/book/os/
- Çetinkaya-Rundel, M., et Hardin, J. (2024). Introduction to Modern Statistics, 2e édition. OpenIntro. https://openintro-ims.netlify.app/
- Rubenthaler, S., et Vasilieiadis, A. (2023-2024). Séries chronologiques avec R, cours et exercices, M1 IM. https://math.univ-cotedazur.fr/~rubentha/enseignement/poly-cours-series-temp-m1-im.pdf
- Lagnoux, A. (s. d.). Séries chronologiques. ISMAG, Master 1. https://www.math.univ-toulouse.fr/~lagnoux/Poly_SC.pdf

## Logiciels et environnement

- R : https://cran.r-project.org/
- RStudio Desktop : https://posit.co/download/rstudio-desktop/
- Positron : https://positron.posit.co/
- tidyverse : https://tidyverse.tidyverse.org/
- ggplot2 : https://ggplot2.tidyverse.org/
- dplyr : https://dplyr.tidyverse.org/
- forecast : https://pkg.robjhyndman.com/forecast/
- fable : https://fable.tidyverts.org/
- tsibble : https://tsibble.tidyverts.org/

## Règle de prudence

Pour le contenu du cours, utiliser d'abord le site du cours et ce document.

Pour R, Quarto et les packages, utiliser la documentation des projets concernés.

Pour les références méthodologiques, privilégier les lectures du cours et les sources reconnues.

Si une information est absente, incertaine ou dépend d'une consigne non fournie, répondre que l'information doit être vérifiée dans la consigne pertinente.
