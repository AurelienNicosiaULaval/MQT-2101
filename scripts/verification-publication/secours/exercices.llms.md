# Exercices - Module 09

## Objectif

Le transfert concerne quatre succursales fictives. Il demande une décision opérationnelle sur la capacité et le contrôle de fuites, différente du scénario promotion/prix du cas guidé. Ouvrez le projet de transfert, essayez chaque exercice, puis ouvrez son corrigé. Les exercices 1 à 4 construisent le rapport `variables_succursales.qmd`. Faites le premier après la capsule 1, le deuxième après la capsule 3, puis les deux derniers après la capsule 5. Tous les blocs d’un même corrigé s’exécutent ensemble après la préparation. Les exercices 5 à 10 offrent une pratique au choix.

Ouvrez `variables-succursales.Rproj` dans RStudio, puis rendez une première fois le rapport de départ. Notez vos décisions dans ce document. Avant de passer au corrigé, vérifiez que vous pouvez expliquer les unités, la date à laquelle vous décidez et la provenance des valeurs utilisées.

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

Imaginez une réunion tenue après la clôture de décembre. Une ligne de votre tableau est une succursale pendant un mois. Dans votre rapport, préparez une ligne par variable avec le mois auquel elle se rapporte, la pièce qui établirait sa disponibilité et la décision de la conserver, de la scénariser ou de l’exclure.

Une équipe souhaite prévoir les ventes du mois suivant avec promotion, capacité, achalandage, ruptures, temps d’attente, satisfaction et ventes du mois courant. Classez-les selon leur disponibilité à l’origine. Proposez une solution pour une variable indisponible.

> **TIP:**
>
> | Variable proposée | Ce qu’il faudrait vérifier | Traitement défendable pour janvier |
> |----|----|----|
> | Promotion et capacité | Plan approuvé pour janvier, daté avant la décision | Utiliser le plan si disponible, autrement fixer une hypothèse |
> | Ventes de décembre | Clôture et transmission avant la réunion | Construire le retard séparément à chaque succursale |
> | Achalandage et ruptures de janvier | Comptage au cours du mois cible | Retirer les valeurs réalisées ou produire une prévision distincte |
> | Attente et satisfaction de janvier | Mesures recueillies pendant le service | Les réserver au suivi après le mois ou préciser un scénario défendable |
>
> Une promotion approuvée et une capacité annoncée peuvent être connues, sous réserve du calendrier réel. Les ventes du mois courant ne sont utilisables que si elles sont effectivement disponibles à l’origine. L’achalandage, les ruptures, l’attente et la satisfaction du mois cible sont observés après coup : leur utilisation telle quelle créerait une fuite. On peut prévoir ou scénariser une variable, puis nommer l’incertitude, ou la retirer.

## Exercice 2 - Diagnostiquer par succursale

Ajustez un modèle simple sur 2020 à 2024, puis calculez l’autocorrélation de rang 1 des résidus séparément par succursale. Pourquoi ne pas joindre la fin d’une succursale au début de la suivante ?

Avant de calculer, comptez les paires que 60 mois permettent de former dans une succursale. Après le calcul, choisissez la succursale où le coefficient est le plus éloigné de zéro. Décrivez son signe, puis dites ce qu’il faudrait regarder avant de proposer un modèle différent.

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
> Avec la corrélation de Pearson entre les 59 paires, on trouve environ −0,009 à Gatineau, +0,085 à Montréal, +0,119 à Québec et −0,185 à Sherbrooke. À Sherbrooke, deux écarts consécutifs tendent légèrement à aller en sens opposé. La valeur reste modeste. Avant de modifier le modèle, examinez si cette tendance est régulière ou portée par quelques mois.
>
> ``` r
> entrainement_service |>
>   mutate(residu = residuals(modele_base)) |>
>   ggplot(aes(date, residu / 1000)) +
>   geom_hline(yintercept = 0, colour = "grey65") +
>   geom_line(colour = "#28536B") + facet_wrap(~ succursale) +
>   labs(x = "Mois", y = "Résidu (milliers de dollars)") + theme_minimal()
> ```
>
> ![](exercices_files/figure-html/unnamed-chunk-2-1.png)
>
> Chaque panneau possède sa propre chronologie. Un seul calcul sur les 240 lignes triées donnerait 239 paires, dont trois relieraient artificiellement deux succursales. Le bon calcul en donne 4 × 59 = 236, réparties entre quatre coefficients. La fonction `acf()` du cas guidé utilise une normalisation différente de `cor()` sur les paires. De petits écarts numériques entre les deux calculs sont possibles.
>
> Les retards sont calculés après tri dans chaque groupe. Une moyenne de résidus proche de zéro ne suffit pas : des signes semblables peuvent se suivre. Les frontières entre succursales ne sont pas des mois consécutifs d’une même série.

## Exercice 3 - Comparer des scénarios

Depuis la fin de 2025, construisez deux scénarios pour janvier 2026 à Québec : capacité stable ou augmentée de 5 %, promotion non et dernières ventes connues. Utilisez le même modèle et interprétez la différence sans conclure à un effet causal. Pour appuyer votre réponse, comparez la plage des capacités observées à Québec à celle de l’ensemble des succursales. Identifiez le type de comparaison qui renseigne la pente de capacité dans ce fichier.

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
> ``` r
> service |>
>   group_by(succursale) |>
>   summarise(mois = n(), minimum = min(capacite), maximum = max(capacite),
>             valeurs_distinctes = n_distinct(capacite), .groups = "drop")
> ```
>
>     # A tibble: 4 × 5
>       succursale  mois minimum maximum valeurs_distinctes
>       <fct>      <int>   <dbl>   <dbl>              <int>
>     1 Gatineau      72    2100    2100                  1
>     2 Montréal      72    3300    3300                  1
>     3 Québec        72    2400    2400                  1
>     4 Sherbrooke    72    1850    1850                  1
>
> On observe 1 850 unités à Sherbrooke, 2 100 à Gatineau, 2 400 à Québec et 3 300 à Montréal. Dans chaque succursale, le minimum et le maximum coïncident. Les 2 520 unités envisagées se trouvent entre les extrêmes globaux, mais hors de toute expérience antérieure à Québec. Les ventes et la capacité peuvent varier entre succursales pour d’autres raisons, dont la taille du marché desservi.
>
> La capacité varie entre succursales dans ces données, mais ne varie pas dans le temps à l’intérieur de chacune; sa pente peut refléter des différences entre succursales. Une hausse hypothétique pour Québec peut extrapoler et n’est pas une estimation causale. À Québec, les 72 mois ont une capacité de 2 400 unités. Le modèle commun prévoit environ 196 781 \$ à cette capacité et 205 502 \$ à 2 520 unités. L’écart prédit d’environ 8 721 \$ dépend de l’hypothèse que l’association entre succursales se transpose à un changement de capacité à Québec.

## Exercice 4 - Formuler une recommandation

Rédigez une recommandation distinguant fuite d’information, diagnostic par succursale et scénario. Nommez un risque d’extrapolation.

> **TIP:**
>
> Exemple de note à la direction de Québec :
>
> > Pour janvier 2026, en supposant l’absence de promotion et les ventes de décembre connues à la clôture, le modèle donne environ 196 800 \$ à la capacité actuelle et 205 500 \$ à 2 520 unités. L’écart d’environ 8 700 \$ peut servir à chiffrer un scénario de planification. Québec a conservé 2 400 unités pendant les six années observées. Pour éclairer un investissement, il nous faudrait des observations de changements de capacité comparables, avec leur contexte et leur coût.
>
> Une bonne réponse distingue les deux dates de travail. Le diagnostic de l’exercice 2 s’arrête fin 2024 pour toutes les succursales. Pour préparer une décision à la fin de 2025, le modèle de scénario peut intégrer les ventes jusqu’à décembre 2025. La recommandation doit préciser cette origine et expliquer pourquoi la capacité de la succursale limite l’interprétation du contraste.
>
> Retirer les variables du mois cible connues après coup, ou utiliser une prévision distincte explicitement incertaine. Examiner les résidus dans chaque succursale et au fil du temps. Présenter la hausse de capacité comme un scénario conditionnel et vérifier si la valeur envisagée se situe dans la plage des données et convient à Québec.

## Pratique supplémentaire

Choisissez la difficulté qui correspond à votre hésitation. Les exercices 5 à 7 portent sur les dates, les diagnostics et les événements. Les exercices 8 à 10 font travailler un coefficient, une comparaison d’erreurs et une décision de gestion. Ces exercices peuvent être faits sans ouvrir un troisième projet.

### Exercice 5 - Retard et horizon

À la fin de décembre, les ventes de décembre sont connues. Peut-on les utiliser pour prévoir janvier et février?

> **TIP:**
>
> Pour janvier, oui si la mesure de décembre est disponible à l’origine. Pour février, le retard d’un mois serait la vente de janvier, encore inconnue à la fin de décembre; il faut la prévoir, utiliser un autre retard disponible ou mettre à jour la prévision après janvier.

### Exercice 6 - Interpréter une p-valeur

Le test de Ljung-Box donne une valeur p de 0,30. Peut-on affirmer que les résidus sont indépendants?

> **TIP:**
>
> Non. Le test ne fournit pas assez d’évidence contre l’absence d’autocorrélations examinées, mais une p-valeur élevée ne démontre ni l’indépendance ni l’absence de structure. Examiner aussi le graphique et la taille de l’échantillon.

### Exercice 7 - Événement spécial

Une panne exceptionnelle réduit les ventes une fois. Faut-il supprimer le mois?

> **TIP:**
>
> Vérifier d’abord si la donnée est erronée et documenter la cause. Selon la question, comparer une analyse avec et sans ce mois ou ajouter un indicateur d’événement; ne pas le supprimer automatiquement. Une prévision future requiert aussi un scénario sur la présence de l’événement.

### Exercice 8 - Deux profils qui changent ensemble

Le modèle ajusté associe une promotion à +47 566 \$ et une hausse du prix de 1 \$ à −4 895 \$ de ventes. La direction envisage la promotion et une baisse de prix de 2 \$. Le mois, la tendance et l’indice sont identiques dans les deux profils. Calculez le contraste, nommez ses unités et précisez la vérification à faire avant de le présenter.

> **TIP:**
>
> Le passage de 0 à 1 pour la promotion apporte 47 566 \$ dans l’équation. La variation de prix vaut −2 \$. Sa contribution vaut donc (−4 895) × (−2) = +9 790 \$. Ensemble, les coefficients arrondis donnent un écart de 57 356 \$ de ventes mensuelles. Une erreur fréquente consiste à soustraire 9 790 \$ parce que le prix diminue. Il faut tenir compte aussi du signe de sa pente.
>
> Vérifiez que les deux prix sont crédibles dans leurs groupes respectifs. Le calcul porte sur deux scénarios. Il ne suffit pas pour conclure que les ventes augmenteraient effectivement de cette somme en lançant une campagne.

### Exercice 9 - Deux critères, deux classements

Pour trois mois réservés à la comparaison, les erreurs en milliers de dollars sont (0, 0, 9) pour A et (4, 4, 4) pour B. Calculez MAE et RMSE à la main. Quel candidat choisiriez-vous si une grosse erreur perturbe fortement les opérations ? Que manque-t-il pour départager les candidats dans une décision réelle ?

> **TIP:**
>
> Pour A, la MAE est (0 + 0 + 9)/3 = 3 et la RMSE vaut √(81/3) ≈ 5,20. Pour B, MAE et RMSE valent toutes deux 4. Multipliez par 1 000 pour lire les écarts en dollars. A obtient la plus petite MAE, mais B évite la grande erreur sur le troisième mois.
>
> Un choix de B se défend si l’organisation accorde un coût particulièrement élevé aux grandes erreurs. Il faudrait connaître ce coût, vérifier que les méthodes ont reçu les mêmes informations au même moment et évaluer d’autres mois représentatifs. Une seule moyenne ne tranche pas une décision dont le coût dépend du sens ou de la taille de l’erreur.

### Exercice 10 - Relire une note d’investissement

Un collègue écrit : « 2 520 unités se trouvent dans la plage de notre réseau. Agrandir Québec rapportera 8 721 \$ par mois. » Relevez deux glissements dans cette phrase. Proposez une formulation utilisable en réunion et une donnée qui renforcerait la décision.

> **TIP:**
>
> Le premier glissement va du réseau entier à l’histoire locale. Québec est toujours à 2 400 unités. Le deuxième transforme un contraste de ventes prévues en rendement causal, puis implicitement en gain financier. Le modèle prédit des ventes brutes et ne contient ni coûts d’agrandissement ni marge.
>
> Une phrase acceptable serait : « Pour janvier 2026, le modèle commun associe le passage hypothétique à 2 520 unités à environ 8 700 \$ de ventes supplémentaires à Québec, sous les autres hypothèses retenues. Cette capacité est nouvelle à Québec. » Un historique avant et après des changements de capacité dans plusieurs succursales, avec dates, coûts et évolutions locales de la demande, aiderait à examiner la décision.

## Auto-vérification

J’ai calculé les retards et examiné les résidus en respectant l’ordre des mois dans chaque succursale.

Ma recommandation situe la décision à Québec et nomme la cible et le mois visé.

Je vérifie si la capacité envisagée a déjà été observée à Québec et j’explique pourquoi les ventes prévues ne mesurent pas l’effet causal d’un agrandissement.
