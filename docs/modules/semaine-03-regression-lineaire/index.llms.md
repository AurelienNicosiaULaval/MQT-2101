# Module 03

Régression linéaire et interprétation

Séance autonome

## Régression linéaire et interprétation

Comprendre, ajuster et interpréter une droite de régression dans un contexte d’affaires. Le module part d’une question simple: lorsqu’un indicateur augmente, que peut-on dire de la valeur moyenne d’un autre indicateur?

Durée estimée

2 h 30 à 3 h

Outils

R, graphiques, modèle linéaire

Données

[campagnes_marketing_quebec.csv](../../donnees/#campagnes-marketing-québécoises-fictives)

Trace finale

Interprétation d’un modèle

## On passe au concret

> **NOTE:**
>
> Une organisation observe plusieurs campagnes marketing régionales et veut savoir si les ventes moyennes augmentent lorsque le budget marketing augmente.
>
> La régression linéaire permet de résumer cette relation par une droite. Elle ne prouve pas automatiquement qu’un budget plus élevé cause des ventes plus élevées. Elle aide à quantifier une association moyenne, à vérifier si le modèle est raisonnable et à formuler une interprétation prudente.

À la fin du module, vous devriez pouvoir :

- distinguer variable réponse et variable explicative;
- lire un nuage de points avant d’ajuster un modèle;
- ajuster une régression linéaire simple avec `lm()`;
- interpréter une pente, une ordonnée à l’origine et un coefficient de détermination;
- utiliser les résidus pour vérifier si la droite résume correctement les données;
- expliquer ce que le modèle permet de dire, et ce qu’il ne permet pas de conclure.

## Votre parcours

> **NOTE:**
>
> Le support global de notes de cours est disponible en [HTML](../../modules/semaine-03-regression-lineaire/notes-cours.llms.md) et en [PDF](media/pdf/notes-cours.pdf). Il sert de synthèse du module; les supports détaillés sont associés aux capsules.

Revenez toujours à cette page pour garder le fil. Cliquez sur une carte pour ouvrir l’étape complète : objectif, ressource, action et activité associée.

1 Formuler la question Passer d'une question d'affaires à une question de régression. [Capsule 1](capsules.llms.md#capsule-1---formuler-une-question-de-régression)[Ex. 1](exercices.llms.md#exercice-1---identifier-les-variables) Ouvrir l'étapeRéduire

Objectif Identifier la variable réponse, la variable explicative et la limite causale de départ.

Ressource [Capsule 1](capsules.llms.md#capsule-1---formuler-une-question-de-régression) [Exercice 1](exercices.llms.md#exercice-1---identifier-les-variables)

Action Reformuler la question avec les mots association moyenne, ventes et budget marketing.

Activité 3.1 - Question et variables

Écrivez la question statistique, puis nommez la variable réponse, la variable explicative principale et une variable de contexte.

2 Lire le nuage de points Observer direction, forme, dispersion et points atypiques avant de modéliser. [Capsule 2](capsules.llms.md#capsule-2---lire-le-nuage-de-points)[Démo](demonstrations.llms.md#visualiser-la-relation)[Ex. 2](exercices.llms.md#exercice-2---nuage-de-points) Ouvrir l'étapeRéduire

Objectif Vérifier visuellement si une droite est un résumé plausible.

Ressource [Capsule 2](capsules.llms.md#capsule-2---lire-le-nuage-de-points) [Démonstration](demonstrations.llms.md#visualiser-la-relation) [Exercice 2](exercices.llms.md#exercice-2---nuage-de-points)

Action Produire le nuage de points et décrire la direction de l'association.

Activité 3.2 - Lecture graphique

Décrivez le graphique avec trois mots-clés : direction, dispersion, limite.

3 Comprendre la droite Relier l'équation du modèle à la pente et à l'ordonnée à l'origine. [Capsule 3](capsules.llms.md#capsule-3---comprendre-la-droite-de-régression) Ouvrir l'étapeRéduire

Objectif Comprendre ce que la pente mesure dans le contexte du module.

Ressource [Capsule 3](capsules.llms.md#capsule-3---comprendre-la-droite-de-régression)

Action Traduire l'équation en langage d'affaires.

Activité 3.3 - Pente et unités

Préparez une phrase qui explique ce que signifie une pente positive pour les ventes.

4 Ajuster le modèle dans R Utiliser lm(), lire les coefficients et transformer la sortie en phrases. [Capsule 4](capsules.llms.md#capsule-4---ajuster-le-modèle-avec-r)[Démo](demonstrations.llms.md#ajuster-le-modèle)[Ex. 3](exercices.llms.md#exercice-3---ajuster-le-modèle) Ouvrir l'étapeRéduire

Objectif Ajuster une régression linéaire simple et lire la sortie R utile.

Ressource [Capsule 4](capsules.llms.md#capsule-4---ajuster-le-modèle-avec-r) [Démonstration](demonstrations.llms.md#ajuster-le-modèle) [Exercice 3](exercices.llms.md#exercice-3---ajuster-le-modèle)

Action Exécuter \`lm(ventes ~ budget_marketing, data = campagnes)\` et repérer les coefficients.

Activité 3.4 - Lire les coefficients

Indiquez où se trouve la pente dans la sortie et ce qu'elle signifie.

5 Diagnostiquer les résidus Vérifier si les erreurs du modèle restent compatibles avec une droite. [Capsule 5](capsules.llms.md#capsule-5---diagnostiquer-avec-les-résidus)[Démo](demonstrations.llms.md#résidus-et-valeurs-ajustées)[Ex. 4](exercices.llms.md#exercice-4---examiner-les-résidus) Ouvrir l'étapeRéduire

Objectif Utiliser les résidus pour juger la crédibilité du modèle.

Ressource [Capsule 5](capsules.llms.md#capsule-5---diagnostiquer-avec-les-résidus) [Démonstration](demonstrations.llms.md#résidus-et-valeurs-ajustées) [Exercice 4](exercices.llms.md#exercice-4---examiner-les-résidus)

Action Ajouter valeurs prédites et résidus, puis produire un graphique de diagnostic.

Activité 3.5 - Résidus

Expliquez pourquoi une pente intéressante ne suffit pas sans diagnostic.

6 Conclure prudemment Rassembler graphique, pente, ajustement, limite et recommandation. [Capsule 6](capsules.llms.md#capsule-6---conclure-sans-dépasser-les-données)[Démo](demonstrations.llms.md#conclusion-prudente)[Ex. 5](exercices.llms.md#exercice-5---conclusion-courte) Ouvrir l'étapeRéduire

Objectif Produire une conclusion courte, utile et statistiquement défendable.

Ressource [Capsule 6](capsules.llms.md#capsule-6---conclure-sans-dépasser-les-données) [Démonstration](demonstrations.llms.md#conclusion-prudente) [Exercice 5](exercices.llms.md#exercice-5---conclusion-courte)

Action Rédiger une conclusion qui distingue association, prédiction et causalité.

Activité 3.6 - Conclusion finale

Rédigez quatre phrases : question, pente, diagnostic, limite.

## Avant de commencer

Téléchargez ou repérez le fichier [`campagnes_marketing_quebec.csv`](data/campagnes_marketing_quebec.csv). Chaque ligne représente une combinaison mois-région pour une campagne fictive.

Variables centrales :

- `ventes` : variable réponse;
- `budget_marketing` : variable explicative principale;
- `visites_site`, `rabais`, `region`, `canal` : variables utiles pour contextualiser;
- `satisfaction` : indicateur complémentaire à ne pas confondre avec les ventes.

## Trace finale

Votre trace finale doit tenir en quelques paragraphes. Elle doit inclure :

1.  la question d’analyse;
2.  le graphique de relation entre budget marketing et ventes;
3.  l’équation interprétée du modèle;
4.  une phrase sur la pente;
5.  une phrase sur la qualité d’ajustement ou les résidus;
6.  une limite claire sur l’interprétation causale.

> **TIP:**
>
> Une bonne conclusion ressemble à ceci : « Dans ces données, les ventes moyennes sont plus élevées lorsque le budget marketing est plus élevé. Le modèle estime l’association moyenne, mais il ne suffit pas à prouver que le budget cause l’augmentation des ventes. »

## Ressources du module

[CapsulesSix capsules courtes avec supports HTML/PDF pour construire l'intuition.](capsules.llms.md) [Notes de coursSynthèse globale du module en format RevealJS.](notes-cours.llms.md) [Démonstrations RAnalyse complète avec le fichier de campagnes marketing.](demonstrations.llms.md) [ExercicesPratiquer l'interprétation, le code et les diagnostics.](exercices.llms.md) [LecturesClarifier les notions de régression et de prudence causale.](lectures.llms.md)

> **WARNING:**
>
> - Interpréter la pente sans préciser l’unité de la variable explicative.
> - Lire une association comme une preuve de causalité.
> - Ajuster le modèle avant d’avoir regardé le nuage de points.
> - Citer seulement le `R²` sans regarder les résidus.
> - Oublier que l’ordonnée à l’origine peut être peu utile si `budget_marketing = 0` n’est pas une situation réaliste dans les données.
> - Faire une prédiction loin de la plage de budgets observés.

## Auto-vérification

Avant de passer au module suivant, je peux dire que :

J’ai formulé une question de régression sans causalité non justifiée.

J’ai identifié la variable réponse et la variable explicative.

J’ai produit et interprété un nuage de points.

J’ai ajusté un modèle avec `lm()`.

J’ai interprété la pente avec les unités.

J’ai examiné les résidus.

J’ai rédigé une conclusion prudente.

> **NOTE:**
>
> Vous pouvez utiliser le [GPT du cours](https://chatgpt.com/g/g-6a0b2ec33d948191ad25b2f247b15de1-analyse-et-modelisation-des-donnees?ref=mini) pour vérifier votre interprétation. Son rôle est de repérer les imprécisions, les oublis de diagnostic et les conclusions trop fortes. Il ne doit pas rédiger la trace finale à votre place.
>
> Suggestion de demande :
>
> > Voici ma trace finale pour le module 03. Vérifie si ma question, mon graphique, mon interprétation de la pente, mon diagnostic des résidus et ma limite causale sont clairs. Indique les éléments manquants ou imprécis, sans réécrire ma réponse à ma place.
>
> Après cette vérification, notez une correction concrète à apporter à votre interprétation.

## Je suis bloqué·e

Avant de demander de l’aide, vérifiez dans l’ordre :

1.  le chargement de `tidyverse`;
2.  le chemin vers `campagnes_marketing_quebec.csv`;
3.  le nom exact des variables `ventes` et `budget_marketing`;
4.  le nuage de points avant le modèle;
5.  le code `lm(ventes ~ budget_marketing, data = campagnes)`;
6.  le graphique des résidus;
7.  le message d’erreur complet si R bloque.

## Pour aller plus loin

- Comparer l’interprétation d’une hausse de 1 dollar et d’une hausse de 1 000 dollars de budget.
- Ajouter une variable de contexte dans le graphique, par exemple `region` ou `canal`, sans en faire une preuve causale.
- Reprendre la conclusion en distinguant clairement association, prédiction et décision.
