# Cahier facultatif - Tendance et saisonnalité

## Pourquoi conserver ce cahier?

Les cinq activités principales visent une comparaison simple avec tendance linéaire et mois. Ce cahier conserve les autres méthodes de l’ancienne séance, avec explications et calculs complets. Il sert de référence et de prolongement: il n’ajoute aucune compétence obligatoire aux deux rapports.

Les formes quadratique et exponentielle consolident les transformations déjà vues au module 04. L’activité 8.1 comprend une première lecture de décomposition dans la page guidée. Ce cahier approfondit la décomposition et les harmoniques. La stationnarité et KPSS constituent une ouverture avancée, sans prérequis à terminer le module ni test exigé dans la trace principale.

Le [projet facultatif téléchargeable](telechargements/complements-tendance.zip) contient ce cahier, les CSV, dictionnaires et fonctions. Les blocs se suivent depuis une session neuve; il n’est pas nécessaire de les copier dans vos rapports principaux.

## Préparation

Chargez `tidyverse` et `broom`. Les parties utilisant `forecast` et `tseries` chargent ces bibliothèques explicitement; installez-les une seule fois si nécessaire. Conservez `data/` et `R/`.

``` r
library(tidyverse)
library(broom)
source("R/fonctions-module08.R")
ventes <- read_csv("data/ventes_saisonnieres_quebec.csv", show_col_types = FALSE) |>
  preparer_calendrier()
stopifnot(nrow(ventes) == 72L)
apprentissage <- ventes |> slice_head(n = 60)
validation <- ventes |> slice_tail(n = 12)
# Les prédicteurs futurs sont construits sans les ventes ni le budget de validation.
futur <- calendrier_futur("2025-01-01", horizon = 12, dernier_indice = 60)
serie <- ts(apprentissage$ventes, frequency = 12, start = c(2020, 1))
```

``` r
# La cible, le calendrier et la séparation sont vérifiés avant l’ajustement.
apprentissage |> select(date, indice_temps, mois) |> slice(c(1, 2, 12, 13, 60))
```

    # A tibble: 5 × 3
      date       indice_temps mois    
      <date>            <int> <fct>   
    1 2020-01-01            1 janvier 
    2 2020-02-01            2 février 
    3 2020-12-01           12 décembre
    4 2021-01-01           13 janvier 
    5 2024-12-01           60 décembre

``` r
modele_tendance <- lm(ventes ~ indice_temps, data = apprentissage)
modele_saison <- lm(ventes ~ mois, data = apprentissage,
                    contrasts = list(mois = "contr.treatment"))
modele_calendrier <- lm(ventes ~ indice_temps + mois, data = apprentissage,
                        contrasts = list(mois = "contr.treatment"))
modeles <- list(Tendance = modele_tendance, Saison = modele_saison,
                Calendrier = modele_calendrier)
model.matrix(modele_calendrier)[c(1, 2, 12), c(1, 2, 3, 13)]
```

       (Intercept) indice_temps moisfévrier moisdécembre
    1            1            1           0            0
    2            1            2           1            0
    12           1           12           0            1

``` r
tidy(modele_calendrier, conf.int = TRUE) |>
  filter(term %in% c("indice_temps", "moisdécembre"))
```

    # A tibble: 2 × 7
      term         estimate std.error statistic  p.value conf.low conf.high
      <chr>           <dbl>     <dbl>     <dbl>    <dbl>    <dbl>     <dbl>
    1 indice_temps    2884.      71.9     40.1  5.03e-38    2740.     3029.
    2 moisdécembre   32705.    6026.       5.43 1.96e- 6   20582.    44829.

## 1. Trois formes de croissance et leurs combinaisons

Prérequis: régression et transformations du module 04. Une droite impose un montant constant par mois. Dans une quadratique, la variation entre t et t + 1 vaut beta_1 + beta_2(2t + 1); elle dépend donc de t. Une courbe qui suit bien le passé peut extrapoler rapidement et devenir irréaliste.

Le modèle log-linéaire impose une croissance par facteur exp(beta_1), soit exactement 100\[exp(beta_1) − 1\] % par mois pour sa courbe exponentielle. Il demande des valeurs positives. Si les erreurs sur log(y) sont normales et centrées, exp(eta) est une médiane conditionnelle; exp(eta + sigma²/2) est une moyenne lognormale, ici approchée avec l’écart-type résiduel estimé. Cette correction ne prouve ni normalité ni variance stable et ne représente pas toute l’incertitude des paramètres.

``` r
modele_quadratique <- lm(ventes ~ indice_temps + I(indice_temps^2), data = apprentissage)
modele_exponentiel <- lm(log(ventes) ~ indice_temps, data = apprentissage)
modele_calendrier_quad <- lm(ventes ~ indice_temps + I(indice_temps^2) + mois,
                            data = apprentissage, contrasts = list(mois = "contr.treatment"))
modele_calendrier_log <- lm(log(ventes) ~ indice_temps + mois,
                           data = apprentissage, contrasts = list(mois = "contr.treatment"))
formes <- list(Quadratique = modele_quadratique, Exponentielle = modele_exponentiel,
               Calendrier_quad = modele_calendrier_quad, Calendrier_log = modele_calendrier_log)
previsions_formes <- imap_dfr(formes, function(modele, nom) {
  tibble(date = futur$date, observe = validation$ventes, methode = nom,
         prevision = prevoir_original(modele, futur, nom %in% c("Exponentielle", "Calendrier_log")))
})
previsions_formes |> group_by(methode) |>
  group_modify(~ mesures08(.x$observe, .x$prevision)) |> ungroup() |> arrange(MAE)
```

    # A tibble: 4 × 4
      methode              ME    MAE   RMSE
      <chr>             <dbl>  <dbl>  <dbl>
    1 Calendrier_quad  -4892. 10145. 11740.
    2 Calendrier_log  -16765. 17078. 19543.
    3 Quadratique      -6302. 17716. 20723.
    4 Exponentielle   -17743. 22331. 26369.

``` r
tibble(pourcentage_mensuel = 100 * (exp(coef(modele_exponentiel)[["indice_temps"]]) - 1),
       mediane_janvier = exp(predict(modele_exponentiel, futur)[1]),
       moyenne_janvier_approchee = prevoir_original(modele_exponentiel, futur, TRUE)[1])
```

    # A tibble: 1 × 3
      pourcentage_mensuel mediane_janvier moyenne_janvier_approchee
                    <dbl>           <dbl>                     <dbl>
    1               0.786         472288.                   472700.

Toutes les erreurs sont calculées en dollars après le retour à l’échelle originale. Une RMSE en logarithmes ne se compare pas à une RMSE en dollars. Dans ce cas, aucune de ces formes ajoutées ne réduit la MAE du modèle linéaire avec mois, qui vaut environ 9 891 \$. Ce résultat sur une validation connue n’impose pas la même conclusion à d’autres séries.

Le modèle log avec mois représente des facteurs saisonniers sur la médiane conditionnelle; les coefficients mensuels exponentiés deviennent des rapports. Un AIC issu de log(y) ne se compare pas naïvement à celui d’un modèle de y sans tenir compte du changement de vraisemblance. Le choix des formes reste annoncé avant les scores.

> **TIP:**
>
> Une pente log de 0,01 signifie environ 1,005 % par mois, sans effet causal démontré. Une pente quadratique ne se résume pas au coefficient de t. Une bonne valeur p ou un bon R² ne garantit pas l’extrapolation.

## 2. Décomposer une série et lire les indices

Une décomposition additive écrit y = tendance + saison + reste; l’écart saisonnier est dans l’unité de la cible. Une décomposition multiplicative écrit y = tendance × saison × reste; les saisons et le reste sont des facteurs. Un facteur de 1,20 indique 20 % au-dessus de la tendance estimée. Ces indices ne sont pas des effets causaux et ne sont pas automatiquement les contrastes d’une régression.

La décomposition classique estime une tendance par moyenne centrée et un motif saisonnier moyen. Elle laisse des valeurs de tendance manquantes aux extrémités et suppose une saison suffisamment stable. On l’applique seulement à l’apprentissage. L’histogramme décrit le mélange de mois et d’années; il ne vérifie pas la normalité des résidus.

``` r
ggplot(apprentissage, aes(ventes / 1000)) +
  geom_histogram(bins = 12, fill = "#0B4F6C", colour = "white") +
  labs(x = "Ventes mensuelles (milliers de $ CA)", y = "Nombre de mois") +
  theme_minimal(base_size = 12)
```

![](complements_files/figure-html/decomposition-complements-08-1.png)

``` r
decomposition_add <- decompose(serie, type = "additive")
decomposition_mult <- decompose(serie, type = "multiplicative")
indices_saisonniers <- tibble(mois = factor(mois_fr, levels = mois_fr),
  ecart_dollars = as.numeric(decomposition_add$figure),
  facteur = as.numeric(decomposition_mult$figure))
indices_saisonniers |> arrange(desc(facteur))
```

    # A tibble: 12 × 3
       mois      ecart_dollars facteur
       <fct>             <dbl>   <dbl>
     1 décembre         24384.   1.07 
     2 mai              18726.   1.05 
     3 novembre          7343.   1.02 
     4 mars              7475.   1.02 
     5 juin              6629.   1.02 
     6 avril             1910.   1.00 
     7 janvier          -5826.   0.986
     8 octobre          -6579.   0.982
     9 février          -8114.   0.977
    10 août            -12419.   0.965
    11 septembre       -15746.   0.958
    12 juillet         -17783.   0.951

``` r
plot(decomposition_mult)
```

![](complements_files/figure-html/decomposition-complements-08-2.png)

Le tableau donne les indices calculés et permet de repérer les mois les plus élevés et faibles. La fonction suppose une fréquence cohérente et fonctionne mieux avec des cycles complets. Les bords non estimés ne doivent pas être remplacés silencieusement par de l’information future. La décomposition n’est pas, à elle seule, une procédure de prévision.

> **TIP:**
>
> Un facteur de 0,90 représente 10 % sous la tendance estimée. Une moyenne centrée ne serait pas disponible en temps réel aux dernières dates. Lire la validation pour estimer les indices préparerait la comparaison avec des données futures.

## 3. Une saison lisse: sinus et cosinus

Une période annuelle mensuelle utilise sin(2πt/12) et cos(2πt/12). Le couple permet de régler l’amplitude et la phase. Son amplitude vaut la racine de la somme des carrés des deux coefficients. Un sinus seul impose une phase. Deux coefficients saisonniers sont plus parcimonieux que onze contrastes, mais une vague peut manquer un pic isolé de décembre ou deux pics distincts.

Le nombre de couples est fixé ici à un avant les scores. En ajouter après observation du classement puis annoncer une confirmation sur ce même bloc ne constituerait pas une validation indépendante. Les unités de la période doivent correspondre à l’indice temporel.

``` r
modele_harmonique <- lm(
  ventes ~ indice_temps + I(indice_temps^2) + sinus + cosinus,
  data = apprentissage
)
mesures08(validation$ventes, as.numeric(predict(modele_harmonique, futur)))
```

    # A tibble: 1 × 3
          ME    MAE   RMSE
       <dbl>  <dbl>  <dbl>
    1 -7465. 16474. 19339.

``` r
# Un seul couple sinus/cosinus, fixé avant les scores; période de 12 mois.
profil <- calendrier_futur("2025-01-01", 12, 60)
profil |>
  transmute(date, mois, sinus, cosinus,
            Calendrier = predict(modele_calendrier, newdata = profil),
            Harmonique = predict(modele_harmonique, newdata = profil)) |>
  pivot_longer(c(Calendrier, Harmonique), names_to = "methode", values_to = "prevision") |>
  ggplot(aes(date, prevision / 1000, colour = methode)) +
  geom_line() + geom_point() +
  labs(x = NULL, y = "Ventes prévues (milliers de $ CA)", colour = "Méthode") +
  theme_minimal(base_size = 12)
```

![](complements_files/figure-html/harmoniques-complements-08-1.png)

La tendance quadratique avec ce couple annuel a ici une MAE d’environ 16 474 \$, plus élevée que celle du modèle calendrier principal. La saison plus lisse n’est pas automatiquement une meilleure prévision. Le cas historique CDC mentionné dans les anciens supports justifie une provenance, sans devenir une application sanitaire dans ce parcours.

> **TIP:**
>
> Un couple annuel ne représente pas deux pics annuels distincts. Les deux termes permettent une phase libre. La tendance quadratique et la forme saisonnière sont deux hypothèses distinctes; chacune peut mal extrapoler.

## 4. Retrouver tslm et Box-Cox

Les anciens notebooks utilisaient `forecast::tslm()`. Avec la même série, `trend + season` représente ici le même espace de modèle que la tendance linéaire avec mois. La transformation Box-Cox vaut (y^lambda − 1)/lambda pour y positif et lambda non nul; lambda = 0 donne log(y), lambda = 1 donne y − 1.

``` r
library(forecast)
modele_tslm <- tslm(serie ~ trend + season)
max(abs(fitted(modele_tslm) - fitted(modele_calendrier)))
```

    [1] 0

``` r
max(abs(as.numeric(BoxCox(serie, lambda = 0)) - log(as.numeric(serie))))
```

    [1] 0

Les différences numériques sont nulles à l’arrondi près. Cette équivalence de valeurs ajustées ne vérifie pas les hypothèses d’erreurs. Les fonctions `forecast()` et `InvBoxCox()` permettent des ajustements de retransformation avec `biasadj`; leurs approximations ne doivent pas être confondues automatiquement avec toute autre correction de moyenne.

## 5. Stationnarité et différences: une ouverture critique

Prérequis supplémentaires: tendance déterministe, dépendance temporelle et hypothèse nulle. Une série faiblement stationnaire a moyenne constante, variance finie constante et covariance dépendant seulement du décalage. Une série stationnaire autour d’une tendance peut s’écrire comme une tendance déterministe plus un écart stationnaire. Ajuster une droite ne démontre pas cette propriété.

Dans `kpss.test()`, `null = "Level"` est l’option par défaut; `null = "Trend"` est une autre hypothèse. L’ancien notebook appelait la fonction sans préciser l’option tout en parlant de stationnarité autour d’une tendance. Le code est corrigé ici, sans utiliser ces tests pour choisir automatiquement un modèle du parcours principal.

``` r
library(tseries)
# Les tests sont explicitement distincts. Les avertissements sur les bornes
# de la table des valeurs p restent visibles dans le complément.
kpss_niveau <- kpss.test(serie, null = "Level")
```

    Warning in kpss.test(serie, null = "Level"): p-value smaller than printed
    p-value

``` r
kpss_tendance <- kpss.test(serie, null = "Trend")
```

    Warning in kpss.test(serie, null = "Trend"): p-value greater than printed
    p-value

``` r
kpss_difference <- kpss.test(diff(serie), null = "Level")
```

    Warning in kpss.test(diff(serie), null = "Level"): p-value greater than printed
    p-value

``` r
tibble(hypothese = c("Niveau stationnaire", "Stationnaire autour d’une tendance",
                     "Différence simple: niveau stationnaire"),
       statistique = c(unname(kpss_niveau$statistic), unname(kpss_tendance$statistic),
                       unname(kpss_difference$statistic)),
       p_table = c(kpss_niveau$p.value, kpss_tendance$p.value, kpss_difference$p.value))
```

    # A tibble: 3 × 3
      hypothese                              statistique p_table
      <chr>                                        <dbl>   <dbl>
    1 Niveau stationnaire                         1.58      0.01
    2 Stationnaire autour d’une tendance          0.0371    0.1 
    3 Différence simple: niveau stationnaire      0.0505    0.1 

``` r
par(mfrow = c(2, 2))
plot(serie, main = "Niveau", ylab = "$ CA", xlab = "Année")
plot(diff(serie), main = "Différence à un mois", ylab = "Différence ($ CA)", xlab = "Année")
plot(diff(serie, lag = 12), main = "Différence à douze mois", ylab = "Différence ($ CA)", xlab = "Année")
plot(diff(diff(serie, lag = 12)), main = "Deux différences", ylab = "Différence ($ CA)", xlab = "Année")
```

![](complements_files/figure-html/stationnarite-complements-08-1.png)

``` r
par(mfrow = c(1, 1))
```

Les avertissements de borne restent visibles: une valeur p affichée à 0,01 ou 0,10 peut être une borne de la table, sans précision exacte. Un rejet ne démontre pas qu’une tendance exponentielle conviendrait. Un non-rejet ne prouve pas la stationnarité. Taille de série, saisonnalité, dépendance et choix du décalage demandent un examen.

La différence simple compare deux mois consécutifs; la saisonnière compare deux mois éloignés de douze périodes. Leur composition ne garantit pas l’élimination de toute structure. Ce sont des transformations de la cible: il faut réintégrer les différences prévues pour retrouver les ventes. Aucune erreur sur les différences n’est comparée ici à une erreur sur le niveau original.

> **TIP:**
>
> Sans argument, KPSS teste l’hypothèse Level. Une valeur p non faible n’est pas une preuve de stationnarité. Modifier la série jusqu’à obtenir une valeur favorable ne valide pas automatiquement la transformation. Ce complément n’est pas requis dans les deux rapports principaux.

## 6. Contexte commercial et suites du cours

Les [exercices 14 et 15](../../modules/semaine-08-tendance-saisonnalite/exercices.llms.md#exercice-14) conservent le modèle avec prix et promotions, les résidus après contrôle commercial, les contrastes qui changent et les erreurs par promotion. Le code distingue le contexte observé ensuite des scénarios disponibles à l’origine. Ce prolongement prépare le module 09 et ne modifie pas la comparaison principale.

## Sources ciblées

Hyndman et Athanasopoulos (2021), FPP3, 3e édition: [transformations](https://otexts.com/fpp3/toolbox.html#sec-ftransformations), [décomposition classique](https://otexts.com/fpp3/decomposition.html#sec-classical-decomposition), [séries de Fourier](https://otexts.com/fpp3/regression.html#fourier-series), [stationnarité et différences](https://otexts.com/fpp3/arima.html#sec-stationarity). Les passages sont facultatifs et l’ouvrage utilise souvent fable; nos exemples emploient lm et forecast.

Documentations officielles consultées le 26 octobre 2026: R Core Team, [decompose](https://stat.ethz.ch/R-manual/R-patched/library/stats/html/decompose.html); équipe forecast, [tslm](https://pkg.robjhyndman.com/forecast/reference/tslm.html), [BoxCox et son inverse](https://pkg.robjhyndman.com/forecast/reference/BoxCox.html); Trapletti et Hornik, [tseries, entrée kpss.test](https://stat.ethz.ch/CRAN/web/packages/tseries/tseries.pdf), pages 22 à 23 dans la version consultée.

Le notebook Amtrak ancien consulté est attribué à Paolo Landa, daté du 16 mars 2021. Les données actuelles restent entièrement simulées pour le cours. Les fichiers anciens protégés ne sont pas redistribués. Les anciennes consignes de remise n’ajoutent aucune obligation actuelle.
