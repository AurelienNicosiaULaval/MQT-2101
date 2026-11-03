# Dictionnaire des données du module 09

Deux jeux fictifs simulés par `scripts/10_create_second_block_data.R`, graine 210110, redistribuables avec le cours; aucune observation réelle ni donnée personnelle. Le script local `R/regenerer-donnees.R` conserve les tirages précédents et réécrit seulement les deux CSV locaux.

## Ventes et promotions

72 mois de janvier 2020 à décembre 2025, une ligne par mois, sans valeur manquante. Ventes mensuelles et budget marketing en dollars canadiens; prix moyen en dollars par unité; indice de confiance fictif en points; promotion oui/non; tendance est le rang 1 à 72; date correspond au premier jour du mois et mois à son numéro. Les observations successives sont dépendantes. Le générateur ajoute une erreur AR(1), ce qui ne dispense pas d’examiner les données.

## Succursales

288 lignes, 72 mois pour quatre succursales fictives. Une ligne est un mois et une succursale; les lignes d’une même succursale sont dépendantes. `indice_temps` est le rang du mois dans la succursale, `promotion` vaut oui/non, `capacite` est un nombre d’unités de service, `achalandage` le nombre de visites, `ruptures_stock` le nombre de ruptures, `temps_attente` des minutes, `satisfaction` une note de 1 à 10 et `ventes` des dollars canadiens. `taux_utilisation` est un rapport et `service_insuffisant_mois_suivant` une cible binaire future, inutilisée comme prédicteur ici. Les valeurs du mois à prévoir ne sont pas automatiquement connues à son début.

## Protocole

Cas guidé : 60 mois pour ajuster, puis douze mois de 2025 pour la comparaison conditionnelle aux prédicteurs observés; origine fin décembre 2024. Ces mêmes mois ont déjà été examinés au module 08 : ils ne sont pas un test final indépendant. Le scénario de janvier 2025 est une illustration hypothétique, pas une affirmation sur un plan réel. Cas de transfert : diagnostics par succursale sur 2020 à 2024, puis illustration d’un scénario à un mois depuis fin 2025, avec modèle ajusté jusqu’à cette origine.
