# Aide R - Laboratoire 02

Retrouver un geste après une première tentative

## Utiliser cette aide

La [mission](../../modules/atelier-02-regression/guide-atelier.llms.md) reste votre fil principal. Ouvrez seulement la rubrique qui répond à votre difficulté. Les exemples reprennent le jeu de saturation du module 4; adaptez les variables et les objets à votre propre analyse des succursales.

Les blocs ci-dessous s’exécutent dans l’ordre pour reproduire cet exemple. Pour l’utiliser dans un projet indépendant, placez le [CSV du module 4](../semaine-04-regression-nonlineaire/data/achalandage_saturation_quebec.csv) dans `data/` et le `.qmd` à la racine.

## Ajouter un bloc dans le rapport

Dans RStudio, le bouton d’insertion de bloc permet d’ajouter du code R à une section. Le code reste dans les blocs; la justification et l’interprétation s’écrivent dans le texte. Donnez des noms distincts aux modèles pour conserver les deux ajustements.

## Importer et contrôler

> **TIP:**
>
> ``` r
> library(tidyverse)
>
> saturation <- read_csv("data/achalandage_saturation_quebec.csv",
>                        show_col_types = FALSE) |>
>   mutate(mois = as.Date(mois),
>          achalandage_milliers = achalandage / 1000)
>
> saturation |>
>   summarise(observations = n(),
>             succursales = n_distinct(succursale),
>             debut = min(mois), fin = max(mois),
>             visites_min = min(achalandage),
>             visites_max = max(achalandage))
> ```
>
>     # A tibble: 1 × 6
>       observations succursales debut      fin        visites_min visites_max
>              <int>       <int> <date>     <date>           <dbl>       <dbl>
>     1           72           6 2025-01-01 2025-12-01        1151        4166
>
> ``` r
> sum(is.na(saturation))
> ```
>
>     [1] 0
>
> ``` r
> saturation |> count(succursale, mois) |> filter(n > 1)
> ```
>
>     # A tibble: 0 × 3
>     # ℹ 3 variables: succursale <chr>, mois <date>, n <int>
>
> ``` r
> # Un seul tableau complet pour tous les modèles de cet exemple.
> stopifnot(all(complete.cases(saturation[c("ventes", "achalandage_milliers")])))
> ```
>
> Vérifiez les colonnes effectivement utilisées. Si un contrôle échoue, examinez la cause avant de filtrer ou de modéliser.

## Construire la référence et une variante

> **TIP:**
>
> ``` r
> modele_reference <- lm(ventes ~ achalandage_milliers, data = saturation)
> modele_variante <- lm(
>   ventes ~ achalandage_milliers + I(achalandage_milliers^2),
>   data = saturation
> )
>
> coef(modele_reference)
> ```
>
>              (Intercept) achalandage_milliers
>                104578.87             25010.99
>
> ``` r
> summary(modele_reference)$r.squared
> ```
>
>     [1] 0.7702993
>
> ``` r
> # La variable est en milliers de visites : 100 visites représentent 0,1 unité.
> unname(coef(modele_reference)["achalandage_milliers"] * 0.1)
> ```
>
>     [1] 2501.099
>
> Pour essayer l’autre famille à la place de la quadratique :
>
> ``` r
> stopifnot(all(saturation$achalandage_milliers > 0))
> modele_variante <- lm(ventes ~ log(achalandage_milliers), data = saturation)
> ```
>
> Choisissez la forme pour une raison explicite. Les deux coefficients de la droite s’interprètent ensemble; ceux de la quadratique ne définissent pas une pente constante.

## Comparer des ajustements

> **TIP:**
>
> ``` r
> comparaison <- tibble(
>   modele = c("Droite", "Variante"),
>   observations = c(nobs(modele_reference), nobs(modele_variante)),
>   r2_ajuste = c(summary(modele_reference)$adj.r.squared,
>                 summary(modele_variante)$adj.r.squared),
>   rmse_ajustement_dollars = c(
>     sqrt(mean(residuals(modele_reference)^2)),
>     sqrt(mean(residuals(modele_variante)^2))
>   )
> )
> knitr::kable(comparaison, digits = c(0, 0, 3, 0),
>              col.names = c("Modèle", "Observations", "R² ajusté", "RMSE d'ajustement ($)"))
> ```
>
> | Modèle   | Observations | R² ajusté | RMSE d’ajustement (\$) |
> |:---------|-------------:|----------:|-----------------------:|
> | Droite   |           72 |     0.767 |                   8976 |
> | Variante |           72 |     0.828 |                   7647 |
>
> L’erreur est calculée sur les données d’ajustement. Cet exemple n’effectue pas de validation sur des observations mises de côté. Vérifiez aussi l’identité des lignes : deux effectifs égaux ne suffisent pas si les lignes utilisées diffèrent.

## Superposer les courbes et interpréter une différence

> **TIP:**
>
> ``` r
> plage <- range(saturation$achalandage_milliers)
> grille <- tibble(achalandage_milliers = seq(plage[1], plage[2], length.out = 100))
> courbes <- grille |>
>   mutate(Droite = predict(modele_reference, newdata = grille),
>          Variante = predict(modele_variante, newdata = grille)) |>
>   pivot_longer(c(Droite, Variante), names_to = "modele", values_to = "ventes_estimees")
>
> ggplot(saturation, aes(achalandage_milliers, ventes)) +
>   geom_point(aes(colour = succursale), alpha = 0.7) +
>   geom_line(data = courbes,
>             aes(y = ventes_estimees, linetype = modele), linewidth = 0.9) +
>   labs(x = "Achalandage mensuel (milliers de visites)", y = "Ventes mensuelles ($)",
>        colour = "Succursale", linetype = "Modèle") +
>   theme_minimal()
> ```
>
> ![](demonstrations_files/figure-html/courbes-aide-labo02-1.png)
>
> ``` r
> # Deux niveaux choisis dans la plage pour illustrer la variation estimée.
> scenarios <- tibble(achalandage_milliers = as.numeric(
>   quantile(saturation$achalandage_milliers, probs = c(0.25, 0.75))))
> scenarios <- scenarios |>
>   mutate(ventes_estimees = predict(modele_variante, newdata = scenarios))
> scenarios
> ```
>
>     # A tibble: 2 × 2
>       achalandage_milliers ventes_estimees
>                      <dbl>           <dbl>
>     1                 1.77         147650.
>     2                 2.51         172414.
>
> ``` r
> diff(scenarios$ventes_estimees)
> ```
>
>            2
>     24763.78
>
> Nommez les deux niveaux et les unités dans votre phrase. Cette différence est celle des moyennes estimées par le modèle à ces points; elle n’est ni une pente constante, ni un effet causal.

## Examiner les résidus

> **TIP:**
>
> ``` r
> # Ici la variante illustre le geste; utilisez le modèle que vous avez retenu.
> diagnostic <- saturation |>
>   mutate(valeur_ajustee = fitted(modele_variante),
>          residu = residuals(modele_variante))
>
> ggplot(diagnostic, aes(valeur_ajustee, residu, colour = succursale)) +
>   geom_hline(yintercept = 0, linetype = "dashed") +
>   geom_point(alpha = 0.8) +
>   labs(x = "Ventes ajustées ($)", y = "Résidu ($)", colour = "Succursale") +
>   theme_minimal()
> ```
>
> ![](demonstrations_files/figure-html/residus-aide-labo02-1.png)
>
> Décrivez ce que vous voyez effectivement : courbure, dispersion, groupes ou points à examiner. Ce seul graphique ne permet pas de vérifier l’indépendance entre mois ni de garantir la performance future.

## Revenir à votre analyse

La [mission](../../modules/atelier-02-regression/guide-atelier.llms.md) demande vos choix, vos résultats et votre conclusion. Consultez les [repères](../../modules/atelier-02-regression/capsules.llms.md) pour vérifier une interprétation et les [lectures](../../modules/atelier-02-regression/lectures.llms.md) pour la documentation officielle.
