# Exercices - Module 07

## Un transfert vers la planification énergétique

Une équipe doit planifier la consommation d’électricité d’un bâtiment universitaire fictif. À la fin de décembre 2024, elle veut une prévision pour chacun des douze mois de 2025. Les méthodes qui prolongent un niveau constant ont-elles assez de souplesse pour suivre un cycle annuel? Vous recommanderez une méthode à partir des écarts observés et d’un scénario de coût fictif. La cible est l’énergie totale consommée chaque mois, en kWh.

Les exercices 1 à 4 alimentent le rapport `lissage_electricite.qmd`. Faites chaque exercice après la capsule du même numéro. Essayez d’abord de produire les résultats demandés et d’écrire votre propre interprétation. Ouvrez ensuite le corrigé pour comparer votre démarche. Les blocs R des quatre corrigés s’exécutent dans l’ordre, après la préparation commune.

Travaillez dans le [projet de transfert](telechargements/lissage-electricite.zip). Le [projet des corrigés complets](telechargements/corrige-lissage-electricite.zip) contient aussi les [huit exercices supplémentaires](#pratique-supplementaire), à faire selon vos besoins.

## Préparation

Décompressez le projet et ouvrez le `.Rproj` dans RStudio. Si les bibliothèques vous manquent, lancez `install.packages(c("tidyverse", "slider", "forecast"))` une fois dans la console. Redémarrez ensuite R et exécutez la préparation ci-dessous. Le projet contient le même fichier de consommation qu’au module 06, les [dictionnaires](data/dictionnaires.md) et les fonctions dans `R/fonctions-module07.R`.

``` r
library(tidyverse)
library(slider)
library(forecast)

# Ouvrir le projet .Rproj fourni : R/ et data/ sont à côté du rapport.
source("R/fonctions-module07.R")
electricite <- read_csv("data/consommation_electrique_batiment_quebec.csv",
                        show_col_types = FALSE) |>
  mutate(date = as.Date(date)) |>
  arrange(date)
stopifnot(nrow(electricite) == 72L, !anyNA(electricite),
          !anyDuplicated(electricite$date),
          identical(electricite$date,
                    seq.Date(as.Date("2020-01-01"), by = "month", length.out = 72)))
horizon_e <- 12L
apprentissage_e <- electricite |> slice_head(n = 60)
validation_e <- electricite |> slice_tail(n = horizon_e)
serie_e <- ts(apprentissage_e$consommation_kwh, frequency = 12,
              start = c(2020, 1))
```

Les 60 mois de janvier 2020 à décembre 2024 servent à calculer les niveaux et les prévisions. Les douze mois de 2025 servent à comparer les méthodes après coup. Ils ont déjà été examinés au module 06 et forment une validation connue.

On fixe cinq candidats avant de calculer les scores. Le naïf et le naïf saisonnier servent de références. La moyenne mobile de trois mois (MM3) et les deux lissages exponentiels (SES02 pour \\\alpha=0{,}2\\ et SES08 pour \\\alpha=0{,}8\\) permettent d’étudier différents niveaux de réactivité. Les deux lissages partent de la première consommation de la série.

## Exercice 1 - Fenêtres et unités

1.  Sur les 60 mois d’apprentissage, superposez la consommation observée et les moyennes mobiles arrière de 3 et 12 mois. Si vous tracez en MWh, divisez les kWh par 1 000 et indiquez l’unité sur l’axe.
2.  Trouvez le premier mois où les deux moyennes sont disponibles et où leur écart absolu dépasse 20 000 kWh. Donnez le mois, les deux moyennes et l’écart. Ce seuil sert à repérer un exemple dans la série.
3.  À partir du graphique, indiquez quelle fenêtre suit le plus vite les hausses et les baisses. Si vous répétiez la dernière moyenne de 12 mois pour toute l’année 2025, la prévision pourrait-elle reproduire les variations entre les mois?

> **TIP:**
>
> Une moyenne arrière de trois mois devient disponible au troisième mois. Pour la fenêtre de douze mois, il faut attendre le douzième. Calculez l’écart seulement aux dates où les deux moyennes existent.
>
> ``` r
> electricite_lissee <- apprentissage_e |>
>   mutate(mm3 = slide_dbl(consommation_kwh, mean, .before = 2, .complete = TRUE),
>          mm12 = slide_dbl(consommation_kwh, mean, .before = 11, .complete = TRUE))
> electricite_lissee |>
>   select(date, Observé = consommation_kwh, MM3 = mm3, MM12 = mm12) |>
>   pivot_longer(-date, names_to = "serie", values_to = "kwh") |>
>   ggplot(aes(date, kwh / 1000, colour = serie)) +
>   geom_line(na.rm = TRUE) +
>   labs(x = NULL, y = "Énergie mensuelle (MWh)", colour = "Série") +
>   theme_minimal(base_size = 12)
> ```
>
> ![La moyenne mobile de trois mois suit une partie des variations saisonnières. La moyenne mobile de douze mois atténue le cycle annuel.](exercices_files/figure-html/solution-fenetres-m07-1.png)
>
> ``` r
> electricite_lissee |>
>   filter(!is.na(mm12)) |>
>   mutate(ecart_kwh = abs(mm3 - mm12)) |>
>   filter(ecart_kwh > 20000) |>
>   slice_head(n = 1) |>
>   select(date, mm3, mm12, ecart_kwh)
> ```
>
>     # A tibble: 1 × 4
>       date           mm3    mm12 ecart_kwh
>       <date>       <dbl>   <dbl>     <dbl>
>     1 2020-12-01 173168. 146385.    26783.
>
> Le premier dépassement survient en décembre 2020. MM3 vaut environ 173 168 kWh et MM12, 146 385 kWh. L’écart est de 26 783 kWh, soit environ 26,8 MWh. Sur le graphique, MM3 suit davantage la remontée de fin d’année. MM12 l’atténue, car elle conserve aussi les mois de plus faible consommation. Si l’on répète la dernière MM12, on obtient la même valeur chaque mois de 2025.

## Exercice 2 - Deux réactivités, une même origine

1.  Calculez les deux niveaux lissés sur l’apprentissage avec `niveau_ses()`. Comparez leurs valeurs de décembre 2024 à la consommation de ce même mois. Quel niveau en est le plus proche?
2.  Construisez un tableau de douze lignes, une par mois de 2025, avec une colonne par méthode. Préparez les cinq prévisions de chaque mois à partir de l’information connue à la fin de décembre 2024.
3.  Expliquez d’où viennent les prévisions de janvier et de février pour MM3 et le naïf saisonnier. Pourquoi quatre méthodes produisent-elles une prévision constante alors que le naïf saisonnier varie d’un mois à l’autre?

> **TIP:**
>
> ``` r
> niveaux_e <- apprentissage_e |>
>   mutate(alpha_02 = niveau_ses(consommation_kwh, 0.2),
>          alpha_08 = niveau_ses(consommation_kwh, 0.8))
> niveaux_e |> select(date, consommation_kwh, alpha_02, alpha_08) |> tail(4)
> ```
>
>     # A tibble: 4 × 4
>       date       consommation_kwh alpha_02 alpha_08
>       <date>                <dbl>    <dbl>    <dbl>
>     1 2024-09-01           129982  140333.  128065.
>     2 2024-10-01           157641  143795.  151726.
>     3 2024-11-01           187237  152483.  180135.
>     4 2024-12-01           200112  162009.  196117.
>
> ``` r
> previsions_e <- tibble(
>   date = seq(max(apprentissage_e$date), by = "month",
>              length.out = horizon_e + 1L)[-1L],
>   Naive = rep(tail(apprentissage_e$consommation_kwh, 1), horizon_e),
>   MM3 = rep(mean(tail(apprentissage_e$consommation_kwh, 3)), horizon_e),
>   SES02 = rep(tail(niveaux_e$alpha_02, 1), horizon_e),
>   SES08 = rep(tail(niveaux_e$alpha_08, 1), horizon_e),
>   Saisonnier = as.numeric(snaive(serie_e, h = horizon_e)$mean)
> )
> knitr::kable(head(previsions_e, 2), digits = 0,
>              col.names = c("Mois", "Naïf", "MM3", "SES02", "SES08", "Naïf saisonnier"),
>              format.args = list(big.mark = "\u00a0"),
>              caption = "Prévisions pour janvier et février 2025, en kWh")
> ```
>
> | Mois       |    Naïf |     MM3 |   SES02 |   SES08 | Naïf saisonnier |
> |:-----------|--------:|--------:|--------:|--------:|----------------:|
> | 2025-01-01 | 200 112 | 181 663 | 162 009 | 196 117 |         215 188 |
> | 2025-02-01 | 200 112 | 181 663 | 162 009 | 196 117 |         192 262 |
>
> Prévisions pour janvier et février 2025, en kWh {.caption-top .table .table-sm .table-striped .small}
>
> En décembre 2024, la consommation observée est de 200 112 kWh. Avec \\\alpha=0{,}8\\, le dernier niveau vaut environ 196 117 kWh. Il est plus près de décembre que le niveau avec \\\alpha=0{,}2\\, qui vaut environ 162 009 kWh. Cette proximité décrit la réactivité du lissage à la dernière observation.
>
> MM3 répète la moyenne d’octobre à décembre 2024 en janvier et en février 2025, puis aux dix autres horizons. Le naïf répète la valeur de décembre et les deux SES répètent leur dernier niveau. Le naïf saisonnier reprend la consommation de janvier 2024 pour janvier 2025, celle de février 2024 pour février 2025, et ainsi de suite. La fréquence 12 indique à `snaive()` la longueur du cycle à répéter.

## Exercice 3 - Scores et coût asymétrique

1.  Associez chaque prévision à la consommation observée le même mois en 2025. Tracez les observations et les cinq séries de prévisions sur un même graphique. À quels mois les prévisions constantes ont-elles de la difficulté à suivre la consommation?
2.  Calculez ME, MAE et RMSE pour chaque méthode, en kWh. Utilisez la convention `erreur = observé - prévu`. Quelle méthode a la plus petite MAE?
3.  Calculez le coût moyen par mois si chaque kWh sous-prévu coûte deux unités fictives et chaque kWh sur-prévu en coûte une. Comparez le classement par MAE au classement par coût. Refaites la comparaison parmi les quatre méthodes constantes. Quelle méthode arrive en tête pour chacun des deux critères dans ce groupe?

> **TIP:**
>
> ``` r
> stopifnot(nrow(previsions_e) == nrow(validation_e),
>           all(previsions_e$date == validation_e$date))
> erreurs_e <- previsions_e |>
>   mutate(observe = validation_e$consommation_kwh) |>
>   pivot_longer(Naive:Saisonnier, names_to = "methode", values_to = "prevision") |>
>   mutate(erreur = observe - prevision)
> scores_e <- erreurs_e |>
>   group_by(methode) |>
>   group_modify(~ mesures_erreurs(.x$observe, .x$prevision,
>                                 cout_sous = 2, cout_sur = 1)) |>
>   ungroup()
> classement_e <- scores_e |>
>   mutate(rang_cout = min_rank(cout_moyen)) |>
>   arrange(MAE) |>
>   select(methode, ME, MAE, RMSE, cout_moyen, rang_cout)
> knitr::kable(classement_e,
>              digits = 0, format.args = list(big.mark = "\u00a0"),
>              col.names = c("Méthode", "ME (kWh)", "MAE (kWh)", "RMSE (kWh)",
>                            "Coût moyen", "Rang selon le coût"),
>              caption = "Méthodes classées par MAE sur les douze mois de 2025")
> ```
>
> | Méthode    | ME (kWh) | MAE (kWh) | RMSE (kWh) | Coût moyen | Rang selon le coût |
> |:-----------|---------:|----------:|-----------:|-----------:|-------------------:|
> | Saisonnier |    3 052 |     6 662 |      7 987 |     11 520 |                  1 |
> | SES02      |    1 224 |    31 102 |     35 679 |     47 265 |                  4 |
> | MM3        |  -18 430 |    33 971 |     40 139 |     41 741 |                  2 |
> | SES08      |  -32 883 |    41 147 |     48 505 |     45 278 |                  3 |
> | Naive      |  -36 879 |    43 810 |     51 298 |     47 276 |                  5 |
>
> Méthodes classées par MAE sur les douze mois de 2025 {.caption-top .table .table-sm .table-striped .small}
>
> ``` r
> ggplot() +
>   geom_line(data = validation_e, aes(date, consommation_kwh / 1000, colour = "Observé"),
>             linewidth = 1) +
>   geom_line(data = erreurs_e, aes(date, prevision / 1000, colour = methode)) +
>   labs(x = NULL, y = "Énergie mensuelle (MWh)", colour = NULL) +
>   scale_colour_manual(values = c("Observé" = "#202124", MM3 = "#0072B2",
>                                  Naive = "#D55E00", SES02 = "#009E73",
>                                  SES08 = "#A34788", Saisonnier = "#80631D"),
>                       breaks = c("Observé", "Saisonnier", "Naive", "MM3", "SES02", "SES08"),
>                       labels = c("Observé", "Naïf saisonnier", "Naïf", "MM3", "SES02", "SES08")) +
>   guides(colour = guide_legend(nrow = 2)) +
>   theme_minimal(base_size = 15) +
>   theme(legend.position = "bottom")
> ```
>
> ![Les prévisions constantes ratent une grande partie des variations mensuelles. Le naïf saisonnier suit mieux la hausse hivernale et le creux estival.](exercices_files/figure-html/solution-graphique-m07-1.png)
>
> Les quatre méthodes constantes sous-estiment la consommation en janvier et en décembre et la surestiment de mai à septembre. La référence saisonnière suit les variations du calendrier et arrive en tête pour la MAE (6 662 kWh), la RMSE (7 987 kWh) et le coût moyen (11 520 unités fictives par mois).
>
> Pour voir comment le signe agit sur le coût, prenez les deux premiers mois du naïf saisonnier. En janvier, son erreur est \\223\\421-215\\188=+8\\233\\ kWh et son coût vaut \\2\times 8\\233=16\\466\\. En février, son erreur est \\184\\638-192\\262=-7\\624\\ kWh et son coût vaut \\7\\624\\. Le tableau donne la moyenne des douze coûts.
>
> ``` r
> scores_constantes_e <- scores_e |> filter(methode != "Saisonnier")
> scores_constantes_e |> arrange(MAE) |> select(methode, MAE)
> ```
>
>     # A tibble: 4 × 2
>       methode    MAE
>       <chr>    <dbl>
>     1 SES02   31102.
>     2 MM3     33971.
>     3 SES08   41147.
>     4 Naive   43810.
>
> ``` r
> scores_constantes_e |> arrange(cout_moyen) |> select(methode, cout_moyen)
> ```
>
>     # A tibble: 4 × 2
>       methode cout_moyen
>       <chr>        <dbl>
>     1 MM3         41741.
>     2 SES08       45278.
>     3 SES02       47265.
>     4 Naive       47276.
>
> Parmi les méthodes constantes, SES02 a la plus petite MAE (31 102 kWh, contre 33 971 pour MM3). MM3 arrive en tête pour le coût (41 741 unités fictives par mois, contre 47 265 pour SES02). Son niveau plus élevé réduit les sous-prévisions, qui coûtent davantage dans ce scénario. La ME de SES02 est près de zéro parce que ses sous-prévisions et ses sur-prévisions se compensent en partie. La MAE conserve l’ampleur de ces écarts.

## Exercice 4 - Recommandation et surveillance

Rédigez une courte note à l’équipe énergétique à partir de vos tableaux de l’exercice 3.

1.  Recommandez une méthode en citant sa MAE, sa RMSE et son coût moyen, avec leurs unités.
2.  Expliquez pourquoi cette méthode se démarque des prévisions constantes. Comparez votre choix à celui du [cas guidé](../../modules/semaine-07-lissage/demonstrations.llms.md#decision).
3.  Précisez ce que la validation de 2025 permet de conclure et proposez un suivi à la réception des prochains relevés. Indiquez quelle information supplémentaire serait nécessaire pour estimer une facture ou juger si la capacité du bâtiment suffit.

> **TIP:**
>
> Exemple de note à l’équipe énergétique.
>
> > Je recommande le naïf saisonnier comme référence. Sur les douze mois de 2025, sa MAE est d’environ 6 662 kWh, sa RMSE de 7 987 kWh et son coût moyen de 11 520 unités fictives par mois. Il suit mieux les hausses hivernales et les creux d’été qu’un niveau constant. Dans le cas hebdomadaire, MM4 a donné le meilleur résultat sur ses treize cibles. Ici, la répétition d’un profil mensuel donne de meilleurs résultats parce que le cycle annuel est marqué.
> >
> > Cette comparaison porte sur une période déjà examinée. À chaque nouveau relevé, je noterais le signe et l’ampleur de l’erreur pour repérer les mois où la référence se dégrade. Je comparerais ensuite les méthodes sur de nouvelles périodes de douze mois, avec les mêmes cibles pour chacune. Pour estimer une facture, il faudrait les tarifs applicables. Pour vérifier la capacité, il faudrait notamment connaître la puissance de pointe en kW et la capacité de l’installation.

## Trace finale

Dans `lissage_electricite.qmd`, gardez le calendrier, le graphique des fenêtres, la comparaison des deux niveaux SES, le tableau des cinq méthodes, le graphique de validation, les scores et votre note de décision. Indiquez l’unité de consommation sur les graphiques et dans les tableaux. Redémarrez R, puis faites Render pour vérifier que tout se recalcule. Les activités du parcours guidé restent dans `lissage_demande.qmd`.

## Pratique supplémentaire

Ces huit exercices sont facultatifs et indépendants des deux rapports suivis. Ils portent sur des situations fictives en approvisionnement, en maintenance et en gestion de l’énergie. Tous les nombres nécessaires sont fournis; aucun fichier supplémentaire n’est requis. Faites d’abord une tentative à la main ou avec une calculatrice, puis utilisez le code R du corrigé pour la vérifier.

| Ce que vous voulez travailler | Exercices | À faire après |
|----|----|----|
| Choisir une fenêtre et respecter l’information disponible | [5](#exercice-5), [6](#exercice-6) | Capsule 1 |
| Comprendre la réaction du lissage exponentiel | [7](#exercice-7) | Capsule 2 |
| Lire ce que les scores résument et ce qu’ils cachent | [8](#exercice-8), [9](#exercice-9), [10](#exercice-10) | Capsule 3 |
| Relier les erreurs à une décision et à ses limites | [11](#exercice-11), [12](#exercice-12) | Capsule 4 |

Chaque corrigé des exercices 5 à 12 peut s’exécuter séparément dans une session R neuve. Les calculs utilisent R de base; `knitr::kable()`, fourni avec l’environnement Quarto du cours, présente les résultats sous forme de tableaux. L’[exercice 13](#exercice-13) est un complément distinct sur Holt et précise sa préparation. Ces pratiques ne créent pas de troisième rapport.

## Exercice 5 - La dernière semaine raconte-t-elle toute l’histoire?

Niveau : consolidation.

Deux entrepôts fictifs de Québec distribuent la même pièce. Leurs demandes hebdomadaires, en unités, sont les suivantes :

| Semaine | Entrepôt A | Entrepôt B |
|---------|-----------:|-----------:|
| 1       |        100 |        100 |
| 2       |        100 |        100 |
| 3       |        100 |        100 |
| 4       |        160 |        100 |
| 5       |        160 |        100 |
| 6       |        160 |        160 |

À la fin de la semaine 6, chaque responsable prépare les trois semaines suivantes. Les observations futures sont inconnues. La règle du module consiste à répéter la dernière moyenne arrière disponible :

\\ m_6^{(k)}=\frac{1}{k}\sum\_{j=0}^{k-1}y\_{6-j}, \qquad \widehat y\_{6+h\mid6}=m_6^{(k)},\quad h=1,2,3. \\

1.  Pour chaque entrepôt, calculez MM2, MM4 et la référence naïve. Pourquoi la référence naïve ne distingue-t-elle pas les deux historiques?
2.  Donnez les trois prévisions de la règle MM4. Faut-il attendre la demande de la semaine 7 pour produire celle de la semaine 8 dans ce protocole?
3.  Si la hausse correspond à un changement durable, quel compromis pose la fenêtre longue? Si la semaine 6 correspond à une commande exceptionnelle, quel autre risque pose la fenêtre courte?
4.  Peut-on déterminer la meilleure fenêtre avec les seuls historiques fournis? Nommez une information à demander avant de conseiller la responsable de l’entrepôt B.

> **TIP:**
>
> Pour A, les quatre dernières demandes sont 100, 160, 160 et 160; pour B, elles sont 100, 100, 100 et 160. Ainsi,
>
> \\ m\_{6,A}^{(4)}=\frac{580}{4}=145, \qquad m\_{6,B}^{(4)}=\frac{460}{4}=115. \\
>
> | Méthode | A : prévision en unités | B : prévision en unités |
> |---------|------------------------:|------------------------:|
> | MM2     |                     160 |                     130 |
> | MM4     |                     145 |                     115 |
> | Naïf    |                     160 |                     160 |
>
> La référence naïve utilise seulement la dernière observation, identique dans les deux entrepôts. MM4 conserve davantage d’information sur les semaines précédentes. Depuis l’origine 6, elle donne 145, 145, 145 pour A et 115, 115, 115 pour B. Les trois valeurs sont émises ensemble : une mise à jour après observation de la semaine 7 changerait le protocole.
>
> Une fenêtre longue peut rester en retard après une hausse durable. Une fenêtre courte réagit davantage à une commande isolée et peut maintenir une prévision trop élevée si la demande revient ensuite à son niveau habituel. Les six observations ne permettent pas de trancher entre ces explications. Pour B, on pourrait demander si la dernière commande correspond à un nouveau contrat, à une promotion ponctuelle ou à un déplacement de livraison.
>
> Le calcul suivant reproduit les trois références, sans données externes :
>
> ``` r
> demandes_5 <- list(
>   A = c(100, 100, 100, 160, 160, 160),
>   B = c(100, 100, 100, 100, 100, 160)
> )
> references_5 <- function(y) {
>   c(MM2 = mean(tail(y, 2)), MM4 = mean(tail(y, 4)),
>     Naif = tail(y, 1))
> }
> resultats_5 <- as.data.frame(t(vapply(demandes_5, references_5, numeric(3))))
> knitr::kable(resultats_5, col.names = c("MM2", "MM4", "Naïf"), caption = "Prévisions émises à la fin de la semaine 6, en unités")
> ```
>
> |     | MM2 | MM4 | Naïf |
> |:----|----:|----:|-----:|
> | A   | 160 | 145 |  160 |
> | B   | 130 | 115 |  160 |
>
> Prévisions émises à la fin de la semaine 6, en unités {.caption-top .table .table-sm .table-striped .small}
>
> ``` r
> knitr::kable(data.frame(
>   Horizon = 1:3, A = rep(resultats_5["A", "MM4"], 3),
>   B = rep(resultats_5["B", "MM4"], 3)
> ), caption = "Trois prévisions MM4 préparées ensemble, en unités")
> ```
>
> | Horizon |   A |   B |
> |--------:|----:|----:|
> |       1 | 145 | 115 |
> |       2 | 145 | 115 |
> |       3 | 145 | 115 |
>
> Trois prévisions MM4 préparées ensemble, en unités {.caption-top .table .table-sm .table-striped .small}
>
> Erreur fréquente : choisir MM2 parce qu’elle est la plus proche de la dernière valeur. Cette proximité décrit sa réactivité; elle ne mesure pas encore son erreur de prévision.

## Exercice 6 - Quand le calcul est-il possible?

Niveau : application et lecture critique.

Un fournisseur fictif de pièces doit prévoir les demandes des semaines 5 à 7 à la fin de la semaine 4. Les valeurs suivantes sont connues à cette origine :

| Semaine           |   1 |   2 |   3 |   4 |
|-------------------|----:|----:|----:|----:|
| Demande en unités | 100 | 110 | 120 | 130 |

Les demandes des semaines 5, 6 et 7, révélées ensuite pour l’évaluation, valent 140, 150 et 160 unités. Trois calculs sont proposés :

\\ \begin{aligned} \text{A : }a_t&=\frac{y_t+y\_{t-1}+y\_{t-2}+y\_{t-3}}{4},\\\[0.3em\] \text{B : }b_t&=\frac{y\_{t-1}+y\_{t-2}+y\_{t-3}+y\_{t-4}}{4},\\\[0.3em\] \text{C : }\widehat y\_{4+h\mid4}&=\frac{y_4+y_3+y_2+y_1}{4},\quad h=1,2,3. \end{aligned} \\

Dans B, le calcul est refait avant chaque semaine à prévoir, après réception des demandes précédentes.

1.  Calculez les trois séries de valeurs pour les semaines 5 à 7, puis leurs écarts absolus moyens par rapport aux demandes observées.
2.  Quel calcul contient la cible qu’il prétend prévoir? Pourquoi peut-il néanmoins servir à décrire une série après observation?
3.  B et C sont-ils tous deux réalisables? Répondent-ils à la même décision prise à la fin de la semaine 4?
4.  Remplacer A par une moyenne centrée \\(y\_{t-1}+y_t+y\_{t+1})/3\\ résoudrait-il le problème de disponibilité?

> **TIP:**
>
> | Calcul | Semaine 5 | Semaine 6 | Semaine 7 | MAE en unités |
> |----|---:|---:|---:|---:|
> | A : contient la cible | 125 | 135 | 145 | 15 |
> | B : mises à jour successives | 115 | 125 | 135 | 25 |
> | C : trois prévisions à l’origine 4 | 115 | 115 | 115 | 35 |
>
> A obtient le plus petit nombre, mais ce n’est pas une prévision disponible avant la cible : \\a_5\\ utilise déjà \\y_5=140\\, et les calculs suivants font de même. C’est une moyenne arrière descriptive, disponible après la semaine concernée. La présenter comme une prévision émise avant cette semaine crée une fuite d’information.
>
> B est réalisable si l’on attend chaque nouvelle observation avant de prévoir à un pas. Ainsi, \\b_6\\ utilise \\y_5\\, connu à la fin de la semaine 5. C est réalisable pour la décision initiale : toutes ses entrées sont connues à la fin de la semaine 4. Sa MAE vaut
>
> \\ \operatorname{MAE}\_C=\frac{\|140-115\|+\|150-115\|+\|160-115\|}{3} =35\\ \text{unités}. \\
>
> La MAE plus faible de B ne démontre pas une meilleure méthode pour les trois prévisions exigées à l’origine 4 : B dispose d’informations supplémentaires aux deuxième et troisième décisions. La moyenne centrée ajoute même une observation postérieure à la cible; elle ne corrige donc pas le problème.
>
> ``` r
> demandes_6 <- c(100, 110, 120, 130, 140, 150, 160)
> cibles_6 <- 5:7
> calcul_a_6 <- vapply(cibles_6, function(t) {
>   mean(demandes_6[(t - 3):t])
> }, numeric(1))
> calcul_b_6 <- vapply(cibles_6, function(t) {
>   mean(demandes_6[(t - 4):(t - 1)])
> }, numeric(1))
> calcul_c_6 <- rep(mean(demandes_6[1:4]), length(cibles_6))
> comparaison_6 <- data.frame(
>   Calcul = c("A : contient la cible", "B : origines successives", "C : origine 4"),
>   Semaine_5 = c(calcul_a_6[1], calcul_b_6[1], calcul_c_6[1]),
>   Semaine_6 = c(calcul_a_6[2], calcul_b_6[2], calcul_c_6[2]),
>   Semaine_7 = c(calcul_a_6[3], calcul_b_6[3], calcul_c_6[3]),
>   MAE = vapply(list(calcul_a_6, calcul_b_6, calcul_c_6), function(p) {
>     mean(abs(demandes_6[cibles_6] - p))
>   }, numeric(1))
> )
> knitr::kable(comparaison_6, row.names = FALSE,
>              col.names = c("Calcul", "Semaine 5", "Semaine 6", "Semaine 7", "MAE (unités)"),
>              caption = "Trois calculs, mais deux protocoles réalisables distincts")
> ```
>
> | Calcul                   | Semaine 5 | Semaine 6 | Semaine 7 | MAE (unités) |
> |:-------------------------|----------:|----------:|----------:|-------------:|
> | A : contient la cible    |       125 |       135 |       145 |           15 |
> | B : origines successives |       115 |       125 |       135 |           25 |
> | C : origine 4            |       115 |       115 |       115 |           35 |
>
> Trois calculs, mais deux protocoles réalisables distincts {.caption-top .table .table-sm .table-striped .small}
>
> Erreur fréquente : classer les trois lignes par MAE sans examiner leurs dates de disponibilité.

## Exercice 7 - Comment le niveau réagit-il à un pic?

Niveau : consolidation, puis interprétation.

Un atelier fictif consomme habituellement 120 unités d’un produit par semaine. Son niveau initial est fixé à \\\ell_0=120\\. Deux observations arrivent : \\y_1=180\\, puis \\y_2=120\\. On veut comparer un lissage modéré, \\\alpha=0{,}25\\, et un lissage plus réactif, \\\alpha=0{,}75\\.

\\ \ell_t=\alpha y_t+(1-\alpha)\ell\_{t-1}. \\

1.  Calculez \\\ell_1\\ et \\\ell_2\\ pour les deux valeurs d’\\\alpha\\, en conservant le même niveau initial.
2.  À l’origine 2, donnez les trois prévisions du SES pour les semaines 3, 4 et 5.
3.  Comparez les deux niveaux finaux, puis les deux niveaux après la première semaine. Que vous apprend cette comparaison sur la réaction au pic?
4.  Pourquoi une initialisation différente compliquerait-elle cette comparaison? Ces deux observations suffisent-elles à choisir un \\\alpha\\ pour les prochaines semaines?

> **TIP:**
>
> Pour \\\alpha=0{,}25\\,
>
> \\ \ell_1=0{,}25(180)+0{,}75(120)=135, \qquad \ell_2=0{,}25(120)+0{,}75(135)=131{,}25. \\
>
> Pour \\\alpha=0{,}75\\,
>
> \\ \ell_1=0{,}75(180)+0{,}25(120)=165, \qquad \ell_2=0{,}75(120)+0{,}25(165)=131{,}25. \\
>
> Depuis l’origine 2, les deux SES donnent donc 131,25 unités aux trois horizons. Cette coïncidence ne rend pas leurs réactions identiques : le second monte de 45 unités après la première observation, contre 15 pour le premier, puis redescend beaucoup plus vite. Le SES prolonge son dernier niveau; il ne prévoit pas à lui seul une pente ni un motif saisonnier.
>
> Le graphique permet de comparer les chemins, et pas seulement le dernier point :
>
> ``` r
> niveau_initial_7 <- 120
> observations_7 <- c(180, 120)
> calculer_niveaux_7 <- function(alpha) {
>   niveaux <- c(niveau_initial_7, numeric(length(observations_7)))
>   for (t in seq_along(observations_7)) {
>     niveaux[t + 1] <- alpha * observations_7[t] + (1 - alpha) * niveaux[t]
>   }
>   niveaux
> }
> niveaux_7 <- cbind(calculer_niveaux_7(0.25), calculer_niveaux_7(0.75))
> knitr::kable(data.frame(
>   Etape = c("État initial", "Après la semaine 1", "Après la semaine 2"),
>   `Alpha = 0,25` = niveaux_7[, 1],
>   `Alpha = 0,75` = niveaux_7[, 2], check.names = FALSE
> ), digits = 2, format.args = list(decimal.mark = ","))
> ```
>
> | Etape              | Alpha = 0,25 | Alpha = 0,75 |
> |:-------------------|-------------:|-------------:|
> | État initial       |       120,00 |       120,00 |
> | Après la semaine 1 |       135,00 |       165,00 |
> | Après la semaine 2 |       131,25 |       131,25 |
>
> ``` r
> matplot(0:2, niveaux_7, type = "b", pch = c(16, 17), lty = c(1, 2),
>         col = c("#075572", "#b40012"), ylim = c(115, 185), xaxt = "n",
>         xlab = "Étape de mise à jour", ylab = "Niveau lissé (unités)")
> axis(1, at = 0:2, labels = c("Initial", "Semaine 1", "Semaine 2"))
> legend("topleft", legend = c("Alpha = 0,25", "Alpha = 0,75"),
>        col = c("#075572", "#b40012"), pch = c(16, 17), lty = c(1, 2), bty = "n")
> ```
>
> ![Après une observation de 180 puis une de 120, les niveaux passent par 135 et 165 avant de se rejoindre à 131,25.](exercices_files/figure-html/pratique-7-m07-1.png)
>
> Une initialisation commune permet d’attribuer les différences calculées au seul choix d’\\\alpha\\. Les deux observations ne constituent pas une validation suffisante pour choisir ce paramètre. Un pic ponctuel et un changement durable appellent des interprétations différentes, à vérifier avec le contexte et de nouvelles cibles.

## Exercice 8 - Une même MAE, mais des urgences différentes

Niveau : application.

Un distributeur fictif compare deux prévisions préparées à la même origine pour six semaines de livraison. Les demandes et les prévisions sont en unités de produit :

| Semaine | Demande observée | Prévision A | Prévision B |
|---------|-----------------:|------------:|------------:|
| 1       |              200 |         188 |         200 |
| 2       |              220 |         208 |         220 |
| 3       |              210 |         198 |         210 |
| 4       |              240 |         228 |         240 |
| 5       |              230 |         218 |         230 |
| 6       |              260 |         248 |         188 |

Pour ce scénario seulement, une sous-prévision strictement supérieure à 30 unités déclenche un transport urgent. Les autres coûts ne sont pas fournis. On conserve la convention \\e_h=y\_{T+h}-\widehat y\_{T+h\mid T}\\ et les mesures

\\ \operatorname{MAE}=\frac{1}{6}\sum\_{h=1}^{6}\|e_h\|, \qquad \operatorname{RMSE}=\sqrt{\frac{1}{6}\sum\_{h=1}^{6}e_h^2}. \\

1.  Retrouvez les six erreurs de chaque méthode, puis calculez MAE et RMSE.
2.  La MAE seule permet-elle de distinguer les méthodes? Quelle information la RMSE ajoute-t-elle ici?
3.  Comptez les semaines qui déclenchent un transport urgent selon la règle fournie.
4.  Quelle méthode évite ces transports sur ces six cibles? Dispose-t-on d’assez d’information pour affirmer qu’elle minimise tous les coûts futurs?

> **TIP:**
>
> Les erreurs de A valent \\(12,12,12,12,12,12)\\; celles de B valent \\(0,0,0,0,0,72)\\. Les deux sommes d’erreurs absolues valent 72 unités, donc les MAE valent toutes deux 12 unités. En revanche,
>
> \\ \operatorname{RMSE}\_A=12, \qquad \operatorname{RMSE}\_B=\sqrt{\frac{72^2}{6}} =12\sqrt{6}\approx29{,}39\\ \text{unités}. \\
>
> La RMSE est plus sensible à la concentration de l’erreur sur la dernière semaine. La règle de transport compte zéro dépassement pour A et un pour B. A évite donc le transport urgent sur ces cibles, même si sa MAE est identique à celle de B. Les nombres ne suffisent pas à comparer tous les coûts : le prix du transport, les autres contraintes et la stabilité du résultat ne sont pas fournis.
>
> ``` r
> observe_8 <- c(200, 220, 210, 240, 230, 260)
> previsions_8 <- list(A = c(188, 208, 198, 228, 218, 248),
>                     B = c(200, 220, 210, 240, 230, 188))
> resumer_8 <- function(prevision) {
>   erreur <- observe_8 - prevision
>   c(MAE = mean(abs(erreur)), RMSE = sqrt(mean(erreur^2)),
>     Semaines_urgentes = sum(erreur > 30))
> }
> resultats_8 <- as.data.frame(t(vapply(previsions_8, resumer_8, numeric(3))))
> knitr::kable(resultats_8, digits = 2,
>              col.names = c("MAE", "RMSE", "Semaines avec transport urgent"),
>              format.args = list(decimal.mark = ","),
>              caption = "Erreurs en unités; nombre de transports selon le scénario")
> ```
>
> |     | MAE |  RMSE | Semaines avec transport urgent |
> |:----|----:|------:|-------------------------------:|
> | A   |  12 | 12,00 |                              0 |
> | B   |  12 | 29,39 |                              1 |
>
> Erreurs en unités; nombre de transports selon le scénario {.caption-top .table .table-sm .table-striped .small}
>
> Erreur fréquente : conclure que deux méthodes de même MAE rendent le même service. La répartition des erreurs et les règles de décision comptent aussi.

## Exercice 9 - Zéro en moyenne, mais huit mois à examiner

Niveau : interprétation et changement d’unité.

Deux prévisions de consommation électrique ont été comparées sur les mêmes huit mois dans un bâtiment fictif. Les erreurs, en kWh, sont données ci-dessous. Une erreur positive signifie que la consommation observée dépasse la prévision.

| Mois    | Erreur A (kWh) | Erreur B (kWh) |
|---------|---------------:|---------------:|
| Janvier |         -2 000 |         -2 000 |
| Février |         -2 000 |          2 000 |
| Mars    |         -2 000 |         -2 000 |
| Avril   |         -2 000 |          2 000 |
| Mai     |          2 000 |         -2 000 |
| Juin    |          2 000 |          2 000 |
| Juillet |          2 000 |         -2 000 |
| Août    |          2 000 |          2 000 |

1.  Calculez ME, MAE et RMSE pour A et B. Exprimez ensuite les trois mesures en MWh.
2.  Tracez les erreurs dans l’ordre des mois. Que manque-t-il aux trois scores pour distinguer les deux situations?
3.  Dans A, à partir de quel mois passe-t-on d’une sur-prévision à une sous-prévision persistante? Dans B, quel autre motif mérite une vérification?
4.  Révisez l’affirmation : « La ME est nulle, donc la méthode ne se trompe pas et ses erreurs sont indépendantes. »

> **TIP:**
>
> Dans chaque série, quatre erreurs valent \\-2\\000\\ et quatre valent \\2\\000\\. Ainsi,
>
> \\ \operatorname{ME}=0\\ \text{kWh},\qquad \operatorname{MAE}=2\\000\\ \text{kWh},\qquad \operatorname{RMSE}=2\\000\\ \text{kWh}. \\
>
> Comme \\1\\ \text{MWh}=1\\000\\ \text{kWh}\\, on obtient 0, 2 et 2 MWh. Le changement d’unité ne change pas les erreurs; il change leur expression numérique.
>
> Les scores sont identiques parce qu’ils ne conservent pas l’ordre des mois. A surestime la consommation pendant les quatre premiers mois, puis la sous-estime à partir de mai. B alterne entre les deux signes. Ces motifs invitent à examiner le calendrier, les changements d’usage et les données. Aucun des deux ne démontre, à lui seul, une cause précise ni l’indépendance des erreurs.
>
> ``` r
> erreurs_9 <- list(A = c(rep(-2000, 4), rep(2000, 4)),
>                   B = rep(c(-2000, 2000), 4))
> mesurer_9 <- function(e) {
>   c(ME = mean(e), MAE = mean(abs(e)), RMSE = sqrt(mean(e^2)))
> }
> mesures_kwh_9 <- t(vapply(erreurs_9, mesurer_9, numeric(3)))
> knitr::kable(mesures_kwh_9, caption = "Mesures en kWh")
> ```
>
> |     |  ME |  MAE | RMSE |
> |:----|----:|-----:|-----:|
> | A   |   0 | 2000 | 2000 |
> | B   |   0 | 2000 | 2000 |
>
> Mesures en kWh {.caption-top .table .table-sm .table-striped .small}
>
> ``` r
> knitr::kable(mesures_kwh_9 / 1000, caption = "Les mêmes mesures en MWh")
> ```
>
> |     |  ME | MAE | RMSE |
> |:----|----:|----:|-----:|
> | A   |   0 |   2 |    2 |
> | B   |   0 |   2 |    2 |
>
> Les mêmes mesures en MWh {.caption-top .table .table-sm .table-striped .small}
>
> ``` r
> parametres_9 <- par(mfrow = c(1, 2), mar = c(5.5, 4, 2, 1))
> for (nom in names(erreurs_9)) {
>   plot(1:8, erreurs_9[[nom]] / 1000, type = "b", pch = 16,
>        col = "#075572", ylim = c(-3, 3), xaxt = "n",
>        xlab = "Mois", ylab = "Erreur (MWh)", main = paste("Méthode", nom))
>   axis(1, at = 1:8, labels = c("Janv.", "Févr.", "Mars", "Avr.", "Mai", "Juin", "Juill.", "Août"), las = 2, cex.axis = 0.85)
>   abline(h = 0, lty = 2, col = "grey50")
> }
> ```
>
> ![La série A garde quatre erreurs négatives puis quatre positives. La série B alterne les signes. Les deux moyennes sont nulles.](exercices_files/figure-html/pratique-9-m07-1.png)
>
> ``` r
> par(parametres_9)
> ```
>
> Une reformulation acceptable serait : « Les signes se compensent sur les huit mois, mais chaque prévision s’écarte ici de 2 MWh de l’observation. Les suites de même signe dans A et l’alternance dans B demandent une analyse du calendrier. Une ME empirique nulle ne prouve ni une absence de biais futur ni l’indépendance. »

## Exercice 10 - Les semaines sans demande comptent aussi

Niveau : application et lecture critique.

Un service de maintenance fictif prévoit la demande hebdomadaire d’une pièce de rechange. Deux règles ont produit les prévisions suivantes à une même origine :

| Semaine | Demande observée | Prévision A | Prévision B |
|---------|-----------------:|------------:|------------:|
| 1       |                0 |          40 |           0 |
| 2       |              100 |          98 |          90 |
| 3       |              100 |          98 |          90 |
| 4       |              100 |          98 |          90 |

Un analyste propose de retirer la première semaine pour calculer

\\ \operatorname{MAPE}=\frac{100}{H}\sum\_{h=1}^{H} \left\|\frac{y\_{T+h}-\widehat y\_{T+h\mid T}}{y\_{T+h}}\right\|. \\

1.  Calculez les MAE des deux règles sur les quatre semaines. Vérifiez leurs RMSE avec R.
2.  Pourquoi le MAPE est-il indéfini sur l’ensemble annoncé, y compris pour B qui prévoit correctement zéro?
3.  Calculez les pourcentages moyens en conservant seulement les semaines où la demande est positive. Ce classement répond-il à la question de précision sur les quatre semaines?
4.  L’échelle de référence calculée sur l’apprentissage vaut \\q=10\\ unités. Calculez les deux MASE à partir des MAE sur les quatre semaines. Pourquoi les cibles nulles ne posent-elles pas ici le même problème?

> **TIP:**
>
> Les erreurs sont \\(-40,2,2,2)\\ pour A et \\(0,10,10,10)\\ pour B. On obtient
>
> \\ \operatorname{MAE}\_A=\frac{40+2+2+2}{4}=11{,}5, \qquad \operatorname{MAE}\_B=\frac{0+10+10+10}{4}=7{,}5. \\
>
> Les RMSE sont d’environ 20,07 et 8,66 unités. B a les plus petites MAE et RMSE sur les quatre semaines. Prévoir 40 unités lorsque la demande est nulle contribue à l’erreur de A; cette semaine ne disparaît pas du besoin de gestion.
>
> Le MAPE divise par chaque observation : \\40/0\\ pour A et \\0/0\\ pour B ne donnent pas de pourcentage d’erreur défini. Sur les trois seules semaines de demande positive, les pourcentages moyens valent 2 % pour A et 10 % pour B. Ils décrivent donc une question restreinte, qui favorise A, mais ne résument pas l’ensemble des quatre cibles. On peut étudier ce sous-ensemble s’il est annoncé et justifié; il ne doit pas remplacer silencieusement la comparaison complète.
>
> Avec la même échelle d’apprentissage positive pour les deux règles,
>
> \\ \operatorname{MASE}\_A=\frac{11{,}5}{10}=1{,}15, \qquad \operatorname{MASE}\_B=\frac{7{,}5}{10}=0{,}75. \\
>
> La MASE divise par \\q\\, et non par chaque demande de validation. Elle est donc définie ici. Si \\q\\ était nul, elle ne le serait plus. Pour comparer A et B, on conserve le même \\q\\ et les mêmes quatre cibles.
>
> ``` r
> observe_10 <- c(0, 100, 100, 100)
> previsions_10 <- list(A = c(40, 98, 98, 98), B = c(0, 90, 90, 90))
> echelle_10 <- 10
> mesurer_10 <- function(prevision) {
>   e <- observe_10 - prevision
>   demande_positive <- observe_10 > 0
>   c(MAE = mean(abs(e)), RMSE = sqrt(mean(e^2)),
>     MAPE_complet = if (any(observe_10 == 0)) NA_real_ else
>       100 * mean(abs(e / observe_10)),
>     MAPE_semaines_positives = 100 * mean(abs(e[demande_positive] /
>                                               observe_10[demande_positive])),
>     MASE = mean(abs(e)) / echelle_10)
> }
> resultats_10 <- as.data.frame(t(vapply(previsions_10, mesurer_10, numeric(5))))
> knitr::kable(resultats_10, digits = 2,
>              col.names = c("MAE", "RMSE", "MAPE complet (%)", "MAPE des semaines positives (%)", "MASE"),
>              format.args = list(decimal.mark = ","),
>              caption = "MAE et RMSE en unités; MAPE en pourcentage; MASE sans unité")
> ```
>
> |     |  MAE |  RMSE | MAPE complet (%) | MAPE des semaines positives (%) | MASE |
> |:----|-----:|------:|-----------------:|--------------------------------:|-----:|
> | A   | 11,5 | 20,07 |               NA |                               2 | 1,15 |
> | B   |  7,5 |  8,66 |               NA |                              10 | 0,75 |
>
> MAE et RMSE en unités; MAPE en pourcentage; MASE sans unité {.caption-top .table .table-sm .table-striped .small}
>
> Dans le tableau R, `NA` désigne ici une mesure non définie, et non une observation manquante.
>
> Erreur fréquente : remplacer un MAPE non défini par zéro, ou annoncer que A est globalement meilleure après avoir retiré la semaine où elle se trompe le plus.

## Exercice 11 - Quel coût donne-t-on à chaque erreur?

Niveau : décision et calcul.

Deux méthodes prévoient la demande d’un produit dans un centre de distribution fictif. Sur quatre semaines communes, A surestime chaque demande de 10 unités; B sous-estime chaque demande de 8 unités. Les prévisions ont été émises à la même origine. On compare le coût moyen pédagogique

\\ L(e)=c\_{\mathrm{sous}}\max(e,0)+c\_{\mathrm{sur}}\max(-e,0), \qquad e=y-\widehat y. \\

Les coefficients sont des unités de coût fictives par unité de produit. Ils ne sont pas déduits des erreurs observées.

1.  Calculez les deux MAE. Quelle méthode ce critère favorise-t-il?
2.  Comparez les coûts moyens avec \\c\_{\mathrm{sous}}=2\\ et \\c\_{\mathrm{sur}}=1\\, puis avec \\c\_{\mathrm{sous}}=1\\ et \\c\_{\mathrm{sur}}=2\\.
3.  Pour quel rapport \\c\_{\mathrm{sous}}/c\_{\mathrm{sur}}\\ les deux méthodes ont-elles le même coût? Supposez les deux coefficients strictement positifs.
4.  Quel scénario pourrait correspondre à une rupture coûteuse? Lequel pourrait correspondre à un produit périssable coûteux à conserver? Quelles informations faudrait-il confirmer avant de retenir ces coefficients?

> **TIP:**
>
> Les erreurs valent \\-10\\ pour A et \\8\\ pour B à chaque semaine. La MAE favorise B : 8 unités contre 10. Leurs coûts moyens sont cependant
>
> \\ \overline L_A=10c\_{\mathrm{sur}},\qquad \overline L_B=8c\_{\mathrm{sous}}. \\
>
> | Coût d’une sous-prévision | Coût d’une sur-prévision | A : coût moyen | B : coût moyen | Préférence sur ces cibles |
> |----|----|---:|---:|----|
> | 2 | 1 | 10 | 16 | A |
> | 1 | 2 | 20 | 8 | B |
>
> L’égalité \\10c\_{\mathrm{sur}}=8c\_{\mathrm{sous}}\\ donne
>
> \\ \frac{c\_{\mathrm{sous}}}{c\_{\mathrm{sur}}}=\frac{10}{8}=1{,}25. \\
>
> Au-dessus de ce rapport, A a le coût le plus faible parmi ces deux candidats; en dessous, B l’emporte. Une rupture de stock coûteuse peut rendre la sous-prévision plus pénalisante. Une perte sur produit périssable peut donner davantage de poids à la sur-prévision. Il faut cependant confirmer les montants, les délais, le stock, les possibilités de rattrapage et la pertinence d’un coût linéaire avec la personne responsable.
>
> ``` r
> erreurs_11 <- list(A = rep(-10, 4), B = rep(8, 4))
> cout_moyen_11 <- function(e, cout_sous, cout_sur) {
>   mean(cout_sous * pmax(e, 0) + cout_sur * pmax(-e, 0))
> }
> resultats_11 <- data.frame(
>   Methode = names(erreurs_11),
>   MAE = vapply(erreurs_11, function(e) mean(abs(e)), numeric(1)),
>   Sous_2_sur_1 = vapply(erreurs_11, cout_moyen_11, numeric(1),
>                         cout_sous = 2, cout_sur = 1),
>   Sous_1_sur_2 = vapply(erreurs_11, cout_moyen_11, numeric(1),
>                         cout_sous = 1, cout_sur = 2)
> )
> knitr::kable(resultats_11, row.names = FALSE,
>              col.names = c("Méthode", "MAE", "Sous : 2; sur : 1", "Sous : 1; sur : 2"),
>              caption = "MAE en unités de produit et deux scénarios de coût moyen")
> ```
>
> | Méthode | MAE | Sous : 2; sur : 1 | Sous : 1; sur : 2 |
> |:--------|----:|------------------:|------------------:|
> | A       |  10 |                10 |                20 |
> | B       |   8 |                16 |                 8 |
>
> MAE en unités de produit et deux scénarios de coût moyen {.caption-top .table .table-sm .table-striped .small}
>
> Erreur fréquente : annoncer les coefficients après avoir regardé quel scénario favorise sa méthode. La comparaison ne fournit pas non plus une quantité optimale à commander : elle porte sur deux prévisions et sur les pertes spécifiées.

## Exercice 12 - Un gain de 1 % justifie-t-il un changement?

Niveau : synthèse.

Une équipe fictive compare une règle simple à une nouvelle méthode sur les treize mêmes semaines. Cette période a déjà servi à choisir la nouvelle méthode parmi plusieurs variantes. Les scores fournis sont les suivants :

| Critère                    | Règle simple |       Nouvelle méthode |
|----------------------------|-------------:|-----------------------:|
| MAE (unités)               |          100 |                     99 |
| RMSE (unités)              |          120 |                    140 |
| Abonnement requis          |        Aucun |      40 \$ par semaine |
| Maintenance supplémentaire |       Aucune | 30 minutes par semaine |

Les coûts réels des erreurs et la valeur du temps de maintenance ne sont pas fournis. Le critère annoncé avant la comparaison était la MAE.

1.  Calculez la baisse absolue et relative de MAE, puis la variation relative de RMSE.
2.  Si l’on applique le critère annoncé, quelle méthode arrive en tête? Pourquoi faut-il tout de même signaler la RMSE et les frais?
3.  Révisez cette note : « La baisse de 1 % prouve que 99 % des prévisions sont correctes. Ce test indépendant confirme une supériorité définitive et rentabilise automatiquement l’abonnement. »
4.  Proposez une recommandation de quatre ou cinq phrases : résultat observé, compromis, limite et prochaine vérification. N’inventez ni économie financière ni intervalle d’incertitude.

> **TIP:**
>
> La MAE baisse de \\100-99=1\\ unité par cible, soit \\(100-99)/100=1\\\\\\. La RMSE augmente de 20 unités, soit \\20/120\approx16{,}7\\\\\\. La nouvelle méthode arrive en tête pour la MAE annoncée. Le score de RMSE invite à examiner les grandes erreurs; il ne faut ni le cacher ni remplacer après coup le critère initial pour imposer une autre conclusion.
>
> Une MAE de 99 unités n’est pas une proportion de prévisions correctes. Les treize semaines ont servi au choix : elles ne constituent pas un nouveau test indépendant de ce choix. Enfin, une unité de baisse de MAE n’a pas de valeur financière donnée ici. Elle ne suffit donc pas à établir que les frais de 40 \$ par semaine et le travail de maintenance sont rentables.
>
> ``` r
> comparaison_12 <- data.frame(
>   Mesure = c("MAE", "RMSE"), Simple = c(100, 120), Nouvelle = c(99, 140)
> )
> comparaison_12$Variation_unites <- comparaison_12$Nouvelle - comparaison_12$Simple
> comparaison_12$Variation_pourcent <- 100 * comparaison_12$Variation_unites /
>   comparaison_12$Simple
> knitr::kable(comparaison_12, digits = 2,
>              col.names = c("Mesure", "Règle simple", "Nouvelle méthode", "Variation (unités)", "Variation (%)"),
>              format.args = list(decimal.mark = ","),
>              caption = "Variation = nouvelle méthode moins règle simple")
> ```
>
> | Mesure | Règle simple | Nouvelle méthode | Variation (unités) | Variation (%) |
> |:-------|-------------:|-----------------:|-------------------:|--------------:|
> | MAE    |          100 |               99 |                 -1 |         -1,00 |
> | RMSE   |          120 |              140 |                 20 |         16,67 |
>
> Variation = nouvelle méthode moins règle simple {.caption-top .table .table-sm .table-striped .small}
>
> Une note acceptable serait : « Sur les treize semaines déjà utilisées pour le choix, la nouvelle méthode réduit la MAE de 1 unité, soit 1 %. Elle a toutefois une RMSE plus élevée de 20 unités et demande un abonnement ainsi qu’une maintenance supplémentaire. Le résultat favorise cette méthode pour la MAE annoncée, sans démontrer un gain financier ni une supériorité future. Avant de la déployer, nous proposons d’examiner les grandes erreurs et de chiffrer les conséquences de sous-prévision, de sur-prévision et de maintenance. La comparaison sera ensuite reprise sur de nouvelles origines communes, avec les candidats et critères fixés à l’avance. »
>
> On peut aussi défendre le maintien provisoire de la règle simple si l’on explique le compromis et les informations manquantes. Ce choix ne doit pas être présenté comme la preuve que la méthode simple est universellement meilleure.

## Exercice 13 - Holt accompagné (facultatif)

Niveau : prolongement accompagné.

Après la [lecture sur Holt](../../modules/semaine-07-lissage/lectures.llms.md#holt), exécutez la [préparation commune](#preparation). Ce corrigé dépend seulement de cette préparation, pas des solutions 1 à 4. Le code d’ajustement est fourni : aucun calcul manuel des récurrences de Holt n’est demandé.

1.  Ajustez Holt avec une tendance amortie sur les 60 mois d’apprentissage. Comparez ses douze prévisions au naïf saisonnier sur les mêmes mois de 2025, avec les mêmes coefficients de coût.
2.  Comparez les MAE et les coûts moyens. Le fait d’ajouter une pente garantit-il un gain?
3.  Holt amorti représente-t-il ici une saisonnalité annuelle? Cette méthode doit-elle s’ajouter aux cinq candidats du rapport principal?

> **TIP:**
>
> ``` r
> modele_holt_e <- holt(serie_e, h = horizon_e, damped = TRUE)
> modele_saisonnier_13 <- snaive(serie_e, h = horizon_e)
> comparaison_holt_13 <- bind_rows(
>   mesures_erreurs(validation_e$consommation_kwh,
>                   as.numeric(modele_holt_e$mean), cout_sous = 2, cout_sur = 1) |>
>     mutate(methode = "Holt amorti"),
>   mesures_erreurs(validation_e$consommation_kwh,
>                   as.numeric(modele_saisonnier_13$mean), cout_sous = 2, cout_sur = 1) |>
>     mutate(methode = "Naïf saisonnier")
> ) |>
>   select(methode, MAE, RMSE, cout_moyen)
> knitr::kable(comparaison_holt_13, digits = 1,
>              col.names = c("Méthode", "MAE (kWh)", "RMSE (kWh)", "Coût moyen"),
>              format.args = list(decimal.mark = ",", big.mark = "\u00a0"),
>              caption = "Erreurs en kWh et coût pédagogique moyen par mois")
> ```
>
> | Méthode         | MAE (kWh) | RMSE (kWh) | Coût moyen |
> |:----------------|----------:|-----------:|-----------:|
> | Holt amorti     |  87 355,1 |   96 691,6 |   88 023,1 |
> | Naïf saisonnier |   6 662,3 |    7 987,1 |   11 519,8 |
>
> Erreurs en kWh et coût pédagogique moyen par mois {.caption-top .table .table-sm .table-striped .small}
>
> Holt amorti obtient une MAE d’environ 87 355 kWh et un coût moyen de 88 023 unités fictives par mois. Le naïf saisonnier obtient respectivement 6 662 kWh et 11 520 unités de coût par mois. Holt estime une pente dont l’effet diminue à mesure que l’horizon s’éloigne. Une pente amortie ne représente pas le cycle annuel de la consommation.
>
> Cet exercice reste facultatif et distinct du rapport principal. Il prolonge l’étude du lissage; Holt n’est pas un prérequis obligatoire du laboratoire 03.

## Auto-vérification

Je calcule une moyenne arrière et je précise quand elle est disponible.

Je distingue trois prévisions à une même origine de trois prévisions à un pas avec mise à jour.

Je peux expliquer l’effet d’\\\alpha\\ à partir de mises à jour intermédiaires.

Je relie les scores aux unités, à la répartition des erreurs et à leur ordre temporel.

Je conserve les cibles nulles dans la comparaison annoncée et je signale les mesures non définies.

Je justifie le critère de décision, ses coûts et les limites de la validation.

Je peux refaire une réponse sans recopier son corrigé.

## Sources et provenance

Les situations et nombres des exercices 5 à 12 sont fictifs et conçus pour l’enseignement. Les conventions et méthodes suivent les [lectures françaises du module](../../modules/semaine-07-lissage/lectures.llms.md), Hyndman et Athanasopoulos (2021), *Forecasting: Principles and Practice*, 3e édition, [chapitre 5 : évaluer les prévisions](https://otexts.com/fpp3/toolbox.html) et [chapitre 8 : lissage exponentiel](https://otexts.com/fpp3/exponential-smoothing.html). Les données du transfert et du complément Holt gardent leur provenance décrite dans les [dictionnaires](data/dictionnaires.md).
