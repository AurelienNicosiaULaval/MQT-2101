# Module 08 - Tendance et saisonnalité

> **NOTE:**
>
> Une organisation peut croître tout en connaissant des mois systématiquement forts ou faibles. Séparer tendance et saisonnalité aide à établir des budgets réalistes, à planifier la capacité et à ne pas confondre effet du calendrier et performance exceptionnelle.

## Continuité du parcours

Après les méthodes de lissage du module 07, vous cherchez maintenant une structure explicable dans la série. La même séparation entraînement-test et les mêmes mesures d’erreur restent nécessaires.

## Résultat attendu

À la fin du module, vous pourrez :

- distinguer tendance et saisonnalité;
- représenter une saisonnalité mensuelle;
- ajuster une régression avec tendance et mois;
- interpréter un coefficient saisonnier relativement à un mois de référence;
- produire des prévisions et intervalles pour une période test;
- comparer le modèle à une référence saisonnière naïve.

Temps de travail indicatif : 2 h 30 à 3 h.

## Données

Le fichier [`ventes_saisonnieres_quebec.csv`](data/ventes_saisonnieres_quebec.csv) contient 72 mois de ventes et de budgets fictifs.

## Parcours

1.  [Capsules et activités](../../modules/semaine-08-tendance-saisonnalite/capsules.llms.md)
2.  [Notes de cours](../../modules/semaine-08-tendance-saisonnalite/notes-cours.llms.md)
3.  [Démonstrations R](../../modules/semaine-08-tendance-saisonnalite/demonstrations.llms.md)
4.  [Exercices](../../modules/semaine-08-tendance-saisonnalite/exercices.llms.md)
5.  [Lectures ciblées](../../modules/semaine-08-tendance-saisonnalite/lectures.llms.md)

## Trace finale

Construisez un modèle de ventes avec tendance et effet du mois. Évaluez-le sur les douze derniers mois et comparez-le à la valeur observée le même mois de l’année précédente. Présentez un graphique, MAE, une interprétation saisonnière, une recommandation budgétaire et une limite.

## Auto-vérification

Mon indice de temps augmente d’une unité par mois.

Le mois est traité comme une catégorie ordonnée pour l’affichage et comme facteur dans le modèle.

J’identifie la catégorie de référence avant d’interpréter les coefficients.

Ma période test vient après l’entraînement.

Je communique l’incertitude de la prévision.

## Lien avec l’évaluation

Ce module prépare la partie tendance, saisonnalité et incertitude du mini-rapport 2 et de l’examen final.
