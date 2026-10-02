# Vrai ou faux et choix multiples - Module 05

## Une première tentative sans aide

Cette série consolide les compétences des modules 01 à 04 avec des situations fictives et des données construites pour l’entraînement. Elle ne décrit aucune organisation réelle. Les questions sont formatives et ne constituent ni une annonce ni une reproduction des questions de l’examen.

Prévoyez 30 minutes pour répondre, puis 20 minutes pour corriger. Vous pouvez aussi faire les deux séries à des moments différents. Ces durées sont des estimations de travail. Lors de la première tentative, travaillez individuellement, sans notes, sans exécuter R, sans consulter les corrigés et sans IA. Les informations nécessaires figurent dans les énoncés. Cette consigne d’entraînement ne définit pas le matériel autorisé à l’examen; consultez les [modalités du cours](../../evaluations/examen-intra.llms.md).

Pour chaque vrai ou faux, écrivez « vrai » ou « faux » et une justification d’une ou deux phrases. Si l’affirmation est fausse, corrigez-la. Pour chaque choix multiple, choisissez une seule lettre et expliquez votre décision; les calculs portent leurs unités. Un choix correct sans explication reste une compétence à consolider.

Conservez vos premières réponses et indiquez votre confiance : sûr, hésitant ou incertain. Les [corrigés expliqués](#corriges) sont regroupés après toutes les questions et fermés par défaut. Après votre tentative, vous pouvez utiliser R et les ressources pour vérifier et comprendre les erreurs.

## Série 1 : douze vrai ou faux

### VF01. Une ligne n’est pas une personne

Une coopérative décrit 18 points de dépôt, chacun observé un seul lundi. La colonne `sacs` donne le nombre de sacs reçus à chaque point. Le tableau comporte 18 unités d’observation, même si le total des sacs dépasse 18.

### VF02. Des valeurs disponibles

Dans une enquête sur neuf ateliers, `outils` et `minutes` sont complets; deux valeurs de `avis` manquent. Retirer toutes les lignes qui contiennent un NA est nécessaire pour étudier l’association entre `outils` et `minutes`.

### VF03. Une valeur sur la frontière

Un histogramme des durées utilise les classes \\\[0;4\[\\, \\\[4;8\[\\ et \\\[8;12\[\\, toutes fermées à gauche et ouvertes à droite. Une durée de quatre minutes est comptée dans la deuxième classe.

### VF04. Une médiane commune

Deux équipes ont la même durée médiane de montage, soit 16 minutes. On peut donc remplacer leurs deux distributions par une seule sans perdre d’information sur la dispersion.

### VF05. Une différence prédite

Une équation fictive de conditionnement est \\\widehat t=18+4{,}2m\\, où \\m\\ est la masse du lot en kg et \\t\\ sa durée en minutes. Entre deux lots qui diffèrent de trois kg, la différence de durée moyenne prédite est de 12,60 minutes. Cette comparaison décrit le modèle.

### VF06. Des erreurs qui s’annulent

Quatre erreurs de prédiction, observé moins prédit, valent \\-1\\, \\1\\, \\-3\\ et \\3\\ minutes. Leur moyenne est nulle : la RMSE vaut donc aussi zéro minute.

### VF07. Une bande qui s’élargit

Dans un graphique résidu-valeur ajustée, une bande de résidus qui s’élargit aux grandes valeurs ajustées signale que l’hypothèse de variance constante est à examiner. L’absence de courbure visible n’efface pas ce signal.

### VF08. Un test peu concluant

Sous les conditions du test classique, un test bilatéral de \\H_0:\beta_1=0\\ donne \\p=0{,}18\\. Au seuil de 5 %, cela démontre que la pente dans la population est exactement nulle.

### VF09. Le point de départ compte

Le modèle \\\widehat t(x)=6+2x+0{,}4x^2\\ décrit des durées en minutes; \\x\\ est un nombre de pièces. L’écart prédit de deux à trois pièces est de quatre minutes, tandis que l’écart de cinq à six pièces est de 6,40 minutes.

### VF10. Une variation proportionnelle de x

Le modèle \\\widehat d(x)=40-7\ln(x)\\ décrit une durée en secondes pour \\x\>0\\. Avec \\\ln(1{,}25)=0{,}2231436\\, la durée moyenne prédite pour une valeur de \\x\\ supérieure de 25 % est plus petite d’environ 1,56 seconde, quel que soit le point de départ positif. Cela compare les prédictions du modèle, sans établir l’effet d’une intervention.

### VF11. Une amélioration à situer

Sur les mêmes données d’apprentissage, ajouter \\x^2\\ à une droite avec constante diminue la SSE. Cette diminution suffit pour annoncer que la quadratique prédit mieux les nouveaux cas.

### VF12. Ralentissement et plafond

Une courbe \\\widehat y=5+3\ln(x)\\, \\x\>0\\, augmente de moins en moins vite. Elle atteindra donc un plafond fini lorsque \\x\\ sera assez grand.

## Série 2 : douze choix multiples

Une seule réponse est défendable par question. Chaque question peut être traitée séparément, sauf CM07 et CM08 qui reprennent la sortie de CM06.

### CM01. Le sens d’un code

Un fichier de location de costumes contient `code_modele` (101, 205, 330), `pieces` (un dénombrement) et `retrait` (une date). Aucun ordre n’est défini entre les modèles. Quelle description est correcte?

A. `code_modele` et `pieces` sont deux mesures continues, puisque R les stocke sous forme numérique.

B. `code_modele` est ordinal : 330 représente un modèle de rang supérieur à 205.

C. `retrait` est une durée; sa moyenne suffit pour décrire le nombre de jours de location.

D. `code_modele` est catégoriel nominal, `pieces` est numérique discret et `retrait` est une date.

### CM02. Corriger un filtre

On veut ajuster `temperature ~ masse` dans un petit suivi fictif de compost. Voici les huit lignes :

| Lot | Masse (kg) | Température (°C) | Note de l’opérateur |
|-----|-----------:|-----------------:|---------------------|
| A   |          5 |               31 | NA                  |
| B   |          6 |               33 | Stable              |
| C   |          7 |               36 | NA                  |
| D   |          8 |               NA | Stable              |
| E   |          9 |               40 | Stable              |
| F   |         NA |               42 | Stable              |
| G   |         11 |               44 | Stable              |
| H   |         12 |               46 | Stable              |

Le code retire d’abord les lignes où `note` manque, puis celles où `masse` ou `temperature` manque. Quel remplacement utilise les observations disponibles pour la question posée?

A. Remplacer tous les NA par zéro pour conserver huit observations.

B. Conserver uniquement les lignes où `masse` et `temperature` sont renseignées : A, B, C, E, G et H.

C. Conserver seulement B, E, G et H, car un avis manquant rend toute la ligne inutilisable.

D. Conserver les huit lignes, car `lm()` peut estimer les deux mesures manquantes.

### CM03. Un rapport qui se reconstruit

Une collègue reçoit un projet avec `analyse.qmd` à la racine et `mesures.csv` dans `data/`. R vient de redémarrer. Quel début de document permet de reconstruire les objets nécessaires sans dépendre de votre Console?

A. Charger `library(tidyverse)`, importer `read_csv("data/mesures.csv")` dans `mesures`, puis faire les calculs dans le document; joindre le dossier `data/` au projet.

B. Commencer par `summary(mesures)`; l’objet existe forcément puisque le fichier CSV est présent.

C. Mettre uniquement `setwd("/Users/moi/Desktop")`; le projet devient transportable.

D. Copier dans le document un tableau de résultats, sans données ni code de calcul.

### CM04. Montrer ce qu’une moyenne cache

Une troupe compare les durées de 30 réparations de costumes, réparties entre trois ateliers. Elle veut montrer la dispersion et les réparations particulièrement longues, et comparer les ateliers. Quel graphique répond le plus directement à cette demande?

A. Trois barres représentant uniquement les durées moyennes.

B. Un histogramme des codes d’atelier 1, 2 et 3, en les traitant comme une mesure continue.

C. Une boîte par atelier avec les observations superposées; atelier en abscisse, durée en minutes en ordonnée.

D. Une courbe reliant les ateliers par ordre alphabétique pour représenter une évolution dans le temps.

### CM05. Lire un résumé sans effacer une valeur

Une sortie fictive résume les durées de 20 petites interventions, en minutes :

``` text
Min.  1st Qu.  Median  Mean  3rd Qu.  Max.
  7      10      12    16      15     58
```

Quelle conclusion est la plus défendable à partir de ces seules informations?

A. Les 20 interventions ont duré environ 16 minutes, avec une dispersion négligeable.

B. La valeur 58 doit être supprimée, puisqu’elle dépasse le troisième quartile.

C. Exactement cinq interventions ont duré plus de 15 minutes, quelles que soient les égalités et la convention des quartiles.

D. La médiane de 12 minutes peut communiquer un centre moins sensible aux durées élevées; il faut examiner la valeur 58 et la distribution avant de décider d’un traitement.

### CM06. Lire une sortie R

Un atelier fictif reconditionne des casques audio. Dix appareils, présentant de deux à onze défauts repérés, ont servi à ajuster le modèle. Chaque ligne représente un appareil distinct. La réponse est la durée de reconditionnement en minutes.

Voici une sortie R calculée sur les données construites pour ce cas :

    lm(minutes ~ defauts, data = casques)

                Estimate Std. Error t value Pr(>|t|)
    (Intercept)   9.4000     1.1065   8.496 2.83e-05 ***
    defauts       1.8000     0.1557  11.561 2.85e-06 ***
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    R-squared: 0.9435

Pour cette question seulement, supposez les conditions du test classique satisfaites. Quelle lecture de la ligne `defauts` est correcte?

A. La valeur p est la probabilité que l’hypothèse de pente nulle soit vraie.

B. Un défaut de plus est associé à 1,80 minute de durée moyenne prédite supplémentaire; au seuil de 5 %, les données sont peu compatibles avec une pente nulle, sans preuve causale.

C. La pente vaut 1,80 défaut par minute; la formule prédit donc le nombre de défauts à partir du temps.

D. La petite valeur p impose que chaque appareil portant un défaut de plus prenne exactement 1,80 minute de plus.

### CM07. Prédiction et signe

Utilisez les coefficients de CM06 : \\\widehat t=9{,}4+1{,}8d\\. Un nouvel appareil présentant neuf défauts a demandé 28,20 minutes. Quel couple « prédiction; erreur observé moins prédit » est correct?

A. 25,60 minutes; \\-2{,}60\\ minutes, donc le modèle surestime.

B. 28,20 minutes; zéro minute, puisque l’observation devient la prédiction.

C. 25,60 minutes; \\+2{,}60\\ minutes, donc le modèle sous-estime la durée observée.

D. 16,20 minutes; \\+12{,}00\\ minutes, car on omet la constante pour un nouvel appareil.

### CM08. Quelle incertitude pour une intervention?

À neuf défauts, les calculs classiques à 95 % de CM06 donnent ce tableau. Les conditions nécessaires sont supposées satisfaites; les intervalles portent sur des appareils comparables.

| Cible           | Prédiction (min) | Borne basse (min) | Borne haute (min) |
|:----------------|:-----------------|:------------------|:------------------|
| Durée moyenne   | 25,60            | 24,23             | 26,97             |
| Nouvel appareil | 25,60            | 22,06             | 29,14             |

Pour situer la durée d’un seul prochain appareil présentant neuf défauts, quelle réponse convient?

A. L’intervalle « Nouvel appareil » : il intègre la dispersion individuelle en plus de l’incertitude sur la moyenne; il ne constitue pas une garantie pour cet appareil.

B. L’intervalle « Durée moyenne » : une moyenne suffisamment précise élimine la dispersion entre appareils.

C. La prédiction ponctuelle : toute durée comprise dans les données d’apprentissage est certaine.

D. Le plus petit intervalle : choisir la largeur minimale valide les hypothèses du modèle.

### CM09. À quoi se rapporte R²?

Pour une droite avec constante sur des données de durées, \\\mathrm{SSE}=36\\ \mathrm{min}^2\\ et \\\mathrm{SST}=144\\ \mathrm{min}^2\\. Quelle interprétation est correcte?

A. \\R^2=0{,}25\\ : 25 % des durées sont prédites sans erreur.

B. \\R^2=0{,}75\\ : la pente est forcément positive.

C. \\R^2=0{,}75\\ : 75 % de l’effet d’une intervention est démontré.

D. \\R^2=0{,}75\\ : le modèle rend compte de 75 % de la variation des durées autour de leur moyenne sur les données d’ajustement; il ne garantit pas la performance future.

### CM10. Lire la dispersion des résidus

Une buanderie associative fictive étudie le temps de séchage selon la masse chargée. Une droite a été ajustée sur 24 charges construites pour cet exercice. Voici ses résidus, définis par observé moins ajusté :

![Les résidus forment des groupes verticaux centrés autour de zéro. Leur dispersion augmente aux grandes durées ajustées.](questions-courtes_files/figure-html/m05-qc-diagnostic-1.png)

Quel commentaire relie le motif visible à une vérification pertinente?

A. Les résidus positifs montrent qu’il faut inverser la réponse et l’explicative.

B. La moyenne des résidus étant proche de zéro, les intervalles classiques sont nécessairement fiables.

C. La dispersion augmente aux grandes valeurs ajustées; examiner la variance constante avant de faire confiance à l’incertitude classique, même si une droite semble décrire la moyenne.

D. Tous les points éloignés de zéro sont des erreurs de saisie à supprimer.

### CM11. Réparer la formule d’une courbe

Un modèle de pliage prédit des minutes à partir du nombre de plis \\x\\. On veut ajuster \\\widehat t=b_0+b_1x+b_2x^2\\, avec une constante et les deux termes. Quelle formule R représente cette forme?

A. `lm(minutes ~ plis + I(plis^2), data = pliage)`

B. `lm(minutes ~ plis^2, data = pliage)`

C. `lm(log(minutes) ~ plis, data = pliage)`

D. `lm(plis ~ minutes + I(minutes^2), data = pliage)`

### CM12. Choisir et vérifier

Un service d’archives compare les durées de traitement de lots selon leur nombre de dossiers. Les trois modèles ont été ajustés sur les mêmes 16 lots et évalués, sans réajustement, sur les mêmes sept lots de validation. Les nombres du tableau sont fictifs, fournis pour le raisonnement. La réponse reste en minutes pour toutes les formes.

| Modèle        | RMSE d’apprentissage (min) | RMSE de validation (min) |
|---------------|---------------------------:|-------------------------:|
| Droite        |                       1,80 |                     2,70 |
| Quadratique   |                       1,20 |                     3,50 |
| Logarithmique |                       1,60 |                     2,40 |

Les sept lots ont servi à choisir la forme. Quelle recommandation est la plus défendable?

A. Retenir la quadratique, puisque sa RMSE d’apprentissage est la plus petite, puis considérer les sept lots comme un test final indépendant.

B. Retenir provisoirement le logarithme selon la validation, examiner ses diagnostics et sa plage d’utilisation, puis évaluer la forme fixée sur de nouvelles données comparables mises de côté.

C. Annoncer que le logarithme raccourcit automatiquement le temps réel de traitement de chaque lot de 0,30 minute.

D. Appliquer le logarithme à n’importe quelle taille de lot, car une RMSE de validation est une garantie universelle.

## Corrigés expliqués

Ouvrez les solutions après avoir terminé la série choisie. La lettre ou le verdict n’est que le début : vérifiez l’argument, le calcul, l’unité et la portée. Les blocs R de cette section servent à vérifier après votre tentative; ils n’ajoutent aucune méthode aux modules 01 à 04.

### Corrigés des vrai ou faux

> **TIP:**
>
> Vrai. Une ligne représente un point de dépôt observé ce lundi. Les sacs sont une variable de dénombrement attachée à chaque unité; leur total n’est pas le nombre de lignes. Il faudrait un tableau décrivant chaque sac séparément pour que le sac soit l’unité.
>
> À revoir : [module 01, unité et variables](../../modules/semaine-01-introduction/index.llms.md).

> **TIP:**
>
> Faux. L’analyse demandée porte sur `outils` et `minutes`, qui sont complets. Les neuf lignes sont disponibles pour cette association. Une suppression fondée sur `avis` en enlèverait deux sans nécessité pour cette question. Pour analyser les avis, on indiquerait sept valeurs disponibles et une limite liée aux avis manquants.
>
> À revoir : [module 02, traitement ciblé des NA](../../modules/semaine-02-r-quarto/demonstrations.llms.md).

> **TIP:**
>
> Vrai. Quatre est exclu de \\\[0;4\[\\ et inclus dans \\\[4;8\[\\. Le classement dépend de la convention annoncée. Une barre compte les valeurs de sa classe; elle ne représente ni une durée moyenne ni le nombre de valeurs égales à son centre.
>
> À revoir : [module 01, distributions et histogrammes](../../modules/semaine-01-introduction/exercices.llms.md).

> **TIP:**
>
> Faux. Une même médiane ne détermine ni les quartiles, ni l’étendue, ni les durées inhabituelles. Une équipe peut avoir des durées très concentrées et l’autre très dispersées. Il faut examiner les deux distributions avant de les regrouper; leur médiane commune ne justifie pas ce regroupement.
>
> À revoir : [exercice progressif 3](../../modules/semaine-05-preparation-intra/exercices.llms.md#exercice-3---réponse-descriptive-courte).

> **TIP:**
>
> Vrai. La différence prédite vaut \\4{,}2\times3=12{,}60\\ minutes. La constante disparaît lorsqu’on soustrait les deux prédictions. La pente a pour unité minute par kg. Cette différence compare des moyennes prédites; elle ne garantit pas la durée d’un lot et ne démontre pas un effet causal.
>
> À revoir : [module 03, droite et unités](../../modules/semaine-03-regression-lineaire/notes-cours.llms.md).

> **TIP:**
>
> Faux. Les signes s’annulent dans la moyenne des erreurs, mais les carrés ne s’annulent pas :
>
> \\\mathrm{RMSE}=\sqrt{(1+1+9+9)/4}=\sqrt5\simeq2{,}24\\ \mathrm{min}.\\
>
> La RMSE conserve l’unité de la réponse. Zéro exige que toutes les erreurs soient nulles. Vérification après la tentative :
>
> ``` r
> erreurs_minutes <- c(-1,1,-3,3)
> c(erreur_moyenne = mean(erreurs_minutes),
>   rmse_minutes = sqrt(mean(erreurs_minutes^2)))
> ```
>
>     erreur_moyenne   rmse_minutes
>           0.000000       2.236068
>
> À revoir : [module 04, RMSE](../../modules/semaine-04-regression-nonlineaire/notes-cours.llms.md).

> **TIP:**
>
> Vrai. La largeur croissante de la bande suggère une dispersion des erreurs qui dépend du niveau ajusté. La variance constante est une condition à examiner pour l’incertitude classique. Une forme moyenne plausible ne valide pas toutes les conditions; le motif ne démontre pas à lui seul sa cause et n’interdit pas le calcul de la droite.
>
> À revoir : [module 03, diagnostics](../../modules/semaine-03-regression-lineaire/exercices.llms.md).

> **TIP:**
>
> Faux. \\0{,}18\>0{,}05\\ : on ne rejette pas \\H_0\\ au seuil choisi. Cela ne prouve pas une pente nulle; les données peuvent être peu précises. La valeur p décrit, sous \\H_0\\ et les hypothèses du test, la probabilité d’obtenir une statistique au moins aussi extrême que celle observée. Ce n’est pas la probabilité que \\H_0\\ soit vraie.
>
> À revoir : [questionnaire formatif de régression](../../evaluations/questionnaire-regression.llms.md).

> **TIP:**
>
> Vrai. Les deux termes varient quand \\x\\ change :
>
> \\\widehat t(3)-\widehat t(2)=15{,}6-11{,}6=4{,}00\\ \mathrm{min},\\ \\\widehat t(6)-\widehat t(5)=32{,}4-26=6{,}40\\ \mathrm{min}.\\
>
> Le coefficient 2 ne représente pas une hausse constante de la courbe par pièce. Vérification :
>
> ``` r
> duree_quadratique <- function(x) 6 + 2*x + .4*x^2
> c(deux_a_trois = duree_quadratique(3) - duree_quadratique(2),
>   cinq_a_six = duree_quadratique(6) - duree_quadratique(5))
> ```
>
>     deux_a_trois   cinq_a_six
>              4.0          6.4
>
> À revoir : [module 04, variations quadratiques](../../modules/semaine-04-regression-nonlineaire/exercices.llms.md).

> **TIP:**
>
> Vrai. Pour \\x\\ et \\1{,}25x\\, la différence vaut
>
> \\-7\[\ln(1{,}25x)-\ln(x)\]=-7\ln(1{,}25)\simeq-1{,}56\\ \mathrm{s}.\\
>
> La réponse reste une durée en secondes, et non un pourcentage. Le point de départ doit être positif et l’utilisation doit respecter la plage et le contexte du modèle. L’identité algébrique ne constitue pas une validation hors plage.
>
> ``` r
> -7 * log(1.25)
> ```
>
>     [1] -1.562005
>
> À revoir : [module 04, logarithme de l’explicative](../../modules/semaine-04-regression-nonlineaire/notes-cours.llms.md).

> **TIP:**
>
> Faux. La diminution concerne l’ajustement sur l’apprentissage. Les moindres carrés peuvent choisir un coefficient du carré égal à zéro; ajouter ce terme ne peut donc augmenter la SSE minimale sur les mêmes lignes. Une diminution réelle peut néanmoins refléter un ajustement de particularités de ces données. Pour discuter la prédiction hors apprentissage, comparer les erreurs sur les mêmes observations de validation et examiner forme, résidus et contexte.
>
> À revoir : [module 04, comparer les formes](../../modules/semaine-04-regression-nonlineaire/notes-cours.llms.md).

> **TIP:**
>
> Faux. Le logarithme croissant n’a pas de plafond fini. Par exemple, doubler \\x\\ ajoute toujours \\3\ln2\\ à la prédiction de cette équation. Une hausse qui ralentit ne démontre pas un plateau physique. Une quadratique peut, quant à elle, finir par redescendre; cette propriété mathématique n’établit pas davantage une limite réelle.
>
> À revoir : [module 04, ralentissement et plateau](../../modules/semaine-04-regression-nonlineaire/notes-cours.llms.md).

### Corrigés des choix multiples

> **TIP:**
>
> Réponse D. Le rôle statistique prime sur le stockage informatique. Les codes identifient des catégories sans ordre; les pièces sont comptées; la date est un repère calendaire.
>
> - A confond type informatique et sens statistique; un dénombrement est discret.
> - B invente un ordre absent du dictionnaire.
> - C confond une date avec une durée; une durée demanderait notamment deux repères temporels.
>
> À revoir : [module 01](../../modules/semaine-01-introduction/index.llms.md).

> **TIP:**
>
> Réponse B. Six lignes ont les deux mesures nécessaires. D et F sont exclues de cette analyse parce qu’une mesure nécessaire manque. Les notes manquantes de A et C ne justifient pas de perdre leurs mesures.
>
> - A transforme une absence de mesure en une valeur observée égale à zéro.
> - C reproduit le filtre inutile et ne conserve que quatre lignes.
> - D attribue à `lm()` une reconstitution des valeurs manquantes qu’il ne fait pas.
>
> Le code corrigé se reconstruit avec les données de l’énoncé :
>
> ``` r
> library(tidyverse)
> compost <- tibble(
>   lot = LETTERS[1:8],
>   masse = c(5,6,7,8,9,NA,11,12),
>   temperature = c(31,33,36,NA,40,42,44,46),
>   note = c(NA,"Stable",NA,"Stable","Stable","Stable","Stable","Stable")
> )
> compost_analyse <- compost |>
>   filter(!is.na(masse), !is.na(temperature))
> compost_analyse |> select(lot, masse, temperature)
> ```
>
>     # A tibble: 6 × 3
>       lot   masse temperature
>       <chr> <dbl>       <dbl>
>     1 A         5          31
>     2 B         6          33
>     3 C         7          36
>     4 E         9          40
>     5 G        11          44
>     6 H        12          46
>
> ``` r
> nrow(compost_analyse)
> ```
>
>     [1] 6
>
> Conserver des valeurs disponibles ne démontre pas que les absences sont sans biais. À revoir : [module 02](../../modules/semaine-02-r-quarto/demonstrations.llms.md).

> **TIP:**
>
> Réponse A. Le document charge les bibliothèques, importe les données et construit ses objets à partir du projet transmis. Le chemin est relatif à la racine indiquée.
>
> - B suppose un objet de la Console qui disparaît au redémarrage.
> - C impose un emplacement personnel et ne crée ni l’objet ni les calculs.
> - D donne un résultat sans permettre de vérifier sa construction à partir des données.
>
> Il faut aussi disposer des packages nécessaires. Un chemin relatif seul ne rend pas toute analyse reproductible. À revoir : [module 02, R et Quarto](../../modules/semaine-02-r-quarto/index.llms.md).

> **TIP:**
>
> Réponse C. Les boîtes montrent centre et dispersion par atelier, et les points donnent accès aux observations et aux durées inhabituelles. Les axes correspondent à une catégorie et une mesure en minutes.
>
> - A peut comparer des moyennes, mais masque la dispersion recherchée.
> - B décrit des codes, sans représenter les durées par atelier.
> - D suggère une évolution temporelle que l’ordre alphabétique ne définit pas.
>
> À revoir : [exercice progressif 3](../../modules/semaine-05-preparation-intra/exercices.llms.md#exercice-3---réponse-descriptive-courte).

> **TIP:**
>
> Réponse D. La moyenne supérieure à la médiane et le maximum élevé invitent à examiner les grandes durées. La médiane est un indicateur central moins sensible à celles-ci. Ce résumé ne montre pas toute la forme de la distribution.
>
> - A confond un centre avec la totalité des valeurs; l’écart entre minimum et maximum contredit une dispersion négligeable.
> - B transforme un signal à vérifier en suppression automatique. Des observations peuvent dépasser Q3 sans être des erreurs.
> - C exige un effectif strictement au-dessus d’une valeur que les seuls quartiles, les égalités possibles et les conventions ne déterminent pas exactement.
>
> À revoir : [module 02, résumés descriptifs](../../modules/semaine-02-r-quarto/exercices.llms.md).

> **TIP:**
>
> Réponse B. La pente est 1,80 minute par défaut. La valeur p de la pente est inférieure à 0,05 : on rejette \\H_0\\ sous les conditions supposées. La sortie décrit une association moyenne.
>
> - A inverse le conditionnement de la valeur p.
> - C inverse les unités et le sens de `minutes ~ defauts`.
> - D transforme une variation moyenne prédite en une règle individuelle certaine.
>
> Ce petit jeu a été construit pour la lecture de sortie; la condition du test est accordée dans l’énoncé, sans être prouvée par sa seule valeur p. Vérification de la sortie :
>
> ``` r
> library(tidyverse)
> casques <- tibble(
>   defauts = 2:11,
>   minutes = 9.4 + 1.8 * defauts + c(2,-1,-1,-1,1,1,-1,-1,-1,2)
> )
> modele_casques <- lm(minutes ~ defauts, data = casques)
> summary(modele_casques)
> ```
>
>
>     Call:
>     lm(formula = minutes ~ defauts, data = casques)
>
>     Residuals:
>        Min     1Q Median     3Q    Max
>         -1     -1     -1      1      2
>
>     Coefficients:
>                 Estimate Std. Error t value Pr(>|t|)
>     (Intercept)   9.4000     1.1065   8.496 2.83e-05 ***
>     defauts       1.8000     0.1557  11.561 2.85e-06 ***
>     ---
>     Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
>
>     Residual standard error: 1.414 on 8 degrees of freedom
>     Multiple R-squared:  0.9435,    Adjusted R-squared:  0.9365
>     F-statistic: 133.6 on 1 and 8 DF,  p-value: 2.847e-06
>
> À revoir : [module 03](../../modules/semaine-03-regression-lineaire/notes-cours.llms.md).

> **TIP:**
>
> Réponse C. \\9{,}4+1{,}8\times9=25{,}60\\ minutes. L’erreur du nouvel appareil vaut \\28{,}20-25{,}60=+2{,}60\\ minutes : la durée observée est supérieure à la prédiction. Neuf défauts appartient à la plage de deux à onze utilisée pour l’ajustement.
>
> - A inverse le signe et l’interprétation.
> - B remplace la prédiction du modèle par la mesure observée.
> - D omet une constante qui fait partie de l’équation, même pour un nouveau cas.
>
> On parle ici d’erreur de prédiction pour une nouvelle observation; les résidus d’ajustement se calculent avec les observations qui ont servi à ajuster le modèle. À revoir : [module 03](../../modules/semaine-03-regression-lineaire/notes-cours.llms.md).

> **TIP:**
>
> Réponse A. La durée d’une nouvelle observation comporte sa dispersion individuelle, en plus de l’incertitude liée à l’estimation de la moyenne. L’intervalle de prédiction vaut ici environ \[22,06; 29,14\] minutes, contre \[24,23; 26,97\] pour la moyenne.
>
> - B confond précision de la moyenne et dispersion des observations.
> - C confond interpolation et certitude.
> - D choisit selon la largeur souhaitée, sans tenir compte de la cible; aucun intervalle ne valide à lui seul les conditions du modèle.
>
> Le niveau de 95 % appartient à une méthode sous hypothèses, et ne garantit pas la durée du prochain appareil. Après avoir exécuté le bloc complet de CM06, vérifiez :
>
> ``` r
> nouveau <- tibble(defauts = 9)
> predict(modele_casques, nouveau, interval = "confidence")
> ```
>
>        fit     lwr     upr
>     1 25.6 24.2328 26.9672
>
> ``` r
> predict(modele_casques, nouveau, interval = "prediction")
> ```
>
>        fit      lwr      upr
>     1 25.6 22.06382 29.13618
>
> À revoir : [module 03, moyenne et nouvelle observation](../../modules/semaine-03-regression-lineaire/notes-cours.llms.md).

> **TIP:**
>
> Réponse D. \\R^2=1-36/144=0{,}75\\, sans unité. SSE décrit les écarts aux valeurs ajustées et SST les écarts à la moyenne. La réduction de variation résiduelle concerne les données d’ajustement.
>
> - A calcule le rapport SSE/SST et lui attribue une proportion de prédictions exactes.
> - B invente le signe de l’association : en régression simple avec constante, \\R^2=r^2\\ perd ce signe.
> - C attribue une interprétation causale au résumé d’ajustement.
>
> À revoir : [module 03, R²](../../modules/semaine-03-regression-lineaire/notes-cours.llms.md).

> **TIP:**
>
> Réponse C. Les écarts autour de zéro deviennent plus grands lorsque la durée ajustée augmente. Ce motif concerne la dispersion. Les erreurs-types et intervalles classiques reposant sur une variance constante peuvent être peu fiables si cette condition n’est pas adéquate.
>
> - A ne découle pas du signe de quelques résidus.
> - B utilise une moyenne proche de zéro comme validation de toutes les conditions.
> - D confond une variation réelle possible avec une erreur de saisie; une suppression automatique déforme l’analyse.
>
> Les quatre points à chaque niveau ont été construits avec une somme des écarts nulle, ce qui explique leur centre. Le contexte et d’autres diagnostics sont nécessaires pour les conditions que ce graphique ne vérifie pas. À revoir : [module 03, diagnostics](../../modules/semaine-03-regression-lineaire/exercices.llms.md).

> **TIP:**
>
> Réponse A. La formule conserve la constante implicite, le terme simple et le carré numérique protégé par `I()`.
>
> - B utilise `^` dans la syntaxe spéciale des formules, sans représenter le carré numérique demandé. Avec une seule explicative, cette écriture ne crée pas le terme \\x^2\\.
> - C transforme la réponse et omet le terme carré; ce n’est pas la forme donnée.
> - D échange réponse et explicative.
>
> Le modèle est courbe en \\x\\, mais linéaire en coefficients. L’interprétation d’une différence doit tenir compte des deux termes. À revoir : [module 04](../../modules/semaine-04-regression-nonlineaire/notes-cours.llms.md).

> **TIP:**
>
> Réponse B. Sur les mêmes lots de validation, la RMSE du logarithme vaut 2,40 minutes, contre 2,70 pour la droite et 3,50 pour la quadratique. Ce classement est provisoire; sept lots ne prouvent pas une performance stable. La plage n’étant pas chiffrée dans l’énoncé, il faut la vérifier dans les données avant un usage opérationnel.
>
> - A privilégie l’apprentissage et appelle « test final indépendant » un ensemble déjà utilisé pour choisir.
> - C confond un écart de RMSE de 0,30 minute avec un raccourcissement réel et individuel du travail. La RMSE mesure une erreur, pas l’effet d’une intervention.
> - D étend sans justification la portée à toutes les tailles de lot.
>
> Fixer la forme avant d’évaluer de nouvelles données mises de côté permet de distinguer choix et évaluation finale. Les résidus, les unités et le contexte restent à examiner. À revoir : [module 04, validation et portée](../../modules/semaine-04-regression-nonlineaire/notes-cours.llms.md).

## Faire de ses erreurs un plan de reprise

Classez chaque réponse : « expliqué sans aide », « bon choix, justification fragile » ou « à reprendre ». Une bonne lettre obtenue en hésitant demande une nouvelle tentative. Pour chaque erreur, notez le raisonnement qui a rendu une autre réponse séduisante, puis écrivez une phrase correcte avec les unités et la limite pertinente.

| Compétence | Questions à reprendre | Repère du cours |
|----|----|----|
| Unité, types, données disponibles et reproductibilité | VF01-VF02; CM01-CM03 | Modules 01-02; laboratoire 01 |
| Tableaux, distributions et graphiques | VF03-VF04; CM04-CM05 | Modules 01-02 |
| Coefficients, test, prédiction, erreur et R² | VF05-VF06; VF08; CM06-CM09 | Module 03; questionnaire formatif |
| Diagnostics et incertitude | VF07; CM08; CM10 | Module 03 |
| Quadratique, logarithme, forme et validation | VF09-VF12; CM11-CM12 | Module 04 |
| Conclusion avec contexte et limites | VF05; VF08; VF10-VF12; CM06-CM10; CM12 | Modules 01-04 |

Utilisez la [grille d’autoévaluation](../../modules/semaine-05-preparation-intra/autoevaluation.llms.md), puis reprenez deux questions 48 heures plus tard en masquant leurs corrigés. Complétez avec les [huit exercices progressifs](../../modules/semaine-05-preparation-intra/exercices.llms.md) pour développer un raisonnement plus long et la [pratique individuelle](../../modules/semaine-05-preparation-intra/pratique.llms.md) pour construire une réponse complète.
