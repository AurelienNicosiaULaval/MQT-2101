# Module 08 - Tendance et saisonnalité

Séance autonome

## Prévoir avec le temps et le calendrier

Distinguer la hausse générale des mois récurrents, puis comparer une prévision simple et communiquer son incertitude.

Organisation

À votre rythme

Outils

R, RStudio et Quarto

Cas guidé

Ventes mensuelles fictives au Québec

Trace finale

Deux rapports Quarto courts

## On passe au concret

> **NOTE:**
>
> Une direction prépare sa planification annuelle. Ses ventes augmentent, mais certains mois sont régulièrement plus forts. Comment tenir compte de ces deux structures sans présenter le budget futur comme certain?

Le module 06 a appris à lire les composantes et à respecter le temps; le module 07 a construit des niveaux lissés. Ici, la tendance et les mois deviennent des termes d’une régression. Vous apprendrez à ajuster un modèle simple, interpréter ses coefficients, examiner les résidus et le comparer à une référence sur les mêmes cibles.

## Avant de commencer

Préalables: importer un CSV et rendre un document Quarto (module 02), lire une droite, un résidu et un intervalle (modules 03 et 04), définir origine, horizon et validation temporelle (module 06). Reprenez au besoin les [lectures du module 03](../../modules/semaine-03-regression-lineaire/lectures.llms.md) et les [références temporelles du module 06](../../modules/semaine-06-series-chronologiques-intro/demonstrations.llms.md#references).

Téléchargez et décompressez le [projet guidé tendance-ventes](telechargements/tendance-ventes.zip) et le [projet de transfert tendance-commerce](telechargements/tendance-commerce.zip). Ouvrez leur `.Rproj`. Les deux CSV, dictionnaires et fonctions sont fournis. Les démonstrations reprennent la [préparation depuis une session neuve](../../modules/semaine-08-tendance-saisonnalite/demonstrations.llms.md#preparation), avec `tidyverse` et `broom`.

Les deux séries sont entièrement simulées, avec 72 mois de janvier 2020 à décembre 2025 et des ventes en dollars canadiens. Les 60 premiers mois servent à apprendre; les douze mois de 2025 servent à comparer à l’origine de décembre 2024. Les prédicteurs futurs sont le calendrier connu et un indice qui continue de 61 à 72. Les [dictionnaires](data/dictionnaires.md) expliquent les autres variables.

### Ce qu’il faut apprendre ici

Le socle porte sur cinq gestes: lire les motifs, ajuster tendance linéaire et mois, lire les résidus, comparer les prévisions et communiquer l’incertitude. Les quatre candidats sont fixés avant les scores: tendance seule, saison seule, tendance avec mois et naïf saisonnier.

Le [cahier facultatif](../../modules/semaine-08-tendance-saisonnalite/complements.llms.md) conserve les autres notions de l’ancienne séance, avec explications et code complet. Tendances quadratique et exponentielle consolident les transformations déjà vues. Décomposition détaillée, harmoniques et stationnarité sont des approfondissements; ils ne sont pas nécessaires pour terminer les deux rapports.

## Votre parcours

Les activités 8.1 à 8.5 de l’accueil, les productions autonomes des diapositives et leurs rappels sur la page des capsules désignent le même travail. Réalisez chacune une seule fois dans `tendance_ventes.qmd`. Les exercices de transfert sont distincts et se conservent dans `tendance_commerce.qmd`, après une première tentative avant le corrigé.

Les [cinq capsules principales](../../modules/semaine-08-tendance-saisonnalite/capsules.llms.md) sont disponibles en PDF et HTML. Aucune vidéo ni version annotée n’est fournie ici. La [synthèse](../../modules/semaine-08-tendance-saisonnalite/notes-cours.llms.md) est aussi disponible en [PDF](media/pdf/notes-cours.pdf). Le [lot du 26 octobre 2026](telechargements/module-08-pdf-2026-11-03.zip) contient ces six supports.

Cliquez sur une carte pour ouvrir l’objectif, les ressources et la production. Revenez ici pour garder le fil.

1Lire le temps et les motifsLa hausse vient-elle du temps ou du calendrier?[Capsule 1](capsules.llms.md#capsule-1)[Démo](demonstrations.llms.md#exploration)[Ex. 1](exercices.llms.md#exercice-1)Ouvrir l’étapeRéduire

Objectif Lire le temps et les motifs.

Ressource [Capsule 1](capsules.llms.md#capsule-1) · [Démonstration](demonstrations.llms.md#exploration) · [Lecture française](lectures.llms.md#lecture-1)

Action Ajouter cette étape au rapport guidé.

Activité 8.1

Sur les 60 mois d’apprentissage, tracez les ventes dans le temps et les profils mensuels par année. Nommez les unités, décrivez une hausse et un motif récurrent, puis expliquez ce que ces graphiques ne permettent pas d’attribuer à une cause.

Auto-vérification J’ai limité l’exploration à 2020 à 2024. Mes axes indiquent les mois et les dollars canadiens. Je distingue tendance, répétition et explication causale.

Transfert distinct Faites l’[exercice 1](exercices.llms.md#exercice-1) dans `tendance_commerce.qmd`, avant d’ouvrir son corrigé.

2Ajuster tendance et moisQue représente un coefficient de décembre?[Capsule 2](capsules.llms.md#capsule-2)[Démo](demonstrations.llms.md#calendrier)[Ex. 2](exercices.llms.md#exercice-2)Ouvrir l’étapeRéduire

Objectif Ajuster tendance et mois.

Ressource [Capsule 2](capsules.llms.md#capsule-2) · [Démonstration](demonstrations.llms.md#calendrier) · [Lecture française](lectures.llms.md#lecture-2)

Action Ajouter cette étape au rapport guidé.

Activité 8.2

Vérifiez l’indice continu et le facteur mois avec janvier comme référence. Ajustez tendance seule, saison seule et tendance avec mois. Interprétez la pente et le contraste décembre-janvier du modèle combiné, puis nommez une hypothèse de sa forme.

Auto-vérification L’indice augmente d’une unité par mois et le facteur n’est pas ordonné. Je précise janvier comme référence et les unités des coefficients. Je distingue comparaison conditionnelle et effet causal.

Transfert distinct Faites l’[exercice 2](exercices.llms.md#exercice-2) dans `tendance_commerce.qmd`, avant d’ouvrir son corrigé.

3Lire les résidusQu’est-ce que le modèle laisse encore dans la série?[Capsule 3](capsules.llms.md#capsule-3)[Démo](demonstrations.llms.md#diagnostic)[Ex. 3](exercices.llms.md#exercice-3)Ouvrir l’étapeRéduire

Objectif Lire les résidus.

Ressource [Capsule 3](capsules.llms.md#capsule-3) · [Démonstration](demonstrations.llms.md#diagnostic) · [Lecture française](lectures.llms.md#lecture-3)

Action Ajouter cette étape au rapport guidé.

Activité 8.3

Examinez les résidus du modèle combiné dans le temps et selon les valeurs ajustées. Comparez les résidus moyens par mois des trois modèles. Expliquez pourquoi une moyenne mensuelle presque nulle ne suffit pas à valider la saisonnalité future.

Auto-vérification Je distingue observation, valeur ajustée et résidu. J’examine le temps et la dispersion au-delà des moyennes. Je sais que les indicatrices imposent des sommes résiduelles mensuelles nulles.

Transfert distinct Faites l’[exercice 3](exercices.llms.md#exercice-3) dans `tendance_commerce.qmd`, avant d’ouvrir son corrigé.

4Comparer sur une validation communeLe calendrier fait-il mieux que reprendre la dernière année?[Capsule 4](capsules.llms.md#capsule-4)[Démo](demonstrations.llms.md#validation)[Ex. 4](exercices.llms.md#exercice-4)Ouvrir l’étapeRéduire

Objectif Comparer sur une validation commune.

Ressource [Capsule 4](capsules.llms.md#capsule-4) · [Démonstration](demonstrations.llms.md#validation) · [Lecture française](lectures.llms.md#lecture-4)

Action Ajouter cette étape au rapport guidé.

Activité 8.4

Construisez le calendrier de 2025 avec les indices 61 à 72. Émettez les prévisions des trois modèles et du naïf saisonnier à l’origine de fin 2024. Calculez ME, MAE et RMSE en dollars, tracez les trajectoires et justifiez un choix provisoire.

Auto-vérification Les quatre candidats utilisent les mêmes douze cibles et informations disponibles. Je n’ai utilisé ni ventes futures ni budget cible comme prédicteur. Mon choix repose sur les erreurs de validation et reste provisoire.

Transfert distinct Faites l’[exercice 4](exercices.llms.md#exercice-4) dans `tendance_commerce.qmd`, avant d’ouvrir son corrigé.

5Communiquer l’incertitude et la décisionQue peut-on annoncer sans promettre le budget futur?[Capsule 5](capsules.llms.md#capsule-5)[Démo](demonstrations.llms.md#incertitude)[Ex. 5](exercices.llms.md#exercice-5)Ouvrir l’étapeRéduire

Objectif Communiquer l’incertitude et la décision.

Ressource [Capsule 5](capsules.llms.md#capsule-5) · [Démonstration](demonstrations.llms.md#incertitude) · [Lecture française](lectures.llms.md#lecture-5)

Action Ajouter cette étape au rapport guidé.

Activité 8.5

Produisez les intervalles de prédiction du modèle combiné et comparez-les aux intervalles de confiance de la moyenne pour janvier 2025. Rédigez une recommandation avec deux scores, une interprétation du calendrier, une limite et une règle de surveillance.

Auto-vérification Je distingue moyenne conditionnelle et nouvelle observation. Je lis les intervalles comme marginaux et dépendants des hypothèses. Ma recommandation nomme les unités, une limite et une réévaluation future.

Transfert distinct Faites l’[exercice 5](exercices.llms.md#exercice-5) dans `tendance_commerce.qmd`, avant d’ouvrir son corrigé.

## Exercices d’application

Les [cinq exercices suivis](../../modules/semaine-08-tendance-saisonnalite/exercices.llms.md) portent sur des ventes fictives dans un contexte commercial changeant. Le calendrier seul doit y être interprété avec davantage de prudence; on ne recopie pas les coefficients, les scores ni la recommandation du cas guidé.

Les [huit pratiques ciblées](../../modules/semaine-08-tendance-saisonnalite/exercices.llms.md#pratique-supplementaire), facultatives, renforcent les cinq gestes principaux. Les exercices accompagnés 14 et 15 conservent l’analyse avec prix et promotions en préparation du module 09. Leur statut conditionnel est explicite et ils ne s’ajoutent pas à la trace principale.

## Trace finale

`tendance_ventes.qmd` rassemble les cinq productions, une seule fois:

1.  protocole, graphiques sur l’apprentissage et lecture des motifs;
2.  indice, facteur, trois ajustements et interprétation des coefficients;
3.  diagnostics et limites des résidus;
4.  quatre prévisions sur des cibles communes et ME, MAE, RMSE;
5.  intervalles commentés, recommandation, limite et surveillance.

`tendance_commerce.qmd` réunit les cinq exercices et la [conclusion de transfert](../../modules/semaine-08-tendance-saisonnalite/exercices.llms.md#trace-finale). Redémarrez R, puis faites Render pour chacun: aucun objet créé seulement dans la console ne doit être nécessaire.

Après votre tentative, utilisez la [démonstration complète](telechargements/demonstration-tendance-ventes.zip) et le [corrigé complet du transfert](telechargements/corrige-tendance-commerce.zip) pour vérifier la démarche. Le [projet des compléments](telechargements/complements-tendance.zip) est une ressource facultative distincte, sans nouveau rapport exigé.

## Pour préparer les évaluations et la suite

Ce module prépare la partie tendance, saisonnalité et incertitude du mini-rapport 2 et de l’examen final. Les rapports du module sont des entraînements. Les [consignes d’évaluation](../../evaluations/mini-rapport-2.llms.md) restent la référence, et le mini-rapport demande une analyse autonome.

> **NOTE:**
>
> La proposition de données est attendue à la fin de ce module. Pour la voie temporelle, utilisez les acquis des modules 06 à 08 et préparez les variables externes du module 09. Pour la voie classification, suivez dès maintenant le [parcours anticipé du module 10](../../modules/semaine-10-classification-modeles-avances/index.llms.md#parcours-anticipe), puis utilisez le point de contrôle du laboratoire 3 pour vérifier votre protocole. Les supports écrits et exemples sont déjà disponibles : cette voie ne demande pas d’attendre le 2 décembre.

## Ressources du module

[CapsulesCinq supports en PDF et HTML, avec leurs productions communes au parcours.](capsules.llms.md) [Notes de coursSynthèse du socle en diapositives HTML et PDF.](notes-cours.llms.md) [Démonstrations RAnalyse guidée complète, depuis le CSV jusqu’à la recommandation.](demonstrations.llms.md) [ExercicesCinq exercices suivis et pratiques ciblées, avec corrigés repliables.](exercices.llms.md) [LecturesExplications françaises du socle et accès au cahier facultatif.](lectures.llms.md)

## Erreurs fréquentes

- Recommencer l’indice temporel à 1 en validation.
- Confondre ordre d’affichage des mois et facteur ordonné dans le modèle.
- Interpréter un contraste comme un effet causal.
- Valider le modèle seulement avec une pente significative ou des moyennes résiduelles nulles.
- Introduire une vente, un prix ou une promotion futurs inconnus à l’origine.
- Lire les intervalles ponctuels comme une garantie pour toute l’année.

## Auto-vérification

Je distingue tendance et motif mensuel.

Je vérifie l’indice, le facteur et la référence avant l’ajustement.

Je sais lire la pente et décembre dans leurs unités.

Je regarde les résidus au-delà de leur moyenne.

Mes quatre candidats partagent origine, cibles et information disponible.

Je distingue confiance de la moyenne et prédiction d’une observation.

Mes deux recommandations utilisent leurs résultats propres et nomment une limite.

Mes rapports se rendent après redémarrage de R.

## Je suis bloqué·e

Vérifiez dans l’ordre:

1.  Le `.Rproj` est ouvert après extraction de toute l’archive, avec `R/` et `data/` présents.
2.  `tidyverse` et `broom` se chargent et `R/fonctions-module08.R` existe.
3.  Les dates sont distinctes, triées et espacées d’un mois; la cible est en dollars canadiens.
4.  L’apprentissage contient 60 mois, la validation 12 mois, avec indices futurs 61 à 72.
5.  Le facteur mois est non ordonné, avec janvier comme référence.
6.  Les blocs visibles sont exécutés dans l’ordre après la préparation commune.

Reprenez la [lecture ciblée](../../modules/semaine-08-tendance-saisonnalite/lectures.llms.md) ou la [démonstration](../../modules/semaine-08-tendance-saisonnalite/demonstrations.llms.md#preparation). Si le blocage persiste, conservez le message d’erreur complet et le court extrait concerné pour demander de l’aide. L’[aide-mémoire R](../../ressources/aide-memoire-r.llms.md) rappelle les commandes usuelles.

Les lectures, calculs et corrigés permettent de travailler sans IA. Si vous utilisez le GPT du cours après une tentative, vérifiez ses critiques et respectez les [règles d’usage](../../ressources/ia.llms.md) et la [déclaration du cours](../../ressources/declaration-ia.llms.md). Ne transmettez pas de données personnelles ou confidentielles.

## Pour aller plus loin

Le [cahier facultatif](../../modules/semaine-08-tendance-saisonnalite/complements.llms.md) garde les méthodes anciennes comme ressources, sans alourdir le socle. Les formes de tendance consolident le module 04; les harmoniques et la stationnarité sont des ouvertures. Le module 09 traite les prédicteurs commerciaux futurs et l’autocorrélation. Le laboratoire 03 intègre les acquis des modules 06 à 08 sur le cas de demande hebdomadaire connu, sans le transformer en nouveau test indépendant.
