# Transfert et pratiques - Laboratoire 03

## Un transfert distinct, facultatif

Une direction fictive suit des ventes mensuelles et un objectif budgétaire. La question est de comparer deux prévisions fondées sur le calendrier, puis d’interpréter rétrospectivement l’écart entre les ventes et l’objectif. Le budget n’est pas automatiquement une prévision disponible à l’origine.

Ces exercices prolongent le module 08. Les 60 mois de 2020 à 2024 servent à l’apprentissage et les 12 mois de 2025 sont une validation déjà examinée. Les résultats ne sont pas un test indépendant. Tentez chaque réponse avant d’ouvrir son corrigé. Les exercices 1 à 4 se suivent; les pratiques 5 et 6 sont indépendantes.

Le [projet de transfert à compléter](telechargements/transfert-labo-03.zip) et le [corrigé exécutable](telechargements/corrige-transfert-labo-03.zip) sont facultatifs. Ils ne créent pas un deuxième rapport obligatoire pendant le laboratoire.

## Préparation

``` r
library(tidyverse)
ventes <- read_csv("data/ventes_saisonnieres_quebec.csv", show_col_types = FALSE) |>
  mutate(date = as.Date(date)) |> arrange(date) |>
  mutate(indice = row_number(), mois = factor(lubridate::month(date), levels = 1:12))
stopifnot(nrow(ventes) == 72L, !anyNA(ventes[c("date", "ventes")]),
          !anyDuplicated(ventes$date),
          identical(ventes$date, seq.Date(as.Date("2020-01-01"), by = "month", length.out = 72)))
apprentissage <- ventes |> slice_head(n = 60)
validation <- ventes |> slice_tail(n = 12)
futur <- tibble(date = seq.Date(as.Date("2025-01-01"), by = "month", length.out = 12),
                indice = 61:72, mois = factor(1:12, levels = 1:12))
stopifnot(identical(futur$date, validation$date))
```

## Exercice 1 - Définir ce qui est connu

Indiquez unité, origine, horizon et indices futurs. Quelles colonnes peuvent être construites à la fin de 2024? Quel statut donner à l’objectif budgétaire pour une comparaison rétrospective?

> **TIP:**
>
> Une ligne représente un mois; les ventes sont en dollars canadiens. L’origine est la fin de décembre 2024 et l’horizon de douze mois. Dates, indices 61 à 72 et mois sont connus. Les ventes de 2025 ne le sont pas. Le budget est un objectif fictif : comme aucune disponibilité à l’origine n’est établie, on le garde pour une lecture après coup, sans l’appeler prévision ex ante.

## Exercice 2 - Comparer deux prévisions

Ajustez une tendance linéaire avec mois, janvier comme référence, et comparez-la au naïf saisonnier sur les mêmes mois. Calculez ME, MAE et RMSE; tracez les trajectoires et commentez le classement et sa limite.

> **TIP:**
>
> ``` r
> # Ajuster sur 2020-2024 et construire les prévisions avant les observations de 2025.
> modele_calendrier <- lm(ventes ~ indice + mois, data = apprentissage,
>                         contrasts = list(mois = "contr.treatment"))
> previsions <- futur |>
>   mutate(Calendrier = as.numeric(predict(modele_calendrier, newdata = futur)),
>          Saisonnier = tail(apprentissage$ventes, 12))
> evaluation <- previsions |>
>   left_join(validation |> select(date, observe = ventes), by = "date") |>
>   pivot_longer(c(Calendrier, Saisonnier), names_to = "methode", values_to = "prevision") |>
>   mutate(erreur = observe - prevision)
> evaluation |> group_by(methode) |>
>   summarise(ME = mean(erreur), MAE = mean(abs(erreur)),
>             RMSE = sqrt(mean(erreur^2)), .groups = "drop")
> ```
>
>     # A tibble: 2 × 4
>       methode        ME    MAE   RMSE
>       <chr>       <dbl>  <dbl>  <dbl>
>     1 Calendrier -3538.  9891. 11280.
>     2 Saisonnier 29067. 29067. 30170.
>
> ``` r
> ggplot(evaluation, aes(date)) +
>   geom_line(aes(y = observe / 1000), colour = "black", linewidth = 1) +
>   geom_line(aes(y = prevision / 1000, colour = methode)) +
>   labs(x = NULL, y = "Ventes (milliers de $ CA)", colour = "Méthode") +
>   theme_minimal(base_size = 12)
> ```
>
> ![](exercices_files/figure-html/transfert-labo03-graphique-1.png)
>
> La MAE du calendrier vaut environ 9 891 \$, contre 29 067 \$ pour le naïf saisonnier. La comparaison sert au choix sur ces douze mois déjà connus; elle ne démontre pas une meilleure performance à toutes les origines. Les contrastes de mois sont conditionnels au modèle, sans effet causal.

## Exercice 3 - Comparer les coûts et l’objectif

Supposez qu’un dollar de ventes sous-prévu coûte fictivement 1,50 \$ et qu’un dollar sur-prévu coûte 0,40 \$. Calculez les coûts des deux prévisions. Calculez ensuite séparément l’écart des ventes à `budget_cible` et le même coût illustratif. Pourquoi ce dernier ne prouve-t-il pas la performance d’une prévision budgétaire émise fin 2024?

> **TIP:**
>
> ``` r
> # Un scénario pédagogique, défini avant de calculer les erreurs.
> couts_previsions <- evaluation |>
>   mutate(cout_fictif = 1.5 * pmax(erreur, 0) + 0.4 * pmax(-erreur, 0)) |>
>   group_by(methode) |>
>   summarise(MAE = mean(abs(erreur)), cout_total = sum(cout_fictif), .groups = "drop")
> couts_previsions
> ```
>
>     # A tibble: 2 × 3
>       methode       MAE cout_total
>       <chr>       <dbl>      <dbl>
>     1 Calendrier  9891.     89411.
>     2 Saisonnier 29067.    523200
>
> ``` r
> # Comparaison rétrospective à un objectif, pas une nouvelle prévision.
> budget_retro <- validation |>
>   mutate(ecart_objectif = ventes - budget_cible,
>          cout_fictif = 1.5 * pmax(ecart_objectif, 0) + 0.4 * pmax(-ecart_objectif, 0)) |>
>   summarise(MAE_ecart_objectif = mean(abs(ecart_objectif)),
>             cout_total = sum(cout_fictif), mois_au_dessus = sum(ecart_objectif > 0))
> budget_retro
> ```
>
>     # A tibble: 1 × 3
>       MAE_ecart_objectif cout_total mois_au_dessus
>                    <dbl>      <dbl>          <int>
>     1             77945.    1403013             12
>
> Les coûts fictifs sur les douze mois sont environ 89 411 \$ pour Calendrier et 523 200 \$ pour le naïf saisonnier. L’objectif est en dessous des ventes dans les douze mois; le coût illustratif de cet écart est environ 1 403 013 \$. Les coefficients sont hypothétiques, les montants ne sont pas des dépenses observées et la disponibilité du budget à l’origine n’est pas établie. Il ne faut pas classer automatiquement l’objectif parmi les prévisions ex ante.

## Exercice 4 - Intervalles et surveillance

Produisez les intervalles de prédiction à 95 % du modèle Calendrier. Proposez quatre indicateurs de surveillance : erreur absolue récente, erreur signée, couverture et erreur de décembre. Pour chacun, donnez un seuil hypothétique et une action. Expliquez la limite d’une couverture calculée sur douze mois.

> **TIP:**
>
> ``` r
> intervalle <- predict(modele_calendrier, newdata = futur,
>                       interval = "prediction", level = 0.95)
> verif_intervalle <- tibble(date = futur$date, observe = validation$ventes,
>   fit = intervalle[, "fit"], inf = intervalle[, "lwr"], sup = intervalle[, "upr"]) |>
>   mutate(dans_intervalle = observe >= inf & observe <= sup)
> verif_intervalle |> summarise(mois_couverts = sum(dans_intervalle), mois = n())
> ```
>
>     # A tibble: 1 × 2
>       mois_couverts  mois
>               <int> <int>
>     1            12    12
>
> Les douze observations connues se trouvent ici dans leurs intervalles individuels. Ce résultat limité ne prouve pas la calibration future et ne garantit pas simultanément toute l’année. Une règle de surveillance doit utiliser les prévisions émises à chaque origine et les observations ensuite disponibles.
>
> Exemple de seuils purement illustratifs : MAE des trois derniers mois au-dessus de 15 000 \$ : examiner les écarts et le contexte; valeur absolue de ME sur trois mois au-dessus de 10 000 \$ : vérifier une dérive de signe; au plus 9 mois couverts sur les 12 derniers : examiner hypothèses et changements; erreur absolue de décembre au-dessus de 20 000 \$ : revoir les événements et la saisonnalité. Ces seuils ne sont ni calibrés ni validés; trois mois et un seul décembre ne suffisent pas à conclure.

## Pratique 5 - Validation et choix

Une personne compare six modèles sur les douze derniers mois, choisit la plus faible MAE et annonce cette même valeur comme performance finale indépendante. Quelle est la difficulté? Comment organiser une validation chronologique interne, puis un test final distinct si les données le permettent?

> **TIP:**
>
> Le bloc a servi à choisir le modèle; la meilleure valeur observée peut être optimiste. On peut réserver un dernier bloc chronologique, comparer les candidats sur une ou plusieurs origines antérieures entièrement situées avant ce bloc, arrêter la méthode puis évaluer une seule fois sur le dernier bloc. Les données disponibles doivent être assez longues. Le même chiffre n’est pas une preuve indépendante du choix. Une moyenne mobile utilisant une vente postérieure à son origine serait une fuite.

## Pratique 6 - Un coût peut changer le classement

Deux méthodes ont des erreurs `observé - prévu` sur deux périodes : A = 10, 0; B = -6, -6. Comparez les MAE et les coûts fictifs du laboratoire, 18 \$ pour une unité sous-prévue et 5 \$ pour une unité sur-prévue.

> **TIP:**
>
> ``` r
> exemple <- tibble(methode = rep(c("A", "B"), each = 2),
>                   erreur = c(10, 0, -6, -6)) |>
>   group_by(methode) |>
>   summarise(MAE = mean(abs(erreur)),
>             cout_total = sum(18 * pmax(erreur, 0) + 5 * pmax(-erreur, 0)),
>             .groups = "drop")
> exemple
> ```
>
>     # A tibble: 2 × 3
>       methode   MAE cout_total
>       <chr>   <dbl>      <dbl>
>     1 A           5        180
>     2 B           6         60
>
> A a la plus petite MAE, 5 unités contre 6. Son coût fictif vaut 180 \$, contre 60 \$ pour B. Le signe des erreurs et les coûts expliquent ce classement différent. Cet exemple est construit pour illustrer la possibilité; il ne décrit pas les résultats observés de la demande hebdomadaire.

## Pour aller plus loin

La [démonstration de la mission](../../modules/atelier-03-series-chronologiques/demonstrations.llms.md) montre aussi Holt, facultatif. Les méthodes et formes plus nombreuses sont conservées dans les [compléments de lissage](../../modules/semaine-07-lissage/complements.llms.md) et les [compléments de tendance](../../modules/semaine-08-tendance-saisonnalite/complements.llms.md). Les anciennes données de tiers ne sont pas redistribuées.
