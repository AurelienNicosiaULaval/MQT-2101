# Mini-rapport 2 - Prévision ou classification

## Objectif et pondération

Produire en équipe une analyse prédictive reproductible avec validation hors échantillon et recommandation décisionnelle.

Pondération : 15 % de la note finale.

## Échéancier pédagogique

- Proposition et validation du jeu de données : au plus tard à la fin du module 08.
- Point de contrôle sur la validation : pendant l’atelier 03.
- Remise : le mercredi 2 décembre 2026 à 23 h 59.

Le dépôt se fait dans Brio. Il est recommandé de vérifier l’archive avant la dernière heure.

## Modalité

- Équipe de 2 ou 3 personnes.
- Environ 1 200 à 1 600 mots, hors code et références.
- Maximum de quatre figures ou tableaux principaux.
- Choisir une seule voie et la développer complètement.
- IA permise avec déclaration selon la [politique du cours](../ressources/ia.llms.md).

## Voie A - Prévision temporelle

Le rapport doit inclure :

- cible, origine, fréquence et horizon;
- audit de la continuité temporelle;
- graphique de tendance, saisonnalité et valeurs inhabituelles;
- séparation chronologique entraînement-test;
- référence naïve ou saisonnière naïve;
- au moins une méthode principale;
- MAE et RMSE, plus une mesure ou un coût adapté;
- prévision conditionnelle et incertitude;
- recommandation et règle de surveillance.

## Voie B - Classification binaire

Le rapport doit inclure :

- définition de l’événement, de la classe positive et de l’horizon;
- séparation entraînement-test;
- régression logistique comme référence ou méthode principale;
- probabilités prédites et vérification descriptive de calibration;
- matrices de confusion à au moins deux seuils;
- sensibilité, spécificité, précision et proportion ciblée;
- choix de seuil selon les coûts ou la capacité;
- recommandation et limite éthique ou opérationnelle.

## Livrables

Remettre une archive contenant : source `.qmd`, HTML autonome, données autorisées ou script d’importation, `README.md`, déclaration IA ou mention de non-usage influent, et déclaration de contribution.

## Validation des données

Suivez la [procédure de validation](../evaluations/validation-donnees.llms.md). Les données futures ou la cible ne doivent jamais fuiter dans la préparation des prédicteurs.

## Grille

La [grille commune des mini-rapports](../evaluations/grille-mini-rapports.llms.md) est appliquée sur 100 points puis convertie en 15 %. Pour ce rapport, la rubrique « modélisation et validation » exige explicitement une preuve hors échantillon.

## Gabarit

Utilisez le [gabarit du mini-rapport 2](../ressources/gabarit-mini-rapport-2.llms.md).
