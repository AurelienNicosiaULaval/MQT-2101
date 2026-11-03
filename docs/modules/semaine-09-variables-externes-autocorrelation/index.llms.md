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

Revoir la régression et ses résidus (module 03), l’origine et les mesures d’erreur (module 06), puis la tendance et les mois (module 08). Les données fictives et les unités sont décrites dans le [dictionnaire](data/dictionnaires.md). Installez `tidyverse` et `forecast`, ouvrez les projets téléchargés dans RStudio et rendez les fichiers Quarto.

Téléchargez le [projet guidé](telechargements/variables-ventes.zip) et le [projet de transfert](telechargements/variables-succursales.zip). Les cinq productions 9.1 à 9.5 sont les mêmes dans cet accueil, les capsules et les diapositives : faites chacune une seule fois dans `variables_ventes.qmd`. Le transfert se réalise séparément dans `variables_succursales.qmd`.

## Votre parcours

Les cinq capsules suivent les cinq décisions utiles : disponibilité, régression, diagnostic, comparaison et scénario. Elles sont distinctes parce que chacune produit une interprétation différente. Les lectures et démonstrations permettent de travailler sans vidéo. Le test de Ljung-Box est un complément facultatif; pour la comparaison AR(1), utilisez les résultats et le code complet fournis : il n’est pas nécessaire de savoir construire ce modèle de mémoire.

1Auditer les variablesActivité 9.1[Capsule 1](capsules.llms.md#capsule-1)[Démo](demonstrations.llms.md)[Exercice](exercices.llms.md#exercice-1)Ouvrir l’étapeRéduire

Ressource [Capsule 1](capsules.llms.md#capsule-1) · [Lecture française](lectures.llms.md#lecture-1)

Activité 9.1

Classez la promotion, le prix, l’indice de confiance et les ventes futures selon leur disponibilité à la fin de 2024. Indiquez pour chacun une source connue, un scénario ou une information indisponible.

Auto-vérification Je précise l’origine. Je distingue une valeur prévue d’une valeur observée après coup. Je ne mets pas la cible future parmi les prédicteurs.

Transfert distinct Faites l’exercice 1 avant d’ouvrir son corrigé.

2Ajuster et interpréterActivité 9.2[Capsule 2](capsules.llms.md#capsule-2)[Démo](demonstrations.llms.md)[Exercice](exercices.llms.md#exercice-2)Ouvrir l’étapeRéduire

Ressource [Capsule 2](capsules.llms.md#capsule-2) · [Lecture française](lectures.llms.md#lecture-2)

Activité 9.2

Ajustez la régression des ventes sur la tendance, le mois, la promotion, le prix et l’indice de confiance avec les 60 premiers mois. Interprétez le coefficient de promotion en dollars, à autres variables fixées, sans conclure à un effet causal.

Auto-vérification Je nomme la catégorie de référence et les unités. Je distingue association conditionnelle et causalité. Les douze mois de validation ne servent pas à ajuster le modèle.

Transfert distinct Faites l’exercice 2 avant d’ouvrir son corrigé.

3Diagnostiquer dans le tempsActivité 9.3[Capsule 3](capsules.llms.md#capsule-3)[Démo](demonstrations.llms.md)[Exercice](exercices.llms.md#exercice-3)Ouvrir l’étapeRéduire

Ressource [Capsule 3](capsules.llms.md#capsule-3) · [Lecture française](lectures.llms.md#lecture-3)

Activité 9.3

Tracez les résidus de la régression en fonction du temps et leur autocorrélation. Décrivez les motifs observés et expliquez pourquoi ils ne prouvent pas à eux seuls l’indépendance des résidus.

Auto-vérification Je garde l’ordre des mois et distingue résidus et erreurs de prévision. Je décris les retards et les motifs visibles. Une ACF peu marquée ne prouve pas l’indépendance.

Transfert distinct Faites l’exercice 3 avant d’ouvrir son corrigé.

4Comparer deux modèlesActivité 9.4[Capsule 4](capsules.llms.md#capsule-4)[Démo](demonstrations.llms.md)[Exercice](exercices.llms.md#exercice-4)Ouvrir l’étapeRéduire

Ressource [Capsule 4](capsules.llms.md#capsule-4) · [Lecture française](lectures.llms.md#lecture-4)

Activité 9.4

À partir de la démonstration fournie, comparez la régression ordinaire et la régression avec erreurs AR(1) sur les mêmes douze mois à l’aide de la MAE et de la RMSE. Indiquez que les prédicteurs de validation sont les valeurs effectivement observées.

Auto-vérification Les deux modèles utilisent les mêmes observations et prédicteurs. Les scores sont en dollars. Je présente cette comparaison comme conditionnelle aux valeurs réalisées.

Transfert distinct Faites l’exercice 4 avant d’ouvrir son corrigé.

5Communiquer un scénarioActivité 9.5[Capsule 5](capsules.llms.md#capsule-5)[Démo](demonstrations.llms.md)[Exercice](exercices.llms.md#exercice-4)Ouvrir l’étapeRéduire

Ressource [Capsule 5](capsules.llms.md#capsule-5) · [Lecture française](lectures.llms.md#lecture-5)

Activité 9.5

Pour janvier 2025, comparez les prévisions de la régression ordinaire sous promotion oui et non, à prix et indice identiques. Présentez les hypothèses, une limite causale et l’incertitude non couverte liée aux prédicteurs futurs.

Auto-vérification Je donne la cible, l’horizon et les valeurs du scénario. Je ne présente pas la différence comme un effet causal établi. Je rappelle que le scénario n’est pas nécessairement le futur réalisé.

Transfert distinct Faites l’exercice 4 avant d’ouvrir son corrigé.

## Trace finale

Le rapport guidé contient un tableau de disponibilité, la régression et son interprétation, les diagnostics, les scores conditionnels et un scénario. Le rapport de transfert traite de succursales et d’une capacité. Il distingue les variables disponibles, les résidus par série et une hypothèse de capacité.

## Ressources du module

- [Capsules et productions](../../modules/semaine-09-variables-externes-autocorrelation/capsules.llms.md), [démonstrations R](../../modules/semaine-09-variables-externes-autocorrelation/demonstrations.llms.md), [lectures françaises](../../modules/semaine-09-variables-externes-autocorrelation/lectures.llms.md) et [exercices avec corrigés](../../modules/semaine-09-variables-externes-autocorrelation/exercices.llms.md).
- [Notes de synthèse HTML](notes-cours.llms.md) et [PDF](media/pdf/notes-cours.pdf).
- [Démonstration complète](telechargements/demonstration-variables.zip) et [corrigé de transfert](telechargements/corrige-succursales.zip).
- [Compléments facultatifs](../../modules/semaine-09-variables-externes-autocorrelation/complements.llms.md) : retards, événements, modèle en deux étapes et repères ARIMA; [télécharger le cahier](telechargements/complements-variables.zip).

## Auto-vérification

Je situe l’origine et la disponibilité de chaque prédicteur.

J’explique une association sans prétendre à la causalité.

Je lis les résidus et l’ACF dans leur ordre temporel.

Je compare les modèles sur les mêmes cibles et indique les valeurs externes utilisées.

Je nomme les hypothèses et les limites du scénario.

## Je suis bloqué·e

Commencez par la [préparation complète](../../modules/semaine-09-variables-externes-autocorrelation/demonstrations.llms.md#preparation), puis faites une activité à la fois. Pour les erreurs de code, vérifiez le répertoire du projet et les noms des colonnes. Comparez vos tentatives aux corrigés repliables, puis demandez de l’aide dans les canaux habituels du cours.

## Lien avec l’évaluation

Ce module prépare les questions du final sur les variables externes, les diagnostics temporels et la validité d’une prévision conditionnelle. Les activités sont des entraînements.
