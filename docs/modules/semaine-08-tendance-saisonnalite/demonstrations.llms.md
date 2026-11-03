# Démonstrations R - Module 08

## La question et les fichiers

Comment prévoir les ventes mensuelles d’une organisation québécoise fictive pour préparer sa planification annuelle? Le parcours principal compare trois structures simples et le naïf saisonnier. Les formes plus avancées de l’ancienne séance restent dans un [cahier facultatif expliqué et exécutable](../../modules/semaine-08-tendance-saisonnalite/complements.llms.md).

Décompressez le [projet guidé](telechargements/tendance-ventes.zip) pour votre analyse, ou la [démonstration complète](telechargements/demonstration-tendance-ventes.zip). Les données, le [dictionnaire](data/dictionnaires.md) et les [fonctions R](R/fonctions-module08.R) sont fournis.

## Préparation

Ouvrez le `.Rproj`. Installez une fois `tidyverse` et `broom` si nécessaire, dans la console avec `install.packages(c("tidyverse", "broom"))`. Les blocs visibles se suivent depuis une session R neuve. Le dossier `R/` contient les fonctions de calendrier et les scores; conservez-le avec `data/`.

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

Les 72 mois vont de janvier 2020 à décembre 2025. Une ligne est un mois, les ventes et le budget cible sont en dollars canadiens. On apprend sur les 60 mois de 2020 à 2024 et on compare sur 2025 à l’origine de décembre 2024. L’indice futur continue de 61 à 72. Les ventes de validation servent ensuite à calculer les erreurs, sans entrer dans les prévisions.

Le protocole et les quatre candidats sont fixés avant les scores: tendance linéaire seule, saison seule, tendance linéaire avec mois et naïf saisonnier. Le bloc de validation sert au choix; aucun test final distinct n’est disponible ici.

## 1. Lire le temps et les motifs

``` r
ggplot(apprentissage, aes(date, ventes / 1000)) +
  geom_line(colour = "#0B4F6C") +
  labs(x = NULL, y = "Ventes mensuelles (milliers de $ CA)") +
  theme_minimal(base_size = 12)
```

![](demonstrations_files/figure-html/exploration-m08-1.png)

``` r
ggplot(apprentissage, aes(mois, ventes / 1000, group = factor(annee), colour = factor(annee))) +
  geom_line() + geom_point() +
  labs(x = NULL, y = "Ventes mensuelles (milliers de $ CA)", colour = "Année") +
  theme_minimal(base_size = 12) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
```

![](demonstrations_files/figure-html/exploration-m08-2.png)

Les profils comparent les mêmes mois entre années et montrent aussi l’augmentation du niveau. Une hausse dans une seule année ne suffirait pas à établir la récurrence saisonnière. Les mois de la fin d’année peuvent être élevés sans qu’un graphique établisse une cause. L’exploration principale reste limitée à l’apprentissage.

## 2. Ajuster tendance et mois

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

Le modèle combiné estime ici environ 2 884 \$ de hausse par mois à mois égal et un contraste décembre-janvier d’environ 32 705 \$ à indice de temps égal. Il s’agit d’une comparaison conditionnelle au modèle, sans effet causal du mois.

La tendance seule laisse de côté la saison. La saison seule répète un profil mensuel mais ne représente pas la hausse entre années. Le facteur mois est non ordonné, avec janvier comme référence et les contrastes de traitement explicitement fixés. L’affichage suit l’ordre du calendrier; il ne demande pas de contrastes polynomiaux.

## 3. Examiner les résidus

``` r
diagnostic <- apprentissage |>
  mutate(ajuste = fitted(modele_calendrier), residu = residuals(modele_calendrier))
ggplot(diagnostic, aes(date, residu / 1000)) +
  geom_hline(yintercept = 0, colour = "grey60") + geom_line() +
  labs(x = NULL, y = "Résidu (milliers de $ CA)") + theme_minimal(base_size = 12)
```

![](demonstrations_files/figure-html/diagnostic-m08-1.png)

``` r
ggplot(diagnostic, aes(ajuste / 1000, residu / 1000)) +
  geom_hline(yintercept = 0, colour = "grey60") + geom_point() +
  labs(x = "Valeur ajustée (milliers de $ CA)", y = "Résidu (milliers de $ CA)") +
  theme_minimal(base_size = 12)
```

![](demonstrations_files/figure-html/diagnostic-m08-2.png)

``` r
# Comparer ce qui reste par mois avec et sans terme de calendrier.
residus_mensuels <- imap_dfr(modeles, function(modele, nom) {
  tibble(mois = apprentissage$mois, residu = residuals(modele), methode = nom)
}) |>
  group_by(methode, mois) |> summarise(residu_moyen = mean(residu), .groups = "drop")
residus_mensuels |>
  ggplot(aes(mois, residu_moyen / 1000, colour = methode, group = methode)) +
  geom_hline(yintercept = 0, colour = "grey60") + geom_line() + geom_point() +
  labs(x = NULL, y = "Résidu mensuel moyen (milliers de $ CA)", colour = "Méthode") +
  theme_minimal(base_size = 12) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
```

![](demonstrations_files/figure-html/diagnostic-m08-3.png)

Dans le modèle avec les indicatrices mensuelles, les équations des moindres carrés imposent des sommes résiduelles nulles par mois, à l’arrondi numérique près. Cette propriété ne valide pas la stabilité future des effets saisonniers. Le temps et la dispersion des résidus peuvent encore révéler une structure manquante. L’autocorrélation sera approfondie au module 09; on peut déjà signaler cette limite sans appliquer un nouveau test.

## 4. Comparer les prévisions

``` r
previsions <- imap_dfr(modeles, function(modele, nom) {
  tibble(date = futur$date, observe = validation$ventes, methode = nom,
         prevision = as.numeric(predict(modele, newdata = futur)))
}) |>
  bind_rows(tibble(date = futur$date, observe = validation$ventes,
                   methode = "Saisonnier_naif", prevision = tail(apprentissage$ventes, 12)))
scores <- previsions |> group_by(methode) |>
  group_modify(~ mesures08(.x$observe, .x$prevision)) |> ungroup() |> arrange(MAE)
scores
```

    # A tibble: 4 × 4
      methode              ME     MAE    RMSE
      <chr>             <dbl>   <dbl>   <dbl>
    1 Calendrier       -3538.   9891.  11280.
    2 Tendance         -4347.  17064.  20292.
    3 Saisonnier_naif  29067.  29067.  30170.
    4 Saison          100302. 100302. 100872.

``` r
ggplot() +
  geom_line(data = validation, aes(date, ventes / 1000), linewidth = 1) +
  geom_line(data = previsions, aes(date, prevision / 1000, colour = methode)) +
  labs(x = NULL, y = "Ventes mensuelles (milliers de $ CA)", colour = "Méthode") +
  theme_minimal(base_size = 12)
```

![](demonstrations_files/figure-html/validation-m08-1.png)

Le modèle combiné a ici la plus faible MAE des quatre candidats: environ 9 891 \$, avec une RMSE d’environ 11 280 \$. Le naïf saisonnier a une MAE d’environ 29 067 \$. La saison seule manque la croissance et sous-prévoit fortement la dernière année. Ce classement décrit ces douze mois utilisés pour choisir, sans établir une supériorité future.

## 5. Prévoir et communiquer l’incertitude

``` r
ip <- predict(modele_calendrier, newdata = futur, interval = "prediction", level = 0.95)
ic <- predict(modele_calendrier, newdata = futur, interval = "confidence", level = 0.95)
previsions_intervalle <- futur |>
  select(date, indice_temps, mois) |>
  bind_cols(as_tibble(ip)) |>
  mutate(observe = validation$ventes, budget_cible = validation$budget_cible,
         ic_inf = ic[, "lwr"], ic_sup = ic[, "upr"],
         dans_intervalle = observe >= lwr & observe <= upr)
previsions_intervalle |> select(date, fit, lwr, upr, ic_inf, ic_sup) |> slice_head(n = 3)
```

    # A tibble: 3 × 6
      date           fit     lwr     upr  ic_inf  ic_sup
      <date>       <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
    1 2025-01-01 457130. 435673. 478587. 447165. 467095.
    2 2025-02-01 460540. 439083. 481998. 450575. 470506.
    3 2025-03-01 475355. 453897. 496812. 465390. 485320.

``` r
ggplot(previsions_intervalle, aes(date)) +
  geom_ribbon(aes(ymin = lwr / 1000, ymax = upr / 1000), fill = "#BFDDE5", alpha = 0.6) +
  geom_line(aes(y = fit / 1000), colour = "#0B4F6C", linewidth = 0.8) +
  geom_point(aes(y = observe / 1000)) +
  labs(x = NULL, y = "Ventes mensuelles (milliers de $ CA)",
       subtitle = "Intervalles de prédiction ponctuels à 95 %, sous les hypothèses du modèle") +
  theme_minimal(base_size = 12)
```

![](demonstrations_files/figure-html/incertitude-m08-1.png)

``` r
previsions_intervalle |>
  summarise(mois_dans_intervalle = sum(dans_intervalle),
            ecart_moyen_au_budget = mean(fit - budget_cible))
```

    # A tibble: 1 × 2
      mois_dans_intervalle ecart_moyen_au_budget
                     <int>                 <dbl>
    1                   12                 81483

Pour janvier 2025, le modèle calendrier prévoit environ 457 130 \$. L’intervalle de prédiction à 95 % vaut environ \[435 673; 478 587\] \$, plus large que l’intervalle de confiance de la moyenne \[447 165; 467 095\] \$. La prédiction ajoute la variabilité d’une nouvelle observation.

Les douze observations se trouvent ici dans leurs intervalles ponctuels à 95 %. Ce petit nombre ne démontre pas leur calibration future. Douze intervalles marginaux ne donnent pas une garantie simultanée de 95 % pour l’année. Les intervalles classiques supposent notamment forme correcte, erreurs indépendantes de variance constante et normalité pour les calculs exacts.

Le budget cible est un objectif fictif, pas un prédicteur utilisé pour retrouver les ventes. La prévision et une plage sous hypothèses nourrissent la discussion budgétaire sans fixer le risque acceptable. Pour une vraie période suivante, on réajuste la méthode choisie avec le passé disponible à la nouvelle origine. Les nouvelles prévisions ne sont évaluables qu’après l’arrivée des observations.

## Pour consolider ou approfondir

Le [cahier facultatif](../../modules/semaine-08-tendance-saisonnalite/complements.llms.md) conserve les tendances quadratique et exponentielle, le retour à l’échelle des dollars, la décomposition, les harmoniques, le pont vers `tslm()` et les tests de stationnarité des anciens scripts. Ces calculs ne sont pas requis pour les deux rapports principaux. Les [exercices commerciaux accompagnés](../../modules/semaine-08-tendance-saisonnalite/exercices.llms.md#exercice-14) préparent le module 09.
