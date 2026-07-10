# Guide en classe - Atelier 04

## Préparation

``` r
library(tidyverse)
library(broom)

data_path <- if (file.exists("data/cas_integrateur_quebec.csv")) {
  "data/cas_integrateur_quebec.csv"
} else {
  "modules/atelier-04-recapitulation/data/cas_integrateur_quebec.csv"
}

cas <- read_csv(data_path, show_col_types = FALSE) |>
  mutate(
    date = as.Date(date),
    succursale = factor(succursale),
    promotion = factor(promotion, levels = c("non", "oui"))
  ) |>
  arrange(date, succursale)

date_coupure <- as.Date("2025-01-01")
entrainement <- cas |> filter(date < date_coupure)
test <- cas |> filter(date >= date_coupure)
```

## Étape 1 - Auditer la structure

``` r
cas |>
  summarise(
    lignes = n(),
    debut = min(date),
    fin = max(date),
    succursales = n_distinct(succursale),
    dates = n_distinct(date),
    valeurs_manquantes = sum(is.na(cas))
  )
```

    # A tibble: 1 × 6
      lignes debut      fin        succursales dates valeurs_manquantes
       <int> <date>     <date>           <int> <int>              <int>
    1    288 2020-01-01 2025-12-01           4    72                  0

> **TIP:**
>
> Définissez l’unité mois-succursale et écrivez votre question selon la voie A ou B.

## Étape 2 - Explorer sans multiplier les graphiques

``` r
cas |>
  ggplot(aes(date, ventes, colour = succursale)) +
  geom_line() +
  facet_wrap(~ succursale, scales = "free_y") +
  labs(title = "Ventes mensuelles par succursale", x = NULL, y = "Ventes", colour = NULL) +
  theme_minimal(base_size = 11) +
  theme(legend.position = "none")
```

![](guide-atelier_files/figure-html/unnamed-chunk-2-1.png)

``` r
cas |>
  group_by(succursale) |>
  summarise(
    ventes_moyennes = mean(ventes),
    attente_moyenne = mean(temps_attente),
    taux_service_insuffisant = mean(niveau_service_insuffisant),
    .groups = "drop"
  )
```

    # A tibble: 4 × 4
      succursale ventes_moyennes attente_moyenne taux_service_insuffisant
      <fct>                <dbl>           <dbl>                    <dbl>
    1 Gatineau           170130.            4.30                   0.0694
    2 Montréal           257110.            4.28                   0     
    3 Québec             195407.            4.35                   0.0556
    4 Sherbrooke         147373.            4.44                   0.0278

> **TIP:**
>
> Conservez un graphique et un tableau qui répondent directement à votre question.

## Voie A - Prévoir une réponse continue

### Modèle et référence

``` r
modele_ventes <- lm(
  ventes ~ indice_temps + succursale + achalandage + promotion + ruptures_stock,
  data = entrainement
)

reference_succursale <- entrainement |>
  group_by(succursale) |>
  summarise(reference = mean(ventes), .groups = "drop")

evaluation_ventes <- test |>
  mutate(prevision_modele = predict(modele_ventes, newdata = test)) |>
  left_join(reference_succursale, by = "succursale") |>
  pivot_longer(
    c(prevision_modele, reference),
    names_to = "methode",
    values_to = "prevision"
  ) |>
  mutate(erreur = ventes - prevision)

evaluation_ventes |>
  group_by(methode) |>
  summarise(
    MAE = mean(abs(erreur)),
    RMSE = sqrt(mean(erreur^2)),
    biais = mean(erreur),
    .groups = "drop"
  )
```

    # A tibble: 2 × 4
      methode             MAE   RMSE  biais
      <chr>             <dbl>  <dbl>  <dbl>
    1 prevision_modele  5302.  6360. -1318.
    2 reference        20025. 26512. 15259.

### Interprétation

``` r
tidy(modele_ventes, conf.int = TRUE) |>
  filter(term %in% c("achalandage", "promotionoui", "ruptures_stock"))
```

    # A tibble: 3 × 7
      term           estimate std.error statistic  p.value conf.low conf.high
      <chr>             <dbl>     <dbl>     <dbl>    <dbl>    <dbl>     <dbl>
    1 achalandage        67.3      4.37     15.4  2.70e-37     58.7      75.9
    2 promotionoui    18212.    1575.       11.6  1.03e-24  15108.    21315. 
    3 ruptures_stock  -3192.     328.       -9.72 5.85e-19  -3839.    -2545. 

Les coefficients décrivent des associations conditionnelles. Ils ne démontrent pas qu’imposer une promotion ou réduire artificiellement une variable produira exactement le changement estimé.

## Voie B - Détecter une réponse binaire

### Modèle et seuil de capacité

``` r
modele_service <- glm(
  niveau_service_insuffisant ~ temps_attente + ruptures_stock + satisfaction +
    achalandage + succursale,
  data = entrainement,
  family = binomial()
)

evaluation_service <- test |>
  mutate(prob_risque = predict(modele_service, newdata = test, type = "response"))

capacite_intervention <- 0.20
seuil <- quantile(evaluation_service$prob_risque, 1 - capacite_intervention)

evaluation_service <- evaluation_service |>
  mutate(prediction = as.integer(prob_risque >= seuil))
```

### Matrice et mesures

``` r
matrice <- evaluation_service |>
  count(observe = niveau_service_insuffisant, prediction)

matrice
```

    # A tibble: 3 × 3
      observe prediction     n
        <dbl>      <int> <int>
    1       0          0    37
    2       0          1    10
    3       1          0     1

``` r
evaluation_service |>
  summarise(
    VP = sum(prediction == 1 & niveau_service_insuffisant == 1),
    FP = sum(prediction == 1 & niveau_service_insuffisant == 0),
    VN = sum(prediction == 0 & niveau_service_insuffisant == 0),
    FN = sum(prediction == 0 & niveau_service_insuffisant == 1)
  ) |>
  mutate(
    sensibilite = VP / (VP + FN),
    specificite = VN / (VN + FP),
    precision = VP / (VP + FP),
    proportion_ciblee = (VP + FP) / (VP + FP + VN + FN)
  )
```

    # A tibble: 1 × 8
         VP    FP    VN    FN sensibilite specificite precision proportion_ciblee
      <int> <int> <int> <int>       <dbl>       <dbl>     <dbl>             <dbl>
    1     0    10    37     1           0       0.787         0             0.208

## Étape finale - Formuler la recommandation

Votre recommandation doit suivre quatre phrases :

1.  Nous avons analysé…
2.  Sur la période test, le modèle…
3.  Nous recommandons de…
4.  Cette recommandation dépend de… et sera révisée lorsque…

> **IMPORTANT:**
>
> Remettez une synthèse de deux pages maximum, en plus du code repliable. Une seule voie analytique doit être développée en profondeur. L’autre doit être résumée en trois phrases pour montrer que vous comprenez la différence de cible et de mesures.

## Vérification finale

La voie choisie correspond à la décision.

La période test est entièrement postérieure à l’entraînement.

Une référence simple est présente.

Les mesures conviennent au type de cible.

La recommandation comporte une limite et une règle de suivi.
