# Repères - Laboratoire 02

## Des repères à consulter au besoin

La [mission](../../modules/atelier-02-regression/guide-atelier.llms.md) mobilise les modules 3 et 4. Ces repères aident à vérifier une décision pendant l’analyse; ils ne constituent pas un travail supplémentaire.

## Question et unités

Les ventes mensuelles sont la réponse. Choisissez une explicative qui permet de poser une question précise et donnez son unité. Distinguez les différences observées entre mois et succursales de l’effet qu’aurait une intervention de la direction.

À vérifier : que représente une ligne, et quelle augmentation concrète de l’explicative allez-vous commenter?

## Droite et coefficients

La pente d’une droite correspond à une variation constante de la moyenne estimée de la réponse par unité de l’explicative. L’intercept correspond à une explicative égale à zéro; vérifiez si ce point a un sens dans le contexte et la plage observée.

À vérifier : votre phrase contient-elle les dollars de ventes, l’augmentation choisie et une formulation d’association?

## Courbe et interprétation

Une quadratique conserve le terme simple avec son carré. Un logarithme de l’explicative exige des valeurs strictement positives. Dans les deux cas, les ventes restent en dollars et `lm()` estime les coefficients. Une courbe peut décrire une relation sans qu’un modèle non linéaire dans ses paramètres soit nécessaire.

Pour interpréter la variante, comparez ses prédictions en deux points précis. La variation n’est pas constante sur toute la plage. Un logarithme ne représente pas un plafond de ventes et une quadratique peut finir par redescendre hors de la plage utile.

## Comparaison et diagnostic

| Repère | Ce qu’il apporte | Limite |
|----|----|----|
| R² | Part de la variation de la réponse résumée par l’ajustement avec intercept | Peut augmenter avec la complexité sans gain utile |
| R² ajusté | Ajustement avec une pénalisation liée au nombre de paramètres | Reste une mesure sur les données d’ajustement |
| RMSE d’ajustement | Taille des erreurs, en dollars, avec davantage de poids aux grandes erreurs | Ne mesure pas l’erreur sur de nouvelles données |
| Graphique des résidus | Recherche de courbure, dispersion variable ou points à vérifier | Ne suffit pas à confirmer toutes les hypothèses |

À vérifier : les modèles utilisent-ils les mêmes lignes et la même réponse? Les résidus changent-ils votre jugement? Les mois d’une même succursale peuvent être liés, même si le nuage paraît régulier.

## Prédiction et décision

Vérifiez la plage de l’explicative et la comparabilité du contexte. Une valeur dans la plage n’efface pas les différences entre succursales. Au-delà de cette plage, il s’agit d’une extrapolation.

Une recommandation indique le modèle retenu, les résultats qui motivent le choix, une limite précise et la prochaine vérification utile.

## Retrouver une explication

- [Module 3 : interpréter une droite et ses résidus](../../modules/semaine-03-regression-lineaire/demonstrations.llms.md).
- [Module 4 : comparer les formes et distinguer ajustement et validation](../../modules/semaine-04-regression-nonlineaire/demonstrations.llms.md).
- [Documentation R et lectures utiles](../../modules/atelier-02-regression/lectures.llms.md).
