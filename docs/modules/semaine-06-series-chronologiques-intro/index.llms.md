# Module 06

Introduction aux séries chronologiques et à la prévision

Séance autonome

## Prévoir en respectant le temps

Définir une décision, préparer une série et comparer des prévisions avec les informations réellement disponibles à leur origine.

Organisation

À votre rythme

Outils

R, RStudio et Quarto

Données du parcours guidé

[consommation_electrique_batiment_quebec.csv](../../donnees/#consommation_electrique_batiment_quebec)

Trace finale

Deux rapports Quarto courts

## On passe au concret

> **NOTE:**
>
> Une équipe doit préparer le suivi énergétique d’un bâtiment universitaire fictif au Québec. Pour décider, elle a besoin de prévisions adaptées à ses délais, d’une référence simple et d’une indication de l’incertitude. Un bon ajustement du passé ne suffit pas.

À la fin du module, vous devriez pouvoir :

- définir la cible, les unités, la fréquence, l’origine et l’horizon d’une prévision;
- distinguer tendance, saisonnalité, cycle et variation irrégulière;
- auditer le calendrier et documenter les anomalies;
- séparer apprentissage et validation dans l’ordre temporel;
- comparer des références et interpréter ME, MAE, RMSE, MAPE et MASE;
- communiquer une prévision, son incertitude et ses limites.

Les outils des modules 1 à 4 restent utiles. Le protocole doit maintenant respecter la chronologie : préparer et ajuster avec le passé, puis comparer sur les périodes suivantes.

## Avant de commencer

Préalables : importer un CSV, lire un graphique et rendre un document Quarto (modules 1 et 2), comprendre ajustement, résidu et prédiction (modules 3 et 4).

Téléchargez et décompressez le [projet guidé `prevision-electricite`](telechargements/prevision-electricite.zip) et le [projet distinct `prevision-demande`](telechargements/prevision-demande.zip), puis ouvrez leur fichier `.Rproj`. Les CSV et les dictionnaires sont fournis. Les [démonstrations](../../modules/semaine-06-series-chronologiques-intro/demonstrations.llms.md#preparation) reprennent les étapes depuis une session neuve.

Le cas guidé contient 72 mois de consommation d’électricité d’un bâtiment universitaire fictif au Québec, de janvier 2020 à décembre 2025. Une ligne représente un mois; la cible est la consommation totale du mois, en kWh. Les données sont entièrement simulées, sans mesure d’un établissement réel. Fixez d’abord le protocole : 2020 à 2024 pour l’apprentissage, 2025 pour la validation à l’origine de décembre 2024.

Pour les cônes ETS de ce module, utilisez le code fourni et concentrez-vous sur la lecture des intervalles. L’estimation des paramètres de lissage et les diagnostics d’autocorrélation ne sont pas des préalables aux activités 6.1 à 6.6. Les fonctions R partagées sont fournies : il n’est pas demandé de les programmer depuis zéro.

## Votre parcours

Suivez les six étapes du parcours principal. Les productions autonomes des capsules et les activités 6.1 à 6.6 ci-dessous sont les mêmes tâches : faites-les une seule fois dans `prevision_electricite.qmd`. Les exercices utilisent un autre jeu de données et se font dans `prevision_demande.qmd` après chaque étape. Ouvrez leurs corrigés après une tentative.

Les [capsules et supports](../../modules/semaine-06-series-chronologiques-intro/capsules.llms.md) comprennent les onglets Vidéo, PDF, HTML et Support écrit. Les vidéos sont en attente d’enregistrement.

> **NOTE:**
>
> Le support global de notes de cours est disponible en [HTML](../../modules/semaine-06-series-chronologiques-intro/notes-cours.llms.md) et en [PDF](media/pdf/notes-cours.pdf). Il sert de synthèse du module; les supports détaillés sont associés aux capsules.

Revenez toujours à cette page pour garder le fil. Cliquez sur une carte pour ouvrir l’étape complète : objectif, ressource, action et activité associée.

1Définir une prévision utileQuelle consommation faut-il prévoir pour préparer le suivi énergétique? [Capsule 1](capsules.llms.md#capsule-1)[Démo](demonstrations.llms.md#preparation)[Ex. 1](exercices.llms.md#exercice-1) Ouvrir l’étapeRéduire

Objectif Définir une série et sa fréquence.

Ressource [Capsule 1](capsules.llms.md#capsule-1) [Démonstration](demonstrations.llms.md#preparation) [Exercice 1](exercices.llms.md#exercice-1) [Lecture ciblée](lectures.llms.md#lecture-1)

Action Formuler la décision, la cible et l’horizon avant de choisir une méthode.

Activité 6.1 - Cible et horizon

Formulez la prévision mensuelle de consommation d’électricité nécessaire pour préparer le suivi énergétique du premier trimestre 2025 à la fin de décembre 2024. Nommez le bâtiment concerné et une personne à consulter.

Exercice d’application Après cette activité, faites l’exercice 1 sur la demande hebdomadaire dans `prevision_demande.qmd`. Tentez une réponse avant d’ouvrir le corrigé.

2Lire les composantes d’une sérieLa hausse vient-elle du temps ou du calendrier? [Capsule 2](capsules.llms.md#capsule-2)[Démo](demonstrations.llms.md#composantes)[Ex. 2](exercices.llms.md#exercice-2) Ouvrir l’étapeRéduire

Objectif Lire un graphique temporel.

Ressource [Capsule 2](capsules.llms.md#capsule-2) [Démonstration](demonstrations.llms.md#composantes) [Exercice 2](exercices.llms.md#exercice-2) [Lecture ciblée](lectures.llms.md#lecture-2)

Action Produire les graphiques temporels sur l’apprentissage et décrire les motifs observés.

Activité 6.2 - Lecture des composantes

Tracez la consommation de 2020 à 2024, puis les profils par mois et année. Décrivez deux motifs. Expliquez la différence entre +20 000 kWh et +10 % et ajoutez une limite.

Exercice d’application Après cette activité, faites l’exercice 2 sur la demande hebdomadaire dans `prevision_demande.qmd`. Tentez une réponse avant d’ouvrir le corrigé.

3Préparer les données temporellesComment documenter un mois absent sans déformer le calendrier? [Capsule 3](capsules.llms.md#capsule-3)[Démo](demonstrations.llms.md#pretraitement)[Ex. 3](exercices.llms.md#exercice-3) Ouvrir l’étapeRéduire

Objectif Auditer le calendrier et les mesures.

Ressource [Capsule 3](capsules.llms.md#capsule-3) [Démonstration](demonstrations.llms.md#pretraitement) [Exercice 3](exercices.llms.md#exercice-3) [Lecture ciblée](lectures.llms.md#lecture-3)

Action Vérifier dates, périodes absentes et anomalies avant de préparer la série.

Activité 6.3 - Audit du calendrier

Auditez les dates et les valeurs manquantes sur l’apprentissage. Proposez un traitement documenté pour un mois absent, une erreur de saisie confirmée et un événement réel.

Exercice d’application Après cette activité, faites l’exercice 3 sur la demande hebdomadaire dans `prevision_demande.qmd`. Tentez une réponse avant d’ouvrir le corrigé.

4Comparer des prévisions de référenceUne méthode élaborée fait-elle mieux qu’une règle simple? [Capsule 4](capsules.llms.md#capsule-4)[Démo](demonstrations.llms.md#references)[Ex. 4](exercices.llms.md#exercice-4) Ouvrir l’étapeRéduire

Objectif Séparer apprentissage et validation.

Ressource [Capsule 4](capsules.llms.md#capsule-4) [Démonstration](demonstrations.llms.md#references) [Exercice 4](exercices.llms.md#exercice-4) [Lecture ciblée](lectures.llms.md#lecture-4)

Action Construire les références avec les données de 2020 à 2024, puis les comparer à 2025.

Activité 6.4 - Références à origine fixe

Produisez les douze prévisions naïves et saisonnières à la fin de 2024. Superposez-les à la consommation de 2025. Expliquez pourquoi une colonne lag(consommation_kwh) sur tout le fichier répond à un autre scénario.

Exercice d’application Après cette activité, faites l’exercice 4 sur la demande hebdomadaire dans `prevision_demande.qmd`. Tentez une réponse avant d’ouvrir le corrigé.

5Mesurer et lire les erreursUne erreur moyenne proche de zéro suffit-elle? [Capsule 5](capsules.llms.md#capsule-5)[Démo](demonstrations.llms.md#erreurs)[Ex. 5](exercices.llms.md#exercice-5) Ouvrir l’étapeRéduire

Objectif Calculer les cinq mesures d’erreur.

Ressource [Capsule 5](capsules.llms.md#capsule-5) [Démonstration](demonstrations.llms.md#erreurs) [Exercice 5](exercices.llms.md#exercice-5) [Lecture ciblée](lectures.llms.md#lecture-5)

Action Calculer les mesures d’erreur et examiner les écarts que leur résumé ne montre pas.

Activité 6.5 - Mesures et lecture des erreurs

Calculez ME, MAE, RMSE, MAPE et MASE des trois candidats. Interprétez les unités et le signe de ME. Comparez directement leurs MAE puis lisez le graphique et l’histogramme des erreurs.

Exercice d’application Après cette activité, faites l’exercice 5 sur la demande hebdomadaire dans `prevision_demande.qmd`. Tentez une réponse avant d’ouvrir le corrigé.

6Communiquer l’incertitudeUne seule valeur suffit-elle au suivi énergétique? [Capsule 6](capsules.llms.md#capsule-6)[Démo](demonstrations.llms.md#incertitude)[Ex. 6](exercices.llms.md#exercice-6) Ouvrir l’étapeRéduire

Objectif Distinguer point et intervalle.

Ressource [Capsule 6](capsules.llms.md#capsule-6) [Démonstration](demonstrations.llms.md#incertitude) [Exercice 6](exercices.llms.md#exercice-6) [Lecture ciblée](lectures.llms.md#lecture-6)

Action Lire le cône de prédiction fourni et expliquer ce qu’il apporte à la décision.

Activité 6.6 - Prévision et incertitude

Produisez le cône ETS(A,A,N) à l’origine de décembre 2024. Comparez les intervalles à 80 % et 95 % pour h = 1 et h = 12. Expliquez son usage et une limite.

Exercice d’application Après cette activité, faites l’exercice 6 sur la demande hebdomadaire dans `prevision_demande.qmd`. Tentez une réponse avant d’ouvrir le corrigé.

## Exercices d’application

Les [six premiers exercices](../../modules/semaine-06-series-chronologiques-intro/exercices.llms.md) se font progressivement dans le projet distinct `prevision-demande`, aux étapes indiquées ci-dessus. Ils utilisent la demande hebdomadaire et se conservent dans `prevision_demande.qmd`. Si vous les avez déjà réalisés, terminez les exercices restants et relisez vos réponses. Tentez chaque exercice avant d’ouvrir sa solution détaillée.

### Consolider après une première tentative

Les [huit exercices supplémentaires corrigés](../../modules/semaine-06-series-chronologiques-intro/exercices.llms.md#pratique-supplementaire) sont facultatifs et indépendants des deux rapports. Ils renforcent les cibles, les composantes, le calendrier, les erreurs et les intervalles avec de petits exemples fictifs. Choisissez ceux qui répondent à une difficulté, tentez une réponse, puis refaites la question sans son corrigé. Ils ne demandent pas les méthodes des modules suivants.

La page [Lectures](../../modules/semaine-06-series-chronologiques-intro/lectures.llms.md) précise les lectures ciblées et les exercices des ouvrages associés aux étapes du module.

## Trace finale

Le parcours guidé produit `prevision_electricite.qmd`. Il doit contenir :

1.  la cible, l’unité d’observation, les unités, l’origine et l’horizon;
2.  l’audit du calendrier et le traitement documenté des anomalies;
3.  les graphiques sur l’apprentissage et leur lecture;
4.  la séparation temporelle et les prévisions de référence à origine fixe;
5.  les mesures et graphiques d’erreur, avec leurs unités et limites;
6.  un cône de prédiction commenté;
7.  une conclusion avec une limite et une règle de suivi.

Les exercices produisent `prevision_demande.qmd`. La section [Trace finale](../../modules/semaine-06-series-chronologiques-intro/exercices.llms.md#trace-finale) précise comment réunir les six réponses et conclure. L’[exercice 6](../../modules/semaine-06-series-chronologiques-intro/exercices.llms.md#exercice-6) porte sur les erreurs et l’incertitude.

Les calculs complets figurent dans la [démonstration téléchargeable](telechargements/demonstration-electricite.zip). Les [exercices et corrigés](../../modules/semaine-06-series-chronologiques-intro/exercices.llms.md) permettent le transfert. Dans RStudio, choisissez Session \> Restart R, puis Render pour vérifier chacun des deux documents : aucun objet créé seulement dans la console ne doit être nécessaire.

## Pour préparer les évaluations

Ce module prépare le mini-rapport 2 et l’examen final. L’intra porte sur les modules 1 à 4 : les séries chronologiques n’y sont pas évaluées. Les rapports de ce module sont des entraînements; les règles des travaux évalués sont dans [Évaluations](../../evaluations/index.llms.md).

Le cas de demande hebdomadaire sera repris au module 7 et au laboratoire 3 pour ajouter des méthodes et analyser le coût des erreurs. Il s’agit d’une progression sur un cas connu; les rapports et corrigés de ce module sont des entraînements, et le mini-rapport 2 exige une analyse autonome. Consultez ses [consignes](../../evaluations/mini-rapport-2.llms.md) et la [procédure de validation des données](../../evaluations/validation-donnees.llms.md).

## Ressources du module

[CapsulesSix capsules, deux compléments facultatifs et leurs supports écrits, PDF et HTML. Vidéos à venir.](capsules.llms.md) [Notes de coursSynthèse du module en diapositives HTML et PDF.](notes-cours.llms.md) [Démonstrations RAnalyse complète de la consommation mensuelle d’électricité, avec code copiable et projet téléchargeable.](demonstrations.llms.md) [Exercices et solutions détailléesSix exercices suivis sur la demande hebdomadaire, deux compléments et huit exercices supplémentaires, avec corrigés repliables.](exercices.llms.md) [LecturesLectures ciblées par étape, références et exercices des ouvrages.](lectures.llms.md)

> **WARNING:**
>
> - Évaluer un modèle sur les mêmes observations qui ont servi à l’ajuster.
> - Fournir au modèle une valeur qui n’était pas disponible à l’origine.
> - Comprimer le calendrier en supprimant une période absente.
> - Confondre erreur moyenne nulle et erreurs petites.
> - Calculer le MAPE en retirant les zéros sans expliquer le changement de comparaison.
> - Lire MASE inférieur à 1 comme une victoire automatique sur la référence de validation.
> - Présenter un intervalle à 95 % comme une garantie pour toute la trajectoire.

## Auto-vérification

Avant de passer au module suivant, je peux dire que :

Je distingue fréquence, granularité, origine, cible et horizon.

Le calendrier est vérifié avant le modèle et les anomalies sont documentées.

Je distingue tendance, saisonnalité, cycle et variation irrégulière.

Les prévisions comparées partagent les mêmes dates et informations disponibles.

Je sais lire ME, MAE, RMSE, MAPE et MASE avec leurs limites.

Je distingue résidu, erreur de prévision et intervalle de prédiction.

Je distingue une comparaison à origine fixe de la réévaluation à de nouvelles origines.

Mon choix reste provisoire et prévoit une réévaluation.

> **NOTE:**
>
> Vous pouvez utiliser le GPT du cours pour faire critiquer votre définition de la cible et de l’horizon. Demandez-lui de relever une ambiguïté sans proposer la formulation finale. Vérifiez ensuite la réponse à l’aide des données et des notes de cours.

Vous pouvez aussi vérifier votre trace sans IA : utilisez la liste ci-dessus, les résultats de vos calculs et les corrigés après votre tentative, puis notez une correction à apporter à votre raisonnement. Aucun compte externe ni outil payant n’est nécessaire. Si vous utilisez le [GPT du cours](https://chatgpt.com/g/g-6a0b2ec33d948191ad25b2f247b15de1-analyse-et-modelisation-des-donnees?ref=mini), ne transmettez pas de données personnelles ou confidentielles et appliquez les [règles du cours](../../ressources/ia.llms.md) et la [déclaration d’usage](../../ressources/declaration-ia.llms.md).

## Je suis bloqué·e

Vérifiez dans l’ordre :

1.  Le projet `.Rproj` est ouvert après avoir décompressé toute l’archive; les dossiers `data/` et `R/` sont présents.
2.  `tidyverse` et `forecast` se chargent et `R/analyse-module06.R` est disponible.
3.  Les dates sont triées, distinctes et espacées d’un mois ou d’une semaine selon le fichier; les unités correspondent à la cible.
4.  La séparation est identique à celle des consignes : 60 mois puis 12 mois pour la consommation d’électricité; 91 semaines puis 13 semaines pour la demande.
5.  La prévision utilise seulement les données disponibles à l’origine. Les observations de validation servent ensuite à calculer les erreurs.
6.  Vous avez relancé la [préparation des démonstrations](../../modules/semaine-06-series-chronologiques-intro/demonstrations.llms.md#preparation) depuis une session R redémarrée. Si R bloque encore, conservez le message d’erreur complet et le petit morceau de code concerné.

Pour retrouver une commande, utilisez l’[aide-mémoire R](../../ressources/aide-memoire-r.llms.md). La [feuille de référence du cours](../../ressources/feuille-reference.llms.md#prevision) rappelle cible, origine, horizon et mesures. Dans les comparaisons de ce module, les données réservées servent à choisir une méthode : nous les appelons validation.

## Pour aller plus loin

### Compléments facultatifs

Après les six capsules, vous pouvez approfondir deux questions avec les supports écrits et visuels :

- [Validation à plusieurs origines](../../modules/semaine-06-series-chronologiques-intro/capsules.llms.md#capsule-7) : fixer l’horizon, faire avancer l’origine et comparer les fenêtres. La pratique 6.7 et l’exercice 7 sont facultatifs.
- [Familles et combinaisons de méthodes](../../modules/semaine-06-series-chronologiques-intro/capsules.llms.md#capsule-8) : structure, mémoire, variables externes, automatisation et complémentarité des erreurs. La pratique 6.8 et l’exercice 8 sont facultatifs.

Ces compléments ne sont pas nécessaires pour terminer les deux rapports d’entraînement du module. Les modules 7 à 9 approfondissent ensuite les méthodes de lissage, la régression saisonnière et les variables externes. Les fonctions des exemples sont fournies.

### Passage au bloc de prévision

Les modules 1 à 4 ont développé la lecture des données, la régression et les diagnostics. Ces outils restent utiles, mais le protocole doit maintenant reproduire la chronologie : préparer et ajuster avec le passé, puis comparer sur les périodes suivantes.

Ce module installe le cadre commun de la prévision. Les notions de tendance, de saisonnalité, d’incertitude et de familles de méthodes seront reprises avec de nouvelles opérations dans les modules suivants.

| Étape | Ce que vous apprenez à faire |
|----|----|
| Module 6 | Définir la décision, auditer la série, construire les références, mesurer les erreurs et respecter le temps dans la validation. |
| [Module 7](../semaine-07-lissage/index.llms.md) | Calculer les moyennes mobiles, comprendre le lissage simple et découvrir le prolongement accompagné de Holt. |
| [Module 8](../semaine-08-tendance-saisonnalite/index.llms.md) | Ajuster et interpréter une régression avec tendance et effets du mois. |
| [Laboratoire 3](../atelier-03-series-chronologiques/index.llms.md) | Intégrer les méthodes des modules 6 à 8 et traduire les erreurs en décision de stock. |
| [Module 9](../semaine-09-variables-externes-autocorrelation/index.llms.md) | Ajouter des variables externes disponibles et diagnostiquer la dépendance temporelle des résidus. |
| [Module 10](../semaine-10-classification-modeles-avances/index.llms.md) | Passer à une cible binaire, une probabilité et une règle de classification. |

Pour choisir la voie classification du mini-rapport 2, le [parcours anticipé du module 10](../../modules/semaine-10-classification-modeles-avances/index.llms.md#parcours-anticipe) commence dès le module 8. La voie temporelle suit les modules 6 à 9.
