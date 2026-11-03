# Exercices - Module 09

Le transfert concerne quatre succursales fictives. Il demande une décision opérationnelle sur la capacité et le contrôle de fuites, différente du scénario promotion/prix du cas guidé. Ouvrez le projet de transfert, essayez chaque exercice, puis ouvrez son corrigé. Les trois derniers exercices sont des pratiques supplémentaires.

## Préparation

``` r
library(tidyverse)
racines <- c(".", "modules/semaine-09-variables-externes-autocorrelation")
racine <- racines[file.exists(file.path(racines, "data/cas_integrateur_quebec.csv"))][1]
stopifnot(!is.na(racine))
service <- read_csv(file.path(racine, "data/cas_integrateur_quebec.csv"), show_col_types = FALSE) |>
  mutate(date = as.Date(date), succursale = factor(succursale),
         promotion = factor(promotion, levels = c("non", "oui"))) |>
  arrange(succursale, date) |>
  group_by(succursale) |>
  mutate(ventes_retard_1 = lag(ventes)) |>
  ungroup()
stopifnot(nrow(service) == 288, !anyDuplicated(service[c("succursale", "date")]))
entrainement_service <- service |> filter(date < as.Date("2025-01-01"))
```

## Exercice 1 - Auditer la disponibilité

Une équipe souhaite prévoir les ventes du mois suivant avec promotion, capacité, achalandage, ruptures, temps d’attente, satisfaction et ventes du mois courant. Classez-les selon leur disponibilité à l’origine. Proposez une solution pour une variable indisponible.

> **TIP:**
>
> Une promotion approuvée et une capacité annoncée peuvent être connues, sous réserve du calendrier réel. Les ventes du mois courant ne sont utilisables que si elles sont effectivement disponibles à l’origine. L’achalandage, les ruptures, l’attente et la satisfaction du mois cible sont observés après coup : leur utilisation telle quelle créerait une fuite. On peut prévoir ou scénariser une variable, puis nommer l’incertitude, ou la retirer.

## Exercice 2 - Diagnostiquer par succursale

Ajustez un modèle simple sur 2020 à 2024, puis calculez l’autocorrélation de rang 1 des résidus séparément par succursale. Pourquoi ne pas joindre la fin d’une succursale au début de la suivante?

> **TIP:**
>
> ``` r
> modele_base <- lm(ventes ~ indice_temps + promotion + succursale, data = entrainement_service)
> diagnostic <- entrainement_service |>
>   mutate(residu = residuals(modele_base)) |>
>   arrange(succursale, date) |>
>   group_by(succursale) |>
>   summarise(autocorrelation_rang_1 = cor(residu, lag(residu), use = "complete.obs"), .groups = "drop")
> diagnostic
> ```
>
>     # A tibble: 4 × 2
>       succursale autocorrelation_rang_1
>       <fct>                       <dbl>
>     1 Gatineau                 -0.00914
>     2 Montréal                  0.0853
>     3 Québec                    0.119
>     4 Sherbrooke               -0.185
>
> Les retards sont calculés après tri dans chaque groupe. Une moyenne de résidus proche de zéro ne suffit pas : des signes semblables peuvent se suivre. Les frontières entre succursales ne sont pas des mois consécutifs d’une même série.

## Exercice 3 - Comparer des scénarios

Depuis la fin de 2025, construisez deux scénarios pour janvier 2026 à Québec : capacité stable ou augmentée de 5 %, promotion non et dernières ventes connues. Utilisez le même modèle et interprétez la différence sans conclure à un effet causal.

> **TIP:**
>
> ``` r
> # Un mois à partir de fin 2025 : le dernier mois et son chiffre de ventes sont disponibles.
> modele_scenario <- lm(ventes ~ indice_temps + promotion + capacite + ventes_retard_1,
>                       data = service |> filter(!is.na(ventes_retard_1)))
> profil <- service |> filter(succursale == "Québec") |> slice_max(date, n = 1, with_ties = FALSE) |>
>   transmute(indice_temps = indice_temps + 1, promotion = factor("non", levels = levels(service$promotion)),
>             capacite, ventes_retard_1 = ventes)
> scenarios <- bind_rows(profil |> mutate(scenario = "Capacité inchangée"),
>                        profil |> mutate(capacite = capacite * 1.05, scenario = "Capacité augmentée de 5 %")) |>
>   mutate(prevision = as.numeric(predict(modele_scenario, newdata = pick(everything()))))
> scenarios
> ```
>
>     # A tibble: 2 × 6
>       indice_temps promotion capacite ventes_retard_1 scenario             prevision
>              <dbl> <fct>        <dbl>           <dbl> <chr>                    <dbl>
>     1           73 non           2400          230891 Capacité inchangée     196781.
>     2           73 non           2520          230891 Capacité augmentée …   205502.
>
> La capacité varie entre succursales dans ces données, mais ne varie pas dans le temps à l’intérieur de chacune; sa pente peut refléter des différences entre succursales. Une hausse hypothétique pour Québec peut extrapoler et n’est pas une estimation causale. La formule de capacité est une hypothèse, pas un plan vérifié.

## Exercice 4 - Formuler une recommandation

Rédigez une recommandation distinguant fuite d’information, diagnostic par succursale et scénario. Nommez un risque d’extrapolation.

> **TIP:**
>
> Retirer les variables du mois cible connues après coup, ou utiliser une prévision distincte explicitement incertaine. Examiner les résidus dans chaque succursale et au fil du temps. Présenter la hausse de capacité comme un scénario conditionnel et vérifier si la valeur envisagée se situe dans la plage des données et convient à Québec.

## Exercice 5 - Retard et horizon

À la fin de décembre, les ventes de décembre sont connues. Peut-on les utiliser pour prévoir janvier et février?

> **TIP:**
>
> Pour janvier, oui si la mesure de décembre est disponible à l’origine. Pour février, le retard d’un mois serait la vente de janvier, encore inconnue à la fin de décembre; il faut la prévoir, utiliser un autre retard disponible ou mettre à jour la prévision après janvier.

## Exercice 6 - Interpréter une p-valeur

Le test de Ljung-Box donne une valeur p de 0,30. Peut-on affirmer que les résidus sont indépendants?

> **TIP:**
>
> Non. Le test ne fournit pas assez d’évidence contre l’absence d’autocorrélations examinées, mais une p-valeur élevée ne démontre ni l’indépendance ni l’absence de structure. Examiner aussi le graphique et la taille de l’échantillon.

## Exercice 7 - Événement spécial

Une panne exceptionnelle réduit les ventes une fois. Faut-il supprimer le mois?

> **TIP:**
>
> Vérifier d’abord si la donnée est erronée et documenter la cause. Selon la question, comparer une analyse avec et sans ce mois ou ajouter un indicateur d’événement; ne pas le supprimer automatiquement. Une prévision future requiert aussi un scénario sur la présence de l’événement.
