# Bienvenue au laboratoire 02

Auditer une prévision de livraison

MQT-2101, Université Laval

## La mission

La direction veut prévoir la durée de livraisons comparables à partir de leur distance.

Elle propose un modèle quadratique parce qu’il décrit mieux les données d’apprentissage.

Vous devez vérifier les prévisions sur les livraisons suivantes et expliquer où le modèle peut être utilisé.

Le CSV contient 96 livraisons simulées dans quatre centres : durée en minutes et distance en kilomètres.

## Ce que vous devez faire

Le gabarit fournit l’importation; vous construisez l’analyse.

1.  Définir les périodes d’apprentissage et de validation.
2.  Comparer une droite et un modèle quadratique.
3.  Indiquer votre choix avant d’examiner la validation.
4.  Maintenir ou réviser ce choix à partir des résultats.
5.  Justifier une recommandation et une limite.

Reprenez un point à améliorer du laboratoire 01. Changez de personne au clavier après les premiers ajustements.

## Les règles de comparaison

Apprentissage : dates antérieures au 1er octobre 2025.

Validation : dates à partir du 1er octobre 2025.

Comparez les deux modèles sur les mêmes observations dans chaque période. La durée reste en minutes.

Ne réajustez pas les modèles avec les livraisons de validation.

## Interpréter et vérifier

- Droite : pente pour cinq kilomètres, ordonnée à l’origine et R².
- Quadratique : variations de 20 à 25 km et de 50 à 55 km.
- Tableau : effectifs, R² ajusté, RMSE d’apprentissage et de validation pour chaque modèle.
- Résidus des deux modèles : repérer L072, retardée par une panne confirmée.
- Prédictions à 25 km et à 95 km : vérifier si les distances sont dans la plage d’apprentissage.

Un incident confirmé n’est pas automatiquement une erreur à supprimer.

## Trois affirmations à auditer

1.  « Le plus grand R² d’apprentissage donne le meilleur modèle pour l’automne. »
2.  « Une minute de RMSE en moins, c’est une minute de moins par livraison. »
3.  « Prévoir à 95 km est aussi défendable qu’à 25 km. »

Pour chacune, donnez votre réponse et justifiez-la avec un résultat ou une limite précise.

## Conclure et relire

Nommez le modèle retenu, citez deux résultats chiffrés et précisez les livraisons auxquelles votre conclusion s’applique.

Ajoutez une limite et une vérification à faire ensuite.

Un autre binôme relève un élément réussi et une amélioration précise dans votre rapport.

Corrigez le rapport, redémarrez R, cliquez sur Render et vérifiez le HTML.

La mission est complète avec deux modèles; les prolongements sont facultatifs.

## Consolider et préparer le mini-rapport

Faites la [fiche individuelle](../../modules/atelier-02-regression/consolidation.llms.md) sans R ni IA au premier essai.

Le mini-rapport 1 garde ses propres exigences : jeu extérieur approuvé, livrables complets et remise selon ses consignes.

La validation est essentielle dans ce laboratoire, facultative dans le mini-rapport selon sa grille actuelle.

## Pour commencer

Ouvrez le [guide](../../modules/atelier-02-regression/guide-atelier.llms.md) et décompressez le [dossier étudiant](../../assets/exemples/laboratoire-02.zip).

Dans RStudio, ouvrez `laboratoire-02.Rproj`, puis `rapport-labo-02.qmd` et cliquez sur Render.

Gardez le dictionnaire ouvert. Commencez par les données et la séparation.

Apportez ensuite une question ciblée sur votre propre mini-rapport.
