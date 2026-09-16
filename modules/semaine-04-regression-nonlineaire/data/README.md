# Données - Module 04

Ce dossier contient les données publiques utilisées dans le module sur la
régression non linéaire et les transformations.

## Fichier

- `achalandage_saturation_quebec.csv` : données simulées sur l'achalandage,
  la saturation opérationnelle et les ventes de succursales fictives au Québec.
  Chaque ligne représente une combinaison mois-succursale.

## Variables principales

- `mois` : mois de l'observation;
- `mois_label` : nom du mois;
- `saison` : période régulière, moyenne ou haute;
- `succursale` : succursale fictive;
- `region` : région québécoise;
- `surface_m2` : superficie de la succursale;
- `capacite_reference` : niveau de capacité utilisé pour simuler la saturation;
- `campagne_locale` : présence ou absence d'une campagne locale;
- `depenses_marketing` : dépenses marketing mensuelles;
- `achalandage` : nombre de visites pendant le mois;
- `taux_occupation` : achalandage rapporté à la capacité de référence;
- `ruptures_stock` : nombre de ruptures de stock observées;
- `temps_attente_minutes` : temps d'attente moyen;
- `panier_moyen` : ventes divisées par l'achalandage;
- `satisfaction` : score de satisfaction simulé;
- `ventes` : ventes mensuelles, en dollars canadiens.

Le fichier contient 72 lignes : six succursales pendant les douze mois de 2025.
Le parcours utilise janvier à septembre pour l’apprentissage (54 lignes), puis
octobre à décembre pour la validation (18 lignes). Les mêmes succursales sont
présentes dans les deux périodes.

Le taux d’occupation est un rapport à une capacité de référence, pas une
probabilité; il peut dépasser 1. L’achalandage d’apprentissage va de 1 151 à
3 833 visites. Deux observations de validation dépassent ce maximum.

Les données sont simulées pour l'enseignement. Elles ne représentent pas une
organisation réelle.
