# Démonstrations R - Laboratoire 04

Les deux voies sont montrées pour permettre de choisir et de comprendre leur différence. Pour votre rapport, développez une seule voie. Les données et résultats sont fictifs; les observations de 2025 ont déjà été consultées dans les modules 09 et 10 et ne forment pas un nouveau test indépendant.

## Préparation

Installez `tidyverse` et `lubridate` au besoin. Exécutez les blocs dans l’ordre dans un projet extrait, sans objets préexistants.

``` r
library(tidyverse)
library(lubridate)

racines <- c(".", "modules/atelier-04-recapitulation")
racine <- racines[file.exists(file.path(racines, "data/cas_integrateur_quebec.csv"))][1]
stopifnot(!is.na(racine))
cas <- read_csv(file.path(racine, "data/cas_integrateur_quebec.csv"), show_col_types = FALSE) |>
  mutate(date = as.Date(date), succursale = factor(succursale),
         promotion = factor(promotion, levels = c("non", "oui")),
         mois = factor(month(date), levels = 1:12)) |> arrange(date, succursale)
stopifnot(nrow(cas) == 288, n_distinct(cas$succursale) == 4,
          !anyDuplicated(cas[c("date", "succursale")]), !anyNA(cas))
cas |> summarise(lignes = n(), debut = min(date), fin = max(date),
                  succursales = n_distinct(succursale), mois = n_distinct(date))
```

    # A tibble: 1 × 5
      lignes debut      fin        succursales  mois
       <int> <date>     <date>           <int> <int>
    1    288 2020-01-01 2025-12-01           4    72

## 1. Vérifier et explorer

Chaque date doit être présente une fois par succursale. Ici, les données sont complètes; dans une autre situation, documentez d’abord les lacunes plutôt que de les supprimer automatiquement.

``` r
cas |> count(succursale)
```

    # A tibble: 4 × 2
      succursale     n
      <fct>      <int>
    1 Gatineau      72
    2 Montréal      72
    3 Québec        72
    4 Sherbrooke    72

``` r
cas |> group_by(succursale) |> summarise(mois = n_distinct(date), .groups = "drop")
```

    # A tibble: 4 × 2
      succursale  mois
      <fct>      <int>
    1 Gatineau      72
    2 Montréal      72
    3 Québec        72
    4 Sherbrooke    72

``` r
# Explorer uniquement la période qui précède la validation de 2025.
cas |> filter(date < as.Date("2025-01-01")) |>
  ggplot(aes(date, ventes, colour = succursale)) + geom_line() +
  facet_wrap(~ succursale, scales = "free_y") +
  labs(x = "Mois", y = "Ventes (dollars)", colour = NULL) +
  theme_minimal(base_size = 11) + theme(legend.position = "none")
```

![](demonstrations_files/figure-html/unnamed-chunk-2-1.png)

## 2. Voie A : ventes et référence

Origine : fin décembre 2024. Le modèle utilise tendance, succursale et calendrier. La référence reporte pour chaque mois les ventes observées en 2024. La promotion de 2025 n’est pas supposée connue, et les variables opérationnelles du mois à prévoir ne sont pas utilisées.

``` r
apprentissage_a <- cas |> filter(date < as.Date("2025-01-01"))
validation_a <- cas |> filter(date >= as.Date("2025-01-01"))
modele_ventes <- lm(ventes ~ indice_temps + succursale + mois, data = apprentissage_a)
reference_a <- apprentissage_a |> filter(year(date) == 2024) |>
  transmute(date = date %m+% years(1), succursale, reference = ventes)
stopifnot(nrow(validation_a) == 48, nrow(reference_a) == 48)
comparaison_a <- validation_a |>
  mutate(regression = as.numeric(predict(modele_ventes, newdata = validation_a))) |>
  left_join(reference_a, by = c("date", "succursale")) |>
  pivot_longer(c(regression, reference), names_to = "methode", values_to = "prevision") |>
  mutate(erreur = ventes - prevision)
stopifnot(!anyNA(comparaison_a$prevision), nrow(comparaison_a) == 96)
scores_a <- comparaison_a |> group_by(methode) |>
  summarise(ME = mean(erreur), MAE = mean(abs(erreur)), RMSE = sqrt(mean(erreur^2)), .groups = "drop")
scores_a
```

    # A tibble: 2 × 4
      methode        ME    MAE   RMSE
      <chr>       <dbl>  <dbl>  <dbl>
    1 reference   4928. 23669  28501.
    2 regression -1192. 18303. 22413.

``` r
comparaison_a |> group_by(succursale, methode) |>
  summarise(MAE = mean(abs(erreur)), .groups = "drop")
```

    # A tibble: 8 × 3
      succursale methode       MAE
      <fct>      <chr>       <dbl>
    1 Gatineau   reference  25013.
    2 Gatineau   regression 12836.
    3 Montréal   reference  22089.
    4 Montréal   regression 16076.
    5 Québec     reference  24765.
    6 Québec     regression 18031.
    7 Sherbrooke reference  22809.
    8 Sherbrooke regression 26270.

ME est la moyenne des erreurs observé moins prévu; MAE et RMSE sont en dollars. Les résultats 2025 sont une validation réutilisée après les modules précédents. Un modèle peut être meilleur globalement et moins bon pour certaines succursales.

## 3. Voie B : service et référence

Les conditions du mois courant sont supposées connues à la décision. La cible est une étiquette simulée pour le mois suivant; elle n’est pas construite à partir d’une observation réelle du mois suivant. L’apprentissage va jusqu’à novembre 2023, le seuil est calculé sur janvier à novembre 2024 et l’évaluation réutilisée porte sur 2025. Les deux mois de décembre précédents sont écartés pour respecter l’horizon de disponibilité de l’étiquette.

``` r
mesures_binaires <- function(observe, prediction) {
  stopifnot(length(observe) == length(prediction), all(observe %in% c(0, 1)),
            all(prediction %in% c(0, 1)))
  vp <- sum(observe == 1 & prediction == 1); fp <- sum(observe == 0 & prediction == 1)
  vn <- sum(observe == 0 & prediction == 0); fn <- sum(observe == 1 & prediction == 0)
  ratio <- function(a, b) if (b == 0) NA_real_ else a / b
  tibble(VP = vp, FP = fp, VN = vn, FN = fn,
         sensibilite = ratio(vp, vp + fn), specificite = ratio(vn, vn + fp),
         precision = ratio(vp, vp + fp), proportion_ciblee = mean(prediction == 1))
}
```

``` r
apprentissage_b <- cas |> filter(date <= as.Date("2023-11-01"))
validation_b <- cas |> filter(date >= as.Date("2024-01-01"), date <= as.Date("2024-11-01"))
evaluation_b <- cas |> filter(date >= as.Date("2025-01-01"))
modele_service <- glm(service_insuffisant_mois_suivant ~ temps_attente + ruptures_stock +
                        satisfaction + taux_utilisation, data = apprentissage_b, family = binomial())
stopifnot(modele_service$converged, all(is.finite(coef(modele_service))))
validation_b <- validation_b |>
  mutate(prob_risque = as.numeric(predict(modele_service, newdata = validation_b, type = "response")))
# Seuil défini sur les scores de 2024, sans utiliser les étiquettes de 2025.
seuil_b <- as.numeric(quantile(validation_b$prob_risque, 0.80))
evaluation_b <- evaluation_b |>
  mutate(prob_risque = as.numeric(predict(modele_service, newdata = evaluation_b, type = "response")),
         prediction = as.integer(prob_risque >= seuil_b))
classe_majoritaire <- as.integer(mean(apprentissage_b$service_insuffisant_mois_suivant) > 0.5)
mesure_b <- mesures_binaires(evaluation_b$service_insuffisant_mois_suivant, evaluation_b$prediction)
reference_b <- mesures_binaires(evaluation_b$service_insuffisant_mois_suivant,
                                 rep(classe_majoritaire, nrow(evaluation_b)))
seuil_b
```

    [1] 0.3394059

``` r
mesure_b |> select(VP, FP, VN, FN)
```

    # A tibble: 1 × 4
         VP    FP    VN    FN
      <int> <int> <int> <int>
    1     6     8    32     2

``` r
mesure_b |> select(sensibilite, specificite, precision, proportion_ciblee)
```

    # A tibble: 1 × 4
      sensibilite specificite precision proportion_ciblee
            <dbl>       <dbl>     <dbl>             <dbl>
    1        0.75         0.8     0.429             0.292

``` r
reference_b |> select(VP, FP, VN, FN, sensibilite, precision)
```

    # A tibble: 1 × 6
         VP    FP    VN    FN sensibilite precision
      <int> <int> <int> <int>       <dbl>     <dbl>
    1     0     0    40     8           0        NA

``` r
evaluation_b |> group_by(succursale) |>
  summarise(observations = n(), cibles = sum(prediction),
            taux_cible = mean(prediction), positifs = sum(service_insuffisant_mois_suivant),
            .groups = "drop")
```

    # A tibble: 4 × 5
      succursale observations cibles taux_cible positifs
      <fct>             <int>  <int>      <dbl>    <dbl>
    1 Gatineau             12      5      0.417        0
    2 Montréal             12      2      0.167        1
    3 Québec               12      3      0.25         3
    4 Sherbrooke           12      4      0.333        4

Le seuil du 80e percentile est calculé sur les scores de validation, pas sur les étiquettes 2025. Il ne garantit pas un taux précis de ciblage ou une capacité stricte sur une période ultérieure. Les petits effectifs par succursale invitent à la prudence. La répartition signale un point à examiner; elle ne prouve pas à elle seule l’équité ou l’iniquité.

## 4. Conclure

Pour la voie retenue, présentez la cible, la référence, les mesures et leurs unités, la décision, puis une limite et une date ou condition de révision. Une association de promotion n’est pas une preuve d’effet causal; la prévision d’un risque ne mesure pas l’effet d’une intervention. Les autres méthodes des modules 07 à 10 demeurent des compléments, non des exigences supplémentaires pour la synthèse.
