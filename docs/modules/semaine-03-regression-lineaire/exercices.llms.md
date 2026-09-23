# Exercices - Module 03

## Objectif

Appliquer la régression linéaire à une nouvelle question : une responsable de service souhaite décrire le lien entre le délai de service et la satisfaction mensuelle dans des succursales fictives.

Jeu de données de transfert : [performance_succursales_quebec.csv](../atelier-02-regression/data/performance_succursales_quebec.csv), décrit dans la [page Données](../../donnees/#performance-de-succursales-québécoises-fictives).

Les activités des capsules portent sur le budget marketing et les ventes. Ici, la question, les variables, les unités et la destinataire changent. Les six premiers exercices se suivent et alimentent un seul rapport, `diagnostic_service.qmd`. Huit [exercices supplémentaires](#pratique-supplementaire), numérotés de 7 à 14, permettent ensuite de cibler les notions à renforcer.

Repères dans le parcours : exercice 1 après la capsule 1, exercice 2 après la capsule 2, exercice 3 après la capsule 4, puis exercices 4 à 6 après la capsule 6. Le dernier groupe mobilise le diagnostic des résidus et le R². Préparez d’abord le projet ci-dessous; conservez-le pour les six exercices.

Faites une première tentative avant d’ouvrir la solution détaillée à la fin de chaque exercice. Les corrigés contiennent le code, les résultats calculés et leur interprétation. Pour les exercices 1 à 6, leur code s’exécute dans l’ordre, après la préparation ci-dessous. Les réponses rédigées sont des exemples à comparer à votre raisonnement.

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

## Pratique supplémentaire

Ces huit exercices sont facultatifs et peuvent être choisis selon vos besoins. Les exercices 7 et 8 utilisent de petits exemples fictifs; les exercices 9 à 12 reprennent le fichier de succursales; les exercices 13 et 14 portent sur le diagnostic et l’interprétation.

| Objectif | Exercices | Préalable |
|----|----|----|
| Consolider les calculs de base | [7](#exercice-07), [8](#exercice-08) | Capsules 1 à 3; calculatrice suffisante pour commencer |
| Relier unités, corrélation et R² | [9](#exercice-09), [10](#exercice-10) | Capsules 3 et 6; exécuter la préparation ci-dessus |
| Distinguer les prédictions et leurs limites | [11](#exercice-11), [12](#exercice-12) | Capsules 4 à 6; exécuter la préparation ci-dessus |
| Justifier un diagnostic et une conclusion | [13](#exercice-13), [14](#exercice-14) | Capsules 4 à 6; pas de fichier nécessaire |

Pour les exercices 9 à 12, chaque corrigé réajuste son modèle à partir de `performance`. Vous pouvez donc les faire séparément après la préparation. Pour les exercices des ouvrages, consultez les [lectures et exercices ciblés](../../modules/semaine-03-regression-lineaire/lectures.llms.md#exercices-ouvrages).

## Exercice 7 - Prédiction, résidu et unités

Niveau : consolidation.

Une entreprise de livraison fictive à Québec a ajusté la droite suivante sur des journées comptant de 4 à 12 livraisons :

\\ \widehat{\text{coût}} = 120 + 18 \times \text{nombre de livraisons}. \\

Le coût est exprimé en dollars par journée. Une journée comptait 8 livraisons et a coûté 250 \$.

1.  Interprétez la pente avec ses unités.
2.  Calculez le coût prédit pour cette journée et son résidu. Le modèle surestime-t-il ou sous-estime-t-il le coût observé?
3.  Comparez les coûts prédits pour 8 et 11 livraisons.
4.  Peut-on conclure que le coût fixe réel est de 120 \$ ou que chaque livraison ajoutée cause exactement 18 \$ de dépenses?

> **TIP:**
>
> 1.  Une livraison supplémentaire est associée à une hausse de 18 \$ du coût journalier prédit par la droite. L’unité de la pente est le dollar par livraison.
> 2.  Pour 8 livraisons, le coût prédit est \\120 + 18 \times 8 = 264\\ dollars. Le résidu est \\250 - 264 = -14\\ dollars. La valeur observée est sous la droite; le modèle surestime le coût de 14 \$.
> 3.  Pour 11 livraisons, la prédiction est de 318 \$. La différence est de \\18 \times (11 - 8) = 54\\ dollars.
> 4.  L’ordonnée à l’origine de 120 \$ est une prédiction à zéro livraison, en dehors de la plage observée. Elle ne suffit pas à établir un coût fixe réel. Une droite ajustée sur des observations ne démontre ni un effet causal ni un coût identique pour chaque livraison.
>
> Vérification dans R, sans fichier de données :
>
> ``` r
> cout_predit <- function(livraisons) 120 + 18 * livraisons
> c(
>   prediction_8 = cout_predit(8),
>   residu_8 = 250 - cout_predit(8),
>   prediction_11 = cout_predit(11),
>   difference = cout_predit(11) - cout_predit(8)
> )
> ```
>
>      prediction_8      residu_8 prediction_11    difference
>               264           -14           318            54

## Exercice 8 - Retrouver la droite à la main

Niveau : consolidation, puis calcul.

Voici cinq observations entièrement fictives. Chaque ligne représente une période de service; \\x\\ est le délai moyen en minutes et \\y\\ la satisfaction moyenne sur 10.

| Période | \\x\\ | \\y\\ |
|---------|------:|------:|
| 1       |     2 |     9 |
| 2       |     4 |     8 |
| 3       |     6 |     8 |
| 4       |     8 |     6 |
| 5       |    10 |     5 |

1.  Calculez \\\bar{x}\\, \\\bar{y}\\, \\S\_{xx} = \sum_i (x_i-\bar{x})^2\\ et \\S\_{xy} = \sum_i (x_i-\bar{x})(y_i-\bar{y})\\.
2.  Utilisez \\\hat\beta_1 = S\_{xy}/S\_{xx}\\ et \\\hat\beta_0 = \bar{y}-\hat\beta_1\bar{x}\\ pour trouver la droite.
3.  Calculez les cinq valeurs ajustées, les résidus et SSE. Quelle période a le plus grand résidu en valeur absolue?
4.  Calculez SST et \\R^2 = 1-\mathrm{SSE}/\mathrm{SST}\\. Ce résultat prouve-t-il que la relation est causale?

> **TIP:**
>
> Les moyennes sont \\\bar{x}=6\\ et \\\bar{y}=7{,}2\\. Les sommes centrées valent \\S\_{xx}=40\\ et \\S\_{xy}=-20\\. On obtient donc \\\hat\beta_1=-0{,}5\\ et \\\hat\beta_0=10{,}2\\, soit \\\hat{y}=10{,}2-0{,}5x\\.
>
> | Période | Valeur ajustée | Résidu \\y-\hat{y}\\ | Résidu au carré |
> |---------|---------------:|---------------------:|----------------:|
> | 1       |            9,2 |                 -0,2 |            0,04 |
> | 2       |            8,2 |                 -0,2 |            0,04 |
> | 3       |            7,2 |                  0,8 |            0,64 |
> | 4       |            6,2 |                 -0,2 |            0,04 |
> | 5       |            5,2 |                 -0,2 |            0,04 |
>
> La période 3 a le plus grand résidu en valeur absolue. SSE vaut 0,8 et SST vaut 10,8. Ainsi, \\R^2=1-0{,}8/10{,}8\approx 0{,}9259\\, soit environ 92,6 % de la variabilité observée de \\y\\ autour de sa moyenne décrite par cette droite. Un ajustement élevé sur cinq observations ne prouve pas la causalité et ne valide pas les hypothèses d’inférence.
>
> Le calcul direct et `lm()` donnent la même droite :
>
> ``` r
> petit_exemple <- data.frame(
>   delai = c(2, 4, 6, 8, 10),
>   satisfaction = c(9, 8, 8, 6, 5)
> )
> x <- petit_exemple$delai
> y <- petit_exemple$satisfaction
> sxx <- sum((x - mean(x))^2)
> sxy <- sum((x - mean(x)) * (y - mean(y)))
> pente <- sxy / sxx
> origine <- mean(y) - pente * mean(x)
> residus <- y - (origine + pente * x)
>
> c(
>   origine = origine,
>   pente = pente,
>   SSE = sum(residus^2),
>   SST = sum((y - mean(y))^2),
>   R2 = 1 - sum(residus^2) / sum((y - mean(y))^2)
> )
> ```
>
>        origine      pente        SSE        SST         R2
>     10.2000000 -0.5000000  0.8000000 10.8000000  0.9259259
>
> ``` r
> coef(lm(satisfaction ~ delai, data = petit_exemple))
> ```
>
>     (Intercept)       delai
>            10.2        -0.5

## Exercice 9 - Passer des minutes aux secondes

Niveau : intermédiaire.

Reprenez `performance`, importé dans la préparation. Une collègue remplace les délais en minutes par des délais en secondes.

1.  Avant de calculer, prévoyez ce qui arrivera à la pente, à l’ordonnée à l’origine, aux valeurs ajustées et au R².
2.  Créez `delai_service_secondes`, ajustez les deux modèles et vérifiez votre réponse.
3.  Interprétez la pente par seconde, puis retrouvez la différence prédite pour deux minutes supplémentaires.

> **TIP:**
>
> Puisque \\x\_{\mathrm{secondes}}=60x\_{\mathrm{minutes}}\\, la pente par seconde est la pente par minute divisée par 60. L’ordonnée à l’origine, les valeurs ajustées, les résidus et le R² restent les mêmes, à l’arrondi numérique près. Le changement d’unité ne change pas l’information contenue dans les observations.
>
> ``` r
> modele_minutes <- lm(satisfaction ~ delai_service_minutes, data = performance)
> performance_secondes <- performance |>
>   mutate(delai_service_secondes = 60 * delai_service_minutes)
> modele_secondes <- lm(satisfaction ~ delai_service_secondes, data = performance_secondes)
>
> tibble(
>   unite = c("minute", "seconde"),
>   origine = c(coef(modele_minutes)[[1]], coef(modele_secondes)[[1]]),
>   pente = c(coef(modele_minutes)[[2]], coef(modele_secondes)[[2]]),
>   R2 = c(summary(modele_minutes)$r.squared, summary(modele_secondes)$r.squared)
> ) |>
>   knitr::kable(digits = 6)
> ```
>
> | unite   |  origine |     pente |       R2 |
> |:--------|---------:|----------:|---------:|
> | minute  | 9.773635 | -0.326396 | 0.363348 |
> | seconde | 9.773635 | -0.005440 | 0.363348 |
>
> ``` r
> c(
>   ecart_max_predictions = max(abs(fitted(modele_minutes) - fitted(modele_secondes))),
>   difference_pour_120_secondes = 120 * coef(modele_secondes)[[2]]
> )
> ```
>
>            ecart_max_predictions difference_pour_120_secondes
>                     1.776357e-15                -6.527922e-01
>
> La pente est d’environ -0,005440 point de satisfaction par seconde. Deux minutes correspondent à 120 secondes; la différence prédite est donc d’environ -0,653 point. Il s’agit toujours d’une association entre moyennes mensuelles, pas d’un effet causal établi.

## Exercice 10 - Distinguer corrélation et R²

Niveau : intermédiaire.

1.  Calculez la corrélation entre délai et satisfaction, puis son carré.
2.  Comparez ce carré au R² du modèle linéaire simple avec constante.
3.  Une collègue écrit : « Le R² est positif, donc la satisfaction augmente avec le délai; environ 36 % des prédictions sont exactes. » Corrigez ses deux interprétations.
4.  La règle \\R^2=r^2\\ s’applique-t-elle automatiquement à tous les modèles?

> **TIP:**
>
> ``` r
> modele_correlation <- lm(satisfaction ~ delai_service_minutes, data = performance)
> r_service <- cor(performance$delai_service_minutes, performance$satisfaction)
> tibble(
>   correlation = r_service,
>   correlation_au_carre = r_service^2,
>   R2 = summary(modele_correlation)$r.squared
> ) |>
>   knitr::kable(digits = 4)
> ```
>
> | correlation | correlation_au_carre |     R2 |
> |------------:|---------------------:|-------:|
> |     -0.6028 |               0.3633 | 0.3633 |
>
> La corrélation vaut environ -0,603; son carré et le R² valent environ 0,363. La relation linéaire observée est négative. Le carré perd le signe : le R² ne donne donc pas la direction de l’association.
>
> Le modèle décrit environ 36,3 % de la variabilité observée de la satisfaction autour de sa moyenne. Ce n’est pas un pourcentage de prédictions exactes. Pour étudier les erreurs, on examine notamment les résidus; pour évaluer de nouvelles prédictions, il faut aussi une validation adaptée.
>
> L’identité vaut ici pour les moindres carrés ordinaires non pondérés, avec constante, une seule variable explicative numérique, les mêmes paires complètes et des variables non constantes. On ne l’applique pas automatiquement à un modèle sans constante ou à une régression multiple.

## Exercice 11 - Moyenne ou nouvelle observation?

Niveau : approfondissement.

Pour un délai mensuel moyen de 6 minutes :

1.  Calculez la satisfaction prédite, un intervalle de confiance à 95 % pour la moyenne conditionnelle et un intervalle de prédiction à 95 % pour une nouvelle observation du même type.
2.  Comparez les largeurs. Pourquoi l’un des intervalles est-il plus large?
3.  Choisissez l’intervalle correspondant à chaque question : « Quelle est la satisfaction moyenne attendue à ce délai? » et « Quelle satisfaction mensuelle pourrait-on observer pour une nouvelle observation mois-succursale? »
4.  Peut-on utiliser ces résultats directement pour la satisfaction d’un client individuel ou garantir leur couverture malgré les observations répétées?

> **TIP:**
>
> ``` r
> modele_intervalles <- lm(satisfaction ~ delai_service_minutes, data = performance)
> nouveau_delai <- tibble(delai_service_minutes = 6)
> ic_moyenne <- predict(modele_intervalles, newdata = nouveau_delai,
>                       interval = "confidence", level = 0.95)
> ip_observation <- predict(modele_intervalles, newdata = nouveau_delai,
>                           interval = "prediction", level = 0.95)
> bind_rows(
>   as_tibble(ic_moyenne) |> mutate(cible = "Moyenne conditionnelle"),
>   as_tibble(ip_observation) |> mutate(cible = "Nouvelle observation mensuelle")
> ) |>
>   mutate(largeur = upr - lwr) |>
>   select(cible, fit, lwr, upr, largeur) |>
>   knitr::kable(digits = 3, col.names = c(
>     "Cible", "Prédiction", "Borne inférieure", "Borne supérieure", "Largeur"
>   ))
> ```
>
> | Cible | Prédiction | Borne inférieure | Borne supérieure | Largeur |
> |:---|---:|---:|---:|---:|
> | Moyenne conditionnelle | 7.815 | 7.700 | 7.930 | 0.230 |
> | Nouvelle observation mensuelle | 7.815 | 6.836 | 8.794 | 1.958 |
>
> La prédiction commune vaut environ 7,815 points sur 10. L’intervalle pour la moyenne est \[7,700; 7,930\], contre \[6,836; 8,794\] pour une nouvelle observation mensuelle.
>
> Le premier intervalle décrit l’incertitude sur la moyenne conditionnelle estimée. Le second inclut aussi la variabilité d’une nouvelle observation autour de cette moyenne; il est donc plus large. Ils répondent respectivement à la première et à la deuxième question.
>
> Ces calculs illustrent les intervalles classiques sous le modèle linéaire à erreurs indépendantes, de variance constante et normales. Les données répétées par succursale ne permettent pas de tenir l’indépendance pour acquise. Sans examen et prise en compte de cette structure, on ne garantit pas la couverture nominale de 95 %. La cible reste une observation mensuelle agrégée, pas un client individuel.

## Exercice 12 - Repérer l’extrapolation

Niveau : intermédiaire.

1.  Retrouvez la plage des délais observés dans `performance`.
2.  Classez les demandes de prédiction à 2, 5, 9 et 40 minutes comme interpolation ou extrapolation.
3.  Calculez les quatre prédictions. Repérez celle qui est incompatible avec un score sur 10 et expliquez ce qu’elle révèle.
4.  Que répondriez-vous à une personne qui propose de remplacer automatiquement tout score négatif par zéro? Une interpolation garantit-elle une bonne prédiction?

> **TIP:**
>
> ``` r
> modele_extrapolation <- lm(satisfaction ~ delai_service_minutes, data = performance)
> plage_delais <- range(performance$delai_service_minutes)
> demandes <- tibble(delai_service_minutes = c(2, 5, 9, 40))
> demandes |>
>   mutate(
>     situation = if_else(
>       between(delai_service_minutes, plage_delais[1], plage_delais[2]),
>       "Interpolation", "Extrapolation"
>     ),
>     satisfaction_predite = as.numeric(predict(modele_extrapolation, newdata = demandes))
>   ) |>
>   knitr::kable(digits = 3)
> ```
>
> | delai_service_minutes | situation     | satisfaction_predite |
> |----------------------:|:--------------|---------------------:|
> |                     2 | Extrapolation |                9.121 |
> |                     5 | Interpolation |                8.142 |
> |                     9 | Extrapolation |                6.836 |
> |                    40 | Extrapolation |               -3.282 |
>
> ``` r
> plage_delais
> ```
>
>     [1] 3.6 8.7
>
> Les délais observés vont de 3,6 à 8,7 minutes. Seule la demande à 5 minutes est une interpolation. Les demandes à 2, 9 et 40 minutes sont des extrapolations, même si 9 minutes est proche de la borne supérieure.
>
> À 40 minutes, la droite prédit environ -3,28 points : cette valeur est incompatible avec l’échelle de satisfaction. Cela montre une limite de son prolongement hors de la plage observée. Remplacer cette valeur par zéro ne valide ni le modèle ni la prédiction; il faut reconnaître l’absence d’appui dans les données et, au besoin, recueillir des observations pertinentes et revoir le modèle.
>
> À 5 minutes, la demande se situe dans la plage observée, mais la dispersion, les hypothèses et la comparabilité du contexte restent à examiner. Une interpolation ne constitue pas une garantie d’exactitude.

## Exercice 13 - Lire trois diagnostics

Niveau : approfondissement.

Les trois graphiques proviennent de jeux de données fictifs distincts, chacun ajusté par une droite avec constante. Les unités sont arbitraires. Dans A et B, l’axe horizontal représente la valeur ajustée. Dans C, il représente l’ordre chronologique des observations.

![Trois diagnostics fictifs : A montre une courbure, B une dispersion croissante et C des séries temporelles de résidus de même signe.](exercices_files/figure-html/enonce-03-diagnostics-fictifs-1.png)

1.  Pour chaque panneau, décrivez le motif et la condition qu’il invite à examiner.
2.  Proposez une vérification supplémentaire par panneau, sans supprimer automatiquement des observations.
3.  Un R² de 0,90 suffirait-il à écarter ces problèmes? Ces graphiques vérifient-ils à eux seuls la normalité des erreurs?

> **TIP:**
>
> | Panneau | Constat | Condition à examiner | Prochaine vérification |
> |----|----|----|----|
> | A | Les résidus dessinent une courbe en U | Forme linéaire de la moyenne conditionnelle | Revoir le nuage initial et déterminer si une forme courbe est pertinente dans le contexte |
> | B | L’amplitude des résidus augmente avec la valeur ajustée | Variance constante des erreurs | Examiner la dispersion selon le niveau prédit et le mécanisme de mesure |
> | C | De longues suites de résidus ont le même signe | Indépendance dans le temps; éventuel changement omis | Examiner les dates, les interventions et les liens entre observations successives |
>
> Ces motifs sont des signaux diagnostiques. Ils appellent une enquête sur les données et le modèle; ils ne désignent pas automatiquement une cause unique ou une correction à appliquer.
>
> Un R² élevé ne vérifie aucune de ces conditions. Un graphique quantile-quantile des résidus peut compléter l’examen de la normalité des erreurs; même un graphique satisfaisant ne constitue pas une preuve. L’indépendance dépend aussi du plan de collecte et ne se déduit pas d’un nuage de résidus centré sur zéro.

## Exercice 14 - Corriger un compte rendu

Niveau : synthèse.

Dans un autre exemple fictif, un analyste étudie 50 observations. Le modèle avec constante relie un budget promotionnel, en milliers de dollars, à des ventes, également en milliers de dollars. Il obtient une pente de 2,4, une erreur-type de 1,3 et \\R^2=0{,}066\\. Pour cet exercice, supposez les conditions du test classique satisfaites.

1.  Testez \\H_0:\beta_1=0\\ contre \\H_1:\beta_1\ne 0\\ au seuil de 5 %. Calculez \\t\\, les degrés de liberté, la valeur p et l’intervalle de confiance à 95 % de la pente.
2.  Corrigez les quatre phrases suivantes et proposez une conclusion de trois phrases.

> 1.  « La valeur p est la probabilité que la pente vraie soit nulle. »
>
> 2.  « Comme le test n’est pas significatif, le budget n’a aucun lien avec les ventes. »
>
> 3.  « Le R² indique que 6,6 % des prédictions sont correctes. »
>
> 4.  « Augmenter le budget de 1 000 \$ provoquera exactement 2 400 \$ de ventes supplémentaires. »

> **TIP:**
>
> Pour une régression simple avec constante, les degrés de liberté sont \\50-2=48\\. La statistique est \\t=2{,}4/1{,}3\approx 1{,}846\\. On calcule la valeur p bilatérale et l’intervalle classique avec la loi de Student :
>
> ``` r
> pente_exemple <- 2.4
> erreur_type <- 1.3
> degres_liberte <- 50 - 2
> statistique_t <- pente_exemple / erreur_type
> valeur_p <- 2 * pt(-abs(statistique_t), df = degres_liberte)
> ic_exemple <- pente_exemple + c(-1, 1) * qt(0.975, df = degres_liberte) * erreur_type
> c(t = statistique_t, ddl = degres_liberte, p = valeur_p,
>   borne_inferieure = ic_exemple[1], borne_superieure = ic_exemple[2])
> ```
>
>                    t              ddl                p borne_inferieure
>           1.84615385      48.00000000       0.07104125      -0.21382518
>     borne_superieure
>           5.01382518
>
> La valeur p est d’environ 0,071 et l’intervalle va de -0,214 à 5,014 milliers de dollars de ventes par millier de dollars de budget. Le test ne rejette pas \\H_0\\ à 5 %; l’intervalle contient zéro, ce qui concorde avec le test bilatéral.
>
> | Phrase | Correction |
> |----|----|
> | a | Sous \\H_0\\ et les hypothèses du test, la valeur p est la probabilité d’obtenir une statistique au moins aussi extrême en valeur absolue que celle observée. Ce n’est pas la probabilité que \\H_0\\ soit vraie. |
> | b | Le test ne fournit pas assez d’éléments pour conclure à une pente non nulle au seuil choisi. Il ne démontre pas une absence d’association. |
> | c | Le R² décrit la part de variabilité des ventes autour de leur moyenne prise en compte par la droite sur ces observations, soit 6,6 %. |
> | d | La pente estimée représente une différence moyenne de 2 400 \$ de ventes associée à 1 000 \$ de budget supplémentaire. Ni la causalité ni une hausse exacte pour chaque observation ne sont établies. |
>
> Une conclusion possible :
>
> > Sur ces observations fictives, 1 000 \$ de budget supplémentaire sont associés à une hausse moyenne estimée de 2 400 \$ des ventes. L’intervalle classique à 95 % de la pente inclut zéro et le test bilatéral ne permet pas de conclure à une pente non nulle au seuil de 5 %. L’incertitude reste importante, la droite décrit 6,6 % de la variabilité observée des ventes et cette analyse ne démontre pas un effet causal du budget.

## Auto-vérification

J’ai tenté chaque exercice avant d’ouvrir son corrigé.

Je distingue une observation mensuelle d’un client individuel.

J’interprète la pente en points de satisfaction pour deux minutes.

Je formule H₀ et j’interprète une valeur p sous les hypothèses du modèle.

Je calcule R² à partir de SSE et SST, puis le convertis en pourcentage.

Je sais expliquer le signe d’un résidu et l’erreur absolue moyenne.

J’ai relié la conclusion à un diagnostic effectivement calculé.

Je distingue un intervalle pour la moyenne d’un intervalle pour une nouvelle observation.

Je repère une extrapolation et les limites d’un changement d’unité.

Mon HTML se recalcule après redémarrage de R.

Vous pouvez demander au [GPT du cours](https://chatgpt.com/g/g-6a0b2ec33d948191ad25b2f247b15de1-analyse-et-modelisation-des-donnees?ref=mini) de commenter votre tentative. Gardez une trace de l’aide reçue et reformulez votre réponse vous-même. Une solution comprise avec de l’aide ne démontre pas, à elle seule, que vous savez la reproduire sans aide.
