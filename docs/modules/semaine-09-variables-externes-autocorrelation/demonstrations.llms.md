# Démonstrations R - Module 09

Le cas reprend les ventes commerciales du transfert du module 08. Les données sont fictives. Les 60 premiers mois servent à ajuster les modèles; les 12 mois de 2025 servent à les comparer. Ils ont déjà été consultés au module 08 : ce bloc ne constitue pas un test final indépendant.

## Préparation

Installez `tidyverse` et `forecast` au besoin, ouvrez le projet et exécutez les blocs dans l’ordre. Le code est complet dans une session neuve.

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

## 1. Disponibilité

Les valeurs de 2025 dans le fichier sont observées après coup. Une promotion pourrait être connue si elle était déjà approuvée; un prix peut être planifié ou scénarisé; l’indice peut être prévu séparément. Aucune de ces disponibilités n’est attestée par le fichier fictif. Les ventes futures sont la cible.

``` r
ventes |> select(date, ventes, promotion, prix_moyen, indice_confiance) |> slice_head(n = 4)
```

    # A tibble: 4 × 5
      date       ventes promotion prix_moyen indice_confiance
      <date>      <dbl> <fct>          <dbl>            <dbl>
    1 2020-01-01 309720 non             59.7             99.6
    2 2020-02-01 329533 non             58.3            101.
    3 2020-03-01 332527 non             58.4            101.
    4 2020-04-01 325184 non             59.2            100.

## 2. Régression conditionnelle

La catégorie de référence est `non`. La pente de promotion compare deux valeurs ajustées, avec les autres variables maintenues fixes. Les données observationnelles ne garantissent pas une interprétation causale.

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

## 3. Autocorrélation des résidus

Une erreur positive signifie une observation supérieure à la valeur ajustée. L’ACF présente la corrélation estimée à chaque retard; l’incertitude est importante avec 60 mois. Le test facultatif de Ljung-Box regroupe les retards jusqu’à 12. Elle est approximative ici, notamment après ajustement de nombreux coefficients : elle complète les graphiques et ne prouve pas la blancheur des résidus.

``` r
residus_lm <- residuals(modele_lm)
plot(entrainement$date, residus_lm, type = "l", xlab = "Mois", ylab = "Résidu (dollars)")
abline(h = 0, lty = 2)
```

![](demonstrations_files/figure-html/unnamed-chunk-3-1.png)

``` r
acf(residus_lm, lag.max = 12, main = "ACF des résidus")
```

![](demonstrations_files/figure-html/unnamed-chunk-3-2.png)

``` r
Box.test(residus_lm, lag = 12, type = "Ljung-Box", fitdf = 0)
```


        Box-Ljung test

    data:  residus_lm
    X-squared = 22.853, df = 12, p-value = 0.029

## 4. Comparaison accompagnée avec erreurs AR(1)

Pour l’activité 9.4, vous pouvez exécuter le code complet ci-dessous et vous concentrer sur la comparaison et ses limites. L’ajustement AR(1) est présenté comme un approfondissement accompagné : sa construction de mémoire n’est pas exigée. Les candidats possèdent les mêmes prédicteurs. La régression avec erreurs AR(1) modélise la dépendance de la partie non expliquée par ces prédicteurs. Les valeurs externes réalisées en 2025 sont utilisées dans les deux modèles : la comparaison est rétrospective et conditionnelle, pas une preuve de performance opérationnelle à l’origine de fin 2024. Les intervalles AR(1) conditionnent eux aussi sur les prédicteurs fournis.

``` r
formule_x <- ~ tendance + promotion + prix_moyen + indice_confiance + mois
x_train <- model.matrix(formule_x, data = entrainement)[, -1, drop = FALSE]
x_validation <- model.matrix(formule_x, data = validation)[, -1, drop = FALSE]
stopifnot(identical(colnames(x_train), colnames(x_validation)))
modele_ar1 <- Arima(entrainement$ventes, xreg = x_train, order = c(1, 0, 0), include.mean = TRUE)
prevision_ar1 <- forecast(modele_ar1, xreg = x_validation, h = nrow(validation), level = c(80, 95))
comparaison <- validation |>
  transmute(date, observe = ventes, regression = as.numeric(predict(modele_lm, newdata = validation)),
            erreurs_ar1 = as.numeric(prevision_ar1$mean)) |>
  pivot_longer(c(regression, erreurs_ar1), names_to = "methode", values_to = "prevision") |>
  mutate(erreur = observe - prevision)
scores <- comparaison |>
  group_by(methode) |>
  summarise(ME = mean(erreur), MAE = mean(abs(erreur)), RMSE = sqrt(mean(erreur^2)), .groups = "drop")
scores
```

    # A tibble: 2 × 4
      methode        ME   MAE  RMSE
      <chr>       <dbl> <dbl> <dbl>
    1 erreurs_ar1 1408. 5380. 6417.
    2 regression  1474. 5088. 6272.

Pour approfondir, examinez aussi les innovations du modèle AR(1). Leur test reste indicatif après estimation.

``` r
innovations <- residuals(modele_ar1)
acf(innovations, lag.max = 12, main = "ACF des innovations du modèle AR(1)")
```

![](demonstrations_files/figure-html/unnamed-chunk-5-1.png)

``` r
Box.test(innovations, lag = 12, type = "Ljung-Box", fitdf = 1)
```


        Box-Ljung test

    data:  innovations
    X-squared = 6.1972, df = 11, p-value = 0.8599

La ligne noire représente les ventes observées; les deux lignes colorées représentent les prévisions.

``` r
comparaison |> ggplot(aes(date, observe)) +
  geom_line(colour = "black") + geom_line(aes(y = prevision, colour = methode)) +
  labs(x = "Mois de 2025", y = "Ventes (dollars)", colour = "Modèle") + theme_minimal()
```

![](demonstrations_files/figure-html/unnamed-chunk-6-1.png)

## 5. Scénario

Pour janvier 2025, on suppose un prix de 60 \$ par unité et un indice de 100 points avec ou sans promotion. Les valeurs sont hypothétiques. La différence entre les prévisions est une association du modèle; elle n’établit pas l’effet d’une intervention. Elle ne tient pas compte de l’incertitude sur les valeurs futures des prédicteurs.

``` r
scenario <- tibble(tendance = 61, mois = factor(1, levels = 1:12),
                   promotion = factor(c("non", "oui"), levels = c("non", "oui")),
                   prix_moyen = 60, indice_confiance = 100)
scenario <- scenario |> mutate(prevision = as.numeric(predict(modele_lm, newdata = scenario)))
scenario
```

    # A tibble: 2 × 6
      tendance mois  promotion prix_moyen indice_confiance prevision
         <dbl> <fct> <fct>          <dbl>            <dbl>     <dbl>
    1       61 1     non               60              100   498619.
    2       61 1     oui               60              100   546185.

## Pour conclure

Comparez les scores calculés sans présumer quel modèle gagne. Un meilleur résultat sur ce bloc ne garantit pas une amélioration future; testez un scénario disponible à l’origine et une période ultérieure quand elles existeront.
