# Exercices - Module 10

Le transfert traite d’une intervention en succursale, différente du ciblage de clients. Essayez les cinq exercices suivis avant d’ouvrir les corrigés; les exercices 6 à 11 sont des pratiques supplémentaires. Les étiquettes et coûts sont simulés. Faites les exercices 1 et 2 après les capsules correspondantes, le 3 après la capsule 4, puis les exercices 4 et 5 après la capsule 5. Exécutez la préparation puis les blocs des corrigés dans l’ordre : le modèle de l’exercice 2 est requis aux exercices 3 et 4.

## Préparation

Les conditions du mois courant sont supposées connues à la décision. Les mois de décembre 2023 et décembre 2024 sont écartés afin que les étiquettes à horizon d’un mois soient disponibles avant la période suivante.

``` r
library(tidyverse)
racines <- c(".", "modules/semaine-10-classification-modeles-avances")
racine <- racines[file.exists(file.path(racines, "data/cas_integrateur_quebec.csv"))][1]
stopifnot(!is.na(racine))
service <- read_csv(file.path(racine, "data/cas_integrateur_quebec.csv"), show_col_types = FALSE) |>
  mutate(date = as.Date(date), succursale = factor(succursale),
         cible = service_insuffisant_mois_suivant) |> arrange(date, succursale)
stopifnot(nrow(service) == 288, !anyDuplicated(service[c("date", "succursale")]),
          all(service$cible %in% c(0, 1)))
apprentissage_service <- service |> filter(date <= as.Date("2023-11-01"))
validation_service <- service |> filter(date >= as.Date("2024-01-01"), date <= as.Date("2024-11-01"))
test_service <- service |> filter(date >= as.Date("2025-01-01"))
```

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

## Exercice 1 - Définir le problème

Définissez l’unité, la classe positive, le moment des variables, l’horizon et les deux erreurs. Pourquoi « succursale à risque » est-il trop vague?

> **TIP:**
>
> L’unité est un mois-succursale. La classe positive est le service insuffisant simulé le mois suivant. Les conditions du mois courant sont supposées connues à la décision. Un faux négatif manque une situation positive; un faux positif déclenche une intervention inutile. L’étiquette est simulée, non une observation reconstituée du mois suivant.

## Exercice 2 - Comparer deux profils

Ajustez une régression sur l’apprentissage et comparez deux profils ne différant que par les ruptures de stock. Interprétez prudemment.

> **TIP:**
>
> ``` r
> modele_service <- glm(cible ~ taux_utilisation + ruptures_stock + temps_attente + satisfaction,
>                       data = apprentissage_service, family = binomial())
> stopifnot(modele_service$converged, all(is.finite(coef(modele_service))))
> profils_service <- tibble(taux_utilisation = c(0.90, 0.90), ruptures_stock = c(0, 5),
>                           temps_attente = c(5, 5), satisfaction = c(7, 7))
> profils_service |> mutate(probabilite = predict(modele_service, newdata = profils_service, type = "response"))
> ```
>
>     # A tibble: 2 × 5
>       taux_utilisation ruptures_stock temps_attente satisfaction probabilite
>                  <dbl>          <dbl>         <dbl>        <dbl>       <dbl>
>     1              0.9              0             5            7       0.296
>     2              0.9              5             5            7       0.335
>
> Le modèle donne environ 29,6 % pour zéro rupture et 33,5 % pour cinq ruptures, à utilisation, attente et satisfaction identiques. Ces probabilités dépendent des conditions fixées et du modèle. Elles ne sont ni des certitudes ni la preuve qu’une rupture cause un futur service insuffisant. Vérifiez aussi si les profils sont plausibles.

## Exercice 3 - Choisir un seuil

En validation, comparez les seuils 0,25 et 0,50 avec un coût fictif de 4 unités par faux négatif et 1 par faux positif. Choisissez le coût le plus faible; en cas d’égalité retenez 0,25.

> **TIP:**
>
> ``` r
> validation_service <- validation_service |>
>   mutate(probabilite = predict(modele_service, newdata = validation_service, type = "response"))
> comparaison_service <- bind_rows(mesures_seuil(validation_service$cible, validation_service$probabilite, 0.25),
>                                 mesures_seuil(validation_service$cible, validation_service$probabilite, 0.50))
> comparaison_service |> select(seuil, VP, FP, VN, FN, cout)
> ```
>
>     # A tibble: 2 × 6
>       seuil    VP    FP    VN    FN  cout
>       <dbl> <int> <int> <int> <int> <dbl>
>     1  0.25     4     9    25     6    33
>     2  0.5      2     3    31     8    35
>
> ``` r
> comparaison_service |> select(seuil, sensibilite, specificite, precision, proportion_ciblee)
> ```
>
>     # A tibble: 2 × 5
>       seuil sensibilite specificite precision proportion_ciblee
>       <dbl>       <dbl>       <dbl>     <dbl>             <dbl>
>     1  0.25         0.4       0.735     0.308             0.295
>     2  0.5          0.2       0.912     0.4               0.114
>
> ``` r
> seuil_service <- comparaison_service |> arrange(cout, seuil) |> slice(1) |> pull(seuil)
> seuil_service
> ```
>
>     [1] 0.25
>
> Sur les 44 lignes de validation, les couples (FP, FN) valent (9, 6) à 0,25 et (3, 8) à 0,50. Les coûts valent donc 33 et 35 unités. On retient 0,25 pour les coûts annoncés. Le seuil est choisi avant consultation du test. Les coûts sont des hypothèses de travail et les mesures en validation servent au choix; elles ne sont pas un test final indépendant.

## Exercice 4 - Évaluer et vérifier la capacité

Sur 2025, appliquez le seuil choisi. Calculez aussi, comme règle alternative fixée à l’avance, le ciblage des deux probabilités les plus élevées par mois et la répartition entre succursales.

> **TIP:**
>
> ``` r
> test_service <- test_service |> mutate(probabilite = predict(modele_service, newdata = test_service, type = "response"))
> resultat_service <- mesures_seuil(test_service$cible, test_service$probabilite, seuil_service)
> resultat_service |> select(seuil, VP, FP, VN, FN, cout)
> ```
>
>     # A tibble: 1 × 6
>       seuil    VP    FP    VN    FN  cout
>       <dbl> <int> <int> <int> <int> <dbl>
>     1  0.25     6    16    24     2    24
>
> ``` r
> resultat_service |> select(seuil, sensibilite, specificite, precision, proportion_ciblee)
> ```
>
>     # A tibble: 1 × 5
>       seuil sensibilite specificite precision proportion_ciblee
>       <dbl>       <dbl>       <dbl>     <dbl>             <dbl>
>     1  0.25        0.75         0.6     0.273             0.458
>
> ``` r
> # Règle fixée à l’avance : deux interventions au plus par mois.
> selection_service <- test_service |> group_by(date) |>
>   arrange(desc(probabilite), succursale, .by_group = TRUE) |> slice_head(n = 2) |> ungroup()
> selection_service |> count(succursale, name = "mois_cibles")
> ```
>
>     # A tibble: 4 × 2
>       succursale mois_cibles
>       <fct>            <int>
>     1 Gatineau            10
>     2 Montréal             3
>     3 Québec               4
>     4 Sherbrooke           7
>
> ``` r
> selection_service |> summarise(cibles = n(), positifs_detectes = sum(cible), precision = mean(cible))
> ```
>
>     # A tibble: 1 × 3
>       cibles positifs_detectes precision
>        <int>             <dbl>     <dbl>
>     1     24                 6      0.25
>
> Le seuil 0,25 signale 22 des 48 mois-succursales de 2025 et détecte 6 des 8 positifs. La règle de capacité affecte 24 interventions sur l’année et détecte également 6 positifs. Les affectations par succursale sont 10 pour Gatineau, 3 pour Montréal, 4 pour Québec et 7 pour Sherbrooke. Ces totaux annuels n’indiquent pas que les deux politiques sélectionnent les mêmes lignes. La règle de capacité n’est pas identique à un seuil fixe. Les égalités sont départagées par le nom de succursale. La comparaison est descriptive sur ce test : une sélection supplémentaire à partir de ce même test nécessiterait une nouvelle évaluation indépendante.

## Exercice 5 - Recommandation

Rédigez une recommandation courte avec la cible, l’horizon, les erreurs, une limite de l’étiquette simulée et un suivi de la concentration du ciblage.

> **TIP:**
>
> Exemple de réponse à la direction : « Avec deux interventions disponibles chaque mois, la règle de classement a retenu 24 mois-succursales et retrouvé 6 des 8 insuffisances simulées en 2025. Gatineau concentre 10 interventions sur 24. Avant un déploiement, je vérifierais cette concentration avec les équipes locales et suivrais les insuffisances effectivement observées lors de la période suivante. »
>
> Rapportez les résultats effectivement calculés et les coûts supposés. Précisez que la cible est une étiquette simulée et que les lignes d’une même succursale se suivent dans le temps. Surveillez la répartition, puis vérifiez la règle sur une période ultérieure et des données réelles appropriées.

## Pratique supplémentaire

Choisissez une difficulté à retravailler. Ces réponses ne sont pas exigées dans le rapport de transfert.

## Exercice 6 - Cotes et probabilités

Si une probabilité vaut 0,20 et que la cote est multipliée par 2, quelle est la nouvelle probabilité?

> **TIP:**
>
> La cote initiale vaut 0,20 / 0,80 = 0,25. Après multiplication : 0,50. La probabilité correspondante vaut 0,50 / 1,50 = 1/3, environ 0,333; elle n’est pas égale à 0,40.

## Exercice 7 - Mesure indéfinie

Aucun client n’est ciblé. Quelle est la précision de la règle?

> **TIP:**
>
> La précision VP / (VP + FP) a un dénominateur nul. Elle est indéfinie; le code retourne `NA`, pas 0. Les autres mesures ne sont calculables que si leur dénominateur est non nul.

## Exercice 8 - Fuite et disponibilité

Une variable « nombre de plaintes après le départ » améliore la performance historique. Peut-on l’utiliser pour cibler avant le départ?

> **TIP:**
>
> Non : elle est connue après l’événement à prédire. Sa présence crée une fuite de cible. Il faut utiliser les informations réellement disponibles à l’origine et vérifier les dates de collecte.

## Exercice 9 - Choisir avec une autre échelle de coûts

En validation des succursales, un FP coûte maintenant deux unités et un FN quatre. Comparez 0,25 et 0,50.

> **TIP:**
>
> Avec (9 FP, 6 FN), le coût à 0,25 devient 2 × 9 + 4 × 6 = 42. Avec (3 FP, 8 FN), le coût à 0,50 est 38. Le classement est inversé. C’est une nouvelle hypothèse de coût appliquée à la validation.

## Exercice 10 - Un quota mensuel ou annuel ?

La direction propose de prendre les 24 risques les plus élevés de 2025. Cela garantit-il deux interventions au plus chaque mois ?

> **TIP:**
>
> Non. Trois des 24 plus grands risques pourraient se trouver en janvier. Il faut classer les quatre succursales à l’intérieur de chaque mois et retenir les deux premières. De plus, une liste annuelle construite après décembre utiliserait des informations futures pour décider en janvier.

## Exercice 11 - Lire un groupe de calibration

Dans le premier groupe du test clients, 5 personnes sur 27 sont parties pour un risque moyen de 6,4 %. Donnez la fréquence observée et une limite.

> **TIP:**
>
> 5/27 vaut environ 18,5 %. L’écart observé est d’environ 12,1 points de pourcentage. Il concerne un seul groupe de 27 personnes sur ce partage. On peut proposer une nouvelle évaluation sur une autre cohorte avant d’adapter les probabilités.
