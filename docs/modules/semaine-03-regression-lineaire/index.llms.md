# Module 03

Régression linéaire et interprétation

Séance autonome

## Régression linéaire et interprétation

Comprendre, ajuster et interpréter une droite de régression dans un contexte d’affaires. Le module part d’une question simple : lorsqu’un indicateur augmente, que peut-on dire de la valeur moyenne d’un autre indicateur?

Organisation

À votre rythme

Outils

R, RStudio et Quarto

Données du parcours guidé

[campagnes_marketing_quebec.csv](../../donnees/#campagnes-marketing-québécoises-fictives)

Trace finale

Rapport Quarto court

## On passe au concret

> **NOTE:**
>
> Une organisation observe plusieurs campagnes marketing régionales et veut savoir si les ventes moyennes augmentent lorsque le budget marketing augmente.
>
> La régression linéaire permet de résumer cette relation par une droite. Elle ne prouve pas automatiquement qu’un budget plus élevé cause des ventes plus élevées. Elle aide à quantifier une association moyenne, à vérifier si le modèle est raisonnable et à formuler une interprétation prudente.

À la fin du module, vous devriez pouvoir :

- distinguer variable réponse et variable explicative;
- lire un nuage de points avant d’ajuster un modèle;
- ajuster une régression linéaire simple avec `lm()`;
- interpréter une pente, une ordonnée à l’origine et un coefficient de détermination;
- utiliser les résidus pour vérifier si la droite résume correctement les données;
- expliquer ce que le modèle permet de dire, et ce qu’il ne permet pas de conclure.

## Avant de commencer

Reprenez les gestes du module 2 : créez le projet R `regression-marketing`, placez [campagnes_marketing_quebec.csv](data/campagnes_marketing_quebec.csv) dans son dossier `data`, puis créez `regression_marketing.qmd` à la racine du projet. Les [démonstrations R](../../modules/semaine-03-regression-lineaire/demonstrations.llms.md#préparation) détaillent les clics et le code.

Une ligne décrit une campagne régionale pendant un mois. Le fichier simulé contient 60 observations : cinq régions suivies pendant les douze mois de 2025. `budget_marketing` et `ventes` sont des montants mensuels en dollars canadiens.

La région, le mois, le canal et la saison aident à comprendre le contexte. Le fichier représente des campagnes fictives, même si les noms des régions sont réels.

## Votre parcours

Suivez les six capsules dans l’ordre et conservez le code et vos réponses dans `regression_marketing.qmd`. Les activités 3.1 à 3.6 ci-dessous correspondent aux productions autonomes des diapositives : il n’est pas nécessaire de les refaire deux fois. Les démonstrations montrent le code complet sur le même fichier.

Les six [capsules vidéo](../../modules/semaine-03-regression-lineaire/capsules.llms.md) sont disponibles, accompagnées des notes annotées en PDF. Les supports se consultent aussi en PDF sans annotations ou en HTML, avec du code copiable dans les versions HTML.

Les liens « Ex. » dans les étapes indiquent quand faire les exercices d’application sur le délai de service et la satisfaction. Préparez le projet distinct `diagnostic-service` en suivant la [préparation des exercices](../../modules/semaine-03-regression-lineaire/exercices.llms.md#préparation). Les données des deux cas sont simulées.

> **NOTE:**
>
> Le support global de notes de cours est disponible en [HTML](../../modules/semaine-03-regression-lineaire/notes-cours.llms.md) et en [PDF](media/pdf/notes-cours.pdf). Il sert de synthèse du module; les supports détaillés sont associés aux capsules.

Revenez toujours à cette page pour garder le fil. Cliquez sur une carte pour ouvrir l’étape complète : objectif, ressource, action et activité associée.

1 Formuler la question Passer d'une question d'affaires à une question de régression. [Capsule 1](capsules.llms.md#capsule-1---formuler-une-question-de-régression)[Ex. 1](exercices.llms.md#exercice-1---identifier-les-variables) Ouvrir l'étapeRéduire

Objectif Identifier la variable réponse, la variable explicative et la limite causale de départ.

Ressource [Capsule 1](capsules.llms.md#capsule-1---formuler-une-question-de-régression) [Exercice 1](exercices.llms.md#exercice-1---identifier-les-variables)

Action Reformuler la question avec les mots association moyenne, ventes et budget marketing.

Activité 3.1 - Question et variables

Écrivez la question statistique, puis nommez la variable réponse, la variable explicative principale et une variable de contexte.

Exercice d’application Après la capsule, faites l’exercice 1 sur les variables du cas de service. Tentez une réponse avant d’ouvrir le corrigé.

2 Lire le nuage de points Observer direction, forme, dispersion et points atypiques avant de modéliser. [Capsule 2](capsules.llms.md#capsule-2---lire-le-nuage-de-points)[Démo](demonstrations.llms.md#visualiser-la-relation)[Ex. 2](exercices.llms.md#exercice-2---nuage-de-points) Ouvrir l'étapeRéduire

Objectif Vérifier visuellement si une droite est un résumé plausible.

Ressource [Capsule 2](capsules.llms.md#capsule-2---lire-le-nuage-de-points) [Démonstration](demonstrations.llms.md#visualiser-la-relation) [Exercice 2](exercices.llms.md#exercice-2---nuage-de-points)

Action Produire le nuage de points et décrire la direction de l'association.

Activité 3.2 - Lecture graphique

Décrivez la direction, la forme et la dispersion du nuage de points, puis indiquez une limite.

Exercice d’application Après la capsule, faites l’exercice 2 : un nouveau nuage de points, sur le délai et la satisfaction. Tentez une réponse avant d’ouvrir le corrigé.

3 Comprendre la droite Relier l'équation du modèle à la pente et à l'ordonnée à l'origine. [Capsule 3](capsules.llms.md#capsule-3---comprendre-la-droite-de-régression) Ouvrir l'étapeRéduire

Objectif Comprendre ce que la pente mesure dans le contexte du module.

Ressource [Capsule 3](capsules.llms.md#capsule-3---comprendre-la-droite-de-régression)

Action Traduire l'équation en langage d'affaires.

Activité 3.3 - Pente et unités

Interprétez la pente pour 1 000 \$ de budget. Expliquez le signe du résidu de janvier en Capitale-Nationale.

4 Ajuster le modèle dans R Utiliser lm(), lire les coefficients et transformer la sortie en phrases. [Capsule 4](capsules.llms.md#capsule-4---ajuster-le-modèle-avec-r)[Démo](demonstrations.llms.md#ajuster-le-modèle)[Ex. 3](exercices.llms.md#exercice-3---ajuster-le-modèle) Ouvrir l'étapeRéduire

Objectif Ajuster une régression linéaire simple et lire la sortie R utile.

Ressource [Capsule 4](capsules.llms.md#capsule-4---ajuster-le-modèle-avec-r) [Démonstration](demonstrations.llms.md#ajuster-le-modèle) [Exercice 3](exercices.llms.md#exercice-3---ajuster-le-modèle)

Action Exécuter `lm(ventes ~ budget_marketing, data = campagnes)` et repérer les coefficients.

Activité 3.4 - Lire les coefficients

Ajustez la droite, présentez la pente pour 1 000 \$ et son intervalle classique. Formulez H₀ sur la pente et interprétez la valeur p. Indiquez une hypothèse à vérifier.

Exercice d’application Après la capsule, faites l’exercice 3 pour ajuster et interpréter le modèle de satisfaction, puis lire le test de la pente. Tentez une réponse avant d’ouvrir le corrigé.

5 Diagnostiquer les résidus Vérifier si les erreurs du modèle restent compatibles avec une droite. [Capsule 5](capsules.llms.md#capsule-5---diagnostiquer-avec-les-résidus)[Démo](demonstrations.llms.md#résidus-et-valeurs-ajustées) Ouvrir l'étapeRéduire

Objectif Utiliser les résidus pour juger la crédibilité du modèle.

Ressource [Capsule 5](capsules.llms.md#capsule-5---diagnostiquer-avec-les-résidus) [Démonstration](demonstrations.llms.md#résidus-et-valeurs-ajustées)

Action Ajouter valeurs prédites et résidus, puis produire un graphique de diagnostic.

Activité 3.5 - Résidus

Produisez le graphique des résidus et le tableau par région. Rédigez un constat sur chacun, puis une limite.

6 Conclure prudemment Rassembler graphique, pente, ajustement, limite et recommandation. [Capsule 6](capsules.llms.md#capsule-6---conclure-sans-dépasser-les-données)[Démo](demonstrations.llms.md#conclusion-prudente)[Ex. 4 à 6](exercices.llms.md#exercice-4---examiner-les-résidus-et-le-r²) Ouvrir l'étapeRéduire

Objectif Produire une conclusion courte, utile et statistiquement défendable.

Ressource [Capsule 6](capsules.llms.md#capsule-6---conclure-sans-dépasser-les-données) [Démonstration](demonstrations.llms.md#conclusion-prudente) [Exercices 4 à 6](exercices.llms.md#exercice-4---examiner-les-résidus-et-le-r²)

Action Calculer le R², prédire les ventes pour 6 000 \$ de budget avec un intervalle, puis conclure en tenant compte des résidus et du contexte.

Activité 3.6 - Conclusion finale

Rédigez cinq phrases : question, pente pour 1 000 \$, ajustement et diagnostic, limite, prochaine étape.

Exercice d’application Terminez avec les exercices 4 à 6 : diagnostic et R², conclusion, puis note Quarto. L’exercice 4 vient ici parce qu’il utilise aussi le R² présenté dans la capsule 6. Tentez une réponse avant d’ouvrir le corrigé.

## Exercices d’application

Les [six exercices](../../modules/semaine-03-regression-lineaire/exercices.llms.md) se font progressivement dans le projet `diagnostic-service`, aux étapes indiquées ci-dessus. Si vous les avez déjà réalisés, il suffit de terminer les exercices restants et de relire vos réponses. Vous étudierez le délai de service moyen, en minutes, et la satisfaction mensuelle, en points sur 10, dans six succursales fictives.

Le fichier de transfert est [performance_succursales_quebec.csv](../atelier-02-regression/data/performance_succursales_quebec.csv). La démarche reste la même, mais la question, les variables, les unités et la destinataire changent. Tentez chaque exercice avant d’ouvrir sa solution détaillée.

## Trace finale

Le parcours guidé produit `regression_marketing.qmd`. Il doit contenir :

1.  la question, l’unité d’observation et les unités des variables;
2.  le nuage budget-ventes et sa lecture;
3.  le code `lm()` et l’interprétation de la pente pour 1 000 \$;
4.  l’intervalle de confiance classique de la pente et ses hypothèses;
5.  le R², le graphique des résidus et le diagnostic par région;
6.  la prédiction pour 6 000 \$ de budget, son intervalle et ses limites;
7.  une conclusion courte appuyée sur les résultats.

Les exercices produisent `diagnostic_service.qmd`, destiné à la responsable du service. L’[exercice 6](../../modules/semaine-03-regression-lineaire/exercices.llms.md#exercice-6---mini-trace-finale) précise le contenu de cette note.

Dans RStudio, choisissez Session \> Restart R, puis Render pour vérifier chacun des documents. Ces traces sont des entraînements; les consignes des mini-rapports évalués restent dans la section [Évaluations](../../evaluations/index.llms.md).

## Ressources du module

[CapsulesSix vidéos, leurs notes annotées et les supports PDF et HTML, avec code copiable.](capsules.llms.md) [Notes de coursSynthèse du module en diapositives HTML et PDF.](notes-cours.llms.md) [Démonstrations RAnalyse complète avec le fichier de campagnes marketing.](demonstrations.llms.md) [Exercices et solutions détailléesTransférer la démarche au service, puis comparer le code, les résultats et les interprétations.](exercices.llms.md) [LecturesClarifier les notions de régression et de prudence causale.](lectures.llms.md)

> **WARNING:**
>
> - Interpréter la pente sans préciser l’unité de la variable explicative.
> - Lire une association comme une preuve de causalité.
> - Ajuster le modèle avant d’avoir regardé le nuage de points.
> - Citer seulement le `R²` sans regarder les résidus.
> - Oublier que l’ordonnée à l’origine peut être peu utile si `budget_marketing = 0` n’est pas une situation réaliste dans les données.
> - Faire une prédiction loin de la plage de budgets observés.

## Auto-vérification

Avant de passer au module suivant, je peux dire que :

J’ai formulé une question de régression sans causalité non justifiée.

J’ai identifié la variable réponse et la variable explicative.

J’ai produit et interprété un nuage de points.

J’ai ajusté un modèle avec `lm()`.

J’ai interprété la pente avec les unités.

J’ai examiné le graphique des résidus et leurs moyennes par région.

J’ai expliqué les limites des intervalles et de la prédiction.

Mon document se recalcule après redémarrage de R.

J’ai rédigé une conclusion prudente.

> **NOTE:**
>
> Vous pouvez utiliser le [GPT du cours](https://chatgpt.com/g/g-6a0b2ec33d948191ad25b2f247b15de1-analyse-et-modelisation-des-donnees?ref=mini) pour vérifier votre interprétation. Après une première tentative, son rôle est de repérer les imprécisions, les oublis de diagnostic et les conclusions trop fortes. Il ne doit pas rédiger la trace finale à votre place.
>
> Suggestion de demande :
>
> > Voici ma trace finale pour le module 03. Vérifie si ma question, mon graphique, mon interprétation de la pente, mon diagnostic des résidus et ma limite causale sont clairs. Indique les éléments manquants ou imprécis, sans réécrire ma réponse à ma place.
>
> Après cette vérification, notez une correction concrète à apporter à votre interprétation.

## Je suis bloqué·e

Avant de demander de l’aide, vérifiez dans l’ordre :

1.  le chargement de `tidyverse`;
2.  le chemin vers `campagnes_marketing_quebec.csv`;
3.  le nom exact des variables `ventes` et `budget_marketing`;
4.  le nuage de points avant le modèle;
5.  le code `lm(ventes ~ budget_marketing, data = campagnes)`;
6.  le graphique des résidus;
7.  le message d’erreur complet si R bloque.

## Pour aller plus loin

- Comparer l’interprétation d’une hausse de 1 dollar et d’une hausse de 1 000 dollars de budget.
- Ajouter une variable de contexte dans le graphique, par exemple `region` ou `canal`, sans en faire une preuve causale.
- Reprendre la conclusion en distinguant clairement association, prédiction et décision.
