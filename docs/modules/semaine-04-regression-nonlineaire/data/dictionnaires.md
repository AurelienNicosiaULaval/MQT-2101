# Dictionnaires du module 4

Les deux fichiers sont simulés pour l’enseignement. Aucune ligne ne représente un client individuel. Les villes identifient des succursales fictives, pas des organismes réels. Les fichiers utilisent une virgule comme séparateur et un point décimal.

## Parcours guidé : achalandage_saturation_quebec.csv

72 lignes, 16 colonnes, six succursales, janvier à décembre 2025. Source : `scripts/09_create_module04_data.R` (graine 210104). Apprentissage : janvier-septembre, 54 lignes. Validation : octobre-décembre, 18 lignes.

| Variable | Sens et unité |
|---|---|
| mois | Date du premier jour du mois (AAAA-MM-JJ) |
| mois_label | Nom français du mois |
| saison | Catégorie simulée : régulière, moyenne ou haute |
| succursale | Ville de la succursale fictive |
| region | Région administrative |
| surface_m2 | Superficie en mètres carrés |
| capacite_reference | Nombre de visites mensuelles de référence |
| campagne_locale | Campagne présente : oui ou non |
| depenses_marketing | Dépenses mensuelles, dollars canadiens |
| achalandage | Nombre de visites mensuelles |
| taux_occupation | Achalandage / capacité de référence, arrondi à trois décimales; peut dépasser 1 |
| ruptures_stock | Nombre simulé de ruptures de stock du mois |
| temps_attente_minutes | Temps d’attente moyen mensuel, minutes |
| panier_moyen | Ventes / achalandage, dollars par visite, arrondi à deux décimales |
| satisfaction | Score moyen simulé sur 10 |
| ventes | Ventes mensuelles, dollars canadiens |

La variable créée dans le code `achalandage_milliers` vaut `achalandage / 1000`. Les colonnes utilisées pour ajuster les modèles sont complètes. L’apprentissage couvre 1 151 à 3 833 visites; deux observations de validation dépassent ce maximum. Ne pas confondre association entre succursales et effet d’une hausse de visites dans une succursale donnée.

## Exercices : cas_integrateur_quebec.csv

Fichier partagé avec l’atelier 4, conservé à son emplacement d’origine. 288 lignes, 12 colonnes, quatre succursales, janvier 2020 à décembre 2025. Source : `scripts/10_create_second_block_data.R`. Apprentissage : 2020-2024, 240 lignes; validation : 2025, 48 lignes.

| Variable | Sens et unité |
|---|---|
| date | Date du premier jour du mois (AAAA-MM-JJ) |
| succursale | Ville de la succursale fictive |
| indice_temps | Rang du mois dans la série, de 1 à 72 |
| promotion | Promotion présente : oui ou non |
| capacite | Nombre de visites mensuelles de référence |
| achalandage | Nombre de visites mensuelles |
| ruptures_stock | Nombre simulé de ruptures de stock |
| temps_attente | Attente moyenne mensuelle, minutes; réponse des exercices |
| satisfaction | Score moyen simulé sur 10 |
| taux_utilisation | Achalandage / capacité; rapport sans unité, explicative des exercices |
| ventes | Ventes mensuelles, dollars canadiens; non utilisées dans ces exercices |
| service_insuffisant_mois_suivant | Cible binaire du mois suivant réservée à la classification de l’atelier 4; ne pas l’utiliser pour prédire une réponse du mois courant |

Les variables nécessaires aux exercices sont complètes. Un taux de 0,90 correspond à 90 %. Une hausse de 10 points de pourcentage correspond à 0,10 unité du taux. L’apprentissage couvre environ 68,8 % à 111,7 %. Les mêmes succursales reviennent dans les deux périodes; la validation n’évalue pas la généralisation à de nouvelles succursales.
