# Exercices - Module 07

## Un transfert vers la planification énergétique

Le cas guidé prévoit des unités de produit sur treize semaines. Ici, l’équipe responsable d’un bâtiment universitaire fictif prépare les douze consommations mensuelles de 2025 à la fin de décembre 2024. La cible est une énergie en kWh, et la saisonnalité est marquée. Un budget financier demanderait des données tarifaires supplémentaires.

Les quatre exercices suivis alimentent un seul rapport, `lissage_electricite.qmd`. Faites l’exercice 1 après la capsule 1, le 2 après la capsule 2, le 3 après la capsule 3, puis le 4 après la capsule 4. Faites une tentative avant d’ouvrir chaque corrigé. Le code des corrigés 1 à 4 s’exécute dans cet ordre, après la préparation commune.

Décompressez le [projet de transfert](telechargements/lissage-electricite.zip). Le [projet des corrigés complets](telechargements/corrige-lissage-electricite.zip) contient aussi les pratiques supplémentaires. Les [huit pratiques ciblées](#pratique-supplementaire) sont facultatives; elles ne créent pas un troisième rapport.

## Préparation

Les données d’électricité sont les mêmes qu’au module 06, recopiées dans le projet pour éviter une dépendance à son dossier. Les [dictionnaires](data/dictionnaires.md) précisent les unités. Installez une fois `tidyverse`, `slider` et `forecast` si nécessaire. Ouvrez le `.Rproj`, puis exécutez les blocs visibles depuis une session neuve. Les fonctions sont fournies dans `R/fonctions-module07.R`.

``` r
library(tidyverse)
library(slider)
library(forecast)

# Ouvrir le projet .Rproj fourni : R/ et data/ sont à côté du rapport.
source("R/fonctions-module07.R")
electricite <- read_csv("data/consommation_electrique_batiment_quebec.csv",
                        show_col_types = FALSE) |>
  mutate(date = as.Date(date)) |>
  arrange(date)
stopifnot(nrow(electricite) == 72L, !anyNA(electricite),
          !anyDuplicated(electricite$date),
          identical(electricite$date,
                    seq.Date(as.Date("2020-01-01"), by = "month", length.out = 72)))
horizon_e <- 12L
apprentissage_e <- electricite |> slice_head(n = 60)
validation_e <- electricite |> slice_tail(n = horizon_e)
serie_e <- ts(apprentissage_e$consommation_kwh, frequency = 12,
              start = c(2020, 1))
```

Apprentissage: janvier 2020 à décembre 2024, 60 mois. Validation: les douze mois de 2025. Les cinq candidats sont fixés avant les scores: naïf, MM3, SES avec alpha = 0,2, SES avec alpha = 0,8 et naïf saisonnier. Les deux SES ont exactement la même initialisation, égale à la première consommation. Les valeurs d’alpha sont imposées pour comprendre leur effet, sans recherche sur 2025.

Ces mois ont déjà servi au module 06. On étudie de nouvelles méthodes sur une validation connue, sans nouveau test indépendant.

## Exercice 1 - Fenêtres et unités

Sur l’apprentissage, tracez les moyennes mobiles arrière de 3 et 12 mois. Un écart absolu de plus de 20 000 kWh est ici le repère descriptif fixé pour comparer leurs messages. Trouvez le premier mois où les deux fenêtres existent et dépassent ce repère. Expliquez la réactivité, le retard et la différence entre kWh et MWh. Une moyenne arrière de 12 mois constitue-t-elle une prévision saisonnière?

> **TIP:**
>
> ``` r
> electricite_lissee <- apprentissage_e |>
>   mutate(mm3 = slide_dbl(consommation_kwh, mean, .before = 2, .complete = TRUE),
>          mm12 = slide_dbl(consommation_kwh, mean, .before = 11, .complete = TRUE))
> electricite_lissee |>
>   select(date, consommation_kwh, mm3, mm12) |>
>   pivot_longer(-date, names_to = "serie", values_to = "kwh") |>
>   ggplot(aes(date, kwh / 1000, colour = serie)) +
>   geom_line(na.rm = TRUE) +
>   labs(x = NULL, y = "Énergie mensuelle (MWh)", colour = "Série") +
>   theme_minimal(base_size = 12)
> ```
>
> ![](exercices_files/figure-html/solution-fenetres-m07-1.png)
>
> ``` r
> electricite_lissee |>
>   filter(!is.na(mm12)) |>
>   mutate(ecart_kwh = abs(mm3 - mm12)) |>
>   filter(ecart_kwh > 20000) |>
>   slice_head(n = 1) |>
>   select(date, mm3, mm12, ecart_kwh)
> ```
>
>     # A tibble: 1 × 4
>       date           mm3    mm12 ecart_kwh
>       <date>       <dbl>   <dbl>     <dbl>
>     1 2020-12-01 173168. 146385.    26783.
>
> La fenêtre courte suit plus vite les hausses hivernales et les baisses. La fenêtre de douze mois atténue le motif annuel, mais introduit un retard et ne prévoit pas douze valeurs saisonnières différentes. Le tableau localise le premier dépassement du repère descriptif; ce n’est pas un test statistique ni un seuil opérationnel validé. Les deux et onze premières moyennes sont manquantes par construction. Un MWh vaut 1 000 kWh; les scores seront calculés en kWh.

## Exercice 2 - Deux réactivités, une même origine

Calculez les niveaux avec alpha = 0,2 et 0,8 sur l’apprentissage, avec le même état initial. Avant de regarder les scores, indiquez lequel suit davantage la dernière observation. Émettez les douze prévisions de chacun des cinq candidats à l’origine de décembre 2024. Expliquez pourquoi quatre trajectoires sont constantes et une varie avec le mois.

> **TIP:**
>
> ``` r
> niveaux_e <- apprentissage_e |>
>   mutate(alpha_02 = niveau_ses(consommation_kwh, 0.2),
>          alpha_08 = niveau_ses(consommation_kwh, 0.8))
> niveaux_e |> select(date, consommation_kwh, alpha_02, alpha_08) |> tail(4)
> ```
>
>     # A tibble: 4 × 4
>       date       consommation_kwh alpha_02 alpha_08
>       <date>                <dbl>    <dbl>    <dbl>
>     1 2024-09-01           129982  140333.  128065.
>     2 2024-10-01           157641  143795.  151726.
>     3 2024-11-01           187237  152483.  180135.
>     4 2024-12-01           200112  162009.  196117.
>
> ``` r
> previsions_e <- tibble(
>   date = validation_e$date,
>   observe = validation_e$consommation_kwh,
>   Naive = rep(tail(apprentissage_e$consommation_kwh, 1), horizon_e),
>   MM3 = rep(mean(tail(apprentissage_e$consommation_kwh, 3)), horizon_e),
>   SES02 = rep(tail(niveaux_e$alpha_02, 1), horizon_e),
>   SES08 = rep(tail(niveaux_e$alpha_08, 1), horizon_e),
>   Saisonnier = as.numeric(snaive(serie_e, h = horizon_e)$mean)
> )
> ```
>
> Alpha = 0,8 se rapproche davantage de décembre, qui est un mois de forte consommation. Cela ne garantit pas une bonne prévision de l’été suivant. Naïf, MM3 et les deux SES répètent un niveau fixe. Le naïf saisonnier reprend les douze mois de 2024. Fixer `frequency = 12` n’ajoute pas automatiquement une saisonnalité au SES.

## Exercice 3 - Scores et coût asymétrique

Calculez ME, MAE et RMSE sur les mêmes douze mois, puis tracez observations et prévisions. Ajoutez un coût pédagogique: deux unités de coût par kWh sous-prévu et une par kWh sur-prévu. Ce coût fictif n’est pas un tarif d’électricité. Comparez le classement par MAE à celui par coût moyen, d’abord pour tous les candidats, puis pour les méthodes constantes seulement.

> **TIP:**
>
> ``` r
> erreurs_e <- previsions_e |>
>   pivot_longer(Naive:Saisonnier, names_to = "methode", values_to = "prevision") |>
>   mutate(erreur = observe - prevision)
> scores_e <- erreurs_e |>
>   group_by(methode) |>
>   group_modify(~ mesures_erreurs(.x$observe, .x$prevision,
>                                 cout_sous = 2, cout_sur = 1)) |>
>   ungroup()
> scores_e |> select(methode, ME, MAE, RMSE, cout_moyen) |> arrange(MAE)
> ```
>
>     # A tibble: 5 × 5
>       methode         ME    MAE   RMSE cout_moyen
>       <chr>        <dbl>  <dbl>  <dbl>      <dbl>
>     1 Saisonnier   3052.  6662.  7987.     11520.
>     2 SES02        1224. 31102. 35679.     47265.
>     3 MM3        -18430  33971. 40139.     41741.
>     4 SES08      -32883. 41147. 48505.     45278.
>     5 Naive      -36879. 43810. 51298.     47276.
>
> ``` r
> ggplot() +
>   geom_line(data = validation_e, aes(date, consommation_kwh / 1000),
>             linewidth = 1) +
>   geom_line(data = erreurs_e, aes(date, prevision / 1000, colour = methode)) +
>   labs(x = NULL, y = "Énergie mensuelle (MWh)", colour = "Méthode") +
>   theme_minimal(base_size = 12)
> ```
>
> ![](exercices_files/figure-html/solution-scores-m07-1.png)
>
> Le naïf saisonnier a une MAE d’environ 6 662 kWh et une RMSE d’environ 7 987 kWh. Les prévisions constantes ont des MAE beaucoup plus élevées: environ 31 102 kWh pour SES02, 33 971 pour MM3, 41 147 pour SES08 et 43 810 pour le naïf.
>
> Dans le groupe constant, SES02 minimise la MAE, mais MM3 minimise ce coût asymétrique: environ 41 741 unités de coût par mois, contre 47 265 pour SES02. La ME de SES02, proche de +1 224 kWh, n’efface pas ses erreurs mensuelles de signes contraires. La référence saisonnière reste la meilleure des cinq pour les deux critères. On ne retire pas ce résultat parce qu’il est défavorable au lissage simple.

## Exercice 4 - Recommandation et surveillance

Rédigez une note à l’équipe énergétique: méthode retenue, MAE et RMSE avec unités, coût moyen dans le scénario, comparaison aux prévisions constantes, limite et surveillance mensuelle. Expliquez pourquoi cette décision diffère de celle du cas de demande. Ne transformez pas la prévision d’énergie en budget ni en garantie de capacité.

> **TIP:**
>
> ``` r
> scores_e |>
>   select(methode, MAE, cout_moyen, sous_previsions) |>
>   arrange(cout_moyen)
> ```
>
>     # A tibble: 5 × 4
>       methode       MAE cout_moyen sous_previsions
>       <chr>       <dbl>      <dbl>           <int>
>     1 Saisonnier  6662.     11520.               7
>     2 MM3        33971.     41741.               5
>     3 SES08      41147.     45278.               2
>     4 SES02      31102.     47265.               6
>     5 Naive      43810.     47276.               2
>
> ``` r
> # Comparer les méthodes constantes, même si la référence saisonnière les bat.
> scores_e |>
>   filter(methode != "Saisonnier") |>
>   select(methode, MAE, cout_moyen) |>
>   arrange(cout_moyen)
> ```
>
>     # A tibble: 4 × 3
>       methode    MAE cout_moyen
>       <chr>    <dbl>      <dbl>
>     1 MM3     33971.     41741.
>     2 SES08   41147.     45278.
>     3 SES02   31102.     47265.
>     4 Naive   43810.     47276.
>
> Exemple acceptable: « Sur les douze mois de validation, le naïf saisonnier est la référence retenue: MAE d’environ 6 662 kWh, RMSE de 7 987 kWh et coût moyen de 11 520 unités fictives par mois. Le lissage constant ne suit pas le motif hivernal et estival. Parmi ces méthodes constantes, MM3 a un coût plus faible que SES02 malgré sa MAE plus élevée. La demande hebdomadaire favorisait MM4 sur ses propres cibles; son classement ne se transfère pas à l’électricité. »
>
> La période est déjà connue et ne prouve pas une performance future. À chaque nouvelle observation, enregistrer l’erreur et son coût, examiner le cumul et les mois d’écart inhabituel, puis comparer à de nouvelles origines avec un horizon identique. Un seuil d’alerte réel doit être convenu avec l’équipe; aucun seuil de coût acceptable n’est fourni. La prévision ne suffit pas à dimensionner une installation ni à calculer une facture.

## Trace finale

Réunissez les quatre réponses dans `lissage_electricite.qmd`: calendrier, fenêtres, niveaux, cinq prévisions, graphique, scores et note de décision. Les graphiques peuvent utiliser les MWh, mais leurs axes doivent le dire et les scores restent en kWh. Redémarrez R, puis faites Render. Les activités du parcours guidé restent dans `lissage_demande.qmd`.

## Pratique supplémentaire

Ces huit questions ciblent des difficultés précises. Les calculs ci-dessous sont indépendants, utilisent R de base et ne demandent pas la préparation des exercices 1 à 4.

## Exercice 5 - Même moyenne, fenêtres différentes

Les quatre demandes sont 980, 1 020, 1 080 et 1 120 unités. Calculez MM4, la référence naïve et une moyenne des deux dernières observations. Quelle information ne peut-on pas déduire de ces trois nombres?

> **TIP:**
>
> ``` r
> y <- c(980, 1020, 1080, 1120)
> c(MM4 = mean(y), naive = tail(y, 1), MM2 = mean(tail(y, 2)))
> ```
>
>       MM4 naive   MM2
>      1050  1120  1100
>
> MM4 = 1 050, naïf = 1 120 et MM2 = 1 100 unités. Ces nombres ne déterminent ni la demande future ni la meilleure fenêtre. Le bruit, la tendance et le coût des erreurs doivent être étudiés.

## Exercice 6 - Repérer une fuite

Pour prévoir la semaine t avant son observation, une personne compare y_t à la moyenne de y_t, y\_(t−1), y\_(t−2) et y\_(t−3). Quel est le problème? Que change une moyenne centrée?

> **TIP:**
>
> La moyenne contient la cible y_t: elle est descriptive après son observation. Pour une prévision à un pas, employer les quatre observations jusqu’à t − 1. Une moyenne centrée utilise aussi des valeurs après t et ne peut pas être disponible à cette origine. Une moyenne calculée sur tout le fichier puis décalée est possible pour des origines successives; elle ne représente pas les treize prévisions émises à une seule origine.

## Exercice 7 - Calculer la récurrence

Le niveau initial vaut 100. Les deux nouvelles observations valent 140. Calculez deux mises à jour avec alpha = 0,2, puis 0,8. Pourquoi ne pas changer aussi l’initialisation?

> **TIP:**
>
> ``` r
> mise_a_jour <- function(alpha) {
>   l1 <- alpha * 140 + (1 - alpha) * 100
>   l2 <- alpha * 140 + (1 - alpha) * l1
>   c(l1 = l1, l2 = l2)
> }
> rbind(alpha02 = mise_a_jour(0.2), alpha08 = mise_a_jour(0.8))
> ```
>
>              l1    l2
>     alpha02 108 114.4
>     alpha08 132 138.4
>
> Les résultats sont (108; 114,4) et (132; 138,4). Une initialisation commune isole l’effet d’alpha. Aucune valeur n’est universellement préférable.

## Exercice 8 - Même MAE, erreur extrême

Deux séries d’erreurs valent (10, 10, 10, 10) et (0, 0, 0, 40) unités. Calculez MAE et RMSE.

> **TIP:**
>
> ``` r
> erreurs_a <- c(10, 10, 10, 10)
> erreurs_b <- c(0, 0, 0, 40)
> calcul <- function(e) c(MAE = mean(abs(e)), RMSE = sqrt(mean(e^2)))
> rbind(A = calcul(erreurs_a), B = calcul(erreurs_b))
> ```
>
>       MAE RMSE
>     A  10   10
>     B  10   20
>
> Les deux MAE valent 10 unités. Les RMSE valent 10 et 20 unités. La seconde mesure reflète davantage la concentration de l’erreur sur une période. Ce résultat ne détermine pas à lui seul le coût opérationnel.

## Exercice 9 - Les compensations du biais

Les erreurs sont (−20, 0, 20) kWh. Calculez ME et MAE. Puis exprimez-les en MWh.

> **TIP:**
>
> ``` r
> e <- c(-20, 0, 20)
> c(ME_kwh = mean(e), MAE_kwh = mean(abs(e)),
>   ME_mwh = mean(e / 1000), MAE_mwh = mean(abs(e / 1000)))
> ```
>
>          ME_kwh     MAE_kwh      ME_mwh     MAE_mwh
>      0.00000000 13.33333333  0.00000000  0.01333333
>
> ME = 0 kWh et MAE ≈ 13,33 kWh = 0,01333 MWh. Les erreurs ne sont pas nulles: les signes se compensent. Une moyenne empirique nulle ne prouve pas l’absence de biais futur.

## Exercice 10 - Zéros et pourcentages

Les observations valent (0, 20), les prévisions (5, 15). Calculez MAE et RMSE. Pourquoi ne pas enlever le zéro pour obtenir un MAPE?

> **TIP:**
>
> ``` r
> observe <- c(0, 20)
> predit <- c(5, 15)
> e <- observe - predit
> c(MAE = mean(abs(e)), RMSE = sqrt(mean(e^2)),
>   MAPE = if (any(observe == 0)) NA_real_ else 100 * mean(abs(e / observe)))
> ```
>
>      MAE RMSE MAPE
>        5    5   NA
>
> MAE = RMSE = 5 unités. Le MAPE est indéfini en présence du zéro. Le retirer changerait les cibles comparées et cacherait une erreur. La MASE du module 06 reste une option si son dénominateur d’apprentissage est positif; elle ne dispense pas de comparer les MAE sur la validation.

## Exercice 11 - Changer le coût change la préférence

Deux méthodes donnent les erreurs A = (−10, −10) et B = (8, 8). Comparez MAE et coût moyen avec sous-prévision coûtant 2 et sur-prévision coûtant 1.

> **TIP:**
>
> ``` r
> perte <- function(e) c(MAE = mean(abs(e)),
>   cout = mean(2 * pmax(e, 0) + pmax(-e, 0)))
> rbind(A = perte(c(-10, -10)), B = perte(c(8, 8)))
> ```
>
>       MAE cout
>     A  10   10
>     B   8   16
>
> La MAE préfère B (8 contre 10), le coût préfère A (10 contre 16 unités de coût par période). Il faut annoncer les coefficients avant d’évaluer et vérifier leur sens avec la personne responsable. Cela ne démontre pas qu’une prévision arbitrairement plus élevée soit optimale.

## Exercice 12 - Un gain de 1 %

Une méthode passe d’une MAE de 100 à 99 unités, mais nécessite des variables payantes et une maintenance hebdomadaire. Les treize semaines ont servi à choisir cette méthode. Que peut-on recommander?

> **TIP:**
>
> Le gain observé est une unité par cible, soit 1 %. Sa valeur dépend du coût réel et de sa stabilité sur d’autres origines. On peut garder provisoirement la règle simple si le gain ne justifie pas les coûts supplémentaires. Les treize semaines sont une validation utilisée pour choisir, sans preuve de généralisation ni test indépendant. Prévoir une comparaison ultérieure commune plutôt qu’affirmer une supériorité définitive.

## Exercice 13 - Holt accompagné (facultatif)

Après le [complément Holt](../../modules/semaine-07-lissage/lectures.llms.md#holt), utilisez la préparation commune du transfert. Ajustez une tendance amortie sur l’apprentissage et comparez-la au naïf saisonnier. Est-ce une méthode saisonnière? Est-elle nécessaire à la trace principale?

> **TIP:**
>
> ``` r
> modele_holt_e <- holt(serie_e, h = horizon_e, damped = TRUE)
> mesures_erreurs(validation_e$consommation_kwh,
>                 as.numeric(modele_holt_e$mean), 2, 1)
> ```
>
>     # A tibble: 1 × 5
>            ME    MAE   RMSE cout_moyen sous_previsions
>         <dbl>  <dbl>  <dbl>      <dbl>           <int>
>     1 -86019. 87355. 96692.     88023.               1
>
> ``` r
> scores_e |> filter(methode == "Saisonnier")
> ```
>
>     # A tibble: 1 × 6
>       methode       ME   MAE  RMSE cout_moyen sous_previsions
>       <chr>      <dbl> <dbl> <dbl>      <dbl>           <int>
>     1 Saisonnier 3052. 6662. 7987.     11520.               7
>
> Holt estime un niveau et une pente amortie. Il ne représente pas le motif annuel. Comparez les valeurs affichées avec les mêmes coûts; l’ajout de la pente ne garantit pas un gain. Ce complément sert au laboratoire et ne s’ajoute pas aux cinq candidats du rapport principal.
