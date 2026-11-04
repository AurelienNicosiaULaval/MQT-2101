# Démonstrations - Laboratoire 03

## Une comparaison sur de nouvelles données

La mission porte sur des livraisons mensuelles fictives. L’apprentissage couvre 2020 à 2024; les douze mois de 2025 servent à comparer, sans constituer un test final indépendant. Exécutez le code dans l’ordre : il vérifie la série, trace l’apprentissage, ajuste les deux méthodes et compare leurs résultats. Le coût est un scénario fictif, et l’intervalle appartient à la régression.

## Préparation et audit

``` r
library(tidyverse)
livraisons <- read_csv('data/livraisons_mensuelles_fictives.csv', show_col_types = FALSE) |>
  mutate(date = as.Date(date)) |> arrange(date) |>
  mutate(indice = row_number(), mois = factor(format(date, '%m'), levels = sprintf('%02d', 1:12)))
stopifnot(nrow(livraisons) == 72L, !anyDuplicated(livraisons$date),
          identical(livraisons$date[1], as.Date('2020-01-01')),
          identical(livraisons$date[72], as.Date('2025-12-01')),
          !anyNA(livraisons$livraisons),
          all(diff(12L * as.integer(format(livraisons$date, '%Y')) +
                     as.integer(format(livraisons$date, '%m'))) == 1L))
apprentissage <- livraisons |> slice_head(n = 60)
validation <- livraisons |> slice_tail(n = 12)
```

## Explorer le passé

``` r
ggplot(apprentissage, aes(date, livraisons)) +
  geom_line(colour = '#0B4F6C') +
  labs(x = 'Mois', y = 'Livraisons par mois') + theme_minimal()
```

![](demonstrations_files/figure-html/unnamed-chunk-2-1.png)

``` r
ggplot(apprentissage, aes(mois, livraisons, group = format(date, '%Y'),
                          colour = format(date, '%Y'))) +
  geom_line() + labs(x = 'Mois', y = 'Livraisons par mois', colour = 'Année') +
  theme_minimal()
```

![](demonstrations_files/figure-html/unnamed-chunk-2-2.png)

## Construire les prévisions

``` r
modele <- lm(livraisons ~ indice + mois, data = apprentissage)
summary(modele)$coefficients[c('indice', 'mois12'), , drop = FALSE]
```

            Estimate Std. Error   t value     Pr(>|t|)
    indice  3.786806    0.31141 12.160192 4.036617e-16
    mois12 82.545139   26.11577  3.160739 2.753293e-03

``` r
futur <- tibble(date = seq(as.Date('2025-01-01'), by = 'month', length.out = 12),
                indice = 61:72,
                mois = factor(sprintf('%02d', 1:12), levels = sprintf('%02d', 1:12)))
stopifnot(identical(futur$date, validation$date))
intervalle <- predict(modele, newdata = futur, interval = 'prediction', level = 0.95)
```

## Comparer et interpréter

``` r
comparaison <- futur |>
  transmute(date, observe = validation$livraisons,
            `Naïf saisonnier` = tail(apprentissage$livraisons, 12),
            `Tendance et mois` = as.numeric(intervalle[, 'fit'])) |>
  pivot_longer(-c(date, observe), names_to = 'methode', values_to = 'prevision') |>
  mutate(erreur = observe - prevision,
         cout = 2 * pmax(erreur, 0) + pmax(-erreur, 0))
comparaison |>
  group_by(methode) |>
  summarise(ME = mean(erreur), MAE = mean(abs(erreur)),
            RMSE = sqrt(mean(erreur^2)), cout_total_dollars = sum(cout), .groups = 'drop')
```

    # A tibble: 2 × 5
      methode              ME   MAE  RMSE cout_total_dollars
      <chr>             <dbl> <dbl> <dbl>              <dbl>
    1 Naïf saisonnier  36.6    64.8  72.8              1385 
    2 Tendance et mois  0.475  34.6  46.2               625.

``` r
ggplot(comparaison, aes(date, prevision, colour = methode)) +
  geom_line() + geom_line(aes(y = observe), colour = 'black', linewidth = 0.8) +
  labs(x = 'Mois de validation', y = 'Livraisons par mois',
       colour = 'Prévision', caption = 'Noir : livraisons observées') + theme_minimal()
```

![](demonstrations_files/figure-html/unnamed-chunk-4-1.png)

``` r
intervalle[1, , drop = FALSE]
```

           fit      lwr      upr
    1 1189.525 1096.536 1282.514

## Lire les résultats

Avec erreur = observé − prévu, une ME positive signifie une sous-prévision moyenne; MAE et RMSE sont en livraisons. La RMSE accorde plus de poids aux grands écarts. Le coût total additionne 2 \$ par livraison sous-prévue et 1 \$ par livraison sur-prévue, sans représenter une facture réelle.

La pente correspond à la variation moyenne mensuelle à mois donné. Le coefficient de décembre compare décembre à janvier à indice identique selon le modèle; il ne démontre pas une cause. Les intervalles classiques de `predict.lm()` reposent notamment sur une forme adéquate et sur des hypothèses concernant les erreurs. Des erreurs dépendantes dans le temps peuvent les rendre inadéquats. Les intervalles mensuels ne garantissent pas simultanément toute l’année.

## Décision

Comparez les deux méthodes à partir des mesures calculées et du scénario de coût. Un classement sur douze mois ne garantit pas le classement futur; il faut le vérifier à d’autres origines. Une prévision ne détermine pas à elle seule une flotte ou un horaire optimal.

La [comparaison hebdomadaire des modules 06 et 07](../../modules/atelier-03-series-chronologiques/demonstration-hebdomadaire.llms.md) est conservée pour révision; sa validation avait déjà été examinée. Les [exercices mensuels complémentaires](../../modules/atelier-03-series-chronologiques/exercices.llms.md) restent facultatifs.

## Holt accompagné

La [comparaison hebdomadaire antérieure](../../modules/atelier-03-series-chronologiques/demonstration-hebdomadaire.llms.md#holt) conserve Holt amorti et ses intervalles comme complément facultatif.

## Examiner l’écart maximal

L’[exemple antérieur](../../modules/atelier-03-series-chronologiques/demonstration-hebdomadaire.llms.md#erreur-max) conserve le calcul d’un écart maximal.
