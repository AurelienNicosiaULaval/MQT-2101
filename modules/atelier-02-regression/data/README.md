# Données - Atelier 02

Ce dossier contient les données publiques utilisées dans l'atelier sur la
régression appliquée.

## Fichier du parcours essentiel

- `livraisons_regionales_quebec.csv` : 96 livraisons entièrement simulées, avec distance en kilomètres et durée en minutes. Une ligne représente une livraison.
- `dictionnaire-livraisons.md` : description des sept variables, des deux périodes et de la panne confirmée de L072.

Utilisez les observations antérieures au 1er octobre 2025 pour l'apprentissage et les autres pour la validation, comme indiqué dans le guide.

## Fichier du prolongement sur les délais de service

- `performance_succursales_quebec.csv` : données simulées sur la performance
  mensuelle de succursales fictives au Québec. Chaque ligne représente une
  combinaison mois-succursale.

### Variables du fichier de succursales

- `mois` : mois de l'observation;
- `mois_label` : nom du mois;
- `saison` : période régulière, moyenne ou haute;
- `succursale` : succursale fictive;
- `region` : région administrative québécoise;
- `surface_m2` : superficie de la succursale;
- `campagne_locale` : présence ou absence d'une campagne locale;
- `depenses_marketing` : dépenses marketing mensuelles;
- `achalandage` : achalandage mensuel;
- `heures_personnel` : heures de personnel planifiées;
- `ruptures_stock` : nombre de ruptures de stock observées;
- `delai_service_minutes` : délai de service moyen;
- `satisfaction` : score de satisfaction simulé;
- `ventes` : ventes mensuelles.

Les données sont simulées pour l'enseignement. Elles ne représentent pas une
organisation réelle.
