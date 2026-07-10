# Données de la semaine 01

Ce dossier contient les jeux de données publics utilisés pour reconstruire la séance 01.

## Fichiers publiés

- `birth_us.csv` : observations quotidiennes de naissances aux États-Unis, utilisées pour revoir les variables, les observations, les mesures descriptives et la préparation d'un tableau.
- `safety_airlines.csv` : données descriptives sur des compagnies aériennes, utilisées pour discuter des indicateurs, des échelles de comparaison et de la lecture prudente d'un tableau.

Le fichier `diagnostic_succursales.csv`, créé pendant une première ébauche du module, n'est plus publié avec la semaine 01. Il est archivé dans `anciens_documents/traces_creation/semaine-01/` pour conserver la trace du travail sans l'inclure dans le site étudiant.

## Origine

Les copies de travail proviennent de l'archive locale `MQT-2101-A25_Séance 01 _  Introduction.zip`. Leur provenance publique a été rétablie :

- `birth_us.csv` correspond à `US_births_1994-2003_CDC_NCHS.csv` du dossier [FiveThirtyEight U.S. Births](https://github.com/fivethirtyeight/data/tree/master/births). Les données d'origine sont attribuées au CDC/National Center for Health Statistics.
- `safety_airlines.csv` correspond au dossier [FiveThirtyEight Airline Safety](https://github.com/fivethirtyeight/data/tree/master/airline-safety). La source d'origine indiquée est l'Aviation Safety Network.

Le dépôt `fivethirtyeight/data` distribue ces fichiers sous licence CC BY 4.0. Les pages du cours doivent conserver l'attribution à FiveThirtyEight et aux sources d'origine.

Les fichiers PDF, PowerPoint et lectures d'origine ne sont pas publiés avec le site.

## Reproduction

Les fichiers peuvent être recréés avec :

```r
source("scripts/06_prepare_weeks_01_02_data.R")
```
