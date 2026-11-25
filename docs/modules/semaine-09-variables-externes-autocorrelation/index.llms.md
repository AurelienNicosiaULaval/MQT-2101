# Module 09 - Variables externes et autocorrélation

Séance autonome

## Prévoir avec une information disponible

Une promotion ou un prix peuvent aider à expliquer les ventes. Encore faut-il connaître ou scénariser ces valeurs au moment de prévoir.

Organisation

À votre rythme

Outils

R, RStudio et Quarto

Cas guidé

Ventes mensuelles fictives

Trace finale

Rapport guidé et transfert

## On passe au concret

> **NOTE:**
>
> Une direction veut prévoir ses ventes avant l’année suivante. Comment utiliser une promotion et un prix prévus sans prétendre connaître l’indice économique futur, et que faire si les erreurs se suivent?

Le module 08 a introduit tendance et calendrier; son transfert utilisait déjà ces données commerciales. Le module 09 ajoute les variables externes et le diagnostic temporel. Les 12 mois de 2025 ont déjà été examinés : ils ne sont pas un test indépendant. Les scores utilisant les valeurs externes réalisées en 2025 sont conditionnels à ces valeurs.

## Avant de commencer

Si le signe d’un résidu vous échappe, reprenez la [démonstration de régression du module 03](../../modules/semaine-03-regression-lineaire/demonstrations.llms.md). Pour les horizons et la MAE, consultez les [notes du module 06](../../modules/semaine-06-series-chronologiques-intro/notes-cours.llms.md). Le [module 08](../../modules/semaine-08-tendance-saisonnalite/index.llms.md) explique comment représenter le mois et la tendance. Les données fictives et les unités sont décrites dans le [dictionnaire](data/dictionnaires.md). Installez `tidyverse` et `forecast`, ouvrez les projets téléchargés dans RStudio et rendez les fichiers Quarto.

Téléchargez le [projet guidé](telechargements/variables-ventes.zip) et le [projet de transfert](telechargements/variables-succursales.zip). Les cinq productions 9.1 à 9.5 sont les mêmes dans cet accueil, les capsules et les diapositives : faites chacune une seule fois dans `variables_ventes.qmd`. Le transfert se réalise séparément dans `variables_succursales.qmd`.

1.  Décompressez le projet guidé. Ouvrez son fichier `variables-ventes.Rproj`, puis `variables_ventes.qmd`. Exécutez le bloc de préparation et vérifiez que l’entraînement se termine en décembre 2024.
2.  Laissez ce rapport ouvert pendant les cinq étapes. La démonstration utilise les mêmes noms d’objets. Commencez chaque activité dans votre document avant d’ouvrir son corrigé.
3.  Lorsque la carte vous renvoie aux succursales, ouvrez `variables-succursales.Rproj` dans une autre session. Une ligne y décrit une succursale pendant un mois. Les ventes de deux succursales successives dans le fichier ne forment pas une série.

## Votre parcours

Les cinq capsules suivent les cinq décisions utiles : disponibilité, régression, diagnostic, comparaison et scénario. Elles sont distinctes parce que chacune produit une interprétation différente. Les lectures et démonstrations permettent de travailler sans vidéo. Le test de Ljung-Box est un complément facultatif; pour la comparaison AR(1), utilisez les résultats et le code complet fournis : il n’est pas nécessaire de savoir construire ce modèle de mémoire.

1Auditer les variablesQue sait-on fin 2024?[Capsule 1](capsules.llms.md#capsule-1)[Démo](demonstrations.llms.md#disponibilite)[Exercice](exercices.llms.md#exercice-1)Ouvrir l’étapeRéduire

Objectif Dater une information avant de l’introduire dans une prévision.

Ressource [Capsule 1](capsules.llms.md#capsule-1) · [Lecture française](lectures.llms.md#lecture-1) · [Démonstration R](demonstrations.llms.md#disponibilite)

Action Cachez la ligne de janvier. Remplissez les colonnes « information disponible » et « justification » avant de regarder les ventes réalisées.

Activité 9.1

Classez la promotion, le prix, l’indice de confiance et les ventes futures selon leur disponibilité à la fin de 2024. Indiquez pour chacun une source connue, un scénario ou une information indisponible.

Auto-vérification Je précise l’origine. Je distingue une valeur prévue d’une valeur observée après coup. Je ne mets pas la cible future parmi les prédicteurs.

Transfert distinct Faites l’exercice 1 avant d’ouvrir son corrigé.

2Ajuster et interpréterQue représente le coefficient?[Capsule 2](capsules.llms.md#capsule-2)[Démo](demonstrations.llms.md#regression)Ouvrir l’étapeRéduire

Objectif Passer de deux moyennes observées à une comparaison entre profils identiques.

Ressource [Capsule 2](capsules.llms.md#capsule-2) · [Lecture française](lectures.llms.md#lecture-2) · [Démonstration R](demonstrations.llms.md#regression)

Action Comparez les deux moyennes de ventes, puis repérez la ligne `promotionoui` de la régression. Expliquez ce que chacune des deux comparaisons maintient fixe.

Activité 9.2

Ajustez la régression des ventes sur la tendance, le mois, la promotion, le prix et l’indice de confiance avec les 60 premiers mois. Interprétez le coefficient de promotion en dollars, à autres variables fixées, sans conclure à un effet causal.

Auto-vérification Je nomme la catégorie de référence et les unités. Je distingue association conditionnelle et causalité. Je n’utilise pas les douze mois de validation pour ajuster le modèle.

Transfert distinct Après l’activité 9.3, l’exercice 2 combine l’ajustement et le diagnostic par succursale.

3Diagnostiquer dans le tempsLes écarts se suivent-ils?[Capsule 3](capsules.llms.md#capsule-3)[Démo](demonstrations.llms.md#diagnostic)[Exercice](exercices.llms.md#exercice-2)Ouvrir l’étapeRéduire

Objectif Relier un écart daté à une barre du graphique d’autocorrélation.

Ressource [Capsule 3](capsules.llms.md#capsule-3) · [Lecture française](lectures.llms.md#lecture-3) · [Démonstration R](demonstrations.llms.md#diagnostic)

Action Calculez le résidu de juillet 2020. Repérez ce mois sur le tracé, puis construisez la paire juin-juillet avant de lire l’ACF.

Activité 9.3

Tracez les résidus de la régression en fonction du temps et leur autocorrélation. Décrivez les motifs observés et expliquez pourquoi ils ne prouvent pas à eux seuls l’indépendance des résidus.

Auto-vérification Je garde l’ordre des mois et distingue résidus et erreurs de prévision. Je décris les retards et les motifs visibles. Je sais qu’une ACF peu marquée ne prouve pas l’indépendance.

Transfert distinct Faites l’exercice 2 avant d’ouvrir son corrigé.

4Comparer deux modèlesQuel modèle prévoit le mieux?[Capsule 4](capsules.llms.md#capsule-4)[Démo](demonstrations.llms.md#comparaison)Ouvrir l’étapeRéduire

Objectif Choisir entre deux modèles pour un même usage et un même horizon.

Ressource [Capsule 4](capsules.llms.md#capsule-4) · [Lecture française](lectures.llms.md#lecture-4) · [Démonstration R](demonstrations.llms.md#comparaison)

Action Avant de lire la moyenne annuelle, comparez les erreurs absolues en janvier et en juillet. Vérifiez ce qui est commun aux deux candidats.

Activité 9.4

À partir de la démonstration fournie, comparez la régression ordinaire et la régression avec erreurs AR(1) sur les mêmes douze mois à l’aide de la MAE et de la RMSE. Indiquez que les prédicteurs de validation sont les valeurs effectivement observées.

Auto-vérification Je compare les deux modèles sur les mêmes observations et prédicteurs. J’exprime les scores en dollars. Je présente cette comparaison comme conditionnelle aux valeurs réalisées.

Transfert distinct La comparaison AR(1) est accompagnée dans cette activité. Le transfert des scénarios suit à l’étape 5.

5Communiquer un scénarioÀ quelles hypothèses tient la prévision?[Capsule 5](capsules.llms.md#capsule-5)[Démo](demonstrations.llms.md#scenario)[Exercice](exercices.llms.md#exercice-3)Ouvrir l’étapeRéduire

Objectif Écrire un message à la direction qui précise les hypothèses de janvier.

Ressource [Capsule 5](capsules.llms.md#capsule-5) · [Lecture française](lectures.llms.md#lecture-5) · [Démonstration R](demonstrations.llms.md#scenario)

Action Prévoyez janvier sous les deux promotions. Changez ensuite le prix seul et examinez si cette valeur a déjà été observée dans chaque groupe.

Activité 9.5

Pour janvier 2025, comparez les prévisions de la régression ordinaire sous promotion oui et non, à prix et indice identiques. Présentez les hypothèses, une limite causale et l’incertitude non couverte liée aux prédicteurs futurs.

Auto-vérification Je donne la cible, l’horizon et les valeurs du scénario. Je ne présente pas la différence comme un effet causal établi. Je rappelle que le scénario n’est pas nécessairement le futur réalisé.

Transfert distinct Faites l’exercice 3, puis l’exercice 4 pour rassembler votre recommandation; ouvrez les corrigés après votre tentative.

## Exercices d’application

Dans le [projet de transfert](telechargements/variables-succursales.zip), la direction de la succursale de Québec envisage d’augmenter sa capacité de 5 %. Faites les [exercices 1 à 4](../../modules/semaine-09-variables-externes-autocorrelation/exercices.llms.md#exercice-1) aux étapes indiquées, puis ouvrez les corrigés. Les [exercices 5 à 10](../../modules/semaine-09-variables-externes-autocorrelation/exercices.llms.md#pratique-supplementaire) offrent une pratique supplémentaire.

## Trace finale

Le rapport guidé contient un tableau de disponibilité, la régression et son interprétation, les diagnostics, les scores conditionnels et un scénario. Le rapport de transfert traite de succursales et d’une capacité. Il distingue les variables disponibles, les résidus par série et une hypothèse de capacité. Redémarrez R, puis rendez chacun des deux documents Quarto à partir de son propre projet.

## Lien avec l’évaluation

Ce module prépare les questions du final sur les variables externes, les diagnostics temporels et la validité d’une prévision conditionnelle. Pour la voie prévision du [mini-rapport 2](../../evaluations/mini-rapport-2.llms.md), l’emploi de variables externes est facultatif. Si vous en utilisez, précisez lesquelles étaient connues, prévues ou fixées par scénario à l’origine.

## Ressources du module

Téléchargez le [lot PDF pour tablette](telechargements/module-09-pdf-2026-11-25-annote.zip) : les cinq supports, leurs versions annotées et les notes de cours.

[CapsulesCinq capsules avec diapositives HTML, PDF originaux et PDF annotés. Chaque capsule comprend une production guidée.](capsules.llms.md) [Notes de coursSynthèse des cinq étapes en diapositives.](notes-cours.llms.md) [Démonstrations RReproduire la régression, les diagnostics et les scénarios de ventes.](demonstrations.llms.md) [Exercices et corrigésÉtudier la capacité des succursales et vérifier ses réponses après une tentative.](exercices.llms.md) [LecturesReprendre une notion en français et consulter les passages ciblés du manuel.](lectures.llms.md)

- [Notes de synthèse HTML](notes-cours.llms.md) et [PDF](media/pdf/notes-cours.pdf).
- [Démonstration complète](telechargements/demonstration-variables.zip) et [corrigé de transfert](telechargements/corrige-succursales.zip).
- [Compléments facultatifs](../../modules/semaine-09-variables-externes-autocorrelation/complements.llms.md) : retards, événements, modèle en deux étapes et repères ARIMA; [télécharger le cahier](telechargements/complements-variables.zip).

## Erreurs fréquentes

| Si vous obtenez ce résultat | Où reprendre |
|----|----|
| Vous avez inscrit 61,59 \$ comme prix connu en décembre | Vérifiez la date de disponibilité et la différence entre tarif et prix moyen dans la [lecture 1](../../modules/semaine-09-variables-externes-autocorrelation/lectures.llms.md#lecture-1). |
| Vous donnez 82 872 \$ comme coefficient de promotion | Comparez les moyennes brutes aux deux profils de la [démonstration de régression](../../modules/semaine-09-variables-externes-autocorrelation/demonstrations.llms.md#regression). |
| Vous choisissez le modèle AR(1) uniquement parce que la première barre dépasse les pointillés | Recalculez les erreurs sur les douze mois de [comparaison](../../modules/semaine-09-variables-externes-autocorrelation/demonstrations.llms.md#comparaison). |
| Vous présentez 8 721 \$ comme le rendement attendu d’un agrandissement | Vérifiez la variation de la capacité à l’intérieur de Québec dans l’[exercice 3](../../modules/semaine-09-variables-externes-autocorrelation/exercices.llms.md#exercice-3). |

## Auto-vérification

Je situe l’origine et la disponibilité de chaque prédicteur.

J’explique une association sans prétendre à la causalité.

Je lis les résidus et l’ACF dans leur ordre temporel.

Je compare les modèles sur les mêmes cibles et indique les valeurs externes utilisées.

Je nomme les hypothèses et les limites du scénario.

## Je suis bloqué·e

Commencez par la [préparation complète](../../modules/semaine-09-variables-externes-autocorrelation/demonstrations.llms.md#preparation), puis faites une activité à la fois. Pour les erreurs de code, vérifiez le répertoire du projet et les noms des colonnes. Si vos scores diffèrent, vérifiez que les [deux modèles utilisent les mêmes douze mois et les mêmes prédicteurs](../../modules/semaine-09-variables-externes-autocorrelation/demonstrations.llms.md#comparaison). Si votre scénario de capacité vous surprend, reprenez le [corrigé de l’exercice 3](../../modules/semaine-09-variables-externes-autocorrelation/exercices.llms.md#exercice-3). Pour demander de l’aide dans les canaux habituels du cours, indiquez le projet, le bloc de code et le message obtenu.
