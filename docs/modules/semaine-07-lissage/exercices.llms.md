# Exercices - Module 07

## Préparation

``` r
library(tidyverse)
library(slider)
library(forecast)

data_path <- if (file.exists("data/demande_hebdomadaire_quebec.csv")) {
  "data/demande_hebdomadaire_quebec.csv"
} else {
  "modules/semaine-07-lissage/data/demande_hebdomadaire_quebec.csv"
}

demande <- read_csv(data_path, show_col_types = FALSE) |>
  mutate(semaine = as.Date(semaine)) |>
  arrange(semaine)
```

## Exercice 1 - Fenêtres de lissage

Calculez des moyennes mobiles arrière de 4 et 12 semaines. Comparez leur réactivité sur un même graphique.

> **TIP:**
>
> ``` r
> demande |>
>   mutate(
>     mm4 = slide_dbl(demande, mean, .before = 3, .complete = TRUE),
>     mm12 = slide_dbl(demande, mean, .before = 11, .complete = TRUE)
>   ) |>
>   select(semaine, demande, mm4, mm12) |>
>   pivot_longer(-semaine, names_to = "serie", values_to = "valeur") |>
>   ggplot(aes(semaine, valeur, colour = serie)) +
>   geom_line() +
>   theme_minimal(base_size = 12)
> ```
>
> ![](exercices_files/figure-html/unnamed-chunk-2-1.png)
>
> La fenêtre de 4 semaines réagit plus rapidement; celle de 12 semaines est plus stable et plus retardée.

## Exercice 2 - Lire le paramètre alpha

Ajustez `ses()` sur les 91 premières semaines. Relevez la valeur estimée de alpha et interprétez-la qualitativement.

> **TIP:**
>
> ``` r
> entrainement <- demande |> slice_head(n = nrow(demande) - 13)
> modele <- ses(ts(entrainement$demande, frequency = 52), h = 13)
> modele$model$par["alpha"]
> ```
>
>         alpha 
>     0.3711818 
>
> Plus alpha est proche de 1, plus le niveau estimé réagit à la dernière observation.

## Exercice 3 - Mesures contradictoires

Comparez les méthodes avec MAE, RMSE et biais. Repérez une situation où les mesures ne donnent pas exactement le même message et expliquez pourquoi.

> **TIP:**
>
> Une méthode avec quelques grandes erreurs peut avoir une MAE acceptable mais une RMSE élevée. Un biais positif indique une sous-prévision moyenne selon la convention `observé - prévu`.

## Exercice de synthèse

Rédigez une recommandation à une gestionnaire d’inventaire. Justifiez une méthode, quantifiez son erreur, indiquez le sens de son biais et proposez une surveillance après déploiement.
