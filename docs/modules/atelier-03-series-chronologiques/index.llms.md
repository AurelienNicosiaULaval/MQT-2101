# Laboratoire 03 - Prévoir la demande

Troisième laboratoire en classe

## Quelle prévision utiliser pour préparer les livraisons?

Vous reprenez brièvement les résultats du module 07, puis transposez les acquis à une nouvelle série mensuelle de livraisons fictives.

Séance

En classe, avec rétroaction

Outils

R, RStudio et Quarto

Données

Livraisons mensuelles simulées

Trace

Un rapport de laboratoire

## La mission

Une coopérative fictive prépare ses ressources pour les douze prochains mois. Quelle prévision peut-elle utiliser, avec quelles réserves et quel suivi?

> **NOTE:**
>
> Dans un seul rapport Quarto, vérifiez la série et le calendrier, comparez le naïf saisonnier et le modèle avec tendance et mois sur les mêmes douze mois, puis recommandez une méthode avec deux mesures, le coût simulé, un intervalle identifié, une limite et une règle de surveillance.

Cette production se construit une seule fois dans `rapport-labo-03.qmd`. Les étapes ci-dessous, le [guide](../../modules/atelier-03-series-chronologiques/guide-atelier.llms.md), les [repères](../../modules/atelier-03-series-chronologiques/capsules.llms.md) et la [présentation de lancement](../../modules/atelier-03-series-chronologiques/presentation.llms.md) désignent le même rapport. Le [transfert mensuel](../../modules/atelier-03-series-chronologiques/exercices.llms.md) est une pratique facultative distincte.

## Avant la séance

Le [calendrier du cours](../../calendrier.llms.md) prévoit la séance le mercredi 18 novembre 2026, de 9 h à 11 h 50, au pavillon Palasis-Prince, local 3213.

- Revoyez origine, horizon et validation au [module 06](../../modules/semaine-06-series-chronologiques-intro/index.llms.md), les références et le SES au [module 07](../../modules/semaine-07-lissage/index.llms.md), puis l’indice et la tendance au [module 08](../../modules/semaine-08-tendance-saisonnalite/index.llms.md).
- Téléchargez et décompressez le [projet de départ](telechargements/laboratoire-03.zip). Ouvrez `laboratoire-03.Rproj`, puis `rapport-labo-03.qmd`; lancez Render avant de commencer.
- Installez `tidyverse` si nécessaire; `forecast` sert à la comparaison hebdomadaire facultative. Le [dictionnaire](data/dictionnaires.md) décrit les fichiers fournis.
- Apportez vos traces précédentes et une question sur votre mini-rapport 2. Si le premier rendu bloque, conservez le message d’erreur pour recevoir de l’aide.

Reprenez brièvement vos résultats du module 07 et la [comparaison hebdomadaire accompagnée](../../modules/atelier-03-series-chronologiques/demonstration-hebdomadaire.llms.md#decision) : pourquoi l’ajout d’une tendance ou le coût fictif des écarts peut-il modifier une recommandation de stock? Il n’est pas nécessaire de refaire les quatre prévisions.

Le nouveau cas est simulé. Les 60 mois de 2020 à 2024 servent à l’apprentissage; les douze mois de 2025 servent à comparer depuis la fin de décembre 2024. Ce bloc utilisé pour choisir n’est pas un test final indépendant.

## Votre parcours en classe

Travaillez en binôme si possible, ou seul. Chaque personne doit pouvoir expliquer la démarche. Le [guide de la mission](../../modules/atelier-03-series-chronologiques/guide-atelier.llms.md) donne les consignes et les indices à ouvrir après une tentative; l’enseignant vous accompagne. Les cartes servent à retrouver une étape, sans ajouter de production.

1Auditer et situerQue sait-on à la fin de décembre 2024?[Aide R](demonstrations.llms.md#audit)[Guide](guide-atelier.llms.md#audit)Ouvrir l’étapeRéduire

Action dans le même rapport Énoncez la cible, l’unité, l’origine et les douze mois de validation. Vérifiez dates, régularité et valeurs manquantes.

Après une tentative [Indice du guide](guide-atelier.llms.md#audit) · [Exemple R](demonstrations.llms.md#audit)

2Explorer le passéQue suggèrent les motifs mensuels?[Aide R](demonstrations.llms.md#exploration)[Guide](guide-atelier.llms.md#exploration)Ouvrir l’étapeRéduire

Action dans le même rapport Tracez les 60 mois d’apprentissage et comparez les profils mensuels par année. Décrivez la tendance, la saison et une limite.

Après une tentative [Indice du guide](guide-atelier.llms.md#exploration) · [Exemple R](demonstrations.llms.md#exploration)

3Construire les prévisionsQue change le modèle avec tendance et mois?[Aide R](demonstrations.llms.md#previsions)[Guide](guide-atelier.llms.md#previsions)Ouvrir l’étapeRéduire

Action dans le même rapport Construisez le calendrier futur et comparez le naïf saisonnier à une régression avec tendance et mois, à la même origine. Interprétez la pente et le mois de référence.

Après une tentative [Indice du guide](guide-atelier.llms.md#previsions) · [Exemple R](demonstrations.llms.md#previsions)

4Comparer et lire l’incertitudeQue disent les erreurs et l’intervalle?[Aide R](demonstrations.llms.md#comparaison)[Guide](guide-atelier.llms.md#comparaison)Ouvrir l’étapeRéduire

Action dans le même rapport Calculez ME, MAE et RMSE sur les mêmes douze mois et interprétez un intervalle de prédiction du modèle combiné.

Après une tentative [Indice du guide](guide-atelier.llms.md#comparaison) · [Exemple R](demonstrations.llms.md#comparaison)

5Décider et surveillerQue change le coût des écarts?[Aide R](demonstrations.llms.md#decision)[Guide](guide-atelier.llms.md#decision)Ouvrir l’étapeRéduire

Action dans le même rapport Comparez les coûts fictifs et formulez une recommandation avec une limite et une prochaine vérification.

Après une tentative [Indice du guide](guide-atelier.llms.md#decision) · [Exemple R](demonstrations.llms.md#decision)

Après l’exploration, présentez votre protocole et vos premiers constats pour obtenir une rétroaction. Avant le rendu final, demandez une relecture à un autre binôme ou à l’enseignant et corrigez un point précis.

## Ce qui est attendu

Le rapport comprend la question et les contrôles, les graphiques du passé, les deux prévisions communes, les mesures et coûts, l’intervalle du modèle combiné, puis une recommandation avec limite et suivi. Les résultats du laboratoire sont une pratique formative distincte du mini-rapport.

Les deux prévisions sont comparées sur les mêmes cibles. Les autres méthodes peuvent être explorées dans les compléments, sans devenir des exigences de la mission.

## Point de contrôle du mini-rapport 2

Le calendrier prévoit un point de contrôle pendant le laboratoire. Apportez votre proposition de données et votre protocole. Pour la voie temporelle, identifiez cible, origine, horizon, références et validation. Pour la voie classification, consultez le [parcours anticipé du module 10](../../modules/semaine-10-classification-modeles-avances/index.llms.md#parcours-anticipe) et préparez cible, séparation, probabilités et choix de seuils. Les [consignes du mini-rapport](../../evaluations/mini-rapport-2.llms.md) restent la référence. Les résultats de ce laboratoire ne remplacent pas une analyse autonome.

## Ressources

[Guide de la missionConsignes, indices et grille de rétroaction.](guide-atelier.llms.md) [Présentation de lancementSupport HTML et PDF pour la séance en classe.](presentation.llms.md) [Aide R et exemple completUn geste à la fois, après votre première tentative.](demonstrations.llms.md) [Transfert et pratiquesVentes mensuelles, coûts et corrigés repliables, facultatifs.](exercices.llms.md) [Lectures et repèresExplications en français et rappels ciblés.](lectures.llms.md)

Le support de lancement est aussi offert en [PDF](media/pdf/presentation.pdf). Aucun enregistrement vidéo ni PDF annoté n’est annoncé.

## Auto-vérification et aide

J’ai précisé l’origine, les dates et les unités.

Je compare les deux méthodes sur les mêmes douze cibles.

Je nomme la méthode de l’intervalle et ses hypothèses.

Ma recommandation cite des résultats, une limite et un suivi.

Si un blocage survient, vérifiez que tout le projet a été extrait, que `data/` est présent, puis reprenez l’[aide R](../../modules/atelier-03-series-chronologiques/demonstrations.llms.md#preparation). Montrez votre tentative et le message d’erreur complet.

> **NOTE:**
>
> Après avoir produit votre première comparaison, vous pouvez demander au GPT du cours de relever une fuite temporelle possible ou une incohérence entre mesure et recommandation. Vous devez vérifier puis documenter la correction retenue.
