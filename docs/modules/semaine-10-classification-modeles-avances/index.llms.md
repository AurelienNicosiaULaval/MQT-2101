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

## Avant de commencer

Revoir une variable réponse, une régression et un résidu (module 03), la comparaison hors échantillon (module 04) et l’importation dans R (module 02). La [lecture française](../../modules/semaine-10-classification-modeles-avances/lectures.llms.md) explique les cotes, les mesures et la calibration. Installez `tidyverse`, puis téléchargez et ouvrez dans RStudio le [projet guidé](telechargements/classification-clients.zip) et le [projet de transfert](telechargements/classification-service.zip). Les deux données et leurs unités figurent dans le [dictionnaire](data/dictionnaires.md).

Dans le cas guidé, le partage stratifié est de l’ordre de 60 % pour l’apprentissage, 20 % pour la validation et 20 % pour le test. Les deux seuils et les coûts fictifs sont fixés avant la comparaison; la validation choisit la règle et le test évalue la règle retenue. Le partage aléatoire est pédagogique : le fichier ne contient pas les dates permettant une validation temporelle réelle.

## Votre parcours

Les activités 10.1 à 10.5 dans l’accueil, les capsules et les diapositives sont les mêmes productions. Réalisez chacune une seule fois dans `classification_clients.qmd`. Les exercices portent sur une décision distincte et se réalisent séparément dans `classification_service.qmd`.

Les cinq capsules correspondent aux décisions de définir la cible, estimer, lire les erreurs, choisir la règle et évaluer l’action. La calibration et la capacité restent ensemble au moment de communiquer la décision, afin de conserver un parcours cohérent.

1Définir la cible et les partitionsActivité 10.1[Capsule 1](capsules.llms.md#capsule-1)[Démo](demonstrations.llms.md)[Ex. 1](exercices.llms.md#exercice-1)Ouvrir l’étapeRéduire

Ressource [Capsule 1](capsules.llms.md#capsule-1) · [Lecture française](lectures.llms.md#lecture-1)

Activité 10.1

Définissez l’unité, la classe positive, l’horizon et le moment des prédicteurs. Séparez les clients en apprentissage, validation et test; vérifiez les effectifs et l’absence de clients communs.

Auto-vérification Je définis un départ observable dans les 90 jours. Je vérifie les identifiants et les trois partitions. Je réserve le test à la règle choisie.

Transfert distinct Faites l’exercice 1 avant d’ouvrir son corrigé.

2Estimer et interpréterActivité 10.2[Capsule 2](capsules.llms.md#capsule-2)[Démo](demonstrations.llms.md)[Ex. 2](exercices.llms.md#exercice-2)Ouvrir l’étapeRéduire

Ressource [Capsule 2](capsules.llms.md#capsule-2) · [Lecture française](lectures.llms.md#lecture-2)

Activité 10.2

Ajustez une régression logistique sur l’apprentissage. Interprétez un rapport de cotes et deux probabilités prédites sans les présenter comme une certitude ou un effet causal.

Auto-vérification Je distingue une cote d’une probabilité. Je nomme la référence et les variables maintenues fixes. Je ne prétends pas mesurer l’effet de l’intervention.

Transfert distinct Faites l’exercice 2 avant d’ouvrir son corrigé.

3Lire une matrice de confusionActivité 10.3[Capsule 3](capsules.llms.md#capsule-3)[Démo](demonstrations.llms.md)[Ex. 3](exercices.llms.md#exercice-3)Ouvrir l’étapeRéduire

Ressource [Capsule 3](capsules.llms.md#capsule-3) · [Lecture française](lectures.llms.md#lecture-3)

Activité 10.3

Sur la validation, construisez les matrices aux seuils 0,30 et 0,50. Calculez sensibilité, spécificité, précision et proportion ciblée; expliquez les deux types d’erreur.

Auto-vérification Je vérifie la classe positive. Je distingue faux positifs et faux négatifs. Les dénominateurs et les éventuelles mesures indéfinies sont explicites.

Transfert distinct Faites l’exercice 3 avant d’ouvrir son corrigé.

4Choisir une règle avant le testActivité 10.4[Capsule 4](capsules.llms.md#capsule-4)[Démo](demonstrations.llms.md)[Ex. 4](exercices.llms.md#exercice-4)Ouvrir l’étapeRéduire

Ressource [Capsule 4](capsules.llms.md#capsule-4) · [Lecture française](lectures.llms.md#lecture-4)

Activité 10.4

Sur la validation seulement, comparez les deux seuils avec un coût fictif de 4 unités par faux négatif et 1 par faux positif. Retenez le seuil au plus faible coût, avec 0,30 en cas d’égalité.

Auto-vérification Je fixe les coûts et les seuils avant la comparaison. Le test ne sert pas au choix. Je présente le coût comme une hypothèse pédagogique.

Transfert distinct Faites l’exercice 4 avant d’ouvrir son corrigé.

5Évaluer et recommanderActivité 10.5[Capsule 5](capsules.llms.md#capsule-5)[Démo](demonstrations.llms.md)[Ex. 5](exercices.llms.md#exercice-5)Ouvrir l’étapeRéduire

Ressource [Capsule 5](capsules.llms.md#capsule-5) · [Lecture française](lectures.llms.md#lecture-5)

Activité 10.5

Appliquez au test le seuil retenu, décrivez la calibration par groupes et examinez la règle alternative préétablie des 15 % de risques les plus élevés. Formulez une recommandation avec deux limites.

Auto-vérification Je sépare choix en validation et évaluation en test. Je décris la calibration sans la prouver. Je distingue risque de départ et effet d’un contact.

Transfert distinct Faites l’exercice 5 avant d’ouvrir son corrigé.

## Trace finale

Dans le rapport guidé, présentez la cible et les partitions, les probabilités et rapports de cotes, les deux matrices de validation, le choix de seuil, le test, la calibration descriptive et une recommandation avec limites. Le transfert traite du service insuffisant le mois suivant, de coûts et d’une capacité de deux interventions par mois.

## Ressources du module

- [Capsules](../../modules/semaine-10-classification-modeles-avances/capsules.llms.md), [démonstrations R](../../modules/semaine-10-classification-modeles-avances/demonstrations.llms.md), [exercices et corrigés](../../modules/semaine-10-classification-modeles-avances/exercices.llms.md) et [lectures](../../modules/semaine-10-classification-modeles-avances/lectures.llms.md).
- Notes de synthèse [HTML](notes-cours.llms.md) et [PDF](media/pdf/notes-cours.pdf).
- [Démonstration complète](telechargements/demonstration-classification.zip), [corrigé du transfert](telechargements/corrige-service.zip) et [cahier facultatif](telechargements/complements-classification.zip).
- [Compléments facultatifs en ligne](../../modules/semaine-10-classification-modeles-avances/complements.llms.md) : cotes, vraisemblance, ROC, arbre et réseaux de neurones.

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
