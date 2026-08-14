# Démonstrations R - Module 10

## Préparation

``` r
library(tidyverse)
library(broom)

data_path <- if (file.exists("data/fidelisation_clients_quebec.csv")) {
  "data/fidelisation_clients_quebec.csv"
} else {
  "modules/semaine-10-classification-modeles-avances/data/fidelisation_clients_quebec.csv"
}

clients <- read_csv(data_path, show_col_types = FALSE) |>
  mutate(type_contrat = factor(type_contrat), rabais_actuel = factor(rabais_actuel))

set.seed(210110)
ids_entrainement <- clients |>
  group_by(depart_90j) |>
  slice_sample(prop = 0.75) |>
  pull(client_id)

entrainement <- clients |> filter(client_id %in% ids_entrainement)
test <- clients |> filter(!client_id %in% ids_entrainement)
```

## 1. Examiner la cible

``` r
clients |>
  count(depart_90j) |>
  mutate(proportion = n / sum(n))
```

    # A tibble: 2 × 3
      depart_90j     n proportion
           <dbl> <int>      <dbl>
    1          0   631     0.971
    2          1    19     0.0292

## 2. Ajuster une régression logistique

``` r
modele <- glm(
  depart_90j ~ anciennete_mois + utilisation_mensuelle + tickets_service_6m +
    satisfaction + type_contrat + rabais_actuel,
  data = entrainement,
  family = binomial()
)

tidy(modele, conf.int = TRUE, exponentiate = TRUE) |>
  filter(term != "(Intercept)")
```

    # A tibble: 7 × 7
      term                   estimate std.error statistic p.value conf.low conf.high
      <chr>                     <dbl>     <dbl>     <dbl>   <dbl>    <dbl>     <dbl>
    1 anciennete_mois           0.987    0.0178    -0.717 0.473      0.950     1.02
    2 utilisation_mensuelle     0.875    0.0612    -2.19  0.0285     0.771     0.981
    3 tickets_service_6m        1.11     0.238      0.448 0.654      0.688     1.77
    4 satisfaction              0.614    0.238     -2.04  0.0410     0.377     0.968
    5 type_contratmensuel       1.23     0.622      0.330 0.741      0.385     4.71
    6 rabais_actuelfidélité     3.39     0.703      1.74  0.0826     0.850    14.6
    7 rabais_actuelrétention    6.46     0.711      2.63  0.00866    1.59     28.1

Les valeurs exponentiées sont des rapports de cotes, pas des différences directes de probabilité.

## 3. Produire les probabilités test

``` r
evaluation <- test |>
  mutate(prob_depart = predict(modele, newdata = test, type = "response"))

evaluation |>
  summarise(
    probabilite_min = min(prob_depart),
    probabilite_mediane = median(prob_depart),
    probabilite_max = max(prob_depart)
  )
```

    # A tibble: 1 × 3
      probabilite_min probabilite_mediane probabilite_max
                <dbl>               <dbl>           <dbl>
    1         0.00110              0.0166           0.516

## 4. Calculer les mesures à un seuil

``` r
mesures_seuil <- function(data, seuil) {
  data |>
    mutate(prediction = as.integer(prob_depart >= seuil)) |>
    summarise(
      seuil = seuil,
      VP = sum(prediction == 1 & depart_90j == 1),
      FP = sum(prediction == 1 & depart_90j == 0),
      VN = sum(prediction == 0 & depart_90j == 0),
      FN = sum(prediction == 0 & depart_90j == 1)
    ) |>
    mutate(
      exactitude = (VP + VN) / (VP + FP + VN + FN),
      sensibilite = VP / (VP + FN),
      specificite = VN / (VN + FP),
      precision = VP / (VP + FP),
      proportion_ciblee = (VP + FP) / (VP + FP + VN + FN)
    )
}

bind_rows(
  mesures_seuil(evaluation, 0.30),
  mesures_seuil(evaluation, 0.50)
)
```

    # A tibble: 2 × 10
      seuil    VP    FP    VN    FN exactitude sensibilite specificite precision
      <dbl> <int> <int> <int> <int>      <dbl>       <dbl>       <dbl>     <dbl>
    1   0.3     0     2   156     5      0.957           0       0.987         0
    2   0.5     0     1   157     5      0.963           0       0.994         0
    # ℹ 1 more variable: proportion_ciblee <dbl>

## 5. Relier le seuil à une capacité

``` r
capacite <- 0.15
seuil_capacite <- quantile(evaluation$prob_depart, probs = 1 - capacite)
mesures_seuil(evaluation, seuil_capacite)
```

    # A tibble: 1 × 10
       seuil    VP    FP    VN    FN exactitude sensibilite specificite precision
       <dbl> <int> <int> <int> <int>      <dbl>       <dbl>       <dbl>     <dbl>
    1 0.0716     0    25   133     5      0.816           0       0.842         0
    # ℹ 1 more variable: proportion_ciblee <dbl>

## 6. Vérifier sommairement la calibration

``` r
evaluation |>
  mutate(groupe_risque = ntile(prob_depart, 5)) |>
  group_by(groupe_risque) |>
  summarise(
    probabilite_moyenne = mean(prob_depart),
    frequence_observee = mean(depart_90j),
    clients = n(),
    .groups = "drop"
  )
```

    # A tibble: 5 × 4
      groupe_risque probabilite_moyenne frequence_observee clients
              <int>               <dbl>              <dbl>   <int>
    1             1             0.00313             0           33
    2             2             0.00915             0           33
    3             3             0.0177              0.0909      33
    4             4             0.0378              0.0312      32
    5             5             0.124               0.0312      32

## Interprétation

Le modèle ordonne des risques selon les données simulées. Avant une utilisation réelle, il faudrait valider les mesures sur une autre période, examiner la stabilité, documenter les populations touchées et s’assurer que l’intervention proposée est proportionnée et respectueuse.
