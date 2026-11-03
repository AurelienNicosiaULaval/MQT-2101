# Compléments facultatifs - Module 09

Ce cahier conserve les prolongements de la séance antérieure. Il ne s’ajoute pas aux cinq productions guidées. Les calculs utilisent la même série fictive et la même préparation que la démonstration.

## Retards et fonction d’autocorrélation

Au retard k, on compare les observations séparées de k périodes. Une série avec tendance peut avoir une ACF positive même si ses résidus, après modélisation, sont différents. Une ACF saisonnière peut présenter des pics aux multiples de 12 pour des données mensuelles, sans que chaque pic constitue une preuve de saisonnalité.

``` r
library(tidyverse)
library(forecast)

racines <- c(".", "modules/semaine-09-variables-externes-autocorrelation")
racine <- racines[file.exists(file.path(racines, "data/ventes_promotions_quebec.csv"))][1]
stopifnot(!is.na(racine))
ventes <- read_csv(file.path(racine, "data/ventes_promotions_quebec.csv"), show_col_types = FALSE) |>
  mutate(date = as.Date(date), promotion = factor(promotion, levels = c("non", "oui")),
         mois = factor(mois, levels = 1:12)) |>
  arrange(date)
stopifnot(nrow(ventes) == 72, !anyDuplicated(ventes$date),
          all(!is.na(ventes)), all(ventes$date == seq.Date(as.Date("2020-01-01"), by = "month", length.out = 72)))
entrainement <- ventes |> slice_head(n = 60)
validation <- ventes |> slice_tail(n = 12)
```

``` r
ventes |> transmute(date, ventes, retard_1 = lag(ventes), retard_12 = lag(ventes, 12)) |> slice_head(n = 14)
```

    # A tibble: 14 × 4
       date       ventes retard_1 retard_12
       <date>      <dbl>    <dbl>     <dbl>
     1 2020-01-01 309720       NA        NA
     2 2020-02-01 329533   309720        NA
     3 2020-03-01 332527   329533        NA
     4 2020-04-01 325184   332527        NA
     5 2020-05-01 405161   325184        NA
     6 2020-06-01 338213   405161        NA
     7 2020-07-01 316643   338213        NA
     8 2020-08-01 405192   316643        NA
     9 2020-09-01 340965   405192        NA
    10 2020-10-01 433802   340965        NA
    11 2020-11-01 375648   433802        NA
    12 2020-12-01 384917   375648        NA
    13 2021-01-01 441917   384917    309720
    14 2021-02-01 354891   441917    329533

``` r
acf(entrainement$ventes, lag.max = 24, main = "ACF des ventes brutes")
```

![](complements_files/figure-html/unnamed-chunk-2-1.png)

## Prévoir des résidus en deux étapes

On peut ajuster d’abord la régression, puis un AR(1) sur ses résidus et ajouter la prévision de ce résidu à celle de la régression. Cette estimation séparée n’est pas forcément identique à une estimation conjointe avec erreurs AR(1). Aux horizons ultérieurs, les résidus inconnus sont remplacés par leurs prévisions; il n’existe pas une limite générale de prévisibilité égale à l’ordre du modèle.

``` r
modele_lm <- lm(ventes ~ tendance + promotion + prix_moyen + indice_confiance + mois,
                data = entrainement)
coef(summary(modele_lm))[c("tendance", "promotionoui", "prix_moyen", "indice_confiance"), ]
```

                      Estimate Std. Error   t value     Pr(>|t|)
    tendance          3087.438   280.4525 11.008774 3.175226e-14
    promotionoui     47566.125  7396.7293  6.430697 7.845218e-08
    prix_moyen       -4895.027  1628.3779 -3.006075 4.360178e-03
    indice_confiance  2687.160  1269.8958  2.116048 4.003496e-02

``` r
ar_residus <- Arima(residuals(modele_lm), order = c(1, 0, 0))
futur_residu <- forecast(ar_residus, h = 12)
prevision_deux_etapes <- as.numeric(predict(modele_lm, newdata = validation)) + as.numeric(futur_residu$mean)
tibble(date = validation$date, observe = validation$ventes, prevision_deux_etapes) |>
  summarise(MAE = mean(abs(observe - prevision_deux_etapes)), RMSE = sqrt(mean((observe - prevision_deux_etapes)^2)))
```

    # A tibble: 1 × 2
        MAE  RMSE
      <dbl> <dbl>
    1 5129. 6317.

Les prédicteurs de validation sont ici les valeurs réalisées après coup; les scores sont conditionnels à ces valeurs. Une comparaison de modèles exige les mêmes cibles et origines.

## Événements, interventions et valeurs atypiques

Une date d’événement peut être codée par une indicatrice; un changement permanent peut être décrit par une indicatrice active après l’intervention. Vérifier si l’événement est connu à l’origine. Une observation atypique peut être une erreur ou un phénomène réel : la documenter, comparer la sensibilité avec et sans elle et éviter une suppression automatique. Une corrélation entre séries qui partagent une tendance peut être trompeuse. Examiner la structure temporelle et les mécanismes avant de conclure.

## Retards de publication et interactions

Une donnée de janvier publiée seulement en mars n’est pas disponible pour une prévision produite en février. Il faut représenter ce délai dans l’entraînement et dans la validation, ou fournir une prévision distincte. À plusieurs horizons, un prédicteur retardé peut lui-même devenir inconnu.

L’ancien exemple météo et jour ouvrable combinait les deux catégories. Une interaction permet de représenter des associations différentes selon le contexte, sans établir une causalité. Ici, une interaction entre prix et promotion est illustrée seulement pour lire les coefficients et scénarios :

``` r
modele_interaction <- lm(ventes ~ tendance + mois + promotion * prix_moyen + indice_confiance,
                         data = entrainement)
coef(modele_interaction)[c("promotionoui", "prix_moyen", "promotionoui:prix_moyen")]
```

               promotionoui              prix_moyen promotionoui:prix_moyen
                51549.16539             -4863.66638               -69.09116

``` r
model.matrix(~ promotion * prix_moyen, data = entrainement) |> head()
```

      (Intercept) promotionoui prix_moyen promotionoui:prix_moyen
    1           1            0      59.67                    0.00
    2           1            0      58.34                    0.00
    3           1            0      58.38                    0.00
    4           1            0      59.25                    0.00
    5           1            1      54.94                   54.94
    6           1            0      58.19                    0.00

L’association de promotion dépend maintenant du prix : coefficient de promotion plus prix multiplié par le coefficient d’interaction. La catégorie de référence reste non. Le choix d’ajouter ce terme doit être justifié et validé; un meilleur ajustement seul ne garantit pas une meilleure prévision.

## ARIMA, différenciation et marche aléatoire

Un modèle AR utilise des retards de la série; un modèle MA utilise des innovations passées. Dans ARIMA(p,d,q), p compte les termes autorégressifs, d les différenciations non saisonnières et q les termes de moyenne mobile des innovations. Différencier peut rendre une série plus stable, mais ne garantit pas à lui seul la stationnarité; les modèles saisonniers ou avec tendance déterministe existent. Les modèles de ce cahier sont des illustrations, non une recherche exhaustive du meilleur modèle.

Une marche aléatoire sans dérive a pour prévision centrale la dernière observation; avec dérive, celle-ci évolue. Son avenir reste incertain. Une ACF de différences apparemment nulle ne démontre pas à elle seule une marche aléatoire, et un test ordinaire de pente égale à 1 n’est pas un test de racine unitaire valide par défaut.

``` r
serie <- ts(entrainement$ventes, start = c(2020, 1), frequency = 12)
modele_ar <- Arima(serie, order = c(1, 0, 0))
modele_ari <- Arima(serie, order = c(1, 1, 0))
modele_arima <- Arima(serie, order = c(1, 1, 1))
# Illustrations sur les mêmes 12 mois; pas de sélection automatique.
tibble(modele = c("AR(1)", "ARI(1,1)", "ARIMA(1,1,1)"),
       MAE = c(mean(abs(validation$ventes - forecast(modele_ar, h = 12)$mean)),
               mean(abs(validation$ventes - forecast(modele_ari, h = 12)$mean)),
               mean(abs(validation$ventes - forecast(modele_arima, h = 12)$mean))))
```

    # A tibble: 3 × 2
      modele          MAE
      <chr>         <dbl>
    1 AR(1)        91172.
    2 ARI(1,1)     36819.
    3 ARIMA(1,1,1) 37062.

Ces modèles sans variables externes et sans ajustement saisonnier explicite ne constituent pas nécessairement des modèles appropriés pour cette série; examiner diagnostics et limites avant toute recommandation. Les scores de validation sont calculés sur un bloc déjà consulté.
