# Atelier 02

Régression appliquée à une décision d’affaires

Atelier en classe

## Régression appliquée à une décision d’affaires

Cet atelier prolonge le module 3. Vous allez utiliser la régression pour analyser la performance de succursales fictives et formuler une recommandation prudente à partir d’un modèle.

Pendant

2 h 30 à 3 h en classe

Outils

R, Quarto, régression

Données

[performance_succursales_quebec.csv](../../donnees/#performance-de-succursales-québécoises-fictives)

Production

Mini-analyse commentée

> **NOTE:**
>
> Faut-il investir davantage en marketing, ajouter du personnel ou réduire les ruptures de stock pour augmenter les ventes? La direction veut une réponse appuyée sur un modèle, pas sur une intuition. Cet atelier vous fait passer d’un nuage de points à une recommandation prudente et chiffrée.

## Avant l’atelier

Cet atelier suppose que les notions du module 3 sont assez présentes pour être réutilisées en classe. L’objectif n’est pas de tout maîtriser avant d’arriver, mais d’avoir les bons repères pour participer activement.

> **NOTE:**
>
> Avant l’atelier, relisez surtout les éléments qui permettent de passer d’une sortie R à une interprétation : variable réponse, variable explicative, pente, résidus et prudence causale.

Avant d’arriver, vérifiez que vous pouvez expliquer :

- variable réponse et variable explicative;
- nuage de points;
- pente et ordonnée à l’origine;
- résidus;
- différence entre association, prédiction et causalité.

Téléchargez ou repérez le fichier [`performance_succursales_quebec.csv`](data/performance_succursales_quebec.csv).

J’ai relu les capsules ou les notes du module 3.

Je sais ouvrir un fichier `.qmd`.

Je sais charger `tidyverse`.

Je sais ajuster un modèle avec `lm()`.

Je sais expliquer pourquoi une régression observationnelle ne prouve pas automatiquement une causalité.

> **TIP:**
>
> Si vous manquez de temps, relisez seulement la page des [capsules du module 3](../semaine-03-regression-lineaire/capsules.llms.md), puis ouvrez le [guide complet de l’atelier](guide-atelier.llms.md) avant la séance.

## Pendant l’atelier

Le guide complet est la page principale à suivre en classe. Les démonstrations et les exercices servent de soutien pendant le parcours.

[Guide](guide-atelier.llms.md)

### Guide complet de l'atelier

Suivre le déroulement en classe, étape par étape, jusqu'à la recommandation finale.

[Démo](demonstrations.llms.md)

### Démonstrations R

Voir une analyse reproductible avant de produire votre propre version.

[Pratique](exercices.llms.md)

### Exercices

Tester votre compréhension et vérifier vos interprétations.

> **IMPORTANT:**
>
> La partie la plus importante de l’atelier est le passage du modèle à la recommandation. Le code sert à produire les résultats, mais le travail principal est d’expliquer ce que les coefficients veulent dire, ce que les résidus permettent de vérifier et ce que la direction peut raisonnablement faire ensuite.

## Déroulement suggéré

0:00 - 0:25

### Question d'affaires

Identifier la variable réponse, les variables explicatives et la décision à éclairer.

0:25 - 1:05

### Exploration

Inspecter le tableau, produire les premiers graphiques et repérer les relations plausibles.

1:05 - 1:55

### Modélisation

Ajuster un modèle simple, puis un modèle enrichi, et comparer les interprétations.

1:55 - 2:35

### Diagnostic

Examiner les résidus, les points influents et les limites du modèle.

2:35 - 3:00

### Recommandation

Transformer les résultats en recommandation prudente et défendable.

Pendant l’atelier, gardez le même fichier Quarto ouvert. À la fin de chaque bloc, ajoutez directement la trace demandée : une phrase, un graphique, un tableau ou un paragraphe de recommandation.

J’ai reformulé la question d’affaires.

J’ai décrit le tableau et l’unité d’observation.

J’ai produit un graphique exploratoire.

J’ai ajusté un modèle simple.

J’ai ajusté ou interprété un modèle enrichi.

J’ai regardé les résidus.

J’ai rédigé une recommandation prudente.

## Résultat attendu

Votre mini-analyse doit inclure :

- une question d’affaires claire;
- un graphique exploratoire;
- un modèle linéaire simple;
- une interprétation de coefficient;
- un diagnostic des résidus;
- une recommandation;
- une limite importante.

> **WARNING:**
>
> La recommandation doit rester cohérente avec les données. Un modèle peut aider à prioriser une piste d’action, mais il ne remplace pas l’analyse du contexte ni la validation avec d’autres informations.

## Après l’atelier

Après la séance, le travail principal consiste à nettoyer la mini-analyse pour qu’elle soit lisible sans votre présence. Une personne qui ouvre votre fichier doit comprendre la question, les résultats et la recommandation sans chercher dans votre console R.

> **IMPORTANT:**
>
> Votre trace finale est une mini-analyse Quarto courte. Elle doit contenir un graphique, au moins un modèle, une interprétation de coefficient, un diagnostic des résidus, une recommandation et une limite.

Avant de considérer la trace terminée :

Le fichier se génère en HTML.

Les graphiques ont des titres et des axes lisibles.

Les coefficients sont interprétés avec les unités.

La recommandation ne confond pas association et causalité.

Une limite importante est mentionnée.

> **NOTE:**
>
> Vous pouvez utiliser le [GPT du cours](https://chatgpt.com/g/g-6a0b2ec33d948191ad25b2f247b15de1-analyse-et-modelisation-des-donnees?ref=mini) pour relire votre mini-analyse. Son rôle est de repérer les éléments manquants, les imprécisions statistiques et les conclusions trop fortes. Il ne doit pas rédiger la recommandation à votre place.
>
> Suggestion de demande :
>
> > Voici ma mini-analyse de l’atelier 02. Vérifie si elle contient une question claire, un graphique, un modèle, une interprétation de coefficient, un diagnostic des résidus, une recommandation et une limite. Indique les passages à corriger, sans réécrire mon texte à ma place.
>
> Après cette vérification, notez une correction apportée à votre recommandation ou à votre interprétation.

## Ressources de l’atelier

[RepèresPréparer les décisions clés avant la séance.](capsules.llms.md) [Guide completSuivre le parcours en classe jusqu'à la recommandation finale.](guide-atelier.llms.md) [Démonstrations RReproduire l'analyse pas à pas et comprendre les sorties.](demonstrations.llms.md) [ExercicesTester les gestes essentiels et préparer la trace finale.](exercices.llms.md) [LecturesRevoir les références utiles sur \`lm()\`, les prédictions et les graphiques.](lectures.llms.md)

## Je suis bloqué·e

Avant de demander de l’aide, vérifiez dans l’ordre :

1.  le chemin vers `performance_succursales_quebec.csv`;
2.  le chargement de `tidyverse`;
3.  le nom exact des variables utilisées dans le modèle;
4.  le graphique avant le modèle;
5.  la formule dans `lm()`;
6.  le graphique des résidus;
7.  la phrase de recommandation et la limite causale.

## Pour la suite

- Reprendre la recommandation en huit lignes maximum.
- Identifier une variable qui mériterait une analyse plus poussée dans le mini-rapport 1.
- Comparer le modèle enrichi de l’atelier avec les idées du module 04 sur la complexité des modèles.
