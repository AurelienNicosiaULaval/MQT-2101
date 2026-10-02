# Repères - Laboratoire 02

## Transférer les acquis

La [mission](../../modules/atelier-02-regression/guide-atelier.llms.md) utilise les commandes des modules 03 et 04 dans un nouveau contexte de livraisons simulées. Ces repères vous aident à vérifier les unités et les interprétations de votre rapport.

| Repère | Application à la mission |
|----|----|
| Unité d’observation | Une livraison, avec un identifiant unique |
| Variables | Réponse : durée en minutes. Explicative : distance en kilomètres. |
| Droite | La pente est en minutes par kilomètre; multipliez par la hausse étudiée |
| Ordonnée à l’origine (intercept) | Durée moyenne estimée à zéro km; vérifiez si cette distance est dans la plage d’apprentissage |
| Quadratique | Conserver le terme simple et `I(distance_km^2)` |
| Variation d’une courbe | Comparer deux prédictions; le point de départ compte |
| R² ajusté | Mesure d’ajustement sur l’apprentissage, qui tient compte du nombre de paramètres |
| RMSE de validation | Taille des erreurs de prévision sur les livraisons qui n’ont pas servi à ajuster le modèle |
| Incident | Vérifier le contexte avant de considérer une observation comme une erreur |
| Extrapolation | Prévision pour une distance hors de la plage d’apprentissage |

## Ajustement, sélection et portée

Définissez les deux périodes avant l’analyse. Ajustez les deux modèles sur l’apprentissage, puis comparez leurs prévisions sur la validation. Puisque cette comparaison guide votre choix, la validation ne constitue pas un test final indépendant du modèle retenu. Les centres sont les mêmes dans les deux périodes.

Une distance dans la plage d’apprentissage ne suffit pas à garantir qu’une livraison est comparable : son contexte et les incidents éventuels comptent aussi. Le modèle décrit une association entre distance et durée. Il ne permet pas de garantir le temps gagné en modifiant un trajet. De même, réduire l’erreur de prévision ne raccourcit pas les livraisons.

## Retrouver une explication

- [Module 03 : droite et résidus](../../modules/semaine-03-regression-lineaire/demonstrations.llms.md).
- [Module 04 : formes et validation](../../modules/semaine-04-regression-nonlineaire/demonstrations.llms.md).
- [Aide R sur un autre exemple](../../modules/atelier-02-regression/demonstrations.llms.md).
- [Lectures et documentation](../../modules/atelier-02-regression/lectures.llms.md).
