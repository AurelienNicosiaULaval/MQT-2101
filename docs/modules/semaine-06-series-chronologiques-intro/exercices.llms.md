# Exercices et corrigés - Module 06

## Objectif

Appliquer le protocole des six capsules à un cas distinct de demande hebdomadaire. Les six premiers exercices construisent un seul rapport de transfert; les compléments 7 et 8 et les huit exercices supplémentaires sont facultatifs. Faites une première tentative avant de consulter le corrigé.

Les [corrigés des productions de fin de capsule](#corriges-capsules) portent sur le cas guidé d’électricité. Ils sont distincts des corrigés de transfert ci-dessous et chaque capsule y renvoie.

## Préparation

Jeu de données de transfert : [demande_hebdomadaire_quebec.csv](../atelier-03-series-chronologiques/data/demande_hebdomadaire_quebec.csv).

Ce cas de transfert porte sur la demande hebdomadaire d’un produit fictif, son prix et ses promotions. Il utilise les 104 observations déjà disponibles dans l’atelier 3; il est distinct du cas de consommation mensuelle d’électricité des capsules. Les données sont simulées, du 1er janvier 2024 au 22 décembre 2025. Une ligne représente une semaine, la demande est en unités de produit et le prix moyen en dollars canadiens par unité.

Décompressez le [projet `prevision-demande`](telechargements/prevision-demande.zip). Ouvrez le fichier `.Rproj`, puis `prevision_demande.qmd`. Tentez chaque question avant d’ouvrir son corrigé.

Fixez le protocole : les 91 premières semaines pour apprendre, les 13 dernières pour valider à l’origine de la semaine 91. Un décalage de 52 semaines est utilisé comme cycle approximatif de 364 jours; il ne garantit pas l’alignement des fêtes ou des années ISO de 53 semaines.

``` r
library(tidyverse)
library(forecast)
chemins_R <- c("R/analyse-module06.R",
               "modules/semaine-06-series-chronologiques-intro/R/analyse-module06.R")
source(chemins_R[file.exists(chemins_R)][1])
chemins <- c("data/demande_hebdomadaire_quebec.csv",
             "../atelier-03-series-chronologiques/data/demande_hebdomadaire_quebec.csv",
             "modules/atelier-03-series-chronologiques/data/demande_hebdomadaire_quebec.csv")
chemin <- chemins[file.exists(chemins)][1]
stopifnot(!is.na(chemin))
demande <- read_csv(chemin, show_col_types = FALSE) |>
  mutate(semaine = as.Date(semaine), promotion = factor(promotion)) |>
  arrange(semaine)
stopifnot(!anyNA(demande[c("semaine", "demande")]),
          !anyDuplicated(demande$semaine),
          all(as.numeric(diff(demande$semaine)) == 7))
apprentissage_demande <- demande |> slice_head(n = 91)
validation_demande <- demande |> slice_tail(n = 13)
```

## Exercice 1 - Cible et horizons

Une équipe planifie son personnel deux semaines à l’avance; le fournisseur exige une commande huit semaines à l’avance. Pour chaque décision, précisez origine, cible, unité, horizon et granularité. Expliquez pourquoi une seule valeur « prochaine période » est insuffisante.

> **TIP:**
>
> À la fin de la semaine 91, les cibles peuvent être la demande de la semaine 93 pour le personnel et celle de la semaine 99 pour le fournisseur. Les horizons sont respectivement 2 et 8 semaines. Si la commande couvre plusieurs semaines, il faut plutôt prévoir leur total et préciser lesquelles. La demande en unités ne donne pas directement les heures de personnel : une relation opérationnelle supplémentaire est nécessaire.

## Exercice 2 - Lire des motifs

Tracez la demande d’apprentissage en marquant les promotions. Produisez un zoom des 26 dernières semaines d’apprentissage. Décrivez deux motifs et une limite. Expliquez pourquoi une variation du prix associée à une variation de demande ne prouve pas un effet causal.

> **TIP:**
>
> ``` r
> ggplot(apprentissage_demande, aes(semaine, demande)) +
>   geom_line(colour = "#0B4F6C") + geom_point(aes(colour = promotion)) +
>   labs(x = NULL, y = "Demande hebdomadaire (unités)", colour = "Promotion") +
>   theme_minimal()
> ```
>
> ![](exercices_files/figure-html/unnamed-chunk-1-1.png)
>
> ``` r
> ggplot(slice_tail(apprentissage_demande, n = 26), aes(semaine, demande)) +
>   geom_line(colour = "#0B4F6C") + geom_point(aes(colour = promotion)) +
>   labs(x = NULL, y = "Demande hebdomadaire (unités)", colour = "Promotion") +
>   theme_minimal()
> ```
>
> ![](exercices_files/figure-html/unnamed-chunk-2-1.png)
>
> Le graphique fait apparaître une évolution du niveau et des variations locales, dont plusieurs coïncident avec une promotion. Le caractère saisonnier doit être confronté aux répétitions, au calendrier et aux promotions; 91 semaines apportent moins de deux cycles de 52 semaines. Le prix et les promotions sont associés et d’autres facteurs temporels peuvent intervenir. Aucun effet causal séparé n’est identifié.

## Exercice 3 - Contrôler le calendrier

Vérifiez le pas temporel, les dates distinctes et les valeurs manquantes. Sur une copie, supprimez la semaine 20 et mettez la demande de la semaine 21 à NA. Rétablissez la grille sans imputer. Quel serait le problème de na.omit() suivi de ts(…, frequency = 52)?

> **TIP:**
>
> ``` r
> apprentissage_demande |>
>   summarise(doublons = sum(duplicated(semaine)),
>             pas_min = min(as.numeric(diff(semaine))),
>             pas_max = max(as.numeric(diff(semaine))),
>             manquants = sum(is.na(demande)))
> ```
>
>     # A tibble: 1 × 4
>       doublons pas_min pas_max manquants
>          <int>   <dbl>   <dbl>     <int>
>     1        0       7       7         0
>
> ``` r
> incomplete <- apprentissage_demande |>
>   mutate(demande = if_else(row_number() == 21L, NA_real_, as.numeric(demande))) |>
>   slice(-20)
> grille <- tibble(semaine = seq.Date(min(apprentissage_demande$semaine),
>                                    max(apprentissage_demande$semaine), by = "week"))
> grille |> left_join(incomplete, by = "semaine") |> filter(is.na(demande))
> ```
>
>     # A tibble: 2 × 5
>       semaine    numero_semaine promotion prix_moyen demande
>       <date>              <dbl> <fct>          <dbl>   <dbl>
>     1 2024-05-13             NA <NA>            NA        NA
>     2 2024-05-20             21 non             40.6      NA
>
> Le fichier original a un pas de sept jours, sans doublon ni demande manquante. Dans la copie, une ligne manque et une mesure manque. Supprimer ces lignes puis appeler ts les rendrait artificiellement voisines. Une imputation, une méthode compatible ou une nouvelle collecte demande une justification; elle ne doit pas consulter le futur de l’origine simulée.

## Exercice 4 - Références à origine fixe

Produisez les treize prévisions émises à la fin de la semaine 91, naïves et saisonnières avec m = 52. Expliquez quelles observations sont utilisées. Pourquoi lag(demande, 1) sur les treize dernières semaines ne représente-t-il pas cette origine fixe?

> **TIP:**
>
> ``` r
> refs_demande <- prevoir_references(apprentissage_demande$demande, 13, periode = 52)
> evaluation_demande <- validation_demande |>
>   mutate(naive = refs_demande$naive, saisonniere = refs_demande$saisonniere) |>
>   pivot_longer(c(naive, saisonniere), names_to = "methode", values_to = "prevision") |>
>   mutate(erreur = demande - prevision)
> evaluation_demande |> select(semaine, methode, prevision, demande) |> head()
> ```
>
>     # A tibble: 6 × 4
>       semaine    methode     prevision demande
>       <date>     <chr>           <dbl>   <dbl>
>     1 2025-09-29 naive            1211    1325
>     2 2025-09-29 saisonniere      1121    1325
>     3 2025-10-06 naive            1211    1282
>     4 2025-10-06 saisonniere      1246    1282
>     5 2025-10-13 naive            1211    1388
>     6 2025-10-13 saisonniere      1154    1388
>
> Le naïf utilise la semaine 91 pour tous les horizons. Le saisonnier utilise les semaines 40 à 52 pour prévoir les semaines 92 à 104. Une colonne lag à un pas utiliserait progressivement des observations de validation devenues connues : c’est un protocole à origine mobile, à évaluer séparément.

## Exercice 5 - Mesures et zéros

Calculez les cinq mesures avec le même dénominateur MASE saisonnier. Interprétez ME et MAE. Puis calculez les erreurs de prévisions (10, 20) pour des observations (0, 20). Que faire du MAPE? Une MASE inférieure à 1 prouve-t-elle que la méthode bat la référence sur ces treize semaines?

> **TIP:**
>
> ``` r
> comparaison_demande <- evaluation_demande |>
>   group_by(methode) |>
>   group_modify(~ mesures_erreur(.x$demande, .x$prevision,
>                                 apprentissage_demande$demande, periode = 52)) |>
>   ungroup()
> comparaison_demande |> knitr::kable(digits = 2)
> ```
>
> | methode     |     ME |    MAE |   RMSE |  MAPE | MASE |
> |:------------|-------:|-------:|-------:|------:|-----:|
> | naive       | 184.85 | 184.85 | 209.19 | 12.82 | 1.09 |
> | saisonniere | 142.92 | 178.62 | 193.55 | 12.64 | 1.05 |
>
> ``` r
> mesures_erreur(c(0, 20), c(10, 20), c(10, 15, 20), periode = 1)
> ```
>
>     # A tibble: 1 × 5
>          ME   MAE  RMSE  MAPE  MASE
>       <dbl> <dbl> <dbl> <dbl> <dbl>
>     1    -5     5  7.07    NA     1
>
> Les erreurs sont −10 et 0 : ME = −5, MAE = 5 et RMSE = √50 ≈ 7,07 unités. Le MAPE est indéfini; le code retourne NA sans exclure le zéro. Ici la MASE non saisonnière vaut 1 puisque l’échelle d’apprentissage est 5. Pour la comparaison principale, m = 52 pour les deux candidats. MASE \< 1 compare la MAE au dénominateur d’apprentissage. Il faut comparer directement les MAE de validation pour désigner la meilleure référence observée.

## Exercice 6 - Erreurs et intervalle

Tracez les erreurs saisonnières dans le temps et leur histogramme. Produisez un intervalle à 80 % et 95 % du naïf à h = 2 et h = 8. Expliquez pourquoi treize erreurs ne prouvent pas la normalité et pourquoi un intervalle à 95 % n’est pas une garantie.

> **TIP:**
>
> ``` r
> erreurs_demande <- evaluation_demande |> filter(methode == "saisonniere")
> ggplot(erreurs_demande, aes(semaine, erreur)) +
>   geom_hline(yintercept = 0, linetype = 2) + geom_line() + geom_point() +
>   labs(x = NULL, y = "Erreur (unités)") + theme_minimal()
> ```
>
> ![](exercices_files/figure-html/unnamed-chunk-6-1.png)
>
> ``` r
> ggplot(erreurs_demande, aes(erreur)) +
>   geom_histogram(bins = 6, fill = "#D9EEF2", colour = "#0B4F6C") +
>   labs(x = "Erreur (unités)", y = "Semaines") + theme_minimal()
> ```
>
> ![](exercices_files/figure-html/unnamed-chunk-7-1.png)
>
> ``` r
> serie_demande <- ts(apprentissage_demande$demande, frequency = 52)
> intervalle_naif <- naive(serie_demande, h = 8, level = c(80, 95))
> tibble(h = c(2, 8), point = as.numeric(intervalle_naif$mean[c(2, 8)]),
>        bas_80 = intervalle_naif$lower[c(2, 8), "80%"],
>        haut_80 = intervalle_naif$upper[c(2, 8), "80%"],
>        bas_95 = intervalle_naif$lower[c(2, 8), "95%"],
>        haut_95 = intervalle_naif$upper[c(2, 8), "95%"])
> ```
>
>     # A tibble: 2 × 6
>           h point bas_80 haut_80 bas_95 haut_95
>       <dbl> <dbl>  <dbl>   <dbl>  <dbl>   <dbl>
>     1     2  1211  1003.   1419.   893.   1529.
>     2     8  1211   796.   1626.   576.   1846.
>
> Ces intervalles illustrent les hypothèses du modèle naïf à marche aléatoire. Ils ne tiennent pas explicitement compte des promotions et ne prouvent pas une calibration correcte pour cette série. La couverture nominale concerne une procédure dans des conditions comparables. L’histogramme est descriptif; une petite série d’erreurs ne certifie pas leur distribution ou leur indépendance.

## Compléments facultatifs

Les six exercices précédents constituent le transfert attendu. Les deux exercices suivants prolongent la validation et les familles de méthodes; ils peuvent être faits après le parcours principal.

## Exercice complémentaire 7 - Origines mobiles à deux et huit semaines

Comparez les deux références à h = 2 et h = 8 avec les origines admissibles à partir de la semaine 91. Donnez les nombres de comparaisons et justifiez pourquoi les classements peuvent dépendre de l’horizon.

> **TIP:**
>
> ``` r
> mobile_demande <- validation_mobile(demande$demande, debut_validation = 92,
>                                    horizons = c(2L, 8L), periode = 52)
> mobile_demande |>
>   group_by(h, methode) |>
>   summarise(n = n(), ME = mean(erreur), MAE = mean(abs(erreur)),
>             RMSE = sqrt(mean(erreur^2)), .groups = "drop") |>
>   knitr::kable(digits = 2)
> ```
>
> |   h | methode     |   n |     ME |    MAE |   RMSE |
> |----:|:------------|----:|-------:|-------:|-------:|
> |   2 | naive       |  12 |  50.58 |  88.25 | 101.57 |
> |   2 | saisonniere |  12 | 137.83 | 176.50 | 192.66 |
> |   8 | naive       |   6 | 184.33 | 184.33 | 211.11 |
> |   8 | saisonniere |   6 | 200.83 | 200.83 | 212.11 |
>
> Les origines vont de 91 à 104 − h. Il y a douze origines à h = 2 et six à h = 8. À un horizon donné, les méthodes partagent les cibles et les origines. Les horizons n’utilisent pas exactement les mêmes cibles; il faut conserver cette limite dans une comparaison de scores entre délais.

## Exercice complémentaire 8 - Méthodes, combinaison et suivi

Comparez la moyenne à poids égaux des deux références à leurs scores à origine fixe. Proposez une famille utilisant uniquement l’historique et une famille avec variables externes. Dites quelles informations seraient nécessaires au moment de prévoir. Terminez par une note de six phrases maximum.

> **TIP:**
>
> ``` r
> combinee_demande <- validation_demande |>
>   mutate(prevision = (refs_demande$naive + refs_demande$saisonniere) / 2)
> mesures_erreur(combinee_demande$demande, combinee_demande$prevision,
>                apprentissage_demande$demande, periode = 52)
> ```
>
>     # A tibble: 1 × 5
>          ME   MAE  RMSE  MAPE  MASE
>       <dbl> <dbl> <dbl> <dbl> <dbl>
>     1  164.  174.  195.  12.1  1.02
>
> Une famille de lissage peut utiliser l’historique; une régression avec prix et promotion nécessite des prix et promotions futurs disponibles, prévus ou scénarisés. Une combinaison est jugée par son score, sans amélioration garantie. La note doit préciser calendrier, cible, deux horizons, comparaison chiffrée, limite causale et réévaluation sur de nouvelles origines. Les scores calculés ne fixent pas à eux seuls le coût acceptable d’une erreur ni le besoin en personnel.

## Trace finale

Rassemblez les six premières réponses dans `prevision_demande.qmd`. Conservez les graphes et le protocole fixe. Terminez par une conclusion qui justifie la référence retenue à partir des mesures, nomme une limite et précise quand réévaluer les erreurs. Si vous faites les exercices complémentaires, ajoutez leurs résultats dans une section facultative distincte. Le [projet des corrigés complets](telechargements/corrige-demande.zip) se recalcule dans une session neuve après votre tentative.

## Corrigés des productions de fin de capsule

Ces corrigés portent sur la consommation mensuelle d’électricité, dans `prevision_electricite.qmd`. Ils répondent aux productions 6.1 à 6.6 du parcours et aux deux pratiques facultatives 6.7 et 6.8. Les exercices 1 à 8 ci-dessus concernent le cas distinct de demande hebdomadaire. Vous n’avez pas à refaire une production déjà réalisée dans le parcours.

Tentez la production, utilisez ses critères d’auto-vérification, puis ouvrez le corrigé correspondant. La démonstration explique l’analyse complète; les réponses ci-dessous précisent ce qui est attendu pour chaque consigne. Les réponses rédigées sont des exemples : d’autres formulations justifiées sont acceptables.

Le [projet des corrigés sur l’électricité](telechargements/corrige-electricite.zip) contient ce parcours corrigé, le CSV et les fonctions R nécessaires.

### Production 6.1 - Définir la demande, sans calcul

Cette première production demande quelques phrases : aucun code, graphique ou résultat numérique de prévision n’est requis. Pour chaque mois visé, indiquez la quantité à prévoir, son unité et le délai depuis l’origine commune. Précisez ensuite un usage et une fonction à consulter.

> **TIP:**
>
> Exemple de réponse : « À la fin de décembre 2024, nous voulons prévoir la consommation totale d’électricité du bâtiment universitaire fictif pour chacun des mois de janvier, février et mars 2025, en kWh. L’unité d’observation est un mois pour ce bâtiment et les horizons sont respectivement de 1, 2 et 3 mois. Ces prévisions serviraient de repères pour comparer les consommations observées chaque mois et examiner les écarts. Nous pourrions consulter la responsable du bâtiment pour connaître les travaux et les changements d’occupation susceptibles d’aider à les interpréter. »
>
> | Mois visé    | Origine commune   | Horizon |
> |--------------|-------------------|---------|
> | Janvier 2025 | Fin décembre 2024 | 1 mois  |
> | Février 2025 | Fin décembre 2024 | 2 mois  |
> | Mars 2025    | Fin décembre 2024 | 3 mois  |
>
> La fréquence est mensuelle et le périmètre est un seul bâtiment fictif. Il n’y a pas de nom de bâtiment à découvrir ni de personne réelle à contacter. Une fonction pertinente et l’information qu’elle apporterait suffisent. Le responsable des compteurs serait aussi un choix acceptable pour vérifier la qualité des mesures.
>
> Les trois prévisions mensuelles sont distinctes du total du trimestre. Les valeurs à prévoir seront calculées après l’introduction des méthodes; il ne faut pas inventer de nombres ici. Une prévision en kWh ne donne pas directement une facture en dollars ni une pointe de puissance en kW.

### Préparation du code des corrigés

Pour les productions suivantes, ouvrez le projet guidé ou le projet des corrigés sur l’électricité. Exécutez d’abord ce bloc, puis les blocs des corrigés dans l’ordre. La production 6.5 reprend les prévisions de 6.4; 6.8 les reprend également. Les calculs du transfert sur la demande hebdomadaire ne sont pas nécessaires.

``` r
library(tidyverse)
library(forecast)

# Dans le projet téléchargé, les dossiers R/ et data/ sont à côté du document.
chemins_fonctions_capsules <- c(
  "R/analyse-module06.R",
  "modules/semaine-06-series-chronologiques-intro/R/analyse-module06.R"
)
chemin_fonctions_capsules <- chemins_fonctions_capsules[
  file.exists(chemins_fonctions_capsules)
][1]
stopifnot(!is.na(chemin_fonctions_capsules))
source(chemin_fonctions_capsules)

chemins_csv_capsules <- c(
  "data/consommation_electrique_batiment_quebec.csv",
  "modules/semaine-06-series-chronologiques-intro/data/consommation_electrique_batiment_quebec.csv"
)
chemin_csv_capsules <- chemins_csv_capsules[file.exists(chemins_csv_capsules)][1]
stopifnot(!is.na(chemin_csv_capsules))
electricite_capsules <- read_csv(chemin_csv_capsules, show_col_types = FALSE) |>
  mutate(date = as.Date(date)) |>
  arrange(date)
apprentissage_capsules <- electricite_capsules |>
  filter(date < as.Date("2025-01-01"))
validation_capsules <- electricite_capsules |>
  filter(date >= as.Date("2025-01-01"))
```

### Production 6.2 - Décrire les graphiques

Tracez les deux graphiques sur 2020 à 2024, décrivez deux motifs et une limite, puis comparez une hausse de 20 000 kWh à une hausse de 10 % sur les deux niveaux fictifs fournis.

> **TIP:**
>
> ``` r
> ggplot(apprentissage_capsules, aes(date, consommation_kwh / 1000)) +
>   geom_line(colour = "#0B4F6C") +
>   geom_point() +
>   labs(x = NULL, y = "Consommation mensuelle (MWh)") +
>   theme_minimal()
> ```
>
> ![](exercices_files/figure-html/corrige-capsule-06-2-1.png)
>
> ``` r
> ggplot(apprentissage_capsules,
>        aes(mois, consommation_kwh / 1000, group = annee,
>            colour = factor(annee))) +
>   geom_line() +
>   geom_point() +
>   scale_x_continuous(breaks = 1:12) +
>   labs(x = "Mois", y = "Consommation mensuelle (MWh)", colour = "Année") +
>   theme_minimal()
> ```
>
> ![](exercices_files/figure-html/corrige-capsule-06-2-2.png)
>
> ``` r
> tibble(niveau_kwh = c(200000, 400000)) |>
>   mutate(
>     apres_hausse_fixe_kwh = niveau_kwh + 20000,
>     hausse_fixe_pourcent = 100 * 20000 / niveau_kwh,
>     apres_hausse_10_pourcent_kwh = niveau_kwh * 1.10,
>     hausse_10_pourcent_kwh = niveau_kwh * 0.10
>   ) |>
>   knitr::kable(digits = 0)
> ```
>
> | niveau_kwh | apres_hausse_fixe_kwh | hausse_fixe_pourcent | apres_hausse_10_pourcent_kwh | hausse_10_pourcent_kwh |
> |---:|---:|---:|---:|---:|
> | 2e+05 | 220000 | 10 | 220000 | 20000 |
> | 4e+05 | 420000 | 5 | 440000 | 40000 |
>
> On observe un motif annuel avec des consommations généralement plus élevées en hiver et plus faibles en été. Le niveau tend aussi à augmenter entre le début et la fin de l’apprentissage, avec des fluctuations : chaque année n’est pas nécessairement supérieure à la précédente.
>
> Une hausse fixe de 20 000 kWh conduit à 220 000 puis 420 000 kWh, soit +10 % et +5 %. Une hausse de 10 % conduit à 220 000 puis 440 000 kWh, soit +20 000 puis +40 000 kWh. Le premier cas illustre une variation additive; le second, une variation proportionnelle. Ces niveaux sont des exemples de calcul, pas des observations supplémentaires du fichier.
>
> Les graphiques décrivent des motifs; ils n’établissent pas leur cause et ne suffisent pas à choisir une méthode de prévision. Les données sont simulées et 2025 reste réservé à la validation.

### Production 6.3 - Auditer et distinguer les situations

Vérifiez le fichier d’apprentissage, puis raisonnez séparément sur les trois situations hypothétiques. Il n’est pas demandé de trouver une anomalie qui aurait été cachée dans le fichier fourni.

> **TIP:**
>
> ``` r
> apprentissage_capsules |>
>   summarise(
>     debut = min(date), fin = max(date), mois_presents = n(),
>     dates_dupliquees = sum(duplicated(date)),
>     dates_manquantes = sum(is.na(date)),
>     consommations_manquantes = sum(is.na(consommation_kwh))
>   )
> ```
>
>     # A tibble: 1 × 6
>       debut      fin        mois_presents dates_dupliquees dates_manquantes
>       <date>     <date>             <int>            <int>            <int>
>     1 2020-01-01 2024-12-01            60                0                0
>     # ℹ 1 more variable: consommations_manquantes <int>
>
> ``` r
> grille_capsules <- tibble(
>   date = seq.Date(as.Date("2020-01-01"), as.Date("2024-12-01"), by = "month")
> )
> grille_capsules |> anti_join(apprentissage_capsules, by = "date")
> ```
>
>     # A tibble: 0 × 1
>     # ℹ 1 variable: date <date>
>
> Le résultat attendu est de 60 mois, de janvier 2020 à décembre 2024, sans doublon, date manquante, mois absent ou consommation manquante. La dernière commande renvoie zéro ligne. Des mois consécutifs n’ont pas tous le même nombre de jours.
>
> | Situation hypothétique | Traitement justifié possible |
> |----|----|
> | Mois absent | Rétablir la ligne du calendrier avec `NA`, rechercher la mesure originale et documenter l’absence. Si elle reste inconnue, choisir une méthode compatible ou une imputation justifiée, en examinant sa sensibilité. |
> | Erreur de saisie confirmée | Vérifier la source et corriger la valeur si la bonne mesure est disponible. Conserver une trace de la correction. Si la mesure correcte demeure inconnue, la traiter comme manquante. |
> | Événement réel | Conserver l’observation et documenter l’événement. Examiner s’il peut se reproduire et justifier tout traitement éventuel par rapport au futur visé. |
>
> Un mois absent ne vaut pas zéro. Retirer une ligne puis appeler `ts()` comprimerait le calendrier. Dans l’évaluation à origine fixe de décembre 2024, on ne consulte aucune observation de 2025 pour estimer un traitement. Aucune imputation n’est nécessaire dans le fichier fourni.

### Production 6.4 - Construire les références

Produisez les deux références depuis la même origine et comparez-les aux douze observations de 2025. À ce stade, les valeurs de validation sont utilisées pour la comparaison, après émission des prévisions.

> **TIP:**
>
> ``` r
> previsions_capsules <- validation_capsules |>
>   mutate(
>     h = row_number(),
>     naive = rep(tail(apprentissage_capsules$consommation_kwh, 1), n()),
>     saisonniere = tail(apprentissage_capsules$consommation_kwh, 12)
>   )
> previsions_capsules |>
>   select(date, h, naive, saisonniere, consommation_kwh) |>
>   knitr::kable()
> ```
>
> | date       |   h |  naive | saisonniere | consommation_kwh |
> |:-----------|----:|-------:|------------:|-----------------:|
> | 2025-01-01 |   1 | 200112 |      215188 |           223421 |
> | 2025-02-01 |   2 | 200112 |      192262 |           184638 |
> | 2025-03-01 |   3 | 200112 |      185038 |           183079 |
> | 2025-04-01 |   4 | 200112 |      158979 |           156201 |
> | 2025-05-01 |   5 | 200112 |      141021 |           142726 |
> | 2025-06-01 |   6 | 200112 |      114345 |           125375 |
> | 2025-07-01 |   7 | 200112 |      119873 |           114372 |
> | 2025-08-01 |   8 | 200112 |      120492 |           127930 |
> | 2025-09-01 |   9 | 200112 |      129982 |           126185 |
> | 2025-10-01 |  10 | 200112 |      157641 |           164449 |
> | 2025-11-01 |  11 | 200112 |      187237 |           192032 |
> | 2025-12-01 |  12 | 200112 |      200112 |           218392 |
>
> ``` r
> previsions_capsules |>
>   pivot_longer(c(naive, saisonniere),
>                names_to = "methode", values_to = "prevision") |>
>   ggplot(aes(date, prevision / 1000, colour = methode)) +
>   geom_line() +
>   geom_line(data = validation_capsules,
>             aes(date, consommation_kwh / 1000),
>             inherit.aes = FALSE, colour = "black") +
>   labs(x = NULL, y = "Consommation (MWh)", colour = "Référence",
>        subtitle = "Noir : observations de 2025; origine fin décembre 2024") +
>   theme_minimal()
> ```
>
> ![](exercices_files/figure-html/corrige-capsule-06-4-1.png)
>
> Le naïf répète 200 112 kWh, la valeur de décembre 2024, pour chacun des douze mois. Le saisonnier utilise janvier 2024 pour janvier 2025, février 2024 pour février 2025, et ainsi de suite. Toutes ces valeurs étaient disponibles à l’origine.
>
> Un décalage `lag(consommation_kwh, 1)` calculé sur tout le fichier utiliserait janvier 2025 pour prévoir février 2025, puis février pour mars. Ces observations sont inconnues en décembre 2024. Cela correspondrait à des prévisions successives à un mois, avec actualisation de l’origine, plutôt qu’à douze prévisions émises ensemble.

### Production 6.5 - Comparer les erreurs

Les trois candidats sont le naïf, le naïf saisonnier et la tendance quadratique illustrée dans la démonstration. Tracez les erreurs saisonnières dans le temps et leur histogramme. Utilisez la convention erreur = observé − prévu et la même échelle MASE saisonnière pour tous les candidats.

> **TIP:**
>
> ``` r
> serie_capsules <- ts(apprentissage_capsules$consommation_kwh,
>                      start = c(2020, 1), frequency = 12)
> tendance_capsules <- tslm(serie_capsules ~ trend + I(trend^2))
> previsions_capsules <- previsions_capsules |>
>   mutate(tendance = as.numeric(forecast(tendance_capsules, h = 12)$mean))
> evaluation_capsules <- previsions_capsules |>
>   pivot_longer(c(naive, saisonniere, tendance),
>                names_to = "methode", values_to = "prevision") |>
>   mutate(erreur = consommation_kwh - prevision)
> scores_capsules <- evaluation_capsules |>
>   group_by(methode) |>
>   group_modify(~ mesures_erreur(
>     .x$consommation_kwh, .x$prevision,
>     apprentissage_capsules$consommation_kwh, periode = 12
>   )) |>
>   ungroup()
> scores_capsules |>
>   knitr::kable(digits = 2,
>     col.names = c("Méthode", "ME (kWh)", "MAE (kWh)", "RMSE (kWh)",
>                   "MAPE (%)", "MASE"),
>     format.args = list(decimal.mark = ",", big.mark = " "))
> ```
>
> | Méthode     |   ME (kWh) | MAE (kWh) | RMSE (kWh) | MAPE (%) | MASE |
> |:------------|-----------:|----------:|-----------:|---------:|-----:|
> | naive       | -36 878,67 | 43 810,17 |  51 298,07 |    31,69 | 6,71 |
> | saisonniere |   3 052,50 |  6 662,33 |   7 987,13 |     4,11 | 1,02 |
> | tendance    |  -2 172,18 | 31 573,64 |  35 965,65 |    20,50 | 4,84 |
>
> ``` r
> erreurs_saisonnieres_capsules <- evaluation_capsules |>
>   filter(methode == "saisonniere")
> ggplot(erreurs_saisonnieres_capsules, aes(date, erreur / 1000)) +
>   geom_hline(yintercept = 0, linetype = 2) +
>   geom_line() + geom_point() +
>   labs(x = NULL, y = "Erreur de prévision (MWh)") + theme_minimal()
> ```
>
> ![](exercices_files/figure-html/corrige-capsule-06-5-1.png)
>
> ``` r
> ggplot(erreurs_saisonnieres_capsules, aes(erreur / 1000)) +
>   geom_histogram(bins = 6, fill = "#D9EEF2", colour = "#0B4F6C") +
>   labs(x = "Erreur de prévision (MWh)", y = "Nombre de mois") + theme_minimal()
> ```
>
> ![](exercices_files/figure-html/corrige-capsule-06-5-2.png)
>
> Sur ces douze mois, les MAE sont d’environ 43 810 kWh pour le naïf, 6 662 kWh pour le saisonnier et 31 574 kWh pour la tendance quadratique. La référence saisonnière obtient donc ici la plus petite MAE. Ce résultat concerne les candidats et la période comparés; il ne garantit pas le même classement à l’avenir.
>
> ME, MAE et RMSE sont en kWh, MAPE en pourcentage et MASE sans unité. La ME saisonnière, environ +3 052 kWh, indique une sous-prévision moyenne avec la convention retenue; la ME négative du naïf indique une sur-prévision moyenne. Les signes peuvent se compenser, d’où l’intérêt de la MAE et de la RMSE.
>
> La MASE utilise l’écart absolu moyen entre les mêmes mois d’années consécutives sur 2020 à 2024. Une MASE d’environ 1,02 pour le saisonnier ne contredit pas sa première place sur la validation : le dénominateur décrit l’apprentissage, pas la MAE d’un concurrent sur 2025. Le MAPE est défini ici puisque les consommations observées sont positives; en présence d’un zéro, il faudrait signaler son indéfinition.
>
> Le graphique montre des erreurs des deux signes et le plus grand écart positif en décembre 2025 (+18 280 kWh). L’histogramme décrit seulement douze erreurs. Il ne démontre ni normalité ni indépendance; ces erreurs de validation sont distinctes des résidus d’apprentissage.

### Production 6.6 - Lire le cône d’incertitude

Utilisez le code fourni pour illustrer ETS(A,A,N). L’estimation des paramètres de lissage ne fait pas partie de ce qui est demandé ici.

> **TIP:**
>
> ``` r
> modele_intervalle_capsules <- ets(serie_capsules, model = "AAN")
> cone_capsules <- forecast(modele_intervalle_capsules,
>                           h = 12, level = c(80, 95))
> autoplot(cone_capsules) +
>   labs(x = "Année", y = "Consommation (kWh)",
>        title = "ETS(A,A,N), origine fin décembre 2024") + theme_minimal()
> ```
>
> ![](exercices_files/figure-html/corrige-capsule-06-6-1.png)
>
> ``` r
> tibble(
>   mois = c("Janvier 2025", "Décembre 2025"), h = c(1, 12),
>   point_kwh = as.numeric(cone_capsules$mean[c(1, 12)]),
>   bas_80 = cone_capsules$lower[c(1, 12), "80%"],
>   haut_80 = cone_capsules$upper[c(1, 12), "80%"],
>   bas_95 = cone_capsules$lower[c(1, 12), "95%"],
>   haut_95 = cone_capsules$upper[c(1, 12), "95%"]
> ) |>
>   knitr::kable(digits = 0,
>     format.args = list(decimal.mark = ",", big.mark = " "))
> ```
>
> | mois          |   h | point_kwh |  bas_80 | haut_80 |   bas_95 | haut_95 |
> |:--------------|----:|----------:|--------:|--------:|---------:|--------:|
> | Janvier 2025  |   1 |   213 142 | 189 581 | 236 703 |  177 109 | 249 175 |
> | Décembre 2025 |  12 |   258 546 |  11 210 | 505 883 | -119 722 | 636 814 |
>
> Toutes les valeurs du tableau sont en kWh. Pour janvier, le point vaut environ 213 142 kWh, l’intervalle à 80 % \[189 581; 236 703\] et celui à 95 % \[177 109; 249 175\]. Pour décembre, le point vaut environ 258 546 kWh, l’intervalle à 80 % \[11 210; 505 883\] et celui à 95 % \[−119 722; 636 815\]. Les derniers chiffres peuvent varier légèrement selon la version de `forecast`.
>
> À horizon fixé, l’intervalle à 95 % est ici plus large que celui à 80 %. Les intervalles de décembre sont aussi plus larges que ceux de janvier. Ils permettent de discuter l’ampleur de l’incertitude, au lieu de communiquer uniquement un point.
>
> La borne négative de décembre est physiquement inadmissible pour cette consommation. ETS(A,A,N) ne représente pas explicitement la saisonnalité : ce cône est une illustration à critiquer, pas une recommandation opérationnelle. Il faudrait réexaminer le modèle et sa calibration. Tronquer silencieusement la borne à zéro ne démontrerait pas la couverture de l’intervalle modifié.
>
> Le niveau de 95 % est nominal et dépend des hypothèses; il ne garantit ni cette observation future ni toute la trajectoire de douze mois simultanément.

### Pratique facultative 6.7 - Avancer les origines

Comparez séparément les horizons 1 et 6 mois, en utilisant seulement le passé déjà connu à chaque origine. Cette pratique ne s’ajoute au rapport que si vous faites le complément A.

> **TIP:**
>
> ``` r
> mobile_capsules <- validation_mobile(
>   electricite_capsules$consommation_kwh,
>   debut_validation = 61, horizons = c(1L, 6L), periode = 12
> ) |>
>   mutate(
>     mois_origine = electricite_capsules$date[origine],
>     mois_cible = electricite_capsules$date[cible]
>   )
> mobile_capsules |>
>   group_by(h, methode) |>
>   summarise(
>     origines = n(),
>     premier_mois_origine = min(mois_origine),
>     dernier_mois_origine = max(mois_origine),
>     derniere_cible = max(mois_cible),
>     MAE_kwh = mean(abs(erreur)), .groups = "drop"
>   ) |>
>   knitr::kable(digits = 2)
> ```
>
> | h | methode | origines | premier_mois_origine | dernier_mois_origine | derniere_cible | MAE_kwh |
> |---:|:---|---:|:---|:---|:---|---:|
> | 1 | naive | 12 | 2024-12-01 | 2025-11-01 | 2025-12-01 | 19989.00 |
> | 1 | saisonniere | 12 | 2024-12-01 | 2025-11-01 | 2025-12-01 | 6662.33 |
> | 6 | naive | 7 | 2024-12-01 | 2025-06-01 | 2025-12-01 | 63994.14 |
> | 6 | saisonniere | 7 | 2024-12-01 | 2025-06-01 | 2025-12-01 | 8235.57 |
>
> Les dates du tableau désignent des mois; la prévision est émise à la fin du mois d’origine. À h = 1, les douze origines vont de fin décembre 2024 à fin novembre 2025. À h = 6, les sept origines vont de fin décembre 2024 à fin juin 2025. La dernière cible est décembre 2025 dans les deux cas.
>
> Les MAE sont d’environ 19 989 et 6 662 kWh à un mois pour le naïf et le saisonnier, puis 63 994 et 8 236 kWh à six mois. Le saisonnier obtient ici la plus petite MAE aux deux horizons. L’horizon, les cibles et l’information actualisée doivent accompagner ces scores.
>
> À origine fixe, les douze prévisions utilisent seulement l’historique arrêté en décembre 2024. À origines mobiles, de nouvelles observations deviennent disponibles entre deux émissions. Les MAE ne décrivent donc pas le même protocole; les horizons 1 et 6 n’utilisent pas non plus exactement les mêmes cibles.

### Pratique facultative 6.8 - Combiner et prévoir le suivi

Proposez des familles à comparer sans devoir les ajuster ici. Évaluez ensuite la combinaison annoncée des deux références. Cette pratique appartient au complément B.

> **TIP:**
>
> ``` r
> combinaison_capsules <- previsions_capsules |>
>   mutate(combinee = (naive + saisonniere) / 2)
> combinaison_capsules |>
>   pivot_longer(c(naive, saisonniere, combinee),
>                names_to = "methode", values_to = "prevision") |>
>   group_by(methode) |>
>   summarise(MAE_kwh = mean(abs(consommation_kwh - prevision)),
>             .groups = "drop") |>
>   knitr::kable(digits = 2)
> ```
>
> | methode     |  MAE_kwh |
> |:------------|---------:|
> | combinee    | 22588.25 |
> | naive       | 43810.17 |
> | saisonniere |  6662.33 |
>
> La combinaison a une MAE d’environ 22 588 kWh. Elle fait mieux que le naïf seul (environ 43 810), mais moins bien que le saisonnier seul (environ 6 662). La moyenne à poids égaux n’améliore donc pas systématiquement la meilleure référence. Ses deux composantes sont disponibles dès fin décembre 2024 et ses poids sont fixés avant l’examen des scores.
>
> Deux familles possibles seraient un lissage avec saisonnalité et une régression avec tendance et indicatrices mensuelles. L’historique et le calendrier futur sont disponibles à l’origine. Ajouter une température ou une occupation future demanderait une valeur connue à l’avance, une prévision ou un scénario explicite. Proposer une famille ne démontre pas qu’elle ferait mieux : il faudrait la comparer sur le même protocole.
>
> Un suivi possible consiste à enregistrer les prévisions émises, ajouter chaque consommation reçue, examiner l’erreur avec les personnes responsables du bâtiment et réévaluer les candidats à de nouvelles origines. Réutiliser 2025 pour choisir de nouveaux candidats ne fournirait pas une nouvelle évaluation indépendante. Les règles d’action devraient aussi tenir compte du coût des écarts et des informations opérationnelles disponibles.

## Pratique supplémentaire

Ces huit exercices sont facultatifs, indépendants des deux rapports suivis et des compléments A et B. Ils consolident les six capsules principales. Tous les scénarios et nombres ci-dessous sont fictifs et fournis pour l’enseignement; aucun fichier supplémentaire n’est nécessaire. Faites le calcul ou l’interprétation avant d’ouvrir la solution, puis refaites la question sans regarder la réponse.

## Exercice 9 - Prévoir une période ou un total

Une responsable prévoit, à la fin de la semaine 40, les unités qui seront nécessaires pour la semaine 42 et celles à commander pour les semaines 41 à 44. Nommez les deux cibles et les horizons. Les prévisions par semaine sont 100, 120, 110 et 130 unités. Quel point de prévision convient à la commande? Quelle information manque pour communiquer son incertitude?

> **TIP:**
>
> La première cible est la demande de la semaine 42, à h = 2 : le point fourni vaut 120 unités. La seconde est le total des semaines 41 à 44, depuis la même origine; elle couvre les horizons 1 à 4. Le point fourni pour ce total vaut 100 + 120 + 110 + 130 = 460 unités.
>
> Additionner les points ne fournit pas à lui seul un intervalle pour le total. Il manque un modèle de l’incertitude conjointe des demandes ou des erreurs entre semaines. Des intervalles séparés à 95 % ne deviennent pas une garantie à 95 % pour toute la période. Le besoin net de commande pourrait aussi dépendre du stock disponible, qui n’est pas fourni.

## Exercice 10 - Montant et proportion

Une pointe saisonnière ajoute 20 unités à un niveau de 100 unités, puis à un niveau de 200 unités. Comparez avec une pointe de 10 % aux mêmes niveaux. Donnez les quatre valeurs prévues et les variations relatives. Quelle forme correspond à un effet additif? Deux valeurs suffisent-elles à établir une saisonnalité?

> **TIP:**
>
> Avec +20 unités, les valeurs sont 120 et 220 : les hausses relatives valent 20 % et 10 %. Le montant constant correspond à la forme additive.
>
> Avec +10 %, les valeurs sont 110 et 220 : les hausses sont de 10 et 20 unités, et de 10 % dans les deux cas. La proportion constante correspond à la forme multiplicative.
>
> Le choix d’une forme demande d’examiner les motifs répétés et leur relation avec le niveau. Deux valeurs fournies pour un calcul ne prouvent ni une saisonnalité observée ni son mécanisme.

## Exercice 11 - Une période absente

Un tableau mensuel contient seulement le 1er janvier 2025 (10 unités) et le 1er mars 2025 (14 unités). Reconstituez le calendrier janvier-mars sans imputer. Peut-on utiliser directement les deux valeurs dans `ts(..., frequency = 12)` pour représenter ces trois mois? La valeur de février est-elle zéro?

> **TIP:**
>
> ``` r
> library(tidyverse)
> mesures_fictives <- tibble(
>   mois = as.Date(c("2025-01-01", "2025-03-01")),
>   quantite = c(10, 14)
> )
> calendrier_fictif <- tibble(
>   mois = seq.Date(as.Date("2025-01-01"), as.Date("2025-03-01"), by = "month")
> )
> calendrier_fictif |> left_join(mesures_fictives, by = "mois")
> ```
>
>     # A tibble: 3 × 2
>       mois       quantite
>       <date>        <dbl>
>     1 2025-01-01       10
>     2 2025-02-01       NA
>     3 2025-03-01       14
>
> Le résultat conserve trois mois : 10, NA, 14. Février est absent du tableau initial; aucune donnée ne permet de lui attribuer zéro. `ts()` suppose des positions régulièrement espacées : deux valeurs directement consécutives représenteraient janvier et février, et déplaceraient la mesure de mars. Rétablir la grille ne choisit pas encore une méthode d’imputation. Le traitement devra être documenté et utiliser seulement l’information disponible à l’origine simulée.

## Exercice 12 - Deux protocoles naïfs

À l’origine T, la dernière observation est 120 unités. Les observations suivantes, révélées ensuite, sont 130 et 150 unités. Calculez les deux prévisions et la MAE d’une référence naïve à origine fixe T. Recommencez avec une prévision à un pas émise à T, puis une autre émise à T + 1 après observation de 130. Les deux MAE répondent-elles à la même question?

> **TIP:**
>
> ``` r
> observations_fictives <- c(130, 150)
> previsions_fixes <- c(120, 120)
> previsions_un_pas <- c(120, 130)
> data.frame(
>   protocole = c("Origine fixe T, horizons 1 et 2", "Deux origines, horizon 1"),
>   MAE = c(mean(abs(observations_fictives - previsions_fixes)),
>           mean(abs(observations_fictives - previsions_un_pas)))
> )
> ```
>
>                             protocole MAE
>     1 Origine fixe T, horizons 1 et 2  20
>     2        Deux origines, horizon 1  15
>
> À origine fixe, les erreurs sont 10 et 30, donc la MAE vaut 20 unités. Aux deux origines successives, les erreurs sont 10 et 20, donc la MAE vaut 15 unités.
>
> Les deux calculs sont valides pour leurs protocoles respectifs, mais leur information et leurs horizons diffèrent. Pour une décision de deux périodes prise à T, la valeur 130 n’est pas encore connue. La MAE de 15 ne prouve donc pas une meilleure prévision à deux pas à cette origine. Le complément A développe le protocole à plusieurs origines; cet exercice demande seulement de reconnaître la différence.

## Exercice 13 - Cinq mesures à la main

Trois observations valent chacune 100 unités. Les prévisions sont 90, 110 et 100 unités. L’échelle de référence calculée sur l’apprentissage vaut q = 5 unités. Avec erreur = observé − prévu, calculez ME, MAE, RMSE, MAPE et MASE. Expliquez pourquoi ME = 0 ne suffit pas et pourquoi la MASE ne classe pas, à elle seule, les méthodes sur la validation.

> **TIP:**
>
> ``` r
> observations_mesures <- c(100, 100, 100)
> previsions_mesures <- c(90, 110, 100)
> erreurs_mesures <- observations_mesures - previsions_mesures
> echelle_apprentissage <- 5
> data.frame(
>   ME = mean(erreurs_mesures),
>   MAE = mean(abs(erreurs_mesures)),
>   RMSE = sqrt(mean(erreurs_mesures^2)),
>   MAPE = 100 * mean(abs(erreurs_mesures / observations_mesures)),
>   MASE = mean(abs(erreurs_mesures)) / echelle_apprentissage
> )
> ```
>
>       ME      MAE     RMSE     MAPE     MASE
>     1  0 6.666667 8.164966 6.666667 1.333333
>
> Les erreurs sont 10, −10 et 0. ME = 0 unité; MAE = 20/3 ≈ 6,67 unités; RMSE = √(200/3) ≈ 8,16 unités; MAPE ≈ 6,67 %; MASE = 4/3 ≈ 1,33, sans unité.
>
> Les écarts opposés s’annulent dans ME sans disparaître. La MASE compare la MAE de validation à l’échelle de référence de l’apprentissage, ici fournie. Pour classer deux méthodes sur la validation, comparez directement leurs scores sur les mêmes cibles et origines; les deux méthodes doivent partager le même q si vous comparez leur MASE.

## Exercice 14 - Zéro observé et échelle nulle

Les observations sont 0 et 20 unités; les prévisions sont 5 et 15 unités. Calculez ME, MAE et RMSE. Le MAPE est-il défini? Peut-on le rendre comparable en supprimant seulement la première observation? L’apprentissage est constant : toutes les différences de référence valent zéro. Que devient la MASE?

> **TIP:**
>
> Les erreurs sont −5 et 5 unités : ME = 0, MAE = 5 et RMSE = 5 unités. Le MAPE divise par l’observation et est indéfini au zéro. Retirer la première cible modifie l’ensemble évalué et masque l’erreur sur cette période; le score obtenu ne décrit plus la comparaison annoncée.
>
> L’échelle de l’apprentissage vaut q = 0 : la MASE est également indéfinie. Une observation de validation nulle ne rend pas toujours la MASE indéfinie; c’est ici son dénominateur nul qui pose problème. Conservez une mesure comme la MAE, avec ses unités et son protocole, et signalez les mesures non définies.

## Exercice 15 - Lire deux intervalles

Pour le même horizon et sous le même modèle, le point fourni vaut 100 unités, l’intervalle à 80 % est \[90; 110\] et celui à 95 % est \[85; 115\]. Comparez les largeurs. Une valeur future est-elle garantie entre 85 et 115? Peut-on transformer ces limites en intervalle garanti pour douze périodes?

> **TIP:**
>
> Les largeurs valent 20 et 30 unités. Ici, l’intervalle de niveau nominal plus élevé est plus large. Le point ne change pas.
>
> Le niveau de 95 % décrit une couverture visée par la procédure sous les hypothèses du modèle et dans des conditions comparables. Il ne garantit pas cette valeur future particulière. Des intervalles marginaux période par période ne fournissent pas automatiquement une bande simultanée à 95 % pour douze périodes. Une rupture de contexte, une mauvaise spécification ou des entrées futures indisponibles peuvent aussi compromettre la couverture.

## Exercice 16 - Corriger une recommandation

> Notre modèle est excellent : le R² atteint 0,99 sur toutes les données, y compris les mois réservés. Nous avons supprimé les mois sans mesure et les cibles nulles, puis calculé l’erreur sur les lignes restantes. Le MAPE vaut 2 %, donc nous commandons exactement le point prévu. Les intervalles à 95 % garantissent toute la demande des douze prochains mois.

Repérez quatre problèmes de raisonnement ou de protocole. Proposez une note corrigée sans inventer de résultats manquants.

> **TIP:**
>
> - Le R² d’ajustement ne mesure pas la précision future. Inclure les mois réservés dans l’ajustement empêche de les utiliser comme validation de ce modèle à l’origine antérieure.
> - Supprimer les périodes sans mesure peut comprimer le calendrier. Supprimer les cibles nulles pour le MAPE change l’ensemble évalué et peut masquer des erreurs.
> - Un seul pourcentage ne justifie pas une commande exacte : la cible, l’horizon, les unités, la référence, l’incertitude et les contraintes opérationnelles doivent être précisés.
> - Des intervalles marginaux à 95 % ne garantissent pas toute une trajectoire future.
>
> Exemple de note : « Le R² fourni décrit seulement l’ajustement observé et ne valide pas une prévision future. Nous devons reconstituer le calendrier, documenter les mesures manquantes et réserver des périodes postérieures à l’apprentissage. Les candidats seront comparés à une référence sur les mêmes cibles, avec des mesures définies et leurs unités. La décision restera provisoire tant que ces scores, les contraintes de commande et l’incertitude n’auront pas été examinés. »

## Auto-vérification

J’ai tenté les six exercices de transfert avant de lire leurs corrigés.

Je distingue les exercices attendus, les compléments A/B et la pratique supplémentaire facultative.

Je sais reconstruire un calcul ou une interprétation sans recopier la correction.

Mon rapport donne les dates, l’origine, les horizons, les unités et une limite.

Le document se recalcule après redémarrage de R.

## Sources

Hyndman et Athanasopoulos (2021), [Forecasting: Principles and Practice](https://otexts.com/fpp3/), chapitres 1, 3, 5 et 8. Pour les productions guidées : [définir la tâche](https://otexts.com/fpp3/intro.html#sec-basic-steps), [mesurer les erreurs](https://otexts.com/fpp3/toolbox.html#sec-accuracy) et [lire les intervalles](https://otexts.com/fpp3/toolbox.html#sec-prediction-intervals). Les données ont été générées par `scripts/10_create_second_block_data.R` pour l’enseignement.
