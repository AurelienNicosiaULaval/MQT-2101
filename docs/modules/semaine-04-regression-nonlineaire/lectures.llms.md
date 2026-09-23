# Lectures - Module 04

## Comment utiliser ces lectures

Les lectures du cours en français ci-dessous font partie du parcours. Les références externes, en anglais, sont des compléments ciblés : choisissez le passage qui répond à une difficulté, sans lire les ouvrages en entier. Aucune ressource payante n’est nécessaire pour réaliser le module.

Avant de commencer, vous devez savoir interpréter une pente, calculer un résidu et distinguer moyenne et nouvelle observation. Si nécessaire, reprenez les [démonstrations du module 3](../../modules/semaine-03-regression-lineaire/demonstrations.llms.md).

## Lectures intégrées au parcours

| Moment | Statut et passage à lire | Ce qu’il faut en retenir | Vérification personnelle |
|----|----|----|----|
| Avant la capsule 1 | Obligatoire : [préparation et données](../../modules/semaine-04-regression-nonlineaire/demonstrations.llms.md#préparation) et [dictionnaires](data/dictionnaires.md) | Une ligne est un mois dans une succursale; les périodes d’apprentissage et de validation ont des rôles distincts | Donner les effectifs, les périodes et les unités sans regarder la correction |
| Après la capsule 2 | Obligatoire : [relier la forme au contexte](../../modules/semaine-04-regression-nonlineaire/demonstrations.llms.md#relier-la-forme-au-contexte) | Un taux d’occupation peut dépasser 100 %; un ralentissement n’est pas la preuve d’un plafond ni d’une cause | Formuler une explication concurrente à un manque de capacité |
| Après la capsule 3 | Obligatoire : [ajuster trois modèles et interpréter une variation](../../modules/semaine-04-regression-nonlineaire/demonstrations.llms.md#ajuster-trois-modèles) | x et x² changent ensemble; log(x) transforme l’explicative, pas les ventes | Expliquer pourquoi deux hausses de 100 visites peuvent donner des différences prédites différentes |
| Après la capsule 4 | Obligatoire : [comparer l’ajustement](../../modules/semaine-04-regression-nonlineaire/demonstrations.llms.md#comparer-lajustement) et [diagnostiquer les résidus](../../modules/semaine-04-regression-nonlineaire/demonstrations.llms.md#diagnostiquer-les-résidus) | R² décrit l’apprentissage; la RMSE de validation compare sur les mêmes mois; des biais par succursale peuvent rester | Dire pourquoi une RMSE plus faible n’est pas un gain de ventes |
| Après la capsule 5 | Obligatoire : [prédire et vérifier la plage](../../modules/semaine-04-regression-nonlineaire/demonstrations.llms.md#prédire-et-vérifier-la-plage) | L’intervalle vise une nouvelle observation sous des hypothèses; il ne protège pas contre une mauvaise forme hors de la plage connue | Distinguer les scénarios de 2 500 et 6 000 visites |
| Après la capsule 6 | Obligatoire : [conclusion prudente](../../modules/semaine-04-regression-nonlineaire/demonstrations.llms.md#conclusion-prudente), puis [synthèse](../../modules/semaine-04-regression-nonlineaire/notes-cours.llms.md) | Choix provisoire, chiffres, unités, domaine d’utilisation et prochaine vérification | Réécrire votre conclusion après avoir identifié une limite précise |

Ces lectures accompagnent les activités 4.1 à 4.6. Elles ne créent pas une deuxième production à remettre. Dans votre rapport, améliorez la réponse déjà commencée à la fin de la capsule.

## Approfondir un point précis

Les liens ci-dessous ont été vérifiés le 23 septembre 2026. Les pages HTML sont en accès libre sans compte. Le site officiel d’ISLR fournit gratuitement le PDF de l’édition R; son téléchargement passe par un hébergement externe. En cas de blocage de ce téléchargement, les explications du cours suffisent au parcours obligatoire.

| Après | Référence et passage vérifié | Statut et utilité |
|----|----|----|
| Capsule 3 | James, Witten, Hastie et Tibshirani (2021), [An Introduction to Statistical Learning, édition R, 2e édition](https://www.statlearning.com/), section 7.1 « Polynomial Regression », page imprimée 290 : début de la section et équation (7.1) | Complémentaire : comprendre pourquoi des puissances de x restent linéaires en coefficients. Se limiter au cas quadratique; les splines et les GAM ne sont pas requis |
| Capsule 3 | R Core Team, [log()](https://stat.ethz.ch/R-manual/R-patched/library/base/html/Log.html), rubriques « Description » et « Value » | Complémentaire : `log()` utilise le logarithme naturel; zéro et les valeurs négatives ne conviennent pas à ce modèle. Réinvestir dans les [exercices 8 et 9](../../modules/semaine-04-regression-nonlineaire/exercices.llms.md#exercice-08) |
| Capsule 4 | James et coll. (2021), même ouvrage, section 5.1.1 « The Validation Set Approach », pages imprimées 198 à 200 : principe de la séparation et limites d’un découpage unique | Complémentaire : distinguer erreur d’ajustement et erreur sur données réservées. Le découpage chronologique du cours conserve l’ordre des mois; on ne copie pas un tirage aléatoire de lignes répétées |
| Capsule 4 | Hyndman et Athanasopoulos (2021), [Forecasting: Principles and Practice, 3e édition, section 5.8](https://otexts.com/fpp3/accuracy.html), sous-sections « Training and test sets », « Forecast errors » et « Scale-dependent errors » | Complémentaire : distinguer résidu et erreur hors apprentissage, puis comparer MAE et RMSE. Arrêtez avant « Percentage errors »; les erreurs en pourcentage et le code `fable` ne sont pas requis ici |
| Capsule 5 | R Core Team, [predict.lm()](https://stat.ethz.ch/R-manual/R-patched/library/stats/html/predict.lm.html), arguments `newdata`, `interval`, `level`, puis « Value » | Complémentaire : comprendre `fit`, `lwr` et `upr`, et choisir entre `confidence` et `prediction`. Réinvestir dans l’[exercice 13](../../modules/semaine-04-regression-nonlineaire/exercices.llms.md#exercice-13) |

Dans l’ouvrage de prévision, les données réservées sont appelées « test ». Dans notre module, elles servent au choix entre trois formes : nous les appelons validation. Il faudra de nouvelles données pour évaluer le choix final sans réutiliser celles qui ont servi à le sélectionner.

## Lire activement, puis pratiquer

Après chaque passage choisi, écrivez une réponse courte à la question correspondante, puis fermez la lecture et refaites le calcul ou l’interprétation. Choisissez les [exercices supplémentaires](../../modules/semaine-04-regression-nonlineaire/exercices.llms.md#pratique-supplementaire) selon votre besoin :

- formes et transformations : exercices 7 à 9, après la capsule 3;
- erreurs, comparaison et séparation des données : exercices 10 à 12, après la capsule 4;
- intervalles et portée d’une conclusion : exercices 13 et 14, après les capsules 5 et 6.

Les corrigés expliquent la démarche, les résultats et les erreurs fréquentes. Une correction comprise doit ensuite pouvoir être reconstruite sans regarder la réponse.

## Limites de la matière

Ce module traite une réponse quantitative et transforme seulement l’explicative. La transformation de la réponse, les modèles à plateau imposé, les splines, les GAM, le probit et le Tobit ne sont pas développés. Mentionner ces méthodes ne signifie pas savoir les ajuster.

La [régression logistique du module 10](../../modules/semaine-10-classification-modeles-avances/index.llms.md) concerne une réponse binaire. Les anciennes lectures sur les rapports de cotes et les anciens exercices médicaux de logistique ne sont donc pas des préalables du module 4 A26.
