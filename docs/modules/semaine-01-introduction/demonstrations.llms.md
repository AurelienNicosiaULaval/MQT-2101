# Démonstrations statistiques - Semaine 01

## Objectif

Ces démonstrations montrent comment lire des résultats descriptifs sans encore écrire de code. L’objectif est de comprendre ce qu’un tableau ou un graphique permet de dire, et ce qu’il ne permet pas de dire.

## Démonstration 1 - Lire la structure d’une base

Base utilisée : [birth_us.csv](../../donnees/#naissances-quotidiennes-aux-états-unis).

La première question n’est pas : quelle méthode utiliser? La première question est : que représente une ligne?

Dans cette base, une ligne correspond à une journée d’observation. Les colonnes décrivent des morceaux de date, un code de jour et un nombre quotidien de naissances.

| year | month | date_of_month | day_of_week | births |
|-----:|------:|--------------:|------------:|-------:|
| 1994 |     1 |             1 |           6 |   8096 |
| 1994 |     1 |             2 |           7 |   7772 |
| 1994 |     1 |             3 |           1 |  10142 |
| 1994 |     1 |             4 |           2 |  11248 |
| 1994 |     1 |             5 |           3 |  11053 |
| 1994 |     1 |             6 |           4 |  11406 |

Ce qu’il faut lire avant de calculer :

- `year`, `month` et `date_of_month` forment ensemble une date;
- `day_of_week` est un code, pas une quantité à moyenner;
- `births` est une variable numérique, car elle compte des naissances;
- l’unité d’observation est la journée, pas une personne ni une naissance individuelle.

Un bon réflexe consiste à écrire une phrase simple : chaque ligne décrit une journée et indique le nombre de naissances observées ce jour-là.

## Démonstration 2 - Décrire une variable numérique

Variable étudiée : `births`.

Le tableau descriptif résume une seule variable. Il ne remplace pas le graphique : il donne des repères numériques.

| Nombre de jours | Minimum | Moyenne | Médiane | Maximum |
|----------------:|--------:|--------:|--------:|--------:|
|            3652 |    6443 | 10876.8 |   11615 |   14540 |

Lecture guidée :

- le minimum et le maximum donnent l’étendue des valeurs observées;
- la moyenne donne un niveau moyen;
- la médiane donne une valeur centrale moins sensible aux journées très basses ou très hautes;
- ces nombres décrivent la base, mais n’expliquent pas les causes des variations.

![](demonstrations_files/figure-html/demo2-histogramme-1.png)

La ligne verticale indique la médiane. L’histogramme montre où les journées se concentrent et où se situent les valeurs moins fréquentes.

Constat acceptable : dans cette base, la variable `births` varie fortement selon les journées, mais la plupart des valeurs se concentrent autour d’un niveau central visible dans le tableau et l’histogramme.

## Démonstration 3 - Comparer des groupes

Comparer ne veut pas dire expliquer. Ici, on décrit comment `births` varie selon le jour de la semaine.

| jour_semaine | Nombre de jours | Moyenne | Médiane |
|:-------------|----------------:|--------:|--------:|
| lundi        |             522 | 11090.4 | 11198.0 |
| mardi        |             522 | 12349.0 | 12392.5 |
| mercredi     |             522 | 12112.7 | 12128.5 |
| jeudi        |             521 | 12069.9 | 12168.0 |
| vendredi     |             521 | 11964.8 | 12047.0 |
| samedi       |             522 |  8739.7 |  8696.5 |
| dimanche     |             522 |  7815.6 |  7780.0 |

![](demonstrations_files/figure-html/demo3-boxplot-1.png)

Lecture guidée :

- le tableau donne un résumé par groupe;
- le boxplot montre la médiane, la dispersion et les valeurs plus extrêmes;
- les fins de semaine semblent différentes des jours de semaine;
- le graphique ne permet pas, à lui seul, d’expliquer pourquoi ces écarts existent.

Constat prudent : dans cette base, les naissances observées sont généralement plus faibles le samedi et le dimanche que pendant plusieurs jours de semaine. Ce constat reste descriptif.

## Démonstration 4 - Comparer un nombre brut et un taux

Base utilisée : [safety_airlines.csv](../../donnees/#sécurité-aérienne-par-compagnie).

Un nombre brut est parfois utile, mais il peut être trompeur lorsque les unités comparées n’ont pas la même taille ou la même exposition.

Tableau classé selon le nombre brut d’incidents :

| Compagnie                   | Incidents 2000-2014 | Taux indicatif |
|:----------------------------|--------------------:|---------------:|
| Delta / Northwest\*         |                  24 |          0.005 |
| American\*                  |                  17 |          0.004 |
| United / Continental\*      |                  14 |          0.003 |
| Saudi Arabian               |                  11 |          0.016 |
| US Airways / America West\* |                  11 |          0.006 |
| Pakistan International      |                  10 |          0.037 |

Tableau classé selon un taux indicatif par milliard de sièges-kilomètres :

| Compagnie              | Incidents 2000-2014 | Taux indicatif |
|:-----------------------|--------------------:|---------------:|
| Pakistan International |                  10 |          0.037 |
| Saudi Arabian          |                  11 |          0.016 |
| Sri Lankan / AirLanka  |                   4 |          0.016 |
| Ethiopian Airlines     |                   5 |          0.013 |
| Royal Air Maroc        |                   3 |          0.013 |
| Gulf Air               |                   3 |          0.013 |

Lecture guidée :

- le premier tableau favorise les compagnies qui ont beaucoup d’activité, car elles ont plus d’occasions d’observer des incidents;
- le deuxième tableau ramène les incidents à une échelle commune;
- le taux est indicatif, car il repose sur une approximation de l’exposition;
- changer l’échelle peut changer l’ordre de comparaison.

Constat prudent : le nombre brut et le taux ne répondent pas exactement à la même question. Le nombre brut décrit un volume d’incidents; le taux cherche à comparer des compagnies sur une échelle plus comparable.

## Synthèse

Avant de choisir une méthode statistique, il faut :

- nommer l’unité d’observation;
- reconnaître le type des variables;
- choisir un indicateur adapté;
- regarder un graphique;
- écrire une limite d’interprétation.

La semaine 1 sert à consolider ce raisonnement. La programmation viendra ensuite, quand le raisonnement statistique de base sera plus clair.
