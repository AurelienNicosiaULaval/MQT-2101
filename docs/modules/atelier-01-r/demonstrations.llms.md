# Démonstrations R - Atelier 01

## Objectif

Cette page montre la démarche complète utilisée dans l’atelier 01. Elle ne sert pas seulement à copier du code : elle explique ce que chaque bloc fait, ce qu’il faut observer dans la sortie et ce qui peut être repris dans la trace finale.

Le parcours principal reste le [guide complet de l’atelier](guide-atelier.llms.md). Cette page sert d’appui pendant ou après la séance, surtout lorsqu’il faut revoir une démonstration précise.

> **NOTE:**
>
> Lisez d’abord l’objectif de la démonstration, puis exécutez le bloc de code dans votre propre fichier Quarto. Après la sortie, vérifiez les éléments à observer et gardez seulement les résultats utiles pour votre trace finale.

## Vue d’ensemble

| Démonstration | Question traitée | Résultat attendu |
|----|----|----|
| 1 | Les données sont-elles importées correctement? | Tableau lisible dans R |
| 2 | Que représente chaque variable importante? | Dictionnaire rapide |
| 3 | Quelles variables sont incomplètes? | Diagnostic des valeurs manquantes |
| 4 | Pourquoi `na.rm = TRUE` peut-il changer certains calculs? | Comparaison avec et sans valeurs manquantes |
| 5 | Comment comparer les succursales? | Tableau synthèse |
| 6 | Comment visualiser les ventes? | Graphique de comparaison |
| 7 | Comment explorer une relation descriptive? | Nuage de points interprétable |
| 8 | Quelle priorité recommander pour la suite? | Résultat descriptif appuyant une priorité |

## Préparation

Avant de commencer, chargez les packages nécessaires et définissez deux objets qui seront réutilisés dans les démonstrations.

``` r
library(tidyverse)
library(janitor)
library(scales)

data_path <- if (file.exists("data/ventes_pme_quebec.csv")) {
  "data/ventes_pme_quebec.csv"
} else {
  "modules/atelier-01-r/data/ventes_pme_quebec.csv"
}

currency_ca <- scales::label_dollar(
  prefix = "",
  suffix = " $",
  big.mark = " ",
  decimal.mark = ","
)
```

À retenir :

- `data_path` permet de retrouver le fichier selon l’endroit où le document est rendu;
- `currency_ca` servira à afficher les montants dans un format lisible;
- les packages sont chargés explicitement pour que le document soit reproductible.

## Démonstration 1 - Importer et inspecter

Objectif : lire le fichier CSV, nettoyer les noms de colonnes et vérifier que les variables importantes ont un type utile pour l’analyse.

``` r
ventes <- readr::read_csv(data_path, show_col_types = FALSE) |>
  clean_names() |>
  mutate(
    mois = as.Date(mois),
    campagne_locale = factor(
      campagne_locale,
      levels = c(0, 1),
      labels = c("non", "oui")
    )
  )

glimpse(ventes)
```

    Rows: 60
    Columns: 15
    $ mois                  <date> 2025-01-01, 2025-01-01, 2025-01-01, 2025-01-01,…
    $ mois_label            <chr> "janvier", "janvier", "janvier", "janvier", "jan…
    $ saison                <chr> "moyenne", "moyenne", "moyenne", "moyenne", "moy…
    $ succursale            <chr> "Gatineau", "Montréal", "Québec", "Sherbrooke", …
    $ region                <chr> "Outaouais", "Montréal", "Capitale-Nationale", "…
    $ surface_m2            <dbl> 410, 520, 460, 390, 360, 410, 520, 460, 390, 360…
    $ campagne_locale       <fct> oui, oui, non, non, oui, non, non, oui, non, non…
    $ depenses_marketing    <dbl> 4799, 5755, 5646, 2367, 7671, 4771, 3070, 5029, …
    $ clients               <dbl> 2188, 2568, 2280, 2013, 1967, 2100, 2468, 2417, …
    $ panier_moyen          <dbl> 59.35, 65.66, 62.41, 59.69, 54.91, 55.02, 64.23,…
    $ ventes                <dbl> 129858, 168615, 142295, 120156, 108008, 115542, …
    $ delai_livraison_jours <dbl> 3.0, 2.5, 2.4, 2.3, 2.1, 3.5, 1.7, 2.4, 2.2, 2.2…
    $ ruptures_stock        <dbl> 6, 3, 1, 3, 1, 1, 0, 2, 1, 1, 1, 0, 1, 2, 0, 1, …
    $ satisfaction          <dbl> 7.6, 7.9, 8.7, 8.5, 7.1, 7.0, 8.5, NA, 7.4, 8.0,…
    $ taux_retour           <dbl> 0.076, 0.043, 0.044, 0.035, 0.037, 0.025, 0.042,…

À observer :

- chaque ligne représente une succursale pour un mois;
- `mois` est une date, ce qui permettra des analyses temporelles plus tard;
- `campagne_locale` est rendue lisible avec les valeurs `non` et `oui`;
- les variables de ventes, clients, satisfaction et opérations sont numériques.

À reprendre dans la trace finale :

> Le tableau contient des observations mensuelles par succursale. Il permet de comparer des indicateurs commerciaux, opérationnels et de satisfaction.

> **WARNING:**
>
> Si R indique que le fichier est introuvable, le problème vient presque toujours du dossier de travail ou du chemin vers le fichier CSV. Vérifiez que le fichier est bien dans le dossier `data` de l’atelier ou utilisez le chemin proposé dans le guide.

## Démonstration 2 - Construire un dictionnaire rapide

Objectif : produire un petit tableau qui décrit les variables. Ce dictionnaire aide à comprendre les données avant de calculer des indicateurs.

``` r
dictionnaire_variables <- tibble(
  variable = names(ventes),
  type = map_chr(ventes, \(x) class(x)[1]),
  valeurs_manquantes = map_int(ventes, \(x) sum(is.na(x))),
  exemple = map_chr(ventes, \(x) {
    valeurs_observees <- x[!is.na(x)]

    if (length(valeurs_observees) == 0) {
      NA_character_
    } else {
      as.character(valeurs_observees[[1]])
    }
  })
)

dictionnaire_variables |>
  knitr::kable()
```

| variable              | type      | valeurs_manquantes | exemple    |
|:----------------------|:----------|-------------------:|:-----------|
| mois                  | Date      |                  0 | 2025-01-01 |
| mois_label            | character |                  0 | janvier    |
| saison                | character |                  0 | moyenne    |
| succursale            | character |                  0 | Gatineau   |
| region                | character |                  0 | Outaouais  |
| surface_m2            | numeric   |                  0 | 410        |
| campagne_locale       | factor    |                  0 | oui        |
| depenses_marketing    | numeric   |                  0 | 4799       |
| clients               | numeric   |                  0 | 2188       |
| panier_moyen          | numeric   |                  0 | 59.35      |
| ventes                | numeric   |                  0 | 129858     |
| delai_livraison_jours | numeric   |                  2 | 3          |
| ruptures_stock        | numeric   |                  0 | 6          |
| satisfaction          | numeric   |                  3 | 7.6        |
| taux_retour           | numeric   |                  0 | 0.076      |

À observer :

- le dictionnaire donne une vue rapide des variables disponibles;
- la colonne `type` indique comment R interprète chaque variable;
- la colonne `valeurs_manquantes` signale les variables à traiter avec prudence;
- la colonne `exemple` aide à comprendre le contenu sans ouvrir tout le tableau.

À reprendre dans la trace finale :

Choisissez cinq variables utiles pour la direction, puis nommez leur rôle : performance commerciale, clientèle, marketing, opérations ou satisfaction.

## Démonstration 3 - Repérer les valeurs manquantes

Objectif : identifier les variables incomplètes avant de calculer des moyennes ou des tableaux synthèses.

``` r
diagnostic_manquants <- ventes |>
  summarise(across(everything(), \(x) sum(is.na(x)))) |>
  pivot_longer(
    cols = everything(),
    names_to = "variable",
    values_to = "valeurs_manquantes"
  ) |>
  filter(valeurs_manquantes > 0) |>
  arrange(desc(valeurs_manquantes))

diagnostic_manquants |>
  knitr::kable()
```

| variable              | valeurs_manquantes |
|:----------------------|-------------------:|
| satisfaction          |                  3 |
| delai_livraison_jours |                  2 |

À observer :

- seules les variables ayant au moins une valeur manquante apparaissent;
- une variable incomplète peut rendre certains résumés impossibles à calculer si on ne précise pas comment traiter les valeurs manquantes;
- ce diagnostic doit être mentionné dans le rapport, même si le problème semble petit.

Phrase possible :

> Certaines variables contiennent des valeurs manquantes. Les indicateurs qui utilisent ces variables doivent donc être calculés et interprétés avec prudence.

## Démonstration 4 - Voir l’effet de `na.rm = TRUE`

Objectif : comprendre pourquoi certaines moyennes deviennent manquantes lorsque les données contiennent des valeurs `NA`.

``` r
comparaison_na_rm <- ventes |>
  summarise(
    satisfaction_sans_na_rm = mean(satisfaction),
    satisfaction_avec_na_rm = mean(satisfaction, na.rm = TRUE),
    delai_sans_na_rm = mean(delai_livraison_jours),
    delai_avec_na_rm = mean(delai_livraison_jours, na.rm = TRUE)
  )

comparaison_na_rm |>
  knitr::kable(digits = 2)
```

| satisfaction_sans_na_rm | satisfaction_avec_na_rm | delai_sans_na_rm | delai_avec_na_rm |
|---:|---:|---:|---:|
| NA | 7.65 | NA | 2.68 |

À observer :

- sans `na.rm = TRUE`, une moyenne peut devenir `NA`;
- avec `na.rm = TRUE`, R calcule la moyenne à partir des valeurs observées;
- ce choix n’efface pas le problème de données manquantes, il permet seulement de calculer un résumé sur les observations disponibles.

> **IMPORTANT:**
>
> Utiliser `na.rm = TRUE` est acceptable ici, mais il faut le signaler. Un résumé calculé sur les valeurs observées n’est pas exactement la même chose qu’un résumé calculé sur toutes les observations prévues.

## Démonstration 5 - Résumer par succursale

Objectif : passer du tableau mensuel à une comparaison lisible des succursales.

``` r
synthese_succursales <- ventes |>
  group_by(succursale, region) |>
  summarise(
    ventes_totales = sum(ventes, na.rm = TRUE),
    clients_totaux = sum(clients, na.rm = TRUE),
    panier_moyen = mean(panier_moyen, na.rm = TRUE),
    satisfaction_moyenne = mean(satisfaction, na.rm = TRUE),
    delai_moyen = mean(delai_livraison_jours, na.rm = TRUE),
    ruptures_stock = sum(ruptures_stock, na.rm = TRUE),
    .groups = "drop"
  ) |>
  arrange(desc(ventes_totales))

synthese_succursales |>
  mutate(
    ventes_totales = currency_ca(ventes_totales),
    panier_moyen = currency_ca(panier_moyen),
    satisfaction_moyenne = round(satisfaction_moyenne, 1),
    delai_moyen = round(delai_moyen, 1)
  ) |>
  knitr::kable()
```

| succursale | region | ventes_totales | clients_totaux | panier_moyen | satisfaction_moyenne | delai_moyen | ruptures_stock |
|:---|:---|:---|---:|:---|---:|---:|---:|
| Montréal | Montréal | 1 923 795 \$ | 31351 | 61,27 \$ | 7.7 | 2.5 | 25 |
| Québec | Capitale-Nationale | 1 740 846 \$ | 27586 | 63,02 \$ | 7.8 | 2.8 | 23 |
| Sherbrooke | Estrie | 1 453 016 \$ | 23858 | 60,82 \$ | 7.6 | 2.7 | 28 |
| Gatineau | Outaouais | 1 442 128 \$ | 24166 | 59,59 \$ | 7.7 | 2.8 | 28 |
| Trois-Rivières | Mauricie | 1 403 919 \$ | 22334 | 62,92 \$ | 7.4 | 2.6 | 29 |

À observer :

- les ventes totales comparent le volume d’affaires;
- le panier moyen compare la valeur moyenne des transactions;
- la satisfaction et les ruptures de stock ajoutent une dimension opérationnelle;
- la succursale avec les ventes les plus élevées n’est pas nécessairement la plus favorable selon tous les indicateurs.

À reprendre dans la trace finale :

Choisissez deux ou trois résultats qui ressortent du tableau. Il n’est pas utile de commenter toutes les colonnes.

## Démonstration 6 - Visualiser les ventes

Objectif : produire un graphique simple qui compare les ventes annuelles par succursale.

``` r
synthese_succursales |>
  mutate(succursale = fct_reorder(succursale, ventes_totales)) |>
  ggplot(aes(ventes_totales, succursale)) +
  geom_col(fill = "#2A9D8F") +
  scale_x_continuous(labels = currency_ca) +
  labs(
    title = "Ventes annuelles par succursale",
    x = "Ventes",
    y = NULL
  ) +
  theme_minimal(base_size = 12)
```

![](demonstrations_files/figure-html/demo-graphique-ventes-atelier-01-1.png)

À observer :

- les succursales sont ordonnées selon les ventes totales;
- l’axe horizontal est formaté en dollars;
- le graphique répond à une question précise : quelles succursales contribuent le plus aux ventes annuelles?

Phrase possible :

> Le graphique montre que les ventes annuelles varient entre les succursales. Cette comparaison décrit le volume d’affaires, mais ne suffit pas à expliquer les causes des écarts.

## Démonstration 7 - Explorer une relation descriptive

Objectif : examiner si deux variables semblent évoluer ensemble, sans conclure à une relation causale.

``` r
ventes |>
  ggplot(aes(ruptures_stock, satisfaction, color = succursale)) +
  geom_point(size = 2.4, alpha = 0.8) +
  geom_smooth(method = "lm", se = FALSE, color = "#1F2933") +
  labs(
    title = "Satisfaction client et ruptures de stock",
    x = "Nombre de ruptures de stock",
    y = "Satisfaction moyenne sur 10",
    color = "Succursale"
  ) +
  theme_minimal(base_size = 12)
```

![](demonstrations_files/figure-html/demo-relation-ruptures-satisfaction-atelier-01-1.png)

À observer :

- chaque point représente une observation mensuelle pour une succursale;
- la droite aide à voir une tendance descriptive générale;
- les couleurs permettent de repérer les succursales, mais elles ne remplacent pas une analyse plus formelle.

> **CAUTION:**
>
> Ce graphique ne prouve pas que les ruptures de stock causent une baisse de satisfaction. Il suggère seulement une relation descriptive à examiner plus rigoureusement.

## Démonstration 8 - Choisir une priorité de prochaine analyse

Objectif : transformer l’exploration en recommandation prudente. La direction hésite entre trois priorités : marketing, opérations ou saisonnalité. On produit un petit résultat descriptif pour éclairer ce choix.

### Option A - Marketing

``` r
priorite_marketing <- ventes |>
  group_by(campagne_locale) |>
  summarise(
    observations = n(),
    ventes_moyennes = mean(ventes, na.rm = TRUE),
    depenses_marketing_moyennes = mean(depenses_marketing, na.rm = TRUE),
    panier_moyen = mean(panier_moyen, na.rm = TRUE),
    .groups = "drop"
  ) |>
  mutate(
    ventes_moyennes = currency_ca(ventes_moyennes),
    depenses_marketing_moyennes = currency_ca(depenses_marketing_moyennes),
    panier_moyen = currency_ca(panier_moyen)
  )

priorite_marketing |>
  knitr::kable()
```

| campagne_locale | observations | ventes_moyennes | depenses_marketing_moyennes | panier_moyen |
|:---|---:|:---|:---|:---|
| non | 36 | 129 813 \$ | 3 706,06 \$ | 61,70 \$ |
| oui | 24 | 137 102 \$ | 5 230,50 \$ | 61,26 \$ |

Ce résultat aide à formuler une question pour la suite sur les campagnes locales. Il ne démontre pas l’effet du marketing, parce que les mois avec campagne peuvent différer des autres mois pour plusieurs raisons.

### Option B - Opérations

``` r
priorite_operations <- ventes |>
  group_by(succursale) |>
  summarise(
    ruptures_stock = sum(ruptures_stock, na.rm = TRUE),
    delai_moyen = mean(delai_livraison_jours, na.rm = TRUE),
    satisfaction_moyenne = mean(satisfaction, na.rm = TRUE),
    .groups = "drop"
  ) |>
  arrange(desc(ruptures_stock)) |>
  mutate(
    delai_moyen = round(delai_moyen, 1),
    satisfaction_moyenne = round(satisfaction_moyenne, 1)
  )

priorite_operations |>
  knitr::kable()
```

| succursale     | ruptures_stock | delai_moyen | satisfaction_moyenne |
|:---------------|---------------:|------------:|---------------------:|
| Trois-Rivières |             29 |         2.6 |                  7.4 |
| Gatineau       |             28 |         2.8 |                  7.7 |
| Sherbrooke     |             28 |         2.7 |                  7.6 |
| Montréal       |             25 |         2.5 |                  7.7 |
| Québec         |             23 |         2.8 |                  7.8 |

Ce résultat aide à repérer les succursales où les enjeux opérationnels semblent plus présents. Il ne dit pas encore si ces enjeux expliquent les ventes ou la satisfaction.

### Option C - Saisons

``` r
priorite_saison <- ventes |>
  group_by(saison) |>
  summarise(
    ventes_totales = sum(ventes, na.rm = TRUE),
    satisfaction_moyenne = mean(satisfaction, na.rm = TRUE),
    ruptures_stock = sum(ruptures_stock, na.rm = TRUE),
    .groups = "drop"
  ) |>
  mutate(
    ventes_totales = currency_ca(ventes_totales),
    satisfaction_moyenne = round(satisfaction_moyenne, 1)
  )

priorite_saison |>
  knitr::kable()
```

| saison    | ventes_totales | satisfaction_moyenne | ruptures_stock |
|:----------|:---------------|---------------------:|---------------:|
| haute     | 1 541 747 \$   |                  7.6 |             27 |
| moyenne   | 1 965 806 \$   |                  7.8 |             29 |
| reguliere | 4 456 151 \$   |                  7.6 |             77 |

Ce résultat aide à décider si les prochaines analyses devraient distinguer les périodes de l’année. Il reste descriptif : il ne sépare pas encore les effets de succursale, de saison, de marketing ou d’opérations.

## Synthèse pour la trace finale

À la fin de ces démonstrations, votre propre trace finale devrait contenir :

- une phrase sur l’unité d’observation;
- un dictionnaire rapide des variables clés;
- un diagnostic des valeurs manquantes;
- un tableau synthèse par succursale;
- un graphique des ventes;
- un deuxième graphique descriptif;
- trois constats prudents;
- une recommandation de prochaine analyse;
- une limite d’interprétation.

> **TIP:**
>
> La prochaine analyse devrait prioriser \[marketing, opérations ou saisonnalité\], car le diagnostic descriptif suggère que \[résultat observé\]. Cette conclusion reste préliminaire, car \[limite à nommer\].
