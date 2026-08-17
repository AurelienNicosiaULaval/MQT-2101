# MQT-2101 : Analyse et modélisation des données

Ce dépôt contient le site Quarto complet du cours MQT-2101. Le cours est orienté vers l'analyse appliquée des données, la modélisation, la prévision et la prise de décision en administration.

Ce README est une documentation interne de développement. Les commandes Git et GitHub Pages ci-dessous servent à l'enseignant pour maintenir et publier le site. Elles ne font pas partie des consignes destinées aux étudiantes et étudiants.

## Objectif du dépôt

Préparer une structure claire et maintenable pour développer progressivement :

- les notes de cours;
- les capsules;
- les exercices;
- les ateliers;
- les évaluations;
- les jeux de données;
- les ressources R et Quarto.

## Structure du projet

```text
.
├── _quarto.yml
├── index.qmd
├── plan-de-cours.qmd
├── calendrier.qmd
├── installation.qmd
├── modules/
├── evaluations/
├── ressources/
├── donnees/
├── scripts/
├── R/
├── assets/
├── anciens_documents/
└── docs/
```

Le dossier `docs/` reçoit le site rendu par Quarto. Cette configuration est compatible avec une publication GitHub Pages depuis le dossier `docs/`, selon la documentation officielle de Quarto : https://quarto.org/docs/publishing/github-pages.html.

## Installation des packages R

Lancer :

```r
source("scripts/00_install_packages.R")
```

Le script vérifie et installe les packages nécessaires au cours.

## Prévisualiser le site localement

Dans un terminal placé à la racine du projet :

```bash
quarto preview
```

La commande `quarto preview` lance un serveur local de développement. Voir la documentation officielle de Quarto sur les sites web : https://quarto.org/docs/websites/.

## Rendre le site

Deux options sont disponibles :

```bash
quarto render
```

ou :

```r
source("scripts/99_render_site.R")
```

Les fichiers HTML seront créés dans `docs/`.

## Valider avant une publication

Exécuter les trois contrôles depuis la racine du projet :

```bash
Rscript scripts/12_validate_module_coherence.R
Rscript scripts/13_validate_data_assets.R
Rscript scripts/14_validate_site_output.R
```

Ils vérifient la structure pédagogique, les jeux de données, les fichiers
générés, les références locales et l'absence de solutions publiées. Le même
contrôle est exécuté automatiquement par GitHub Actions à chaque demande de
fusion et à chaque mise à jour de la branche principale.

## Publier avec GitHub Pages

Procédure recommandée :

1. Créer un dépôt GitHub privé ou public selon le contenu à publier.
2. Utiliser une URL SSH, par exemple `git@github.com:organisation/MQT-2101.git`.
3. Pousser le dépôt vers GitHub.
4. Dans les paramètres GitHub Pages, choisir la branche principale et le dossier `docs/`.
5. Vérifier que le dossier `anciens_documents/sources_privees/` demeure ignoré par Git.

Ne jamais publier d'archives contenant des fichiers nominatifs ou confidentiels.

## Ajouter une nouvelle semaine

1. Créer un dossier dans `modules/`, par exemple `modules/semaine-11-nouveau-theme/`.
2. Ajouter au minimum `index.qmd`, `capsules.qmd`, `exercices.qmd`, `solutions.qmd` et `data/`.
3. Reprendre le gabarit pédagogique utilisé dans les semaines existantes.
4. Ajouter la page principale dans la navigation de `_quarto.yml`.
5. Rendre le site avec `quarto render`.

## Intégrer les anciens documents

Les anciens documents sont conservés localement dans `anciens_documents/sources_privees/archives_zip/`. Ce dossier est ignoré par Git.

Pour extraire les archives localement :

```r
source("scripts/02_extract_old_material.R")
```

L'extraction se fait dans `anciens_documents/sources_privees/extraits/` sans écraser les fichiers existants. Les archives d'examen sont ignorées par défaut parce qu'elles peuvent contenir des fichiers nominatifs.

Pour créer l'inventaire agrégé :

```r
source("scripts/03_inventory_old_material.R")
```

La correspondance entre l'ancien matériel et la nouvelle structure est documentée dans `migration-ancien-materiel.qmd` et `anciens_documents/correspondance_ancienne_nouvelle_structure.md`.

## État de préparation

- Les dix modules et les quatre laboratoires sont rédigés.
- Les deux mini-rapports, les deux examens et les questionnaires formatifs sont documentés.
- Les jeux de données publics ou simulés sont intégrés au site.
- Les supports écrits des capsules sont utilisables de façon autonome.
- Une foire aux questions de démarrage est publiée dans les ressources.
- Les données et le rendu du site sont couverts par des validations automatiques.
- Les prochaines capsules vidéo seront ajoutées sans modifier le parcours écrit.
- Les dates, heures et locaux d'examen non publiés institutionnellement demeurent indiqués comme étant à confirmer.
