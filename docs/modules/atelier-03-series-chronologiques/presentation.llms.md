# Laboratoire 03 - Prévoir la demande

MQT-2101 - Analyse et modélisation des données


## Pourquoi ça compte

Comment préparer les livraisons des prochains mois?

Comparer des prévisions à la même origine et expliquer les réserves à la direction.

## Objectifs du laboratoire

- Définir cible, origine, horizon et validation.
- Comparer une référence saisonnière et une régression avec tendance et mois.
- Interpréter les erreurs, l’incertitude et un coût fictif.
- Formuler une recommandation avec limite et suivi.

## Une nouvelle situation

Un mois

une ligne, livraisons fictives

60 mois

apprentissage de 2020 à 2024

12 mois

validation pour comparer

## Du module 07 à la mission

Pourquoi un classement peut-il changer quand on ajoute une méthode?

Reprenez les résultats hebdomadaires sans refaire les quatre prévisions, puis travaillez sur le nouveau cas mensuel.

## Deux prévisions à la même origine

Référence

naïf saisonnier : reprendre les mois de 2024

Régression

tendance et indicatrices de mois

Futur

indices 61 à 72, mois connus

## Comparer et interpréter

ME

erreur moyenne signée

MAE

moyenne des erreurs absolues

RMSE

racine de l’erreur quadratique moyenne

Erreur = observation − prévision. Les mesures sont en livraisons.

## Incertitude et coût

- Interprétez un intervalle de prédiction de la régression et ses hypothèses.
- Comparez les coûts fictifs : 2 \$ par livraison sous-prévue, 1 \$ par livraison sur-prévue.
- Réexaminez la méthode à de nouvelles origines.

## À retenir

Temps

prévoir avant de comparer

Preuve

mêmes cibles et unités

Décision

coût fictif, limite et suivi

## Production du laboratoire

Dans un seul rapport Quarto, vérifiez la série et le calendrier, comparez le naïf saisonnier et le modèle avec tendance et mois sur les mêmes douze mois, puis recommandez une méthode avec deux mesures, le coût simulé, un intervalle identifié, une limite et une règle de surveillance.

Cette production se réalise une seule fois dans `rapport-labo-03.qmd`.

### Auto-vérification

- J’ai précisé l’origine, les dates et les unités.
- Je compare les deux méthodes sur les mêmes douze cibles.
- Je nomme la méthode de l’intervalle et ses hypothèses.
- Ma recommandation cite des résultats, une limite et un suivi.

## Rétroaction et suite

- Présentez votre protocole après une première tentative.
- Faites relire le rapport et corrigez un point précis.
- Apportez votre projet autonome au point de contrôle du mini-rapport 2.
- Redémarrez R et rendez le rapport avec ses données.

## Références et crédits

- Hyndman et Athanasopoulos (2021), Forecasting: Principles and Practice, 3e édition.
- Données de livraisons entièrement simulées pour le cours MQT-2101, Université Laval.
