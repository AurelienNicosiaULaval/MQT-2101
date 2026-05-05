# Correspondance entre ancien matériel et nouvelle structure

Ce fichier documente la phase 1 de migration. Les archives anciennes restent dans `anciens_documents/sources_privees/`, qui est ignoré par Git.

## Principe

L'ancien matériel sert de référence. Il ne doit pas être copié tel quel. Chaque contenu retenu doit être converti en Quarto, réécrit, modernisé, recontextualisé et rattaché à une décision d'affaires.

## Correspondance

| Ancienne source | Nouvelle destination | Réutilisation prévue |
|---|---|---|
| Plan de cours PDF | `plan-de-cours.qmd`, `calendrier.qmd` | Progression, évaluations, objectifs |
| Séance 01 Introduction au cours | `modules/semaine-01-introduction/` | Captures du portail, quiz diagnostique, préparation des données, exploration descriptive, fichiers BirthUS et SafetyAirlines |
| Séance 02 Introduction | `modules/semaine-02-r-quarto/` | Introduction à R et exploration de données |
| Atelier en classe 1 | `modules/atelier-01-r/` | Structure d'atelier d'importation et exploration |
| Séance 03 Régression | `modules/semaine-03-regression-lineaire/` | Corrélation, régression, exercices R |
| Séance 04 Régression non linéaire | `modules/semaine-04-regression-nonlineaire/` | Transformations, logistique, non-linéarité |
| Atelier en classe 2 | `modules/atelier-02-regression/` | Atelier appliqué de régression |
| Séance 05 Préparation intra | `modules/semaine-05-preparation-intra/` | Révision, canevas de réponse |
| Préparation à l'examen | `evaluations/` | Structure d'examen et critères |
| Séance 06 Prévision | `modules/semaine-06-series-chronologiques-intro/` | Introduction aux séries chronologiques |
| Séance 07 Lissage | `modules/semaine-07-lissage/` | Moyennes mobiles, lissage exponentiel, ETS |
| Séance 08 Modèles | `modules/semaine-08-tendance-saisonnalite/` | Tendance, saisonnalité, ventes |
| Atelier en classe 3 | `modules/atelier-03-series-chronologiques/` | Atelier de prévision |
| Séance 09 Modèles basés | `modules/semaine-09-variables-externes-autocorrelation/` | Variables externes et autocorrélation |
| Séance 10 Prévision des résultats binaires | `modules/semaine-10-classification-modeles-avances/` | Classification et résultats binaires |
| Séance 11 Récapitulation | `modules/atelier-04-recapitulation/` | Atelier intégrateur |
| Solutionnaires séances | `modules/*/solutions.qmd` | Solutions privées, hors rendu public |

## Données

Les données anciennes sont à classer en trois groupes :

- à réutiliser après vérification de l'origine et de la licence;
- à adapter ou simuler pour un contexte d'affaires québécois ou canadien;
- à remplacer parce qu'elles sont trop génériques, classiques ou peu alignées avec le cours.

Inventaire agrégé : `anciens_documents/inventaire_archives.csv`.
