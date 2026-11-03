# Laboratoire 04 - Analyse intégratrice et décision

Laboratoire en classe

## Relier une preuve à une décision

Choisir une cible, comparer une méthode à une référence et expliquer ce que les données permettent de recommander.

Séance

9 décembre, 9 h à 11 h 50

Outils

R, RStudio et Quarto

Cas

Quatre succursales fictives

Trace

Une synthèse, une voie principale

## La mission

Une direction fictive souhaite soit préparer les ventes à venir, soit repérer un risque de service insuffisant. Quelle décision peut-on soutenir avec les données et quelles limites faut-il communiquer?

> **NOTE:**
>
> Dans un seul rapport Quarto, définissez la décision et la cible, vérifiez les données, développez une voie avec une référence et des mesures adaptées, puis formulez une recommandation avec une limite et un suivi. Résumez l’autre voie en trois phrases.

Cette production se réalise une seule fois dans un rapport. Les cartes, le guide, les repères et la présentation renvoient au même travail. Les exercices de fidélisation constituent un transfert facultatif distinct.

## Deux voies possibles

- Voie A : prévoir les ventes mensuelles en dollars par succursale avec le calendrier et une référence saisonnière naïve.
- Voie B : détecter un risque de service insuffisant le mois suivant à partir des conditions du mois courant et d’une règle de ciblage.

Le choix de la voie fait partie de l’évaluation. Il doit correspondre à la décision formulée. Les modalités de remise et de rétroaction pour cette production sont à confirmer auprès de l’enseignant; le plan de cours présente les évaluations pondérées.

## Avant la séance

Le [calendrier](../../calendrier.llms.md) prévoit le mercredi 9 décembre 2026, de 9 h à 11 h 50, au pavillon Palasis-Prince, local 3213. Revoyez origine et mesures temporelles aux modules [06](../../modules/semaine-06-series-chronologiques-intro/index.llms.md) à [09](../../modules/semaine-09-variables-externes-autocorrelation/index.llms.md), puis probabilités et confusion au [module 10](../../modules/semaine-10-classification-modeles-avances/index.llms.md). Le mini-rapport 2 a été remis avant ce laboratoire : la séance prépare la synthèse et le final.

Téléchargez le projet de départ correspondant à votre voie : [voie A, ventes](telechargements/labo04-ventes.zip) ou [voie B, service](telechargements/labo04-service.zip). Décompressez-le entièrement, ouvrez le `.Rproj` puis le `.qmd`, et rendez une première fois. Installez `tidyverse` et `lubridate` au besoin. Le [dictionnaire](data/dictionnaires.md) décrit les données fictives et les hypothèses.

Les données de 2025 ont déjà été utilisées aux modules 09 et 10 : les résultats du laboratoire sont une validation réutilisée, pas un nouveau test indépendant. La voie A utilise seulement le calendrier connu; la voie B fixe un seuil à partir des scores de 2024 avant d’examiner ceux de 2025. Les valeurs et étiquettes de l’autre voie demeurent accessibles pour les trois phrases demandées.

## Votre parcours en classe

Les étapes construisent la même synthèse. Après une tentative, ouvrez l’indice ou consultez l’exemple R; prévoyez une relecture avant de terminer.

1Situer la décisionÉtape 1 du même rapport[Guide](guide-atelier.llms.md#audit)[Aide R](demonstrations.llms.md)Ouvrir l’étapeRéduire

Action Choisissez la cible, l’unité, l’origine et l’horizon de votre voie.

Après une tentative [Indice du guide](guide-atelier.llms.md#audit) · [Démonstration complète](demonstrations.llms.md)

2Vérifier les donnéesÉtape 2 du même rapport[Guide](guide-atelier.llms.md#exploration)[Aide R](demonstrations.llms.md)Ouvrir l’étapeRéduire

Action Contrôlez les dates, les clés, les valeurs manquantes et explorez la période d’apprentissage.

Après une tentative [Indice du guide](guide-atelier.llms.md#exploration) · [Démonstration complète](demonstrations.llms.md)

3Construire une référenceÉtape 3 du même rapport[Guide](guide-atelier.llms.md#modeles)[Aide R](demonstrations.llms.md)Ouvrir l’étapeRéduire

Action Ajustez votre méthode et construisez la référence propre à votre cible.

Après une tentative [Indice du guide](guide-atelier.llms.md#modeles) · [Démonstration complète](demonstrations.llms.md)

4Comparer et interpréterÉtape 4 du même rapport[Guide](guide-atelier.llms.md#comparaison)[Aide R](demonstrations.llms.md)Ouvrir l’étapeRéduire

Action Calculez les mesures adaptées sur les mêmes observations de validation réutilisée.

Après une tentative [Indice du guide](guide-atelier.llms.md#comparaison) · [Démonstration complète](demonstrations.llms.md)

5Recommander et surveillerÉtape 5 du même rapport[Guide](guide-atelier.llms.md#decision)[Aide R](demonstrations.llms.md)Ouvrir l’étapeRéduire

Action Expliquez une décision, une limite, une règle de suivi et l’autre voie en trois phrases.

Après une tentative [Indice du guide](guide-atelier.llms.md#decision) · [Démonstration complète](demonstrations.llms.md)

## Ce qui est attendu

Remettez une synthèse de deux pages maximum, en plus du code repliable. Une seule voie analytique doit être développée en profondeur. L’autre doit être résumée en trois phrases pour montrer que vous comprenez la différence de cible et de mesures. Incluez une déclaration IA, si applicable, selon la politique du cours.

La référence saisonnière A utilise 2024 pour prévoir 2025; les promotions futures ne sont pas présumées connues. Le seuil B basé sur le 80e percentile des risques de 2024 est une règle illustrative : il ne garantit pas que 20 % des occasions seront ciblées en 2025 et ne constitue pas une capacité stricte.

## Ressources

- [Guide en classe](../../modules/atelier-04-recapitulation/guide-atelier.llms.md), [repères préparatoires](../../modules/atelier-04-recapitulation/capsules.llms.md) et [présentation de lancement](presentation.llms.md), aussi en [PDF](media/pdf/presentation.pdf).
- [Démonstrations R des deux voies](../../modules/atelier-04-recapitulation/demonstrations.llms.md), [exercices de transfert](../../modules/atelier-04-recapitulation/exercices.llms.md) et [lectures](../../modules/atelier-04-recapitulation/lectures.llms.md).
- Exemples complets [voie A](telechargements/exemple-ventes.zip) et [voie B](telechargements/exemple-service.zip); [transfert de départ](telechargements/transfert-fidelisation.zip) et [corrigé](telechargements/corrige-fidelisation.zip).

Aucune vidéo ni version annotée n’est annoncée pour cette séance.

## Auto-vérification et aide

Je précise la cible, l’origine, l’horizon et l’unité.

Je compare la méthode et sa référence sur les mêmes observations.

Je distingue la validation réutilisée d’un nouveau test indépendant.

Ma recommandation cite les résultats, une limite et une règle de suivi.

Si le projet ne se rend pas, vérifiez que toute l’archive a été extraite et que `data/` est présent, puis reprenez la [préparation](../../modules/atelier-04-recapitulation/demonstrations.llms.md#preparation). Montrez votre tentative et le message complet.
