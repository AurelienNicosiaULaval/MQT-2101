# Démonstrations R - Module 06

## Objectif

Construire une analyse de prévision sur la consommation mensuelle d’électricité d’un bâtiment universitaire fictif. Définir la cible, vérifier le calendrier, comparer les références et communiquer les erreurs et l’incertitude. Les six étapes du parcours utilisent les mêmes données simulées.

## Préparation

Décompressez le [projet de démonstration complet](telechargements/demonstration-electricite.zip), puis ouvrez `demonstration-electricite.Rproj`. Il contient le CSV, le dictionnaire, les fonctions R et ce document. Pour produire votre propre analyse, utilisez le [projet guidé](telechargements/prevision-electricite.zip).

Les bibliothèques nécessaires sont `tidyverse` et `forecast`. Leur installation se fait une seule fois, dans la console, avant de rendre le document :

``` r
install.packages(c("tidyverse", "forecast"))
```

Un fichier CSV seul ne suffit pas si vous copiez ces fonctions partagées : conservez également le dossier `R` du projet. Le code ci-dessous se recalcule depuis une session R neuve.

``` r
library(tidyverse)
library(forecast)

# Dans le projet téléchargé, R/ et data/ sont à côté du document.
chemins_R <- c("R/analyse-module06.R",
               "modules/semaine-06-series-chronologiques-intro/R/analyse-module06.R")
chemin_R <- chemins_R[file.exists(chemins_R)][1]
stopifnot(!is.na(chemin_R))
source(chemin_R)
chemins <- c("data/consommation_electrique_batiment_quebec.csv",
             "modules/semaine-06-series-chronologiques-intro/data/consommation_electrique_batiment_quebec.csv")
chemin <- chemins[file.exists(chemins)][1]
stopifnot(!is.na(chemin))
analyse <- charger_module06(chemin)
electricite <- analyse$electricite
apprentissage <- analyse$apprentissage
validation <- analyse$validation
```

Les fonctions partagées chargent les données, produisent les références, calculent les scores et construisent la validation mobile. Les étapes 1 à 6 constituent le parcours principal. Les deux derniers développements sont des compléments facultatifs.

## 1. Définir et vérifier la série

``` r
glimpse(electricite)
```

    Rows: 72
    Columns: 8
    $ date             <date> 2020-01-01, 2020-02-01, 2020-03-01, 2020-04-01, 2020…
    $ annee            <dbl> 2020, 2020, 2020, 2020, 2020, 2020, 2020, 2020, 2020,…
    $ mois             <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2, 3, 4, 5,…
    $ mois_label       <fct> janvier, février, mars, avril, mai, juin, juillet, ao…
    $ trimestre        <chr> "T1", "T1", "T1", "T2", "T2", "T2", "T3", "T3", "T3",…
    $ jours_mois       <dbl> 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 2…
    $ consommation_kwh <dbl> 201898, 181611, 172716, 130212, 118104, 102466, 10385…
    $ indice           <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16…

``` r
electricite |>
  summarise(debut = min(date), fin = max(date), observations = n(),
            dates_dupliquees = sum(duplicated(date)),
            consommation_manquante = sum(is.na(consommation_kwh)))
```

    # A tibble: 1 × 5
      debut      fin        observations dates_dupliquees consommation_manquante
      <date>     <date>            <int>            <int>                  <int>
    1 2020-01-01 2025-12-01           72                0                      0

Une ligne est un mois de consommation d’électricité d’un bâtiment universitaire fictif au Québec. La date désigne ce mois et consommation_kwh donne son énergie totale en kWh. Le fichier est entièrement simulé. La cible doit préciser les périodes futures et la décision. Les graphiques divisent les valeurs par 1 000 pour afficher des MWh; les scores restent en kWh.

La séparation est fixée avant l’exploration utilisée pour choisir la méthode : 60 mois de 2020 à 2024 pour apprendre; 12 mois de 2025 pour comparer. La validation utilise ici une origine à la fin de décembre 2024.

## 2. Lire les composantes

``` r
graphique_serie(apprentissage)
```

![](demonstrations_files/figure-html/unnamed-chunk-3-1.png)

``` r
ggplot(apprentissage, aes(mois, consommation_kwh / 1000,
                         group = annee, colour = factor(annee))) +
  geom_line() + geom_point() +
  scale_x_continuous(breaks = 1:12) +
  labs(x = "Mois", y = "Consommation (MWh)", colour = "Année") +
  theme_minimal(base_size = 12)
```

![](demonstrations_files/figure-html/unnamed-chunk-4-1.png)

Les profils par année montrent les mois comparables sans trier alphabétiquement leurs noms. Une hausse de long terme et un motif annuel peuvent coexister. Décrire ces formes n’en établit pas la cause.

### Zoom et logarithme

``` r
zoom <- apprentissage |> filter(date >= as.Date("2023-01-01"))
graphique_serie(zoom)
```

![](demonstrations_files/figure-html/unnamed-chunk-5-1.png)

``` r
stopifnot(all(apprentissage$consommation_kwh > 0))
graphique_serie(apprentissage) + scale_y_log10()
```

![](demonstrations_files/figure-html/unnamed-chunk-6-1.png)

Un zoom change la période regardée. L’échelle logarithmique change l’interprétation des écarts. Elle ne transforme pas la consommation dans le modèle ajusté plus bas. Une agrégation annuelle efface la résolution mensuelle et ne constitue pas à elle seule une désaisonnalisation.

### Objets ts, window et ligne de tendance

``` r
serie <- ts(apprentissage$consommation_kwh, start = c(2020, 1), frequency = 12)
fenetre <- window(serie, start = c(2023, 1), end = c(2024, 12))
modele_tendance <- tslm(serie ~ trend + I(trend^2))
```

``` r
graphique_serie(apprentissage) +
  geom_line(aes(y = as.numeric(fitted(modele_tendance)) / 1000),
            colour = "#7A1C24", linewidth = 1)
```

![](demonstrations_files/figure-html/unnamed-chunk-8-1.png)

Cette tendance quadratique reprend le modèle étudié au module 4. La courbe ne modélise pas explicitement le calendrier. `ts()` suppose une grille régulière; il ne répare pas un mois absent.

## 3. Prétraiter sans déformer le calendrier

``` r
dates_attendues <- seq.Date(min(apprentissage$date),
                           max(apprentissage$date), by = "month")
calendrier <- tibble(date = dates_attendues) |>
  left_join(apprentissage |> select(date, consommation_kwh), by = "date")
stopifnot(!anyDuplicated(apprentissage$date))
calendrier |> filter(is.na(consommation_kwh))
```

    # A tibble: 0 × 2
    # ℹ 2 variables: date <date>, consommation_kwh <dbl>

Le fichier guidé ne contient pas de trou. Pour apprendre à distinguer une ligne supprimée d’une mesure manquante, créez une copie de travail, en conservant l’original :

``` r
exemple_incomplet <- apprentissage |>
  filter(date != as.Date("2022-02-01")) |>
  mutate(consommation_kwh = if_else(date == as.Date("2022-03-01"), NA_real_, consommation_kwh))

# Rétablir la grille rend les deux problèmes visibles, sans imputer.
tibble(date = dates_attendues) |>
  left_join(exemple_incomplet |> select(date, consommation_kwh), by = "date") |>
  filter(is.na(consommation_kwh))
```

    # A tibble: 2 × 2
      date       consommation_kwh
      <date>                <dbl>
    1 2022-02-01               NA
    2 2022-03-01               NA

La copie a été modifiée uniquement pour cet exemple. Aucune valeur imputée n’est utilisée dans les comparaisons. Documentez le mécanisme supposé, le traitement, les informations disponibles à l’origine et une analyse de sensibilité. Ne retirez pas automatiquement un événement réel. Les modalités de gestion des NA dépendent de la fonction de modèle.

## 4. Comparer les références à origine fixe

``` r
refs <- prevoir_references(apprentissage$consommation_kwh, horizon = 12, periode = 12)
prevision_tendance <- forecast(modele_tendance, h = 12)

previsions <- validation |>
  mutate(naive = refs$naive, saisonniere = refs$saisonniere,
         tendance = as.numeric(prevision_tendance$mean))
previsions |> select(date, consommation_kwh, naive, saisonniere, tendance) |> head()
```

    # A tibble: 6 × 5
      date       consommation_kwh  naive saisonniere tendance
      <date>                <dbl>  <dbl>       <dbl>    <dbl>
    1 2025-01-01           223421 200112      215188  162081.
    2 2025-02-01           184638 200112      192262  162647.
    3 2025-03-01           183079 200112      185038  163225.
    4 2025-04-01           156201 200112      158979  163814.
    5 2025-05-01           142726 200112      141021  164415.
    6 2025-06-01           125375 200112      114345  165027.

Les trois candidats sont définis avant la comparaison. Le naïf reprend décembre 2024 pour tout 2025. Le saisonnier reprend chacun des mois de 2024. La régression extrapole la forme estimée sur 2020 à 2024.

``` r
graphique_validation(analyse)
```

![](demonstrations_files/figure-html/unnamed-chunk-12-1.png)

La ligne noire utilise les observations de validation seulement après émission des prévisions. Après le choix final, un réajustement sur les données disponibles jusqu’à décembre 2025 permettra de prévoir 2026. Les scores de validation doivent rester ceux du protocole initial.

## 5. Calculer les mesures et lire les erreurs

``` r
# Les trois candidats utilisent le même dénominateur saisonnier pour la MASE.
analyse$comparaison |> knitr::kable(digits = 2,
  col.names = c("Méthode", "ME (kWh)", "MAE (kWh)", "RMSE (kWh)", "MAPE (%)", "MASE"),
  format.args = list(decimal.mark = ",", big.mark = " "))
```

| Méthode     |   ME (kWh) | MAE (kWh) | RMSE (kWh) | MAPE (%) | MASE |
|:------------|-----------:|----------:|-----------:|---------:|-----:|
| naive       | -36 878,67 | 43 810,17 |  51 298,07 |    31,69 | 6,71 |
| saisonniere |   3 052,50 |  6 662,33 |   7 987,13 |     4,11 | 1,02 |
| tendance    |  -2 172,18 | 31 573,64 |  35 965,65 |    20,50 | 4,84 |

``` r
# Illustration indépendante, avec erreurs -20 et +20.
mesures_erreur(observe = c(80, 120), prevision = c(100, 100),
               apprentissage = c(80, 90, 100), periode = 1)
```

    # A tibble: 1 × 5
         ME   MAE  RMSE  MAPE  MASE
      <dbl> <dbl> <dbl> <dbl> <dbl>
    1     0    20    20  20.8     2

La ME indique le signe moyen de la différence observé moins prévu. La MAE et la RMSE décrivent l’ampleur en kWh. Le MAPE est en pourcentage. La MASE divise la MAE de validation par l’erreur saisonnière moyenne sur l’apprentissage; elle ne prouve pas à elle seule une victoire sur le naïf saisonnier de validation.

``` r
erreurs <- analyse$evaluation |> filter(methode == "saisonniere")
ggplot(erreurs, aes(date, erreur / 1000)) +
  geom_hline(yintercept = 0, linetype = 2) +
  geom_line(colour = "#0B4F6C") + geom_point() +
  labs(x = NULL, y = "Erreur (MWh)") + theme_minimal()
```

![](demonstrations_files/figure-html/unnamed-chunk-14-1.png)

``` r
ggplot(erreurs, aes(erreur / 1000)) +
  geom_histogram(bins = 6, fill = "#D9EEF2", colour = "#0B4F6C") +
  labs(x = "Erreur de prévision (MWh)", y = "Nombre de mois") +
  theme_minimal()
```

![](demonstrations_files/figure-html/unnamed-chunk-15-1.png)

Douze erreurs donnent peu d’information sur les queues de distribution et l’indépendance. Ce sont les erreurs hors apprentissage, pas les résidus du modèle ajusté.

## 6. Produire et lire les cônes de prédiction

``` r
# Trois structures illustratives, toutes ajustées à la même origine.
modeles_ets <- list(
  ANN = ets(serie, model = "ANN"),
  AAN = ets(serie, model = "AAN"),
  AAA = ets(serie, model = "AAA")
)
cones <- map(modeles_ets, ~ forecast(.x, h = 12, level = c(80, 95)))
```

``` r
autoplot(cones$AAN) +
  labs(x = "Année", y = "Consommation (kWh)", title = "Exemple ETS(A,A,N)") +
  scale_y_continuous(labels = function(x) nombre_fr(x))
```

![](demonstrations_files/figure-html/unnamed-chunk-17-1.png)

``` r
walk(names(cones), function(nom) {
  print(autoplot(cones[[nom]]) +
          labs(x = "Année", y = "Consommation (kWh)", title = paste("Exemple ETS", nom)) +
          scale_y_continuous(labels = function(x) nombre_fr(x)))
})
```

![](demonstrations_files/figure-html/unnamed-chunk-18-1.png)

![](demonstrations_files/figure-html/unnamed-chunk-18-2.png)

![](demonstrations_files/figure-html/unnamed-chunk-18-3.png)

Les lettres indiquent erreur, tendance et saisonnalité. A désigne additif, M multiplicatif, N l’absence de tendance ou de saisonnalité. Z demande un choix automatique à `ets()`; certaines combinaisons sont inadmissibles. Le lissage est approfondi au module 7.

``` r
tibble(
  h = c(1L, 12L),
  point = as.numeric(cones$AAN$mean[c(1, 12)]),
  bas_80 = cones$AAN$lower[c(1, 12), "80%"],
  haut_80 = cones$AAN$upper[c(1, 12), "80%"],
  bas_95 = cones$AAN$lower[c(1, 12), "95%"],
  haut_95 = cones$AAN$upper[c(1, 12), "95%"]
) |> knitr::kable(digits = 0)
```

|   h |  point | bas_80 | haut_80 |  bas_95 | haut_95 |
|----:|-------:|-------:|--------:|--------:|--------:|
|   1 | 213142 | 189581 |  236703 |  177109 |  249175 |
|  12 | 258546 |  11210 |  505883 | -119722 |  636814 |

Dans cette illustration ETS(A,A,N), la borne inférieure à 95 % pour h = 12 est négative, ce qui n’a pas de sens physique pour une consommation d’énergie. C’est une limite de la structure additive illustrée; elle appelle une réévaluation du modèle et de sa calibration avant un usage opérationnel.

Un niveau de 95 % se lit comme la couverture nominale d’une procédure sous ses hypothèses. L’intervalle par horizon n’est pas une garantie ni une bande simultanée de toute la trajectoire. La comparaison de ces cônes est illustrative : leur largeur ne désigne pas le meilleur modèle.

## Conclusion du parcours principal

Nommez la décision, le protocole, la méthode retenue et son score utile. Ajoutez une limite, les informations externes nécessaires et une règle de réévaluation. Une bonne performance descriptive ou prédictive n’établit pas un effet causal.

## Réajuster après le choix de méthode

``` r
# Illustration avec une référence choisie; ce n'est pas un classement imposé.
serie_complete <- ts(electricite$consommation_kwh, start = c(2020, 1), frequency = 12)
prevision_2026 <- snaive(serie_complete, h = 12)
head(prevision_2026$mean)
```

            Jan    Feb    Mar    Apr    May    Jun
    2026 223421 184638 183079 156201 142726 125375

À la fin de 2025, l’apprentissage et la validation historiques sont réunis pour prévoir 2026. On conserve les anciens scores et on suit les erreurs au fur et à mesure que les nouvelles observations deviennent disponibles.

## Complément A - Valider à plusieurs origines

``` r
mobile <- validation_mobile(electricite$consommation_kwh, debut_validation = 61,
                            horizons = c(1L, 6L), periode = 12)
mobile |>
  group_by(h, methode) |>
  summarise(n = n(), ME = mean(erreur), MAE = mean(abs(erreur)),
            RMSE = sqrt(mean(erreur^2)), .groups = "drop") |>
  knitr::kable(digits = 2)
```

|   h | methode     |   n |        ME |      MAE |     RMSE |
|----:|:------------|----:|----------:|---------:|---------:|
|   1 | naive       |  12 |   1523.33 | 19989.00 | 23242.66 |
|   1 | saisonniere |  12 |   3052.50 |  6662.33 |  7987.13 |
|   6 | naive       |   7 | -20973.86 | 63994.14 | 70792.76 |
|   6 | saisonniere |   7 |   5579.00 |  8235.57 |  9450.34 |

L’historique croît à chaque origine. Il y a douze origines à un mois, sept à six mois. Les observations reçues depuis décembre 2024 peuvent être utilisées seulement lorsqu’elles sont déjà connues à la nouvelle origine. Le tableau regroupe les erreurs par horizon, sans les mélanger.

``` r
# Vérifier l'information utilisée et la date de la cible.
mobile |>
  mutate(date_origine = electricite$date[origine], date_cible = electricite$date[cible]) |>
  select(methode, h, date_origine, date_cible, prevision, observe) |>
  filter(h == 6) |> head()
```

    # A tibble: 6 × 6
      methode         h date_origine date_cible prevision observe
      <chr>       <int> <date>       <date>         <dbl>   <dbl>
    1 naive           6 2024-12-01   2025-06-01    200112  125375
    2 saisonniere     6 2024-12-01   2025-06-01    114345  125375
    3 naive           6 2025-01-01   2025-07-01    223421  114372
    4 saisonniere     6 2025-01-01   2025-07-01    119873  114372
    5 naive           6 2025-02-01   2025-08-01    184638  127930
    6 saisonniere     6 2025-02-01   2025-08-01    120492  127930

Un classement de méthodes dépend de l’horizon et de la fenêtre. Les scores d’une comparaison utilisée pour choisir un modèle ne constituent pas une évaluation finale indépendante.

## Complément B - Combiner et préparer le suivi

``` r
combinaison <- previsions |>
  mutate(prevision_combinee = (naive + saisonniere) / 2)
mesures_erreur(combinaison$consommation_kwh, combinaison$prevision_combinee,
               apprentissage$consommation_kwh, periode = 12)
```

    # A tibble: 1 × 5
           ME    MAE   RMSE  MAPE  MASE
        <dbl>  <dbl>  <dbl> <dbl> <dbl>
    1 -16913. 22588. 25806.  16.0  3.46

Les poids sont fixés avant de regarder le score. Vérifiez le gain observé plutôt que de le supposer. La covariance et le biais des erreurs influencent l’utilité d’un ensemble. Prévoir une correction à partir des erreurs est une autre stratégie, qui exige elle aussi une validation sans fuite temporelle.

## Sources

Hyndman, R. J., et Athanasopoulos, G. (2021), [Forecasting: Principles and Practice, 3e édition](https://otexts.com/fpp3/), chapitres 2, 5 et 8, sections 13.4 et 13.9. Les [lectures ciblées](../../modules/semaine-06-series-chronologiques-intro/lectures.llms.md) précisent les passages associés à chaque étape. Fonctions : [forecast](https://pkg.robjhyndman.com/forecast/).
