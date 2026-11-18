# Démonstrations R - Module 09

Le cas reprend les ventes commerciales du transfert du module 08. Les données sont fictives. Les 60 premiers mois servent à ajuster les modèles; les 12 mois de 2025 servent à les comparer. Ils ont déjà été consultés au module 08 : ce bloc ne constitue pas un test final indépendant.

## Préparation

Dans RStudio, ouvrez `variables-ventes.Rproj`, puis `variables_ventes.qmd`. Si nécessaire, installez `tidyverse` et `forecast` une première fois. Exécutez ensuite les blocs dans l’ordre. Dans ce cas, « janvier » est un niveau du facteur mois. Le traiter comme le nombre 1 dans une pente linéaire imposerait le même changement de janvier à février que de novembre à décembre.

Avant de lancer le modèle, demandez-vous ce que vous devriez voir dans les deux objets. La dernière ligne de `entrainement` devrait être décembre 2024, et la première de `validation` janvier 2025. Chaque ligne est un mois, quel que soit le nombre de transactions ce mois-là.

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
ventes |>
  filter(date %in% as.Date(c("2024-12-01", "2025-01-01"))) |>
  select(date, ventes, promotion, prix_moyen, indice_confiance)
```

    # A tibble: 2 × 5
      date       ventes promotion prix_moyen indice_confiance
      <date>      <dbl> <fct>          <dbl>            <dbl>
    1 2024-12-01 542217 non             61.2             112.
    2 2025-01-01 526715 non             61.6             111.

Le prix moyen de janvier est 61,59 \$ et l’indice vaut 111,1 dans le fichier terminé. Pour refaire la décision de décembre, cachez ces deux cellules et les ventes de janvier. Le mois reste connu. Pour le prix, il faudrait un tarif daté et une hypothèse sur les transactions. Pour l’indice, il faudrait une prévision disponible à l’origine ou une valeur de scénario. Conservez cette distinction dans l’activité 9.1.

## 2. Régression conditionnelle

### Commencer par les groupes observés

``` r
entrainement |>
  group_by(promotion) |>
  summarise(mois_observes = n(), ventes_moyennes = mean(ventes),
            prix_moyen_du_groupe = mean(prix_moyen), .groups = "drop")
```

    # A tibble: 2 × 4
      promotion mois_observes ventes_moyennes prix_moyen_du_groupe
      <fct>             <int>           <dbl>                <dbl>
    1 non                  42         420892.                 59.8
    2 oui                  18         503764.                 55.9

Les 18 mois avec promotion affichent en moyenne 503 764 \$ de ventes, contre 420 892 \$ pour les 42 autres. Ils ont aussi un prix moyen plus bas, 55,87 \$ contre 59,81 \$. Soustrayez les ventes. Le résultat décrit les deux groupes tels qu’ils se présentent dans les données. Pour parler d’un même mois à un même prix, il faut poser une autre question.

### Construire la comparaison ajustée

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

Pour deux profils identiques sauf la promotion, la différence ajustée est de 47 566 \$. Si le prix baisse aussi d’un dollar, deux termes changent. La pente estimée du prix est d’environ −4 895 \$ de ventes par dollar de prix. Le contraste devient donc 47 566 + 4 895 ≈ 52 461 \$. Cette arithmétique décrit l’équation ajustée. Le fichier ne révèle pas pourquoi les responsables ont choisi les mois des campagnes.

## 3. Autocorrélation des résidus

Une erreur positive signifie une observation supérieure à la valeur ajustée. L’ACF présente la corrélation estimée à chaque retard; l’incertitude est importante avec 60 mois. Le test facultatif de Ljung-Box regroupe les retards jusqu’à 12. La valeur p est approximative ici, notamment après ajustement de nombreux coefficients : elle complète les graphiques et ne prouve pas la blancheur des résidus.

### Partir d’un mois identifiable

``` r
diagnostic_mois <- entrainement |>
  transmute(date, ventes, ajustees = fitted(modele_lm),
            residu = ventes - ajustees, precedent = lag(residu))
diagnostic_mois |> filter(between(date, as.Date("2020-05-01"), as.Date("2020-08-01")))
```

    # A tibble: 4 × 5
      date       ventes ajustees  residu precedent
      <date>      <dbl>    <dbl>   <dbl>     <dbl>
    1 2020-05-01 405161  407153.  -1992.    -5371.
    2 2020-06-01 338213  343286.  -5073.    -1992.
    3 2020-07-01 316643  338760. -22117.    -5073.
    4 2020-08-01 405192  417161. -11969.   -22117.

En juillet 2020, le résidu vaut 316 643 − 338 760 ≈ −22 117 \$. En juin, il était déjà négatif. Sur le tracé chronologique, ce sont deux points voisins sous zéro. Pour le retard 1, ce sont les deux coordonnées d’une seule paire. Les 60 mois donnent 59 paires voisines et 48 paires séparées d’une année.

### Passer des dates aux retards

``` r
residus_lm <- residuals(modele_lm)
plot(entrainement$date, residus_lm, type = "l", xlab = "Mois", ylab = "Résidu (dollars)")
abline(h = 0, lty = 2)
```

![](demonstrations_files/figure-html/unnamed-chunk-6-1.png)

``` r
acf(residus_lm, lag.max = 12, main = "ACF des résidus")
```

![](demonstrations_files/figure-html/unnamed-chunk-6-2.png)

``` r
a <- acf(residus_lm, lag.max = 12, plot = FALSE)
tibble(retard = as.numeric(a$lag), correlation = as.numeric(a$acf)) |>
  filter(retard %in% c(0, 1, 12))
```

    # A tibble: 3 × 2
      retard correlation
       <dbl>       <dbl>
    1      0       1    
    2      1       0.413
    3     12      -0.295

Le retard zéro compare chaque résidu à lui-même et vaut 1. La barre suivante décrit les mois voisins. Une même valeur d’ACF peut résulter de séquences placées à des dates différentes, d’où l’intérêt du premier graphique.

Pour le test facultatif mentionné ci-dessus :

``` r
Box.test(residus_lm, lag = 12, type = "Ljung-Box", fitdf = 0)
```


        Box-Ljung test

    data:  residus_lm
    X-squared = 22.853, df = 12, p-value = 0.029

Au retard 1, l’ACF des résidus vaut environ 0,41. Au retard 12, elle vaut environ −0,30. Ces deux barres dépassent en valeur absolue le repère approximatif de 0,25. La première suggère que des écarts de même signe tendent à se suivre. Une seule barre au retard 12 ne suffit pas à identifier un mécanisme saisonnier.

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

### Vérifier le classement avant de conclure

``` r
comparaison |>
  filter(date %in% as.Date(c("2025-01-01", "2025-07-01"))) |>
  select(date, methode, observe, prevision, erreur)
```

    # A tibble: 4 × 5
      date       methode     observe prevision erreur
      <date>     <chr>         <dbl>     <dbl>  <dbl>
    1 2025-01-01 regression   526715   520664.  6051.
    2 2025-01-01 erreurs_ar1  526715   518310.  8405.
    3 2025-07-01 regression   615840   600840. 15000.
    4 2025-07-01 erreurs_ar1  615840   602557. 13283.

En janvier, les deux modèles sous-prévoient. L’erreur absolue est plus faible pour la régression ordinaire (environ 6 051 \$ contre 8 405 \$). En juillet, l’ordre s’inverse (15 000 \$ contre 13 283 \$). Choisir un seul mois après avoir vu les résultats changerait la question. Le tableau des scores utilise les douze mois pour les deux candidats.

Sur les douze mois de 2025, la régression ordinaire donne une MAE de 5 088 \$ et une RMSE de 6 272 \$. Avec les erreurs AR(1), on obtient 5 380 \$ et 6 417 \$. Les deux critères favorisent ici la régression ordinaire malgré l’autocorrélation observée à l’entraînement.

Pour approfondir, examinez aussi les innovations du modèle AR(1). Leur test reste indicatif après estimation.

``` r
innovations <- residuals(modele_ar1)
acf(innovations, lag.max = 12, main = "ACF des innovations du modèle AR(1)")
```

![](demonstrations_files/figure-html/unnamed-chunk-11-1.png)

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

![](demonstrations_files/figure-html/unnamed-chunk-12-1.png)

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

Vérifiez si le prix du scénario a déjà été observé dans chaque groupe de promotion.

``` r
entrainement |>
  group_by(promotion) |>
  summarise(prix_min = min(prix_moyen), prix_max = max(prix_moyen), .groups = "drop")
```

    # A tibble: 2 × 3
      promotion prix_min prix_max
      <fct>        <dbl>    <dbl>
    1 non           57.5     62.7
    2 oui           53.2     57.9

À 60 \$ et avec un indice de 100, le modèle prévoit 498 619 \$ sans promotion et 546 185 \$ avec promotion. Le prix de 60 \$ appartient à la plage observée sans promotion (57,47 à 62,72 \$). En promotion, les prix observés vont de 53,17 à 57,86 \$. Le scénario avec promotion extrapole donc la relation ajustée au-delà des prix observés dans ce groupe.

### Modifier une hypothèse à la fois

``` r
variantes <- expand_grid(
  prix_moyen = c(57.70, 60), indice_confiance = c(100, 105),
  promotion = factor(c("non", "oui"), levels = levels(entrainement$promotion))
) |> mutate(tendance = 61, mois = factor(1, levels = levels(entrainement$mois)))
resultats_scenario <- bind_cols(variantes, as_tibble(
  predict(modele_lm, newdata = variantes, interval = "prediction", level = 0.95)
))
resultats_scenario |> select(prix_moyen, indice_confiance, promotion, fit, lwr, upr)
```

    # A tibble: 8 × 6
      prix_moyen indice_confiance promotion     fit     lwr     upr
           <dbl>            <dbl> <fct>       <dbl>   <dbl>   <dbl>
    1       57.7              100 non       509878. 468863. 550893.
    2       57.7              100 oui       557444. 520709. 594179.
    3       57.7              105 non       523314. 491215. 555412.
    4       57.7              105 oui       570880. 543745. 598014.
    5       60                100 non       498619. 459670. 537568.
    6       60                100 oui       546185. 508885. 583485.
    7       60                105 non       512055. 482727. 541383.
    8       60                105 oui       559621. 531817. 587426.

À 57,70 \$, les deux groupes ont une plage de prix compatible avec le scénario. L’écart entre les prévisions demeure 47 566 \$, car la formule ne comporte aucune interaction entre prix et promotion. Cela ne garantit pas que les deux profils complets ont été fréquemment observés.

À 60 \$, sans promotion, faire passer l’indice de 100 à 105 déplace la prévision de 498 619 \$ à 512 055 \$. Les colonnes `lwr` et `upr` répondent à une autre question. Pour la première de ces lignes, elles donnent environ 459 670 à 537 568 \$ pour une nouvelle vente mensuelle sous les entrées fixées. Il s’agit de l’intervalle classique de `lm`. Sa couverture théorique suppose notamment des erreurs indépendantes, alors que le diagnostic temporel invite ici à la prudence. La variation future de l’indice n’y est pas incorporée.

## Pour conclure

Comparez les scores calculés sans présumer quel modèle gagne. Un meilleur résultat sur ce bloc ne garantit pas une amélioration future; testez un scénario disponible à l’origine et une période ultérieure quand elles existeront.
