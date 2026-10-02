# Pratique individuelle sans aide - Module 05

## Consigne de pratique

Prévoyez environ 60 minutes pour les dix questions, puis 30 minutes pour la correction et l’autoévaluation. Répondez individuellement, sans notes, sans exécuter R, sans consulter les solutions et sans IA. Les tableaux, sorties et équations de cette page donnent les informations nécessaires. Vous pouvez poser les calculs sur papier; l’objectif est d’expliquer le raisonnement. Cette consigne d’entraînement ne définit pas le matériel autorisé à l’examen.

Ces questions portent sur les compétences des modules 01 à 04. Elles sont formatives et ne constituent ni une annonce ni une reproduction des questions du futur examen. Les mini-cas explicitement fictifs servent uniquement à illustrer les calculs et erreurs de raisonnement.

Conservez vos premières réponses. Si vous bloquez, indiquez ce qui manque puis poursuivez. Les solutions expliquées se trouvent après les dix questions et restent fermées par défaut. Consultez-les après votre tentative complète.

## Q1. Unité et qualité

Un extrait fictif a pour clé attendue la paire mois-succursale :

| Mois | Code de succursale | Clients | Ventes (\$ CA) | Satisfaction moyenne sur 10 |
|----|---:|---:|---:|---:|
| 2025-01-01 | 101 | 2 000 | 125 000 | 8,2 |
| 2025-02-01 | 101 | 2 100 | 132 000 | NA |
| 2025-02-01 | 101 | 2 100 | 132 000 | NA |
| 2025-02-01 | 202 | 1 600 | 99 000 | 7,8 |

Nommez l’unité, le type ou rôle des cinq colonnes et deux vérifications nécessaires avant l’analyse. Expliquez pourquoi le code de succursale ne doit pas être moyenné et pourquoi NA n’est pas zéro.

## Q2. Choisir un graphique

Justifiez un graphique pour chacune des demandes, avec ses axes :

1.  Décrire la distribution des délais moyens de livraison en jours.
2.  Comparer les taux de retour entre trois saisons.
3.  Examiner l’association entre clients mensuels et ventes mensuelles.
4.  Comparer les ventes totales déjà calculées pour cinq succursales sur la même période.

## Q3. Lire un tableau et son dénominateur

Voici les résumés calculés sur le fichier simulé de la PME; les taux sont déjà en pourcentage.

| Saison    | Nombre de lignes | Médiane (%) | Q1 (%) | Q3 (%) |
|:----------|-----------------:|------------:|-------:|-------:|
| haute     |               10 |        4,15 |   3,40 |  4,625 |
| moyenne   |               15 |        3,70 |   2,75 |  4,500 |
| reguliere |               35 |        4,20 |   2,85 |  4,650 |

Comparez deux saisons en une phrase chiffrée, puis donnez une limite tenant compte des effectifs et du recouvrement des distributions.

Dans un autre mini-cas fictif, une succursale a 10 000 \$ de ventes pour 100 clients un mois, puis 36 000 \$ pour 600 clients le mois suivant. Calculez les ventes par client sur l’ensemble des deux mois. Pourquoi ce résultat diffère-t-il de la moyenne simple des deux ratios mensuels?

## Q4. Corriger un code court

La question est : « Quels sont le total des ventes et le nombre de scores de satisfaction disponibles par succursale? » Une personne écrit, après une importation correcte :

``` r
pme |>
  drop_na() |>
  group_by(succursale) |>
  summarise(ventes_totales = mean(ventes),
            satisfaction_moyenne = mean(satisfaction),
            scores_disponibles = n())
```

Repérez trois problèmes et proposez le bloc corrigé. Les ventes sont complètes et seules certaines satisfactions ou certains délais sont manquants.

## Q5. Interpréter une sortie R

Le fichier contient une ligne par mois-succursale. `clients` compte les clients du mois et `ventes` est en dollars canadiens. La plage observée des clients est de 1 600 à 2 999.


    Call:
    lm(formula = ventes ~ clients, data = pme)

    Residuals:
         Min       1Q   Median       3Q      Max
    -17130.8  -6223.9   -527.5   6576.0  20804.8

    Coefficients:
                Estimate Std. Error t value Pr(>|t|)
    (Intercept) -8206.20    8557.60  -0.959    0.342
    clients        65.40       3.93  16.643   <2e-16 ***
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 9566 on 58 degrees of freedom
    Multiple R-squared:  0.8269,    Adjusted R-squared:  0.8239
    F-statistic:   277 on 1 and 58 DF,  p-value: < 2.2e-16

1.  Nommez la réponse et l’explicative. Interprétez la pente pour 100 clients supplémentaires et l’intercept.
2.  Au seuil de 5 %, quelle décision prenez-vous pour \\H_0:\beta_1=0\\? Que la valeur p ne permet-elle pas d’affirmer?
3.  Interprétez le R². Si l’on conserve une régression simple avec constante, quel lien a-t-il avec la corrélation? Le R² vous donne-t-il le signe de celle-ci?

## Q6. Prédiction, résidu et plage

Utilisez uniquement les coefficients affichés et arrondis de Q5 : intercept -8 206,20 \$, pente 65,40 \$ par client.

1.  Calculez les ventes prédites pour 2 500 clients.
2.  Pour une observation fictive de 160 000 \$ à 2 500 clients, calculez le résidu et interprétez son signe.
3.  Peut-on recommander la même droite pour 6 000 clients? Justifiez avec la plage fournie.

## Q7. Lire des résidus

Les deux figures suivantes sont schématiques; leurs points sont construits pour illustrer des motifs de diagnostic, sans représenter les résultats d’une organisation réelle.

![](pratique_files/figure-html/m05-pratique-residus-1.png)

Pour chaque figure, nommez le motif, son implication possible et une vérification pertinente. Corrigez : « Les résidus moyens sont nuls, donc toutes les hypothèses sont validées. »

## Q8. Formes et unités

Mini-cas fictif de consommation d’énergie : x est un nombre de lots de production, y une consommation en kWh. Les modèles fournis servent au calcul; la plage observée supposée est de 1 à 4 lots.

\\\widehat y_Q=100+20x-2x^2,\qquad \widehat y_L=100+50\ln(x).\\

1.  Avec la quadratique, calculez la consommation estimée à x = 2, puis les différences pour passer de 2 à 3 lots et de 3 à 4 lots. Le coefficient 20 est-il une variation constante par lot?
2.  Avec le logarithme, calculez la différence de consommation estimée pour une hausse de 10 % de x. Indiquez l’unité et la condition sur x.
3.  Corrigez la formule `y ~ x + x^2` pour représenter le carré numérique et expliquez pourquoi `lm()` convient à ces formes.

## Q9. Comparer équitablement

Les deux modèles ci-dessous sont ajustés sur les mêmes 45 observations de janvier à septembre du fichier de la PME. La validation porte sur les mêmes 15 observations d’octobre à décembre. Toutes les erreurs sont en dollars canadiens.

| Modèle | R² apprentissage | RMSE apprentissage (\\)\| RMSE validation (\\) |  |
|:---|---:|---:|---:|
| Droite | 0,8434 | 7735 | 14365 |
| Quadratique | 0,8469 | 7646 | 15486 |

1.  Quel modèle retenez-vous provisoirement selon la RMSE de validation? Pourquoi le plus grand R² ne suffit-il pas?
2.  Pourquoi serait-il invalide de comparer la RMSE d’apprentissage de la quadratique à la RMSE de validation de la droite?
3.  Deux erreurs de validation fournies dans un mini-cas fictif sont -3 \$ et +4 \$. Calculez leur MAE et leur RMSE. La moyenne signée suffit-elle à résumer leur taille?
4.  La validation ayant servi à choisir constitue-t-elle un test final indépendant? Quelle limite vient des succursales répétées?

## Q10. Intervalles et conclusion

Le modèle de Q5 fournit ces résultats pour 2 500 clients, sous les hypothèses classiques :

| intervalle        |     fit |     lwr |     upr |
|:------------------|--------:|--------:|--------:|
| Confiance à 95 %  | 155 297 | 151 626 | 158 969 |
| Prédiction à 95 % | 155 297 | 135 801 | 174 794 |

Une directrice écrit :

> « La droite prouve qu’une campagne qui amène 100 clients de plus causera la hausse prévue des ventes. L’intervalle de confiance donne les ventes garanties de la prochaine observation mensuelle. Nous pouvons utiliser ce résultat dans toute nouvelle succursale. »

Corrigez en trois ou quatre phrases. Interprétez `fit`, choisissez l’intervalle correspondant à une nouvelle observation et indiquez une hypothèse ou une limite pertinente.

## Correction après votre tentative

Les liens vers les compétences déjà enseignées figurent dans chaque corrigé. Attribuez un état à votre première réponse avec la [grille d’autoévaluation](../../modules/semaine-05-preparation-intra/autoevaluation.llms.md), puis expliquez la correction. Une réponse juste après consultation n’est pas encore une preuve d’autonomie.

> **TIP:**
>
> Une ligne représente un mois-succursale. `Mois` est une date désignant un mois; le code est un identifiant catégoriel nominal; clients est un compte; ventes est un montant; satisfaction est un score moyen numérique sur 10. Les unités sont respectivement clients, dollars et points sur 10.
>
> La paire 2025-02-01/101 apparaît deux fois : il faut vérifier la source avant de décider de retirer une copie. Il faut compter les NA, vérifier les unités et les types importés. Les codes 101 et 202 sont des étiquettes sans quantité à moyenner. NA indique un score inconnu, pas l’absence de satisfaction. Un score moyen n’est pas un pourcentage de personnes satisfaites.
>
> Repères : modules [01](../../modules/semaine-01-introduction/index.llms.md), [02](../../modules/semaine-02-r-quarto/index.llms.md), laboratoire [01](../../modules/atelier-01-r/guide-atelier.llms.md).

> **TIP:**
>
> 1.  Histogramme : délai en jours à l’horizontale, nombre d’observations à la verticale; il montre une distribution.
> 2.  Boîtes à moustaches : saisons à l’horizontale, taux de retour à la verticale; elles comparent centre et dispersion.
> 3.  Nuage : clients à l’horizontale, ventes en dollars à la verticale; il montre leur association.
> 4.  Barres : succursales et ventes totales en dollars, avec `geom_col()` pour des valeurs déjà résumées.
>
> Les axes peuvent être inversés pour les barres si les noms sont longs; les unités, le titre et le sens de la comparaison doivent rester clairs. Repères : modules [01](../../modules/semaine-01-introduction/notes-cours.llms.md) et [02](../../modules/semaine-02-r-quarto/exercices.llms.md).

> **TIP:**
>
> La médiane est de 4,20 % en saison régulière contre 3,70 % en saison moyenne, soit 0,50 point de pourcentage de plus. Les effectifs sont inégaux, 35 contre 15 lignes, et les intervalles interquartiles se recouvrent largement; ces données ne prouvent ni une différence générale ni une cause.
>
> Sur les deux mois fictifs, le ratio total vaut \\(10\\000+36\\000)/(100+600)=65{,}71\\ \$ par client. Les ratios mensuels sont 100 \$ et 60 \$; leur moyenne simple vaut 80 \$. Le ratio total pondère les mois par leur nombre de clients, tandis que la moyenne simple donne le même poids aux deux mois.
>
> Repère : [laboratoire 01, tableau par succursale](../../modules/atelier-01-r/guide-atelier.llms.md).

> **TIP:**
>
> La suppression globale perd des ventes complètes à cause de variables absentes non nécessaires à leur total. `mean(ventes)` calcule une moyenne et non un total. Après suppression, `n()` compte les lignes restantes et cache la différence entre n total et scores disponibles.
>
> ``` r
> library(tidyverse)
> # pme est le tableau importé dans la question.
> pme |>
>   group_by(succursale) |>
>   summarise(ventes_totales = sum(ventes),
>             satisfaction_moyenne = mean(satisfaction, na.rm = TRUE),
>             n_total = n(),
>             scores_disponibles = sum(!is.na(satisfaction)),
>             scores_manquants = sum(is.na(satisfaction)),
>             .groups = "drop")
> ```
>
> La moyenne de satisfaction porte sur les scores mensuels disponibles; elle ne remplace pas les valeurs manquantes. La somme des ventes est complète ici, comme le précise l’énoncé. Repères : [module 02](../../modules/semaine-02-r-quarto/exercices.llms.md), [laboratoire 01](../../modules/atelier-01-r/guide-atelier.llms.md).

> **TIP:**
>
> La réponse est ventes et l’explicative clients. La pente d’environ 65,40 \$ par client correspond à environ 6 540 \$ de ventes moyennes estimées supplémentaires pour 100 clients. L’intercept est la valeur estimée à zéro client, hors de la plage 1 600-2 999 : il ne décrit pas une succursale réellement observée à zéro client.
>
> La valeur p inférieure à 0,001 conduit à rejeter la pente nulle au seuil de 5 %, sous les hypothèses du modèle. Elle ne mesure ni l’ampleur de l’association, ni la probabilité que H0 soit vraie, ni une causalité.
>
> R² est d’environ 0,8269 : la droite décrit 82,7 % de la variation observée des ventes autour de leur moyenne sur l’ajustement. En régression simple avec constante, \\R^2=r^2\\. Le signe de r doit venir de la pente ou du nuage; le carré le fait disparaître. Repère : [module 03](../../modules/semaine-03-regression-lineaire/notes-cours.llms.md).

> **TIP:**
>
> Avec les coefficients affichés, \\\widehat y=\\ -8 206,20 \\+\\ 65,40 \\\times 2\\500=\\ 155 293,80 \$. Le résidu est \\160\\000-\widehat y=\\ 4 706,20 \$ : il est positif, donc la droite sous-estime cette observation fictive.
>
> 6 000 clients sont hors de la plage 1 600-2 999. Une extrapolation de cette ampleur ne justifie pas une recommandation sans autres données et vérifications. Les calculs avec les coefficients non arrondis de R peuvent différer légèrement de ceux demandés ici. Repère : [module 03](../../modules/semaine-03-regression-lineaire/exercices.llms.md).

> **TIP:**
>
> A montre une courbe en U : la moyenne peut être mal représentée par une droite; examiner une forme quadratique ou une transformation enseignée, puis comparer. B montre une dispersion qui augmente avec la valeur ajustée : une variance constante est douteuse; examiner la dispersion et rester prudent sur les intervalles classiques.
>
> La moyenne globale nulle des résidus est une propriété des moindres carrés ordinaires avec constante. Elle ne confirme ni la forme moyenne ni l’indépendance ni la variance constante. Décrire un motif n’en établit pas la cause. Repères : modules [03](../../modules/semaine-03-regression-lineaire/exercices.llms.md#exercice-13) et [04](../../modules/semaine-04-regression-nonlineaire/notes-cours.llms.md).

> **TIP:**
>
> \\\widehat y_Q(2)=100+40-8=132\\ kWh; à trois lots, 142 kWh; à quatre lots, 148 kWh. Les différences sont 10 kWh et 6 kWh. Le coefficient 20 ne constitue pas une variation constante : le carré change en même temps que x.
>
> Pour le logarithme, la différence est \\50\ln(1{,}10)\approx4{,}77\\ kWh, avec x strictement positif. Elle n’est pas automatiquement 10 % de consommation en plus. La bonne formule est `y ~ x + I(x^2)`. Les deux formes restent linéaires en leurs coefficients, ce qui permet `lm()`. Repère : [module 04, transformations](../../modules/semaine-04-regression-nonlineaire/exercices.llms.md#exercice-07).

> **TIP:**
>
> Les RMSE de validation sont de 14 365 \$ et 15 486 \$. La droite est retenue provisoirement selon ce critère. Ajouter le carré ne peut pas diminuer le R² d’apprentissage sur les mêmes lignes; son augmentation ne démontre pas une meilleure généralisation.
>
> Une erreur d’apprentissage et une erreur de validation utilisent des données et des rôles différents : elles ne classent pas équitablement les modèles. Pour les deux erreurs fictives, MAE = \\(3+4)/2=3{,}50\\ \$, RMSE = \\\sqrt{(9+16)/2}\approx3{,}54\\ \$. Leur moyenne signée, 0,50 \$, masque leur taille par compensation.
>
> La validation utilisée pour sélectionner n’est pas un test final indépendant. Les mêmes succursales apparaissent dans les deux périodes; on ne teste pas de nouvelles succursales, et les répétitions demandent de vérifier l’indépendance. Repères : [module 04](../../modules/semaine-04-regression-nonlineaire/demonstrations.llms.md), [laboratoire 02](../../modules/atelier-02-regression/guide-atelier.llms.md).

> **TIP:**
>
> Exemple : « Pour 2 500 clients, la droite estime des ventes moyennes d’environ 155 297 \$. Une nouvelle observation mois-succursale relève de l’intervalle de prédiction, d’environ 135 801 \$ à 174 794 \$, sous les hypothèses classiques, et non de l’intervalle de confiance de moyenne. La pente décrit une association; elle ne prouve pas l’effet causal d’une campagne et aucune valeur n’est garantie. Les succursales répétées, l’indépendance à examiner et le contexte représenté dans les données limitent l’utilisation dans une nouvelle succursale. »
>
> Les intervalles exacts présentés supposent notamment une moyenne correctement spécifiée, des erreurs indépendantes, de variance constante et normales. `fit` est l’estimation ponctuelle; `lwr` et `upr` sont les bornes. Repères : modules [03](../../modules/semaine-03-regression-lineaire/notes-cours.llms.md) et [04](../../modules/semaine-04-regression-nonlineaire/notes-cours.llms.md).

## Reprise ciblée

Pour varier la reprise, faites la [série de 12 vrai ou faux et 12 choix multiples](../../modules/semaine-05-preparation-intra/questions-courtes.llms.md), en justifiant d’abord vos décisions sans aide ni IA. Comparez les explications après la tentative; une lettre juste sans raisonnement ne suffit pas.

Ouvrez la [grille d’autoévaluation](../../modules/semaine-05-preparation-intra/autoevaluation.llms.md). Choisissez deux erreurs, associez-les à un passage précis du cours et à un [exercice progressif](../../modules/semaine-05-preparation-intra/exercices.llms.md). Refaites une question analogue deux jours plus tard sans aide. Les ressources utilisées ici sont des outils de préparation; consultez la [fiche de l’intra](../../evaluations/examen-intra.llms.md) et Brio pour les modalités d’examen.
