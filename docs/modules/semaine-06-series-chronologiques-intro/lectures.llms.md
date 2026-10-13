# Lectures - Module 06

## Comment utiliser ces lectures

Les supports du cours en français constituent la lecture attendue. Ils permettent de réaliser les six activités sans la vidéo ni un ouvrage externe. Les pages du livre en anglais et la documentation R ci-dessous sont des compléments ciblés : consultez le passage correspondant à votre difficulté. Aucune ressource payante ni aucun compte externe n’est nécessaire.

Après la lecture, répondez à la question de vérification, fermez le support et reprenez votre propre explication. Corrigez votre rapport existant; ces lectures ne créent pas une deuxième production.

## Lectures intégrées au parcours

| Moment | Statut et passage à lire | Ce qu’il faut en retenir | Vérification personnelle |
|----|----|----|----|
| Avant la capsule 1 | Obligatoire : [préparation](../../modules/semaine-06-series-chronologiques-intro/demonstrations.llms.md#preparation) et [dictionnaires](data/dictionnaires.md) | Unité d’observation, unités, calendrier et séparation temporelle. | Donner les périodes d’apprentissage et de validation. |
| Après la capsule 1 | Obligatoire : [définir une prévision utile](../../modules/semaine-06-series-chronologiques-intro/lectures.llms.md#lecture-1) | La décision détermine la cible, l’origine, la fréquence et l’horizon. | Nommer la décision, l’origine, la cible et l’horizon. |
| Après la capsule 2 | Obligatoire : [lire les composantes](../../modules/semaine-06-series-chronologiques-intro/lectures.llms.md#lecture-2), puis [graphiques](../../modules/semaine-06-series-chronologiques-intro/demonstrations.llms.md#composantes) | Tendance, saisonnalité, cycle et reste; montant ou proportion. | Distinguer les composantes et comparer montant et proportion. |
| Après la capsule 3 | Obligatoire : [préparer les données](../../modules/semaine-06-series-chronologiques-intro/lectures.llms.md#lecture-3), puis [audit du calendrier](../../modules/semaine-06-series-chronologiques-intro/demonstrations.llms.md#pretraitement) | Une période absente, une mesure manquante et un événement réel ne sont pas équivalents. | Justifier un traitement utilisant seulement le passé disponible. |
| Après la capsule 4 | Obligatoire : [comparer les références](../../modules/semaine-06-series-chronologiques-intro/lectures.llms.md#lecture-4), puis [origine fixe](../../modules/semaine-06-series-chronologiques-intro/demonstrations.llms.md#references) | Les candidats partagent la même origine et les mêmes cibles; validation et test ont des rôles distincts. | Dire quelles observations sont disponibles pour les douze prévisions. |
| Après la capsule 5 | Obligatoire : [mesurer les erreurs](../../modules/semaine-06-series-chronologiques-intro/lectures.llms.md#lecture-5), puis [mesures et graphiques](../../modules/semaine-06-series-chronologiques-intro/demonstrations.llms.md#erreurs) | Lire signe, unité, limites du MAPE et dénominateur d’apprentissage de la MASE. | Expliquer le dénominateur de la MASE et une limite d’un score. |
| Après la capsule 6 | Obligatoire : [communiquer l’incertitude](../../modules/semaine-06-series-chronologiques-intro/lectures.llms.md#lecture-6), puis [intervalles](../../modules/semaine-06-series-chronologiques-intro/demonstrations.llms.md#incertitude) | Point, niveau nominal, largeur et horizon; un intervalle n’est pas une garantie. | Comparer deux niveaux et nommer une limite. |

Les deux dernières parties de la [synthèse complète](../../modules/semaine-06-series-chronologiques-intro/notes-cours.llms.md) sont des compléments facultatifs. Les opérations du lissage, de la régression saisonnière et des variables externes sont approfondies dans les modules 7 à 9.

## Lectures par capsule

Les explications françaises ci-dessous et les démonstrations constituent le support de travail du module. Les passages ci-dessous d’Hyndman, R. J., et Athanasopoulos, G. (2021), Forecasting: Principles and Practice, 3e édition, servent de compléments facultatifs de lecture. Les exemples du livre utilisent souvent l’écosystème fable; nos calculs emploient ici tidyverse et forecast, pour les démonstrations reproductibles du cours.

## Après la capsule 1 : définir la tâche

### Repères du cours

#### Un tableau ordonné dans le temps

Une série chronologique est une suite de mesures repérées dans le temps. Avec plusieurs succursales, on possède plusieurs séries; il faut identifier la succursale et la date. La dépendance entre périodes doit être examinée et ne disparaît pas parce que les données sont en tableau.

#### Le cas guidé

Le fichier contient le calendrier et le nombre de jours de chaque mois. La variable cible est consommation_kwh, une quantité d’énergie en kWh. La date désigne le mois entier, sans représenter une mesure faite uniquement le premier jour. Les valeurs sont simulées pour un bâtiment universitaire fictif au Québec.

#### Origine, cible et horizon

À la fin de décembre 2024, prévoir la consommation de janvier à décembre 2025 signifie produire douze valeurs, aux horizons 1 à 12 mois. Une prévision pour la consommation totale du trimestre est une cible différente des trois prévisions mensuelles.

#### Fréquence et granularité

La fréquence désigne la résolution temporelle. La granularité désigne le périmètre des mesures, spatial, démographique ou temporel. Agréger peut réduire le bruit, mais efface des détails. Une prévision provinciale ne fournit pas directement les besoins de chaque succursale. Désagréger exige une règle justifiée. Une couverture très fine peut produire de faibles comptes, des zéros et une série plus bruyante. Le niveau d’agrégation doit donc être choisi avec le prétraitement, la méthode et les mesures d’erreur, selon la décision à prendre.

#### L’expertise complète les mesures

Les personnes qui connaissent le domaine expliquent la collecte, les unités, les événements inhabituels et les conséquences des erreurs. La qualité des mesures et la continuité de la collecte conditionnent le suivi. Une interprétation exige de communiquer avec les utilisateurs de la prévision.

#### Le processus est une boucle

Une évaluation insuffisante peut conduire à revoir les méthodes, l’objectif ou la collecte. Les nouvelles observations alimentent le suivi et un éventuel réajustement. Ce processus ne garantit pas que les données permettent d’atteindre la précision souhaitée.

#### Préciser la décision

Le choix de la mesure d’erreur et du niveau d’agrégation doit refléter la décision. Prévoir l’énergie mensuelle en kWh ne suffit pas à prévoir une pointe de puissance en kW. Pour convertir l’énergie en budget, il faudrait préciser les tarifs et les autres postes de la facture.

> **TIP:**
>
> Origine, cible, kWh, trois horizons mensuels et usage sont explicites. La granularité correspond au bâtiment fictif.

### Complément bibliographique facultatif

[1.6, The basic steps in a forecasting task](https://otexts.com/fpp3/intro.html#sec-basic-steps).

Repérez le rôle des utilisateurs et de l’expertise. Quels renseignements manquent à la phrase « prévoir la consommation »?

## Après la capsule 2 : lire les composantes

### Repères du cours

#### Respecter les axes

Lire d’abord les axes et les unités. La ligne relie des mesures mensuelles, sans prouver ce qui se produit entre elles. Une hausse et un motif annuel semblent présents; la génération simulée ne permet pas d’identifier un mécanisme causal réel.

#### Niveau et tendance

Le niveau n’est pas nécessairement la moyenne de toute la série lorsque celle-ci évolue. La tendance peut être linéaire, quadratique, exponentielle ou plus souple. Une forme descriptive ne garantit pas une extrapolation fiable.

#### Saisonnalité, cycle et reste

La saisonnalité revient à des périodes connues: mois, jours de la semaine ou saisons. Un cycle n’a pas obligatoirement une durée stable. Le reste peut comprendre bruit de mesure, événements et structure non modélisée; il n’est pas automatiquement un bruit blanc. Une seule pointe ne suffit pas pour établir une saisonnalité.

#### Additif ou multiplicatif?

La distinction entre niveau, tendance, saisonnalité et bruit permet de décrire la série. Dans cette notation usuelle, T est la composante tendance-cycle incluant le niveau. Une amplitude saisonnière approximativement constante suggère une forme additive; une amplitude proportionnelle au niveau suggère une forme multiplicative. Cette dernière demande des valeurs compatibles, généralement strictement positives.

#### Montant ou pourcentage?

Ces valeurs sont un exemple didactique. Un supplément de 20 000 kWh représente 10 % de 200 000 kWh mais seulement 5 % de 400 000 kWh. Une variation de 10 % représente 20 000 puis 40 000 kWh. Observer ce comportement n’est pas ajuster une décomposition.

#### Comparer les mêmes mois

Les profils annuels aident à vérifier si des mois comparables se distinguent de façon répétée. La tendance peut aussi déplacer le niveau d’une année à l’autre. Il faut plusieurs répétitions et une justification de la fréquence saisonnière.

#### Zoomer et changer d’échelle

Un zoom précise les variations locales. Le logarithme modifie la lecture des écarts et exige des valeurs strictement positives. L’agrégation annuelle atténue le motif mensuel, mais n’équivaut pas à estimer une composante saisonnière. Des graphiques séparés par saison et une moyenne mobile sont d’autres diagnostics, approfondis ensuite.

#### L’objet ts et la fenêtre

La fréquence de ts est le nombre d’observations par cycle, ici 12 par an. ts ne vérifie pas les dates du CSV: contrôler d’abord le calendrier. window conserve la structure temporelle. Le module 2 a déjà introduit le projet Quarto utilisé ici pour réunir code, résultats et interprétation.

#### Une tendance descriptive

Le modèle tslm(serie ~ trend + I(trend^2)) reprend la tendance quadratique étudiée au module 4. La courbe rouge est ajustée sur 2020 à 2024; elle ne représente pas la composante saisonnière et ne prouve ni mécanisme ni performance future.

> **TIP:**
>
> Le graphique et l’interprétation utilisent seulement l’apprentissage; la saisonnalité est distinguée d’une hausse continue.

### Complément bibliographique facultatif

[3.2, Time series components](https://otexts.com/fpp3/decomposition.html#sec-components).

Distinguez montant saisonnier constant et proportion constante. Complément : chapitre 2, graphiques temporels et saisonniers.

## Après la capsule 3 : préparer les données

### Repères du cours

#### Quatre vérifications

Il faut distinguer une date absente du tableau, une date présente avec une valeur manquante et une véritable mesure égale à zéro. Documenter également le changement d’instrument, de périmètre ou de définition de la variable.

#### Mensuel ne signifie pas trente jours

Le nombre de jours diffère selon le mois. La régularité mensuelle se vérifie par le calendrier et non par une différence constante en jours. Pour des observations hebdomadaires régulières, les intervalles sont de sept jours.

#### Valeur manquante ou période absente

Une grille complète rend les absences explicites. Certaines fonctions de modèle gèrent des valeurs manquantes, d’autres non. La compatibilité dépend de l’implémentation; il serait incorrect d’affirmer que tous les modèles ARIMA les refusent.

#### Imputer exige une règle

Une imputation peut utiliser un modèle, des valeurs proches dans le passé ou des informations externes disponibles. Elle conserve les positions du calendrier, remplace une mesure inconnue par une estimation et ajoute de l’incertitude. Une méthode compatible avec les valeurs manquantes travaille avec moins d’information observée. Pour chaque origine d’évaluation, le traitement est réestimé sans regarder au-delà de cette origine. On ne remplace pas les cibles de validation inconnues par des valeurs imputées pour calculer des scores comme si elles étaient observées.

On peut aussi comparer, ou combiner après validation, une prévision obtenue après imputation et celle d’une méthode acceptant des valeurs manquantes. Cette comparaison ne supprime pas l’incertitude d’imputation. Les deux approches doivent garder le calendrier, la même cible et la même information disponible à l’origine. Supprimer des lignes sans conserver leurs positions ne constitue pas une solution équivalente.

#### Espacement irrégulier

Une suite de mesures à des instants irréguliers est une série temporelle, mais n’est pas directement un objet ts régulier. L’agrégation crée une nouvelle cible; l’interpolation crée des estimations. Le choix dépend de l’objectif et de la méthode, sans inventer de mesures.

#### Extrême : erreur ou événement?

Une fermeture, une panne ou des travaux peuvent expliquer une valeur extrême. L’expertise du domaine et une analyse de sensibilité avec et sans traitement éclairent le choix. Une analyse qui retire un événement réel doit indiquer quel futur elle suppose.

#### Combien d’années utiliser?

La durée utile n’est pas une règle fixe. Une fenêtre courte manque d’information; un passé ancien peut relever d’un autre régime. Comparer les fenêtres par une validation temporelle, sans supprimer les années difficiles après avoir vu les scores.

#### Les variables externes arrivent-elles à temps?

Une variable externe n’est utilisable que si sa valeur, sa prévision ou un scénario explicite existe au moment de produire la prévision. Sa disponibilité historique dans un tableau ne prouve pas sa disponibilité opérationnelle. La collecte doit continuer après la mise en service.

> **TIP:**
>
> NA, zéro et date absente sont distingués. Aucune étape n’utilise la validation pour estimer le traitement.

### Complément bibliographique facultatif

[13.9, Dealing with outliers and missing values](https://otexts.com/fpp3/practical.html#sec-missing-outliers).

Pourquoi ne faut-il pas remplacer toute valeur extrême automatiquement? Les méthodes acceptent-elles toutes les mêmes valeurs manquantes?

## Après la capsule 4 : comparer les références

### Repères du cours

#### Bien ajuster n’est pas bien prévoir

Un modèle flexible peut ajuster le bruit. Le R² d’apprentissage et les résidus ne suffisent pas à mesurer la performance de prévision. Les données utilisées pour sélectionner un candidat ne fournissent pas ensuite une évaluation finale indépendante. Une comparaison à origine fixe garde le même passé pour tout l’horizon. À origine mobile, on avance dans le temps et on réajuste avec les observations déjà reçues, en gardant l’horizon de comparaison constant. Le complément A détaille ce protocole; il n’est pas nécessaire de programmer cette boucle pour terminer le parcours principal.

#### Apprentissage, validation et test

Pour des observations transversales indépendantes, un découpage aléatoire peut former trois ensembles : l’apprentissage sert à estimer les paramètres; la validation sert à comparer les candidats; le test sert à évaluer le choix final sur des données qui n’ont pas participé à cette sélection.

Pour prévoir une série, le découpage respecte l’ordre temporel et reproduit l’information disponible au moment d’agir. Une période finale de test reste possible si l’historique le permet. Un tirage aléatoire peut faire entrer le futur dans l’apprentissage et ne reproduit pas la décision de prévision. Le rôle des ensembles importe davantage que leur nom.

#### La séparation du cas guidé

Les méthodes candidates sont fixées avant la comparaison. Le bloc de 2025 sert ici à les comparer: nous l’appelons validation. Un test final distinct est possible si la taille et le calendrier le permettent; il n’est ni interdit ni toujours disponible. Une séparation aléatoire mélangerait passé et futur et pourrait créer des trous.

#### Le naïf à origine fixe

Cette référence est simple et parfois utile en pratique, mais ignore tendance et saisonnalité. On ne lui donne pas la consommation de janvier 2025 pour prévoir février dans un scénario où les douze prévisions ont été émises en décembre 2024.

#### Le naïf saisonnier

Pour un horizon dépassant un cycle, on répète le dernier cycle observé: on n’utilise pas une valeur future encore inconnue. Formellement, on choisit l’observation la plus récente de la même saison disponible à T. Le principe exige une période saisonnière justifiée.

#### Comparer sur les mêmes mois

Les lignes colorées sont toutes produites en décembre 2024. Le noir montre les observations révélées ensuite. Le candidat tendance est une régression quadratique du temps, sans saisonnalité. Il ne devient pas préférable parce qu’il est plus complexe.

#### Du code à la référence

Le code complet est dans les démonstrations et le projet téléchargeable. Une prévision saisonnière peut être décalée si le calendrier a des trous; d’où la vérification avant ts et avant la comparaison.

#### Choisir la période selon l’horizon

La validation doit contenir les horizons utiles. Un score à un mois ne renseigne pas directement sur une décision à douze mois. Une origine fixe donne ici une erreur par horizon, ce qui motive la validation à origine mobile du complément A.

#### Réajuster avant la vraie prévision

Après l’évaluation, les observations récentes peuvent rejoindre l’apprentissage pour la prévision réelle. Les scores historiques restent ceux obtenus sans réajustement sur la validation. Refaire l’ajustement ne transforme pas les scores de validation en scores indépendants du choix. Les observations récentes apportent une information plus proche du futur visé; davantage de données peuvent aider l’estimation, sans garantie en cas de rupture. Réajuster rapproche aussi l’origine du futur à prévoir : après douze mois de validation, le prochain mois est à h = 1 depuis la nouvelle origine, mais à h = 13 depuis l’ancienne.

> **TIP:**
>
> Les valeurs de 2025 ne changent pas les prévisions à origine fixe. Le calendrier et l’horizon sont identiques pour les candidats.

### Complément bibliographique facultatif

[5.2, Some simple forecasting methods](https://otexts.com/fpp3/toolbox.html#sec-simple-methods).

Quelles valeurs sont disponibles pour le naïf saisonnier lorsque l’horizon dépasse un cycle?

## Après la capsule 5 : mesurer les erreurs

### Repères du cours

#### Une convention de signe

Un résidu concerne les données utilisées pour ajuster; une erreur de prévision compare une observation future à une valeur émise avant de la connaître. Pour éviter une ambiguïté, nommer l’origine et l’horizon.

#### ME, MAE et RMSE

La ME décrit le biais moyen signé, la MAE l’ampleur absolue moyenne et la RMSE donne plus de poids aux grandes erreurs. Les trois sont en kWh dans le cas guidé. Elles peuvent classer les méthodes différemment.

#### Les erreurs peuvent s’annuler

La moyenne signée n’est pas une mesure suffisante de précision. Le suivi énergétique peut alterner sous-estimation et surestimation des besoins même si les erreurs se compensent en moyenne.

#### Le MAPE et ses limites

Le MAPE est sans unité, mais requiert une échelle où le zéro a un sens. Il ne convient pas aux températures en degrés Celsius. Exclure les cibles nulles change l’ensemble évalué et peut cacher des erreurs.

Pour des observations et des prévisions positives, une sous-prévision ne dépasse pas 100 % d’erreur relative, alors qu’une sur-prévision peut dépasser 100 %. Cette asymétrie peut influencer les comparaisons et le choix de prévisions qui minimisent ce score. À observation fixée, deux prévisions à la même distance de part et d’autre de cette observation donnent cependant le même pourcentage absolu : il faut préciser ce qui est comparé.

#### La MASE : une échelle d’apprentissage

Le dénominateur utilise uniquement l’apprentissage. La MASE est sans unité et tolère des observations de validation nulles lorsque q est positif. Si toutes les différences de référence valent zéro, elle est indéfinie. Les méthodes d’une comparaison doivent partager le même dénominateur.

#### Que signifie MASE \< 1?

La comparaison se fait avec l’erreur moyenne de référence sur l’apprentissage, pas avec l’erreur de la référence sur les mêmes mois de validation. Pour affirmer une amélioration sur la validation, comparer directement les deux MAE de validation.

#### Le résultat du cas guidé

Lire le classement obtenu, sans annoncer un vainqueur universel. Les méthodes sont naïve, saisonnière et tendance. Les cinq mesures utilisent les douze mêmes observations de validation. La MASE emploie m égal à 12 pour toutes les méthodes.

#### Lire le temps et la distribution

Un graphique temporel peut montrer un biais, une évolution, une période difficile ou une succession d’erreurs de même signe. Un histogramme décrit leur distribution; douze erreurs ne suffisent pas à certifier normalité ou indépendance. Les dépendances sont approfondies au module 9.

> **TIP:**
>
> MASE utilise l’apprentissage, le MAPE n’efface aucun zéro et les erreurs sont séparées des résidus.

### Complément bibliographique facultatif

[5.8, Evaluating point forecast accuracy](https://otexts.com/fpp3/toolbox.html#sec-accuracy).

Repérez le dénominateur de la MASE et deux limites du MAPE.

## Après la capsule 6 : lire l’incertitude

### Repères du cours

#### Un point et une plage

Une plage plus large signale une incertitude plus importante. Un intervalle de prédiction vise une nouvelle observation; un intervalle de confiance pour une moyenne ou un paramètre vise un autre objet. La précision d’un point et la couverture d’un intervalle sont distinctes.

#### Interpréter 95 %

Cette interprétation suppose un modèle et des conditions adéquats. Elle n’est pas une garantie pour cette observation particulière. Un intervalle usuel par horizon n’est pas automatiquement une bande simultanée qui couvre toute la trajectoire à 95 %. La rupture de régime ou une variable future inconnue peut rendre l’intervalle trompeur.

#### Une approximation normale

La distribution prédictive et la prise en compte de l’estimation doivent être justifiées. Un histogramme avec douze erreurs ne valide pas ces conditions. Des modèles et procédures simulées peuvent produire des intervalles asymétriques. Une formule de cours ne doit pas être appliquée à tout modèle sans contrôle.

#### Plus loin, plus incertain?

À modèle et horizon fixés, des intervalles emboîtés à 80 et 95 % ont des largeurs différentes. L’incertitude peut croître avec l’horizon, mais ce n’est pas une loi universelle pour toute série et toute méthode. Les saisonnalités et les paramètres peuvent modifier la forme du cône.

#### Lire un cône de prédiction

La ligne centrale est la prévision ponctuelle; les zones représentent ici les niveaux 80 et 95 %. Le modèle est un exemple pour lire l’incertitude, pas un vainqueur sélectionné. Les détails du lissage seront étudiés au module 7. Dans ce cas, la borne inférieure à 95 % devient négative à h = 12, ce qui n’a pas de sens physique pour une consommation d’énergie. Cette limite invite à revoir la structure et la calibration du modèle avant un usage opérationnel.

#### Lire les trois lettres ETS

AAN possède une erreur additive, une tendance additive et aucune saisonnalité; AAA possède une saisonnalité additive. Une tendance peut aussi être amortie. Toutes les combinaisons de lettres ne correspondent pas à un modèle admissible, et les composantes multiplicatives imposent des conditions de positivité. Le nombre de modèles admissibles dépend donc des restrictions de leurs composantes.

#### Comparer des cônes sans choisir à l’œil

Le code des démonstrations reproduit trois cônes sur la même origine. La largeur seule ne mesure pas la qualité: un intervalle très large peut couvrir sans être utile. Une comparaison sérieuse lit la couverture empirique, la largeur et les performances par horizon. Les rares observations de ce module n’établissent pas la calibration.

#### Relier l’intervalle à une décision

La décision demande un coût, une contrainte et parfois un quantile adapté. Le point moyen n’est pas toujours le seuil adapté au suivi énergétique. Les intervalles conditionnels à un scénario externe n’intègrent pas nécessairement l’incertitude de ce scénario.

> **TIP:**
>
> Le niveau, l’origine et l’horizon sont nommés; aucune certitude absolue ni couverture de toute la trajectoire n’est annoncée.

### Complément bibliographique facultatif

[5.5, Distributional forecasts and prediction intervals](https://otexts.com/fpp3/toolbox.html#sec-prediction-intervals).

Distinguez niveau nominal, largeur et horizon. Complément facultatif : section 8.5 pour la notation ETS.

## Complément facultatif A : faire avancer l’origine

### Repères du cours

#### Faire avancer l’origine

À chaque origine, l’apprentissage ne contient que les observations déjà disponibles. L’actualisation du modèle est réaliste lorsque les nouvelles mesures sont réellement arrivées. Il faut réestimer aussi les transformations et les imputations à cette origine.

#### Fixe ou mobile?

Une colonne lag sur l’ensemble de la série peut représenter des prévisions à un pas réactualisées. Elle ne représente pas douze prévisions émises en décembre 2024. Les deux scénarios sont valides si la décision les exige, mais leurs scores répondent à des questions différentes.

#### Combien de comparaisons?

Avec soixante mois initiaux et douze mois de validation, les origines vont de T égal à 60 à 72 moins h. Le nombre vaut 13 moins h, pour h de 1 à 12. Si les horizons restent dans la validation, les prévisions plus lointaines disposent de moins de répétitions.

#### Le geste à chaque origine

L’observation cible n’est consultée que pour calculer l’erreur après émission de la prévision. Le script complet boucle sur toutes les origines autorisées et les horizons 1 et 6.

#### Comparer par horizon

La colonne n permet de vérifier les répétitions. Les deux méthodes utilisent les mêmes origines à un horizon donné. Les scores à h égal à 1 et h égal à 6 ne portent pas sur exactement les mêmes cibles. Le classement peut changer selon l’horizon.

#### Fenêtre croissante ou glissante

La fenêtre croissante de ce module ajoute les nouvelles observations. Une fenêtre glissante peut mieux refléter un changement de régime, mais perd des données. Sa longueur doit être choisie dans une validation cohérente, sans regarder le test final.

#### Réévaluer sans recycler le test

Une sélection répétée sur les mêmes observations peut surajuster la validation. Rapporter le protocole et réserver une nouvelle période lorsque possible. Le suivi n’est pas une preuve que le modèle restera bon après une rupture.

#### Choisir selon la décision

Le protocole doit reproduire le moment où l’on agit, l’information disponible et le délai. Un modèle peut être utile pour le personnel et insuffisant pour une commande à long délai; sa performance moyenne sur tous les horizons ne suffit pas.

> **TIP:**
>
> Il y a 12 origines à h = 1 et 7 à h = 6. Les informations au-delà de chaque origine servent seulement à évaluer.

### Complément bibliographique facultatif

[5.10, Time series cross-validation](https://otexts.com/fpp3/toolbox.html#sec-tscv).

À chaque origine, quelles observations peuvent entrer dans le modèle? Pourquoi faut-il séparer les horizons?

## Complément facultatif B : combiner les méthodes

### Repères du cours

#### Structure explicite ou adaptation locale

La distinction entre structure explicite et adaptation locale sert à comparer les méthodes. Les deux apprennent à partir des données et certaines ont une formulation statistique commune. Les modèles de lissage peuvent aussi être écrits comme des modèles d’espace d’état. Il ne s’agit donc pas de catégories exclusives.

Une structure parcimonieuse peut être utile pour une série courte si ses hypothèses sont défendables. Une méthode adaptative peut suivre une structure changeante, mais elle exige assez d’information pour régler sa mémoire et sa saisonnalité. Ces avantages sont conditionnels : le choix reste fondé sur une validation cohérente.

#### Motif global et mémoire locale

Un modèle simple estimé sur toute la série décrit une structure globale dans le temps. Un lissage peut accorder plus de poids aux dernières périodes. Mémoire courte: adaptation plus rapide et sensibilité au bruit; mémoire longue: stabilité et réaction plus lente. Le mot global ne désigne pas ici un modèle entraîné sur plusieurs séries.

#### Extrapoler ou utiliser des entrées?

Une régression du temps et du calendrier peut extrapoler la série. Une régression avec variables externes requiert leurs valeurs futures ou leurs scénarios. Les modèles économétriques peuvent s’appuyer sur une théorie causale, mais un bon score de prévision ne prouve pas la causalité. Des modèles multivariés décrivent des relations entre séries sans les rendre automatiquement causales.

#### Disponible au moment de prévoir

La disponibilité opérationnelle est une condition nécessaire. Une fermeture planifiée peut être connue; la température réellement observée dans le futur ne l’est pas et doit être prévue ou scénarisée. Les hypothèses des scénarios doivent apparaître dans le rapport et l’incertitude.

#### Manuel, automatisé, surveillé

L’expertise peut compléter ou réviser une prévision, avec une trace de la modification. Automatiser ne dispense ni du contrôle des données ni de la validation. Les méthodes légères peuvent faciliter un grand nombre de séries, mais aucune famille n’élimine le surajustement ni le besoin d’entretien.

#### Combiner les prévisions

Une combinaison parallèle utilise plusieurs prévisions de la même cible, origine et horizon. Une stratégie peut également retenir différentes méthodes selon les horizons ou les périodes, à condition de valider la règle. Des poids choisis sur la validation doivent être évalués ensuite sur de nouvelles données ou de nouvelles origines.

#### Diversifier les erreurs

La covariance explique pourquoi la complémentarité des erreurs compte. Une covariance négative peut diminuer la variance combinée. Le biais des erreurs et leurs variances importent aussi; une combinaison ne garantit pas une MAE inférieure à celle de chaque candidat.

#### Corriger en deux étapes

Une méthode en cascade tente de prévoir la structure restante des erreurs. L’ajustement de cette correction exige des erreurs produites sans fuite temporelle et une nouvelle validation; on ne corrige pas une prévision en lui donnant son erreur future observée.

#### La suite du cours

Ce module donne le cadre commun et des exemples opérationnels. Les modules suivants approfondissent les méthodes, sans remplacer la définition de la cible, les références, la validation temporelle ni la communication de l’incertitude.

> **TIP:**
>
> Les deux prévisions partagent cible, origine et horizon. Le gain de combinaison est vérifié, jamais supposé.

### Complément bibliographique facultatif

[13.4, Forecast combinations](https://otexts.com/fpp3/practical.html#sec-combinations).

Une moyenne de prévisions garantit-elle un gain? Compléments facultatifs : chapitre 6 sur le jugement et section 7.6 sur les variables futures.

## Lire activement, puis pratiquer

Pour une difficulté précise, choisissez parmi les [exercices supplémentaires corrigés](../../modules/semaine-06-series-chronologiques-intro/exercices.llms.md#pratique-supplementaire) :

- cible, composantes et calendrier : exercices 9 à 11, après les capsules 1 à 3;
- origine et mesures d’erreur : exercices 12 à 14, après les capsules 4 et 5;
- incertitude et lecture critique : exercices 15 et 16, après la capsule 6.

Les nombres de ces exercices sont fictifs et fournis dans les énoncés. Les corrigés détaillent le raisonnement; les calculs en R permettent de vérifier les valeurs. La pratique supplémentaire et les deux compléments ne sont pas requis pour terminer les rapports d’entraînement.

## Un exercice ciblé de l’ouvrage

Pour approfondir après les capsules 4 et 5, Hyndman et Athanasopoulos (2021), section 5.11, [exercice 6, assertions 2 à 5](https://otexts.com/fpp3/toolbox.html#sec-toolbox-exercises), propose une lecture critique de l’ajustement, des mesures, de la complexité et du choix d’une méthode. Ce complément est facultatif et ne demande ni jeu externe ni code `fable`. Justifiez vos réponses avec le protocole du cours; les corrigés des exercices 13, 14 et 16 de ce module donnent des repères sur les scores et les conclusions. Les autres exercices de ce chapitre ne sont pas requis.

## Lecture historique pour approfondir

David, M., Bonnieux, F., et Rainelli, P. (1983), [Introduction au traitement des séries chronologiques](https://www.persee.fr/doc/ecoru_0013-0559_1983_num_157_1_2997), Économie rurale, 157, 49-56.

Cette lecture, déjà présente dans l’archive du cours, reste disponible comme complément historique. Elle aborde la désaisonnalisation, l’analyse spectrale et la démarche de Box et Jenkins. Ces développements dépassent les calculs demandés dans le module 6; ils ne sont pas des prérequis pour terminer les deux rapports d’entraînement.

## Documentation R

- [forecast : documentation officielle](https://pkg.robjhyndman.com/forecast/)
- [ets : modèles d’espace d’état de lissage exponentiel](https://pkg.robjhyndman.com/forecast/reference/ets.html)
- [accuracy : mesures et échelle de la MASE](https://pkg.robjhyndman.com/forecast/reference/accuracy.default.html)

Ces compléments servent à vérifier les arguments et les conventions des fonctions, sans imposer un apprentissage supplémentaire de toutes les méthodes du package. Le cadre de lissage est approfondi au module 7.
