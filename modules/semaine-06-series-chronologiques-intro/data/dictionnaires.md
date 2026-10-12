# Dictionnaires du module 6

## Consommation mensuelle d’électricité

Une ligne représente l’énergie consommée pendant un mois par un bâtiment universitaire fictif au Québec. 72 observations, janvier 2020 à décembre 2025. Les données sont entièrement simulées et ne décrivent aucun bâtiment réel.

| Variable | Définition et unité |
| --- | --- |
| date | Mois entier, encodé par son premier jour |
| annee | Année civile |
| mois | Numéro du mois, de 1 à 12 |
| mois_label | Nom français du mois, à ordonner selon mois |
| trimestre | Trimestre civil, T1 à T4 |
| jours_mois | Nombre de jours du mois civil, y compris les années bissextiles |
| consommation_kwh | Énergie totale simulée pendant le mois, en kilowattheures (kWh) |

La consommation est une quantité d’énergie. Elle ne mesure pas la puissance de pointe en kW et ne constitue pas une facture. Les graphiques affichent parfois des MWh (1 MWh = 1 000 kWh); les scores ME, MAE et RMSE sont calculés sur la cible en kWh. Aucune donnée tarifaire n’est fournie.

Le fichier est généré par `scripts/24_create_module06_electricity.R`, avec la graine 210106. Le niveau, la tendance, le motif hivernal dominant, le supplément estival et le bruit sont imposés par un scénario pédagogique, détaillé dans le README des données. Une explication causale réelle ne peut pas être déduite de cette simulation.

## Demande hebdomadaire

Une ligne représente une semaine pour un produit fictif. 104 observations du 1er janvier 2024 au 22 décembre 2025. Un cycle de 52 semaines représente ici 364 jours; il ne reproduit pas parfaitement chaque année civile ou le calendrier des fêtes.

| Variable | Définition et unité |
| --- | --- |
| semaine | Date de début de semaine, lundi |
| numero_semaine | Numéro ISO de semaine, différent du rang dans le tableau |
| promotion | Promotion simulée, oui ou non |
| prix_moyen | Prix moyen simulé, dollars canadiens par unité |
| demande | Demande hebdomadaire simulée, unités de produit |

Le fichier de demande est généré par `scripts/10_create_second_block_data.R`, avec une graine fixée. Les deux cas ne décrivent aucune organisation réelle. Ils restent distincts pour permettre le transfert des méthodes.
