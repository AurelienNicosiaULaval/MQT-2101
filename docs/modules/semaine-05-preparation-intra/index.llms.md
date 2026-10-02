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

Le parcours principal représente environ 4 h 30, à répartir sur plusieurs séances. Pour la reprise, faites la [série de 12 vrai ou faux et 12 choix multiples](../../modules/semaine-05-preparation-intra/questions-courtes.llms.md) : 30 minutes sans aide ni IA, puis 20 minutes de correction expliquée, idéalement deux jours après votre première série. Avec cette reprise, prévoyez environ 5 h 20 au total. Ces durées sont des estimations de travail, pas une durée d’examen.

La série courte entraîne à prendre position, repérer une réponse plausible mais incorrecte et justifier son choix. Les huit mini-cas entraînent à construire une analyse plus longue. Alternez ces formats en gardant une trace de vos premières réponses.

### Préparation et autonomie

La préparation avec R et les ressources sert à comprendre et vérifier les gestes. Une aide, y compris le GPT du cours selon la politique du cours, peut expliquer une erreur après une tentative; vous devez vérifier son explication. La pratique individuelle mesure ensuite votre capacité à reconstruire le raisonnement sans aide ni IA. Ces deux étapes ont des objectifs différents.

La [fiche de l’intra](../../evaluations/examen-intra.llms.md) confirme un examen individuel en personne, sans IA, accès Internet ou appareil connecté. Le matériel permis sera confirmé dans Brio. La feuille de référence et R utilisés pendant la préparation ne sont donc pas annoncés comme autorisés à l’examen.

### Rappels par compétence

> **NOTE:**
>
> La [synthèse structurée](../../modules/semaine-05-preparation-intra/synthese.llms.md) est le document principal de révision autonome. Un support compact de révision est aussi disponible en [HTML](../../modules/semaine-05-preparation-intra/notes-cours.llms.md) et en [PDF](media/pdf/notes-cours.pdf).

Les [huit exercices](../../modules/semaine-05-preparation-intra/exercices.llms.md) proposent des situations variées : audit de collecte, présence aux formations, préparation de kits, impression, céramique et service de bibliothèque. Les repères ci-dessous permettent de retrouver directement les passages de la synthèse et les exercices utiles à votre révision.

Revenez toujours à cette page pour garder le fil. Cliquez sur une carte pour retrouver une compétence, ses ressources écrites et les éléments à vérifier dans votre réponse.

1Lire la question et les donnéesNommer la demande, les observations et les variables.[Synthèse](synthese.llms.md#donnees)[Exercice 1](exercices.llms.md#exercice-1---identifier-la-question)Ouvrir le repèreRéduire

Objectif Distinguer décrire, comparer, modéliser et prédire avant tout calcul.

Ressources [Synthèse](synthese.llms.md#donnees) [Exercice 1](exercices.llms.md#exercice-1---identifier-la-question)

À vérifier dans votre réponse

Reformulez une question en une phrase, puis nommez l'unité d'observation et une vérification de qualité.

2Choisir un résumé et un graphiqueRelier la représentation à la question et aux types de variables.[Synthèse](synthese.llms.md#graphiques)[Exercice 3](exercices.llms.md#exercice-3---réponse-descriptive-courte)Ouvrir le repèreRéduire

Objectif Justifier le graphique et le résumé retenus, avec le bon dénominateur.

Ressources [Synthèse](synthese.llms.md#graphiques) [Exercice 3](exercices.llms.md#exercice-3---réponse-descriptive-courte)

À vérifier dans votre réponse

Expliquez ce que montrent le centre, la dispersion et les observations particulières; vérifiez aussi les taux dans l'exercice 2.

3Lire une régression et prédireInterpréter la sortie R et calculer avec les bonnes unités.[Synthèse](synthese.llms.md#regression)[Exercice 4](exercices.llms.md#exercice-4---interpréter-une-pente)Ouvrir le repèreRéduire

Objectif Relier coefficients, unités, prédiction et plage observée.

Ressources [Synthèse](synthese.llms.md#regression) [Exercice 4](exercices.llms.md#exercice-4---interpréter-une-pente)

À vérifier dans votre réponse

Interprétez la pente, calculez une prédiction et indiquez si la constante a un sens dans le contexte.

4Reconnaître une forme et comparerJustifier le modèle avec la forme et l'erreur de validation.[Synthèse](synthese.llms.md#transformations)[Exercice 5](exercices.llms.md#exercice-5---choisir-entre-deux-modèles)Ouvrir le repèreRéduire

Objectif Comparer les formes enseignées sur une même cible et les mêmes observations de validation.

Ressources [Synthèse](synthese.llms.md#transformations) [Exercice 5](exercices.llms.md#exercice-5---choisir-entre-deux-modèles)

À vérifier dans votre réponse

Justifiez le choix par la forme, l'erreur, les résidus et une limite; vérifiez les transformations dans l'exercice 7.

5Lire les résidus et l’incertitudeExaminer la structure des erreurs et la cible de l'intervalle.[Synthèse](synthese.llms.md#diagnostic)[Exercice 6](exercices.llms.md#exercice-6---mini-réponse-complète)[Exercice 8](exercices.llms.md#exercice-8)Ouvrir le repèreRéduire

Objectif Repérer un diagnostic insuffisant et distinguer moyenne prédite et nouvelle observation.

Ressources [Synthèse](synthese.llms.md#diagnostic) [Exercice 6](exercices.llms.md#exercice-6---mini-réponse-complète) [Exercice 8](exercices.llms.md#exercice-8)

À vérifier dans votre réponse

Décrivez les résidus sans affirmer que le modèle est validé; expliquez pourquoi l'intervalle de prédiction est plus large.

6Construire une conclusion autonomeRédiger une réponse avec contexte, unités et limites.[Pratique individuelle](pratique.llms.md)[Autoévaluation](autoevaluation.llms.md)Ouvrir le repèreRéduire

Objectif Reconstruire le raisonnement sans aide, puis expliquer les corrections.

Ressources [Pratique individuelle](pratique.llms.md) [Autoévaluation](autoevaluation.llms.md)

À vérifier dans votre réponse

Vérifiez la présence de la question, du résultat, du diagnostic et de la limite; corrigez toute affirmation causale excessive.

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

[Synthèse structuréeNotions, formules, unités et limites des modules 01 à 04.](synthese.llms.md) [Support compact de révisionRappels pour préparer l'intra, en HTML et en PDF.](notes-cours.llms.md) [Exemples commentés avec RReconstituer le raisonnement, vérifier les calculs et interpréter les résultats.](demonstrations.llms.md) [ExercicesExaminer huit mini-cas : export, ratios, graphiques, budget et modèles.](exercices.llms.md) [Vrai ou faux et choix multiples24 questions à justifier sans aide, puis corrigés et explication de chaque option.](questions-courtes.llms.md) [Pratique individuelleDix questions sans aide ni IA, puis solutions expliquées.](pratique.llms.md) [Autoévaluation et erreurs fréquentesVérifier une réponse et choisir une reprise ciblée.](autoevaluation.llms.md) [LecturesPrioriser les ressources utiles pour la révision.](lectures.llms.md)

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
