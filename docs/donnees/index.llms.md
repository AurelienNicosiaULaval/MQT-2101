# Données

Cette page rassemble les jeux de données utilisés dans le cours. Pour chaque base, vous trouverez un lien de téléchargement, un court résumé, un aperçu interactif du tableau et une description des variables.

## Jeux de données disponibles

Module 01 - Introduction

## Naissances quotidiennes aux États-Unis

Observations quotidiennes de naissances aux États-Unis.

3 652 observations · 5 variables

[Télécharger le CSV](../modules/semaine-01-introduction/data/birth_us.csv)

Module 01 - Introduction

## Sécurité aérienne par compagnie

Données descriptives par compagnie aérienne, avec trafic hebdomadaire, incidents, accidents mortels et décès sur deux périodes.

56 observations · 8 variables

[Télécharger le CSV](../modules/semaine-01-introduction/data/safety_airlines.csv)

Module 02 - R et Quarto

## Ventes et opérations de succursales québécoises

Jeu de données simulé où chaque ligne représente une succursale pour un mois.

24 observations · 12 variables

[Télécharger le CSV](../modules/semaine-02-r-quarto/data/ventes_operations_quebec.csv)

Atelier 01 - Explorer un tableau

## Ventes mensuelles d’une PME québécoise fictive

Jeu de données simulé sur les ventes mensuelles d’une PME québécoise fictive dans cinq succursales.

60 observations · 15 variables

[Télécharger le CSV](../modules/atelier-01-r/data/ventes_pme_quebec.csv)

Module 03 - Régression linéaire

## Campagnes marketing québécoises fictives

Jeu de données simulé sur des campagnes marketing régionales fictives.

60 observations · 10 variables

[Télécharger le CSV](../modules/semaine-03-regression-lineaire/data/campagnes_marketing_quebec.csv)

Atelier 02 - Audit de régression

## Livraisons régionales québécoises fictives

96 livraisons simulées dans quatre centres, avec distance, durée et incident documenté.

96 observations · 7 variables

[Télécharger le CSV](../modules/atelier-02-regression/data/livraisons_regionales_quebec.csv)

Exemple complémentaire de régression

## Performance de succursales québécoises fictives

Jeu de données simulé sur la performance mensuelle de succursales fictives au Québec.

72 observations · 14 variables

[Télécharger le CSV](../modules/atelier-02-regression/data/performance_succursales_quebec.csv)

Module 04 - Régression non linéaire

## Achalandage et saturation de succursales fictives

Jeu de données simulé sur l’achalandage, la saturation opérationnelle et les ventes de succursales fictives.

72 observations · 16 variables

[Télécharger le CSV](../modules/semaine-04-regression-nonlineaire/data/achalandage_saturation_quebec.csv)

Module 06 - Séries chronologiques

## Consommation mensuelle d’électricité fictive

Consommation d’électricité entièrement simulée pour un bâtiment universitaire fictif au Québec sur 72 mois, en kWh.

72 observations · 7 variables

[Télécharger le CSV](../modules/semaine-06-series-chronologiques-intro/data/consommation_electrique_batiment_quebec.csv)

Module 07 et Atelier 03

## Demande hebdomadaire fictive

Série hebdomadaire simulée de demande, prix et promotion sur 104 semaines.

104 observations · 5 variables

[Télécharger le CSV](../modules/semaine-07-lissage/data/demande_hebdomadaire_quebec.csv)

Module 08 - Tendance et saisonnalité

## Ventes saisonnières fictives

Série mensuelle simulée avec tendance, saisonnalité et budget cible.

72 observations · 8 variables

[Télécharger le CSV](../modules/semaine-08-tendance-saisonnalite/data/ventes_saisonnieres_quebec.csv)

Module 09 - Variables externes

## Ventes et promotions fictives

Série mensuelle simulée avec promotions, prix et dépendance temporelle.

72 observations · 10 variables

[Télécharger le CSV](../modules/semaine-09-variables-externes-autocorrelation/data/ventes_promotions_quebec.csv)

Module 10 - Classification

## Fidélisation de clients fictifs

Données transversales simulées de 650 clients avec cible de départ à 90 jours.

650 observations · 9 variables

[Télécharger le CSV](../modules/semaine-10-classification-modeles-avances/data/fidelisation_clients_quebec.csv)

Atelier 04 - Intégration

## Cas intégrateur de succursales fictives

Données mensuelles simulées pour quatre succursales avec réponses continue et binaire.

288 observations · 12 variables

[Télécharger le CSV](../modules/atelier-04-recapitulation/data/cas_integrateur_quebec.csv)

## Naissances quotidiennes aux États-Unis

Observations quotidiennes de naissances aux États-Unis. Ce fichier est utilisé pour revoir la notion d’observation, distinguer les types de variables et produire de premières descriptions numériques.

Source : FiveThirtyEight, *U.S. Births*, à partir des données du CDC/National Center for Health Statistics. Licence du dépôt : CC BY 4.0.

[Télécharger birth_us.csv](../modules/semaine-01-introduction/data/birth_us.csv)

### En bref

| information | valeur |
|:---|:---|
| Module | Module 01 - Introduction |
| Observations | 3 652 |
| Variables | 5 |
| Valeurs manquantes | 0 |
| Utilisation dans le cours | Revoir la notion d’observation, classer des variables, produire des mesures descriptives et préparer un premier tableau. |

### Aperçu interactif

### Variables

| variable | type | valeurs_manquantes | proportion_manquante | valeurs_distinctes | exemple |
|:---|:---|---:|:---|---:|:---|
| year | numeric | 0 | 0 % | 10 | 1994 |
| month | numeric | 0 | 0 % | 12 | 1 |
| date_of_month | numeric | 0 | 0 % | 31 | 1 |
| day_of_week | numeric | 0 | 0 % | 7 | 6 |
| births | numeric | 0 | 0 % | 2526 | 8096 |

Profil des variables de birth_us.csv {.caption-top .table .table-sm .table-striped .small}

### Distribution des variables numériques

![](index_files/figure-html/plot-birth-us-1.png)

## Sécurité aérienne par compagnie

Données descriptives par compagnie aérienne. Le fichier sert à discuter la différence entre un nombre brut et un indicateur rapporté à une échelle d’exposition.

Source : FiveThirtyEight, *Airline Safety*, à partir de l’Aviation Safety Network. Licence du dépôt : CC BY 4.0. Ces données historiques ne décrivent pas la sécurité actuelle d’une compagnie.

[Télécharger safety_airlines.csv](../modules/semaine-01-introduction/data/safety_airlines.csv)

### En bref

| information | valeur |
|:---|:---|
| Module | Module 01 - Introduction |
| Observations | 56 |
| Variables | 8 |
| Valeurs manquantes | 0 |
| Utilisation dans le cours | Comparer des indicateurs bruts et des échelles de référence, puis discuter l’interprétation prudente d’un tableau. |

### Aperçu interactif

### Variables

| variable | type | valeurs_manquantes | proportion_manquante | valeurs_distinctes | exemple |
|:---|:---|---:|:---|---:|:---|
| airline | character | 0 | 0 % | 56 | Aer Lingus |
| avail_seat_km_per_week | numeric | 0 | 0 % | 56 | 320906734 |
| incidents_85_99 | numeric | 0 | 0 % | 19 | 2 |
| fatal_accidents_85_99 | numeric | 0 | 0 % | 11 | 0 |
| fatalities_85_99 | numeric | 0 | 0 % | 38 | 0 |
| incidents_00_14 | numeric | 0 | 0 % | 14 | 0 |
| fatal_accidents_00_14 | numeric | 0 | 0 % | 4 | 0 |
| fatalities_00_14 | numeric | 0 | 0 % | 23 | 0 |

Profil des variables de safety_airlines.csv {.caption-top .table .table-sm .table-striped .small}

### Distribution des variables numériques

![](index_files/figure-html/plot-safety-airlines-1.png)

## Ventes et opérations de succursales québécoises

Jeu de données simulé où chaque ligne représente une succursale pour un mois. Le fichier est utilisé pour pratiquer l’importation, l’inspection, le nettoyage de base, les tableaux descriptifs et les graphiques avec R.

[Télécharger ventes_operations_quebec.csv](../modules/semaine-02-r-quarto/data/ventes_operations_quebec.csv)

### En bref

| information | valeur |
|:---|:---|
| Module | Module 02 - R et Quarto |
| Observations | 24 |
| Variables | 12 |
| Valeurs manquantes | 3 |
| Utilisation dans le cours | Pratiquer l’importation, l’inspection, la factorisation, le repérage des valeurs manquantes, les tableaux descriptifs et les graphiques avec R. |

### Aperçu interactif

### Variables

| variable | type | valeurs_manquantes | proportion_manquante | valeurs_distinctes | exemple |
|:---|:---|---:|:---|---:|:---|
| mois | Date | 0 | 0 % | 6 | 2025-01-01 |
| mois_nom | character | 0 | 0 % | 6 | janvier |
| succursale | character | 0 | 0 % | 4 | Montréal |
| region | character | 0 | 0 % | 4 | Montréal |
| surface_m2 | numeric | 0 | 0 % | 4 | 540 |
| campagne_locale | character | 0 | 0 % | 2 | non |
| canal_principal | character | 0 | 0 % | 3 | magasin |
| clients | numeric | 0 | 0 % | 24 | 2254 |
| panier_moyen | numeric | 0 | 0 % | 24 | 53.11 |
| ventes | numeric | 0 | 0 % | 24 | 119710 |
| delai_livraison_jours | numeric | 1 | 4.2 % | 18 | 2.2 |
| satisfaction | numeric | 2 | 8.3 % | 13 | 8.3 |

Profil des variables de ventes_operations_quebec.csv {.caption-top .table .table-sm .table-striped .small}

### Distribution des variables numériques

![](index_files/figure-html/plot-ventes-operations-quebec-1.png)

## Ventes mensuelles d’une PME québécoise fictive

Jeu de données simulé sur les ventes mensuelles d’une PME québécoise fictive dans cinq succursales. Le fichier sert de mini-cas d’affaires pour explorer un tableau, construire des indicateurs et formuler des constats descriptifs.

[Télécharger ventes_pme_quebec.csv](../modules/atelier-01-r/data/ventes_pme_quebec.csv)

### En bref

| information | valeur |
|:---|:---|
| Module | Atelier 01 - Explorer un tableau |
| Observations | 60 |
| Variables | 15 |
| Valeurs manquantes | 5 |
| Utilisation dans le cours | Explorer un tableau d’affaires, produire des synthèses descriptives et relier les variables opérationnelles aux ventes. |

### Aperçu interactif

### Variables

| variable | type | valeurs_manquantes | proportion_manquante | valeurs_distinctes | exemple |
|:---|:---|---:|:---|---:|:---|
| mois | Date | 0 | 0 % | 12 | 2025-01-01 |
| mois_label | character | 0 | 0 % | 12 | janvier |
| saison | character | 0 | 0 % | 3 | moyenne |
| succursale | character | 0 | 0 % | 5 | Gatineau |
| region | character | 0 | 0 % | 5 | Outaouais |
| surface_m2 | numeric | 0 | 0 % | 5 | 410 |
| campagne_locale | numeric | 0 | 0 % | 2 | 1 |
| depenses_marketing | numeric | 0 | 0 % | 60 | 4799 |
| clients | numeric | 0 | 0 % | 58 | 2188 |
| panier_moyen | numeric | 0 | 0 % | 58 | 59.35 |
| ventes | numeric | 0 | 0 % | 60 | 129858 |
| delai_livraison_jours | numeric | 2 | 3.3 % | 21 | 3 |
| ruptures_stock | numeric | 0 | 0 % | 7 | 6 |
| satisfaction | numeric | 3 | 5 % | 22 | 7.6 |
| taux_retour | numeric | 0 | 0 % | 35 | 0.076 |

Profil des variables de ventes_pme_quebec.csv {.caption-top .table .table-sm .table-striped .small}

### Distribution des variables numériques

![](index_files/figure-html/plot-ventes-pme-quebec-1.png)

## Campagnes marketing québécoises fictives

Jeu de données simulé sur des campagnes marketing régionales fictives. Le fichier sert à visualiser une relation entre budget marketing et ventes, ajuster une régression linéaire simple et interpréter les résidus.

[Télécharger campagnes_marketing_quebec.csv](../modules/semaine-03-regression-lineaire/data/campagnes_marketing_quebec.csv)

### En bref

| information | valeur |
|:---|:---|
| Module | Module 03 - Régression linéaire |
| Observations | 60 |
| Variables | 10 |
| Valeurs manquantes | 0 |
| Utilisation dans le cours | Visualiser une relation entre budget marketing et ventes, ajuster une régression linéaire simple et interpréter les résidus. |

### Aperçu interactif

### Variables

| variable | type | valeurs_manquantes | proportion_manquante | valeurs_distinctes | exemple |
|:---|:---|---:|:---|---:|:---|
| mois | Date | 0 | 0 % | 12 | 2025-01-01 |
| mois_label | character | 0 | 0 % | 12 | janvier |
| region | character | 0 | 0 % | 5 | Capitale-Nationale |
| canal | character | 0 | 0 % | 3 | Infolettre |
| saison | character | 0 | 0 % | 3 | moyenne |
| budget_marketing | numeric | 0 | 0 % | 60 | 5814 |
| visites_site | numeric | 0 | 0 % | 60 | 6393 |
| rabais | numeric | 0 | 0 % | 18 | 0 |
| ventes | numeric | 0 | 0 % | 60 | 121915 |
| satisfaction | numeric | 0 | 0 % | 22 | 7.7 |

Profil des variables de campagnes_marketing_quebec.csv {.caption-top .table .table-sm .table-striped .small}

### Distribution des variables numériques

![](index_files/figure-html/plot-campagnes-marketing-quebec-1.png)

## Livraisons régionales québécoises fictives

Nouveau jeu du laboratoire 02 : une ligne représente une livraison. La durée est en minutes, la distance en kilomètres. Le fichier est entièrement simulé. Consultez le [dictionnaire](../modules/atelier-02-regression/data/dictionnaire-livraisons.md), notamment pour la livraison avec panne confirmée et la séparation des périodes.

[Télécharger livraisons_regionales_quebec.csv](../modules/atelier-02-regression/data/livraisons_regionales_quebec.csv)

### En bref

| information | valeur |
|:---|:---|
| Module | Atelier 02 - Audit de régression |
| Observations | 96 |
| Variables | 7 |
| Valeurs manquantes | 0 |
| Utilisation dans le cours | Auditer droite et quadratique, comparer apprentissage et validation, puis juger la portée des prévisions. |

### Aperçu interactif

### Variables

| variable | type | valeurs_manquantes | proportion_manquante | valeurs_distinctes | exemple |
|:---|:---|---:|:---|---:|:---|
| livraison_id | character | 0 | 0 % | 96 | L001 |
| date | Date | 0 | 0 % | 24 | 2025-01-06 |
| centre | character | 0 | 0 % | 4 | Lévis |
| distance_km | numeric | 0 | 0 % | 86 | 11.1 |
| colis | numeric | 0 | 0 % | 23 | 23 |
| incident | character | 0 | 0 % | 2 | aucun |
| duree_minutes | numeric | 0 | 0 % | 88 | 27.2 |

## Performance de succursales québécoises fictives

Jeu de données simulé sur la performance mensuelle de succursales fictives au Québec. Ce jeu complémentaire est conservé; la mission actuelle du laboratoire 02 utilise les livraisons ci-dessus. Le fichier sert à ajuster un modèle de régression appliqué, comparer un modèle simple et un modèle enrichi, puis formuler une recommandation prudente.

[Télécharger performance_succursales_quebec.csv](../modules/atelier-02-regression/data/performance_succursales_quebec.csv)

### En bref

| information | valeur |
|:---|:---|
| Module | Exemple complémentaire de régression |
| Observations | 72 |
| Variables | 14 |
| Valeurs manquantes | 0 |
| Utilisation dans le cours | Ajuster un modèle de régression appliqué, comparer un modèle simple et un modèle enrichi, puis formuler une recommandation prudente. |

### Aperçu interactif

### Variables

| variable | type | valeurs_manquantes | proportion_manquante | valeurs_distinctes | exemple |
|:---|:---|---:|:---|---:|:---|
| mois | Date | 0 | 0 % | 12 | 2025-01-01 |
| mois_label | character | 0 | 0 % | 12 | janvier |
| saison | character | 0 | 0 % | 3 | moyenne |
| succursale | character | 0 | 0 % | 6 | Gatineau |
| region | character | 0 | 0 % | 6 | Outaouais |
| surface_m2 | numeric | 0 | 0 % | 6 | 420 |
| campagne_locale | character | 0 | 0 % | 2 | oui |
| depenses_marketing | numeric | 0 | 0 % | 72 | 5977 |
| achalandage | numeric | 0 | 0 % | 69 | 1653 |
| heures_personnel | numeric | 0 | 0 % | 54 | 483 |
| ruptures_stock | numeric | 0 | 0 % | 8 | 1 |
| delai_service_minutes | numeric | 0 | 0 % | 37 | 5.5 |
| satisfaction | numeric | 0 | 0 % | 24 | 7.7 |
| ventes | numeric | 0 | 0 % | 72 | 163260 |

Profil des variables de performance_succursales_quebec.csv {.caption-top .table .table-sm .table-striped .small}

### Distribution des variables numériques

![](index_files/figure-html/plot-performance-succursales-quebec-1.png)

## Achalandage et saturation de succursales fictives

Jeu de données simulé sur l’achalandage, la saturation opérationnelle et les ventes de succursales fictives. Le fichier sert à comparer un modèle linéaire, un modèle quadratique et un modèle logarithmique pour décrire une relation avec saturation.

[Télécharger achalandage_saturation_quebec.csv](../modules/semaine-04-regression-nonlineaire/data/achalandage_saturation_quebec.csv)

### En bref

| information | valeur |
|:---|:---|
| Module | Module 04 - Régression non linéaire |
| Observations | 72 |
| Variables | 16 |
| Valeurs manquantes | 0 |
| Utilisation dans le cours | Comparer un modèle linéaire, un modèle quadratique et un modèle logarithmique pour décrire une relation avec saturation. |

### Aperçu interactif

### Variables

| variable | type | valeurs_manquantes | proportion_manquante | valeurs_distinctes | exemple |
|:---|:---|---:|:---|---:|:---|
| mois | Date | 0 | 0 % | 12 | 2025-01-01 |
| mois_label | character | 0 | 0 % | 12 | janvier |
| saison | character | 0 | 0 % | 3 | moyenne |
| succursale | character | 0 | 0 % | 6 | Gatineau |
| region | character | 0 | 0 % | 6 | Outaouais |
| surface_m2 | numeric | 0 | 0 % | 6 | 420 |
| capacite_reference | numeric | 0 | 0 % | 6 | 2050 |
| campagne_locale | character | 0 | 0 % | 2 | non |
| depenses_marketing | numeric | 0 | 0 % | 70 | 3706 |
| achalandage | numeric | 0 | 0 % | 69 | 2366 |
| taux_occupation | numeric | 0 | 0 % | 65 | 1.154 |
| ruptures_stock | numeric | 0 | 0 % | 7 | 3 |
| temps_attente_minutes | numeric | 0 | 0 % | 35 | 5.5 |
| panier_moyen | numeric | 0 | 0 % | 72 | 70.02 |
| satisfaction | numeric | 0 | 0 % | 23 | 7.6 |
| ventes | numeric | 0 | 0 % | 72 | 165671 |

Profil des variables de achalandage_saturation_quebec.csv {.caption-top .table .table-sm .table-striped .small}

### Distribution des variables numériques

![](index_files/figure-html/plot-achalandage-saturation-quebec-1.png)

## Jeux de données du bloc prévision et classification

Les six jeux suivants sont entièrement simulés. Le cas d’électricité du module 6 est reproductible avec `scripts/24_create_module06_electricity.R`; les autres avec `scripts/10_create_second_block_data.R`, qui appelle aussi le générateur d’électricité. Les aperçus permettent de vérifier la structure avant téléchargement.

## Consommation mensuelle d’électricité fictive

Consommation d’électricité entièrement simulée pour un bâtiment universitaire fictif au Québec sur 72 mois, en kWh.

[Télécharger consommation_electrique_batiment_quebec.csv](../modules/semaine-06-series-chronologiques-intro/data/consommation_electrique_batiment_quebec.csv)

### En bref

| information | valeur |
|:---|:---|
| Module | Module 06 - Séries chronologiques |
| Observations | 72 |
| Variables | 7 |
| Valeurs manquantes | 0 |
| Utilisation dans le cours | Définir une cible et un horizon, visualiser le temps et construire une référence naïve. |

### Aperçu interactif

### Variables

| variable | type | valeurs_manquantes | proportion_manquante | valeurs_distinctes | exemple |
|:---|:---|---:|:---|---:|:---|
| date | Date | 0 | 0 % | 72 | 2020-01-01 |
| annee | numeric | 0 | 0 % | 6 | 2020 |
| mois | numeric | 0 | 0 % | 12 | 1 |
| mois_label | character | 0 | 0 % | 12 | janvier |
| trimestre | character | 0 | 0 % | 4 | T1 |
| jours_mois | numeric | 0 | 0 % | 4 | 31 |
| consommation_kwh | numeric | 0 | 0 % | 71 | 201898 |

## Demande hebdomadaire fictive

Série hebdomadaire simulée de demande, prix et promotion sur 104 semaines.

[Télécharger demande_hebdomadaire_quebec.csv](../modules/semaine-07-lissage/data/demande_hebdomadaire_quebec.csv)

### En bref

| information | valeur |
|:---|:---|
| Module | Module 07 et Atelier 03 |
| Observations | 104 |
| Variables | 5 |
| Valeurs manquantes | 0 |
| Utilisation dans le cours | Comparer moyenne mobile, méthodes naïves et lissage exponentiel sur une période test. |

### Aperçu interactif

### Variables

| variable | type | valeurs_manquantes | proportion_manquante | valeurs_distinctes | exemple |
|:---|:---|---:|:---|---:|:---|
| semaine | Date | 0 | 0 % | 104 | 2024-01-01 |
| numero_semaine | numeric | 0 | 0 % | 52 | 1 |
| promotion | character | 0 | 0 % | 2 | non |
| prix_moyen | numeric | 0 | 0 % | 90 | 42.04 |
| demande | numeric | 0 | 0 % | 93 | 1234 |

## Ventes saisonnières fictives

Série mensuelle simulée avec tendance, saisonnalité et budget cible.

[Télécharger ventes_saisonnieres_quebec.csv](../modules/semaine-08-tendance-saisonnalite/data/ventes_saisonnieres_quebec.csv)

### En bref

| information | valeur |
|:---|:---|
| Module | Module 08 - Tendance et saisonnalité |
| Observations | 72 |
| Variables | 8 |
| Valeurs manquantes | 0 |
| Utilisation dans le cours | Ajuster et valider une régression avec tendance et calendrier. |

### Aperçu interactif

### Variables

| variable | type | valeurs_manquantes | proportion_manquante | valeurs_distinctes | exemple |
|:---|:---|---:|:---|---:|:---|
| date | Date | 0 | 0 % | 72 | 2020-01-01 |
| annee | numeric | 0 | 0 % | 6 | 2020 |
| mois | numeric | 0 | 0 % | 12 | 1 |
| mois_label | character | 0 | 0 % | 12 | janvier |
| trimestre | character | 0 | 0 % | 4 | T1 |
| indice_temps | numeric | 0 | 0 % | 72 | 1 |
| ventes | numeric | 0 | 0 % | 72 | 279411 |
| budget_cible | numeric | 0 | 0 % | 72 | 214100 |

## Ventes et promotions fictives

Série mensuelle simulée avec promotions, prix et dépendance temporelle.

[Télécharger ventes_promotions_quebec.csv](../modules/semaine-09-variables-externes-autocorrelation/data/ventes_promotions_quebec.csv)

### En bref

| information | valeur |
|:---|:---|
| Module | Module 09 - Variables externes |
| Observations | 72 |
| Variables | 10 |
| Valeurs manquantes | 0 |
| Utilisation dans le cours | Auditer la disponibilité future, ajuster une régression et diagnostiquer l’autocorrélation. |

### Aperçu interactif

### Variables

| variable | type | valeurs_manquantes | proportion_manquante | valeurs_distinctes | exemple |
|:---|:---|---:|:---|---:|:---|
| date | Date | 0 | 0 % | 72 | 2020-01-01 |
| annee | numeric | 0 | 0 % | 6 | 2020 |
| mois | numeric | 0 | 0 % | 12 | 1 |
| mois_label | character | 0 | 0 % | 12 | janvier |
| tendance | numeric | 0 | 0 % | 72 | 1 |
| promotion | character | 0 | 0 % | 2 | non |
| prix_moyen | numeric | 0 | 0 % | 68 | 59.67 |
| indice_confiance | numeric | 0 | 0 % | 52 | 99.6 |
| budget_marketing | numeric | 0 | 0 % | 71 | 14982 |
| ventes | numeric | 0 | 0 % | 72 | 309720 |

## Fidélisation de clients fictifs

Données transversales simulées de 650 clients avec cible de départ à 90 jours.

[Télécharger fidelisation_clients_quebec.csv](../modules/semaine-10-classification-modeles-avances/data/fidelisation_clients_quebec.csv)

### En bref

| information | valeur |
|:---|:---|
| Module | Module 10 - Classification |
| Observations | 650 |
| Variables | 9 |
| Valeurs manquantes | 0 |
| Utilisation dans le cours | Ajuster une régression logistique, comparer des seuils et relier les erreurs aux coûts. |

### Aperçu interactif

### Variables

| variable | type | valeurs_manquantes | proportion_manquante | valeurs_distinctes | exemple |
|:---|:---|---:|:---|---:|:---|
| client_id | character | 0 | 0 % | 650 | CL0001 |
| anciennete_mois | numeric | 0 | 0 % | 82 | 39 |
| utilisation_mensuelle | numeric | 0 | 0 % | 200 | 16.8 |
| tickets_service_6m | numeric | 0 | 0 % | 7 | 0 |
| satisfaction | numeric | 0 | 0 % | 65 | 7.7 |
| type_contrat | character | 0 | 0 % | 2 | annuel |
| rabais_actuel | character | 0 | 0 % | 3 | fidélité |
| valeur_mensuelle | numeric | 0 | 0 % | 631 | 79.6 |
| depart_90j | numeric | 0 | 0 % | 2 | 0 |

## Cas intégrateur de succursales fictives

Données mensuelles simulées pour quatre succursales avec réponses continue et binaire.

[Télécharger cas_integrateur_quebec.csv](../modules/atelier-04-recapitulation/data/cas_integrateur_quebec.csv)

### En bref

| information | valeur |
|:---|:---|
| Module | Atelier 04 - Intégration |
| Observations | 288 |
| Variables | 12 |
| Valeurs manquantes | 0 |
| Utilisation dans le cours | Choisir une voie de régression-prévision ou de classification et produire une recommandation validée. |

### Aperçu interactif

### Variables

| variable | type | valeurs_manquantes | proportion_manquante | valeurs_distinctes | exemple |
|:---|:---|---:|:---|---:|:---|
| date | Date | 0 | 0 % | 72 | 2020-01-01 |
| succursale | character | 0 | 0 % | 4 | Gatineau |
| indice_temps | numeric | 0 | 0 % | 72 | 1 |
| promotion | character | 0 | 0 % | 2 | non |
| capacite | numeric | 0 | 0 % | 4 | 2100 |
| achalandage | numeric | 0 | 0 % | 267 | 1521 |
| ruptures_stock | numeric | 0 | 0 % | 7 | 3 |
| temps_attente | numeric | 0 | 0 % | 44 | 3.2 |
| satisfaction | numeric | 0 | 0 % | 31 | 7.3 |
| taux_utilisation | numeric | 0 | 0 % | 276 | 0.724285714285714 |
| ventes | numeric | 0 | 0 % | 286 | 154567 |
| service_insuffisant_mois_suivant | numeric | 0 | 0 % | 2 | 0 |
