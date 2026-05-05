# Anciens documents

Ce dossier documente les sources anciennes du cours. Les archives originales sont conservées localement dans `sources_privees/archives_zip/`.

Le dossier `sources_privees/` est ignoré par Git afin d'éviter la publication d'archives privées ou nominatives. Les ZIP d'examen semblent contenir des fichiers remis par des étudiant·es. Ils ne doivent pas être publiés sur GitHub Pages ni dans un dépôt public.

## Inventaire des archives

| Archive | Type de contenu présumé |
|---|---|
| `MQT-2101-A25_Atelier en classe 1 .zip` | Atelier R et données d'exercices |
| `MQT-2101-A25_Atelier en classe 2.zip` | Atelier régression et données d'exercices |
| `MQT-2101-A25_Atelier en classe 3.zip` | Atelier séries chronologiques |
| `MQT-2101-A25_Atelier en classe 4.zip` | Atelier récapitulatif |
| `MQT-2101-A25_Examen final à la maison.zip` | Archives privées d'examen |
| `MQT-2101-A25_Examen intra à la maison.zip` | Archives privées d'examen |
| `MQT-2101-A25_Préparation à l'examen.zip` | Préparation à l'examen |
| `MQT-2101-A25_Solutionnaires séances.zip` | Solutionnaires anciens |
| `MQT-2101-A25_Séance 02 _  Introduction.zip` | Présentations et données |
| `MQT-2101-A25_Séance 03 _ Régression.zip` | Régression |
| `MQT-2101-A25_Séance 04_ Régression non.zip` | Régression non linéaire |
| `MQT-2101-A25_Séance 05 _ Préparation à.zip` | Préparation intra |
| `MQT-2101-A25_Séance 06 _  La prévision.zip` | Introduction à la prévision |
| `MQT-2101-A25_Séance 07 _ Méthodes de.zip` | Méthodes de lissage |
| `MQT-2101-A25_Séance 08 _  Modèles.zip` | Tendance et saisonnalité |
| `MQT-2101-A25_Séance 09 _ Modèles basés.zip` | Variables externes et autocorrélation |
| `MQT-2101-A25_Séance 10 _ Prévision des.zip` | Résultats binaires et modèles avancés |
| `MQT-2101-A25_Séance 11 _.zip` | Récapitulation ancienne |
| `MQT-2101_A25_86582.pdf` | Ancien plan de cours |

## Extraction locale

Pour extraire les archives sans écraser les fichiers existants :

```r
source("scripts/02_extract_old_material.R")
```

Les fichiers extraits seront placés dans `sources_privees/extraits/`. Les archives d'examen sont ignorées par défaut parce qu'elles peuvent contenir des fichiers nominatifs.

## Inventaire et correspondance

L'inventaire agrégé est dans `inventaire_archives.csv`.

La correspondance entre l'ancien matériel et la nouvelle structure du cours est dans `correspondance_ancienne_nouvelle_structure.md`.

## Règles d'intégration

- Ne pas copier le contenu ancien tel quel dans le nouveau site.
- Ne pas publier de fichiers nominatifs.
- Utiliser les anciennes ressources comme référence de structure et de thèmes.
- Réécrire progressivement les activités dans une forme plus appliquée, orientée administration et décision d'affaires.
