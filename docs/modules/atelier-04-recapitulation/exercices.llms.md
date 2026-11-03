# Transfert et pratiques - Laboratoire 04

Ce transfert facultatif reprend les clients fictifs du module 10 pour une décision de fidélisation. Il demande de comparer une capacité et un seuil, puis de surveiller le ciblage par type de contrat. Faites une tentative avant les corrigés. Le partage et ses résultats ont déjà été examinés : ce ne sont pas de nouvelles données de test indépendantes.

## Préparation

``` r
library(tidyverse)

racines <- c(".", "modules/atelier-04-recapitulation")
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

## Exercice 1 - Aligner question et mesure

Associez chaque question à une cible, à une séparation et à deux mesures : valeur mensuelle moyenne, départ dans les 90 jours, ciblage de 15 % des clients et performance par type de contrat. Pourquoi l’exactitude seule ne répond-elle pas à la capacité?

> **TIP:**
>
> La valeur mensuelle est continue et peut se lire avec MAE et RMSE sur un bloc approprié. Le départ est binaire : cible positive, sensibilité et précision. Les 15 % les plus risqués exigent un classement et une règle de départage. Par contrat, rapporter effectifs, proportion ciblée et erreurs; l’exactitude globale ne décrit pas le nombre ciblé ni les départs détectés.

## Exercice 2 - Critiquer une conclusion

« Le coefficient du contrat mensuel est positif. Il faut convertir tous les clients aux contrats annuels pour empêcher les départs. » Relevez quatre limites, puis vérifiez deux probabilités de profils fictifs.

> **TIP:**
>
> ``` r
> modele <- glm(depart_90j ~ anciennete_mois + utilisation_mensuelle + tickets_service_6m +
>                 satisfaction + type_contrat + rabais_actuel,
>               data = apprentissage, family = binomial())
> stopifnot(modele$converged, all(is.finite(coef(modele))))
> exp(coef(modele))
> ```
>
>                (Intercept)        anciennete_mois  utilisation_mensuelle
>                 89.1555181              0.9698880              0.9025786
>         tickets_service_6m           satisfaction    type_contratmensuel
>                  1.4428952              0.5410943              1.9203206
>      rabais_actuelfidélité rabais_actuelrétention
>                  0.8721358              1.7765345
>
> ``` r
> profils <- tibble(anciennete_mois = c(24, 24), utilisation_mensuelle = c(12, 12),
>                   tickets_service_6m = c(1, 3), satisfaction = c(7, 7),
>                   type_contrat = factor(c("mensuel", "mensuel"), levels = levels(clients$type_contrat)),
>                   rabais_actuel = factor(c("aucun", "aucun"), levels = levels(clients$rabais_actuel)))
> profils |> mutate(probabilite = predict(modele, newdata = profils, type = "response")) |>
>   select(tickets_service_6m, probabilite)
> ```
>
>     # A tibble: 2 × 2
>       tickets_service_6m probabilite
>                    <dbl>       <dbl>
>     1                  1       0.320
>     2                  3       0.495
>
> Le coefficient est conditionnel aux variables du modèle; il ne démontre pas l’effet causal d’un changement de contrat. La sélection des clients, le coût, la faisabilité et la stabilité future sont inconnus. Une action prudente demande une évaluation adaptée plutôt qu’une conversion générale.

## Exercice 3 - Comparer seuil et capacité

Reprenez la règle choisie sur la validation du module 10 et la règle préétablie des 15 % les plus risqués. Calculez les résultats sur le bloc client réutilisé, sans choisir ensuite une nouvelle règle à partir de ce bloc.

> **TIP:**
>
> ``` r
> mesures_seuil <- function(observe, probabilite, seuil, cout_fp = 1, cout_fn = 4) {
>   stopifnot(length(observe) == length(probabilite), all(observe %in% c(0, 1)),
>             all(is.finite(probabilite)), all(probabilite >= 0 & probabilite <= 1))
>   predit <- as.integer(probabilite >= seuil)
>   vp <- sum(predit == 1 & observe == 1); fp <- sum(predit == 1 & observe == 0)
>   vn <- sum(predit == 0 & observe == 0); fn <- sum(predit == 0 & observe == 1)
>   ratio <- function(a, b) if (b == 0) NA_real_ else a / b
>   tibble(seuil, VP = vp, FP = fp, VN = vn, FN = fn,
>          exactitude = ratio(vp + vn, length(observe)), sensibilite = ratio(vp, vp + fn),
>          specificite = ratio(vn, vn + fp), precision = ratio(vp, vp + fp),
>          proportion_ciblee = ratio(vp + fp, length(observe)), cout = cout_fp * fp + cout_fn * fn)
> }
> ```
>
> ``` r
> validation <- validation |> mutate(probabilite = predict(modele, newdata = validation, type = "response"))
> resultats_validation <- bind_rows(mesures_seuil(validation$depart_90j, validation$probabilite, 0.30),
>                                  mesures_seuil(validation$depart_90j, validation$probabilite, 0.50))
> resultats_validation |> select(seuil, VP, FP, VN, FN, cout)
> ```
>
>     # A tibble: 2 × 6
>       seuil    VP    FP    VN    FN  cout
>       <dbl> <int> <int> <int> <int> <dbl>
>     1   0.3    30    19    71    10    59
>     2   0.5    17     7    83    23    99
>
> ``` r
> resultats_validation |> select(seuil, sensibilite, specificite, precision, proportion_ciblee)
> ```
>
>     # A tibble: 2 × 5
>       seuil sensibilite specificite precision proportion_ciblee
>       <dbl>       <dbl>       <dbl>     <dbl>             <dbl>
>     1   0.3       0.75        0.789     0.612             0.377
>     2   0.5       0.425       0.922     0.708             0.185
>
> ``` r
> seuil_retenu <- resultats_validation |> arrange(cout, seuil) |> slice(1) |> pull(seuil)
> seuil_retenu
> ```
>
>     [1] 0.3
>
> ``` r
> test <- test |> mutate(probabilite = predict(modele, newdata = test, type = "response"))
> resultat_test <- mesures_seuil(test$depart_90j, test$probabilite, seuil_retenu)
> resultat_test |> select(seuil, VP, FP, VN, FN, cout)
> ```
>
>     # A tibble: 1 × 6
>       seuil    VP    FP    VN    FN  cout
>       <dbl> <int> <int> <int> <int> <dbl>
>     1   0.3    22    28    63    18   100
>
> ``` r
> resultat_test |> select(seuil, sensibilite, specificite, precision, proportion_ciblee)
> ```
>
>     # A tibble: 1 × 5
>       seuil sensibilite specificite precision proportion_ciblee
>       <dbl>       <dbl>       <dbl>     <dbl>             <dbl>
>     1   0.3        0.55       0.692      0.44             0.382
>
> ``` r
> # Référence : toujours prédire la classe majoritaire de l’apprentissage.
> # Une égalité est départagée en faveur de la classe 0.
> classe_majoritaire <- as.integer(mean(apprentissage$depart_90j) > 0.5)
> seuil_reference <- if (classe_majoritaire == 1) 0 else 1.01
> reference <- mesures_seuil(test$depart_90j, test$probabilite, seuil_reference)
> reference |> select(VP, FP, VN, FN, exactitude, sensibilite, precision)
> ```
>
>     # A tibble: 1 × 7
>          VP    FP    VN    FN exactitude sensibilite precision
>       <int> <int> <int> <int>      <dbl>       <dbl>     <dbl>
>     1     0     0    91    40      0.695           0        NA
>
> ``` r
> calibration <- test |> mutate(groupe = ntile(probabilite, 5)) |> group_by(groupe) |>
>   summarise(n = n(), probabilite_moyenne = mean(probabilite),
>             frequence_depart = mean(depart_90j), .groups = "drop")
> calibration
> ```
>
>     # A tibble: 5 × 4
>       groupe     n probabilite_moyenne frequence_depart
>        <int> <int>               <dbl>            <dbl>
>     1      1    27              0.0643            0.185
>     2      2    26              0.137             0.115
>     3      3    26              0.233             0.346
>     4      4    26              0.369             0.346
>     5      5    26              0.573             0.538
>
> ``` r
> brier <- mean((test$probabilite - test$depart_90j)^2)
> brier
> ```
>
>     [1] 0.1910233
>
> ``` r
> # Règle alternative fixée à l’avance : au plus 15 % des clients test.
> # En cas d’égalité de probabilités, trier selon client_id.
> n_capacite <- floor(0.15 * nrow(test))
> selection <- test |> arrange(desc(probabilite), client_id) |> slice_head(n = n_capacite)
> tibble(clients = nrow(test), cibles = nrow(selection),
>        departs_detectes = sum(selection$depart_90j), precision = mean(selection$depart_90j))
> ```
>
>     # A tibble: 1 × 4
>       clients cibles departs_detectes precision
>         <int>  <int>            <dbl>     <dbl>
>     1     131     19               12     0.632
>
> Les 15 % sont arrondis à l’entier inférieur et les égalités sont départagées par identifiant. Le bloc client est celui déjà examiné au module 10 : il ne fournit pas un nouveau test indépendant. Un risque de départ ne quantifie pas l’effet d’un contact.

## Exercice 4 - Comparer deux contraintes

Deux règles ont la même exactitude : la première détecte 75 % des départs et cible 30 % des clients; la seconde détecte 55 % et cible 12 %. Que faire avec une capacité de 15 %? Et si un départ manqué coûte davantage?

> **TIP:**
>
> Avec une capacité stricte de 15 %, la seconde respecte la contrainte et la première ne la respecte pas telle quelle. Si manquer un départ coûte davantage, la première détecte davantage, mais il faut connaître les effectifs, coûts et contraintes avant une décision. Ajuster la première règle pour respecter la capacité exigerait une nouvelle évaluation.

## Exercice 5 - Surveiller par type de contrat

Comparez le nombre ciblé par contrat pour les deux règles. Proposez une surveillance des erreurs, de la calibration et des données manquantes.

> **TIP:**
>
> ``` r
> test |> mutate(selection_seuil = probabilite >= seuil_retenu,
>                selection_15 = client_id %in% selection$client_id) |>
>   group_by(type_contrat) |>
>   summarise(clients = n(), cible_seuil = sum(selection_seuil),
>             cible_capacite = sum(selection_15), departs = sum(depart_90j), .groups = "drop")
> ```
>
>     # A tibble: 2 × 5
>       type_contrat clients cible_seuil cible_capacite departs
>       <fct>          <int>       <int>          <int>   <dbl>
>     1 annuel            44           6              0       6
>     2 mensuel           87          44             19      34
>
> Les effectifs et taux de base peuvent différer. Les nombres ciblés ne démontrent pas à eux seuls un traitement équitable ou inéquitable. Vérifier les dénominateurs, les erreurs, la calibration et le contexte; suspendre la règle si les données indispensables deviennent indisponibles, selon un critère établi à l’avance.

## Exercice 6 - Fiche de gouvernance

Rédigez une fiche en six rubriques : objectif, données, validation, décision, surveillance et limites.

> **TIP:**
>
> Nommer l’événement et son horizon; l’origine, les variables et la population; la séparation et le caractère réutilisé du bloc; la règle et les coûts; les mesures et le contrôle des changements; les limites causales, opérationnelles et les données manquantes. Cette fiche est distincte du rapport principal.
