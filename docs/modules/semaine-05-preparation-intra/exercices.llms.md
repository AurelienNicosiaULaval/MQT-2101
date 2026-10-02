# Exercices progressifs - Module 05

## Huit situations à examiner

Prévoyez environ 80 minutes, en deux séances si nécessaire. Vous travaillez comme une personne qui doit vérifier un rapport avant qu’une décision soit prise : retrouver le bon dénominateur, réparer une lecture, déceler une comparaison trompeuse et préciser ce qu’un modèle permet de dire.

Tous les mini-cas de cette page sont fictifs. Leurs données sont construites pour l’entraînement et ne décrivent aucune organisation réelle. Les contextes, tableaux et décisions diffèrent de ceux des exemples commentés. Les outils restent ceux des modules 01 à 04.

Les cas 1 à 7 peuvent être traités séparément. Le cas 8 revient sur l’imprimerie du cas 4 pour confronter une estimation de coût à son incertitude. Pour chaque exercice, conservez une première réponse avant d’ouvrir sa solution. Une autre formulation est recevable si elle justifie le résultat, ses unités et ses limites.

Travaillez avec R et les ressources du cours. Les tableaux se créent directement avec les blocs fournis; aucun téléchargement ni nouveau package n’est nécessaire. Exécutez cette préparation, puis le bloc de données du cas choisi :

``` r
library(tidyverse)
```

Ces activités sont formatives et ne sont pas les questions du futur examen. Après correction, passez à la [pratique individuelle sans aide ni IA](../../modules/semaine-05-preparation-intra/pratique.llms.md).

Pour une séance de reprise, la [série de vrai ou faux et de choix multiples](../../modules/semaine-05-preparation-intra/questions-courtes.llms.md) propose 24 décisions courtes à justifier, avec les corrigés regroupés à la fin. Faites une première tentative complète sans aide, puis comparez votre raisonnement aux explications.

## Exercice 1 - Le fichier compte deux fois

Compétence : unité d’observation, types, agrégats, clé et valeurs manquantes. Repères : modules [01](../../modules/semaine-01-introduction/index.llms.md) et [02](../../modules/semaine-02-r-quarto/exercices.llms.md).

Une petite ressourcerie reçoit un export des masses collectées. Il devrait y avoir une ligne par jour et par point de collecte. Les lignes « Ensemble » contiennent déjà le total quotidien des deux points.

``` r
# Données fictives, fournies pour cet exercice.
collecte <- tribble(
  ~jour,         ~point,      ~code_zone, ~masse_kg,
  "2026-09-08",  "A",         101,        80,
  "2026-09-08",  "A",         101,        80,
  "2026-09-08",  "B",         202,       120,
  "2026-09-08",  "Ensemble",  999,       200,
  "2026-09-09",  "A",         101,        90,
  "2026-09-09",  "B",         202,        NA,
  "2026-09-09",  "Ensemble",  999,       150
) |>
  mutate(jour = as.Date(jour))
```

| jour       | point    | code_zone | masse_kg |
|:-----------|:---------|----------:|---------:|
| 2026-09-08 | A        |       101 |       80 |
| 2026-09-08 | A        |       101 |       80 |
| 2026-09-08 | B        |       202 |      120 |
| 2026-09-08 | Ensemble |       999 |      200 |
| 2026-09-09 | A        |       101 |       90 |
| 2026-09-09 | B        |       202 |       NA |
| 2026-09-09 | Ensemble |       999 |      150 |

Le brouillon du rapport annonce :

> « Sept collectes indépendantes ont reçu 720 kg. Les codes de zone ont une moyenne de 386,43, ce qui décrit notre clientèle. Le point B n’a rien reçu le 9 septembre. »

1.  Faites la liste des problèmes de cette phrase. Nommez l’unité des lignes détaillées, celle des lignes « Ensemble » et le type ou rôle des quatre variables.
2.  Pour estimer le total des deux jours, quelles lignes pourriez-vous utiliser, sous réserve de vérifier la fiabilité des totaux? Pour comparer A et B, quelles lignes faut-il examiner?
3.  Écrivez deux contrôles R : un pour la clé des lignes détaillées, un pour les valeurs manquantes. Quelle confirmation manque avant de supprimer la deuxième ligne A?

> **TIP:**
>
> Les lignes A et B décrivent un jour-point de collecte. Les lignes « Ensemble » décrivent un jour pour les deux points réunis : l’export mélange deux niveaux. `jour` est une date; `point` est une catégorie nominale; `code_zone` est un code d’identification, même s’il est stocké comme nombre; `masse_kg` est une mesure numérique en kilogrammes.
>
> Les sept lignes ne sont pas sept observations indépendantes de même unité. La clé du point A le 8 septembre est répétée; deux autres lignes sont des agrégats. La somme avec `na.rm = TRUE` vaut bien 720, mais elle ajoute totaux et composantes, compte deux fois A le 8 septembre et ignore une valeur inconnue. Sa justesse arithmétique ne lui donne pas un sens statistique. La moyenne des codes n’est pas une mesure de la clientèle; aucune donnée sur les personnes n’est fournie. NA ne signifie pas zéro.
>
> ``` r
> # Séparer les niveaux selon la question posée.
> details_collecte <- collecte |> filter(point != "Ensemble")
> totaux_collecte <- collecte |> filter(point == "Ensemble")
>
> details_collecte |> count(jour, point) |> filter(n > 1)
> ```
>
>     # A tibble: 1 × 3
>       jour       point     n
>       <date>     <chr> <int>
>     1 2026-09-08 A         2
>
> ``` r
> details_collecte |> summarise(masses_manquantes = sum(is.na(masse_kg)))
> ```
>
>     # A tibble: 1 × 1
>       masses_manquantes
>                   <int>
>     1                 1
>
> ``` r
> totaux_collecte |> summarise(total_declare_kg = sum(masse_kg))
> ```
>
>     # A tibble: 1 × 1
>       total_declare_kg
>                  <dbl>
>     1              350
>
> Les totaux déclarés donnent 200 + 150 = 350 kg sur les deux jours. Cela suppose que ces lignes sont fiables, complètes et couvrent bien le même périmètre. Pour comparer les points, on utilise les lignes détaillées, après résolution de la clé répétée et examen de la valeur manquante. Il faut demander si les deux lignes A proviennent d’une copie accidentelle ou de deux collectes réelles qui auraient été mal identifiées. La seule ressemblance des lignes ne justifie pas une suppression automatique.

## Exercice 2 - Le classement change de sens

Compétence : choisir un dénominateur, interpréter un résumé et corriger un code. Repère : [laboratoire 01, résumés et ratios](../../modules/atelier-01-r/guide-atelier.llms.md).

Deux programmes de formation comparent leur présence aux ateliers. Chaque ligne décrit un atelier d’un programme. On veut le taux de présence par inscription sur l’ensemble des deux ateliers, et non le taux moyen d’un atelier choisi au hasard. Une personne peut être inscrite aux deux ateliers.

``` r
presence <- tribble(
  ~programme, ~atelier, ~inscrits, ~presents,
  "A",        1,         10,         9,
  "A",        2,         90,        45,
  "B",        1,         60,        36,
  "B",        2,         40,        28
)
```

| programme | atelier | inscrits | presents |
|:----------|--------:|---------:|---------:|
| A         |       1 |       10 |        9 |
| A         |       2 |       90 |       45 |
| B         |       1 |       60 |       36 |
| B         |       2 |       40 |       28 |

Une collègue écrit :

``` r
presence |>
  group_by(programme) |>
  summarise(taux = mean(presents / inscrits), .groups = "drop")
```

Elle obtient 70 % pour A et 65 % pour B, puis écrit « A a le meilleur taux global ».

1.  Le code est-il invalide en R ou répond-il à une autre question? Expliquez le poids qu’il donne aux ateliers.
2.  Calculez le taux demandé, puis corrigez le code. Le classement reste-t-il le même?
3.  Écrivez une phrase de rapport avec le dénominateur. Peut-on en déduire le nombre de personnes différentes qui ont assisté ou l’effet causal du programme?

> **TIP:**
>
> Le code fonctionne. Il donne le même poids à deux ateliers de tailles différentes. Pour A, les taux d’atelier sont 90 % et 50 %, d’où une moyenne de 70 %. Pour B, ils sont 60 % et 70 %, d’où 65 %. Cette moyenne décrit un atelier moyen; elle ne répond pas au taux par inscription demandé.
>
> ``` r
> presence_programme <- presence |>
>   group_by(programme) |>
>   summarise(inscriptions = sum(inscrits),
>             presences = sum(presents),
>             taux_global = presences / inscriptions,
>             moyenne_taux_atelier = mean(presents / inscrits),
>             .groups = "drop")
> presence_programme
> ```
>
>     # A tibble: 2 × 5
>       programme inscriptions presences taux_global moyenne_taux_atelier
>       <chr>            <dbl>     <dbl>       <dbl>                <dbl>
>     1 A                  100        54        0.54                 0.7
>     2 B                  100        64        0.64                 0.65
>
> A a 54 présences pour 100 inscriptions, soit 54 %; B a 64 pour 100, soit 64 %. Le classement s’inverse. Le ratio des sommes pondère les taux d’atelier par les inscriptions, contrairement à leur moyenne simple.
>
> Une phrase défendable : « Sur ces deux ateliers fictifs, la présence représente 54 % des inscriptions du programme A et 64 % de celles du programme B. » Les inscriptions et présences sont des participations à des ateliers, pas nécessairement des personnes distinctes. Ce tableau ne permet pas d’isoler un effet causal du programme.

## Exercice 3 - Deux moyennes, deux histoires

Compétence : choisir et lire un graphique; confronter centre, dispersion et valeurs inhabituelles. Repères : modules [01](../../modules/semaine-01-introduction/exercices.llms.md) et [02](../../modules/semaine-02-r-quarto/exercices.llms.md).

Un centre de prêt d’équipement veut décrire la durée habituelle de préparation d’un kit et les durées inhabituelles, pour deux équipes. Chaque ligne est la préparation d’un kit, en minutes.

``` r
kits <- tibble(
  equipe = rep(c("Azimut", "Balise"), each = 10),
  minutes = c(8,9,10,10,11,12,13,14,15,48,
              13,14,14,15,15,16,16,17,17,18)
)
```

![](exercices_files/figure-html/m05-original-deux-figures-1.png)

Le rapport ne conserve que A et conclut : « Les préparations se ressemblent puisque les moyennes sont presque égales. Il faut retirer la durée de 48 minutes avant toute analyse. »

1.  Quelle figure répond le mieux à la question du centre? Que perd-on en ne gardant que A? Dans quelle question A pourrait-elle être utile?
2.  Calculez les médianes et les quartiles, puis décrivez en trois phrases ce que les moyennes masquent.
3.  La durée de 48 minutes est-elle nécessairement une erreur? Proposez une vérification avant de décider de la garder ou de la retirer.

> **TIP:**
>
> B répond mieux à la durée habituelle et aux valeurs inhabituelles : elle montre la distribution et les observations. A conviendrait à une question ciblée sur la durée moyenne, à condition d’indiquer les effectifs et de ne pas faire passer cette moyenne pour toute la distribution.
>
> ``` r
> resume_kits <- kits |>
>   group_by(equipe) |>
>   summarise(n = n(), moyenne = mean(minutes), mediane = median(minutes),
>             q1 = quantile(minutes, .25), q3 = quantile(minutes, .75),
>             .groups = "drop")
> resume_kits
> ```
>
>     # A tibble: 2 × 6
>       equipe     n moyenne mediane    q1    q3
>       <chr>  <int>   <dbl>   <dbl> <dbl> <dbl>
>     1 Azimut    10    15      11.5  10    13.8
>     2 Balise    10    15.5    15.5  14.2  16.8
>
> Les moyennes sont 15 et 15,5 minutes, mais les médianes sont 11,5 minutes pour Azimut et 15,5 pour Balise. Les intervalles interquartiles sont respectivement \[10; 13,75\] et \[14,25; 16,75\] minutes; chaque équipe a dix préparations. Azimut présente une durée de 48 minutes qui tire sa moyenne vers le haut; les petites différences de moyenne cachent ici des centres et des dispersions différents.
>
> Une valeur inhabituelle n’est pas automatiquement erronée. Il faut vérifier l’enregistrement, l’unité, le début et la fin du chronométrage ainsi que le type de kit. Les données fournies ne permettent pas de connaître la cause de cette durée. Si une exclusion est justifiée, elle doit être documentée; une suppression destinée seulement à rapprocher les deux équipes n’est pas une justification.

## Exercice 4 - Une facture multipliée par cent

Compétence : lire une sortie R, les unités d’une pente, une prédiction et un résidu. Repère : [module 03](../../modules/semaine-03-regression-lineaire/notes-cours.llms.md).

Une imprimerie associative fournit les coûts observés de dix lots. La réponse est le coût en dollars canadiens. L’explicative utilisée dans la droite est le nombre de centaines d’affiches.

``` r
impression <- tibble(
  affiches = c(100,200,300,400,500,600,800,1000,1200,1500),
  cout_ca = c(19,22,31,32,40,47,53,70,75,97)
) |>
  mutate(centaines_affiches = affiches / 100)
```


    Call:
    lm(formula = cout_ca ~ centaines_affiches, data = impression)

    Residuals:
        Min      1Q  Median      3Q     Max
    -3.3344 -2.0303  0.7229  2.0358  2.6783

    Coefficients:
                       Estimate Std. Error t value Pr(>|t|)
    (Intercept)         12.2580     1.4401   8.512 2.79e-05 ***
    centaines_affiches   5.5064     0.1823  30.204 1.57e-09 ***
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 2.502 on 8 degrees of freedom
    Multiple R-squared:  0.9913,    Adjusted R-squared:  0.9902
    F-statistic: 912.3 on 1 and 8 DF,  p-value: 1.567e-09

La fiche de calcul a arrondi les coefficients à 12,26 et 5,51, mais elle affiche :

> « Coût prévu = 12,26 + 5,51 × nombre d’affiches. »

1.  Réparez la fiche : quel nombre doit remplacer l’explicative pour un lot de 1 000 affiches? Interprétez la pente par cent affiches, puis par affiche. Que signifie l’intercept, et quelle est sa limite de plage?
2.  Avec les coefficients arrondis fournis, calculez le coût prévu de ce lot, puis le résidu d’un nouveau lot fictif de même taille coûtant 72 \$. Une enveloppe de 70 \$ est-elle garantie suffisante?
3.  Au seuil de 5 %, que dit le test de pente? Expliquez pourquoi la petite valeur p et le R² élevé ne garantissent ni le budget d’un lot particulier ni une causalité.

> **TIP:**
>
> Il faut utiliser 10 centaines, pas 1 000. La fiche correcte est \\\widehat c=\\ 12,26 \\+\\ 5,51 \\\times(\text{affiches}/100)\\. La pente représente environ 5,51 \$ pour cent affiches supplémentaires, soit environ 0,0551 \$ par affiche. Elle n’est pas de 5,51 \$ par affiche.
>
> ``` r
> modele_impression <- lm(cout_ca ~ centaines_affiches, data = impression)
> b_impression <- round(coef(modele_impression), 2)
>
> # Utiliser les coefficients arrondis demandés dans la fiche.
> c_prevu <- b_impression[1] + b_impression[2] * (1000 / 100)
> c(cout_prevu = unname(c_prevu), residu_lot_72 = unname(72 - c_prevu))
> ```
>
>        cout_prevu residu_lot_72
>             67.36          4.64
>
> ``` r
> # Le logiciel utilise les coefficients non arrondis.
> predict(modele_impression, newdata = tibble(centaines_affiches = 10))
> ```
>
>            1
>     67.32166
>
> ``` r
> range(impression$affiches)
> ```
>
>     [1]  100 1500
>
> Le calcul manuel donne 67,36 \$. Le résidu est 4,64 \$ : positif, il indique une sous-estimation de ce lot. L’écart minime avec `predict()` vient de l’arrondi des coefficients. Le point estimé est sous 70 \$, mais la dispersion ne disparaît pas; cela ne garantit pas le coût d’un lot particulier. Le cas 8 examine cette incertitude.
>
> L’intercept vise zéro affiche, hors de la plage de 100 à 1 500 affiches observée. Il ne suffit pas à démontrer un tarif fixe facturé dans la réalité. On rejette une pente nulle au seuil de 5 %, sous les hypothèses classiques. Le R² décrit environ 99,1 % de la variation des coûts autour de leur moyenne sur ces dix lots; il ne donne pas le pourcentage de lots respectant le budget. L’analyse ne documente pas une intervention isolant un effet causal.

## Exercice 5 - Les étiquettes du rapport se sont mélangées

Compétence : comparer sur les mêmes observations et lire les résidus. Repère : [module 04](../../modules/semaine-04-regression-nonlineaire/exercices.llms.md).

Un atelier de céramique étudie la durée de finition d’un lot selon le nombre de pièces. Chaque ligne est un lot. Douze lots servent à ajuster les modèles, six autres à comparer leurs erreurs. Le rôle des lots est fixé avant l’ajustement.

``` r
ceramique <- tibble(
  pieces = c(4,4,8,8,12,12,16,16,20,20,24,24,6,10,14,18,22,23),
  minutes = c(17,18,20,23,26,28,32,35,41,44,50,52,18.5,25,29.5,39,46.5,49),
  role = c(rep("apprentissage", 12), rep("validation", 6))
)
```

| Modele      | R² apprentissage | RMSE copiée (min) | Origine de la RMSE      |
|:------------|-----------------:|------------------:|:------------------------|
| Droite      |           0,9693 |             1,321 | 6 lots de validation    |
| Quadratique |           0,9885 |             1,262 | 12 lots d’apprentissage |

Le rédacteur a aussi perdu les noms des modèles sur les graphiques de résidus d’apprentissage :

![](exercices_files/figure-html/m05-original-residus-mystere-1.png)

1.  Le classement par la colonne « RMSE copiée » est-il défendable? Identifiez ce qui doit être recalculé.
2.  Associez I et II à la droite ou à la quadratique. Justifiez avec un motif observable; vérifiez ensuite votre association avec R.
3.  Réparez le tableau avec les deux RMSE de validation, puis formulez un choix provisoire. Que n’avez-vous pas démontré avec six lots de validation?

> **TIP:**
>
> Les deux erreurs copiées utilisent des données et des rôles différents. Leur comparaison ne classe pas équitablement les modèles. Il faut calculer la RMSE des deux modèles sur les mêmes six lots de validation, avec la même réponse et la même unité.
>
> I correspond à la quadratique et II à la droite. II présente une tendance en U : les résidus sont plutôt positifs aux extrémités et négatifs au centre. Le carré permet ici de mieux représenter la forme moyenne. L’absence d’un U aussi net dans I ne valide pas toutes les hypothèses.
>
> ``` r
> apprentissage_c <- ceramique |> filter(role == "apprentissage")
> validation_c <- ceramique |> filter(role == "validation")
> droite_c <- lm(minutes ~ pieces, data = apprentissage_c)
> quad_c <- lm(minutes ~ pieces + I(pieces^2), data = apprentissage_c)
>
> # Une même réponse et les mêmes six lignes pour les deux erreurs.
> erreurs_c <- tibble(
>   modele = c("Droite", "Quadratique"),
>   n_validation = nrow(validation_c),
>   rmse_validation = c(
>     sqrt(mean((validation_c$minutes - predict(droite_c, validation_c))^2)),
>     sqrt(mean((validation_c$minutes - predict(quad_c, validation_c))^2))
>   )
> )
> erreurs_c
> ```
>
>     # A tibble: 2 × 3
>       modele      n_validation rmse_validation
>       <chr>              <int>           <dbl>
>     1 Droite                 6           1.32
>     2 Quadratique            6           0.793
>
> ``` r
> # Retrouver les étiquettes des résidus pour vérifier la lecture.
> tibble(figure = "I", residu = residuals(quad_c), ajuste = fitted(quad_c))
> ```
>
>     # A tibble: 12 × 3
>        figure residu ajuste
>        <chr>   <dbl>  <dbl>
>      1 I      -0.411   17.4
>      2 I       0.589   17.4
>      3 I      -1.58    21.6
>      4 I       1.42    21.6
>      5 I      -1.04    27.0
>      6 I       0.957   27.0
>      7 I      -1.81    33.8
>      8 I       1.19    33.8
>      9 I      -0.889   41.9
>     10 I       2.11    41.9
>     11 I      -1.27    51.3
>     12 I       0.732   51.3
>
> ``` r
> tibble(figure = "II", residu = residuals(droite_c), ajuste = fitted(droite_c))
> ```
>
>     # A tibble: 12 × 3
>        figure residu ajuste
>        <chr>   <dbl>  <dbl>
>      1 II      1.76    15.2
>      2 II      2.76    15.2
>      3 II     -2.01    22.0
>      4 II      0.990   22.0
>      5 II     -2.78    28.8
>      6 II     -0.781   28.8
>      7 II     -3.55    35.6
>      8 II     -0.552   35.6
>      9 II     -1.32    42.3
>     10 II      1.68    42.3
>     11 II      0.905   49.1
>     12 II      2.90    49.1
>
> Les RMSE de validation sont environ 1,321 minute pour la droite et 0,793 minute pour la quadratique. On retient provisoirement la quadratique selon ce critère et le diagnostic observé. Son R² plus grand ne suffit pas, à lui seul, à justifier ce choix.
>
> Ces six lots ne démontrent pas une supériorité universelle, un effet causal du nombre de pièces ni la validité du modèle pour toute production. La validation utilisée pour choisir n’est pas un test final indépendant. Il faut aussi connaître les conditions de fabrication et examiner la stabilité du résultat; le fichier seul ne valide pas l’indépendance des erreurs.

## Exercice 6 - Une recommandation qui oublie les couleurs

Compétence : lire un nuage par groupe et corriger une conclusion causale. Repère : [module 03, lecture du nuage et limites](../../modules/semaine-03-regression-lineaire/exercices.llms.md).

Un service de bibliothèque compare huit comptoirs. La réponse est l’attente moyenne, en minutes; l’explicative est le nombre de bornes en service. Deux types de comptoirs sont présents.

``` r
bornes <- tibble(
  nombre_bornes = 1:8,
  attente_minutes = c(6,5,4,3,14,13,12,11),
  type_comptoir = rep(c("Quartier", "Pôle de services"), each = 4)
)
```

![](exercices_files/figure-html/m05-original-groupes-1.png)

Le brouillon d’un message à la direction dit :

> « La pente globale est positive : les bornes créent de l’attente. Nous devrions retirer deux bornes de chaque comptoir. »

1.  Décrivez séparément la tendance globale et celle visible à l’intérieur de chaque couleur.
2.  Proposez une information de contexte à recueillir, sans prétendre que vous connaissez déjà la cause du motif.
3.  Réécrivez le message en trois ou quatre phrases : un résultat observé, une limite et une suite raisonnable. N’affirmez pas non plus un effet causal inverse.

> **TIP:**
>
> ``` r
> modele_bornes <- lm(attente_minutes ~ nombre_bornes, data = bornes)
> coef(modele_bornes)
> ```
>
>       (Intercept) nombre_bornes
>          2.714286      1.285714
>
> La droite globale est croissante, avec une pente d’environ 1,29 minute par borne. Dans chacun des deux types, les attentes fournies diminuent quand le nombre de bornes augmente. Le regroupement de comptoirs différents change la lecture de l’association. Cela ne démontre aucun des deux effets causaux possibles.
>
> La fréquentation, le type de demandes, les horaires et les effectifs sont des informations à recueillir. Elles ne sont pas mesurées dans ce fichier; il ne faut pas affirmer qu’une d’entre elles explique déjà le motif. Aucune régression multiple n’est nécessaire pour repérer cette limite sur le nuage.
>
> Exemple de message corrigé : « Dans ces huit comptoirs fictifs, la droite globale relie davantage de bornes à une attente moyenne plus longue, mais chaque type montre une tendance décroissante. La comparaison mélange deux types de comptoirs et ne documente pas une intervention sur les bornes. Elle ne justifie donc pas de retirer deux bornes partout, ni d’affirmer qu’en ajouter réduirait nécessairement l’attente. Il faut documenter la fréquentation et les conditions de service avant de recommander une modification. »

## Exercice 7 - La notice ne correspond pas aux modèles

Compétence : lire une quadratique, un logarithme et leur code; calculer une variation avec unités. Repère : [module 04, formes enseignées](../../modules/semaine-04-regression-nonlineaire/exercices.llms.md#exercice-07).

Un prototype de formation fournit deux modèles fictifs du temps de réponse à une tâche. \\n\\ est le nombre d’essais d’entraînement, \\t\\ un temps en secondes. La plage supposée d’observation est de 5 à 20 essais.

\\\widehat t_Q(n)=80-5n+0{,}15n^2, \qquad \widehat t_L(n)=90-12\ln(n).\\

Sa notice affirme :

> « `lm()` ne peut pas représenter ces courbes. Dans Q, chaque essai supplémentaire retire toujours cinq secondes. Dans L, doubler le nombre d’essais retire douze secondes. »

1.  Vérifiez la phrase sur Q en calculant les différences de 5 à 6 essais et de 15 à 16 essais.
2.  Vérifiez la phrase sur L de 5 à 10, puis de 10 à 20 essais. Indiquez la condition de définition du logarithme et les unités de vos différences.
3.  Réparez ces deux propositions de code pour représenter exactement les formes données :

``` r
lm(temps_secondes ~ n + n^2, data = formation)
lm(log(temps_secondes) ~ n, data = formation)
```

Expliquez aussi pourquoi `lm()` convient. Une réponse correcte ne nécessite ni dérivée ni nouvelle méthode.

> **TIP:**
>
> ``` r
> q <- function(n) 80 - 5*n + .15*n^2
> l <- function(n) 90 - 12*log(n)
> c(q_5_vers_6 = q(6)-q(5), q_15_vers_16 = q(16)-q(15),
>   l_5_vers_10 = l(10)-l(5), l_10_vers_20 = l(20)-l(10))
> ```
>
>       q_5_vers_6 q_15_vers_16  l_5_vers_10 l_10_vers_20
>        -3.350000    -0.350000    -8.317766    -8.317766
>
> Q donne des différences de -3,35 secondes et -0,35 seconde. Le terme carré change avec n, donc le coefficient -5 n’est pas une variation constante de la prédiction. L donne dans les deux cas \\-12\ln(2)\approx-8{,}32\\ secondes. Un doublement donne ici la même différence en secondes, qui ne vaut ni -12 secondes ni une réduction garantie du temps d’une personne.
>
> Le logarithme exige n strictement positif. Les trois phrases de la notice sont à corriger. Les formes sont linéaires en leurs coefficients, ce qui permet `lm()`, même si leur relation avec n est courbée. Les formules correctes sont :
>
> ``` r
> # Tableau construit avec Q pour rendre les formules exécutables.
> # Il ne contient pas de mesures observées.
> formation <- tibble(n = 5:20, temps_secondes = q(n))
> forme_q <- lm(temps_secondes ~ n + I(n^2), data = formation)
> forme_l <- lm(temps_secondes ~ log(n), data = formation)
> ```
>
> `I(n^2)` demande le carré numérique. Dans la deuxième forme, le logarithme porte sur n et la réponse reste en secondes. Le tableau R est construit avec Q seulement pour vérifier les deux syntaxes. L’ajustement logarithmique sur ce tableau n’est pas la source des coefficients de L. Les différences demandées se calculent avec les deux équations fournies, sans prétendre à des mesures réelles. On ne généralise pas les prédictions au-delà de 5 à 20 essais.

## Exercice 8 - Une moyenne dans le budget, un lot qui peut le dépasser

Compétence : distinguer intervalles de moyenne et de prédiction, lire R² et conclure avec incertitude. Repère : [module 03, prédiction et incertitude](../../modules/semaine-03-regression-lineaire/notes-cours.llms.md).

Reprenez l’imprimerie du cas 4. Pour 1 000 affiches, le logiciel utilise ses coefficients non arrondis et produit les intervalles suivants, à 95 %, sous les hypothèses classiques du modèle. Les noms des deux intervalles ont été retirés.

| Intervalle | Estimation (\$ CA) | Borne inférieure (\$ CA) | Borne supérieure (\$ CA) |
|:---|---:|---:|---:|
| A | 67,32 | 61,1 | 73,54 |
| B | 67,32 | 65,0 | 69,64 |

Les sommes de carrés de l’ajustement, arrondies à deux décimales, sont SSE = 50,09 et SST = 5 762,40 dollars carrés.

La responsable écrit :

> « L’intervalle B est sous 70 \$, donc chaque prochain lot de 1 000 affiches restera dans notre enveloppe. Le R² élevé signifie que presque tous les lots respecteront ce plafond. »

1.  Retrouvez le nom de A et B. Pourquoi leur largeur diffère-t-elle?
2.  Calculez R² à partir des sommes fournies, puis corrigez son interprétation.
3.  Répondez à la responsable en deux phrases, avec une valeur, l’unité et une réserve. Que faut-il vérifier avant d’utiliser ces intervalles dans une décision réelle?

> **TIP:**
>
> A est l’intervalle de prédiction d’un nouveau lot de 1 000 affiches; B est l’intervalle de confiance du coût moyen à cette taille. A est plus large parce qu’il ajoute la dispersion d’un nouveau lot autour de cette moyenne. L’intervalle de confiance d’une moyenne ne borne pas tous les coûts individuels.
>
> ``` r
> modele_impression <- lm(cout_ca ~ centaines_affiches, data = impression)
> sse_impression <- sum(residuals(modele_impression)^2)
> sst_impression <- sum((impression$cout_ca-mean(impression$cout_ca))^2)
> 1 - sse_impression / sst_impression
> ```
>
>     [1] 0.991307
>
> ``` r
> predict(modele_impression, tibble(centaines_affiches = 10), interval = "confidence")
> ```
>
>            fit      lwr      upr
>     1 67.32166 65.00374 69.63957
>
> ``` r
> predict(modele_impression, tibble(centaines_affiches = 10), interval = "prediction")
> ```
>
>            fit      lwr      upr
>     1 67.32166 61.10318 73.54013
>
> R² vaut environ 0,9913, soit 99,1 % de la variation observée des coûts autour de leur moyenne décrite sur l’ajustement. Il ne mesure pas la proportion de lots dont le coût est sous 70 \$.
>
> Une réponse possible : « Pour 1 000 affiches, le coût moyen estimé est d’environ 67,32 \$, mais l’intervalle de prédiction à 95 % d’un nouveau lot va d’environ 61,10 \$ à 73,54 \$, sous les hypothèses du modèle. Une partie de cet intervalle dépasse 70 \$, donc la droite ne garantit pas le respect de l’enveloppe pour un lot particulier. » Cela ne calcule pas, à lui seul, la probabilité de dépasser le budget.
>
> Il faut examiner la forme moyenne, les résidus, l’indépendance et la variance constante des erreurs, avec normalité pour ces intervalles classiques exacts. Il faut aussi vérifier le contexte des nouveaux lots et les unités; la plage observée contient bien 1 000 affiches. Ces intervalles ne garantissent aucune valeur particulière et ne démontrent pas une causalité.

## Après les huit cas

Avec la [grille d’autoévaluation](../../modules/semaine-05-preparation-intra/autoevaluation.llms.md), choisissez deux erreurs précises à reprendre. Fermez les solutions, puis faites la [série individuelle sans aide ni IA](../../modules/semaine-05-preparation-intra/pratique.llms.md). L’objectif est de retrouver les bons gestes quand la présentation, les unités et la décision changent.

Deux jours plus tard, utilisez les [vrai ou faux et choix multiples](../../modules/semaine-05-preparation-intra/questions-courtes.llms.md) pour vérifier vos décisions et leurs justifications dans d’autres situations.
