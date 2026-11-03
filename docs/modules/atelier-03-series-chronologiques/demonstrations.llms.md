# Aide R et exemple complet - Laboratoire 03

## Utiliser cette page

Suivez d’abord le [guide de la mission](../../modules/atelier-03-series-chronologiques/guide-atelier.llms.md). Les blocs visibles ci-dessous forment un exemple complet et cumulatif dans une session R neuve. Le [projet de départ](telechargements/laboratoire-03.zip) contient votre rapport à compléter; le [projet de l’exemple](telechargements/exemple-laboratoire-03.zip) contient le code complet pour vérifier après une tentative.

## Préparation

Ouvrez le `.Rproj` du dossier extrait. Installez une fois `tidyverse` et `forecast` si nécessaire. Les données et leurs unités sont décrites dans le [dictionnaire](data/dictionnaires.md).

``` r
library(tidyverse)
library(forecast)
demande <- read_csv("data/demande_hebdomadaire_quebec.csv", show_col_types = FALSE) |>
  mutate(semaine = as.Date(semaine)) |> arrange(semaine) |>
  mutate(indice = row_number())
stopifnot(nrow(demande) == 104L, !anyNA(demande[c("semaine", "demande")]),
          !anyDuplicated(demande$semaine),
          all(as.numeric(diff(demande$semaine)) == 7))
horizon <- 13L
apprentissage <- demande |> slice_head(n = 91)
validation <- demande |> slice_tail(n = horizon)
# La date identifie le lundi. Une semaine complète est connue le dimanche suivant.
origine <- max(apprentissage$semaine) + 6
futur <- tibble(semaine = seq.Date(max(apprentissage$semaine) + 7,
                                   by = "week", length.out = horizon),
                indice = 91L + seq_len(horizon))
serie <- ts(apprentissage$demande, frequency = 52)
stopifnot(all(futur$semaine == validation$semaine))
```

## 1. Auditer et situer

``` r
demande |> summarise(lignes = n(), dates_distinctes = n_distinct(semaine),
  premiere_semaine = min(semaine), derniere_semaine = max(semaine),
  manquants = sum(is.na(demande)))
```

    # A tibble: 1 × 5
      lignes dates_distinctes premiere_semaine derniere_semaine manquants
       <int>            <int> <date>           <date>               <int>
    1    104              104 2024-01-01       2025-12-22               0

``` r
tibble(derniere_semaine_apprentissage = max(apprentissage$semaine),
       origine_fin_de_semaine = origine,
       premiere_semaine_validation = min(validation$semaine), horizon)
```

    # A tibble: 1 × 4
      derniere_semaine_appre…¹ origine_fin_de_semaine premiere_semaine_val…² horizon
      <date>                   <date>                 <date>                   <int>
    1 2025-09-22               2025-09-28             2025-09-29                  13
    # ℹ abbreviated names: ¹​derniere_semaine_apprentissage,
    #   ²​premiere_semaine_validation

La dernière date d’apprentissage, le 22 septembre 2025, désigne le lundi de la semaine. La demande est connue à la fin du dimanche 28 septembre; la première semaine prévue commence le 29 septembre. Treize semaines sont comparées. La validation est déjà connue du cours et ne constitue pas un test final indépendant.

## 2. Explorer le passé

``` r
ggplot(apprentissage, aes(semaine, demande)) +
  geom_line(colour = "#0B4F6C") + geom_point(aes(shape = promotion), size = 1.5) +
  labs(x = NULL, y = "Demande hebdomadaire (unités de produit)",
       shape = "Promotion observée") + theme_minimal(base_size = 12)
```

![](demonstrations_files/figure-html/exploration-labo03-1.png)

Le graphique décrit l’apprentissage seulement. Une hausse possible et des fluctuations récurrentes ne prouvent pas la cause de chaque écart. Les promotions marquées sont celles déjà observées; aucune promotion future n’entre dans ces prévisions.

## 3. Émettre les prévisions

``` r
# Tous les paramètres et les valeurs de référence viennent de l’apprentissage.
modele_ses <- ses(serie, h = horizon, initial = "optimal", level = c(80, 95))
modele_tendance <- lm(demande ~ indice, data = apprentissage)
previsions <- futur |>
  mutate(Naive = tail(apprentissage$demande, 1),
         MM4 = mean(tail(apprentissage$demande, 4)),
         SES = as.numeric(modele_ses$mean),
         Saisonnier = as.numeric(snaive(serie, h = horizon)$mean),
         Tendance = as.numeric(predict(modele_tendance, newdata = futur)))
previsions |> slice_head(n = 3)
```

    # A tibble: 3 × 7
      semaine    indice Naive   MM4   SES Saisonnier Tendance
      <date>      <int> <dbl> <dbl> <dbl>      <dbl>    <dbl>
    1 2025-09-29     92  1211 1313. 1290.       1121    1438.
    2 2025-10-06     93  1211 1313. 1290.       1246    1440.
    3 2025-10-13     94  1211 1313. 1290.       1154    1442.

``` r
coef(modele_tendance)
```

    (Intercept)      indice
    1245.188278    2.092897

Le coefficient de l’indice est d’environ 2,09 unités par semaine selon la droite ajustée. Il résume une pente moyenne sur l’apprentissage, sans effet causal. La méthode saisonnière naïve reprend le retard 52; le SES et la droite ne comportent pas de saison explicite. La droite ajoute un candidat à ceux du module 07 : leur ancien classement portait sur une liste plus courte.

## 4. Comparer et lire l’incertitude

``` r
# Les observations de validation ne sont jointes qu’après la prévision.
evaluation <- previsions |>
  left_join(validation |> select(semaine, observe = demande), by = "semaine") |>
  pivot_longer(c(Naive, MM4, SES, Saisonnier, Tendance),
               names_to = "methode", values_to = "prevision") |>
  mutate(erreur = observe - prevision)
scores <- evaluation |> group_by(methode) |>
  summarise(ME = mean(erreur), MAE = mean(abs(erreur)),
            RMSE = sqrt(mean(erreur^2)), .groups = "drop") |> arrange(MAE)
scores
```

    # A tibble: 5 × 4
      methode       ME   MAE  RMSE
      <chr>      <dbl> <dbl> <dbl>
    1 Tendance   -54.4  93.1  107.
    2 MM4         82.6 100.   128.
    3 SES        106.  114.   144.
    4 Saisonnier 143.  179.   194.
    5 Naive      185.  185.   209.

``` r
ggplot(evaluation, aes(semaine)) +
  geom_line(aes(y = observe), colour = "black", linewidth = 1) +
  geom_line(aes(y = prevision, colour = methode)) +
  labs(x = NULL, y = "Demande hebdomadaire (unités de produit)", colour = "Méthode") +
  theme_minimal(base_size = 12)
```

![](demonstrations_files/figure-html/comparaison-labo03-1.png)

Sur ces treize semaines connues, la tendance linéaire a une MAE d’environ 93 unités et une RMSE d’environ 107 unités; MM4 a une MAE d’environ 100. Ces chiffres décrivent cette comparaison utilisée pour choisir, et ne garantissent pas le classement futur. La ME est signée, en unités, selon observation moins prévision.

``` r
intervalles_ses <- tibble(semaine = futur$semaine,
  prevision = as.numeric(modele_ses$mean),
  inf80 = as.numeric(modele_ses$lower[, "80%"]),
  sup80 = as.numeric(modele_ses$upper[, "80%"]),
  inf95 = as.numeric(modele_ses$lower[, "95%"]),
  sup95 = as.numeric(modele_ses$upper[, "95%"]))
intervalles_ses |> slice_head(n = 3)
```

    # A tibble: 3 × 6
      semaine    prevision inf80 sup80 inf95 sup95
      <date>         <dbl> <dbl> <dbl> <dbl> <dbl>
    1 2025-09-29     1290. 1170. 1410. 1106. 1473.
    2 2025-10-06     1290. 1162. 1418. 1094. 1486.
    3 2025-10-13     1290. 1154. 1425. 1082. 1497.

Pour la première semaine prévue, le SES donne environ 1 290 unités; ses intervalles sont environ 1 170 à 1 410 à 80 % et 1 106 à 1 473 à 95 %. Ils concernent ce modèle SES, sous ses hypothèses. Ils ne sont pas les intervalles de la droite si vous retenez la tendance. Treize intervalles marginaux ne garantissent pas une couverture simultanée de tout l’horizon.

## 5. Décider et surveiller

``` r
couts <- evaluation |>
  mutate(cout = 18 * pmax(erreur, 0) + 5 * pmax(-erreur, 0)) |>
  group_by(methode) |>
  summarise(cout_total = sum(cout), .groups = "drop") |> arrange(cout_total)
couts
```

    # A tibble: 5 × 2
      methode    cout_total
      <chr>           <dbl>
    1 Tendance        9320.
    2 MM4            21944.
    3 SES            25997.
    4 Saisonnier     38780
    5 Naive          43254

Avec 18 \$ par unité sous-prévue et 5 \$ par unité sur-prévue, le coût fictif total est d’environ 9 320 \$ pour la tendance, contre environ 21 944 \$ pour MM4. Dans ce cas, le classement par coût et par MAE conserve la tendance en tête; un renversement n’est pas garanti. Ces valeurs ne sont pas des coûts observés ni une preuve d’une politique de stock optimale.

Exemple de note : « Sur les treize semaines déjà connues, la tendance obtient une MAE d’environ 93 unités et une RMSE d’environ 107, avec un coût fictif d’environ 9 320 \$. Je la retiens provisoirement parmi les cinq candidats. Les intervalles présentés ici sont ceux du SES et ne quantifient pas l’incertitude de cette droite. Les promotions futures et les délais ne sont pas modélisés. À chaque nouvelle origine, je suivrai les erreurs et réexaminerai la méthode si elles changent durablement. »

## Holt accompagné, si le temps le permet

Le [complément Holt du module 07](../../modules/semaine-07-lissage/capsules.llms.md#holt) explique niveau, pente et amortissement. Ce sixième candidat est un prolongement facultatif pour explorer une pente locale. Sur le même apprentissage et les mêmes cibles :

``` r
modele_holt <- holt(serie, h = horizon, damped = TRUE,
                    initial = "optimal", level = c(80, 95))
holt_validation <- tibble(semaine = futur$semaine,
  observe = validation$demande, prevision = as.numeric(modele_holt$mean)) |>
  mutate(erreur = observe - prevision)
holt_validation |> summarise(ME = mean(erreur), MAE = mean(abs(erreur)),
  RMSE = sqrt(mean(erreur^2)),
  cout_total = sum(18 * pmax(erreur, 0) + 5 * pmax(-erreur, 0)))
```

    # A tibble: 1 × 4
         ME   MAE  RMSE cout_total
      <dbl> <dbl> <dbl>      <dbl>
    1  152.  152.  189.     35578.

``` r
tibble(semaine = futur$semaine, prevision = as.numeric(modele_holt$mean),
       inf80 = as.numeric(modele_holt$lower[, "80%"]),
       sup80 = as.numeric(modele_holt$upper[, "80%"]),
       inf95 = as.numeric(modele_holt$lower[, "95%"]),
       sup95 = as.numeric(modele_holt$upper[, "95%"])) |> slice_head(n = 3)
```

    # A tibble: 3 × 6
      semaine    prevision inf80 sup80 inf95 sup95
      <date>         <dbl> <dbl> <dbl> <dbl> <dbl>
    1 2025-09-29     1280. 1160. 1401. 1096. 1464.
    2 2025-10-06     1272. 1148. 1395. 1082. 1461.
    3 2025-10-13     1264. 1136. 1392. 1068. 1460.

Holt amorti obtient ici une MAE d’environ 152 unités et un coût fictif d’environ 35 578 \$. Ses intervalles appartiennent à Holt. Une méthode plus élaborée n’assure pas une meilleure prévision; ces résultats concernent seulement les treize semaines de validation déjà connues.

## Un écart maximal, si utile

La plus grande erreur absolue peut aider à repérer une semaine à examiner. Ce repère est facultatif et ne résume pas à lui seul la qualité globale.

``` r
evaluation |> group_by(methode) |>
  summarise(erreur_max = max(abs(erreur)), .groups = "drop") |>
  arrange(erreur_max)
```

    # A tibble: 5 × 2
      methode    erreur_max
      <chr>           <dbl>
    1 Tendance         199.
    2 MM4              264.
    3 SES              287.
    4 Saisonnier       298
    5 Naive            366

## Pour revenir à votre mission

La [grille de relecture](../../modules/atelier-03-series-chronologiques/guide-atelier.llms.md#rapport-attendu) vous aide à vérifier votre rapport. Les [exercices de transfert](../../modules/atelier-03-series-chronologiques/exercices.llms.md) utilisent des ventes mensuelles et un objectif budgétaire, dans un autre contexte. Les [lectures](../../modules/atelier-03-series-chronologiques/lectures.llms.md) précisent les sources et les compléments.
