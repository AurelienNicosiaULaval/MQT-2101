# Données de l'atelier 03

`demande_hebdomadaire_quebec.csv` contient 104 semaines de demande simulée pour une organisation québécoise fictive. Il s'agit du même scénario que dans le module 07 afin de permettre une analyse plus intégrée en atelier.

Le fichier est généré par `scripts/10_create_second_block_data.R`, ne représente aucune organisation réelle et peut être redistribué avec le matériel du cours.


Le fichier mensuel `ventes_saisonnieres_quebec.csv` provient du module 08 et sert à une pratique facultative distincte. Les unités, dates et limites sont dans `dictionnaires.md`; `R/regenerer-donnees.R` reproduit les deux jeux dans une copie locale du projet.


`livraisons_mensuelles_fictives.csv` est une nouvelle série mensuelle entièrement simulée pour la mission. Une ligne représente un mois et la variable `livraisons` est un nombre de livraisons. Période : janvier 2020 à décembre 2025, 72 mois, aucune valeur manquante. Le script `R/generer-livraisons.R` reproduit le fichier dans une copie de travail à partir de la graine 210103. Les valeurs ne représentent aucune entreprise réelle.
