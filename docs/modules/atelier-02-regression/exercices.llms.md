# Exercices complémentaires - Laboratoire 02

## Une pratique facultative

La [mission du laboratoire](../../modules/atelier-02-regression/guide-atelier.llms.md) se fait dans un seul rapport. Ces exercices servent à reprendre un geste après la mission ou à pratiquer davantage. Ils utilisent le trafic numérique de campagnes fictives plutôt que les ventes des succursales.

Jeu de données de transfert : [campagnes_marketing_quebec.csv](../semaine-03-regression-lineaire/data/campagnes_marketing_quebec.csv).

Essayez chaque exercice avant d’ouvrir sa proposition de solution. Les solutions s’exécutent dans l’ordre; plusieurs choix de variante et plusieurs conclusions peuvent être défendables.

## 1. Question et données

Comment le budget marketing est-il associé aux visites du site? Identifiez la réponse, l’explicative, leurs unités et l’unité d’observation. Vérifiez les données avant l’ajustement.

> **TIP:**
>
> ``` r
> library(tidyverse)
>
> campagnes <- read_csv("data/campagnes_marketing_quebec.csv", show_col_types = FALSE) |>
>   mutate(mois = as.Date(mois), budget_milliers = budget_marketing / 1000)
> glimpse(campagnes)
> ```
>
>     Rows: 60
>     Columns: 11
>     $ mois             <date> 2025-01-01, 2025-01-01, 2025-01-01, 2025-01-01, 2025…
>     $ mois_label       <chr> "janvier", "janvier", "janvier", "janvier", "janvier"…
>     $ region           <chr> "Capitale-Nationale", "Estrie", "Mauricie", "Montréal…
>     $ canal            <chr> "Infolettre", "Infolettre", "Recherche", "Réseaux soc…
>     $ saison           <chr> "moyenne", "moyenne", "moyenne", "moyenne", "moyenne"…
>     $ budget_marketing <dbl> 5814, 3775, 5497, 6215, 5703, 3246, 4927, 2497, 6515,…
>     $ visites_site     <dbl> 6393, 5235, 6880, 8106, 7107, 4958, 6154, 4117, 7606,…
>     $ rabais           <dbl> 0.00, 0.15, 0.13, 0.17, 0.17, 0.13, 0.15, 0.08, 0.17,…
>     $ ventes           <dbl> 121915, 93518, 95109, 121125, 108469, 82306, 95280, 5…
>     $ satisfaction     <dbl> 7.7, 7.4, 7.5, 7.7, 7.7, 7.1, 7.3, 7.2, 8.5, 7.2, 8.3…
>     $ budget_milliers  <dbl> 5.814, 3.775, 5.497, 6.215, 5.703, 3.246, 4.927, 2.49…
>
> ``` r
> campagnes |> count(region, mois) |> filter(n > 1)
> ```
>
>     # A tibble: 0 × 3
>     # ℹ 3 variables: region <chr>, mois <date>, n <int>
>
> ``` r
> campagnes |> summarise(n = n(), debut = min(mois), fin = max(mois),
>                         budget_min = min(budget_marketing), budget_max = max(budget_marketing))
> ```
>
>     # A tibble: 1 × 5
>           n debut      fin        budget_min budget_max
>       <int> <date>     <date>          <dbl>      <dbl>
>     1    60 2025-01-01 2025-12-01       2497       8857
>
> ``` r
> sum(is.na(campagnes))
> ```
>
>     [1] 0
>
> ``` r
> stopifnot(all(complete.cases(campagnes[c("visites_site", "budget_milliers")])) )
> ```
>
> La réponse est le nombre mensuel de visites du site. L’explicative est le budget mensuel, exprimé ici en milliers de dollars. Une ligne correspond à un mois dans une région; le canal est une caractéristique de la campagne. Les régions sont observées à plusieurs mois. L’analyse décrit une association et ne prouve pas un effet d’une dépense décidée par la direction.

## 2. Explorer et lire une droite

Tracez le nuage des visites selon le budget, en distinguant les canaux. Ajustez une droite commune et interprétez la pente pour 1 000 \$ supplémentaires. Expliquez la portée de l’intercept.

> **TIP:**
>
> ``` r
> ggplot(campagnes, aes(budget_milliers, visites_site)) +
>   geom_point(aes(colour = canal)) +
>   geom_smooth(method = "lm", se = FALSE, colour = "#0B4F6C") +
>   labs(x = "Budget mensuel (milliers de dollars)", y = "Visites mensuelles du site",
>        colour = "Canal") +
>   theme_minimal()
> ```
>
> ![](exercices_files/figure-html/droite-exercices-labo02-1.png)
>
> ``` r
> reference <- lm(visites_site ~ budget_milliers, data = campagnes)
> coef(reference)
> ```
>
>         (Intercept) budget_milliers
>           1711.8329        869.0126
>
> ``` r
> summary(reference)$r.squared
> ```
>
>     [1] 0.8429617
>
> La pente vaut 869 visites par tranche de 1 000 \$. Elle décrit une variation moyenne estimée des visites, sans isoler l’effet causal du budget. L’intercept représente les visites estimées pour un budget nul; zéro est hors de la plage observée et son interprétation pratique est limitée.

## 3. Comparer une variante

Choisissez une quadratique ou un logarithme du budget. Gardez les visites comme réponse et les mêmes lignes. Comparez le R² ajusté et la RMSE d’ajustement; expliquez pourquoi cela ne suffit pas à établir une meilleure performance future.

> **TIP:**
>
> Le logarithme permet ici d’examiner une association dont l’intensité varie avec le niveau du budget. Il s’agit d’une variante à examiner, pas d’une forme à retenir d’avance.
>
> ``` r
> stopifnot(all(campagnes$budget_milliers > 0))
> variante <- lm(visites_site ~ log(budget_milliers), data = campagnes)
>
> tibble(
>   modele = c("Droite", "Logarithme"),
>   n = c(nobs(reference), nobs(variante)),
>   r2_ajuste = c(summary(reference)$adj.r.squared, summary(variante)$adj.r.squared),
>   rmse_ajustement_visites = c(sqrt(mean(residuals(reference)^2)),
>                             sqrt(mean(residuals(variante)^2)))) |>
>   knitr::kable(digits = c(0, 0, 3, 1))
> ```
>
> | modele     |   n | r2_ajuste | rmse_ajustement_visites |
> |:-----------|----:|----------:|------------------------:|
> | Droite     |  60 |     0.840 |                   490.3 |
> | Logarithme |  60 |     0.809 |                   536.0 |
>
> La RMSE est en visites pour les deux modèles. Une diminution décrit une meilleure concordance sur ces observations. Elle ne remplace pas une validation sur des données mises de côté. Le modèle retenu doit aussi rester interprétable et compatible avec les diagnostics.

## 4. Interpréter la courbe et les résidus

Comparez les prédictions de la variante pour deux budgets dans la plage observée. Examinez ses résidus en distinguant les canaux. Expliquez une limite concrète pour l’utilisation du modèle.

> **TIP:**
>
> ``` r
> budgets <- tibble(budget_milliers = as.numeric(
>   quantile(campagnes$budget_milliers, c(0.25, 0.75))))
> budgets <- budgets |> mutate(visites_estimees = predict(variante, newdata = budgets))
> budgets
> ```
>
>     # A tibble: 2 × 2
>       budget_milliers visites_estimees
>                 <dbl>            <dbl>
>     1            4.65            5872.
>     2            6.27            7210.
>
> ``` r
> diff(budgets$visites_estimees)
> ```
>
>            2
>     1337.512
>
> Cette différence compare les moyennes estimées aux deux budgets indiqués. Le coefficient du logarithme n’est pas une variation constante par dollar.
>
> ``` r
> diagnostic <- campagnes |> mutate(ajustement = fitted(variante), residu = residuals(variante))
> ggplot(diagnostic, aes(ajustement, residu, colour = canal)) +
>   geom_hline(yintercept = 0, linetype = "dashed") +
>   geom_point() +
>   labs(x = "Visites ajustées", y = "Résidu (visites)", colour = "Canal") +
>   theme_minimal()
> ```
>
> ![](exercices_files/figure-html/diagnostic-exercices-labo02-1.png)
>
> Des différences entre canaux peuvent appeler une vérification du contexte. Les mois répétés d’une même région limitent aussi l’hypothèse d’indépendance. N’inventez pas un motif : décrivez celui que votre graphique montre et reliez-le à une vérification précise.

## 5. Conclure

Rédigez au plus huit lignes : question, modèle retenu, deux résultats chiffrés, diagnostic, limite et prochaine vérification.

> **TIP:**
>
> La conclusion doit préciser la variante effectivement essayée et peut retenir la droite. Citez les valeurs de votre comparaison et une interprétation en visites. Une nouvelle période de campagnes ou un examen des écarts entre canaux peut être proposé comme prochaine vérification. Une augmentation automatique du budget n’est pas démontrée par ces associations.
