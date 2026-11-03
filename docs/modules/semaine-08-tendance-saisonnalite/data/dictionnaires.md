# Données du module 08

Deux séries fictives d’une organisation québécoise, entièrement simulées pour l’enseignement. Aucun enregistrement réel, aucune donnée personnelle. Chaque fichier contient 72 mois de janvier 2020 à décembre 2025, sans valeur manquante. Une ligne représente un mois; les dates sont triées, distinctes et mensuelles. Les observations successives sont dépendantes dans les scénarios temporels, sans hypothèse de lignes indépendantes.

## Ventes saisonnières, cas guidé

| Variable | Définition et unité |
| --- | --- |
| date | Mois entier encodé par son premier jour |
| annee | Année civile |
| mois | Numéro de mois, 1 à 12 dans le CSV |
| mois_label | Nom français du mois |
| trimestre | Trimestre, T1 à T4 |
| indice_temps | Rang mensuel continu, 1 à 72 |
| ventes | Total mensuel simulé, dollars canadiens |
| budget_cible | Objectif budgétaire fictif, dollars canadiens; il n’est pas utilisé comme prédicteur |

La simulation contient une hausse globale et un motif mensuel. Elle ne démontre aucune cause dans une organisation réelle. Le budget est une cible pédagogique, sans statut de prévision vérifiée.

## Ventes et promotions, transfert

| Variable | Définition et unité |
| --- | --- |
| date, annee, mois, mois_label | Calendrier mensuel, mêmes conventions que ci-dessus |
| tendance | Rang temporel, 1 à 72 |
| promotion | Indicateur fictif, non ou oui |
| prix_moyen | Prix moyen simulé, dollars canadiens par unité |
| indice_confiance | Indice fictif en points arbitraires |
| budget_marketing | Budget marketing mensuel simulé, dollars canadiens |
| ventes | Total mensuel simulé, dollars canadiens |

Les prix, promotions et indicateurs observés dans les mois futurs ne sont pas réputés connus à l’origine. Les modèles principaux utilisent seulement l’indice et le mois. Le complément avec contexte réalisé est explicitement conditionnel à ce contexte; les scénarios doivent être déclarés séparément. Le générateur impose aussi une erreur AR(1), sans que l’échantillon permette d’en connaître automatiquement le paramètre.

## Protocole et reproduction

Apprentissage: janvier 2020 à décembre 2024, 60 mois. Validation: douze mois de 2025, prévus à l’origine de fin décembre 2024. Les indices futurs sont 61 à 72. Le bloc sert au choix; il n’est pas un test final indépendant. Les données commerciales sont reprises sans modification du module 09, sans utiliser leurs prédicteurs futurs dans le parcours principal.

Les fichiers proviennent du script 10 du cours, graine 210110. `R/regenerer-donnees.R` reproduit les deux CSV dans le dossier data/ du projet téléchargé, en conservant les tirages intermédiaires du script d’origine. Les données simulées peuvent être redistribuées avec le matériel du cours. Les anciens fichiers Amtrak, FRED et Club ne sont pas redistribués.
