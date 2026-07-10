# Capsules - Module 06

## Mode d’emploi

Chaque capsule comporte un emplacement vidéo, un support écrit autonome et une activité immédiate. Les supports écrits suffisent pour réaliser le module avant l’ajout des vidéos.

## Capsule 1 - Reconnaître une série chronologique

## Vidéo

> **NOTE:**
>
> Durée cible : 6 à 8 minutes. Montrer la différence entre données transversales et données ordonnées dans le temps, puis définir date, fréquence et intervalle d’observation.

## Deck de capsule

[Ouvrir le support visuel RevealJS](media/qmd/capsule-01-support.llms.md)

## Support écrit

Une série chronologique est une suite d’observations repérées dans le temps. L’ordre est porteur d’information : la valeur de mars vient après celle de février et peut dépendre de ce qui s’est passé auparavant.

Quatre éléments doivent toujours être explicités :

- l’unité d’observation, par exemple un mois-succursale;
- la variable mesurée, par exemple les ventes mensuelles;
- la fréquence, par exemple mensuelle;
- la période couverte, par exemple janvier 2020 à décembre 2025.

Une date stockée comme texte peut être triée incorrectement. Dans R, vérifiez sa classe avec `class()` et l’ordre avec `arrange(date)`.

### Activité 6.1

Pour chacune des situations suivantes, indiquez s’il s’agit d’une série chronologique : ventes mensuelles d’une succursale; satisfaction de 400 clients interrogés une seule fois; température relevée chaque heure.

> **TIP:**
>
> Les ventes mensuelles et les températures horaires sont des séries chronologiques. Le sondage transversal ne le devient que si les mêmes mesures sont répétées à des dates comparables.

## Capsule 2 - Lire un graphique temporel

## Vidéo

> **NOTE:**
>
> Durée cible : 6 à 8 minutes. Construire un graphique temporel et identifier niveau, tendance, saisonnalité, ruptures et observations inhabituelles.

## Deck de capsule

[Ouvrir le support visuel RevealJS](media/qmd/capsule-02-support.llms.md)

## Support écrit

Le graphique temporel est le premier diagnostic. Il doit utiliser le temps sur l’axe horizontal et conserver les observations dans leur ordre réel.

Cherchez systématiquement :

- le niveau général de la série;
- une tendance persistante;
- une saisonnalité qui revient à une fréquence connue;
- des changements de variabilité;
- des valeurs inhabituelles ou des ruptures;
- des données manquantes.

Une tendance est une évolution de long terme. Une saisonnalité est un motif qui se répète selon une période connue, par exemple chaque mois de décembre. Une seule pointe en décembre ne suffit pas à conclure à une saisonnalité.

### Activité 6.2

Tracez `ventes` selon `date`. Nommez deux motifs visibles et une caractéristique qui ne peut pas être confirmée par le graphique seul.

> **TIP:**
>
> On peut décrire une tendance ou des variations récurrentes. On ne peut pas attribuer causalement une hausse à une campagne ou à une décision sans information supplémentaire et sans plan d’analyse approprié.

## Capsule 3 - Définir la cible et l’horizon

## Vidéo

> **NOTE:**
>
> Durée cible : 5 à 7 minutes. Relier la cible, l’horizon, la fréquence et la décision opérationnelle.

## Deck de capsule

[Ouvrir le support visuel RevealJS](media/qmd/capsule-03-support.llms.md)

## Support écrit

La cible est la variable future à prévoir. L’horizon est la distance entre le moment où la prévision est produite et la période visée.

Une prévision doit être formulée avant de choisir le modèle :

> À la fin de décembre 2025, prévoir les ventes mensuelles de janvier à mars 2026 afin de planifier les achats du trimestre.

Cette formulation précise le point d’origine, la cible, la fréquence, l’horizon et l’usage. Un horizon trop court ou trop long peut rendre une prévision inutile même si son erreur numérique semble faible.

### Activité 6.3

Une organisation doit commander ses stocks six semaines à l’avance. Reformulez une cible de prévision compatible avec ce délai.

> **TIP:**
>
> La formulation doit viser au moins les six prochaines semaines et préciser à quel moment la prévision est produite. « Prévoir la demande » est insuffisant sans origine, fréquence et horizon.

## Capsule 4 - Évaluer sans regarder le futur

## Vidéo

> **NOTE:**
>
> Durée cible : 7 à 9 minutes. Présenter la séparation chronologique, la méthode naïve et l’idée d’une évaluation hors échantillon.

## Deck de capsule

[Ouvrir le support visuel RevealJS](media/qmd/capsule-04-support.llms.md)

## Support écrit

Pour évaluer une prévision, on entraîne le modèle sur une première période et on réserve la période suivante pour le test. Le futur ne doit jamais influencer la préparation ou l’ajustement du modèle.

La méthode naïve utilise la dernière valeur observée comme prévision de la prochaine période. Elle est simple, mais elle constitue une référence importante : une méthode complexe qui ne la dépasse pas n’apporte pas encore de valeur démontrée.

L’erreur absolue moyenne est :

\\ \operatorname{MAE}=\frac{1}{n}\sum\_{t=1}^{n}\|y_t-\widehat{y}\_t\|. \\

Elle s’exprime dans la même unité que la cible.

### Activité 6.4

Expliquez en deux phrases pourquoi une séparation aléatoire des mois entre entraînement et test produit une évaluation irréaliste.

> **TIP:**
>
> Une séparation aléatoire peut utiliser des observations futures pour prévoir des observations passées. Elle ne reproduit donc pas la situation réelle où seules les informations disponibles au point d’origine peuvent être utilisées.
