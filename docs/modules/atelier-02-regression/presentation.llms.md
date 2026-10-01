# Bienvenue au laboratoire 02

Auditer une prévision de livraison

MQT-2101, Université Laval

## La mission

La direction veut prévoir la durée de livraisons comparables à partir de leur distance.

Elle propose une courbe parce qu’elle ajuste mieux les anciennes observations.

Votre rôle : auditer la proposition et préciser son domaine d’utilisation.

Nouveau CSV simulé : 96 livraisons, quatre centres, durée en minutes et distance en kilomètres.

## Ce qui vous appartient

Le gabarit fournit l’importation; vous construisez l’analyse.

1.  Verrouiller les périodes.
2.  Comparer droite et quadratique.
3.  Prendre position avant la validation.
4.  Confirmer ou réviser cette position.
5.  Justifier une recommandation et une limite.

Reprenez un point à améliorer du laboratoire 01. Alternez le clavier.

## Les règles de comparaison

Apprentissage : dates antérieures au 1er octobre 2025.

Validation : dates à partir du 1er octobre 2025.

Deux formes, mêmes observations dans chaque période et durée en minutes.

Ne réajustez pas les modèles avec les livraisons de validation.

## Interpréter et vérifier

- Droite : pente pour cinq kilomètres, intercept et R².
- Quadratique : variations de 20 à 25 km et de 50 à 55 km.
- Tableau : effectifs, R² ajusté et les deux RMSE.
- Résidus : repérer L072, une panne confirmée.
- Prédictions : 25 km et 95 km, domaines à distinguer.

Un incident confirmé n’est pas automatiquement une erreur à supprimer.

## Trois affirmations à auditer

1.  « Le plus grand R² d’apprentissage donne le meilleur modèle pour l’automne. »
2.  « Une minute de RMSE en moins, c’est une minute de moins par livraison. »
3.  « Prévoir à 95 km est aussi défendable qu’à 25 km. »

Pour chacune : un jugement et une preuve ou une limite précise.

## Conclure et relire

Modèle retenu, deux résultats chiffrés, plage utile, réserve et prochaine vérification.

Un autre binôme relève un acquis et une amélioration localisée.

Corrigez, redémarrez R et faites Render.

La mission est complète avec deux modèles; les prolongements sont facultatifs.

## Consolider et préparer le mini-rapport

Faites la [fiche individuelle](../../modules/atelier-02-regression/consolidation.llms.md) sans R ni IA au premier essai.

Le mini-rapport 1 garde ses propres exigences : jeu extérieur approuvé, livrables complets et remise selon ses consignes.

La validation est essentielle dans ce laboratoire, facultative dans le mini-rapport selon sa grille actuelle.

## Pour commencer

Ouvrez le [guide](../../modules/atelier-02-regression/guide-atelier.llms.md), décompressez le [dossier étudiant](../../assets/exemples/laboratoire-02.zip) et faites un premier rendu.

Gardez le dictionnaire ouvert. Commencez par les données et la séparation.

Apportez ensuite une question ciblée sur votre propre mini-rapport.
