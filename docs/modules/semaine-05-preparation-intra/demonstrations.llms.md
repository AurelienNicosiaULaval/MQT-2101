# Exemples commentés avec R - Module 05

## Avant de commencer

Prévoyez environ 45 minutes. Essayez d’annoncer ce que le code va produire avant de l’exécuter, puis expliquez le résultat. Les fichiers utilisés sont simulés pour le cours : [performance des succursales](../atelier-02-regression/data/performance_succursales_quebec.csv) et [achalandage](../semaine-04-regression-nonlineaire/data/achalandage_saturation_quebec.csv). Les exemples relient un indicateur de service et un indicateur de ventes, pour les contextes d’opérations et de gestion.

Les blocs suivants s’exécutent dans l’ordre depuis la racine du dépôt ou depuis ce module. Toutes les bibliothèques et importations sont présentes. Pour travailler dans RStudio, ouvrez le projet du cours et copiez les blocs dans un script; le CSV reste à son emplacement indiqué. Les corrigés des [exercices](../../modules/semaine-05-preparation-intra/exercices.llms.md) utilisent un autre fichier.

## 1. Lire la question et les données

Question : « Comment le score moyen mensuel de satisfaction est-il associé au délai moyen de service? » La réponse est `satisfaction`, en points sur 10; l’explicative est `delai_service_minutes`, en minutes. Une ligne correspond à une succursale observée pendant un mois. L’analyse ne porte pas sur des réponses individuelles de clients.

``` r
library(tidyverse)

# Repérer la racine sans imposer un chemin propre à un ordinateur.
racines <- c(".", "../..", "../../../..")
racine <- racines[file.exists(file.path(
  racines, "modules/atelier-02-regression/data/performance_succursales_quebec.csv"
))][1]
stopifnot(!is.na(racine))

performance <- read_csv(file.path(racine,
  "modules/atelier-02-regression/data/performance_succursales_quebec.csv"),
  show_col_types = FALSE) |>
  mutate(mois = as.Date(mois))

nombre_fr <- function(x, decimales = 2) {
  formatC(x, format = "f", digits = decimales,
          decimal.mark = ",", big.mark = " ")
}

glimpse(performance)
```

    Rows: 72
    Columns: 14
    $ mois                  <date> 2025-01-01, 2025-01-01, 2025-01-01, 2025-01-01,…
    $ mois_label            <chr> "janvier", "janvier", "janvier", "janvier", "jan…
    $ saison                <chr> "moyenne", "moyenne", "moyenne", "moyenne", "moy…
    $ succursale            <chr> "Gatineau", "Montréal", "Québec", "Saguenay", "S…
    $ region                <chr> "Outaouais", "Montréal", "Capitale-Nationale", "…
    $ surface_m2            <dbl> 420, 560, 470, 350, 390, 365, 420, 560, 470, 350…
    $ campagne_locale       <chr> "oui", "oui", "non", "non", "oui", "non", "non",…
    $ depenses_marketing    <dbl> 5977, 6162, 4978, 2981, 5061, 3279, 4677, 4693, …
    $ achalandage           <dbl> 1653, 2043, 1864, 1202, 1362, 1369, 1486, 2179, …
    $ heures_personnel      <dbl> 483, 528, 499, 450, 476, 493, 498, 577, 495, 465…
    $ ruptures_stock        <dbl> 1, 1, 2, 1, 0, 1, 0, 1, 6, 3, 0, 2, 1, 0, 1, 2, …
    $ delai_service_minutes <dbl> 5.5, 6.8, 3.8, 5.4, 3.8, 5.5, 5.0, 6.2, 6.5, 5.3…
    $ satisfaction          <dbl> 7.7, 8.0, 7.7, 7.4, 8.7, 8.4, 8.6, 8.3, 7.1, 7.6…
    $ ventes                <dbl> 163260, 180567, 166706, 126460, 151254, 132775, …

``` r
performance |>
  summarise(lignes = n(), succursales = n_distinct(succursale),
            mois = n_distinct(mois),
            delais_manquants = sum(is.na(delai_service_minutes)),
            scores_manquants = sum(is.na(satisfaction)))
```

    # A tibble: 1 × 5
      lignes succursales  mois delais_manquants scores_manquants
       <int>       <int> <int>            <int>            <int>
    1     72           6    12                0                0

``` r
performance |> count(mois, succursale) |> filter(n > 1)
```

    # A tibble: 0 × 3
    # ℹ 3 variables: mois <date>, succursale <chr>, n <int>

``` r
# Conserver les mêmes lignes pour le graphique et le modèle.
analyse <- performance |>
  drop_na(delai_service_minutes, satisfaction)
range(analyse$delai_service_minutes)
```

    [1] 3.6 8.7

Raisonnement : le fichier contient 72 lignes et 6 succursales observées pendant 12 mois. Les deux variables étudiées sont complètes; le contrôle de clé ne trouve pas de doublon. La plage des délais est de 3,6 à 8,7 minutes. Ces contrôles ne prouvent pas que toutes les hypothèses d’un modèle sont valides.

## 2. Justifier une représentation

``` r
ggplot(analyse, aes(x = delai_service_minutes, y = satisfaction)) +
  geom_point(aes(colour = succursale), alpha = 0.8) +
  geom_smooth(method = "lm", se = FALSE, colour = "#0B4F6C") +
  labs(x = "Délai moyen de service (minutes)",
       y = "Score moyen de satisfaction (sur 10)", colour = "Succursale") +
  theme_minimal(base_size = 12)
```

![](demonstrations_files/figure-html/m05-demo-nuage-1.png)

Raisonnement : deux variables numériques appellent un nuage de points. La couleur rappelle que les succursales se répètent. La droite résume une association moyenne décroissante, avec dispersion; elle ne décrit pas le changement certain d’un client ni l’effet d’une intervention sur le délai.

## 3. Ajuster et lire une sortie R

``` r
modele_service <- lm(satisfaction ~ delai_service_minutes, data = analyse)
summary(modele_service)
```


    Call:
    lm(formula = satisfaction ~ delai_service_minutes, data = analyse)

    Residuals:
         Min       1Q   Median       3Q      Max
    -1.03399 -0.38662  0.06738  0.41842  0.88058

    Coefficients:
                          Estimate Std. Error t value Pr(>|t|)
    (Intercept)            9.77363    0.31188  31.338  < 2e-16 ***
    delai_service_minutes -0.32640    0.05164  -6.321 2.11e-08 ***
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 0.4875 on 70 degrees of freedom
    Multiple R-squared:  0.3633,    Adjusted R-squared:  0.3543
    F-statistic: 39.95 on 1 and 70 DF,  p-value: 2.11e-08

``` r
confint(modele_service, "delai_service_minutes", level = 0.95)
```

                               2.5 %     97.5 %
    delai_service_minutes -0.4293887 -0.2234035

La droite estimée est \\\widehat{\text{satisfaction}}=\\ 9,774 \\-\\ 0,326 \\\times\text{délai en minutes}\\.

Pour une minute de délai supplémentaire, le score moyen estimé est inférieur d’environ 0,326 point sur 10, selon ce modèle. Le coefficient n’est pas un pourcentage de clients. L’intercept correspond à zéro minute; ce délai est hors de la plage observée et sa valeur ne constitue pas une mesure réellement observée.

La ligne de pente donne une valeur p inférieure à 0,001 : au seuil de 5 %, on rejette l’hypothèse d’une pente nulle sous les hypothèses classiques. Cela n’établit pas une causalité. L’intervalle de pente va de -0,429 à -0,223 point par minute. Le R² vaut 0,363 : la droite décrit environ 36,3 % de la variation observée du score, sur l’ajustement.

## 4. Prédire et calculer un résidu

``` r
scenario <- tibble(delai_service_minutes = 6)
prediction <- predict(modele_service, newdata = scenario,
                      interval = "prediction", level = 0.95)
prediction
```

           fit      lwr      upr
    1 7.815258 6.836298 8.794218

``` r
# Une observation réellement présente dans le fichier.
observation <- analyse |> slice(1)
valeur_ajustee <- as.numeric(predict(modele_service, newdata = observation))
tibble(score_observe = observation$satisfaction,
       score_ajuste = valeur_ajustee,
       residu = observation$satisfaction - valeur_ajustee)
```

    # A tibble: 1 × 3
      score_observe score_ajuste residu
              <dbl>        <dbl>  <dbl>
    1           7.7         7.98 -0.278

Pour six minutes, la valeur estimée est 7,82 points sur 10. Le scénario est dans la plage, ce qui évite une extrapolation sur le délai sans garantir le contexte. L’intervalle de 6,84 à 8,79 concerne un nouveau score mensuel de succursale, sous le modèle classique. Un intervalle de confiance viserait la moyenne de ces scores conditionnellement au délai.

La première ligne a un score de 7,7; sa valeur ajustée est 7,98. Son résidu vaut -0,28 point. Il est négatif : la droite surestime ce score. On utilise les coefficients non arrondis pour les calculs; un calcul manuel avec des coefficients arrondis peut différer légèrement.

## 5. Décrire le diagnostic réellement obtenu

``` r
diagnostic <- analyse |>
  mutate(score_ajuste = fitted(modele_service),
         residu = residuals(modele_service))
ggplot(diagnostic, aes(score_ajuste, residu)) +
  geom_hline(yintercept = 0, colour = "#7A1C24") +
  geom_point(aes(colour = succursale), alpha = 0.8) +
  labs(x = "Score ajusté (sur 10)", y = "Résidu (points sur 10)",
       colour = "Succursale") +
  theme_minimal(base_size = 12)
```

![](demonstrations_files/figure-html/m05-demo-residus-1.png)

``` r
diagnostic |>
  group_by(succursale) |>
  summarise(residu_moyen = mean(residu), .groups = "drop")
```

    # A tibble: 6 × 2
      succursale     residu_moyen
      <chr>                 <dbl>
    1 Gatineau            0.0227
    2 Montréal            0.336
    3 Québec             -0.102
    4 Saguenay           -0.0986
    5 Sherbrooke         -0.149
    6 Trois-Rivières     -0.00912

Raisonnement : décrire une courbure, une dispersion changeante ou une différence entre groupes exige de regarder la figure et les résultats. Les résidus moyens des succursales vont ici de -0,149 à 0,336 point. Cette variation appelle une vérification du contexte des succursales. La moyenne globale proche de zéro est une propriété des moindres carrés avec constante; elle ne valide pas l’indépendance des erreurs. Les mois répétés et le caractère agrégé des scores limitent l’interprétation des intervalles classiques.

## 6. Comparer droite, quadratique et logarithme

Reprenons le cas du module 04. La réponse reste les ventes en dollars canadiens; x est l’achalandage en milliers de visites. La séparation déjà enseignée est conservée : janvier-septembre pour ajuster; octobre-décembre pour comparer.

``` r
saturation <- read_csv(file.path(racine,
  "modules/semaine-04-regression-nonlineaire/data/achalandage_saturation_quebec.csv"),
  show_col_types = FALSE) |>
  mutate(mois = as.Date(mois), x = achalandage / 1000)
stopifnot(!anyNA(saturation[c("mois", "x", "ventes")]), all(saturation$x > 0))
apprentissage <- saturation |> filter(mois < as.Date("2025-10-01"))
validation <- saturation |> filter(mois >= as.Date("2025-10-01"))

modeles <- list(
  Droite = lm(ventes ~ x, data = apprentissage),
  Quadratique = lm(ventes ~ x + I(x^2), data = apprentissage),
  Logarithmique = lm(ventes ~ log(x), data = apprentissage)
)
rmse <- function(observe, predit) {
  stopifnot(length(observe) == length(predit),
            !anyNA(observe), !anyNA(predit))
  sqrt(mean((observe - predit)^2))
}
comparaison <- imap_dfr(modeles, function(ajustement, nom) {
  tibble(modele = nom, n_apprentissage = nobs(ajustement),
         r2 = summary(ajustement)$r.squared,
         rmse_apprentissage = rmse(apprentissage$ventes, fitted(ajustement)),
         n_validation = nrow(validation),
         rmse_validation = rmse(validation$ventes,
                                predict(ajustement, newdata = validation)))
})
comparaison
```

    # A tibble: 3 × 6
      modele   n_apprentissage    r2 rmse_apprentissage n_validation rmse_validation
      <chr>              <int> <dbl>              <dbl>        <int>           <dbl>
    1 Droite                54 0.783              8707.           18          10155.
    2 Quadrat…              54 0.825              7817.           18           7237.
    3 Logarit…              54 0.819              7940.           18           8409.

La RMSE de validation est d’environ 10 155 \$ pour la droite, 7 237 \$ pour la quadratique et 8 409 \$ pour le logarithme. La quadratique est le choix provisoire selon ce critère. Il faut compléter le jugement par la forme et les résidus, comme dans la [démonstration du module 04](../../modules/semaine-04-regression-nonlineaire/demonstrations.llms.md). La période de validation ayant servi au choix ne fournit pas une évaluation finale indépendante de ce choix.

## 7. Expliquer une variation non linéaire

``` r
scenarios <- tibble(x = c(2, 2.1, 3, 3.1))
predictions_quad <- predict(modeles$Quadratique, newdata = scenarios)
tibble(comparaison = c("2 000 à 2 100 visites", "3 000 à 3 100 visites"),
       difference_dollars = c(diff(predictions_quad[1:2]),
                              diff(predictions_quad[3:4])))
```

    # A tibble: 2 × 2
      comparaison           difference_dollars
      <chr>                              <dbl>
    1 2 000 à 2 100 visites              3487.
    2 3 000 à 3 100 visites              1763.

``` r
# Une hausse relative de 10 % de x, dans le modèle logarithmique.
difference_log <- unname(coef(modeles$Logarithmique)[2] * log(1.10))
difference_log
```

    [1] 6142.589

Dans la quadratique, les 100 visites supplémentaires représentent 0,1 millier. Elles donnent une différence estimée de 3 487 \$ à partir de 2 000 visites et de 1 763 \$ à partir de 3 000 visites. La pente n’est pas constante. Dans le logarithme, la hausse relative de 10 % de x correspond à environ 6 143 \$ de ventes moyennes estimées; la réponse n’a pas été transformée.

## 8. Construire une conclusion défendable

Exemple sur le service : « Dans ces données simulées de 6 succursales, une minute de délai supplémentaire est associée à un score moyen estimé inférieur d’environ 0,326 point sur 10. Les résidus moyens varient entre succursales, ce qui demande de vérifier le contexte et les répétitions mensuelles avant d’utiliser l’incertitude classique pour décider. Cette droite décrit une association agrégée; elle ne prouve pas que réduire le délai provoquerait cette hausse de satisfaction. »

Les [exercices progressifs](../../modules/semaine-05-preparation-intra/exercices.llms.md) vous demandent ensuite de reconstruire ce raisonnement. La [pratique individuelle](../../modules/semaine-05-preparation-intra/pratique.llms.md) vérifie votre autonomie sans exécuter R.
