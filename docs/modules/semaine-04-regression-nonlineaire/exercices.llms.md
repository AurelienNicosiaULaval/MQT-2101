# Exercices - Module 04

## Objectif

Une responsable des opérations veut décrire le temps d’attente en fonction du taux d’utilisation de ses succursales. La question est de déterminer si une courbe apporte un gain utile par rapport à une droite.

Jeu de données de transfert : [cas_integrateur_quebec.csv](../atelier-04-recapitulation/data/cas_integrateur_quebec.csv), décrit dans la [page Données](../../donnees/). Les succursales et leurs données sont fictives.

Les applications des capsules concernent l’achalandage et les ventes. Ici, la réponse, l’explicative, les unités, la période et la décision changent. Les six premiers exercices alimentent un seul rapport, `comparaison_attente.qmd`. Le modèle à retenir n’est pas donné d’avance.

Faites l’exercice 1 après la capsule 1, l’exercice 2 après la capsule 3, l’exercice 3 après la capsule 4, l’exercice 4 après la capsule 5, puis les exercices 5 et 6 après la capsule 6. Les activités 4.1 à 4.6 du cas guidé restent distinctes de cette série.

Faites une première tentative avant d’ouvrir le corrigé. Les solutions contiennent le code complet, les résultats recalculés et leur interprétation. Le code s’exécute dans l’ordre après la préparation; les réponses rédigées sont des exemples à confronter à votre raisonnement.

Huit [exercices supplémentaires](#pratique-supplementaire) permettent de pratiquer séparément les transformations, les calculs et la lecture critique.

## Préparation

Vous pouvez télécharger le [projet de départ complet](telechargements/comparaison-attente.zip), le décompresser et ouvrir son fichier `.Rproj`, ou suivre les étapes ci-dessous. Le [dictionnaire des deux cas](data/dictionnaires.md) précise les variables utiles.

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

# Afficher les résultats avec une virgule décimale dans le texte du rapport.
nombre_fr <- function(x, decimales = 3) {
  formatC(x, format = "f", digits = decimales, big.mark = " ", decimal.mark = ",")
}

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

Compétence visée : Décrire un nuage en distinguant les unités et les groupes.

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

Compétence visée : Interpréter une variation lorsque plusieurs termes dépendent de x.

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
> ``` r
> # La quadratique exige une différence de prédictions.
> scenarios_taux <- tibble(taux_utilisation = c(0.80, 0.90, 1.00))
> predictions_taux <- predict(modele_quadratique, newdata = scenarios_taux)
> tibble(comparaison = c("80 % à 90 %", "90 % à 100 %"),
>        difference_minutes = diff(predictions_taux))
> ```
>
>     # A tibble: 2 × 2
>       comparaison  difference_minutes
>       <chr>                     <dbl>
>     1 80 % à 90 %               0.465
>     2 90 % à 100 %              0.591
>
> Le R² passe d’environ 0,252 à 0,256. Cette légère hausse est un résultat d’apprentissage : ajouter un terme ne peut pas réduire le R² sur les mêmes lignes.
>
> La pente linéaire vaut environ 5,021 minutes par unité de taux. Dix points de pourcentage représentent 0,10 unité : la différence moyenne prédite est donc de 0,502 minute, soit environ 30 secondes. Cette association n’est pas un effet causal.
>
> Dans la quadratique, x et x² varient simultanément. On doit comparer les prédictions aux deux valeurs de x; le coefficient de x, pris seul, n’est pas une pente constante. Ici, les différences quadratiques valent 0,465 puis 0,591 minute.
>
> Erreur fréquente : confondre 10 points de pourcentage (0,10 unité) avec une hausse relative de 10 % (0,08 unité à partir de 80 %).

## Exercice 3 - Calculer la RMSE

Compétence visée : Comparer les erreurs sur les mêmes observations hors apprentissage.

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

Compétence visée : Délimiter la portée d’une prédiction et de son intervalle.

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

Compétence visée : Construire une conclusion décisionnelle appuyée sur les résultats.

Rédigez au plus cinq phrases pour la responsable des opérations : question, modèle retenu provisoirement, comparaison chiffrée, plage d’utilisation et limite. Proposez une information supplémentaire à recueillir.

> **TIP:**

## Exercice 6 - Mini-trace de comparaison

Compétence visée : Produire un document autonome qui se recalcule.

Terminez `comparaison_attente.qmd` avec le nuage, les deux modèles, la comparaison d’erreurs, le diagnostic, les scénarios et votre conclusion. Vérifiez qu’aucun résultat ne dépend d’un objet créé manuellement dans la console. Redémarrez R, puis rendez le rapport en HTML.

> **TIP:**
>
> Après votre tentative, le [corrigé complet téléchargeable](telechargements/corrige-attente.zip) fournit le document Quarto et le script R, les données et le dictionnaire. Les encadrés de cette page restent la version de référence pour consulter les corrections progressivement.
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

## Pratique supplémentaire

Ces huit exercices sont facultatifs et indépendants des rapports suivis. Ils portent sur des situations pédagogiques fictives; les nombres fournis ne sont pas des données d’organisations réelles. Les calculs peuvent être faits à la main, puis vérifiés avec le code R complet de chaque corrigé. Aucun fichier supplémentaire n’est nécessaire.

| Exercices | À faire après | Compétence |
|----|----|----|
| 7 à 9 | Capsule 3 | Comparer des prédictions, interpréter log(x), changer d’unité |
| 10 à 12 | Capsule 4 | Calculer les erreurs, choisir sans fuite de données, lire les diagnostics |
| 13 | Capsule 5 | Distinguer les intervalles et l’extrapolation |
| 14 | Capsule 6 | Corriger une conclusion décisionnelle |

## Exercice 7 - Une courbe de consommation

Une équation pédagogique décrit la consommation électrique journalière d’un atelier : \\\widehat y = 40 + 6x + 0{,}8x^2\\, où x est le nombre de centaines de pièces et y est en kWh. Elle a été ajustée pour x entre 1 et 6.

1.  Calculez les prédictions pour 200, 300 et 400 pièces. Comparez les deux hausses de 100 pièces.
2.  Expliquez pourquoi le coefficient 6 ne donne pas la hausse prédite pour 100 pièces supplémentaires.
3.  Peut-on employer cette équation pour 1 000 pièces? Précisez la limite.

> **TIP:**
>
> ``` r
> pieces_centaines <- c(2, 3, 4)
> consommation <- 40 + 6 * pieces_centaines + 0.8 * pieces_centaines^2
> data.frame(pieces = 100 * pieces_centaines, kWh_predits = consommation)
> ```
>
>       pieces kWh_predits
>     1    200        55.2
>     2    300        65.2
>     3    400        76.8
>
> ``` r
> diff(consommation)
> ```
>
>     [1] 10.0 11.6
>
> Les prédictions sont 55,2, 65,2 et 76,8 kWh. Les différences valent 10,0 puis 11,6 kWh. Ici la hausse s’accélère, alors que le cas guidé cherchait un ralentissement. Pour passer de x à x + h, les termes simple et quadratique changent : la différence est \\6h + 0{,}8(2xh+h^2)\\.
>
> Pour 1 000 pièces, x vaut 10 et dépasse la plage de 1 à 6. Le calcul est possible mais sa pertinence n’est pas validée. Erreurs fréquentes : saisir 200 à la place de 2, prendre 6 comme une pente constante ou annoncer un effet causal de la production sur la consommation à partir de cette seule équation.

## Exercice 8 - Interpréter un logarithme

Un modèle pédagogique donne le temps moyen de traitement d’un lot : \\\widehat y = 12 + 4\ln(x)\\, où x est le nombre de dossiers et y est en minutes. La plage étudiée est de 10 à 100 dossiers.

Comparez 20 à 40 dossiers, puis 40 à 80 dossiers. Comparez ensuite une hausse de 10 % à partir de 20 dossiers. Peut-on calculer une prédiction pour zéro dossier? Le modèle impose-t-il un plafond au temps de traitement?

> **TIP:**
>
> ``` r
> predire_temps <- function(dossiers) {
>   stopifnot(all(dossiers > 0))
>   12 + 4 * log(dossiers)
> }
> x <- c(20, 40, 80)
> data.frame(dossiers = x, minutes = predire_temps(x))
> ```
>
>       dossiers  minutes
>     1       20 23.98293
>     2       40 26.75552
>     3       80 29.52811
>
> ``` r
> c(doubler_20 = predire_temps(40) - predire_temps(20),
>   doubler_40 = predire_temps(80) - predire_temps(40),
>   hausse_10_pourcent = predire_temps(22) - predire_temps(20))
> ```
>
>             doubler_20         doubler_40 hausse_10_pourcent
>              2.7725887          2.7725887          0.3812407
>
> Les deux doublements donnent la même différence, \\4\ln(2)\\, soit environ 2,773 minutes. La hausse relative de 10 % donne \\4\ln(1{,}10)\\, soit 0,381 minute. Les temps prédits pour 20, 40 et 80 dossiers sont environ 23,983, 26,756 et 29,528 minutes.
>
> Zéro ne convient pas : `log(0)` n’est pas une valeur finie. Le logarithme croît sans borne; la progression ralentit mais n’impose aucun plafond. Erreurs fréquentes : lire une hausse de 10 % du temps, employer `log10()` sans changer le coefficient ou ajouter arbitrairement 1 à x. `log(x + 1)` serait un autre modèle à justifier et à ajuster.

## Exercice 9 - Changer d’unité sans changer la courbe

Un modèle pédagogique utilise x, une distance en kilomètres, et y, un coût en dollars : \\\widehat y=80+12x+2x^2\\. On veut maintenant saisir la distance z en mètres.

Écrivez l’équation en z. Vérifiez que 2 km et 2 000 m donnent le même résultat. Pour un modèle \\\widehat y=a+b\ln(x)\\, indiquez quels coefficients changent lorsqu’on remplace les kilomètres par les mètres.

> **TIP:**
>
> Comme \\x=z/1000\\, l’équation devient \\\widehat y=80+0{,}012z+0{,}000002z^2\\. Le coefficient quadratique est divisé par un million.
>
> ``` r
> x_km <- 2
> z_m <- 2000
> c(kilometres = 80 + 12 * x_km + 2 * x_km^2,
>   metres = 80 + 0.012 * z_m + 0.000002 * z_m^2)
> ```
>
>     kilometres     metres
>            112        112
>
> ``` r
> # Vérification du logarithme sur un exemple de coefficients.
> a <- 80
> b <- 12
> c(kilometres = a + b * log(x_km),
>   metres = (a - b * log(1000)) + b * log(z_m))
> ```
>
>     kilometres     metres
>       88.31777   88.31777
>
> Les deux prédictions quadratiques valent 112 \$. Pour le logarithme, \\\ln(x)=\ln(z)-\ln(1000)\\ : l’ordonnée à l’origine devient \\a-b\ln(1000)\\ et b reste le même. Il s’agit d’un changement d’unité, pas d’un nouvel ajustement ni d’une amélioration du modèle.
>
> Erreur fréquente : diviser les deux coefficients de la quadratique par 1 000. Il faut transformer chaque puissance avec son unité.

## Exercice 10 - Erreurs signées, MAE et RMSE

Repère : la MAE est la moyenne des valeurs absolues des erreurs, \\\mathrm{MAE}=n^{-1}\sum_i \|y_i-\widehat y_i\|\\. Elle conserve l’unité de la réponse. La RMSE, vue à la capsule 4, utilise les carrés avant de prendre la racine. La [lecture sur les mesures d’erreur](../../modules/semaine-04-regression-nonlineaire/lectures.llms.md#references-ciblees) explique cette distinction.

Sur quatre journées réservées à la validation, une équipe observe des livraisons de 8, 10, 12 et 14 palettes. Le modèle A prédit 10, 8, 14 et 12 palettes; le modèle B prédit 8, 10, 12 et 18 palettes.

Calculez les erreurs observé moins prédit, leur moyenne, la MAE et la RMSE de chaque modèle. Est-ce que les deux critères donnent le même classement? Ces observations permettent-elles de calculer des résidus d’apprentissage?

> **TIP:**
>
> ``` r
> observe <- c(8, 10, 12, 14)
> pred_A <- c(10, 8, 14, 12)
> pred_B <- c(8, 10, 12, 18)
> mesurer <- function(predit) {
>   erreur <- observe - predit
>   c(moyenne = mean(erreur), MAE = mean(abs(erreur)),
>     RMSE = sqrt(mean(erreur^2)))
> }
> rbind(A = mesurer(pred_A), B = mesurer(pred_B))
> ```
>
>       moyenne MAE RMSE
>     A       0   2    2
>     B      -1   1    2
>
> ``` r
> data.frame(erreur_A = observe - pred_A, erreur_B = observe - pred_B)
> ```
>
>       erreur_A erreur_B
>     1       -2        0
>     2        2        0
>     3       -2        0
>     4        2       -4
>
> A donne les erreurs −2, 2, −2 et 2 palettes : moyenne 0, MAE 2, RMSE 2. B donne 0, 0, 0 et −4 : moyenne −1, MAE 1, RMSE 2. La MAE préfère B; la RMSE donne une égalité parce qu’elle pénalise davantage la grande erreur de B. Un classement dépend donc aussi du critère choisi selon la décision.
>
> Il s’agit d’erreurs de validation, pas de résidus d’apprentissage. Une moyenne signée nulle peut cacher des erreurs importantes. Ne divisez pas la somme des carrés par n − p : ici la RMSE utilise le nombre d’erreurs évaluées, soit 4.

## Exercice 11 - Repérer une comparaison invalide

Une analyste ajuste deux modèles sur 2022-2024. Elle choisit ensuite le degré du polynôme en essayant plusieurs formes sur 2025. Enfin, elle réajuste le modèle retenu avec toutes les données de 2022 à 2025 et calcule son erreur sur 2025. Elle annonce : « Notre erreur de test final est de 3,2 unités. »

Repérez deux problèmes distincts. Proposez une procédure qui permettrait une comparaison puis une évaluation finale. Le réajustement sur toutes les données est-il toujours interdit?

> **TIP:**
>
> Le choix de la forme a utilisé 2025 : cette année est une validation, pas un test final indépendant. Après le réajustement, les réponses de 2025 ont aussi servi à estimer les coefficients; l’erreur annoncée n’est même plus calculée sur des observations hors apprentissage.
>
> Une procédure acceptable fixe d’abord les candidats et ajuste leurs coefficients sur 2022-2024, les compare sur 2025 sans réajuster, puis fige la procédure retenue. De nouvelles observations, par exemple une période ultérieure non consultée, peuvent alors évaluer le choix final. Si les données sont mensuelles et répétées par succursale, on conserve l’ordre chronologique et on précise qu’on prédit les mêmes succursales.
>
> Réajuster ensuite pour préparer l’utilisation du modèle est possible. Cela ne transforme pas les erreurs sur les anciennes données en une évaluation indépendante. La réponse est acceptable si elle distingue sélection, estimation des coefficients et évaluation finale. Erreur fréquente : appeler « test » toute donnée qui avait été mise de côté au début.

## Exercice 12 - Une bonne moyenne peut cacher un biais

Un tableau pédagogique contient les résidus suivants, en minutes : −2, −1 et −3 pour le centre A; 2, 1 et 3 pour le centre B. Les valeurs ajustées correspondantes sont 10, 12 et 14 minutes dans chaque centre.

Calculez le résidu moyen global et les deux moyennes par centre. Quel centre est surestimé? Que faudrait-il examiner avant de conclure que le modèle convient? Une moyenne globale nulle suffit-elle à vérifier l’indépendance ou la normalité?

> **TIP:**
>
> ``` r
> library(tidyverse)
> exemple_residus <- tibble(
>   centre = rep(c("A", "B"), each = 3),
>   ajuste = rep(c(10, 12, 14), 2),
>   residu = c(-2, -1, -3, 2, 1, 3)
> )
> mean(exemple_residus$residu)
> ```
>
>     [1] 0
>
> ``` r
> exemple_residus |>
>   group_by(centre) |>
>   summarise(residu_moyen_minutes = mean(residu), .groups = "drop")
> ```
>
>     # A tibble: 2 × 2
>       centre residu_moyen_minutes
>       <chr>                 <dbl>
>     1 A                        -2
>     2 B                         2
>
> ``` r
> ggplot(exemple_residus, aes(ajuste, residu, colour = centre)) +
>   geom_hline(yintercept = 0) +
>   geom_point(size = 3) +
>   labs(x = "Temps ajusté (minutes)", y = "Résidu (minutes)", colour = "Centre") +
>   theme_minimal()
> ```
>
> ![](exercices_files/figure-html/solution-04-12-1.png)
>
> La moyenne globale vaut 0, mais les moyennes valent −2 pour A et +2 pour B. Avec résidu = observé − ajusté, A est surestimé et B est sous-estimé. Il faut examiner les différences de contexte, la dispersion, la forme et l’ordre temporel des observations. Six résidus ne démontrent pas un mécanisme.
>
> La moyenne nulle n’établit ni indépendance ni normalité. Sur l’apprentissage d’un modèle par moindres carrés avec constante, une somme de résidus pratiquement nulle découle de l’ajustement. Erreur fréquente : confondre cette propriété algébrique avec la validation du modèle.

## Exercice 13 - Choisir le bon intervalle

Dans une petite série pédagogique de lots indépendants, le volume x est en centaines d’unités et le temps y en heures. Les six couples sont (1; 2,4), (2; 3,1), (3; 4,2), (4; 4,7), (5; 5,9) et (6; 6,4).

Ajustez une droite. Pour x = 3,5, calculez un intervalle de confiance à 95 % pour le temps moyen et un intervalle de prédiction à 95 % pour un nouveau lot. Comparez leur centre et leur largeur. Répétez à x = 12 et expliquez pourquoi la présence d’un intervalle ne valide pas l’extrapolation. Les hypothèses du modèle sont à examiner, même si les calculs fonctionnent.

> **TIP:**
>
> ``` r
> lots <- data.frame(x = 1:6, y = c(2.4, 3.1, 4.2, 4.7, 5.9, 6.4))
> ajustement_lots <- lm(y ~ x, data = lots)
> scenarios_lots <- data.frame(x = c(3.5, 12))
> ic_lots <- predict(ajustement_lots, newdata = scenarios_lots,
>                    interval = "confidence", level = 0.95)
> ip_lots <- predict(ajustement_lots, newdata = scenarios_lots,
>                    interval = "prediction", level = 0.95)
> cbind(scenarios_lots, ic_lots)
> ```
>
>          x      fit       lwr       upr
>     1  3.5  4.45000  4.250891  4.649109
>     2 12.0 11.46857 10.457782 12.479361
>
> ``` r
> cbind(scenarios_lots, ip_lots)
> ```
>
>          x      fit       lwr       upr
>     1  3.5  4.45000  3.923207  4.976793
>     2 12.0 11.46857 10.346270 12.590873
>
> À x = 3,5, les deux intervalles sont centrés sur 4,450 heures. L’intervalle pour la moyenne va de 4,251 à 4,649 heures; celui pour un nouveau lot va de 3,923 à 4,977 heures. Le second inclut la variabilité d’une nouvelle observation, en plus de l’incertitude d’estimation de la moyenne.
>
> À x = 12, on est au-delà de 1 à 6. Les intervalles reposent encore sur la forme linéaire et les hypothèses d’erreurs indépendantes, normales et de variance constante. Ils ne mesurent pas l’incertitude sur une autre forme possible au-delà des données. Erreur fréquente : présenter l’intervalle pour la moyenne comme celui d’un prochain lot, ou son niveau de 95 % comme une garantie de fiabilité hors domaine.

## Exercice 14 - Réviser une recommandation

Une note fictive affirme : « Le polynôme a le meilleur R², donc il prédit mieux. Sa RMSE de validation a baissé de 2 minutes : nous avons réduit l’attente de 2 minutes. La courbure prouve que le centre est saturé. Nous pouvons doubler la capacité et prévoir au-delà des volumes observés puisque R fournit un intervalle. »

Repérez quatre erreurs de raisonnement et proposez une note corrigée en quatre ou cinq phrases. Aucune autre donnée n’est fournie : ne créez pas de résultats supplémentaires.

> **TIP:**
>
> Le R² d’apprentissage ne suffit pas à conclure sur la prédiction. La baisse de RMSE mesure une amélioration d’erreur sur la période réservée, pas une réduction de l’attente observée. La courbure ne prouve ni un plateau ni sa cause. Une décision sur la capacité et une extrapolation demandent des informations supplémentaires; un intervalle classique ne résout pas ces limites.
>
> Exemple de réponse acceptable : « Le polynôme présente un meilleur ajustement sur les données utilisées. Sa RMSE de validation est plus faible de 2 minutes, mais il faut connaître les erreurs de référence, le nombre d’observations et la stabilité sur d’autres périodes pour juger ce gain. Ce résultat ne démontre pas une réduction de l’attente ni une cause de saturation. L’utilisation doit rester prudente dans la plage observée. Avant une décision de capacité, il faut examiner les contraintes opérationnelles et recueillir de nouvelles données. »
>
> Une formulation différente convient si elle corrige les quatre erreurs, distingue prédiction et intervention, et n’invente aucun résultat. Erreur fréquente : remplacer une certitude injustifiée par une autre, par exemple affirmer sans preuve que la droite est forcément préférable.

## Auto-vérification

J’ai tenté chaque exercice avant d’ouvrir le corrigé.

J’ai séparé les périodes avant d’ajuster les modèles.

Mes RMSE utilisent les mêmes observations et les mêmes unités.

Je distingue amélioration d’ajustement et amélioration de validation.

Ma conclusion explique pourquoi une droite peut suffire.

Mon rapport se recalcule après redémarrage de R.

Vous pouvez demander au [GPT du cours](https://chatgpt.com/g/g-6a0b2ec33d948191ad25b2f247b15de1-analyse-et-modelisation-des-donnees?ref=mini) de commenter une première tentative. Il doit vous aider à repérer une erreur ou une limite, sans choisir ni rédiger la conclusion à votre place. Comprendre une réponse aidée ne démontre pas que vous savez la reproduire seul.
