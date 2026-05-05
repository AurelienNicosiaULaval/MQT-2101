# Données de la semaine 01

Ce dossier contient les jeux de données publics utilisés pour reconstruire la séance 01.

## Fichiers publiés

- `birth_us.csv` : observations quotidiennes de naissances aux États-Unis, utilisées pour revoir les variables, les observations, les mesures descriptives et la préparation d'un tableau.
- `safety_airlines.csv` : données descriptives sur des compagnies aériennes, utilisées pour discuter des indicateurs, des échelles de comparaison et de la lecture prudente d'un tableau.
- `diagnostic_succursales.csv` : jeu de données simulé créé pendant la première ébauche du module. Il est conservé pour traçabilité, mais le parcours principal utilise `birth_us.csv` et `safety_airlines.csv`.

## Origine

`birth_us.csv` et `safety_airlines.csv` ont été convertis depuis les fichiers Excel non nominatifs trouvés dans l'archive locale `MQT-2101-A25_Solutionnaires séances.zip`.

Les fichiers Excel d'origine ne sont pas publiés.

## Reproduction

Les fichiers peuvent être recréés avec :

```r
source("scripts/06_prepare_weeks_01_02_data.R")
```
