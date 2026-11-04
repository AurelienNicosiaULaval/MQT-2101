# Module 08 : lire la décomposition et une prévision saisonnière

Cette activité accompagne la lecture des motifs de l’activité 8.1. Elle utilise les ventes mensuelles fictives du cas guidé. Elle prépare la discussion de la tendance et de la saisonnalité; ses réponses peuvent compléter la même section du rapport. Les calculs utilisent uniquement les 60 mois d’apprentissage jusqu’à la comparaison de prévisions.

## Préparation

Installez au besoin les packages `tidyverse` et `forecast`, puis exécutez tous les blocs dans l’ordre.

``` r
library(tidyverse)
library(forecast)
ventes <- read_csv('data/ventes_saisonnieres_quebec.csv', show_col_types = FALSE) |>
  mutate(date = as.Date(date)) |>
  arrange(date)
stopifnot(nrow(ventes) == 72L, !anyDuplicated(ventes$date),
          identical(ventes$date[1], as.Date('2020-01-01')),
          identical(ventes$date[72], as.Date('2025-12-01')),
          all(diff(12L * as.integer(format(ventes$date, '%Y')) +
                     as.integer(format(ventes$date, '%m'))) == 1L),
          !anyNA(ventes$ventes), all(ventes$ventes > 0))
apprentissage <- ventes |> slice_head(n = 60)
validation <- ventes |> slice_tail(n = 12)
serie <- ts(apprentissage$ventes, start = c(2020, 1), frequency = 12)
```

## Lire les composantes

Dans une décomposition additive, la série s’écrit comme la somme d’une tendance, d’une composante saisonnière et d’un reste. Les composantes sont exprimées dans les unités de la série, ici des dollars par mois. Dans une décomposition multiplicative, elles sont combinées par multiplication; la composante saisonnière devient un facteur.

``` r
composantes <- decompose(serie, type = 'additive')
graphique_composantes <- tibble(
  date = apprentissage$date,
  `Série observée` = as.numeric(composantes$x),
  Tendance = as.numeric(composantes$trend),
  Saison = as.numeric(composantes$seasonal),
  Reste = as.numeric(composantes$random)
) |>
  pivot_longer(-date, names_to = 'composante', values_to = 'valeur') |>
  mutate(composante = factor(composante,
                            levels = c('Série observée', 'Tendance', 'Saison', 'Reste')))
ggplot(graphique_composantes, aes(date, valeur)) +
  geom_line(colour = '#0B4F6C', na.rm = TRUE) +
  facet_grid(composante ~ ., scales = 'free_y') +
  labs(x = 'Mois', y = 'Ventes et composantes ($ CA)') + theme_minimal()
```

![](decomposition-guidee_files/figure-html/unnamed-chunk-3-1.png)

``` r
indices <- tibble(mois = 1:12, ecart_saisonnier = as.numeric(composantes$figure))
indices
```

    # A tibble: 12 × 2
        mois ecart_saisonnier
       <int>            <dbl>
     1     1           -5826.
     2     2           -8114.
     3     3            7475.
     4     4            1910.
     5     5           18726.
     6     6            6629.
     7     7          -17783.
     8     8          -12419.
     9     9          -15746.
    10    10           -6579.
    11    11            7343.
    12    12           24384.

Pour un mois, un écart saisonnier estimé positif indique une valeur au-dessus de la tendance estimée dans cette décomposition. Il ne démontre pas que le mois cause cet écart. La tendance est obtenue par une moyenne centrée : elle manque aux extrémités et utilise des observations de part et d’autre des dates intérieures. Elle ne représente donc pas ce qui aurait été connu en temps réel à chaque date.

1.  Nommez un mois où l’écart saisonnier estimé est positif et un mois où il est négatif. Donnez leurs valeurs en dollars.
2.  Décrivez la tendance et une variation du reste. Pourquoi les valeurs manquantes aux extrémités ne sont-elles pas nécessairement des données absentes?
3.  Pourquoi ne faut-il pas utiliser 2025 pour estimer ces composantes si l’on veut comparer des prévisions émises à la fin de 2024?

> **TIP:**
>
> Utilisez le tableau affiché, avec ses signes et ses unités. La moyenne centrée ne peut pas être calculée aux bords avec la fenêtre complète. Les ventes de 2025 ne sont pas connues à l’origine de fin 2024. La décomposition décrit le passé et ne suffit pas à elle seule pour produire une prévision.

## Comprendre Holt-Winters et ETS avec un exemple fourni

Le lissage de Holt-Winters prolonge le lissage exponentiel en combinant un niveau, une tendance et une saisonnalité. Une saison additive ajoute des écarts dans l’unité des ventes; une saison multiplicative utilise des facteurs et exige des valeurs positives. L’approche ETS représente une famille de modèles dont on précise ou sélectionne les composantes d’erreur, de tendance et de saisonnalité. L’exemple ci-dessous estime un Holt-Winters additif et laisse `ets()` choisir une structure parmi les modèles qu’il considère. Il n’est pas demandé de calculer les récurrences à la main ni de mémoriser le catalogue des modèles.

Les trois candidats et l’horizon sont fixés avant d’examiner les erreurs : naïf saisonnier, Holt-Winters additif et ETS sélectionné sur l’apprentissage. Les douze valeurs de validation sont jointes après la prévision.

``` r
reference <- snaive(serie, h = 12)
holt_winters <- hw(serie, seasonal = 'additive', h = 12)
modele_ets <- ets(serie, model = 'ZZZ')
prevision_ets <- forecast(modele_ets, h = 12)
modele_ets
```

    ETS(A,A,A) 

    Call:
    ets(y = serie, model = "ZZZ")

      Smoothing parameters:
        alpha = 0.0829 
        beta  = 0.0051 
        gamma = 1e-04 

      Initial states:
        l = 286827.7167 
        b = 3210.8142 
        s = 24384.43 7342.497 -6578.983 -15746.51 -12419.05 -17783.21
               6629.252 18726.32 3305.001 7475.11 -7891.439 -7443.426

      sigma:  10625.49

         AIC     AICc      BIC 
    1373.573 1388.144 1409.177 

``` r
comparaison <- tibble(
  date = validation$date,
  observe = validation$ventes,
  `Naïf saisonnier` = as.numeric(reference$mean),
  `Holt-Winters additif` = as.numeric(holt_winters$mean),
  ETS = as.numeric(prevision_ets$mean)
) |> pivot_longer(-c(date, observe), names_to = 'methode', values_to = 'prevision')

scores <- comparaison |>
  group_by(methode) |>
  summarise(MAE = mean(abs(observe - prevision)),
            RMSE = sqrt(mean((observe - prevision)^2)), .groups = 'drop')
scores
```

    # A tibble: 3 × 3
      methode                 MAE   RMSE
      <chr>                 <dbl>  <dbl>
    1 ETS                   9947. 11252.
    2 Holt-Winters additif  9387. 10699.
    3 Naïf saisonnier      29067. 30170.

``` r
ggplot(comparaison, aes(date, prevision, colour = methode)) +
  geom_line() + geom_line(aes(y = observe), colour = 'black', linewidth = 0.8) +
  labs(x = 'Mois de validation', y = 'Ventes mensuelles ($ CA)',
       colour = 'Prévision', caption = 'Noir : ventes observées') +
  theme_minimal()
```

![](decomposition-guidee_files/figure-html/unnamed-chunk-4-1.png)

Lisez la structure affichée par `modele_ets` et le tableau. Ici, `ets()` retient la structure additive ETS(A,A,A), apparentée à celle utilisée par le Holt-Winters additif. Dans cette version de `forecast`, `hw()` estime celle-ci en minimisant l’erreur quadratique à un pas, tandis que `ets()` utilise par défaut la vraisemblance pour l’estimation. Les deux ajustements peuvent donc différer, même lorsque leur structure est semblable. Une MAE plus faible signifie ici une erreur absolue moyenne plus faible sur ces douze mois. Elle ne garantit pas le même classement à une autre origine. L’ETS automatique sélectionne sa structure à partir de l’apprentissage, selon le critère utilisé par `ets()`; le tableau de validation répond à une autre question. Les intervalles de chaque méthode reposent sur ses hypothèses et n’incluent pas nécessairement tous les changements futurs.

1.  Quelle composante le naïf saisonnier reprend-il pour chaque mois de 2025?
2.  Quels résultats distinguent les trois prévisions sur ce bloc? Indiquez la mesure et les unités.
3.  Donnez une raison pour laquelle le modèle retenu sur ce bloc doit être vérifié sur d’autres périodes ou à de nouvelles origines.

Les prévisions et le choix effectués sur 2025 ne constituent pas un test final indépendant. Les chiffres ne prouvent pas qu’une méthode est toujours supérieure.

## Pour aller plus loin

Hyndman et Athanasopoulos (2021), [décomposition des séries](https://otexts.com/fpp3/decomposition.html) et [lissage exponentiel](https://otexts.com/fpp3/exponential-smoothing.html); équipe `forecast`, documentation de [`hw()`](https://pkg.robjhyndman.com/forecast/reference/ses.html) et de [`ets()`](https://pkg.robjhyndman.com/forecast/reference/ets.html).
