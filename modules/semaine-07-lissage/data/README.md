# Données du module 07

Deux jeux entièrement simulés, sans mesure réelle ni donnée personnelle, repris sans modification des modules 06 et 07 et du laboratoire 03.

- `demande_hebdomadaire_quebec.csv`: 104 semaines, du 1er janvier 2024 au 22 décembre 2025. Cible: demande en unités de produit. Prix moyen en dollars canadiens par unité; promotion fictive oui/non.
- `consommation_electrique_batiment_quebec.csv`: 72 mois, janvier 2020 à décembre 2025. Cible: énergie mensuelle en kWh. Ne pas confondre avec la puissance en kW ni avec une facture.

Consulter `dictionnaires.md` pour toutes les variables, les dépendances temporelles et les validations déjà connues. Les deux cas sont distincts: comparaison de prévisions de demande puis planification énergétique avec coût asymétrique fictif.

La demande provient de `scripts/10_create_second_block_data.R` (graine 210110, avec les tirages préalables du script). L’électricité provient de `scripts/24_create_module06_electricity.R` (graine 210106). `R/regenerer-donnees.R` fournit une reproduction autonome des deux fichiers, avec les tirages préalables nécessaires pour conserver la demande originale. Exécuter depuis la racine du projet téléchargé. Les données peuvent être redistribuées avec le matériel du cours.
