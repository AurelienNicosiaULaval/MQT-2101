# Module 10 - Résultats binaires et classification

Séance autonome

## Transformer un risque en décision

Estimer une probabilité de départ, choisir une règle sur une validation et évaluer cette règle sur des clients distincts.

Organisation

À votre rythme

Outils

R, RStudio et Quarto

Cas guidé

Clients fictifs au Québec

Trace finale

Rapport guidé et transfert

## On passe au concret

> **NOTE:**
>
> Une organisation ne peut contacter qu’une partie de sa clientèle. Comment utiliser un risque de départ prévu, choisir qui cibler et reconnaître les erreurs sans supposer que le contact empêchera le départ?

Le module 04 étudiait une réponse continue; ici, la cible vaut 0 ou 1. La régression logistique estime une probabilité et une règle distincte la transforme en action. Les fichiers sont fictifs : ils ne prouvent pas qu’une intervention serait efficace.

## Parcours anticipé pour le mini-rapport 2

Si vous choisissez la voie classification, commencez dès le module 08, avant la proposition des données. Les prérequis sont les modules 03 et 04, R/Quarto et la validation hors échantillon. Pour préparer le choix des données et le point de contrôle de l’atelier 03, commencez par la capsule 1 et sa production : définissez une cible binaire, sa date, les prédicteurs disponibles et les partitions. Lisez ensuite les repères de la capsule 3 et les lectures 2 à 4 pour situer la probabilité, les types d’erreur, le seuil et la validation. L’activité 10.3 utilise le modèle ajusté à l’activité 10.2 : réalisez ces deux productions dans l’ordre lorsque vous poursuivrez le parcours. Poursuivez les autres capsules, productions et exercices pour terminer l’analyse et le mini-rapport; la séance du 2 décembre consolide ces acquis. Les [consignes du mini-rapport 2](../../evaluations/mini-rapport-2.llms.md) fixent les modalités; ces exemples sont un entraînement et ne remplacent pas votre analyse autonome.

### Répartir votre travail

- Au module 08 : choisissez l’événement et l’horizon, vérifiez la disponibilité des variables et proposez vos données.
- Au laboratoire 03 : présentez la séparation, les types d’erreur et une façon de choisir un seuil pour obtenir une rétroaction.
- Avant la [remise du mini-rapport 2](../../evaluations/mini-rapport-2.llms.md#échéancier-pédagogique), poursuivez les activités 10.2 à 10.5 et votre analyse autonome. Fixez la règle en validation avant d’utiliser un test distinct, si les données le permettent.
- À la séance du module 10 : consolidez les mesures et les limites en vue du final.

## Avant de commencer

Revoir une variable réponse, une régression et un résidu (module 03), la comparaison hors échantillon (module 04) et l’importation dans R (module 02). La [lecture française](../../modules/semaine-10-classification-modeles-avances/lectures.llms.md) explique les cotes, les mesures et la calibration. Installez `tidyverse`, puis téléchargez et ouvrez dans RStudio le [projet guidé](telechargements/classification-clients.zip) et le [projet de transfert](telechargements/classification-service.zip). Les deux données et leurs unités figurent dans le [dictionnaire](data/dictionnaires.md).

Dans le cas guidé, le partage stratifié est de l’ordre de 60 % pour l’apprentissage, 20 % pour la validation et 20 % pour le test. Les deux seuils et les coûts fictifs sont fixés avant la comparaison; la validation choisit la règle et le test évalue la règle retenue. Le partage aléatoire est pédagogique : le fichier ne contient pas les dates permettant une validation temporelle réelle.

Ouvrez le fichier du même nom que le dossier du projet (extension .Rproj), puis son rapport Quarto. Rendez le document une première fois après avoir exécuté sa préparation.

## Votre parcours

Les activités 10.1 à 10.5 dans l’accueil, les capsules et les diapositives sont les mêmes productions. Réalisez chacune une seule fois dans `classification_clients.qmd`. Les exercices portent sur une décision distincte et se réalisent séparément dans `classification_service.qmd`.

Les cinq capsules correspondent aux décisions de définir la cible, estimer, lire les erreurs, choisir la règle et évaluer l’action. La calibration et la capacité restent ensemble au moment de communiquer la décision, afin de conserver un parcours cohérent.

1Définir la cible et les partitionsQue savait-on avant le départ ?[Capsule 1](capsules.llms.md#capsule-1)[Démo](demonstrations.llms.md#preparation)[Ex. 1](exercices.llms.md#exercice-1)Ouvrir l’étapeRéduire

Objectif Définir l’unité, l’horizon et les trois rôles du partage.

Ressource [Capsule 1](capsules.llms.md#capsule-1) · [Lecture française](lectures.llms.md#lecture-1)

Action Repérez dans le dictionnaire une variable connue à la décision et une information qui ne sera disponible qu’après le suivi.

Activité 10.1

Définissez l’unité, la classe positive, l’horizon et le moment des prédicteurs. Séparez les clients en apprentissage, validation et test; vérifiez les effectifs et l’absence de clients communs.

Auto-vérification Je définis un départ observable dans les 90 jours. Je vérifie les identifiants et les trois partitions. Je réserve le test à la règle choisie.

Transfert distinct Faites l’[exercice 1](exercices.llms.md#exercice-1) sur le mois-succursale.

2Estimer et interpréterQue change un ticket de plus ?[Capsule 2](capsules.llms.md#capsule-2)[Démo](demonstrations.llms.md#modele)[Ex. 2](exercices.llms.md#exercice-2)Ouvrir l’étapeRéduire

Objectif Passer d’un rapport de cotes à deux risques chiffrés.

Ressource [Capsule 2](capsules.llms.md#capsule-2) · [Lecture française](lectures.llms.md#lecture-2)

Action Comparez à la main les cotes des profils à un et trois tickets, puis vérifiez leurs probabilités dans R.

Activité 10.2

Ajustez une régression logistique sur l’apprentissage. Interprétez un rapport de cotes et deux probabilités prédites sans les présenter comme une certitude ou un effet causal.

Auto-vérification Je distingue une cote d’une probabilité. Je nomme la référence et les variables maintenues fixes. Je ne prétends pas mesurer l’effet de l’intervention.

Transfert distinct Faites l’[exercice 2](exercices.llms.md#exercice-2) sur les ruptures de stock.

3Lire une matrice de confusionQui figure au dénominateur ?[Capsule 3](capsules.llms.md#capsule-3)[Démo](demonstrations.llms.md#matrices)Ouvrir l’étapeRéduire

Objectif Lire séparément les erreurs parmi les départs et parmi les clients ciblés.

Ressource [Capsule 3](capsules.llms.md#capsule-3) · [Lecture française](lectures.llms.md#lecture-3)

Action Tracez une grille de deux lignes et deux colonnes. Écrivez d’abord les totaux, puis les ratios.

Activité 10.3

Sur la validation, construisez les matrices aux seuils 0,30 et 0,50. Calculez sensibilité, spécificité, précision et proportion ciblée; expliquez les deux types d’erreur.

Auto-vérification Je vérifie la classe positive. Je distingue faux positifs et faux négatifs. Je précise les dénominateurs et les mesures éventuellement indéfinies.

Transfert distinct Conservez vos deux matrices. L’exercice 3 sur les succursales vient après la capsule 4, une fois les coûts expliqués.

4Choisir une règle avant le testCombien coûte chaque erreur ?[Capsule 4](capsules.llms.md#capsule-4)[Démo](demonstrations.llms.md#validation)[Ex. 3](exercices.llms.md#exercice-3)Ouvrir l’étapeRéduire

Objectif Choisir une règle en validation pour des coûts énoncés.

Ressource [Capsule 4](capsules.llms.md#capsule-4) · [Lecture française](lectures.llms.md#lecture-4)

Action Reprenez les quatre effectifs de chaque seuil et appliquez les mêmes coûts aux deux règles.

Activité 10.4

Sur la validation seulement, comparez les deux seuils avec un coût fictif de 4 unités par faux négatif et 1 par faux positif. Retenez le seuil au plus faible coût, avec 0,30 en cas d’égalité.

Auto-vérification Je fixe les coûts et les seuils avant la comparaison. Je n’utilise pas le test pour choisir le seuil. Je présente le coût comme une hypothèse pédagogique.

Transfert distinct Faites l’[exercice 3](exercices.llms.md#exercice-3) et fixez le seuil du transfert avant d’ouvrir son test.

5Évaluer et recommanderCombien de clients peut-on appeler ?[Capsule 5](capsules.llms.md#capsule-5)[Démo](demonstrations.llms.md#test)[Ex. 4 et 5](exercices.llms.md#exercice-4)Ouvrir l’étapeRéduire

Objectif Évaluer le choix figé et vérifier sa faisabilité.

Ressource [Capsule 5](capsules.llms.md#capsule-5) · [Lecture française](lectures.llms.md#lecture-5)

Action Confrontez le nombre de contacts, les départs détectés et les risques moyens avant de rédiger votre recommandation.

Activité 10.5

Appliquez au test le seuil retenu, décrivez la calibration par groupes et examinez la règle alternative préétablie des 15 % de risques les plus élevés. Formulez une recommandation avec deux limites.

Auto-vérification Je sépare choix en validation et évaluation en test. Je décris la calibration sans la prouver. Je distingue risque de départ et effet d’un contact.

Transfert distinct Terminez les [exercices 4 et 5](exercices.llms.md#exercice-4) sur la capacité mensuelle et la recommandation.

## Exercices d’application

Les ventes d’une succursale et les tickets d’un client ne décrivent pas la même décision. Dans le transfert, la direction dispose de deux interventions par mois pour quatre succursales. Travaillez dans le [projet des succursales](telechargements/classification-service.zip). Réalisez les exercices 1 et 2 après les capsules 1 et 2, l’exercice 3 après la capsule 4, puis les exercices 4 et 5 après la capsule 5. Ouvrez chaque corrigé après votre tentative.

## Trace finale

Dans le rapport guidé, présentez la cible et les partitions, les probabilités et rapports de cotes, les deux matrices de validation, le choix de seuil, le test, la calibration descriptive et une recommandation avec limites. Le transfert traite du service insuffisant le mois suivant, de coûts et d’une capacité de deux interventions par mois. Redémarrez R et rendez chacun des deux rapports à partir de son propre projet.

## Ressources du module

Les cinq capsules et la synthèse sont regroupées dans le [lot PDF des cinq capsules et des notes de cours](telechargements/module-10-pdf-2026-11-20-tournage.zip).

[CapsulesCinq supports PDF et HTML avec leurs activités guidées.](capsules.llms.md) [Notes de coursRetrouver les définitions et les exemples chiffrés.](notes-cours.llms.md) [Démonstrations RReproduire les probabilités et comparer deux règles de ciblage.](demonstrations.llms.md) [Exercices et corrigésChoisir des interventions dans quatre succursales et vérifier sa réponse.](exercices.llms.md) [LecturesRelire une notion en français et vérifier sa compréhension.](lectures.llms.md)

- Notes de synthèse [HTML](notes-cours.llms.md) et [PDF](media/pdf/notes-cours.pdf).
- [Démonstration complète](telechargements/demonstration-classification.zip), [corrigé du transfert](telechargements/corrige-service.zip) et [cahier facultatif](telechargements/complements-classification.zip).
- [Compléments facultatifs en ligne](../../modules/semaine-10-classification-modeles-avances/complements.llms.md) : cotes, vraisemblance, ROC, arbre et réseaux de neurones.

## Erreurs fréquentes

| Si vous obtenez ce résultat | Où reprendre |
|----|----|
| Vous annoncez une hausse de 44,3 points pour un ticket de plus | [Comparer deux profils aux autres variables fixées](../../modules/semaine-10-classification-modeles-avances/demonstrations.llms.md#modele) |
| Vous obtenez 75 % de précision au seuil de 0,30 | [Identifier la ligne des contacts et la colonne des départs](../../modules/semaine-10-classification-modeles-avances/lectures.llms.md#lecture-3) |
| Vous changez le seuil après avoir lu les résultats du test | [Refaire le choix avec la validation](../../modules/semaine-10-classification-modeles-avances/demonstrations.llms.md#validation) |
| Vous prenez les 24 meilleurs scores de l’année pour les interventions | [Appliquer la limite à chaque mois](../../modules/semaine-10-classification-modeles-avances/exercices.llms.md#exercice-4) |

## Auto-vérification

Je définis la classe positive, l’origine et l’horizon.

Je distingue cote, probabilité et décision.

Je calcule les erreurs et les mesures avec les bons dénominateurs.

Je choisis la règle en validation puis je l’évalue sur le test.

Je nomme les coûts supposés, la capacité et les limites de calibration.

Je distingue un risque prédit de l’effet d’une intervention.

## Je suis bloqué·e

Commencez par la [préparation complète](../../modules/semaine-10-classification-modeles-avances/demonstrations.llms.md#preparation), puis ajoutez les activités une par une. Vérifiez le dossier du projet, la classe positive et les noms de variables. Faites une première tentative avant les corrigés, puis utilisez les canaux habituels du cours pour demander de l’aide.

## Lien avec l’évaluation

Le module prépare la classification et l’interprétation décisionnelle du final, ainsi que la voie classification du mini-rapport 2. Les activités sont formatives.
