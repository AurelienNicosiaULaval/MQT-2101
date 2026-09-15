# Exercices - Module 03

## Objectif

Appliquer la régression linéaire à une nouvelle question : une responsable de service souhaite décrire le lien entre le délai de service et la satisfaction mensuelle dans des succursales fictives.

Jeu de données de transfert : [performance_succursales_quebec.csv](../atelier-02-regression/data/performance_succursales_quebec.csv), décrit dans la [page Données](../../donnees/#performance-de-succursales-québécoises-fictives).

Les activités des capsules portent sur le budget marketing et les ventes. Ici, la question, les variables, les unités et la destinataire changent. Les six exercices se suivent et alimentent un seul rapport, `diagnostic_service.qmd`.

Faites une première tentative avant d’ouvrir la solution détaillée à la fin de chaque exercice. Les corrigés contiennent le code, les résultats calculés et leur interprétation. Leur code s’exécute dans l’ordre, après la préparation ci-dessous. Les réponses rédigées sont des exemples à comparer à votre raisonnement.

## Préparation

1.  Dans RStudio, créez un projet `diagnostic-service` avec File \> New Project \> New Directory \> New Project.
2.  Dans Files, créez `data` et placez-y le CSV téléchargé.
3.  Créez un document Quarto HTML nommé `diagnostic_service.qmd` à la racine du projet.
4.  Utilisez cet en-tête, puis ajoutez les blocs R avec Insert \> Code Chunk \> R.

``` yaml
---
title: "Délai de service et satisfaction"
lang: fr
format:
  html:
    embed-resources: true
---
```

``` r
library(tidyverse)

performance <- read_csv(
  "data/performance_succursales_quebec.csv",
  show_col_types = FALSE
) |>
  mutate(campagne_locale = factor(campagne_locale, levels = c("non", "oui")))
```

## Exercice 1 - Identifier les variables

La responsable demande : « Un délai de service plus long est-il associé à une satisfaction mensuelle plus faible? »

Identifiez la variable réponse, la variable explicative et leurs unités. Précisez ce que représente une ligne, le nombre de succursales et le nombre de mois. Vérifiez les valeurs manquantes dans les deux variables du modèle. Nommez une variable de contexte et une information à obtenir avant de parler de causalité.

Repères : `delai_service_minutes` est un délai mensuel moyen en minutes; `satisfaction` est un score mensuel moyen sur 10; `campagne_locale` indique la présence ou l’absence d’une campagne.

> **TIP:**

## Exercice 2 - Nuage de points

Produisez un nuage de points de la satisfaction selon le délai de service. Colorez les points selon la présence d’une campagne locale. Ajoutez une seule droite ajustée à toutes les observations.

Décrivez la direction, la forme, la dispersion et le chevauchement des deux groupes. Précisez une limite du graphique.

Indice : placez `colour = campagne_locale` dans `geom_point(aes(...))` pour colorer les points sans créer deux droites.

> **TIP:**
>
> ``` r
> ggplot(performance, aes(x = delai_service_minutes, y = satisfaction)) +
>   geom_point(aes(colour = campagne_locale), alpha = 0.8, size = 2.3) +
>   geom_smooth(method = "lm", se = FALSE, colour = "#0B4F6C") +
>   labs(
>     title = "Satisfaction selon le délai de service",
>     x = "Délai de service mensuel moyen (minutes)",
>     y = "Satisfaction mensuelle moyenne (points sur 10)",
>     colour = "Campagne locale"
>   ) +
>   theme_minimal(base_size = 12)
> ```
>
> ![](exercices_files/figure-html/solution-03-nuage-1.png)
>
> La tendance globale est décroissante : les observations où le délai est plus long ont généralement une satisfaction plus faible. Les points restent dispersés autour de la droite et les groupes se chevauchent. La couleur ne démontre pas un effet causal de la campagne locale.
>
> `geom_smooth(method = "lm")` ajuste ici une droite globale, car le groupe de couleur n’est défini que dans `geom_point()`. `se = FALSE` masque la bande d’incertitude du graphique; cela ne supprime pas l’incertitude du modèle.
>
> Pour situer les données :
>
> ``` r
> performance |>
>   summarise(
>     delai_min = min(delai_service_minutes),
>     delai_max = max(delai_service_minutes),
>     satisfaction_min = min(satisfaction),
>     satisfaction_max = max(satisfaction)
>   )
> ```
>
>     # A tibble: 1 × 4
>       delai_min delai_max satisfaction_min satisfaction_max
>           <dbl>     <dbl>            <dbl>            <dbl>
>     1       3.6       8.7              5.9              8.9
>
> Les délais vont de 3,6 à 8,7 minutes et les scores de 5,9 à 8,9. L’axe vertical est exprimé en points sur 10. Une différence de 0,5 point n’est pas une baisse de 50 %.

## Exercice 3 - Ajuster le modèle

Ajustez `satisfaction ~ delai_service_minutes` avec `lm()`. Présentez la pente et son intervalle de confiance classique à 95 %. Interprétez la pente pour une différence de deux minutes.

Expliquez aussi ce que représente l’ordonnée à l’origine et pourquoi il faut être prudent à délai nul. Nommez une hypothèse nécessaire pour interpréter l’intervalle de confiance. Formulez H₀ et H₁ pour un test bilatéral de la pente. Relevez la valeur p, puis expliquez la décision au seuil de 5 % et une limite de cette décision.

> **TIP:**
>
> ``` r
> modele_service <- lm(
>   satisfaction ~ delai_service_minutes,
>   data = performance
> )
>
> coef(modele_service)
> ```
>
>               (Intercept) delai_service_minutes
>                 9.7736347            -0.3263961
>
> ``` r
> confint(modele_service, "delai_service_minutes", level = 0.95)
> ```
>
>                                2.5 %     97.5 %
>     delai_service_minutes -0.4293887 -0.2234035
>
> La droite estimée est :
>
> \\\widehat{\text{satisfaction}} = 9{,}7736 - 0{,}3264\times\text{délai en minutes}.\\
>
> La pente est d’environ −0,326 point par minute. Son intervalle classique à 95 % va d’environ −0,429 à −0,223 point par minute.
>
> ``` r
> pente_deux_minutes <- coef(modele_service)[["delai_service_minutes"]] * 2
> intervalle_deux_minutes <- confint(
>   modele_service, "delai_service_minutes", level = 0.95
> ) * 2
>
> pente_deux_minutes
> ```
>
>     [1] -0.6527922
>
> ``` r
> intervalle_deux_minutes
> ```
>
>                                2.5 %    97.5 %
>     delai_service_minutes -0.8587774 -0.446807
>
> Une réponse possible :
>
> > Dans ces données simulées, deux minutes de délai moyen supplémentaires sont associées à une satisfaction mensuelle moyenne inférieure d’environ 0,65 point sur 10 selon le modèle. L’intervalle classique correspondant va d’environ −0,86 à −0,45 point pour la différence de satisfaction.
>
> Le signe indique une diminution. On multiplie la pente et les deux bornes par 2 pour passer de la comparaison d’une minute à celle de deux minutes.
>
> L’ordonnée vaut environ 9,77 points : c’est la satisfaction prédite à délai nul. Les délais observés commencent à 3,6 minutes. Cette interprétation à zéro extrapole donc au-delà des observations.
>
> ### Tester une pente nulle
>
> Les hypothèses sont \\H_0 : \beta_1 = 0\\ et \\H_1 : \beta_1 \ne 0\\.
>
> ``` r
> test_pente_service <- summary(modele_service)$coefficients[
>   "delai_service_minutes", ]
> test_pente_service
> ```
>
>          Estimate    Std. Error       t value      Pr(>|t|)
>     -3.263961e-01  5.163994e-02 -6.320614e+00  2.109825e-08
>
> La valeur p est inférieure à 0,001 : au seuil de 5 %, le test rejette H₀ sous les hypothèses du modèle. Elle indique une faible compatibilité des données avec une pente nulle, sous ces hypothèses. Ce n’est ni la probabilité que H₀ soit vraie ni une mesure de l’ampleur de l’association. La pente et son intervalle donnent cette information dans les unités de satisfaction.
>
> L’intervalle classique repose notamment sur une moyenne linéaire, des erreurs indépendantes et de variance constante; la normalité permet le calcul exact présenté. Comme les mêmes succursales sont observées sur plusieurs mois, l’indépendance reste à examiner. L’intervalle illustre le calcul sous ces hypothèses et ne prouve pas un effet causal du délai.

## Exercice 4 - Examiner les résidus et le R²

Produisez le graphique des résidus selon les valeurs prédites, avec une couleur par succursale. Calculez ensuite, pour chaque succursale, le résidu moyen et l’erreur absolue moyenne, c’est-à-dire la moyenne des valeurs absolues des résidus.

Identifiez une sous-estimation ou une surestimation moyenne. Expliquez pourquoi un petit résidu moyen peut coexister avec des erreurs individuelles importantes. Calculez aussi SSE, SST et R². Comparez votre R² à celui de `summary()` et exprimez-le en pourcentage. Terminez par une limite du modèle simple.

> **TIP:**
>
> ``` r
> diagnostic_service <- performance |>
>   mutate(
>     satisfaction_predite = fitted(modele_service),
>     residu = residuals(modele_service)
>   )
> ```
>
> ``` r
> ggplot(diagnostic_service, aes(x = satisfaction_predite, y = residu)) +
>   geom_hline(yintercept = 0, colour = "#7A1C24") +
>   geom_point(aes(colour = succursale), alpha = 0.8, size = 2.3) +
>   labs(
>     title = "Résidus du modèle de satisfaction",
>     x = "Satisfaction prédite (points sur 10)",
>     y = "Résidu (points)",
>     colour = "Succursale"
>   ) +
>   theme_minimal(base_size = 12)
> ```
>
> ![](exercices_files/figure-html/solution-03-graphique-residus-1.png)
>
> ``` r
> bilan_succursales <- diagnostic_service |>
>   group_by(succursale) |>
>   summarise(
>     observations = n(),
>     residu_moyen = mean(residu),
>     erreur_absolue_moyenne = mean(abs(residu)),
>     .groups = "drop"
>   )
>
> bilan_succursales |>
>   mutate(across(c(residu_moyen, erreur_absolue_moyenne), ~ round(.x, 3))) |>
>   knitr::kable(col.names = c(
>     "Succursale", "Observations", "Résidu moyen (points)",
>     "Erreur absolue moyenne (points)"
>   ))
> ```
>
> | Succursale | Observations | Résidu moyen (points) | Erreur absolue moyenne (points) |
> |:---|---:|---:|---:|
> | Gatineau | 12 | 0.023 | 0.444 |
> | Montréal | 12 | 0.336 | 0.408 |
> | Québec | 12 | -0.102 | 0.399 |
> | Saguenay | 12 | -0.099 | 0.573 |
> | Sherbrooke | 12 | -0.149 | 0.335 |
> | Trois-Rivières | 12 | -0.009 | 0.274 |
>
> À Montréal, le résidu moyen est d’environ +0,336 point : la droite sous-estime en moyenne la satisfaction. À Sherbrooke, il est d’environ −0,149 point : elle la surestime en moyenne. Ces écarts sont descriptifs et ne prouvent pas un effet propre à la succursale.
>
> À Gatineau, le résidu moyen est proche de zéro (+0,023 point), mais l’erreur absolue moyenne vaut environ 0,444 point. Des erreurs positives et négatives peuvent s’annuler dans une moyenne signée. La moyenne des valeurs absolues renseigne sur leur ampleur.
>
> ### Retrouver le coefficient de détermination
>
> ``` r
> sse_service <- sum(residuals(modele_service)^2)
> sst_service <- sum(
>   (performance$satisfaction - mean(performance$satisfaction))^2
> )
>
> tibble(
>   SSE = sse_service,
>   SST = sst_service,
>   R2_calcule = 1 - sse_service / sst_service,
>   R2_summary = summary(modele_service)$r.squared,
>   pourcentage = 100 * (1 - sse_service / sst_service)
> )
> ```
>
>     # A tibble: 1 × 5
>         SSE   SST R2_calcule R2_summary pourcentage
>       <dbl> <dbl>      <dbl>      <dbl>       <dbl>
>     1  16.6  26.1      0.363      0.363        36.3
>
> Les deux R² valent environ 0,363 : la droite explique environ 36,3 % de la variation observée des scores de satisfaction. Cela ne signifie pas que 36,3 % des prédictions sont correctes. Les écarts au carré à la droite représentent les quelque 63,7 % restants de la variation totale.
>
> Le nuage ne montre pas de courbure nette, mais les différences entre succursales méritent un examen. La moyenne globale des résidus est nulle par construction avec une ordonnée; ce seul fait ne valide pas le modèle. Il faudrait aussi examiner les mois et les variables de contexte. Le graphique ne vérifie pas l’indépendance entre observations répétées.

## Exercice 5 - Conclusion courte

Rédigez au plus cinq phrases pour la responsable du service :

1.  la question étudiée;
2.  la direction et l’ampleur de l’association pour deux minutes;
3.  un résultat précis du diagnostic;
4.  une limite de l’interprétation;
5.  une information à recueillir ensuite.

> **TIP:**
>
> Une conclusion possible :
>
> > Nous étudions le lien entre délai de service moyen et satisfaction mensuelle dans six succursales fictives observées pendant douze mois. Deux minutes de délai supplémentaires sont associées à une satisfaction moyenne inférieure d’environ 0,65 point sur 10 selon la droite. Le modèle sous-estime notamment la satisfaction à Montréal d’environ 0,34 point en moyenne. Cette association ne prouve pas qu’une réduction imposée du délai provoquerait une amélioration de satisfaction de même ampleur, et les observations répétées appellent un examen de l’indépendance. Il faudrait documenter les changements de personnel, les ruptures de stock et le moment des interventions pour approfondir l’analyse.
>
> Cette réponse cite un résultat vérifiable, conserve les unités et propose une collecte liée aux limites du modèle. D’autres formulations conviennent si elles restent cohérentes avec les résultats. Évitez une conclusion limitée à « la pente est significative ».

## Exercice 6 - Mini-trace finale

Préparez une courte note Quarto destinée à la responsable du service. Rassemblez le nuage de points, le modèle, la pente et son intervalle, le test sous hypothèses, le calcul du R², le diagnostic par succursale et votre conclusion. Indiquez une action de collecte de données.

Redémarrez R et rendez le document en HTML. Les exercices précédents doivent suffire à recalculer tous les résultats.

> **TIP:**
>
> ### Organisation possible
>
> | Section du rapport | Contenu attendu |
> |----|----|
> | Question et données | 72 observations mois-succursale, données simulées, variables et unités |
> | Relation observée | Nuage de points de l’exercice 2 et lecture de la dispersion |
> | Modèle | Code `lm()`, pente, intervalle classique, H₀, valeur p et hypothèses |
> | Diagnostic | Graphique des résidus, tableau par succursale et calcul du R² |
> | Conclusion | Votre réponse à l’exercice 5 et la prochaine collecte proposée |
>
> Pour présenter la comparaison de deux minutes dans un petit tableau :
>
> ``` r
> ic_pente <- confint(modele_service, "delai_service_minutes")
>
> tibble(
>   comparaison = "Deux minutes supplémentaires",
>   difference_satisfaction = 2 * coef(modele_service)[["delai_service_minutes"]],
>   borne_inferieure = 2 * ic_pente[1, 1],
>   borne_superieure = 2 * ic_pente[1, 2]
> ) |>
>   mutate(across(where(is.numeric), ~ round(.x, 3))) |>
>   knitr::kable(col.names = c(
>     "Comparaison", "Différence (points)", "Borne inférieure", "Borne supérieure"
>   ))
> ```
>
> | Comparaison | Différence (points) | Borne inférieure | Borne supérieure |
> |:---|---:|---:|---:|
> | Deux minutes supplémentaires | -0.653 | -0.859 | -0.447 |
>
> Les bornes sont celles de l’intervalle classique à 95 % de la différence moyenne estimée sous le modèle. Elles ne décrivent pas l’intervalle de satisfaction d’une nouvelle observation.
>
> ### Vérifier le rapport
>
> Dans RStudio, choisissez Session \> Restart R, puis Render. Si un objet manque, vérifiez que le bloc qui le crée est présent plus haut dans le document. Si le CSV est introuvable, vérifiez le dossier `data` dans Files.
>
> Le HTML doit afficher les résultats et vos explications. Conservez le `.qmd` avec le CSV pour permettre de refaire l’analyse. Cette trace est un entraînement; elle ne remplace pas un mini-rapport évalué.

## Auto-vérification

J’ai tenté chaque exercice avant d’ouvrir son corrigé.

Je distingue une observation mensuelle d’un client individuel.

J’interprète la pente en points de satisfaction pour deux minutes.

Je formule H₀ et j’interprète une valeur p sous les hypothèses du modèle.

Je calcule R² à partir de SSE et SST, puis le convertis en pourcentage.

Je sais expliquer le signe d’un résidu et l’erreur absolue moyenne.

J’ai relié la conclusion à un diagnostic effectivement calculé.

Mon HTML se recalcule après redémarrage de R.

Vous pouvez demander au [GPT du cours](https://chatgpt.com/g/g-6a0b2ec33d948191ad25b2f247b15de1-analyse-et-modelisation-des-donnees?ref=mini) de commenter votre tentative. Gardez une trace de l’aide reçue et reformulez votre réponse vous-même. Une solution comprise avec de l’aide ne démontre pas, à elle seule, que vous savez la reproduire sans aide.
