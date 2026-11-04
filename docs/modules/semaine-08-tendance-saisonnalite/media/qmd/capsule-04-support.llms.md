# Capsule 4 - Comparer sur une validation commune

MQT-2101 - Analyse et modélisation des données


## Pourquoi ça compte

Le calendrier fait-il mieux que reprendre la dernière année?

Un bon ajustement ne garantit pas une prévision utile des prochains mois.

## Objectifs de la capsule

- Construire le calendrier futur.
- Comparer les mêmes cibles à une seule origine.
- Interpréter ME, MAE et RMSE en dollars.

## Connaître le calendrier, pas les ventes

- Les mois de 2025 sont connus fin 2024.
- L’indice continue de 61 à 72.
- Les ventes futures ne servent pas à prévoir.
- Le budget cible ne sert pas de prédicteur.

## Quatre candidats annoncés

Tendance et saison

deux modèles séparés

Calendrier

tendance et mois ensemble

Naïf saisonnier

reprendre les douze mois de 2024

## Des informations identiques

Une seule origine à la fin de 2024. Douze horizons et douze cibles communs. Paramètres estimés sur 2020 à 2024.

Mettre à jour une prévision avec une vente de 2025 répondrait à un autre protocole.

## Les erreurs sur la validation

ME : erreur moyenne signée. MAE : erreur absolue moyenne. RMSE : racine de l’erreur quadratique moyenne.

| Méthode         | ME (\$ CA) | MAE (\$ CA) | RMSE (\$ CA) |
|:----------------|:-----------|:------------|:-------------|
| Calendrier      | -3 538     | 9 891       | 11 280       |
| Tendance        | -4 347     | 17 064      | 20 292       |
| Naïf saisonnier | 29 067     | 29 067      | 30 170       |
| Saison          | 100 302    | 100 302     | 100 872      |

## Les trajectoires complètent le classement

![](capsule-04-support_files/figure-html/m08-c4-trajectoires-1.png)

## Choisir provisoirement

- Le modèle combiné a ici la plus petite MAE.
- Le modèle saisonnier seul ne décrit pas la croissance.
- La validation sert au choix, sans test final indépendant.
- Le classement doit être réévalué à de nouvelles origines.

## À retenir

Comparer

mêmes dates et informations

Mesurer

erreurs en dollars

Choisir

un résultat limité à ce protocole

## Production autonome 8.4

Construisez le calendrier de 2025 avec les indices 61 à 72. Émettez les prévisions des trois modèles et du naïf saisonnier à l’origine de fin 2024. Calculez ME, MAE et RMSE en dollars, tracez les trajectoires et justifiez un choix provisoire.

Cette production se réalise une seule fois dans le rapport guidé.

### Auto-vérification

- Les quatre candidats utilisent les mêmes douze cibles et informations disponibles.
- Je n’ai utilisé ni ventes futures ni budget cible comme prédicteur.
- Mon choix repose sur les erreurs de validation et reste provisoire.
