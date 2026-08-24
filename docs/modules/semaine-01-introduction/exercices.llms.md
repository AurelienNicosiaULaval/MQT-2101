# Exercices - Semaine 01

## Objectif

Ces exercices constituent un cas de transfert. Ils utilisent les données de ventes et d’opérations de succursales québécoises, et non les bases étudiées dans les capsules. Aucun code n’est attendu cette semaine.

Jeu de données de transfert : [ventes_operations_quebec.csv](../../donnees/#ventes-et-opérations-de-succursales-québécoises).

## Exercice 1 - Lire la structure d’une base

Une direction souhaite comparer la qualité du service entre les régions. Elle propose le dictionnaire incomplet suivant :

| Variable                | Type proposé | Rôle proposé              |
|-------------------------|--------------|---------------------------|
| `mois`                  | catégorie    | identifiant de succursale |
| `succursale`            | nombre       | mesure de performance     |
| `canal_principal`       | catégorie    | contexte de vente         |
| `delai_livraison_jours` | nombre       | mesure opérationnelle     |
| `satisfaction`          | nombre       | mesure de perception      |

À faire :

- corriger les deux lignes manifestement erronées;
- nommer l’unité d’observation du fichier;
- indiquer quelle variable permet de former les groupes régionaux;
- nommer une précaution concernant `satisfaction`;
- expliquer pourquoi `mois` doit conserver un sens temporel.

## Exercice 2 - Lire une analyse univariée

Voici un résumé de `delai_livraison_jours`.

| minimum | moyenne | mediane | maximum | valeurs_manquantes |
|--------:|--------:|--------:|--------:|-------------------:|
|     1.8 |     3.3 |     3.5 |     4.6 |                  1 |

![](exercices_files/figure-html/histogramme-delai-livraison-semaine-01-1.png)

Distribution des délais de livraison observés

Rédigez trois phrases :

1.  une phrase qui situe le délai habituel sans se limiter au minimum;
2.  une phrase qui décrit la forme visible de la distribution;
3.  une phrase qui explique l’effet des valeurs manquantes sur la portée du résumé.

## Exercice 3 - Comparer des groupes et des indicateurs

Une gestionnaire hésite entre deux indicateurs pour comparer les canaux de vente : les ventes totales et les ventes par client.

| canal_principal | observations | ventes_totales | clients_totaux | ventes_par_client | satisfaction_moyenne |
|:---|---:|---:|---:|---:|---:|
| magasin | 11 | 1106155 | 19335 | 57.21 | 8.12 |
| telephone | 3 | 351375 | 6044 | 58.14 | 8.13 |
| web | 10 | 1158115 | 18296 | 63.30 | 7.94 |

À faire :

- expliquer pourquoi les ventes totales et les ventes par client ne répondent pas à la même question;
- choisir l’indicateur le plus pertinent pour comparer la valeur moyenne d’une transaction client et justifier ce choix;
- formuler un constat prudent sur la satisfaction;
- nommer une variable de contexte qui pourrait modifier la comparaison;
- expliquer pourquoi le tableau ne démontre pas qu’un canal cause un niveau de satisfaction donné.

## Exercice 4 - Modèles et diagnostic de compétences

Une note de gestion contient les deux affirmations suivantes :

> Le canal ayant les ventes totales les plus élevées est nécessairement le plus efficace. Comme sa satisfaction moyenne est aussi différente, changer toutes les ventes vers ce canal améliorera la satisfaction.

Repérez au moins trois problèmes dans ce raisonnement. Réécrivez ensuite la note en quatre phrases maximum en distinguant :

- la description fournie par les données;
- le choix d’un indicateur pertinent;
- ce qui demeure inconnu;
- l’information supplémentaire nécessaire avant une décision.

## Consolidation des réponses

Choisissez une réponse parmi les exercices 2 à 4 et améliorez-la à l’aide de la liste suivante :

- l’unité et les variables sont nommées;
- l’indicateur répond à la question;
- le constat est descriptif;
- une limite précise est formulée;
- aucune conclusion causale n’est ajoutée.

## Trace finale courte

Produisez une note d’une page maximum destinée à la direction des opérations. Elle doit contenir :

- l’unité d’observation et trois variables classées correctement;
- un constat sur le délai de livraison;
- une comparaison entre ventes totales et ventes par client;
- une recommandation sur l’indicateur à surveiller;
- une limite et une question à approfondir.

La trace doit être compréhensible sans avoir vu les capsules ni leurs exemples.

## Conseils de vérification

Avant de terminer, vérifiez que votre note répond à une nouvelle question de gestion et qu’elle n’utilise ni `birth_us.csv`, ni `safety_airlines.csv`.
