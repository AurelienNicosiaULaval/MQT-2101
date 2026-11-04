# Données du laboratoire 03

Deux jeux entièrement simulés pour MQT-2101, sans données personnelles ni entreprise réelle. Ils peuvent être redistribués avec le cours. Les lignes successives sont liées dans le temps.

## Demande hebdomadaire

104 lignes de janvier 2024 à décembre 2025, lundi de début de semaine. La demande est connue après la fin de sa semaine. Pas de date dupliquée ni de valeur manquante dans le fichier distribué.

| Variable | Définition |
| --- | --- |
| semaine | Date du lundi qui commence la semaine |
| numero_semaine | Numéro ISO, distinct du rang temporel |
| promotion | Promotion simulée, oui ou non |
| prix_moyen | Prix moyen simulé, dollars canadiens par unité |
| demande | Demande totale simulée pendant la semaine, unités de produit |

Apprentissage: 91 semaines, dernière débutant le 22 septembre 2025. Origine: fin de cette semaine, le 28 septembre. Validation: 13 semaines du 29 septembre au 22 décembre 2025, repérées par leur lundi; la dernière se termine le 28 décembre. Les prix et promotions futurs ne sont pas utilisés comme prédicteurs. Période déjà examinée aux modules 06 et 07, donc sans nouveau test final indépendant. Le cycle de 52 semaines vaut 364 jours et approxime imparfaitement le calendrier civil.

## Ventes mensuelles

72 lignes de janvier 2020 à décembre 2025. Une ligne est un mois. Ce jeu est celui du module 08; les observations de 2025 sont de nouveau une validation connue.

| Variable | Définition |
| --- | --- |
| date | Premier jour du mois |
| annee, mois, mois_label, trimestre | Repères calendaires |
| indice_temps | Rang mensuel continu de 1 à 72 |
| ventes | Total mensuel simulé en dollars canadiens |
| budget_cible | Objectif budgétaire fictif en dollars, sans statut de prévision vérifiée |

Le budget est comparé rétrospectivement aux ventes comme objectif; on ne suppose pas qu’il était disponible à l’origine. Les scénarios de coûts sont fictifs, sans tarif observé. Le fichier ne contient pas de valeurs manquantes dans la version distribuée.

## Régénération

Les deux fichiers proviennent de scripts/10_create_second_block_data.R, graine 210110. Le script R/regenerer-donnees.R reprend les tirages intermédiaires et réécrit les deux CSV dans data/ du projet courant. Il est vérifié sur une copie hors du dépôt et ne modifie pas les modules du cours.


## Livraisons mensuelles fictives

| Variable | Description |
| --- | --- |
| `date` | Premier jour du mois, de janvier 2020 à décembre 2025 |
| `livraisons` | Nombre simulé de livraisons durant ce mois |

Une ligne par mois, sans donnée manquante. Les observations consécutives forment une série temporelle. Simulation reproductible : `R/generer-livraisons.R`, graine 210103. L’organisation est fictive.
