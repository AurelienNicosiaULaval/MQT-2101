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
    1          0   452      0.695
    2          1   198      0.305

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
    1 anciennete_mois           0.970   0.00752    -4.08  4.54e-5    0.955     0.984
    2 utilisation_mensuelle     0.907   0.0230     -4.26  2.02e-5    0.866     0.948
    3 tickets_service_6m        1.63    0.0962      5.10  3.47e-7    1.36      1.98
    4 satisfaction              0.679   0.0966     -4.01  5.95e-5    0.559     0.817
    5 type_contratmensuel       2.26    0.250       3.26  1.13e-3    1.40      3.74
    6 rabais_actuelfidélité     1.26    0.252       0.929 3.53e-1    0.769     2.07
    7 rabais_actuelrétention    1.81    0.315       1.88  5.94e-2    0.973     3.36

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
    1         0.00760               0.266           0.896

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
    1   0.3    41    35    78     9      0.730        0.82       0.690     0.539
    2   0.5    23     6   107    27      0.798        0.46       0.947     0.793
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
    1 0.532    19     6   107    31      0.773        0.38       0.947      0.76
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
    1             1              0.0664              0          33
    2             2              0.170               0.152      33
    3             3              0.286               0.242      33
    4             4              0.410               0.375      32
    5             5              0.672               0.781      32

## Interprétation

Le modèle ordonne des risques selon les données simulées. Avant une utilisation réelle, il faudrait valider les mesures sur une autre période, examiner la stabilité, documenter les populations touchées et s’assurer que l’intervention proposée est proportionnée et respectueuse.
