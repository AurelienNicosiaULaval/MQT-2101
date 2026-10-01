# Laboratoire 02

Auditer une prévision de livraison

Deuxième laboratoire en classe

## Le meilleur ajustement suffit-il pour prévoir?

Un service fictif de livraison régionale veut utiliser un modèle de durée selon la distance. Vous auditez deux modèles sur de nouvelles données simulées, puis vous jugez trois affirmations de la direction.

Vous reprenez le projet R, Quarto et la relecture du laboratoire 01. Le contexte, les unités et le problème de décision changent : une livraison est une observation, la réponse est en minutes, un incident est documenté et les dernières observations servent à la validation.

## Avant l’atelier

- Reprenez un point de rétroaction du laboratoire 01.
- Revoyez les [modules 03](../../modules/semaine-03-regression-lineaire/index.llms.md) et [04](../../modules/semaine-04-regression-nonlineaire/index.llms.md), notamment les périodes d’apprentissage et de validation.
- Téléchargez et décompressez le [dossier étudiant](../../assets/exemples/laboratoire-02.zip). Ouvrez le projet et faites Render du gabarit.
- Apportez votre mini-rapport 1 en cours et une question ciblée.

## Pendant l’atelier

Le [guide](../../modules/atelier-02-regression/guide-atelier.llms.md) est le fil principal. Travaillez en binômes; chaque personne doit expliquer les unités, les deux modèles et la validation. Changez de personne au clavier après le premier contrôle.

| Étape | Production |
|----|----|
| Comprendre et séparer | Données contrôlées, apprentissage et validation fixés |
| Ajuster et prendre position | Droite, quadratique et position avant validation |
| Pause | Reprendre avec les modèles déjà fixés |
| Valider et diagnostiquer | Deux RMSE par modèle, résidus et incident |
| Auditer et relire | Trois affirmations jugées et recommandation |
| Recalculer | Rapport corrigé et HTML vérifié |
| Consolider | [Fiche individuelle pour l’intra](../../modules/atelier-02-regression/consolidation.llms.md) |
| Vérifier le mini-rapport | [Vérification finale du dossier évalué](../../modules/atelier-02-regression/guide-atelier.llms.md#vérifier-le-mini-rapport-1) |

La validation est essentielle ici. Le logarithme, la sensibilité à l’incident et les erreurs par centre sont des [prolongements facultatifs](../../modules/atelier-02-regression/exercices.llms.md).

## Supports

- [Guide étudiant et résultats attendus](../../modules/atelier-02-regression/guide-atelier.llms.md).
- [Présentation de lancement](../../modules/atelier-02-regression/presentation.llms.md).
- [Données de livraison](data/livraisons_regionales_quebec.csv) et [dictionnaire](data/dictionnaire-livraisons.md).
- [Repères](../../modules/atelier-02-regression/capsules.llms.md), [aide R à la demande](../../modules/atelier-02-regression/demonstrations.llms.md) et [lectures](../../modules/atelier-02-regression/lectures.llms.md).

Le laboratoire est formatif. Le mini-rapport 1 garde ses consignes et exige un jeu extérieur approuvé. Les données du laboratoire sont inadmissibles pour ce travail évalué.
