# Données de la semaine 02

`ventes_operations_quebec.csv` est un jeu de données simulé pour pratiquer l'importation, l'inspection, la factorisation, le repérage des valeurs manquantes, les tableaux descriptifs et les graphiques avec R.

Chaque ligne représente une succursale pour un mois.

Variables principales :

- `mois` : date du mois;
- `succursale` : ville de la succursale;
- `region` : région administrative;
- `surface_m2` : taille de la succursale;
- `campagne_locale` : indicateur textuel de campagne locale;
- `canal_principal` : canal principal de vente;
- `clients` : nombre de clients;
- `panier_moyen` : panier moyen en dollars;
- `ventes` : ventes mensuelles;
- `delai_livraison_jours` : délai moyen de livraison;
- `satisfaction` : satisfaction moyenne sur 10.

Le fichier remplace l'ancien exercice `masculinity.csv` afin de garder les mêmes compétences techniques dans un contexte d'administration.

Les données ont été générées avec `scripts/06_prepare_weeks_01_02_data.R`.
