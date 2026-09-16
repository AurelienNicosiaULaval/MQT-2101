# Exercices - Module 04

## Objectif

Une responsable des opérations veut décrire le temps d’attente en fonction du taux d’utilisation de ses succursales. La question est de déterminer si une courbe apporte un gain utile par rapport à une droite.

Jeu de données de transfert : [cas_integrateur_quebec.csv](../atelier-04-recapitulation/data/cas_integrateur_quebec.csv), décrit dans la [page Données](../../donnees/). Les succursales et leurs données sont fictives.

Les applications des capsules concernent l’achalandage et les ventes. Ici, la réponse, l’explicative, les unités, la période et la décision changent. Les six exercices alimentent un seul rapport, `comparaison_attente.qmd`. Le modèle à retenir n’est pas donné d’avance.

Faites l’exercice 1 après la capsule 1, l’exercice 2 après la capsule 3, l’exercice 3 après la capsule 4, l’exercice 4 après la capsule 5, puis les exercices 5 et 6 après la capsule 6. Les activités 4.1 à 4.6 du cas guidé restent distinctes de cette série.

Faites une première tentative avant d’ouvrir le corrigé. Les solutions contiennent le code complet, les résultats recalculés et leur interprétation. Le code s’exécute dans l’ordre après la préparation; les réponses rédigées sont des exemples à confronter à votre raisonnement.

## Préparation

1.  Dans RStudio, créez le projet `comparaison-attente` avec File \> New Project \> New Directory \> New Project.
2.  Dans Files, créez `data` et placez-y le CSV téléchargé.
3.  Créez `comparaison_attente.qmd` à la racine, avec l’en-tête ci-dessous.
4.  Ajoutez les blocs R dans l’ordre avec Insert \> Code Chunk \> R.

``` yaml
---
title: "Utilisation et attente : faut-il une courbe?"
lang: fr
format:
  html:
    embed-resources: true
---
```

``` r
library(tidyverse)

service <- read_csv("data/cas_integrateur_quebec.csv",
                    show_col_types = FALSE) |>
  mutate(date = as.Date(date), succursale = factor(succursale)) |>
  arrange(date, succursale)

stopifnot(!anyNA(service[c("date", "taux_utilisation", "temps_attente")]))

# Garder l’année 2025 pour comparer les deux modèles.
apprentissage <- service |> filter(date < as.Date("2025-01-01"))
validation <- service |> filter(date >= as.Date("2025-01-01"))
```

## Exercice 1 - Lire le graphique

Identifiez la réponse, l’explicative et leurs unités. Vérifiez le nombre de mois et de succursales dans chaque période. Produisez le nuage de points sur les données d’apprentissage, en colorant les succursales. Décrivez la direction, la dispersion et une éventuelle courbure, sans supposer que la relation est saturée.

Repères : `temps_attente` est une moyenne mensuelle en minutes; `taux_utilisation` est le rapport du volume à la capacité de référence. Une valeur de 0,90 correspond à 90 %.

> **TIP:**
>
> ``` r
> tibble(ensemble = c("Apprentissage", "Validation"),
>        observations = c(nrow(apprentissage), nrow(validation)),
>        mois = c(n_distinct(apprentissage$date), n_distinct(validation$date)),
>        succursales = c(n_distinct(apprentissage$succursale),
>                       n_distinct(validation$succursale)))
> ```
>
>     # A tibble: 2 × 4
>       ensemble      observations  mois succursales
>       <chr>                <int> <int>       <int>
>     1 Apprentissage          240    60           4
>     2 Validation              48    12           4
>
> ``` r
> ggplot(apprentissage, aes(taux_utilisation, temps_attente)) +
>   geom_point(aes(colour = succursale), alpha = 0.7, size = 2.1) +
>   scale_x_continuous(labels = scales::label_percent()) +
>   labs(x = "Taux d’utilisation", y = "Attente moyenne (minutes)", colour = "Succursale") +
>   theme_minimal(base_size = 13)
> ```
>
> ![](exercices_files/figure-html/solution-04-1-1.png)
>
> Le fichier contient 288 lignes : quatre succursales sur 72 mois, de 2020 à 2025. L’apprentissage comporte 240 lignes sur 60 mois; la validation comporte 48 lignes sur 12 mois. Ce ne sont pas 288 clients indépendants.
>
> La réponse est le temps d’attente, en minutes. L’explicative est le taux d’utilisation, un rapport sans unité. Le nuage présente une association positive, avec une dispersion et des différences entre succursales. Une faible courbure est envisageable, mais le graphique ne suffit pas à imposer une quadratique. Le dépassement de 100 % signifie que le volume dépasse la référence de capacité, pas qu’une probabilité dépasse 1.

## Exercice 2 - Ajuster deux modèles

Ajustez une droite et une quadratique sur les seules données de 2020 à 2024. Superposez-les au nuage dans cette plage. Comparez les R² d’apprentissage.

Avec la droite, interprétez une hausse de 10 points de pourcentage du taux d’utilisation, par exemple de 80 % à 90 %. Expliquez pourquoi le seul coefficient du terme simple ne donne pas cette variation dans le modèle quadratique.

> **TIP:**
>
> ``` r
> modele_lineaire <- lm(temps_attente ~ taux_utilisation, data = apprentissage)
> modele_quadratique <- lm(
>   temps_attente ~ taux_utilisation + I(taux_utilisation^2),
>   data = apprentissage
> )
> coef(modele_lineaire)
> ```
>
>          (Intercept) taux_utilisation
>           -0.1170084        5.0212622
>
> ``` r
> coef(modele_quadratique)
> ```
>
>               (Intercept)      taux_utilisation I(taux_utilisation^2)
>                  4.724425             -6.092024              6.316268
>
> ``` r
> tibble(modele = c("Linéaire", "Quadratique"),
>        r2_apprentissage = c(summary(modele_lineaire)$r.squared,
>                              summary(modele_quadratique)$r.squared))
> ```
>
>     # A tibble: 2 × 2
>       modele      r2_apprentissage
>       <chr>                  <dbl>
>     1 Linéaire               0.252
>     2 Quadratique            0.256
>
> ``` r
> grille <- tibble(taux_utilisation = seq(min(apprentissage$taux_utilisation),
>                                         max(apprentissage$taux_utilisation),
>                                         length.out = 120))
> courbes <- bind_rows(
>   grille |> mutate(modele = "Linéaire", attente_predite = predict(modele_lineaire, newdata = grille)),
>   grille |> mutate(modele = "Quadratique", attente_predite = predict(modele_quadratique, newdata = grille))
> )
> ggplot(apprentissage, aes(taux_utilisation, temps_attente)) +
>   geom_point(alpha = 0.4) +
>   geom_line(data = courbes, aes(y = attente_predite, colour = modele), linewidth = 1.1) +
>   scale_x_continuous(labels = scales::label_percent()) +
>   labs(x = "Taux d’utilisation", y = "Attente moyenne (minutes)", colour = "Modèle") +
>   theme_minimal(base_size = 13)
> ```
>
> ![](exercices_files/figure-html/solution-04-2-1.png)
>
> ``` r
> unname(coef(modele_lineaire)[2] * 0.10)
> ```
>
>     [1] 0.5021262
>
> Le R² passe d’environ 0,252 à 0,256. Cette légère hausse est un résultat d’apprentissage : ajouter un terme ne peut pas réduire le R² sur les mêmes lignes.
>
> La pente linéaire vaut environ 5,021 minutes par unité de taux. Dix points de pourcentage représentent 0,10 unité : la différence moyenne prédite est donc de 0,502 minute, soit environ 30 secondes. Cette association n’est pas un effet causal.
>
> Dans la quadratique, x et x² varient simultanément. On doit comparer les prédictions aux deux valeurs de x; le coefficient de x, pris seul, n’est pas une pente constante.

## Exercice 3 - Calculer la RMSE

Calculez la RMSE des deux modèles sur l’apprentissage, puis sur l’année 2025, sans réajuster les coefficients. Quel modèle a la plus faible erreur de validation? Exprimez la différence en minutes, puis en secondes. Expliquez pourquoi ce classement ne suffit pas à démontrer un avantage stable.

> **TIP:**
>
> ``` r
> rmse <- function(observe, predit) {
>   stopifnot(length(observe) == length(predit), !anyNA(observe), !anyNA(predit))
>   sqrt(mean((observe - predit)^2))
> }
> comparaison <- tibble(
>   modele = c("Linéaire", "Quadratique"),
>   rmse_apprentissage = c(rmse(apprentissage$temps_attente, fitted(modele_lineaire)),
>                          rmse(apprentissage$temps_attente, fitted(modele_quadratique))),
>   rmse_validation = c(rmse(validation$temps_attente, predict(modele_lineaire, newdata = validation)),
>                       rmse(validation$temps_attente, predict(modele_quadratique, newdata = validation)))
> )
> comparaison
> ```
>
>     # A tibble: 2 × 3
>       modele      rmse_apprentissage rmse_validation
>       <chr>                    <dbl>           <dbl>
>     1 Linéaire                 0.742           0.692
>     2 Quadratique              0.740           0.723
>
> ``` r
> ecart_minutes <- comparaison$rmse_validation[2] - comparaison$rmse_validation[1]
> tibble(ecart_minutes = ecart_minutes, ecart_secondes = 60 * ecart_minutes)
> ```
>
>     # A tibble: 1 × 2
>       ecart_minutes ecart_secondes
>               <dbl>          <dbl>
>     1        0.0310           1.86
>
> La RMSE d’apprentissage baisse très légèrement, de 0,742 à 0,740 minute. En validation, la droite obtient 0,692 minute, contre 0,723 pour la quadratique. La droite a donc une erreur plus faible d’environ 0,031 minute, soit 1,86 seconde.
>
> On peut retenir provisoirement la droite, plus simple et légèrement meilleure sur cette période. Cet écart de RMSE n’est pas une réduction réelle du temps d’attente. Une seule année, des succursales répétées et un faible écart ne permettent pas d’affirmer une supériorité générale. Il faudrait vérifier d’autres périodes. L’année 2025 ayant servi au choix, elle constitue une validation, pas un test final indépendant.

## Exercice 4 - Interpréter la saturation

Une analyste affirme : « Toute relation entre utilisation et attente doit être quadratique; le modèle permettra de prévoir à 150 % d’utilisation. » Critiquez les deux parties de l’affirmation.

Appuyez-vous sur le graphique, la RMSE de validation, la plage d’apprentissage et un diagnostic par succursale. Comparez les prédictions de la droite à 90 % et à 150 %, avec les intervalles classiques de prédiction. Pourquoi un intervalle calculé ne résout-il pas le problème d’extrapolation?

> **TIP:**
>
> ``` r
> plage <- range(apprentissage$taux_utilisation)
> plage
> ```
>
>     [1] 0.6880952 1.1167568
>
> ``` r
> sum(validation$taux_utilisation < plage[1] |
>     validation$taux_utilisation > plage[2])
> ```
>
>     [1] 3
>
> ``` r
> diagnostic <- apprentissage |>
>   mutate(attente_predite = fitted(modele_lineaire), residu = residuals(modele_lineaire))
> ggplot(diagnostic, aes(attente_predite, residu, colour = succursale)) +
>   geom_hline(yintercept = 0, colour = "#7A1C24") +
>   geom_point(alpha = 0.7) +
>   labs(x = "Attente ajustée (minutes)", y = "Résidu (minutes)", colour = "Succursale") +
>   theme_minimal(base_size = 13)
> ```
>
> ![](exercices_files/figure-html/solution-04-4-1.png)
>
> ``` r
> diagnostic |>
>   group_by(succursale) |>
>   summarise(residu_moyen = mean(residu), erreur_absolue_moyenne = mean(abs(residu)),
>             .groups = "drop")
> ```
>
>     # A tibble: 4 × 3
>       succursale residu_moyen erreur_absolue_moyenne
>       <fct>             <dbl>                  <dbl>
>     1 Gatineau       -0.0736                   0.520
>     2 Montréal        0.0298                   0.664
>     3 Québec         -0.00177                  0.587
>     4 Sherbrooke      0.0455                   0.602
>
> ``` r
> scenarios <- tibble(taux_utilisation = c(0.90, 1.50))
> intervalles <- predict(modele_lineaire, newdata = scenarios,
>                        interval = "prediction", level = 0.95)
> bind_cols(scenarios, as_tibble(intervalles))
> ```
>
>     # A tibble: 2 × 4
>       taux_utilisation   fit   lwr   upr
>                  <dbl> <dbl> <dbl> <dbl>
>     1              0.9  4.40  2.93  5.87
>     2              1.5  7.41  5.79  9.04
>
> Ni le contexte ni le nuage n’imposent une quadratique; la validation donne même une RMSE légèrement plus faible à la droite. Une attente croissante n’est pas nécessairement un plateau de saturation. Le stock, la capacité et les différences entre succursales peuvent jouer un rôle.
>
> La plage d’apprentissage va de 68,8 % à 111,7 %. Le scénario à 90 % est dans cette plage; celui à 150 % est au-delà. À 90 %, la droite donne environ 4,40 minutes, avec un intervalle de 2,93 à 5,87 minutes. À 150 %, elle produit aussi des nombres, mais aucune observation d’apprentissage ne valide cette extrapolation.
>
> L’intervalle suppose notamment une forme correcte et des erreurs indépendantes, normalement distribuées et de variance constante. Il ne tient pas compte d’une erreur de forme loin des données ni du choix préalable du modèle. Les écarts par succursale et les répétitions mensuelles demandent un examen supplémentaire. Les prédictions restent conditionnelles au taux fourni.

## Exercice 5 - Conclusion prudente

Rédigez au plus cinq phrases pour la responsable des opérations : question, modèle retenu provisoirement, comparaison chiffrée, plage d’utilisation et limite. Proposez une information supplémentaire à recueillir.

> **TIP:**

## Exercice 6 - Mini-trace de comparaison

Terminez `comparaison_attente.qmd` avec le nuage, les deux modèles, la comparaison d’erreurs, le diagnostic, les scénarios et votre conclusion. Vérifiez qu’aucun résultat ne dépend d’un objet créé manuellement dans la console. Redémarrez R, puis rendez le rapport en HTML.

> **TIP:**
>
> ### Éléments à retrouver dans le rapport
>
> | Partie | Contenu attendu |
> |----|----|
> | Question et données | Variables, unités, succursales fictives et périodes |
> | Graphique | Nuage d’apprentissage et deux courbes, légendes lisibles |
> | Modèles | Même apprentissage 2020-2024, formules et interprétation |
> | Validation | RMSE sur 2025, différence en minutes et portée limitée |
> | Diagnostic | Résidus et écarts entre succursales |
> | Prédictions | 90 % dans la plage; 150 % hors de la plage |
> | Conclusion | Choix provisoire, limite et prochaine collecte |
>
> ### Vérification finale
>
> Le code des solutions précédentes suffit à recalculer ces éléments dans l’ordre. Gardez les nombres dans des sorties R ou des expressions en ligne, afin qu’ils suivent les calculs. Après Session \> Restart R, cliquez sur Render. Vérifiez le HTML obtenu et la présence des unités sur les figures.
>
> L’encadré de décision peut reprendre la réponse de l’exercice 5, avec vos propres mots. La qualité de l’argumentation compte davantage que la sophistication du modèle.

## Auto-vérification

J’ai tenté chaque exercice avant d’ouvrir le corrigé.

J’ai séparé les périodes avant d’ajuster les modèles.

Mes RMSE utilisent les mêmes observations et les mêmes unités.

Je distingue amélioration d’ajustement et amélioration de validation.

Ma conclusion explique pourquoi une droite peut suffire.

Mon rapport se recalcule après redémarrage de R.

Vous pouvez demander au [GPT du cours](https://chatgpt.com/g/g-6a0b2ec33d948191ad25b2f247b15de1-analyse-et-modelisation-des-donnees?ref=mini) de commenter une première tentative. Il doit vous aider à repérer une erreur ou une limite, sans choisir ni rédiger la conclusion à votre place. Comprendre une réponse aidée ne démontre pas que vous savez la reproduire seul.
