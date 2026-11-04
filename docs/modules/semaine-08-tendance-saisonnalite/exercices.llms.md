# Exercices - Module 08

## Un transfert vers la planification commerciale

Une direction de commerce fictif doit planifier les ventes mensuelles alors que promotions et prix changent. Le parcours principal utilise seulement le calendrier connu à l’origine; les erreurs et les coefficients demandent une interprétation différente du cas guidé. Les variables commerciales ne sont pas employées comme prédicteurs futurs dans les cinq premiers exercices.

Ces cinq exercices se suivent après les capsules correspondantes et alimentent `tendance_commerce.qmd`. Tentez chaque réponse avant d’ouvrir son corrigé. Leur code s’exécute dans l’ordre après la préparation commune. Huit [pratiques ciblées](#pratique-supplementaire) et deux exercices commerciaux accompagnés sont facultatifs.

Téléchargez le [projet de transfert](telechargements/tendance-commerce.zip) ou le [corrigé complet](telechargements/corrige-tendance-commerce.zip). Les données, [dictionnaires](data/dictionnaires.md) et fonctions sont fournis.

## Préparation

Ouvrez le `.Rproj`; conservez `R/` et `data/`. Apprentissage: janvier 2020 à décembre 2024, 60 mois. Validation: les douze mois de 2025, prévus à l’origine de décembre 2024. Les quatre candidats sont tendance seule, saison seule, tendance avec mois et naïf saisonnier. Aucun prix ou promotion futur observé ne sert à ces prévisions.

``` r
library(tidyverse)
library(broom)
source("R/fonctions-module08.R")
commerce <- read_csv("data/ventes_promotions_quebec.csv", show_col_types = FALSE) |>
  preparer_calendrier()
stopifnot(nrow(commerce) == 72L)
apprentissage <- commerce |> slice_head(n = 60)
validation <- commerce |> slice_tail(n = 12)
# Les prédicteurs futurs sont construits sans les ventes ni le budget de validation.
futur <- calendrier_futur("2025-01-01", horizon = 12, dernier_indice = 60)
serie <- ts(apprentissage$ventes, frequency = 12, start = c(2020, 1))
```

## Exercice 1 - Lire une série dans son contexte

Tracez les ventes d’apprentissage dans le temps et les profils mensuels par année. Indiquez les promotions sur le graphique temporel. Distinguez hausse générale, récurrence et événements possibles. Que manque-t-il avant d’attribuer une fluctuation à une cause? Décomposez la série d’apprentissage de façon additive, interprétez un écart saisonnier en dollars et nommez une limite de cette description.

> **TIP:**
>
> ``` r
> ggplot(apprentissage, aes(date, ventes / 1000)) +
>   geom_line(colour = "#0B4F6C") + geom_point(aes(shape = promotion)) +
>   labs(x = NULL, y = "Ventes mensuelles (milliers de $ CA)") +
>   theme_minimal(base_size = 12)
> ```
>
> ![](exercices_files/figure-html/solution-08-1-1.png)
>
> ``` r
> ggplot(apprentissage, aes(mois, ventes / 1000, group = factor(annee), colour = factor(annee))) +
>   geom_line() + geom_point() +
>   labs(x = NULL, y = "Ventes mensuelles (milliers de $ CA)", colour = "Année") +
>   theme_minimal(base_size = 12) +
>   theme(axis.text.x = element_text(angle = 45, hjust = 1))
> ```
>
> ![](exercices_files/figure-html/solution-08-1-2.png)
>
> ``` r
> # Décomposition descriptive estimée sur l’apprentissage seulement.
> decomposition_commerce <- decompose(serie, type = "additive")
> tibble(mois = 1:12,
>        ecart_saisonnier_dollars = as.numeric(decomposition_commerce$figure))
> ```
>
>     # A tibble: 12 × 2
>         mois ecart_saisonnier_dollars
>        <int>                    <dbl>
>      1     1                   10863.
>      2     2                  -10710.
>      3     3                   -9124.
>      4     4                   -2264.
>      5     5                  -17965.
>      6     6                  -18035.
>      7     7                    2561.
>      8     8                   11895.
>      9     9                  -23506.
>     10    10                    5308.
>     11    11                   29355.
>     12    12                   21622.
>
> L’écart estimé d’un mois est exprimé en dollars par rapport à la tendance estimée dans cette décomposition. Il n’est pas une preuve d’effet causal du calendrier ou d’une promotion. La tendance centrée ne peut pas être estimée aux extrémités sans observations supplémentaires, et la décomposition ne produit pas à elle seule une prévision.
>
> La série progresse et présente des fluctuations commerciales. Les profils mensuels comparent les années, mais les promotions ne surviennent pas nécessairement aux mêmes dates. Une association graphique ne suffit pas à démontrer un effet causal. Le modèle principal de calendrier ne prétend pas isoler celui du prix ou des promotions.

## Exercice 2 - Un calendrier, trois structures

Vérifiez l’indice de temps et le facteur mois, avec janvier comme référence. Ajustez tendance seule, saison seule et tendance avec mois. Interprétez la pente et décembre dans le modèle combiné. Comparez la précision du contraste décembre-janvier au cas guidé, sans conclure qu’une valeur p non faible prouve une absence de saisonnalité.

> **TIP:**
>
> ``` r
> # La cible, le calendrier et la séparation sont vérifiés avant l’ajustement.
> apprentissage |> select(date, indice_temps, mois) |> slice(c(1, 2, 12, 13, 60))
> ```
>
>     # A tibble: 5 × 3
>       date       indice_temps mois    
>       <date>            <int> <fct>   
>     1 2020-01-01            1 janvier 
>     2 2020-02-01            2 février 
>     3 2020-12-01           12 décembre
>     4 2021-01-01           13 janvier 
>     5 2024-12-01           60 décembre
>
> ``` r
> modele_tendance <- lm(ventes ~ indice_temps, data = apprentissage)
> modele_saison <- lm(ventes ~ mois, data = apprentissage,
>                     contrasts = list(mois = "contr.treatment"))
> modele_calendrier <- lm(ventes ~ indice_temps + mois, data = apprentissage,
>                         contrasts = list(mois = "contr.treatment"))
> modeles <- list(Tendance = modele_tendance, Saison = modele_saison,
>                 Calendrier = modele_calendrier)
> model.matrix(modele_calendrier)[c(1, 2, 12), c(1, 2, 3, 13)]
> ```
>
>        (Intercept) indice_temps moisfévrier moisdécembre
>     1            1            1           0            0
>     2            1            2           1            0
>     12           1           12           0            1
>
> ``` r
> tidy(modele_calendrier, conf.int = TRUE) |>
>   filter(term %in% c("indice_temps", "moisdécembre"))
> ```
>
>     # A tibble: 2 × 7
>       term         estimate std.error statistic  p.value conf.low conf.high
>       <chr>           <dbl>     <dbl>     <dbl>    <dbl>    <dbl>     <dbl>
>     1 indice_temps    3540.      251.    14.1   1.71e-18    3034.     4045.
>     2 moisdécembre   13191.    21067.     0.626 5.34e- 1  -29190.    55572.
>
> La pente vaut environ 3 540 \$ par mois. Le contraste décembre-janvier vaut environ 13 191 \$, avec une erreur-type d’environ 21 067 \$. Il est moins précis que dans le cas guidé. Ce résultat est conditionnel à la forme du modèle; il ne prouve ni causalité du calendrier ni absence de motif saisonnier. La catégorie de référence donne un point de comparaison, sans désigner un meilleur mois.

## Exercice 3 - Ce que les résidus révèlent et imposent

Examinez les résidus du modèle combiné dans le temps et selon les valeurs ajustées. Comparez les résidus moyens par mois des trois modèles. Pourquoi leur moyenne mensuelle presque nulle dans les modèles avec mois ne suffit-elle pas? Nommez une information que le modèle principal laisse de côté.

> **TIP:**
>
> ``` r
> diagnostic <- apprentissage |>
>   mutate(ajuste = fitted(modele_calendrier), residu = residuals(modele_calendrier))
> ggplot(diagnostic, aes(date, residu / 1000)) +
>   geom_hline(yintercept = 0, colour = "grey60") + geom_line() +
>   labs(x = NULL, y = "Résidu (milliers de $ CA)") + theme_minimal(base_size = 12)
> ```
>
> ![](exercices_files/figure-html/solution-08-3-1.png)
>
> ``` r
> ggplot(diagnostic, aes(ajuste / 1000, residu / 1000)) +
>   geom_hline(yintercept = 0, colour = "grey60") + geom_point() +
>   labs(x = "Valeur ajustée (milliers de $ CA)", y = "Résidu (milliers de $ CA)") +
>   theme_minimal(base_size = 12)
> ```
>
> ![](exercices_files/figure-html/solution-08-3-2.png)
>
> ``` r
> # Comparer ce qui reste par mois avec et sans terme de calendrier.
> residus_mensuels <- imap_dfr(modeles, function(modele, nom) {
>   tibble(mois = apprentissage$mois, residu = residuals(modele), methode = nom)
> }) |>
>   group_by(methode, mois) |> summarise(residu_moyen = mean(residu), .groups = "drop")
> residus_mensuels |>
>   ggplot(aes(mois, residu_moyen / 1000, colour = methode, group = methode)) +
>   geom_hline(yintercept = 0, colour = "grey60") + geom_line() + geom_point() +
>   labs(x = NULL, y = "Résidu mensuel moyen (milliers de $ CA)", colour = "Méthode") +
>   theme_minimal(base_size = 12) +
>   theme(axis.text.x = element_text(angle = 45, hjust = 1))
> ```
>
> ![](exercices_files/figure-html/solution-08-3-3.png)
>
> La moyenne nulle par mois découle des équations des moindres carrés lorsque les indicatrices sont présentes. Il faut encore regarder la dispersion et la structure temporelle. Le modèle principal ne représente pas explicitement prix et promotion; des erreurs de même signe ou des écarts lors d’événements commerciaux motivent le travail du module 09. Un graphique ne suffit pas à vérifier l’indépendance.

## Exercice 4 - Comparer avec les mêmes informations

Prévoyez les douze mois de 2025 à une origine fixe. Comparez les quatre candidats avec ME, MAE et RMSE en dollars. Lisez ensuite les erreurs du modèle calendrier séparément pour les mois avec et sans promotion. Pourquoi cette lecture rétrospective n’est-elle pas une utilisation des promotions futures pour prévoir?

> **TIP:**
>
> ``` r
> previsions <- imap_dfr(modeles, function(modele, nom) {
>   tibble(date = futur$date, observe = validation$ventes, methode = nom,
>          prevision = as.numeric(predict(modele, newdata = futur)))
> }) |>
>   bind_rows(tibble(date = futur$date, observe = validation$ventes,
>                    methode = "Saisonnier_naif", prevision = tail(apprentissage$ventes, 12)))
> scores <- previsions |> group_by(methode) |>
>   group_modify(~ mesures08(.x$observe, .x$prevision)) |> ungroup() |> arrange(MAE)
> scores
> ```
>
>     # A tibble: 4 × 4
>       methode              ME     MAE    RMSE
>       <chr>             <dbl>   <dbl>   <dbl>
>     1 Calendrier       -6385.  32389.  34721.
>     2 Tendance        -10345.  36415.  37728.
>     3 Saisonnier_naif  37264.  54348.  63258.
>     4 Saison          121042. 121042. 125762.
>
> ``` r
> ggplot() +
>   geom_line(data = validation, aes(date, ventes / 1000), linewidth = 1) +
>   geom_line(data = previsions, aes(date, prevision / 1000, colour = methode)) +
>   labs(x = NULL, y = "Ventes mensuelles (milliers de $ CA)", colour = "Méthode") +
>   theme_minimal(base_size = 12)
> ```
>
> ![](exercices_files/figure-html/solution-08-4-1.png)
>
> ``` r
> previsions |> left_join(validation |> select(date, promotion), by = "date") |>
>   filter(methode == "Calendrier") |>
>   group_by(promotion) |>
>   summarise(mois = n(), MAE = mean(abs(observe - prevision)), .groups = "drop")
> ```
>
>     # A tibble: 2 × 3
>       promotion  mois    MAE
>       <chr>     <int>  <dbl>
>     1 non           8 29081.
>     2 oui           4 39006.
>
> Le modèle combiné a ici la plus faible MAE des quatre candidats: environ 32 389 \$, avec une RMSE d’environ 34 721 \$. Le naïf saisonnier a une MAE d’environ 54 348 \$. Les erreurs sont nettement plus élevées que dans le cas guidé, même si la famille gagnante est la même. Le regroupement par promotion intervient après l’émission des prévisions et ne change pas leurs prédicteurs. Les groupes de huit et quatre mois sont descriptifs et trop petits pour conclure à une stabilité générale.

## Exercice 5 - Communiquer une recommandation adaptée

Produisez les intervalles classiques du modèle calendrier, puis rédigez une note à la direction: deux scores, contraste mensuel, limite des intervalles, rôle du plan commercial et règle de surveillance. Expliquez pourquoi la conclusion ne peut pas recopier celle du cas guidé.

> **TIP:**
>
> ``` r
> ip_commerce <- predict(modele_calendrier, futur, interval = "prediction", level = 0.95)
> tibble(date = futur$date, observe = validation$ventes,
>        fit = ip_commerce[, "fit"], lwr = ip_commerce[, "lwr"], upr = ip_commerce[, "upr"]) |>
>   ggplot(aes(date)) +
>   geom_ribbon(aes(ymin = lwr / 1000, ymax = upr / 1000), fill = "#BFDDE5", alpha = 0.6) +
>   geom_line(aes(y = fit / 1000), colour = "#0B4F6C") +
>   geom_point(aes(y = observe / 1000)) +
>   labs(x = NULL, y = "Ventes (milliers de $ CA)",
>        subtitle = "Intervalles classiques conditionnels au modèle, sans plan commercial futur") +
>   theme_minimal(base_size = 12)
> ```
>
> ![](exercices_files/figure-html/solution-08-5-1.png)
>
> Exemple acceptable: « Le modèle calendrier réduit la MAE de validation à environ 32 389 \$, contre 54 348 \$ pour le naïf saisonnier; sa RMSE vaut environ 34 721 \$. Le contraste décembre-janvier est d’environ 13 191 \$, mais sa précision est limitée. Le calendrier seul ne représente pas les changements commerciaux. Les intervalles supposent une structure d’erreurs qui reste à vérifier; ils ne garantissent pas le risque commercial réel. »
>
> Demander le plan disponible à l’origine avant d’ajouter des prédicteurs futurs, documenter des scénarios et réévaluer les erreurs aux nouvelles origines. Une plage de ventes ne détermine pas seule les stocks ou le personnel. L’analyse avec contexte observé, disponible plus bas, n’est pas une validation de prévision ex ante.

## Trace finale

Réunissez ces cinq réponses dans `tendance_commerce.qmd`: protocole, graphiques, trois ajustements, interprétations, diagnostics, quatre prévisions, scores et note de décision. Redémarrez R, puis faites Render. Le parcours guidé reste dans `tendance_ventes.qmd`. Les exercices facultatifs ne créent pas un troisième rapport.

## Pratique supplémentaire

Huit questions indépendantes. Tentez une réponse avant le corrigé. Elles ne demandent pas les méthodes avancées du cahier facultatif.

## Exercice 6 - Continuer l’indice

L’apprentissage va de t = 1 à 60. Une personne code 2025 avec t = 1 à 12. Que faut-il corriger?

> **TIP:**
>
> Les indices continuent de 61 à 72. Recommencer à 1 efface cinq années de tendance. Les mois reviennent à janvier: catégorie mensuelle et temps écoulé sont deux variables distinctes.

## Exercice 7 - Compter les coefficients

Combien de coefficients le modèle avec constante, pente et douze mois estime-t-il? Pourquoi pas douze indicatrices en plus de la constante?

> **TIP:**
>
> Treize: une constante, une pente et onze contrastes. Les douze indicatrices plus la constante sont linéairement dépendantes. La référence est identifiée quand les onze autres indicatrices valent zéro.

## Exercice 8 - Lire un contraste

La pente vaut 2 000 \$ par mois et le contraste décembre-janvier 30 000 \$. Que disent ces nombres?

> **TIP:**
>
> Selon le modèle, les ventes moyennes augmentent de 2 000 \$ par mois à mois égal. Décembre est modélisé 30 000 \$ au-dessus de janvier à indice de temps égal. Ce sont des relations conditionnelles, sans effet causal démontré. L’égalité de l’indice est une comparaison construite par le modèle.

## Exercice 9 - Prévoir à une seule origine

Pour prévoir les douze mois de 2025 fin 2024, peut-on employer lag(ventes, 1) calculé sur tout le fichier comme naïf pour chaque mois?

> **TIP:**
>
> Après janvier, ce code incorpore des ventes de 2025 inconnues à l’origine. Il correspond à des origines mises à jour. Le naïf à origine fixe répéterait décembre 2024; le naïf saisonnier reprend les douze mois de 2024.

## Exercice 10 - Changer la référence

Si décembre devient la référence, la MAE doit-elle changer?

> **TIP:**
>
> Avec les mêmes observations et le même modèle, les valeurs ajustées et les prévisions restent identiques à la précision numérique près. Les coefficients changent d’écriture. Choisir la référence ne choisit pas le meilleur modèle.

## Exercice 11 - Une pente significative suffit-elle?

Une pente a une valeur p très faible, mais les résidus dessinent une vague annuelle. Quelle conclusion est défendable?

> **TIP:**
>
> Le modèle contient une variation temporelle, mais laisse une structure saisonnière. La significativité de la pente ne démontre ni l’adéquation du modèle ni une bonne prévision. Comparer les modèles candidats à information et périodes communes, puis examiner les erreurs.

## Exercice 12 - Confiance ou prédiction

Pour un même modèle et un même mois, pourquoi l’intervalle de prédiction est-il plus large que l’intervalle de confiance de la moyenne?

> **TIP:**
>
> La prédiction ajoute la variabilité d’une nouvelle observation à l’incertitude de la moyenne. Le niveau, l’origine et les hypothèses doivent rester les mêmes pour cette comparaison. Un intervalle plus large n’est pas une garantie de calibration.

## Exercice 13 - Douze intervalles

Douze observations sont dans leurs intervalles ponctuels à 95 %. Est-ce une garantie à 95 % pour toute l’année? Peut-on additionner les bornes pour le total annuel?

> **TIP:**
>
> Non. Une couverture observée sur douze cibles ne prouve pas la calibration future. Les intervalles sont marginaux. Une bande simultanée ou un intervalle de total nécessite un calcul qui tient compte de la dépendance; la somme des bornes ne conserve pas automatiquement le niveau voulu.

## Exercice 14 - Prix, promotion et saison (complément accompagné)

Cet exercice conserve l’analyse commerciale de la version précédente du module. Prérequis: régression multiple et interprétation conditionnelle. Utilisez la préparation et les objets des exercices 1 à 5. Le code est fourni; ce complément n’est pas requis dans la trace principale et prépare le module 09.

Ajustez un modèle avec tendance, prix et promotion sans mois; examinez ses résidus mensuels. Ajoutez le mois et comparez les contrastes juillet et décembre. Évaluez ensuite par promotion en distinguant la prévision de calendrier et la comparaison conditionnelle aux prix et promotions observés après l’origine.

> **TIP:**
>
> ``` r
> # Complément accompagné: les valeurs futures observées servent ici à une
> # comparaison rétrospective conditionnelle, pas à une prévision réalisable ex ante.
> apprentissage <- apprentissage |>
>   mutate(promotion = factor(promotion, levels = c("non", "oui")))
> validation <- validation |>
>   mutate(promotion = factor(promotion, levels = c("non", "oui")))
> modele_contexte_sans_mois <- lm(ventes ~ indice_temps + promotion + prix_moyen,
>                                data = apprentissage)
> modele_contexte <- lm(ventes ~ indice_temps + mois + promotion + prix_moyen,
>                       data = apprentissage, contrasts = list(mois = "contr.treatment"))
> augment(modele_contexte_sans_mois, data = apprentissage) |>
>   group_by(mois) |> summarise(residu_moyen = mean(.resid), .groups = "drop") |>
>   ggplot(aes(mois, residu_moyen, group = 1)) +
>   geom_hline(yintercept = 0, colour = "grey60") + geom_line() + geom_point() +
>   labs(x = NULL, y = "Résidu moyen ($ CA)") + theme_minimal(base_size = 12) +
>   theme(axis.text.x = element_text(angle = 45, hjust = 1))
> ```
>
> ![](exercices_files/figure-html/contexte-08-1.png)
>
> ``` r
> bind_rows(tidy(modele_calendrier) |> mutate(modele = "Calendrier"),
>           tidy(modele_contexte) |> mutate(modele = "Calendrier et contexte")) |>
>   filter(term %in% c("moisjuillet", "moisdécembre")) |>
>   select(modele, term, estimate, std.error)
> ```
>
>     # A tibble: 4 × 4
>       modele                 term         estimate std.error
>       <chr>                  <chr>           <dbl>     <dbl>
>     1 Calendrier             moisjuillet    -3408.    20939.
>     2 Calendrier             moisdécembre   13191.    21067.
>     3 Calendrier et contexte moisjuillet    -6680.     6103.
>     4 Calendrier et contexte moisdécembre   22263.     6360.
>
> ``` r
> comparaison_conditionnelle <- bind_rows(
>   validation |> transmute(date, promotion, observe = ventes,
>     prevision = as.numeric(predict(modele_calendrier, futur)), modele = "Calendrier"),
>   validation |> transmute(date, promotion, observe = ventes,
>     prevision = as.numeric(predict(modele_contexte, validation)), modele = "Contexte observé")
> )
> comparaison_conditionnelle |> group_by(modele, promotion) |>
>   summarise(mois = n(), MAE = mean(abs(observe - prevision)),
>             ME = mean(observe - prevision), .groups = "drop")
> ```
>
>     # A tibble: 4 × 5
>       modele           promotion  mois    MAE      ME
>       <chr>            <fct>     <int>  <dbl>   <dbl>
>     1 Calendrier       non           8 29081. -29081.
>     2 Calendrier       oui           4 39006.  39006.
>     3 Contexte observé non           8  3781.  -1136.
>     4 Contexte observé oui           4  6414.   3799.
>
> Le contraste décembre-janvier passe d’environ 13 191 \$ à 22 263 \$ après ajout du contexte, sans preuve causale. Le modèle avec contexte observé a une MAE d’environ 3 781 \$ sur huit mois sans promotion et 6 414 \$ sur quatre mois avec promotion. Ces scores utilisent les valeurs commerciales effectivement observées en 2025: ils ne prouvent pas la performance d’une prévision qui aurait dû les connaître fin 2024. Ils ne valident pas non plus l’indépendance des erreurs. Le module 09 traite ces deux limites.

## Exercice 15 - Scénario disponible à l’origine (facultatif)

Après l’exercice 14, gardez le dernier prix d’apprentissage et comparez deux plans hypothétiques: aucune promotion ou promotion chaque mois. Pourquoi ne faut-il pas lire leurs prévisions comme une reconstitution validée du contexte réalisé?

> **TIP:**
>
> ``` r
> # Scénario hypothétique déclaré, sans utilisation des prix observés de 2025.
> # Le dernier prix d’apprentissage est répété. Deux plans de promotion sont comparés.
> scenarios <- bind_rows(
>   futur |> mutate(promotion = factor("non", levels = c("non", "oui")),
>                    prix_moyen = tail(apprentissage$prix_moyen, 1), plan = "Sans promotion"),
>   futur |> mutate(promotion = factor("oui", levels = c("non", "oui")),
>                    prix_moyen = tail(apprentissage$prix_moyen, 1), plan = "Avec promotion")
> )
> scenarios$prevision <- as.numeric(predict(modele_contexte, newdata = scenarios))
> scenarios |> select(date, plan, prix_moyen, prevision) |> slice(c(1, 13))
> ```
>
>     # A tibble: 2 × 4
>       date       plan           prix_moyen prevision
>       <date>     <chr>               <dbl>     <dbl>
>     1 2025-01-01 Sans promotion       61.2   526281.
>     2 2025-01-01 Avec promotion       61.2   572258.
>
> La différence reflète le coefficient promotion conditionnel au prix et au calendrier; elle n’est pas un effet causal démontré. Ces plans sont hypothétiques, sans prétendre avoir été décidés historiquement. L’incertitude d’un prix ou d’un plan inconnu ne figure pas automatiquement dans les intervalles conditionnels usuels.
