# Démonstrations R - Module 10

Le cas est fictif et porte sur un départ dans les 90 jours. Les coûts et la capacité sont des hypothèses d’exercice; un score de risque ne mesure pas l’effet d’un contact. Les trois partitions sont fixes pour tout le parcours. L’absence de date dans le fichier empêche de vérifier une validation chronologique réaliste.

## Préparation et cible

Dans le projet de départ, ouvrez `classification-clients.Rproj`. Pour consulter le projet entièrement résolu, ouvrez `demonstration-classification.Rproj` dans sa propre archive. Installez `tidyverse` si nécessaire et exécutez les blocs dans l’ordre à partir d’une session neuve. Classe positive : départ = 1. L’identifiant sert aux vérifications et aux égalités, pas comme prédicteur.

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

Les effectifs attendus sont 389, 130 et 131. La classe positive compte respectivement 118, 40 et 40 clients. La répartition est stratifiée et les effectifs sont entiers. Changer la graine modifierait les personnes présentes dans chaque groupe et les résultats des étapes suivantes.

## Régression et probabilités

Un rapport de cotes de 1,5 signifie des cotes multipliées par 1,5, pas une probabilité augmentée de 50 %. Les profils comparés sont hypothétiques. L’association conditionnelle n’est pas une preuve causale.

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

Le rapport de cotes pour un ticket supplémentaire vaut environ 1,443. Les deux profils ont respectivement un et trois tickets. Pour ces profils, passer de 32,0 % à 49,5 % représente environ 17,5 points de pourcentage. Le contrat est mensuel dans les deux cas et la catégorie de référence du coefficient de contrat est le contrat annuel.

## Matrices de confusion

Pour la classe positive 1 : VP = départ ciblé; FN = départ non ciblé; FP = non-départ ciblé; VN = non-départ non ciblé. La précision est indéfinie si aucun client n’est ciblé; la fonction retourne alors `NA` plutôt que 0.

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

Commencez par calculer les probabilités sur les 130 clients de validation. Un score exactement égal au seuil entraîne un contact.

``` r
validation <- validation |> mutate(probabilite = predict(modele, newdata = validation, type = "response"))
resultats_validation <- bind_rows(mesures_seuil(validation$depart_90j, validation$probabilite, 0.30),
                                 mesures_seuil(validation$depart_90j, validation$probabilite, 0.50))
resultats_validation |> select(seuil, VP, FP, VN, FN)
```

    # A tibble: 2 × 5
      seuil    VP    FP    VN    FN
      <dbl> <int> <int> <int> <int>
    1   0.3    30    19    71    10
    2   0.5    17     7    83    23

``` r
resultats_validation |> select(seuil, sensibilite, specificite, precision, proportion_ciblee)
```

    # A tibble: 2 × 5
      seuil sensibilite specificite precision proportion_ciblee
      <dbl>       <dbl>       <dbl>     <dbl>             <dbl>
    1   0.3       0.75        0.789     0.612             0.377
    2   0.5       0.425       0.922     0.708             0.185

À 0,30, 49 clients sont ciblés, dont 30 futurs départs. La sensibilité vaut 30/40 et la précision 30/49. À 0,50, il reste 24 contacts, dont 17 futurs départs. La sensibilité descend à 17/40 et la précision monte à 17/24. L’exemple illustratif sur 100 clients du diaporama sert à apprendre les définitions. Les deux matrices du rapport utilisent les 130 clients du fichier de validation.

## Choisir en validation

La validation sert au choix. Un faux négatif coûte ici 4 unités et un faux positif 1 unité, uniquement pour illustrer une décision; la comparaison n’est valide que pour ces hypothèses. En cas d’égalité, la règle fixe le seuil inférieur. Une fois le seuil choisi, ne pas l’ajuster en regardant le test.

``` r
resultats_validation |> select(seuil, FP, FN, cout)
```

    # A tibble: 2 × 4
      seuil    FP    FN  cout
      <dbl> <int> <int> <dbl>
    1   0.3    19    10    59
    2   0.5     7    23    99

``` r
seuil_retenu <- resultats_validation |> arrange(cout, seuil) |> slice(1) |> pull(seuil)
seuil_retenu
```

    [1] 0.3

La comparaison donne 59 unités à 0,30 et 99 à 0,50. Abaisser le seuil ajoute 12 faux positifs et évite 13 faux négatifs. À quatre unités par départ manqué, le gain net sur la validation vaut 13 × 4 − 12 = 40 unités. Le rapport de coûts est fictif. Une règle choisie pour le coût peut aussi demander plus d’appels que l’équipe ne peut en faire.

## Évaluer et communiquer

Le test estime la performance de la règle retenue sur ce partage fictif. La référence prédit toujours la classe majoritaire déterminée sur l’apprentissage, et non sur le test. La calibration compare, par groupes, probabilités moyennes et fréquences observées; les petits groupes et un seul partage limitent sa précision. Le score de Brier est la moyenne des carrés entre probabilités et résultats; plus petit n’implique pas à lui seul une bonne calibration. La règle des 15 % est une autre règle fixée avant le test, illustrative; l’observation des deux règles sur le même test ne justifie pas une nouvelle sélection sur ce test.

``` r
test <- test |> mutate(probabilite = predict(modele, newdata = test, type = "response"))
resultat_test <- mesures_seuil(test$depart_90j, test$probabilite, seuil_retenu)
resultat_test |> select(seuil, VP, FP, VN, FN, cout)
```

    # A tibble: 1 × 6
      seuil    VP    FP    VN    FN  cout
      <dbl> <int> <int> <int> <int> <dbl>
    1   0.3    22    28    63    18   100

``` r
resultat_test |> select(seuil, sensibilite, specificite, precision, proportion_ciblee)
```

    # A tibble: 1 × 5
      seuil sensibilite specificite precision proportion_ciblee
      <dbl>       <dbl>       <dbl>     <dbl>             <dbl>
    1   0.3        0.55       0.692      0.44             0.382

``` r
# Référence : toujours prédire la classe majoritaire de l’apprentissage.
# Une égalité est départagée en faveur de la classe 0.
classe_majoritaire <- as.integer(mean(apprentissage$depart_90j) > 0.5)
seuil_reference <- if (classe_majoritaire == 1) 0 else 1.01
reference <- mesures_seuil(test$depart_90j, test$probabilite, seuil_reference)
reference |> select(VP, FP, VN, FN, exactitude, sensibilite, precision)
```

    # A tibble: 1 × 7
         VP    FP    VN    FN exactitude sensibilite precision
      <int> <int> <int> <int>      <dbl>       <dbl>     <dbl>
    1     0     0    91    40      0.695           0        NA

``` r
calibration <- test |> mutate(groupe = ntile(probabilite, 5)) |> group_by(groupe) |>
  summarise(n = n(), probabilite_moyenne = mean(probabilite),
            frequence_depart = mean(depart_90j), .groups = "drop")
calibration
```

    # A tibble: 5 × 4
      groupe     n probabilite_moyenne frequence_depart
       <int> <int>               <dbl>            <dbl>
    1      1    27              0.0643            0.185
    2      2    26              0.137             0.115
    3      3    26              0.233             0.346
    4      4    26              0.369             0.346
    5      5    26              0.573             0.538

``` r
brier <- mean((test$probabilite - test$depart_90j)^2)
brier
```

    [1] 0.1910233

``` r
# Règle alternative fixée à l’avance : au plus 15 % des clients test.
# En cas d’égalité de probabilités, trier selon client_id.
n_capacite <- floor(0.15 * nrow(test))
selection <- test |> arrange(desc(probabilite), client_id) |> slice_head(n = n_capacite)
tibble(clients = nrow(test), cibles = nrow(selection),
       departs_detectes = sum(selection$depart_90j), precision = mean(selection$depart_90j))
```

    # A tibble: 1 × 4
      clients cibles departs_detectes precision
        <int>  <int>            <dbl>     <dbl>
    1     131     19               12     0.632

Le seuil 0,30 cible 50 des 131 clients du test et repère 22 des 40 départs. La règle de capacité prend 19 personnes et repère 12 départs. Elle augmente ici la précision de la liste tout en réduisant sa couverture. La règle majoritaire prédit 0 pour tous : son exactitude de 91/131 dépasse celle de la règle au seuil (85/131), mais elle manque les 40 départs.

Le groupe de risque le plus faible réunit 27 personnes et cinq départs. Sa fréquence observée de 18,5 % dépasse la moyenne prévue de 6,4 %. Les autres groupes figurent dans le tableau. Le score de Brier global vaut environ 0,191.

Un ciblage efficace exige aussi qu’un contact puisse aider, ce que ce modèle de risque ne mesure pas. Examiner les coûts réels, la disponibilité des variables, les populations touchées et une période ultérieure avant toute utilisation.
