# Exercices - Semaine 01

## Objectif

Ces exercices vous invitent à appliquer les notions des capsules à un nouveau jeu de données sur les ventes et les activités de succursales québécoises. Aucun code n’est attendu cette semaine.

Après avoir rédigé votre réponse, cliquez sur « Solution détaillée » à la fin de l’exercice pour comparer votre démarche au corrigé. Chaque boîte est fermée à l’ouverture de la page; cliquez de nouveau sur son titre pour la refermer. Les réponses proposées sont des exemples. Vous pouvez répondre autrement, à condition de justifier votre réponse et de préciser ce que les données permettent ou ne permettent pas de conclure.

Jeu de données de transfert : [ventes_operations_quebec.csv](../../donnees/#ventes-et-opérations-de-succursales-québécoises).

Ces données sont simulées à des fins pédagogiques. Le [descriptif du fichier](../../donnees/index.llms.md#ventes-et-opérations-de-succursales-québécoises) précise le sens des variables : les délais et les scores de satisfaction sont des moyennes pour une succursale et un mois.

## Exercice 1 - Lire la structure d’une base

Une direction souhaite comparer la qualité du service entre les régions. Elle propose le dictionnaire de variables suivant, qui contient des erreurs :

| Variable                | Type proposé | Rôle proposé              |
|-------------------------|--------------|---------------------------|
| `mois`                  | catégorie    | identifiant de succursale |
| `succursale`            | nombre       | mesure de performance     |
| `canal_principal`       | catégorie    | contexte de vente         |
| `delai_livraison_jours` | nombre       | mesure opérationnelle     |
| `satisfaction`          | nombre       | mesure de perception      |

À faire :

- corriger les deux lignes manifestement erronées;
- nommer l’unité d’observation du fichier, c’est-à-dire ce que représente une ligne;
- indiquer quelle variable permet de former les groupes régionaux;
- nommer une précaution concernant `satisfaction`;
- expliquer pourquoi `mois` doit conserver un sens temporel.

> **TIP:**
>
> ### 1. Corriger le dictionnaire
>
> | Variable | Type à retenir | Rôle dans l’analyse |
> |----|----|----|
> | `mois` | Variable temporelle, enregistrée comme une date | Situer l’observation dans le temps et ordonner les mois. |
> | `succursale` | Variable catégorielle nominale | Identifier la succursale observée. |
> | `canal_principal` | Variable catégorielle nominale | Décrire le principal canal de vente du mois. |
> | `delai_livraison_jours` | Variable numérique, en jours | Mesurer le délai moyen de livraison de la succursale pour le mois. |
> | `satisfaction` | Variable numérique, score moyen sur 10 | Résumer la satisfaction moyenne de la succursale pour le mois. |
>
> Une variable catégorielle nominale sert à distinguer des catégories sans ordre naturel entre elles. Par exemple, les noms des succursales ne forment pas un classement. Une variable temporelle indique une date ou une période.
>
> Les deux lignes manifestement erronées sont donc `mois` et `succursale`. Une date n’identifie pas une succursale : plusieurs succursales sont observées le même mois. Inversement, le nom d’une succursale ne mesure pas une performance. Même si on remplaçait les noms par des codes 1, 2, 3 et 4, ces codes resteraient des étiquettes; leur moyenne n’aurait pas de sens comme indicateur de performance.
>
> ### 2. Nommer l’unité d’observation
>
> Une ligne représente une succursale pendant un mois. Par exemple, la première ligne décrit la succursale de Montréal en janvier 2025. Le fichier contient 24 lignes : 4 succursales observées pendant 6 mois, de janvier à juin 2025.
>
> Pour identifier une ligne, il faut donc connaître à la fois la succursale et le mois, soit la combinaison (`succursale`, `mois`). Ce ne sont ni 24 clients ni 24 succursales différentes. Une même succursale revient plusieurs fois dans le fichier.
>
> ### 3. Former les groupes régionaux
>
> La variable à utiliser est `region`. Elle permet de regrouper les lignes par région administrative avant de comparer un indicateur, par exemple le délai moyen observé. Dans ce fichier, chaque région n’est représentée que par une succursale. Une différence entre régions est donc aussi une différence entre ces succursales; elle ne décrit pas toutes les entreprises de ces régions.
>
> ### 4. Interpréter la satisfaction avec précaution
>
> `satisfaction` est un score moyen, pas un nombre de personnes satisfaites. Une valeur de 8,3 signifie un score moyen de 8,3 sur 10; elle ne signifie pas que 83 % des clients sont satisfaits.
>
> Deux autres précautions sont utiles :
>
> - 2 scores mensuels sont manquants. Une valeur manquante n’est pas un score de zéro.
> - Le fichier ne donne ni le nombre de répondants ni les réponses individuelles. On ne peut donc pas calculer la satisfaction moyenne de l’ensemble des répondants : il faudrait connaître le nombre de personnes représentées par chaque score mensuel pour donner à ce score le poids approprié.
>
> ### 5. Conserver le sens temporel de `mois`
>
> Le temps permet d’ordonner les observations, de suivre une évolution et de comparer les succursales sur les mêmes périodes. Si on traite les mois comme de simples étiquettes sans ordre, on peut perdre la chronologie. Le nom du mois seul ferait aussi perdre l’année si on ajoutait des observations de 2026.
>
> Le premier jour inscrit dans une date comme `2025-01-01` sert ici à désigner le mois de janvier : les ventes de la ligne concernent le mois entier. Enfin, les observations successives d’une même succursale ne doivent pas être confondues avec celles de succursales différentes.

## Exercice 2 - Lire une analyse univariée

Voici un résumé de `delai_livraison_jours`.

| Minimum (jours) | Moyenne (jours) | Médiane (jours) | Maximum (jours) | Valeurs manquantes |
|---:|---:|---:|---:|---:|
| 1,8 | 3,3 | 3,5 | 4,6 | 1 |

![](exercices_files/figure-html/histogramme-delai-livraison-semaine-01-1.png)

Distribution des délais de livraison observés

Rédigez trois phrases :

1.  une phrase qui situe le délai habituel sans se limiter au minimum;
2.  une phrase qui décrit la forme visible de la distribution;
3.  une phrase qui explique l’effet des valeurs manquantes sur la portée du résumé.

> **TIP:**
>
> ### Une réponse possible en trois phrases
>
> 1.  Dans les données disponibles, les délais de livraison par succursale et par mois sont en moyenne de 3,30 jours, et leur médiane est de 3,50 jours.
> 2.  L’histogramme présente un seul sommet principal autour de 3,5 jours, avec des valeurs moins fréquentes aux extrémités et un étalement un peu plus important du côté des délais courts.
> 3.  Ces résultats portent sur 23 observations sur 24 et excluent le délai manquant, dont on ne connaît pas la valeur.
>
> ### Lire les indicateurs et le graphique
>
> Le minimum, 1,80 jour, décrit seulement la plus petite valeur observée. Il ne suffit pas pour parler du délai habituel. Pour calculer la moyenne, on additionne les 23 délais disponibles, puis on divise cette somme par 23 :
>
> 75,9 ÷ 23 = 3,30 jours.
>
> La médiane correspond à la 12e valeur lorsque les 23 délais disponibles sont rangés du plus petit au plus grand. Au moins la moitié des valeurs sont inférieures ou égales à 3,50 jours et au moins la moitié sont supérieures ou égales à cette valeur.
>
> L’histogramme complète ces indicateurs. Avec les classes affichées, la barre la plus élevée regroupe les délais entre 3,25 et 3,75 jours. L’ensemble des valeurs observées va de 1,80 à 4,60 jours. La moyenne un peu inférieure à la médiane est cohérente avec l’étalement visible du côté des délais courts. Cette lecture du graphique suffit : il n’est pas nécessaire d’attribuer une loi de probabilité à la distribution.
>
> ### Ce que change la valeur manquante
>
> Le tableau et l’histogramme excluent le délai manquant. Ils ne le remplacent pas par zéro : un zéro représenterait une livraison sans délai, ce qui serait une information inventée. On ne connaît ni le délai absent ni la raison de son absence; on ne peut donc pas affirmer que son exclusion est sans effet, ni déterminer dans quel sens elle modifierait la moyenne.
>
> Enfin, chaque valeur du graphique est déjà un délai moyen pour une succursale et un mois. La moyenne de 3,30 jours donne le même poids à chaque ligne disponible, même si une succursale a effectué plus de livraisons qu’une autre. Pour calculer le délai moyen de toutes les livraisons réunies, il faudrait tenir compte du nombre de livraisons représentées par chaque ligne. Le fichier ne fournit pas cette information.

## Exercice 3 - Comparer des groupes et des indicateurs

Une gestionnaire hésite entre deux indicateurs pour comparer les canaux de vente : les ventes totales et les ventes par client.

Dans le tableau, les lignes sont regroupées selon `canal_principal`. Par exemple, le groupe « web » rassemble les observations pour lesquelles le web est le principal canal de vente de la succursale pendant le mois considéré.

| Canal principal | Nombre de lignes | Ventes totales (dollars) | Total des clients | Ventes par client (dollars) | Satisfaction moyenne (sur 10) |
|:---|---:|---:|---:|---:|---:|
| magasin | 11 | 1 106 155 | 19 335 | 57,21 | 8,12 |
| téléphone | 3 | 351 375 | 6 044 | 58,14 | 8,13 |
| web | 10 | 1 158 115 | 18 296 | 63,30 | 7,94 |

À faire :

- expliquer pourquoi les ventes totales et les ventes par client ne répondent pas à la même question;
- choisir l’indicateur le plus pertinent pour comparer le montant moyen dépensé par un client et justifier ce choix;
- formuler un constat prudent sur la satisfaction;
- nommer une variable de contexte qui pourrait modifier la comparaison;
- expliquer pourquoi le tableau ne démontre pas qu’un canal cause un niveau de satisfaction donné.

> **TIP:**
>
> ### 1. Distinguer les deux questions
>
> Les ventes totales répondent à la question : « Quel est le montant total des ventes pour les observations de ce groupe? » Elles dépendent notamment du nombre de lignes, du nombre de clients et du montant dépensé par client.
>
> Les ventes par client répondent à une autre question : « Quel montant de ventes obtient-on, en moyenne, par client comptabilisé dans ce groupe? » On divise les ventes totales du groupe par le total des clients du même groupe. L’unité est le dollar par client, tandis que les ventes totales s’expriment en dollars.
>
> ### 2. Calculer et choisir l’indicateur
>
> Les trois calculs sont :
>
> - Magasin : 1 106 155 \$ ÷ 19 335 clients = 57,21 \$ par client.
> - Téléphone : 351 375 \$ ÷ 6 044 clients = 58,14 \$ par client.
> - Web : 1 158 115 \$ ÷ 18 296 clients = 63,30 \$ par client.
>
> Parmi les deux indicateurs proposés, les ventes par client sont les plus pertinentes pour comparer le montant moyen associé à un client. Le groupe « web » présente ici le ratio le plus élevé, alors qu’il totalise moins de clients que le groupe « magasin ».
>
> Ce montant par client ne doit pas être confondu avec un montant par transaction. Une transaction correspond à un achat; un même client peut en effectuer plusieurs. Pour calculer le montant moyen d’une transaction, il faudrait diviser les ventes par le nombre de transactions. Le fichier ne fournit pas ce nombre. De même, additionner les clients de plusieurs mois ne donne pas nécessairement un nombre de personnes distinctes sur toute la période : une personne peut revenir d’un mois à l’autre.
>
> Le rapport entre les ventes totales et le total des clients tient compte du nombre de clients de chaque ligne. Il correspond à une moyenne pondérée des ventes par client : les lignes qui comptent davantage de clients ont plus de poids. Une moyenne simple des ratios mensuels donnerait, au contraire, le même poids à toutes les lignes. Ce ne serait pas le même calcul.
>
> ### 3. Formuler un constat prudent sur la satisfaction
>
> Voici le nombre de scores mensuels utilisés pour calculer chaque moyenne :
>
> | Canal     | Lignes du groupe | Scores disponibles | Scores manquants |
> |:----------|-----------------:|-------------------:|-----------------:|
> | magasin   |               11 |                 10 |                1 |
> | téléphone |                3 |                  3 |                0 |
> | web       |               10 |                  9 |                1 |
>
> Une réponse possible est :
>
> > Parmi les scores mensuels disponibles, la satisfaction moyenne est de 8,13 sur 10 dans le groupe « téléphone », de 8,12 dans le groupe « magasin » et de 7,94 dans le groupe « web »; ces moyennes décrivent les données disponibles et reposent sur des nombres de scores différents, avec seulement trois scores pour le téléphone.
>
> La différence entre téléphone et magasin est d’environ 0,01 point sur 10. Ce seul écart ne suffit pas pour conclure que les clients sont plus satisfaits au téléphone qu’en magasin. On ne connaît pas non plus le nombre de répondants associé à chaque score mensuel. Dans le calcul présenté, chaque score disponible reçoit le même poids.
>
> ### 4. Tenir compte du contexte
>
> On peut nommer, par exemple, `region`, `surface_m2`, `campagne_locale` ou `mois`. Une campagne locale peut être associée au nombre de clients et au montant de leurs achats. Si les campagnes sont plus fréquentes dans un groupe que dans un autre, elles pourraient contribuer aux écarts observés. C’est une explication possible à examiner, et non un effet démontré par ce tableau.
>
> La définition de `canal_principal` apporte une autre limite : la ligne décrit l’ensemble d’une succursale pendant un mois et indique son canal principal. Elle ne détaille pas chaque vente par canal. Les montants du tableau sont donc ceux des observations classées dans chaque groupe; on ne peut pas attribuer toutes leurs transactions exclusivement au canal principal.
>
> ### 5. Distinguer association et causalité
>
> Observer une différence de satisfaction entre les canaux ne signifie pas que le canal est responsable de cette différence.
>
> Le tableau compare des groupes tels qu’ils apparaissent dans les données. Il ne décrit pas une expérience où l’on aurait changé uniquement le canal, toutes les autres conditions étant comparables. Les succursales, les mois, la clientèle, les campagnes et les délais peuvent aussi différer entre les groupes. Une différence de satisfaction ne démontre donc pas qu’un changement de canal produirait cette différence.

## Exercice 4 - Modèles et diagnostic de compétences

Une note de gestion contient les deux affirmations suivantes :

> Le canal ayant les ventes totales les plus élevées est nécessairement le plus efficace. Comme sa satisfaction moyenne est aussi différente, changer toutes les ventes vers ce canal améliorera la satisfaction.

Repérez au moins trois problèmes dans ce raisonnement. Réécrivez ensuite la note en quatre phrases maximum en distinguant :

- la description fournie par les données;
- le choix d’un indicateur pertinent;
- ce qui demeure inconnu;
- l’information supplémentaire nécessaire avant une décision.

> **TIP:**
>
> ### Les problèmes du raisonnement
>
> Au moins trois des problèmes suivants doivent être expliqués :
>
> 1.  Un volume de ventes élevé ne définit pas l’efficacité. Une succursale peut vendre davantage parce qu’elle a plus de clients, plus d’espace ou plus de ressources. Pour parler d’efficacité, il faut préciser le résultat visé et les ressources utilisées, par exemple les coûts ou les heures de travail.
> 2.  Les groupes ne contiennent pas le même nombre d’observations. On compte 11 lignes pour le magasin, 10 pour le web et 3 pour le téléphone. Comparer directement les ventes totales ne corrige pas ces différences de taille entre les groupes. Les ventes par client répondent mieux à une question de montant moyen, mais ne mesurent pas, à elles seules, la rentabilité.
> 3.  Une satisfaction différente ne signifie pas une satisfaction meilleure. Le groupe « web », qui a les ventes totales les plus élevées, présente ici la satisfaction moyenne la plus faible des trois groupes : 7,94 sur 10. Même une satisfaction observée plus élevée ne prouverait pas un effet bénéfique du canal.
> 4.  Une association descriptive n’est pas un effet causal. Le tableau ne permet pas de savoir ce qui arriverait aux mêmes clients si on changeait leur canal de vente. D’autres caractéristiques peuvent expliquer les écarts.
> 5.  Les scores de satisfaction ne donnent qu’une information partielle. Ce sont des moyennes mensuelles dont on ne connaît pas le nombre de répondants; de plus, 2 scores sont manquants. On ne peut donc pas reconstituer la satisfaction de l’ensemble des clients.
> 6.  Le canal principal n’est pas le canal de chaque transaction. Regrouper les succursales et les mois selon leur canal principal ne permet pas de mesurer directement ce que produirait le transfert de toutes les ventes vers un seul canal.
>
> ### Une note corrigée en quatre phrases
>
> > Dans le tableau, les observations du groupe « web » totalisent 1 158 115 \$ de ventes, mais leur satisfaction moyenne calculée à partir des scores disponibles, 7,94 sur 10, est inférieure à celle des deux autres groupes. Pour comparer le montant moyen associé à un client, nous retenons les ventes par client, soit 63,30 \$ pour le web, 58,14 \$ pour le téléphone et 57,21 \$ pour le magasin. Ces résultats ne permettent de déterminer ni le canal le plus rentable ni l’effet d’un changement de canal sur la satisfaction. Avant toute décision, il faudrait documenter les transactions par canal, les coûts, la clientèle et les réponses au questionnaire de satisfaction, puis évaluer l’effet d’un changement dans des conditions comparables, idéalement par une expérimentation appropriée.
>
> ### Vérifier la structure de la note
>
> La première phrase décrit les données. La deuxième choisit un indicateur en lien avec une question précise. La troisième indique ce qui demeure inconnu. La quatrième nomme l’information et la démarche supplémentaires nécessaires. La note précise ainsi ce qu’on observe et ce qu’il faut encore vérifier avant de décider.

## Consolidation des réponses

Choisissez une réponse parmi les exercices 2 à 4 et améliorez-la à l’aide de la liste suivante :

- l’unité et les variables sont nommées;
- l’indicateur répond à la question;
- le constat est descriptif;
- une limite précise est formulée;
- aucune conclusion causale n’est ajoutée.

> **TIP:**
>
> ### Réponse à améliorer
>
> > Le web est meilleur, car les clients y dépensent plus et ce canal permet d’augmenter les ventes.
>
> Le mot « meilleur » ne précise aucun critère. L’unité d’observation n’est pas nommée et la fin de la phrase attribue au canal un effet que le tableau ne démontre pas.
>
> ### Réponse améliorée
>
> > Dans les observations regroupées selon le canal principal de chaque succursale pour un mois donné, le groupe « web » présente des ventes par client de 63,30 \$, contre 57,21 \$ pour le groupe « magasin ». La division des ventes totales par le total des clients sert ici à comparer un montant moyen par client comptabilisé. Cette différence est descriptive : les groupes peuvent aussi différer quant à leur clientèle ou aux campagnes locales, et le fichier ne permet pas d’attribuer la différence au canal lui-même.
>
> ### Appliquer la liste de vérification
>
> | Critère | Ce que la réponse améliorée apporte |
> |----|----|
> | Unité et variables nommées | Succursale pendant un mois; canal principal, ventes et clients. |
> | Indicateur adapté | Un montant en dollars par client pour comparer les montants moyens. |
> | Constat descriptif | Une comparaison chiffrée limitée aux groupes observés. |
> | Limite précise | La clientèle et les campagnes peuvent différer entre groupes. |
> | Absence de conclusion causale | Aucun effet d’un changement de canal n’est affirmé. |
>
> Vous pouvez appliquer la même démarche à votre réponse à l’exercice 2 ou 4 : repérer une imprécision, la corriger, puis vérifier chaque critère.

## Trace finale courte

Produisez une note d’une page maximum destinée à la direction des opérations. Elle doit contenir :

- l’unité d’observation et trois variables classées correctement;
- un constat sur le délai de livraison;
- une comparaison entre ventes totales et ventes par client;
- une recommandation sur l’indicateur à surveiller;
- une limite et une question à approfondir.

La trace doit être compréhensible sans avoir vu les capsules ni leurs exemples.

> **TIP:**
>
> ### Exemple de note destinée à la direction des opérations
>
> Les données simulées décrivent quatre succursales québécoises de janvier à juin 2025, soit 24 observations. Chaque ligne représente une succursale pendant un mois. `mois` est une variable temporelle, `canal_principal` est une variable catégorielle nominale et `ventes` est une variable numérique exprimée en dollars.
>
> Parmi les 23 délais mensuels disponibles, la moyenne est de 3,30 jours et la médiane de 3,50 jours. Ces deux indicateurs situent le délai habituel entre trois et trois jours et demi. Ils donnent le même poids à chaque moyenne mensuelle par succursale, quel que soit le nombre de livraisons.
>
> Le groupe « web » totalise 1 158 115 \$ de ventes, contre 1 106 155 \$ pour le groupe « magasin ». Les ventes par client sont respectivement de 63,30 \$ et 57,21 \$; elles atteignent 58,14 \$ pour le groupe « téléphone ». Les totaux décrivent le volume d’activité, tandis que les ratios décrivent un montant moyen par client comptabilisé.
>
> Pour suivre le montant moyen associé à un client, je recommande de surveiller les ventes par client, en conservant les ventes totales comme indicateur de volume. Cette recommandation ne constitue pas un classement de rentabilité, car les coûts ne figurent pas dans le fichier.
>
> Les regroupements reposent sur le canal principal d’une succursale pendant un mois, sans détail des transactions par canal. Ils ne démontrent pas l’effet d’un changement de canal. Une question à approfondir est la suivante : l’écart de ventes par client entre les groupes demeure-t-il lorsqu’on compare des périodes et des succursales de contexte comparable?
>
> ### Pour relire votre note
>
> Vérifiez que chaque nombre correspond aux tableaux des exercices et que votre recommandation répond à une question précise. Une personne qui n’a pas suivi le cours doit pouvoir comprendre ce que représente une ligne, comment vous comparez les groupes et pourquoi vous restez prudent dans vos conclusions. Vous pouvez retenir une autre limite ou une autre question, à condition de l’expliquer à partir des données.

## Conseils de vérification

Avant de terminer, vérifiez que votre note répond à une nouvelle question de gestion et qu’elle n’utilise ni `birth_us.csv`, ni `safety_airlines.csv`.
