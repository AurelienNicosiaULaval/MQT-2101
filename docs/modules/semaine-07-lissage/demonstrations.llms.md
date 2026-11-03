# Démonstrations R - Module 07

## Question et fichiers

Comment stabiliser une prévision de demande sans ignorer une hausse récente? Le parcours guidé reprend les 104 semaines fictives du module 06. Les prix et promotions décrivent le contexte; ils ne sont pas utilisés comme prédicteurs. Leur effet causal ne peut pas être déduit de ces calculs.

Décompressez le [projet de départ](telechargements/lissage-demande.zip) pour votre travail ou la [démonstration complète](telechargements/demonstration-lissage-demande.zip) pour reprendre tous les calculs. Ouvrez le `.Rproj`. Les [dictionnaires](data/dictionnaires.md) et [fonctions R](R/fonctions-module07.R) sont fournis.

## Préparation

Installez une fois `tidyverse`, `slider` et `forecast` si nécessaire, dans la console avec `install.packages(c("tidyverse", "slider", "forecast"))`. Les blocs visibles s’exécutent ensuite dans l’ordre depuis une session R neuve. Le dossier `R/` contient la récurrence `niveau_ses()` et les formules de `mesures_erreurs()`; conservez-le avec `data/`.

``` r
library(tidyverse)
library(slider)
library(forecast)

# Ouvrir le projet .Rproj fourni : R/ et data/ sont à côté du rapport.
source("R/fonctions-module07.R")
demande <- read_csv("data/demande_hebdomadaire_quebec.csv",
                    show_col_types = FALSE) |>
  mutate(semaine = as.Date(semaine)) |>
  arrange(semaine)
stopifnot(nrow(demande) == 104L, !anyNA(demande),
          !anyDuplicated(demande$semaine),
          all(diff(demande$semaine) == 7))
horizon <- 13L
apprentissage <- demande |> slice_head(n = 91)
validation <- demande |> slice_tail(n = horizon)
serie <- ts(apprentissage$demande, frequency = 52)
```

L’apprentissage contient 91 semaines, du 1er janvier 2024 au 22 septembre 2025. L’origine est la fin de cette dernière semaine, avant celle du 29 septembre. La validation va du 29 septembre au 22 décembre 2025, soit treize cibles à horizons 1 à 13. Aucune de leurs observations n’entre dans les prévisions. Ces cibles sont déjà connues depuis le module 06: elles ne forment pas un test indépendant.

## 1. Choisir une fenêtre

``` r
lissage <- apprentissage |>
  mutate(mm4 = slide_dbl(demande, mean, .before = 3, .complete = TRUE),
         mm13 = slide_dbl(demande, mean, .before = 12, .complete = TRUE))
lissage |>
  select(semaine, demande, mm4, mm13) |>
  pivot_longer(-semaine, names_to = "serie", values_to = "unites") |>
  ggplot(aes(semaine, unites, colour = serie)) +
  geom_line(linewidth = 0.7, na.rm = TRUE) +
  labs(x = NULL, y = "Demande (unités par semaine)", colour = "Série") +
  theme_minimal(base_size = 12)
```

![](demonstrations_files/figure-html/moyennes-mobiles-m07-1.png)

``` r
tail(lissage |> select(semaine, demande, mm4, mm13), 4)
```

    # A tibble: 4 × 4
      semaine    demande   mm4  mm13
      <date>       <dbl> <dbl> <dbl>
    1 2025-09-01    1412 1346. 1413.
    2 2025-09-08    1300 1345. 1386.
    3 2025-09-15    1330 1340. 1380.
    4 2025-09-22    1211 1313. 1353

``` r
mean(c(980, 1020, 1080, 1120))
```

    [1] 1050

La moyenne de l’exemple vaut 1 050 unités. MM4 donne le même poids à quatre observations; MM13 répartit le poids sur treize. Les trois et douze premières valeurs manquantes sont normales: la fenêtre complète n’existe pas encore. `na.rm = TRUE` concerne seulement leur tracé; aucun score n’écarte de cible.

À la date t, la moyenne arrière contient y_t. Elle décrit le niveau connu après observation de cette semaine. Elle peut prévoir t + 1, mais n’est pas une prévision émise avant y_t. Pour une origine fixe T, nous répétons ici m_T pour tous les horizons. Réinjecter des prévisions dans la fenêtre définirait une autre règle, qui n’est pas celle comparée.

## 2. Mettre à jour un niveau

``` r
exemple <- tibble(observe = c(100, 100, 140, 140),
                  alpha_02 = niveau_ses(observe, 0.2),
                  alpha_08 = niveau_ses(observe, 0.8))
exemple
```

    # A tibble: 4 × 3
      observe alpha_02 alpha_08
        <dbl>    <dbl>    <dbl>
    1     100     100      100
    2     100     100      100
    3     140     108      132
    4     140     114.     138.

``` r
niveaux <- apprentissage |>
  mutate(alpha_02 = niveau_ses(demande, 0.2),
         alpha_08 = niveau_ses(demande, 0.8))
niveaux |>
  select(semaine, demande, alpha_02, alpha_08) |>
  pivot_longer(-semaine, names_to = "serie", values_to = "unites") |>
  ggplot(aes(semaine, unites, colour = serie)) +
  geom_line(linewidth = 0.7) +
  labs(x = NULL, y = "Demande (unités par semaine)", colour = "Série") +
  theme_minimal(base_size = 12)
```

![](demonstrations_files/figure-html/alpha-m07-1.png)

``` r
modele_ses <- ses(serie, h = horizon, initial = "optimal")
modele_ses$model$par["alpha"]
```

        alpha
    0.3711818

Avec le même niveau initial de 100, les deux dernières valeurs lissées de l’exemple sont 108 puis 114,4 pour alpha = 0,2, contre 132 puis 138,4 pour alpha = 0,8. Le paramètre élevé réagit davantage; il amplifie aussi la réaction à une observation inhabituelle.

Le SES principal estime alpha et l’état initial sur les 91 semaines seulement, avec `initial = "optimal"`. L’alpha obtenu est d’environ 0,371. Il n’est pas censé égaler une des valeurs imposées pour l’illustration. Les prévisions SES à origine fixe restent constantes: un niveau révisable ne constitue pas une tendance prévue.

## 3. Émettre et évaluer les prévisions

Les trois candidats historiques restent naïf, MM4 et SES. Le naïf saisonnier du module 06 est ajouté comme référence de contrôle. Il reprend les valeurs de 52 semaines auparavant. Ce cycle de 364 jours est une approximation du calendrier annuel.

``` r
# Règles fixées avant de consulter les scores : origine unique, h = 1 à 13.
# MM4 : répéter la dernière moyenne observée, sans mise à jour future.
previsions <- tibble(
  semaine = validation$semaine,
  observe = validation$demande,
  Naive = rep(tail(apprentissage$demande, 1), horizon),
  MM4 = rep(mean(tail(apprentissage$demande, 4)), horizon),
  SES = as.numeric(modele_ses$mean),
  Saisonnier = as.numeric(snaive(serie, h = horizon)$mean)
)
erreurs <- previsions |>
  pivot_longer(Naive:Saisonnier, names_to = "methode", values_to = "prevision") |>
  mutate(erreur = observe - prevision)
scores <- erreurs |>
  group_by(methode) |>
  group_modify(~ mesures_erreurs(.x$observe, .x$prevision)) |>
  ungroup() |>
  arrange(MAE)
scores |> select(methode, ME, MAE, RMSE)
```

    # A tibble: 4 × 4
      methode       ME   MAE  RMSE
      <chr>      <dbl> <dbl> <dbl>
    1 MM4         82.6  100.  128.
    2 SES        106.   114.  144.
    3 Saisonnier 143.   179.  194.
    4 Naive      185.   185.  209.

``` r
# Chaque observation est tracée une seule fois.
ggplot() +
  geom_line(data = validation, aes(semaine, demande), linewidth = 1) +
  geom_line(data = erreurs, aes(semaine, prevision, colour = methode),
            linewidth = 0.7) +
  labs(x = NULL, y = "Demande (unités par semaine)", colour = "Méthode") +
  theme_minimal(base_size = 12)
```

![](demonstrations_files/figure-html/graphiques-m07-1.png)

``` r
ggplot(erreurs, aes(semaine, erreur, colour = methode)) +
  geom_hline(yintercept = 0, colour = "grey55") +
  geom_line() + geom_point() +
  labs(x = NULL, y = "Observé − prévu (unités)", colour = "Méthode") +
  theme_minimal(base_size = 12)
```

![](demonstrations_files/figure-html/graphiques-m07-2.png)

MM4 a ici une MAE d’environ 100,1 unités, contre 113,9 pour SES, 178,6 pour le naïf saisonnier et 184,8 pour le naïf. La RMSE de MM4 est d’environ 128,1 unités. Sa ME positive (environ 82,6 unités) signale une sous-prévision moyenne. La meilleure MAE de cette période ne prouve pas que le lissage constant capture la tendance ou les promotions.

Les scores restent en unités de produit. La ME peut cacher des compensations; le graphique des erreurs montre leur localisation. Les rappels MAPE et MASE sont dans les [lectures](../../modules/semaine-07-lissage/lectures.llms.md#lecture-3). On ne sélectionne aucune fenêtre supplémentaire après consultation des scores.

## 4. Relier le classement à la décision

``` r
# Sensibilité hypothétique : une unité sous-prévue coûte 2, une sur-prévue 1.
scores_cout <- erreurs |>
  group_by(methode) |>
  group_modify(~ mesures_erreurs(.x$observe, .x$prevision,
                                cout_sous = 2, cout_sur = 1)) |>
  ungroup() |>
  arrange(cout_moyen)
scores_cout |> select(methode, MAE, cout_moyen, sous_previsions)
```

    # A tibble: 4 × 4
      methode      MAE cout_moyen sous_previsions
      <chr>      <dbl>      <dbl>           <int>
    1 MM4         100.       191.              10
    2 SES         114.       224.              11
    3 Saisonnier  179.       339.              11
    4 Naive       185.       370.              13

MM4 conserve ici la plus petite perte dans ce scénario fictif. On peut la retenir provisoirement comme prévision de référence de demande. Ce calcul ne fixe pas une quantité de commande: stocks disponibles, délais, capacité, niveau de service et incertitude manquent. Une perte linéaire asymétrique ne transforme pas le SES en prévision optimisée pour ce coût.

Réévaluez aux prochaines origines lorsque les observations arrivent, en conservant le même horizon et les mêmes règles pour tous les candidats. Un déplacement de l’origine est une nouvelle expérience; il ne doit pas être mélangé aux treize prévisions émises ensemble.

## Complément accompagné : Holt

Facultatif pour les deux rapports. Pour le laboratoire 03, savoir lire le niveau, la pente et l’amortissement; le code est fourni et les récurrences manuelles ne sont pas demandées.

``` r
# Facultatif : comparer une tendance amortie, sans composante saisonnière.
modele_holt <- holt(serie, h = horizon, damped = TRUE)
comparaison_holt <- bind_rows(
  scores |> select(methode, ME, MAE, RMSE),
  mesures_erreurs(validation$demande, as.numeric(modele_holt$mean)) |>
    mutate(methode = "Holt amorti") |> select(methode, ME, MAE, RMSE)
)
comparaison_holt |> arrange(MAE)
```

    # A tibble: 5 × 4
      methode        ME   MAE  RMSE
      <chr>       <dbl> <dbl> <dbl>
    1 MM4          82.6  100.  128.
    2 SES         106.   114.  144.
    3 Holt amorti 152.   152.  189.
    4 Saisonnier  143.   179.  194.
    5 Naive       185.   185.  209.

Holt amorti a ici une MAE d’environ 152,2 unités. Ajouter une pente n’améliore donc pas automatiquement le score. La méthode ne modélise pas la saisonnalité. Les [lectures facultatives](../../modules/semaine-07-lissage/lectures.llms.md#complements) conservent les autres pistes de l’ancien matériel.
