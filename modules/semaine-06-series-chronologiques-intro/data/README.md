# Données du module 06

`consommation_electrique_batiment_quebec.csv` contient 72 mois de consommation d’électricité d’un bâtiment universitaire fictif au Québec, de janvier 2020 à décembre 2025. Chaque ligne décrit l’énergie totale d’un mois, en kWh, et son calendrier.

Toutes les valeurs de consommation sont simulées pour l’enseignement. Aucune mesure de l’Université Laval, d’un autre établissement ou d’un fournisseur d’électricité n’est utilisée. Le scénario suppose un motif hivernal dominant, un petit supplément estival, une légère tendance et une variation irrégulière. Ces hypothèses ne décrivent pas la consommation réelle des bâtiments québécois et les motifs ne prouvent aucune causalité.

Le générateur est `scripts/24_create_module06_electricity.R`, avec la graine 210106. Il utilise le nombre réel de jours du calendrier et simule un niveau quotidien de 4 500 + 10 × rang du mois, une composante annuelle de 1 900 × cos(2π × (mois − 1)/12) et un supplément de 500 × max(0, cos(2π × (mois − 7)/12)), en kWh/jour. Le total mensuel reçoit une perturbation normale d’écart-type 5 000 kWh avant arrondi. Tous les coefficients sont des choix pédagogiques. Le fichier peut être redistribué avec le matériel du cours.

## Utilisation dans le parcours

Les [dictionnaires](dictionnaires.md) précisent les unités, les périodes et les limites des deux jeux employés dans le module. Le rapport guidé utilise la consommation mensuelle d’électricité; les exercices de transfert utilisent la demande hebdomadaire déjà fournie au laboratoire 3. Les deux cas et leurs projets de départ restent distincts.

L’apprentissage couvre janvier 2020 à décembre 2024 (60 mois), et la validation couvre 2025 (12 mois), à l’origine de décembre 2024. Les graphiques peuvent afficher des MWh (1 MWh = 1 000 kWh); les scores ME, MAE et RMSE restent en kWh. Le fichier ne décrit ni la puissance maximale en kW ni une facture en dollars.

Les archives de départ et de correction incluent leurs CSV, le dictionnaire et les fonctions R nécessaires. Les six étapes principales constituent le parcours attendu; les deux compléments et les huit exercices supplémentaires sont facultatifs.
