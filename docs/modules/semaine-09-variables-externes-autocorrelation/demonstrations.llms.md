# Démonstrations R - Module 09

## Préparation

``` r
library(tidyverse)
library(broom)
library(forecast)

data_path <- if (file.exists("data/ventes_promotions_quebec.csv")) {
  "data/ventes_promotions_quebec.csv"
} else {
  "modules/semaine-09-variables-externes-autocorrelation/data/ventes_promotions_quebec.csv"
}

ventes <- read_csv(data_path, show_col_types = FALSE) |>
  mutate(
    date = as.Date(date),
    promotion = factor(promotion, levels = c("non", "oui")),
    mois = factor(mois)
  ) |>
  arrange(date)

entrainement <- ventes |> slice_head(n = nrow(ventes) - 12)
test <- ventes |> slice_tail(n = 12)
```

## 1. Visualiser cible et prédicteurs

``` r
ventes |>
  select(date, ventes, prix_moyen, indice_confiance, budget_marketing) |>
  pivot_longer(-date, names_to = "variable", values_to = "valeur") |>
  ggplot(aes(date, valeur)) +
  geom_line(colour = "#0B4F6C") +
  facet_wrap(~ variable, scales = "free_y", ncol = 1) +
  labs(title = "Cible et variables externes", x = NULL, y = NULL) +
  theme_minimal(base_size = 11)
```

![](demonstrations_files/figure-html/unnamed-chunk-1-1.png)

## 2. Ajuster une régression ordinaire

``` r
modele_lm <- lm(
  ventes ~ tendance + promotion + prix_moyen + indice_confiance + mois,
  data = entrainement
)

tidy(modele_lm, conf.int = TRUE) |>
  filter(term %in% c("tendance", "promotionoui", "prix_moyen", "indice_confiance"))
```

    # A tibble: 4 × 7
      term             estimate std.error statistic  p.value conf.low conf.high
      <chr>               <dbl>     <dbl>     <dbl>    <dbl>    <dbl>     <dbl>
    1 tendance            3087.      280.     11.0  3.18e-14    2522.     3653.
    2 promotionoui       47566.     7397.      6.43 7.85e- 8   32659.    62473.
    3 prix_moyen         -4895.     1628.     -3.01 4.36e- 3   -8177.    -1613.
    4 indice_confiance    2687.     1270.      2.12 4.00e- 2     128.     5246.

## 3. Diagnostiquer les résidus temporels

``` r
residus_lm <- residuals(modele_lm)

par(mfrow = c(1, 2))
plot(entrainement$date, residus_lm, type = "l", xlab = "Date", ylab = "Résidu")
abline(h = 0, lty = 2)
acf(residus_lm, main = "Autocorrélation des résidus")
```

![](demonstrations_files/figure-html/unnamed-chunk-3-1.png)

``` r
par(mfrow = c(1, 1))

Box.test(residus_lm, lag = 12, type = "Ljung-Box", fitdf = 0)
```


        Box-Ljung test

    data:  residus_lm
    X-squared = 22.853, df = 12, p-value = 0.029

## 4. Ajuster une régression avec erreurs AR(1)

``` r
x_train <- model.matrix(
  ~ tendance + promotion + prix_moyen + indice_confiance + mois,
  data = entrainement
)[, -1, drop = FALSE]

x_test <- model.matrix(
  ~ tendance + promotion + prix_moyen + indice_confiance + mois,
  data = test
)[, -1, drop = FALSE]

modele_ar1 <- Arima(
  entrainement$ventes,
  xreg = x_train,
  order = c(1, 0, 0),
  include.mean = TRUE
)

prevision_ar1 <- forecast(modele_ar1, xreg = x_test, h = nrow(test))
```

## 5. Comparer sur la période test

``` r
comparaison <- test |>
  transmute(
    date,
    observe = ventes,
    regression = predict(modele_lm, newdata = test),
    erreurs_ar1 = as.numeric(prevision_ar1$mean)
  ) |>
  pivot_longer(regression:erreurs_ar1, names_to = "methode", values_to = "prevision") |>
  mutate(erreur = observe - prevision)

comparaison |>
  group_by(methode) |>
  summarise(
    MAE = mean(abs(erreur)),
    RMSE = sqrt(mean(erreur^2)),
    .groups = "drop"
  )
```

    # A tibble: 2 × 3
      methode       MAE  RMSE
      <chr>       <dbl> <dbl>
    1 erreurs_ar1 5380. 6417.
    2 regression  5088. 6272.

## Interprétation

La comparaison indique si la structure AR(1) améliore la prévision sur cette période. Elle ne transforme pas les coefficients de promotion ou de prix en effets causaux et reste conditionnelle aux valeurs externes utilisées pour le test.
