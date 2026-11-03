# Compléments facultatifs - Module 10

Ce cahier conserve des explications utiles de la régression logistique et ouvre sur d’autres méthodes. Il ne s’ajoute pas aux cinq activités guidées. Le code ci-dessous utilise les mêmes données et partitions que la démonstration.

## Cotes, logit et rapport de cotes

Pour p = 0,20, la cote est 0,25. Multiplier cette cote par 2 donne 0,50, qui correspond à p = 1/3 et non à 0,40. Le logit est le logarithme d’une cote, pas le logarithme d’un rapport de deux cotes; une différence de logits correspond au logarithme d’un rapport de cotes.

``` r
p <- 0.20
cote <- p / (1 - p)
nouvelle_cote <- 2 * cote
nouvelle_probabilite <- nouvelle_cote / (1 + nouvelle_cote)
c(cote = cote, nouvelle_cote = nouvelle_cote, nouvelle_probabilite = nouvelle_probabilite)
```

                    cote        nouvelle_cote nouvelle_probabilite
               0.2500000            0.5000000            0.3333333

## Vraisemblance, déviance et incertitude

Pour des réponses binaires indépendantes conditionnellement aux prédicteurs, la vraisemblance multiplie les termes pᵢ pour les événements et 1 − pᵢ pour les non-événements. `glm` estime les coefficients par maximum de vraisemblance. La déviance permet notamment de comparer des modèles emboîtés sous leurs hypothèses; elle ne garantit pas une bonne prévision hors échantillon. Les intervalles et tests de Wald reposent sur des approximations et ne résolvent pas les biais de sélection ou la confusion causale. Les pseudo-R² ne s’interprètent pas comme la proportion de variance expliquée en régression linéaire. Une calibration par groupes ou un test de Hosmer-Lemeshow ne prouve pas à lui seul la validité du modèle.

``` r
library(tidyverse)

racines <- c(".", "modules/semaine-10-classification-modeles-avances")
racine <- racines[file.exists(file.path(racines, "data/fidelisation_clients_quebec.csv"))][1]
stopifnot(!is.na(racine))
clients <- read_csv(file.path(racine, "data/fidelisation_clients_quebec.csv"), show_col_types = FALSE) |>
  mutate(type_contrat = factor(type_contrat, levels = c("annuel", "mensuel")),
         rabais_actuel = factor(rabais_actuel, levels = c("aucun", "fidélité", "rétention")))
stopifnot(nrow(clients) == 650, !anyDuplicated(clients$client_id),
          !anyNA(clients), all(clients$depart_90j %in% c(0, 1)))
set.seed(210110)
clients <- clients |> group_by(depart_90j) |>
  mutate(tirage = sample.int(n()),
         partition = case_when(tirage <= floor(0.60 * n()) ~ "apprentissage",
                               tirage <= floor(0.80 * n()) ~ "validation",
                               TRUE ~ "test")) |> ungroup()
apprentissage <- clients |> filter(partition == "apprentissage")
validation <- clients |> filter(partition == "validation")
test <- clients |> filter(partition == "test")
stopifnot(length(intersect(apprentissage$client_id, validation$client_id)) == 0,
          length(intersect(apprentissage$client_id, test$client_id)) == 0,
          length(intersect(validation$client_id, test$client_id)) == 0)
clients |> count(partition, depart_90j)
```

    # A tibble: 6 × 3
      partition     depart_90j     n
      <chr>              <dbl> <int>
    1 apprentissage          0   271
    2 apprentissage          1   118
    3 test                   0    91
    4 test                   1    40
    5 validation             0    90
    6 validation             1    40

``` r
modele <- glm(depart_90j ~ anciennete_mois + utilisation_mensuelle + tickets_service_6m +
                satisfaction + type_contrat + rabais_actuel,
              data = apprentissage, family = binomial())
stopifnot(modele$converged, all(is.finite(coef(modele))))
exp(coef(modele))
```

               (Intercept)        anciennete_mois  utilisation_mensuelle
                89.1555181              0.9698880              0.9025786
        tickets_service_6m           satisfaction    type_contratmensuel
                 1.4428952              0.5410943              1.9203206
     rabais_actuelfidélité rabais_actuelrétention
                 0.8721358              1.7765345

``` r
profils <- tibble(anciennete_mois = c(24, 24), utilisation_mensuelle = c(12, 12),
                  tickets_service_6m = c(1, 3), satisfaction = c(7, 7),
                  type_contrat = factor(c("mensuel", "mensuel"), levels = levels(clients$type_contrat)),
                  rabais_actuel = factor(c("aucun", "aucun"), levels = levels(clients$rabais_actuel)))
profils |> mutate(probabilite = predict(modele, newdata = profils, type = "response")) |>
  select(tickets_service_6m, probabilite)
```

    # A tibble: 2 × 2
      tickets_service_6m probabilite
                   <dbl>       <dbl>
    1                  1       0.320
    2                  3       0.495

``` r
resume <- summary(modele)$coefficients
resume
```

                              Estimate  Std. Error    z value     Pr(>|z|)
    (Intercept)             4.49038224 1.022143942  4.3931017 1.117448e-05
    anciennete_mois        -0.03057469 0.008373693 -3.6512785 2.609381e-04
    utilisation_mensuelle  -0.10249946 0.026440917 -3.8765470 1.059494e-04
    tickets_service_6m      0.36665166 0.105978140  3.4596914 5.407948e-04
    satisfaction           -0.61416174 0.114655057 -5.3566041 8.480067e-08
    type_contratmensuel     0.65249216 0.287805250  2.2671308 2.338223e-02
    rabais_actuelfidélité  -0.13681009 0.297872407 -0.4592909 6.460253e-01
    rabais_actuelrétention  0.57466453 0.344638936  1.6674394 9.542707e-02

``` r
# Intervalle de Wald pour les log-cotes, puis transformation en rapport de cotes.
estimation <- coef(modele)
erreur_type <- sqrt(diag(vcov(modele)))
tibble(terme = names(estimation), rapport_cotes = exp(estimation),
       borne_basse = exp(estimation - 1.96 * erreur_type),
       borne_haute = exp(estimation + 1.96 * erreur_type))
```

    # A tibble: 8 × 4
      terme                  rapport_cotes borne_basse borne_haute
      <chr>                          <dbl>       <dbl>       <dbl>
    1 (Intercept)                   89.2        12.0       661.
    2 anciennete_mois                0.970       0.954       0.986
    3 utilisation_mensuelle          0.903       0.857       0.951
    4 tickets_service_6m             1.44        1.17        1.78
    5 satisfaction                   0.541       0.432       0.677
    6 type_contratmensuel            1.92        1.09        3.38
    7 rabais_actuelfidélité          0.872       0.486       1.56
    8 rabais_actuelrétention         1.78        0.904       3.49

``` r
modele_nul <- glm(depart_90j ~ 1, data = apprentissage, family = binomial())
anova(modele_nul, modele, test = "Chisq")
```

    Analysis of Deviance Table

    Model 1: depart_90j ~ 1
    Model 2: depart_90j ~ anciennete_mois + utilisation_mensuelle + tickets_service_6m +
        satisfaction + type_contrat + rabais_actuel
      Resid. Df Resid. Dev Df Deviance  Pr(>Chi)
    1       388     477.43
    2       381     384.67  7   92.769 < 2.2e-16 ***
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

## ROC et AUC, en validation

La courbe ROC décrit sensibilité et taux de faux positifs pour plusieurs seuils. L’AUC résume le classement des scores, sans choisir une règle ni assurer une bonne calibration. Les égalités de scores comptent pour une demi-paire. Un score élevé ne remplace pas le calcul des coûts.

``` r
mesures_seuil <- function(observe, probabilite, seuil, cout_fp = 1, cout_fn = 4) {
  stopifnot(length(observe) == length(probabilite), all(observe %in% c(0, 1)),
            all(is.finite(probabilite)), all(probabilite >= 0 & probabilite <= 1))
  predit <- as.integer(probabilite >= seuil)
  vp <- sum(predit == 1 & observe == 1); fp <- sum(predit == 1 & observe == 0)
  vn <- sum(predit == 0 & observe == 0); fn <- sum(predit == 0 & observe == 1)
  ratio <- function(a, b) if (b == 0) NA_real_ else a / b
  tibble(seuil, VP = vp, FP = fp, VN = vn, FN = fn,
         exactitude = ratio(vp + vn, length(observe)), sensibilite = ratio(vp, vp + fn),
         specificite = ratio(vn, vn + fp), precision = ratio(vp, vp + fp),
         proportion_ciblee = ratio(vp + fp, length(observe)), cout = cout_fp * fp + cout_fn * fn)
}
```

``` r
validation <- validation |> mutate(probabilite = predict(modele, newdata = validation, type = "response"))
resultats_validation <- bind_rows(mesures_seuil(validation$depart_90j, validation$probabilite, 0.30),
                                 mesures_seuil(validation$depart_90j, validation$probabilite, 0.50))
resultats_validation |> select(seuil, VP, FP, VN, FN, cout)
```

    # A tibble: 2 × 6
      seuil    VP    FP    VN    FN  cout
      <dbl> <int> <int> <int> <int> <dbl>
    1   0.3    30    19    71    10    59
    2   0.5    17     7    83    23    99

``` r
resultats_validation |> select(seuil, sensibilite, specificite, precision, proportion_ciblee)
```

    # A tibble: 2 × 5
      seuil sensibilite specificite precision proportion_ciblee
      <dbl>       <dbl>       <dbl>     <dbl>             <dbl>
    1   0.3       0.75        0.789     0.612             0.377
    2   0.5       0.425       0.922     0.708             0.185

``` r
seuil_retenu <- resultats_validation |> arrange(cout, seuil) |> slice(1) |> pull(seuil)
seuil_retenu
```

    [1] 0.3

``` r
positifs <- validation$probabilite[validation$depart_90j == 1]
negatifs <- validation$probabilite[validation$depart_90j == 0]
auc <- mean(outer(positifs, negatifs, ">")) + 0.5 * mean(outer(positifs, negatifs, "=="))
auc
```

    [1] 0.8561111

``` r
seuils <- seq(0, 1, by = 0.02)
roc <- map_dfr(seuils, ~ mesures_seuil(validation$depart_90j, validation$probabilite, .x)) |>
  mutate(taux_faux_positifs = 1 - specificite)
ggplot(roc, aes(taux_faux_positifs, sensibilite)) + geom_path() +
  geom_abline(linetype = 2) + coord_equal() +
  labs(x = "Taux de faux positifs", y = "Sensibilité") + theme_minimal()
```

![](complements_files/figure-html/unnamed-chunk-7-1.png)

## Ouverture : arbre de classification

Un arbre sépare des profils par règles successives. La comparaison ci-dessous est exploratoire sur la validation et ne transforme pas l’arbre en méthode principale ni en nouveau modèle évalué sur le test. Installer `rpart` au besoin; pour une vraie sélection, prévoir la complexité et une évaluation indépendante.

``` r
library(rpart)
arbre <- rpart(factor(depart_90j, levels = c(0, 1)) ~ anciennete_mois + utilisation_mensuelle +
                 tickets_service_6m + satisfaction + type_contrat + rabais_actuel,
               data = apprentissage, method = "class", control = rpart.control(cp = 0.02))
prob_arbre <- predict(arbre, newdata = validation, type = "prob")[, "1"]
evaluation_arbre <- mesures_seuil(validation$depart_90j, prob_arbre, 0.30)
evaluation_arbre |> select(seuil, VP, FP, VN, FN, cout)
```

    # A tibble: 1 × 6
      seuil    VP    FP    VN    FN  cout
      <dbl> <int> <int> <int> <int> <dbl>
    1   0.3    24    27    63    16    91

``` r
evaluation_arbre |> select(sensibilite, specificite, precision, proportion_ciblee)
```

    # A tibble: 1 × 4
      sensibilite specificite precision proportion_ciblee
            <dbl>       <dbl>     <dbl>             <dbl>
    1         0.6         0.7     0.471             0.392

``` r
plot(arbre, uniform = TRUE); text(arbre, use.n = TRUE, cex = 0.8)
```

![](complements_files/figure-html/unnamed-chunk-8-1.png)

## Classification temporelle : retards et calendrier

La séance antérieure combinait une cible binaire, des retards et des termes sinus et cosinus. Voici une adaptation aux données de succursales : les mois sont connus, et les ruptures du mois précédent sont calculées séparément pour chaque succursale. Leurs dates de disponibilité doivent être vérifiées en pratique. Un retard peut devenir inconnu quand l’horizon dépasse les observations disponibles. Le bloc de 2024 sert ici à illustrer, pas à évaluer définitivement un modèle choisi parmi plusieurs.

``` r
service_temps <- read_csv(file.path(racine, "data/cas_integrateur_quebec.csv"), show_col_types = FALSE) |>
  mutate(date = as.Date(date)) |> arrange(succursale, date) |>
  group_by(succursale) |>
  mutate(ruptures_retard_1 = lag(ruptures_stock),
         etiquette_precedente = lag(service_insuffisant_mois_suivant),
         sinus_mois = sin(2 * pi * lubridate::month(date) / 12),
         cosinus_mois = cos(2 * pi * lubridate::month(date) / 12)) |> ungroup()
ancien <- service_temps |> filter(date <= as.Date("2023-11-01"), !is.na(ruptures_retard_1))
validation_temps <- service_temps |> filter(date >= as.Date("2024-01-01"), date <= as.Date("2024-11-01"))
modele_temps <- glm(service_insuffisant_mois_suivant ~ ruptures_retard_1 + sinus_mois + cosinus_mois,
                    data = ancien, family = binomial())
prob_temps <- predict(modele_temps, newdata = validation_temps, type = "response")
mesures_temps <- mesures_seuil(validation_temps$service_insuffisant_mois_suivant, prob_temps, 0.30)
mesures_temps |> select(seuil, VP, FP, VN, FN, cout)
```

    # A tibble: 1 × 6
      seuil    VP    FP    VN    FN  cout
      <dbl> <int> <int> <int> <int> <dbl>
    1   0.3     0     0    34    10    40

``` r
mesures_temps |> select(sensibilite, specificite, precision, proportion_ciblee)
```

    # A tibble: 1 × 4
      sensibilite specificite precision proportion_ciblee
            <dbl>       <dbl>     <dbl>             <dbl>
    1           0           1        NA                 0

``` r
# Référence naïve : réutiliser l’étiquette du mois précédent si elle est connue.
stopifnot(!anyNA(validation_temps$etiquette_precedente))
naive_temps <- mesures_seuil(validation_temps$service_insuffisant_mois_suivant,
                             validation_temps$etiquette_precedente, 0.5)
naive_temps |> select(VP, FP, VN, FN, cout)
```

    # A tibble: 1 × 5
         VP    FP    VN    FN  cout
      <int> <int> <int> <int> <dbl>
    1     1     8    26     9    44

Les termes cycliques d’une période de 12 mois sont choisis pour cette illustration. La règle naïve n’est réalisable que si l’étiquette précédente est effectivement connue à l’origine. Une cible binaire peut aussi être créée par un seuil appliqué à une mesure continue; un retard de la mesure originale conserve davantage d’information que son indicateur, lorsque cette mesure est disponible. Une faible valeur p ne prouve pas une cause; une grande valeur p ne prouve pas l’absence d’association. Tester de nombreux retards et périodes sur le même bloc peut favoriser le surajustement.

## Réseau de neurones pour une classe binaire

Un réseau comprend des entrées, une couche cachée et une sortie. Il peut représenter des relations non linéaires, mais sa complexité ne garantit pas une meilleure prévision. Dans cet exemple, les quatre prédicteurs numériques sont centrés et réduits avec les moyennes et écarts-types de l’apprentissage uniquement. Les paramètres, le nombre de neurones et la graine sont fixés pour illustrer; la comparaison à 0,30 se fait seulement en validation. Installer `nnet` au besoin.

``` r
library(nnet)
variables <- c("anciennete_mois", "utilisation_mensuelle", "tickets_service_6m", "satisfaction")
x_a <- as.matrix(apprentissage[, variables]); x_v <- as.matrix(validation[, variables])
centres <- colMeans(x_a); ecarts <- apply(x_a, 2, sd)
stopifnot(all(ecarts > 0))
x_a <- scale(x_a, center = centres, scale = ecarts)
x_v <- scale(x_v, center = centres, scale = ecarts)
set.seed(210110)
reseau <- nnet(x_a, apprentissage$depart_90j, size = 3, entropy = TRUE,
               decay = 0.1, maxit = 500, trace = FALSE)
reseau$convergence
```

    [1] 0

``` r
prob_reseau <- as.numeric(predict(reseau, x_v, type = "raw"))
mesures_reseau <- mesures_seuil(validation$depart_90j, prob_reseau, 0.30)
mesures_reseau |> select(seuil, VP, FP, VN, FN, cout)
```

    # A tibble: 1 × 6
      seuil    VP    FP    VN    FN  cout
      <dbl> <int> <int> <int> <int> <dbl>
    1   0.3    27    27    63    13    79

``` r
mesures_reseau |> select(sensibilite, specificite, precision, proportion_ciblee)
```

    # A tibble: 1 × 4
      sensibilite specificite precision proportion_ciblee
            <dbl>       <dbl>     <dbl>             <dbl>
    1       0.675         0.7       0.5             0.415

Un code de convergence égal à 0 indique l’arrêt normal de l’optimisation, sans prouver que le modèle est bien adapté. Pour sélectionner réellement un réseau ou ses réglages, il faut prévoir une validation appropriée et une évaluation finale indépendante.

## Réseau autorégressif pour une série continue

La présentation et un exercice anciens utilisaient `forecast::nnetar` pour une série numérique. Cette ouverture est distincte de la classification : la sortie ci-dessous prévoit des ventes continues. Un réseau NNAR utilise des retards comme entrées et peut inclure des prédicteurs externes avec `xreg`; leurs valeurs futures devraient alors être fournies. La normalisation par défaut de `nnetar` soustrait les moyennes et divise par les écarts-types des entrées, plutôt que de toujours ramener les valeurs à un intervalle fixe. Installer `forecast` au besoin.

``` r
library(forecast)
ventes_mensuelles <- read_csv(file.path(racine, "data/cas_integrateur_quebec.csv"), show_col_types = FALSE) |>
  mutate(date = as.Date(date)) |> group_by(date) |>
  summarise(ventes = sum(ventes), .groups = "drop") |> arrange(date)
ventes_ts <- ts(ventes_mensuelles$ventes, start = c(2020, 1), frequency = 12)
serie_train <- window(ventes_ts, end = c(2023, 12))
serie_validation <- window(ventes_ts, start = c(2024, 1), end = c(2024, 12))
set.seed(210110)
reseau_ts <- nnetar(serie_train, p = 2, P = 1, size = 2, repeats = 3,
                    scale.inputs = TRUE, maxit = 2000)
vapply(reseau_ts$model, function(x) x$convergence, integer(1))
```

    [1] 0 0 0

``` r
prevision_ts <- forecast(reseau_ts, h = 12)$mean
reference_ts <- snaive(serie_train, h = 12)$mean
tibble(methode = c("NNAR", "Naïf saisonnier"),
       MAE = c(mean(abs(serie_validation - prevision_ts)), mean(abs(serie_validation - reference_ts))),
       RMSE = c(sqrt(mean((serie_validation - prevision_ts)^2)), sqrt(mean((serie_validation - reference_ts)^2))))
```

    # A tibble: 2 × 3
      methode            MAE   RMSE
      <chr>            <dbl>  <dbl>
    1 NNAR            37136. 44236.
    2 Naïf saisonnier 55387. 65907.

Les trois initialisations donnent des modèles dont les prévisions sont moyennées. Le vecteur affiché indique leur convergence : 0 est un arrêt normal, 1 signale que la limite d’itérations a été atteinte. Une prévision à plusieurs pas utilise récursivement des valeurs prévues quand les retards futurs sont inconnus. Cette comparaison sur douze mois et des données simulées ne démontre pas la supériorité générale des réseaux; les observations de 2025 ne sont pas utilisées ici.

Les forêts aléatoires combinent plusieurs arbres; elles demandent d’autres choix et vérifications. Elles ne sont pas requises dans le socle. La discrétisation systématique des variables continues n’est pas nécessaire et peut perdre de l’information; toute transformation apprise doit être estimée sans le test.
