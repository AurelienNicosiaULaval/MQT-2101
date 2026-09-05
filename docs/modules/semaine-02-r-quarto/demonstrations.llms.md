# Démonstrations R - Semaine 02

## Objectif

Cette page est une démonstration complète et autoportante. Elle montre comment passer d’un fichier CSV à une première exploration descriptive reproductible dans R et Quarto.

Question centrale :

> Comment transformer un tableau de ventes mensuelles en premiers constats descriptifs vérifiables?

Le but n’est pas de tout interpréter. Le but est de suivre une démarche fiable :

1.  importer le tableau;
2.  comprendre ce que représente une ligne;
3.  préparer les variables;
4.  repérer les valeurs manquantes;
5.  produire un tableau descriptif;
6.  créer un graphique;
7.  écrire des constats prudents.

## Données utilisées

Fichier : [ventes_operations_quebec.csv](../../donnees/#ventes-et-opérations-de-succursales-québécoises).

Ce fichier contient des observations mensuelles pour des succursales fictives au Québec. Chaque ligne correspond à une succursale observée pendant un mois. Les variables décrivent les ventes, les clients, la région, le canal principal, la satisfaction et certains aspects opérationnels.

## Préparation

Créez le projet avec File \> New Project. Placez le CSV dans `data/` et votre fichier `rapport_semaine_02.qmd` à la racine du projet. Conservez les blocs ci-dessous dans leur ordre d’apparition.

Le bloc suivant charge les packages et importe les données. Il est placé au début de la démonstration parce que tous les blocs suivants en dépendent.

``` r
library(tidyverse)
library(janitor)
library(lubridate)
library(scales)

data_path <- "data/ventes_operations_quebec.csv"

ventes_operations <- readr::read_csv(data_path, show_col_types = FALSE) |>
  clean_names()

currency_ca <- scales::label_dollar(
  prefix = "",
  suffix = " $",
  big.mark = " ",
  decimal.mark = ","
)
```

À lire dans ce bloc :

- `read_csv()` lit le fichier CSV;
- `clean_names()` standardise les noms de variables;
- `currency_ca` servira plus tard à afficher les montants en dollars canadiens.

## Démonstration 1 - Inspecter le tableau

Avant de calculer, il faut comprendre la structure du tableau.

``` r
glimpse(ventes_operations)
```

    Rows: 24
    Columns: 12
    $ mois                  <date> 2025-01-01, 2025-01-01, 2025-01-01, 2025-01-01,…
    $ mois_nom              <chr> "janvier", "janvier", "janvier", "janvier", "fév…
    $ succursale            <chr> "Montréal", "Québec", "Sherbrooke", "Trois-Riviè…
    $ region                <chr> "Montréal", "Capitale-Nationale", "Estrie", "Mau…
    $ surface_m2            <dbl> 540, 420, 360, 335, 540, 420, 360, 335, 540, 420…
    $ campagne_locale       <chr> "non", "oui", "non", "non", "non", "non", "oui",…
    $ canal_principal       <chr> "magasin", "magasin", "web", "web", "web", "maga…
    $ clients               <dbl> 2254, 1858, 1506, 1199, 2162, 1682, 1585, 1458, …
    $ panier_moyen          <dbl> 53.11, 59.40, 63.31, 68.21, 66.53, 55.20, 58.44,…
    $ ventes                <dbl> 119710, 110365, 95345, 81784, 143838, 92846, 926…
    $ delai_livraison_jours <dbl> 2.2, 3.8, 4.5, 3.5, 3.6, 1.8, 3.5, 2.6, NA, 3.9,…
    $ satisfaction          <dbl> 8.3, 8.6, 7.3, 8.1, NA, 7.9, 7.8, 8.0, 7.7, 7.9,…

Comment lire la sortie :

- `Rows` donne le nombre de lignes;
- `Columns` donne le nombre de variables;
- le type de chaque variable apparaît à côté de son nom;
- les premières valeurs aident à repérer le sens de la variable.

Dans ce fichier, une ligne correspond à une succursale pour un mois donné. Ce n’est pas une ligne par client ni une ligne par vente individuelle.

À retenir pour la trace finale :

- nommer l’unité d’observation;
- indiquer le nombre de lignes et de colonnes;
- classer quelques variables importantes selon leur type.

## Démonstration 2 - Préparer les variables

Vérifiez les types avant les résumés et les graphiques. Ici, `read_csv()` reconnaît déjà `mois` comme une date; `ymd()` conserve ce type. La conversion en facteurs rend explicite le rôle des catégories. Par exemple, `mois` doit être traité comme une date, tandis que `succursale`, `region`, `campagne_locale` et `canal_principal` sont des catégories.

``` r
ventes_preparees <- ventes_operations |>
  mutate(
    mois = ymd(mois),
    succursale = factor(succursale),
    region = factor(region),
    campagne_locale = factor(campagne_locale),
    canal_principal = factor(canal_principal)
  )

ventes_preparees |>
  summarise(
    nb_lignes = n(),
    nb_succursales = n_distinct(succursale),
    nb_regions = n_distinct(region),
    nb_canaux = n_distinct(canal_principal),
    mois_min = min(mois, na.rm = TRUE),
    mois_max = max(mois, na.rm = TRUE)
  ) |>
  knitr::kable()
```

| nb_lignes | nb_succursales | nb_regions | nb_canaux | mois_min   | mois_max   |
|----------:|---------------:|-----------:|----------:|:-----------|:-----------|
|        24 |              4 |          4 |         3 | 2025-01-01 | 2025-06-01 |

Comment lire la sortie :

- `nb_lignes` confirme la taille du tableau;
- `nb_succursales`, `nb_regions` et `nb_canaux` indiquent combien de groupes peuvent être comparés;
- `mois_min` et `mois_max` indiquent la période couverte.

À retenir pour la trace finale :

- expliquer pourquoi certaines variables sont catégorielles;
- indiquer la période couverte par les données;
- garder les transformations dans le code, plutôt que de modifier le CSV à la main.

## Démonstration 3 - Vérifier les valeurs manquantes

Une valeur manquante peut influencer un total, une moyenne ou un graphique. Elle doit donc être repérée et signalée avant l’interprétation.

``` r
diagnostic_manquants <- ventes_preparees |>
  summarise(across(everything(), \(x) sum(is.na(x)))) |>
  pivot_longer(
    cols = everything(),
    names_to = "variable",
    values_to = "valeurs_manquantes"
  ) |>
  filter(valeurs_manquantes > 0)

diagnostic_manquants |>
  knitr::kable()
```

| variable              | valeurs_manquantes |
|:----------------------|-------------------:|
| delai_livraison_jours |                  1 |
| satisfaction          |                  2 |

Comment lire la sortie :

- une ligne apparaît seulement pour les variables qui ont au moins une valeur manquante;
- `valeurs_manquantes` indique combien de valeurs sont absentes pour chaque variable;
- si le tableau était vide, cela voudrait dire qu’aucune valeur manquante n’a été détectée.

> **IMPORTANT:**
>
> Une valeur manquante n’est pas automatiquement une erreur à supprimer. Il faut d’abord comprendre où elle apparaît et comment elle peut influencer le résultat.

À écrire dans la trace finale :

- les variables touchées;
- le nombre de valeurs manquantes;
- une précaution d’interprétation.

## Démonstration 4 - Résumer un tableau

Un tableau descriptif sert à transformer plusieurs lignes en quelques indicateurs lisibles. Ici, on résume les ventes par succursale.

``` r
resume_succursales <- ventes_preparees |>
  group_by(succursale, region) |>
  summarise(
    ventes_totales = sum(ventes),
    clients_totaux = sum(clients),
    panier_moyen = ventes_totales / clients_totaux,
    nb_mois_satisfaction = sum(!is.na(satisfaction)),
    satisfaction_moyenne = mean(satisfaction, na.rm = TRUE),
    .groups = "drop"
  ) |>
  arrange(desc(ventes_totales))

resume_succursales |>
  transmute(
    Succursale = succursale,
    `Ventes ($ CA)` = currency_ca(ventes_totales),
    `Panier ($ CA)` = currency_ca(panier_moyen),
    `Mois utilisés` = nb_mois_satisfaction,
    `Satisfaction (/10)` = format(
      round(satisfaction_moyenne, 2), decimal.mark = ",", nsmall = 2
    )
  ) |>
  knitr::kable()
```

| Succursale | Ventes (\$ CA) | Panier (\$ CA) | Mois utilisés | Satisfaction (/10) |
|:---|:---|:---|---:|:---|
| Montréal | 831 777 \$ | 59,17 \$ | 5 | 8,08 |
| Québec | 677 971 \$ | 59,14 \$ | 5 | 8,06 |
| Sherbrooke | 589 922 \$ | 61,68 \$ | 6 | 7,88 |
| Trois-Rivières | 515 975 \$ | 60,07 \$ | 6 | 8,18 |

Comment lire la sortie :

- `ventes_totales` compare le volume de ventes total observé;
- `clients_totaux`, conservé dans l’objet R, additionne les nombres mensuels de clients; il ne compte pas nécessairement des personnes distinctes sur six mois;
- `panier_moyen` est le rapport des ventes totales au total de clients;
- `satisfaction_moyenne` est la moyenne des scores mensuels disponibles, sans pondération par le nombre de clients;
- `nb_mois_satisfaction` compte les mois utilisés pour cette moyenne; le tableau l’affiche sous « Mois utilisés »;
- le tri permet de repérer rapidement les succursales avec le plus de ventes.

Prudence :

- une succursale peut avoir plus de ventes parce qu’elle a plus de clients;
- la satisfaction repose sur 5 mois à Montréal et à Québec, contre 6 à Sherbrooke et à Trois-Rivières;
- les ventes et les nombres de clients sont complets ici; `na.rm = TRUE` est utilisé seulement pour la satisfaction;
- ce tableau décrit des écarts, il ne les explique pas.

## Démonstration 5 - Créer un graphique

Un graphique ne remplace pas le tableau. Il aide à voir plus rapidement une comparaison.

``` r
resume_succursales |>
  mutate(succursale = fct_reorder(succursale, ventes_totales)) |>
  ggplot(aes(ventes_totales, succursale)) +
  geom_col(fill = "#0B4F6C") +
  scale_x_continuous(labels = currency_ca) +
  labs(
    title = "Ventes totales par succursale",
    x = "Ventes totales ($ CA)",
    y = NULL
  ) +
  theme_minimal(base_size = 12)
```

![](demonstrations_files/figure-html/graphique-semaine-02-1.png)

Comment lire le graphique :

- chaque barre représente une succursale;
- la longueur de la barre représente les ventes totales;
- les succursales sont ordonnées pour faciliter la comparaison;
- le titre et l’axe horizontal indiquent ce qui est mesuré.

Constat descriptif possible :

> De janvier à juin 2025, Montréal totalise 831 777 \$ CA de ventes, contre 515 975 \$ CA pour Trois-Rivières. Ces montants décrivent les données simulées du module.

Ce constat est descriptif. Il ne dit pas pourquoi ces différences existent.

## Synthèse pour la trace finale

Le rapport guidé doit montrer que l’analyse peut être reprise. Les exercices vous demandent ensuite d’appliquer ces gestes à un autre fichier. Elle devrait donc contenir :

- le code d’importation;
- une description de l’unité d’observation;
- un diagnostic des valeurs manquantes;
- un tableau descriptif;
- un graphique;
- deux constats descriptifs;
- une question à approfondir.

Avant de considérer la trace terminée, vérifiez que le fichier Quarto se rend sans erreur et que chaque résultat important est produit par du code présent dans le document.
