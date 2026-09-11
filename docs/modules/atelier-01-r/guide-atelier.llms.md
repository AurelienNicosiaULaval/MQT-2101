# Mission du laboratoire 01

Un premier diagnostic pour la direction

## Votre mission

La direction d’une PME québécoise fictive dispose d’un tableau mensuel décrivant ses cinq succursales. Elle souhaite consacrer sa prochaine analyse à une seule priorité : le marketing, les opérations ou la saisonnalité.

Vous jouez le rôle de l’équipe d’analyse. La direction vous demande un premier diagnostic pour répondre à cette question :

> Quelle priorité de prochaine analyse recommandez-vous, et quels résultats descriptifs justifient votre choix?

Votre réponse doit préciser une succursale, une période ou une comparaison à examiner. Appuyez votre choix sur au moins deux résultats de votre rapport et indiquez une information supplémentaire à obtenir avant de proposer une intervention.

> **IMPORTANT:**
>
> Vous devez comprendre le tableau, vérifier sa qualité, calculer des indicateurs, visualiser et interpréter. Une régression, un test statistique ou une prévision ne sont pas demandés. Plusieurs priorités peuvent être défendables : c’est la cohérence entre la question, les résultats et la conclusion qui sera discutée.

## Organisation du travail

La séance commence par une [présentation de 10 à 15 minutes](../../modules/atelier-01-r/presentation.llms.md). Vous travaillez ensuite dans votre rapport, avec l’accompagnement de l’enseignant. Le [déroulement horaire](../../modules/atelier-01-r/index.llms.md#pendant-latelier) réserve deux moments à la rétroaction.

Travaillez en binômes, avec un rapport par binôme. Alternez la personne au clavier après le premier point de rétroaction. Chaque personne doit pouvoir expliquer l’importation, un indicateur et la priorité retenue. Si vous travaillez seul, les mêmes productions sont attendues.

Le laboratoire est formatif, sans points dans la note finale. Il prépare la démarche des mini-rapports évalués, dont les consignes sont séparées.

## Dossier de départ

[Télécharger le dossier du laboratoire](../../assets/exemples/laboratoire-01.zip)

Décompressez l’archive avant de l’ouvrir. Elle contient :

``` text
laboratoire-01/
  laboratoire-01.Rproj
  rapport-labo-01.qmd
  LIRE-MOI.txt
  data/
    ventes_pme_quebec.csv
```

1.  Ouvrez `laboratoire-01.Rproj` dans RStudio ou Positron.
2.  Ouvrez `rapport-labo-01.qmd` et remplacez le nom de l’auteur par vos noms.
3.  Cliquez sur Render. Vous obtenez `rapport-labo-01.html` dans le même dossier.
4.  Complétez les sections et les blocs de code au fil de la mission, puis relancez Render régulièrement.

L’importation est déjà écrite avec le chemin relatif `data/ventes_pme_quebec.csv`. Gardez le CSV dans `data/` et le `.qmd` à la racine du dossier. N’ajoutez pas `install.packages()` au rapport : l’installation se fait une fois dans la Console, au besoin.

Le [CSV seul](data/ventes_pme_quebec.csv) reste téléchargeable. Il s’agit de données simulées pour le cours, déjà utilisées dans les exercices du module 2. Ici, vous les mobilisez pour comparer les succursales et défendre une priorité, au-delà de la comparaison guidée par saison.

## Étape 1 : comprendre et vérifier les données

À faire entre 9 h 15 et 10 h, avec l’étape 2.

Dans la section « Données et qualité » du rapport :

1.  Vérifiez les dimensions et les dates minimale et maximale. Expliquez ce que représente une ligne.
2.  Choisissez trois variables utiles à la mission. Précisez leur sens, leur type statistique et leur unité, s’il y a lieu. Un dictionnaire de toutes les colonnes n’est pas demandé.
3.  Comptez les valeurs manquantes par variable. Nommez les variables concernées et expliquez votre traitement.

> **TIP:**
>
> Retrouvez les fonctions `glimpse()`, `dim()`, `range()` et `is.na()`. Les exercices 1 et 3 du module 2 montrent leur utilisation. Pour compter les valeurs absentes de chaque colonne, vous pouvez combiner `summarise()` et `across()`.
>
> `na.rm = TRUE` calcule un résumé à partir des valeurs disponibles. Il ne remplace pas les valeurs manquantes et ne garantit pas que les valeurs disponibles représentent bien l’ensemble des mois.

## Étape 2 : comparer les succursales

Construisez un tableau contenant, pour chaque succursale :

- le nombre de mois observés;
- les ventes totales sur la période, en dollars canadiens;
- les ventes par client sur la période, calculées par `sum(ventes) / sum(clients)`;
- un indicateur de service choisi parmi le délai moyen de livraison, la satisfaction moyenne ou le nombre total de ruptures de stock.

Si votre indicateur comporte des valeurs manquantes, ajoutez le nombre de mois effectivement utilisés dans son calcul. Comparez deux succursales dans une courte phrase chiffrée. Le classement change-t-il lorsqu’on passe des ventes totales aux ventes par client?

> **TIP:**
>
> `group_by(succursale)` forme les groupes et `summarise()` calcule une ligne par succursale. `n()` compte les lignes du groupe et `sum(!is.na(satisfaction))` compte les scores disponibles.
>
> Le ratio des ventes totales au nombre total de clients pondère les mois par leur nombre de clients. La moyenne simple des paniers mensuels donne le même poids à chaque mois. Ces deux calculs ne répondent pas exactement à la même question.
>
> Pour le délai et la satisfaction, une moyenne des valeurs mensuelles disponibles donne le même poids à chaque mois. Elle ne représente pas une moyenne calculée sur toutes les livraisons ou toutes les réponses individuelles. Utilisez des noms distincts pour les colonnes sources et les indicateurs calculés, par exemple `satisfaction_moyenne`.

> **NOTE:**
>
> Montrez votre tableau et votre diagnostic. Préparez une explication de l’unité d’observation et du nombre de valeurs utilisées pour un indicateur. Repérez avec l’enseignant une vérification à faire ou une correction à apporter avant de poursuivre.

## Étape 3 : produire deux graphiques utiles

À faire après la pause, de 10 h 20 à 10 h 55.

Le premier graphique compare les ventes totales par succursale. Le second explore une dimension utile à votre priorité. Choisissez une seule piste dans ce tableau.

| Piste | Exemple de question pour le second graphique | Graphique possible |
|----|----|----|
| Marketing | Comment les dépenses marketing et les ventes varient-elles ensemble? | Nuage de points, une observation mensuelle par succursale |
| Opérations | Comment comparer les délais ou la satisfaction entre succursales? | Barres à partir d’un résumé, ou nuage de points délai-satisfaction |
| Saisonnalité | À quels mois les ventes sont-elles les plus élevées, et le profil est-il semblable entre succursales? | Courbes des ventes mensuelles, une par succursale |

Pour chaque graphique, écrivez la question, indiquez les unités sur les axes et ajoutez une ou deux phrases d’interprétation sous le résultat. Vous pouvez choisir une autre représentation si vous expliquez son utilité. Aucune droite de régression n’est nécessaire.

> **TIP:**
>
> `geom_col()` représente des valeurs déjà calculées, par exemple les ventes totales du tableau synthèse. `geom_point()` montre les observations du tableau mensuel. `geom_line()` peut relier les mois d’une même succursale avec `color = succursale`.
>
> Si le graphique utilise deux variables incomplètes, comptez les lignes pour lesquelles les deux valeurs sont disponibles. Signalez le nombre de points exclus. Pour une courbe de ventes, vérifiez que `mois` est une date et que les succursales sont distinguées.

## Étape 4 : répondre à la direction

À rédiger de 10 h 55 à 11 h 20, à partir des résultats déjà obtenus.

Écrivez trois constats chiffrés au total. Ils peuvent reprendre vos commentaires du tableau et des graphiques : il n’est pas nécessaire de les recopier dans une autre section. Chaque constat nomme une comparaison, une valeur ou un écart, avec son unité.

Terminez par un paragraphe qui répond directement à la mission :

1.  Choisissez une priorité de prochaine analyse et précisez la succursale, la période ou la comparaison visée.
2.  Renvoyez à au moins deux résultats de votre tableau ou de vos graphiques pour justifier ce choix.
3.  Expliquez une limite qui pourrait changer l’interprétation.
4.  Formulez une question de prochaine analyse et nommez une information supplémentaire à recueillir.

> **NOTE:**
>
> Une association entre marketing et ventes ne démontre pas un effet de la campagne. Un total de ruptures peut dépendre du volume d’activité. Un profil observé pendant une seule année ne suffit pas à établir une saisonnalité récurrente. Choisissez la limite qui concerne réellement votre analyse et expliquez sa conséquence.

## Rapport attendu

Le gabarit suit cette structure. Le rapport doit rester compréhensible pour une personne qui n’a pas votre session R sous les yeux.

| Section du gabarit | Contenu attendu |
|----|----|
| 1\. Mission | Question reformulée et objectif du diagnostic |
| 2\. Données et qualité | Importation, dimensions, période, unité d’observation, trois variables et diagnostic des valeurs manquantes |
| 3\. Comparaison des succursales | Tableau synthèse avec unités, effectifs nécessaires et commentaire |
| 4\. Deux graphiques | Questions, titres, axes et commentaires liés à la mission |
| 5\. Réponse à la direction | Priorité justifiée par deux résultats, limite et prochaine question |
| 6\. Bilan formatif | Rétroaction reçue, correction apportée et point à retravailler |

Visez environ 400 à 600 mots hors code et tableaux, avec trois constats chiffrés répartis dans le rapport. Gardez le code visible pour faciliter la rétroaction. Les résultats doivent provenir du code exécuté dans le `.qmd`.

## Rétroaction formative

De 11 h 20 à 11 h 35, échangez votre HTML avec un autre binôme. Chaque binôme relève un point réussi et propose une amélioration précise en s’appuyant sur la grille. L’enseignant vous accompagne pour vérifier les points qui restent incertains.

Pour chaque critère, indiquez « Acquis », « À consolider » ou « À reprendre ». Ces repères servent à choisir une correction, sans calcul de note.

| Critère | Ce qui permet de dire « Acquis » |
|----|----|
| Compréhension des données | La période, l’unité d’observation et les trois variables sont correctement décrites |
| Qualité et calculs | Les valeurs manquantes sont repérées, les unités sont correctes et les effectifs utiles sont indiqués |
| Tableau et graphiques | Le tableau et les deux graphiques répondent à des questions identifiables et se lisent sans deviner les unités |
| Raisonnement | Trois constats chiffrés sont présents et la priorité s’appuie sur deux résultats cohérents |
| Limites | Une limite précise encadre la conclusion et conduit à une question ou à un besoin d’information |
| Reproductibilité et bilan | Render refait l’analyse à partir du CSV, et le bilan nomme une correction ou un point à reprendre |

Une rétroaction utile précise où intervenir : « Ajoutez le nombre de mois disponibles à côté de la satisfaction moyenne » est plus exploitable que « Améliorez le tableau ».

## Fin de séance

De 11 h 35 à 11 h 50 :

1.  Appliquez une amélioration issue de la relecture et complétez le bilan.
2.  Enregistrez le `.qmd`. Redémarrez R, puis cliquez sur Render sans exécuter de commandes préparatoires dans la Console.
3.  Ouvrez le HTML produit et vérifiez les tableaux, les deux graphiques et la réponse à la mission.
4.  Conservez le dossier complet avec le `.qmd`, le `.html` et le CSV. Les modalités de transmission du rapport seront précisées en classe.

Si vous n’avez pas terminé, gardez les éléments réalisés et indiquez le blocage dans le bilan. Si le rendu échoue, montrez le premier message d’erreur pour recevoir de l’aide. L’objectif formatif est de repérer la prochaine étape qui vous permettra de progresser.

## Aide pendant la mission

Consultez d’abord la consigne et tentez le calcul. Si nécessaire, utilisez les indices repliés de ce guide, les [exercices corrigés du module 2](../../modules/semaine-02-r-quarto/exercices.llms.md) ou une [démonstration R](../../modules/atelier-01-r/demonstrations.llms.md). Adaptez le code à votre question et vérifiez le résultat obtenu.

Pour demander de l’aide, montrez le bloc essayé, le résultat ou le message d’erreur, et ce que vous cherchez à obtenir. Le [GPT du cours](https://chatgpt.com/g/g-6a0b2ec33d948191ad25b2f247b15de1-analyse-et-modelisation-des-donnees?ref=mini) peut servir de tuteur, conformément aux [règles du cours](../../ressources/ia.llms.md), après une première tentative. Vous devez pouvoir expliquer le code et les constats conservés. Notez dans votre bilan l’aide utilisée et ce que vous avez vérifié.

Les [exercices complémentaires](../../modules/atelier-01-r/exercices.llms.md) sont facultatifs. Ils ne constituent pas un second rapport à produire pendant cette séance.
