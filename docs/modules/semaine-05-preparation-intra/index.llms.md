# Module 05

Préparation à l’examen intra

Séance de révision

## Préparation à l’examen intra

Consolider les compétences des modules 01 à 04 : lire un tableau, produire une analyse descriptive, ajuster un modèle, vérifier les diagnostics et communiquer une conclusion prudente.

Organisation

4 h 30, puis reprise ciblée

Outils

R pour préparer; pratique sans aide

Données

Données du cours et cas fictifs variés

Production

Réponses et plan de reprise

## Objectif de la préparation

L’examen intra est prévu le dimanche 25 octobre 2026. Ce module consolide les compétences des modules 01 à 04, sans ajouter les séries chronologiques du module 06. Les activités sont formatives et ne sont pas les questions du futur examen.

Cette séance ne sert pas à apprendre une nouvelle méthode. Elle sert à rendre les gestes essentiels plus fiables :

- reformuler une question d’analyse;
- identifier les variables et l’unité d’observation;
- produire un graphique utile;
- ajuster un modèle approprié;
- lire une sortie R;
- vérifier les résidus;
- distinguer description, association, prédiction et causalité;
- rédiger une conclusion courte, précise et prudente.

> **WARNING:**
>
> Les règles officielles de l’examen sont décrites dans la page [Examen intra](../../evaluations/examen-intra.llms.md). La préparation peut utiliser les ressources du cours, mais l’examen individuel en personne ne permet pas l’utilisation de l’IA.

## Prérequis

Avoir travaillé les modules 01 à 04 et les laboratoires 01 et 02, en gardant les premières réponses et la rétroaction reçue. Pour les étapes avec R, disposer d’un environnement fonctionnel et des données du cours. Retrouvez au besoin `read_csv()`, `mutate()`, `group_by()`, `summarise()`, `ggplot()`, `lm()` et `predict()` dans les modules précédents.

Si vous ne savez pas encore nommer l’unité d’observation, traiter un NA ou lire une pente, commencez par le passage correspondant de la [synthèse](../../modules/semaine-05-preparation-intra/synthese.llms.md) avant de poursuivre les questions plus complexes.

## Votre parcours

### Organisation recommandée

| Étape | Temps indicatif | Travail et résultat attendu |
|----|---:|----|
| 1\. Repérer ses besoins | 15 min | Faire une première tentative du [questionnaire formatif de régression](../../evaluations/questionnaire-regression.llms.md), sans aide; noter deux hésitations |
| 2\. Consolider | 40 min | Lire la [synthèse structurée](../../modules/semaine-05-preparation-intra/synthese.llms.md), en priorité sur les notions fragiles; expliquer chaque formule avec ses unités |
| 3\. Reproduire le raisonnement | 45 min | Exécuter les [exemples commentés avec R](../../modules/semaine-05-preparation-intra/demonstrations.llms.md); relier sortie, diagnostic et conclusion |
| 4\. S’exercer progressivement | 80 min | Faire les [huit exercices](../../modules/semaine-05-preparation-intra/exercices.llms.md), avec R et ressources; ouvrir chaque corrigé après une tentative |
| 5\. Vérifier l’autonomie | 60 min | Faire la [série de dix questions](../../modules/semaine-05-preparation-intra/pratique.llms.md), individuellement sans notes, sans exécuter R et sans IA |
| 6\. Corriger et planifier | 30 min | Expliquer les corrections avec la [grille d’autoévaluation](../../modules/semaine-05-preparation-intra/autoevaluation.llms.md); choisir deux exercices à reprendre |

Le parcours principal représente environ 4 h 30, à répartir sur plusieurs séances. Pour la reprise, faites la [série de 12 vrai ou faux et 12 choix multiples](../../modules/semaine-05-preparation-intra/questions-courtes.llms.md) : 30 minutes sans aide ni IA, puis 20 minutes de correction expliquée, idéalement deux jours après votre première série. Avec cette reprise, prévoyez environ 5 h 20 au total. Ces durées sont des estimations de travail, pas une durée d’examen. Les six supports de capsules ci-dessous sont des rappels facultatifs à consulter selon vos besoins.

La série courte entraîne à prendre position, repérer une réponse plausible mais incorrecte et justifier son choix. Les huit mini-cas entraînent à construire une analyse plus longue. Alternez ces formats en gardant une trace de vos premières réponses.

### Préparation et autonomie

La préparation avec R et les ressources sert à comprendre et vérifier les gestes. Une aide, y compris le GPT du cours selon la politique du cours, peut expliquer une erreur après une tentative; vous devez vérifier son explication. La pratique individuelle mesure ensuite votre capacité à reconstruire le raisonnement sans aide ni IA. Ces deux étapes ont des objectifs différents.

La [fiche de l’intra](../../evaluations/examen-intra.llms.md) confirme un examen individuel en personne, sans IA, accès Internet ou appareil connecté. Le matériel permis sera confirmé dans Brio. La feuille de référence et R utilisés pendant la préparation ne sont donc pas annoncés comme autorisés à l’examen.

### Rappels par compétence

> **NOTE:**
>
> La [synthèse structurée](../../modules/semaine-05-preparation-intra/synthese.llms.md) est le document principal de révision autonome. Le support compact de notes reste disponible en [HTML](../../modules/semaine-05-preparation-intra/notes-cours.llms.md) et en [PDF](media/pdf/notes-cours.pdf). Les supports détaillés sont associés aux capsules.

Les [huit exercices](../../modules/semaine-05-preparation-intra/exercices.llms.md) proposent des situations distinctes des capsules : audit de collecte, présence aux formations, préparation de kits, impression, céramique et service de bibliothèque. Les rappels ci-dessous servent à retrouver une compétence, sans imposer de refaire le scénario d’une capsule.

Revenez toujours à cette page pour garder le fil. Cliquez sur une carte pour ouvrir l’étape complète : objectif, ressource, action et activité associée.

1Lire la questionReformuler la demande avant de calculer.[Capsule 1](capsules.llms.md#capsule-1---lire-la-question-avant-de-calculer)[Ex. 1](exercices.llms.md#exercice-1---identifier-la-question)Ouvrir l'étapeRéduire

Objectif Distinguer décrire, comparer, modéliser, prédire et interpréter.

Ressource [Capsule 1](capsules.llms.md#capsule-1---lire-la-question-avant-de-calculer) [Exercice 1](exercices.llms.md#exercice-1---identifier-la-question)

Action Écrire le plan de réponse avant le code.

Activité 5.1 - Plan de réponse

Reformulez une question en une phrase et nommez la méthode prévue.

2Diagnostiquer les donnéesVérifier unité d'observation, types et valeurs manquantes.[Capsule 2](capsules.llms.md#capsule-2---préparer-les-données-et-le-diagnostic-minimal)Ouvrir l'étapeRéduire

Objectif Installer les vérifications minimales avant toute analyse.

Ressource [Capsule 2](capsules.llms.md#capsule-2---préparer-les-données-et-le-diagnostic-minimal)

Action Nommer l'unité d'observation et les variables utilisées.

Activité 5.2 - Diagnostic minimal

Écrivez une phrase qui indique l'unité d'observation, les variables et une limite.

3Répondre descriptivementProduire tableau, graphique, constat et limite.[Capsule 3](capsules.llms.md#capsule-3---répondre-à-une-question-descriptive)[Ex. 3](exercices.llms.md#exercice-3---réponse-descriptive-courte)Ouvrir l'étapeRéduire

Objectif Structurer une réponse descriptive courte et prudente.

Ressource [Capsule 3](capsules.llms.md#capsule-3---répondre-à-une-question-descriptive) [Exercice 3](exercices.llms.md#exercice-3---réponse-descriptive-courte)

Action Relier un tableau, un graphique et un constat.

Activité 5.3 - Réponse descriptive

Rédigez : méthode, résultat, constat, limite.

4Répondre avec une régressionInterpréter une pente, un ajustement et un diagnostic.[Capsule 4](capsules.llms.md#capsule-4---répondre-à-une-question-de-régression)[Démo](demonstrations.llms.md#ajuster-un-modèle)[Ex. 4](exercices.llms.md#exercice-4---interpréter-une-pente)Ouvrir l'étapeRéduire

Objectif Répondre à une question de modèle sans se limiter à la sortie R.

Ressource [Capsule 4](capsules.llms.md#capsule-4---répondre-à-une-question-de-régression) [Démonstration](demonstrations.llms.md#ajuster-un-modèle) [Exercice 4](exercices.llms.md#exercice-4---interpréter-une-pente)

Action Interpréter la pente avec unités et limite causale.

Activité 5.4 - Pente et diagnostic

Rédigez : question, pente, ajustement, diagnostic, limite, conclusion.

5Choisir entre deux modèlesJustifier un choix avec plusieurs critères.[Capsule 5](capsules.llms.md#capsule-5---choisir-entre-deux-modèles)[Ex. 5](exercices.llms.md#exercice-5---choisir-entre-deux-modèles)Ouvrir l'étapeRéduire

Objectif Comparer deux modèles sans choisir automatiquement le plus complexe.

Ressource [Capsule 5](capsules.llms.md#capsule-5---choisir-entre-deux-modèles) [Exercice 5](exercices.llms.md#exercice-5---choisir-entre-deux-modèles)

Action Préparer un argument visuel, un argument numérique et une limite.

Activité 5.5 - Choix de modèle

Justifiez un choix en utilisant graphique, erreur, résidus et interprétation.

6Finaliser la réponseRelire question, méthode, résultat, diagnostic, limite et conclusion.[Capsule 6](capsules.llms.md#capsule-6---relire-et-finaliser-une-réponse-dexamen)[Ex. 6](exercices.llms.md#exercice-6---mini-réponse-complète)Ouvrir l'étapeRéduire

Objectif Produire une réponse courte, complète et défendable.

Ressource [Capsule 6](capsules.llms.md#capsule-6---relire-et-finaliser-une-réponse-dexamen) [Exercice 6](exercices.llms.md#exercice-6---mini-réponse-complète)

Action Relire la réponse avec une checklist.

Activité 5.6 - Checklist finale

Cochez les éléments présents et corrigez ce qui manque.

## Ce qui est couvert

Module 01

### Lire un tableau

Observation, variable, type de variable, résumé descriptif et limite d'interprétation.

Module 02

### Travailler avec R

Importer, inspecter, résumer, visualiser et produire une trace reproductible.

Module 03

### Régression linéaire

Interpréter une pente, un R², des prédictions et des résidus.

Module 04

### Transformations

Reconnaître une relation courbée, comparer des modèles et éviter l'extrapolation.

## Canevas de réponse

Pour une question d’analyse, une réponse solide suit généralement cet ordre :

1.  reformuler la question en une phrase;
2.  nommer la variable réponse et les variables explicatives;
3.  justifier le graphique ou le modèle utilisé;
4.  donner le résultat principal avec les unités;
5.  mentionner un diagnostic ou une vérification;
6.  formuler une conclusion en langage d’affaires;
7.  préciser une limite.

> **TIP:**
>
> Une réponse d’examen doit être courte, mais complète. Elle doit montrer le raisonnement statistique, pas seulement recopier une sortie R.

## Ressources du module

[CapsulesSix capsules de révision avec supports HTML/PDF.](capsules.llms.md) [Synthèse structuréeNotions, formules, unités et limites des modules 01 à 04.](synthese.llms.md) [Notes de coursSynthèse globale de préparation à l'examen intra.](notes-cours.llms.md) [Démonstrations RVoir une réponse complète à partir de données déjà utilisées.](demonstrations.llms.md) [ExercicesExaminer huit mini-cas : export, ratios, graphiques, budget et modèles.](exercices.llms.md) [Vrai ou faux et choix multiples24 questions à justifier sans aide, puis corrigés et explication de chaque option.](questions-courtes.llms.md) [Pratique individuelleDix questions sans aide ni IA, puis solutions expliquées.](pratique.llms.md) [Autoévaluation et erreurs fréquentesVérifier une réponse et choisir une reprise ciblée.](autoevaluation.llms.md) [LecturesPrioriser les ressources utiles pour la révision.](lectures.llms.md)

> **WARNING:**
>
> - Commencer par le code sans avoir reformulé la question.
> - Recopier une sortie R sans l’interpréter.
> - Confondre description, association, prédiction et causalité.
> - Oublier les unités dans l’interprétation d’une pente.
> - Choisir le modèle le plus complexe seulement parce que son `R²` est plus élevé.
> - Donner une conclusion sans diagnostic ou sans limite.
> - Utiliser l’IA comme substitut à la compréhension personnelle pendant la préparation.

## Auto-vérification

Complétez la [grille détaillée](../../modules/semaine-05-preparation-intra/autoevaluation.llms.md) après les exercices et la pratique. Conservez une première réponse, sa correction expliquée et un plan de reprise : c’est la trace finale de ce module.

Avant de considérer la préparation comme terminée, je peux dire que :

Je reformule la question avant de calculer.

Je nomme les variables et l’unité d’observation.

Je choisis un graphique ou un modèle adapté.

J’interprète les résultats avec les unités.

Je mentionne un diagnostic ou une vérification.

Je distingue description, association, prédiction et causalité.

Je termine avec une limite claire.

> **NOTE:**
>
> Vous pouvez utiliser le [GPT du cours](https://chatgpt.com/g/g-6a0b2ec33d948191ad25b2f247b15de1-analyse-et-modelisation-des-donnees?ref=mini) pour vérifier votre préparation. Son rôle est de vous faire repérer ce qui manque dans une réponse, pas de produire une réponse d’examen à votre place.
>
> Suggestion de demande :
>
> > Voici une réponse de révision pour l’examen intra. Vérifie si elle contient la question reformulée, la méthode, le résultat principal, l’interprétation avec unités, un diagnostic et une limite. Pose-moi une question de suivi si ma réponse n’est pas assez claire. Ne rédige pas une nouvelle réponse complète à ma place.
>
> Après cette vérification, notez une faiblesse récurrente à surveiller pendant vos prochaines pratiques.

## Je suis bloqué·e

Avant de demander de l’aide, vérifiez dans l’ordre :

1.  ce que la question demande : décrire, comparer, modéliser, prédire ou interpréter;
2.  les variables et l’unité d’observation;
3.  le graphique minimal qui permet de voir la relation;
4.  le modèle ou le résumé statistique approprié;
5.  les unités du résultat principal;
6.  le diagnostic minimal;
7.  la limite à mentionner dans la conclusion.

## Après l’examen intra

Le bloc suivant ne repart pas de zéro. Vous conserverez les mêmes réflexes : définir une question, lire les données, choisir une représentation utile, vérifier ce qui est observable et formuler une limite. Le changement important est que le temps devient une contrainte centrale : une prévision doit être construite sans utiliser le futur.

Le [module 06 sur les séries chronologiques](../../modules/semaine-06-series-chronologiques-intro/index.llms.md) introduit le bloc suivant. L’examen intra porte sur les compétences de régression travaillées dans les modules 01 à 04. Consultez le [calendrier](../../calendrier.llms.md) pour l’ordre des séances et des évaluations.

## Pour aller plus loin

- Reprendre une question des modules 03 ou 04 et limiter volontairement la réponse à huit lignes.
- Transformer une réponse trop longue en réponse d’examen courte : question, méthode, résultat, diagnostic, limite.
- Préparer une fiche personnelle de trois erreurs à éviter pendant l’examen.
