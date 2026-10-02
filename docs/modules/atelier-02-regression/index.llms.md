# Laboratoire 02

Auditer une prévision de livraison

Deuxième laboratoire en classe

## Le meilleur ajustement suffit-il pour prévoir?

Un service fictif de livraison régionale veut prévoir la durée de ses livraisons à partir de leur distance. Vous comparez deux modèles sur des données simulées, vérifiez leurs prévisions sur les livraisons suivantes et examinez trois affirmations de la direction.

Vous reprenez la démarche du laboratoire 01 : comprendre les données, construire un rapport Quarto et le faire relire. Cette fois, chaque ligne représente une livraison. Vous étudiez une durée en minutes, tenez compte d’une panne documentée et utilisez les dernières livraisons pour vérifier les prévisions.

## Avant l’atelier

- Reprenez un point de rétroaction du laboratoire 01.
- Revoyez les [modules 03](../../modules/semaine-03-regression-lineaire/index.llms.md) et [04](../../modules/semaine-04-regression-nonlineaire/index.llms.md), notamment les périodes d’apprentissage et de validation.
- Téléchargez et décompressez le [dossier étudiant](../../assets/exemples/laboratoire-02.zip). Ouvrez `laboratoire-02.Rproj`, puis `rapport-labo-02.qmd` dans RStudio et cliquez sur Render.
- Apportez votre mini-rapport 1 en cours et une question ciblée.

## Pendant l’atelier

Suivez les étapes du [guide](../../modules/atelier-02-regression/guide-atelier.llms.md). Travaillez en binômes avec un rapport commun; chaque personne doit pouvoir expliquer les résultats. Changez de personne au clavier après l’étape 2. Si vous travaillez seul, les mêmes productions sont attendues.

| Étape | Production |
|----|----|
| Comprendre et séparer | Fichier vérifié et deux tableaux : apprentissage et validation |
| Ajuster et prendre position | Droite, modèle quadratique et choix provisoire |
| Pause | Enregistrer le travail avant de passer à la validation |
| Valider et diagnostiquer | Une RMSE par période et par modèle, puis les résidus et l’analyse de l’incident |
| Auditer et relire | Réponses aux trois affirmations et recommandation justifiée |
| Recalculer | Rapport corrigé et HTML vérifié |
| Consolider | [Fiche individuelle pour l’intra](../../modules/atelier-02-regression/consolidation.llms.md) |
| Vérifier le mini-rapport | [Vérification finale du dossier évalué](../../modules/atelier-02-regression/guide-atelier.llms.md#mini-rapport-1) |

La validation fait partie du parcours essentiel. Une fois ce parcours terminé, vous pouvez choisir un des [prolongements facultatifs](../../modules/atelier-02-regression/exercices.llms.md).

## Supports

- [Guide étudiant et résultats attendus](../../modules/atelier-02-regression/guide-atelier.llms.md).
- [Présentation de lancement](../../modules/atelier-02-regression/presentation.llms.md).
- [Données de livraison](data/livraisons_regionales_quebec.csv) et [dictionnaire](data/dictionnaire-livraisons.md).
- [Repères](../../modules/atelier-02-regression/capsules.llms.md), [aide R à la demande](../../modules/atelier-02-regression/demonstrations.llms.md) et [lectures](../../modules/atelier-02-regression/lectures.llms.md).

Le laboratoire est formatif. Le mini-rapport 1 garde ses consignes et exige un jeu extérieur approuvé. Les données du laboratoire sont inadmissibles pour ce travail évalué.
