# Guide en classe - Atelier 04

## Préparation

``` r
library(tidyverse)
library(broom)
library(lubridate)

data_path <- if (file.exists("data/cas_integrateur_quebec.csv")) {
  "data/cas_integrateur_quebec.csv"
} else {
  "modules/atelier-04-recapitulation/data/cas_integrateur_quebec.csv"
}

cas <- read_csv(data_path, show_col_types = FALSE) |>
  mutate(
    date = as.Date(date),
    succursale = factor(succursale),
    promotion = factor(promotion, levels = c("non", "oui")),
    mois = factor(month(date), levels = 1:12)
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
    taux_service_insuffisant_mois_suivant = mean(service_insuffisant_mois_suivant),
    .groups = "drop"
  )
```

    # A tibble: 4 × 4
      succursale ventes_moyennes attente_moyenne taux_service_insuffisant_mois_sui…¹
      <fct>                <dbl>           <dbl>                               <dbl>
    1 Gatineau           170130.            4.30                              0.0833
    2 Montréal           257110.            4.28                              0.125
    3 Québec             195407.            4.35                              0.25
    4 Sherbrooke         147373.            4.44                              0.208
    # ℹ abbreviated name: ¹​taux_service_insuffisant_mois_suivant

> **TIP:**
>
> Conservez un graphique et un tableau qui répondent directement à votre question.

## Voie A - Prévoir une réponse continue

### Modèle et référence

``` r
modele_ventes <- lm(
  ventes ~ indice_temps + succursale + mois + promotion,
  data = entrainement
)

reference_saisonniere <- cas |>
  transmute(
    date = date %m+% years(1),
    succursale,
    reference_saisonniere = ventes
  )

evaluation_ventes <- test |>
  mutate(prevision_modele = predict(modele_ventes, newdata = test)) |>
  left_join(reference_saisonniere, by = c("date", "succursale")) |>
  pivot_longer(
    c(prevision_modele, reference_saisonniere),
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
      methode                  MAE   RMSE  biais
      <chr>                  <dbl>  <dbl>  <dbl>
    1 prevision_modele       8949. 11942. -1566.
    2 reference_saisonniere 23669  28501.  4928.

> **WARNING:**
>
> La voie A utilise seulement le temps, la succursale, le mois et une promotion planifiée. L’achalandage et les ruptures de stock du mois à prévoir ne sont pas encore observés et créeraient une fuite d’information. Si la promotion n’est pas décidée à l’origine de la prévision, elle doit être fixée selon un scénario explicite.

### Interprétation

``` r
tidy(modele_ventes, conf.int = TRUE) |>
  filter(term %in% c("indice_temps", "promotionoui"))
```

    # A tibble: 2 × 7
      term         estimate std.error statistic  p.value conf.low conf.high
      <chr>           <dbl>     <dbl>     <dbl>    <dbl>    <dbl>     <dbl>
    1 indice_temps     426.      38.5      11.0 6.37e-23     350.      502.
    2 promotionoui   35840.    1488.       24.1 5.59e-64   32907.    38772.

Les coefficients décrivent des associations conditionnelles. Ils ne démontrent pas qu’imposer une promotion ou réduire artificiellement une variable produira exactement le changement estimé.

## Voie B - Détecter une réponse binaire

### Modèle et seuil de capacité

``` r
modele_service <- glm(
  service_insuffisant_mois_suivant ~ temps_attente + ruptures_stock +
    satisfaction + taux_utilisation,
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
  count(observe = service_insuffisant_mois_suivant, prediction)

matrice
```

    # A tibble: 4 × 3
      observe prediction     n
        <dbl>      <int> <int>
    1       0          0    36
    2       0          1     4
    3       1          0     2
    4       1          1     6

``` r
evaluation_service |>
  summarise(
    VP = sum(prediction == 1 & service_insuffisant_mois_suivant == 1),
    FP = sum(prediction == 1 & service_insuffisant_mois_suivant == 0),
    VN = sum(prediction == 0 & service_insuffisant_mois_suivant == 0),
    FN = sum(prediction == 0 & service_insuffisant_mois_suivant == 1)
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
    1     6     4    36     2        0.75         0.9       0.6             0.208

Le modèle utilise les conditions observées pendant le mois courant pour estimer le risque de service insuffisant au mois suivant. La cible est donc postérieure aux prédicteurs, ce qui correspond à une décision préventive.

### Vérifier la répartition de l’intervention

``` r
evaluation_service |>
  group_by(succursale) |>
  summarise(
    observations = n(),
    proportion_ciblee = mean(prediction),
    taux_observe = mean(service_insuffisant_mois_suivant),
    precision = if_else(
      sum(prediction) > 0,
      sum(prediction == 1 & service_insuffisant_mois_suivant == 1) / sum(prediction),
      NA_real_
    ),
    .groups = "drop"
  )
```

    # A tibble: 4 × 5
      succursale observations proportion_ciblee taux_observe precision
      <fct>             <int>             <dbl>        <dbl>     <dbl>
    1 Gatineau             12            0.25         0            0
    2 Montréal             12            0.167        0.0833       0.5
    3 Québec               12            0.0833       0.25         1
    4 Sherbrooke           12            0.333        0.333        1

> **WARNING:**
>
> Une règle de ciblage peut concentrer les interventions dans une succursale. Avant de la déployer, comparez les taux de ciblage et la précision par succursale, documentez les faux positifs et vérifiez que l’intervention proposée est proportionnée au risque. Le modèle sert à prioriser une vérification, pas à sanctionner automatiquement une équipe.

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
