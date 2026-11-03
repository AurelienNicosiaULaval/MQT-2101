# Module 07 - Lissage et évaluation des prévisions

Séance autonome

## Prévoir sans suivre chaque fluctuation

Construire un niveau lissé, comparer des prévisions et relier leurs erreurs à une décision.

Organisation

À votre rythme

Outils

R, RStudio et Quarto

Cas guidé

Demande hebdomadaire fictive au Québec

Trace finale

Deux rapports Quarto courts

## On passe au concret

> **NOTE:**
>
> Une équipe d’approvisionnement doit prévoir la demande des treize prochaines semaines. Comment stabiliser sa référence sans ignorer une hausse récente? Une moyenne plus lisse n’est pas automatiquement une meilleure prévision.

À la fin du module, vous pourrez calculer une moyenne mobile arrière, mettre à jour un niveau exponentiel, distinguer lissage et prévision, puis comparer les erreurs et leur coût sur des cibles communes. La demande hebdomadaire annoncée au module 06 est reprise ici et au laboratoire 03. Le transfert porte sur la planification énergétique d’un bâtiment fictif; il demande une interprétation différente du classement.

## Avant de commencer

Prérequis présents dans les supports: importer un CSV et rendre un document Quarto (module 02), définir cible, origine et horizon, vérifier un calendrier, construire les références naïves et lire ME, MAE et RMSE (module 06). Si nécessaire, reprenez les [démonstrations du module 06](../../modules/semaine-06-series-chronologiques-intro/demonstrations.llms.md#references) et ses [lectures sur les erreurs](../../modules/semaine-06-series-chronologiques-intro/lectures.llms.md#lecture-5). L’acquisition de ces gestes n’est pas présumée vérifiée individuellement.

Téléchargez et décompressez les projets [lissage-demande](telechargements/lissage-demande.zip) et [lissage-electricite](telechargements/lissage-electricite.zip). Ouvrez leur `.Rproj`; les données, dictionnaires et fonctions sont fournis. `tidyverse`, `slider` et `forecast` sont nécessaires. La [préparation R](../../modules/semaine-07-lissage/demonstrations.llms.md#preparation) repart d’une session neuve.

Le cas guidé comprend 104 semaines simulées, du 1er janvier 2024 au 22 décembre 2025. Une ligne est une semaine, la demande se mesure en unités de produit. On apprend sur les 91 premières semaines et on compare sur les treize dernières à une seule origine. L’électricité compte 72 mois, de janvier 2020 à décembre 2025, en kWh: 60 mois pour apprendre, puis les douze mois de 2025 pour comparer. Les [dictionnaires](data/dictionnaires.md) détaillent les variables et les limites du calendrier.

> **WARNING:**
>
> Ces périodes ont déjà été examinées au module 06. Elles servent à apprendre la comparaison de nouvelles méthodes, sans nouveau test indépendant. Les fenêtres et candidats sont annoncés avant les scores; les paramètres estimés utilisent seulement l’apprentissage.

### Ce qui change depuis le module 06

Le calendrier, les références et les mesures d’erreur sont des rappels utiles. Les nouveaux gestes sont le calcul des fenêtres, la récurrence du SES, l’effet d’alpha et l’usage d’un coût asymétrique. Le parcours comprend quatre étapes principales et une cinquième étape facultative sur Holt. Ce complément accompagné ajoute une pente au niveau lissé; différenciation, ETS saisonnier et autres méthodes restent aussi facultatifs.

## Votre parcours

Les productions autonomes 7.1 à 7.4 des diapositives, les activités ci-dessous et leurs rappels sur la page des capsules désignent le même travail. Réalisez chaque production une seule fois dans `lissage_demande.qmd`. Les quatre exercices de transfert sont distincts et alimentent `lissage_electricite.qmd`. Ouvrez leurs corrigés après une tentative.

Les [quatre capsules principales et le complément Holt](../../modules/semaine-07-lissage/capsules.llms.md) sont disponibles en PDF et HTML. Les [capsules 1 et 2](../../modules/semaine-07-lissage/capsules.llms.md#capsule-1) disposent aussi de leur vidéo et de leur PDF annoté. Les autres capsules restent disponibles en PDF et HTML. La [synthèse](../../modules/semaine-07-lissage/notes-cours.llms.md) est aussi disponible en [PDF](media/pdf/notes-cours.pdf). Le [lot PDF harmonisé du 3 novembre 2026](telechargements/module-07-pdf-2026-11-03-harmonise.zip) contient ces six supports et les deux PDF annotés.

Cliquez sur une carte pour ouvrir l’objectif, les ressources et la tâche. Les quatre premières cartes forment le parcours principal. La cinquième propose un prolongement facultatif sur Holt, avec des supports PDF et HTML, une lecture et du code fourni. Revenez ici pour garder le fil.

1Choisir une fenêtre de lissageQue peut-on savoir avant la semaine suivante?[Capsule 1](capsules.llms.md#capsule-1)[Démo](demonstrations.llms.md#moyennes-mobiles)[Ex. 1](exercices.llms.md#exercice-1)Ouvrir l’étapeRéduire

Objectif Choisir une fenêtre de lissage.

Ressource [Capsule 1](capsules.llms.md#capsule-1) · [Démonstration](demonstrations.llms.md#moyennes-mobiles) · [Lecture française](lectures.llms.md#lecture-1)

Action Ajouter cette étape au même rapport guidé.

Activité 7.1 - Fenêtre et disponibilité

Sur les 91 semaines d’apprentissage, tracez MM4 et MM13. Calculez la moyenne de 980, 1 020, 1 080 et 1 120 unités. Expliquez le retard d’une fenêtre longue et distinguez niveau observé et prévision à origine fixe.

Auto-vérification J’ai utilisé seulement les 91 semaines d’apprentissage. J’obtiens 1 050 unités et je précise quand la moyenne est disponible. Je distingue fenêtre arrière, fenêtre centrée et prévision émise avant la cible.

Exercice d’application distinct Faites l’[exercice 1](exercices.llms.md#exercice-1) sur l’électricité dans `lissage_electricite.qmd`. Tentez une réponse avant d’ouvrir le corrigé.

2Mettre à jour un niveauQuelle part de l’écart faut-il corriger?[Capsule 2](capsules.llms.md#capsule-2)[Démo](demonstrations.llms.md#lissage-exponentiel)[Ex. 2](exercices.llms.md#exercice-2)Ouvrir l’étapeRéduire

Objectif Mettre à jour un niveau.

Ressource [Capsule 2](capsules.llms.md#capsule-2) · [Démonstration](demonstrations.llms.md#lissage-exponentiel) · [Lecture française](lectures.llms.md#lecture-2)

Action Ajouter cette étape au même rapport guidé.

Activité 7.2 - Niveau et alpha

Avec un niveau initial de 100 et deux observations de 140, calculez les mises à jour pour alpha = 0,2 et 0,8. Tracez ces deux lissages sur l’apprentissage, puis estimez le SES principal. Distinguez alpha imposé, alpha estimé et tendance.

Auto-vérification Les deux calculs partagent le même état initial. J’obtiens 108 puis 114,4 et 132 puis 138,4. J’estime le SES sur l’apprentissage et je sais que ses prévisions sont constantes.

Exercice d’application distinct Faites l’[exercice 2](exercices.llms.md#exercice-2) sur l’électricité dans `lissage_electricite.qmd`. Tentez une réponse avant d’ouvrir le corrigé.

3Lire les erreurs de prévisionQuelle erreur le score moyen cache-t-il?[Capsule 3](capsules.llms.md#capsule-3)[Démo](demonstrations.llms.md#erreurs)[Ex. 3](exercices.llms.md#exercice-3)Ouvrir l’étapeRéduire

Objectif Lire les erreurs de prévision.

Ressource [Capsule 3](capsules.llms.md#capsule-3) · [Démonstration](demonstrations.llms.md#erreurs) · [Lecture française](lectures.llms.md#lecture-3)

Action Ajouter cette étape au même rapport guidé.

Activité 7.3 - Erreurs et unités

Émettez les treize prévisions naïves, MM4, SES et saisonnières à la même origine. Calculez ME, MAE et RMSE, puis tracez les prévisions et leurs erreurs. Interprétez le signe de ME et la sensibilité de RMSE aux grandes erreurs.

Auto-vérification Les quatre méthodes utilisent les mêmes treize cibles, sans mise à jour future. Mes scores sont en unités de produit, avec erreur = observé moins prévu. Je relie le classement au graphique et je distingue validation et test indépendant.

Exercice d’application distinct Faites l’[exercice 3](exercices.llms.md#exercice-3) sur l’électricité dans `lissage_electricite.qmd`. Tentez une réponse avant d’ouvrir le corrigé.

4Choisir et surveiller une référenceLe plus petit score suffit-il pour décider?[Capsule 4](capsules.llms.md#capsule-4)[Démo](demonstrations.llms.md#decision)[Ex. 4](exercices.llms.md#exercice-4)Ouvrir l’étapeRéduire

Objectif Choisir et surveiller une référence.

Ressource [Capsule 4](capsules.llms.md#capsule-4) · [Démonstration](demonstrations.llms.md#decision) · [Lecture française](lectures.llms.md#lecture-4)

Action Ajouter cette étape au même rapport guidé.

Activité 7.4 - Coût et recommandation

Comparez le coût moyen avec une sous-prévision coûtant 2 et une sur-prévision coûtant 1. Recommandez une référence pour la demande avec deux résultats chiffrés, une limite et une règle de surveillance. Expliquez pourquoi ce choix ne fixe pas une quantité à commander.

Auto-vérification Les coefficients du coût sont annoncés avant le calcul. Ma recommandation utilise les résultats de cette validation connue. Je nomme les informations manquantes pour commander et une réévaluation future.

Exercice d’application distinct Faites l’[exercice 4](exercices.llms.md#exercice-4) sur l’électricité dans `lissage_electricite.qmd`. Tentez une réponse avant d’ouvrir le corrigé.

5Holt accompagné (facultatif)Qu’ajoute une pente au niveau lissé?[PDF et HTML](capsules.llms.md#capsule-5)[Démo](demonstrations.llms.md#holt)[Ex. 13](exercices.llms.md#exercice-13)Ouvrir l’étapeRéduire

Objectif Distinguer le niveau, la pente et son amortissement.

Prérequis Niveau lissé, origine, horizon et pente.

Ressources [Supports PDF et HTML](capsules.llms.md#capsule-5) · [Démonstration avec code complet](demonstrations.llms.md#holt) · [Lecture française](lectures.llms.md#holt)

Action facultative Réaliser cette pratique une seule fois si vous choisissez ce prolongement. Elle ne s’ajoute pas aux deux rapports principaux.

Pratique facultative 7.5 - Niveau et pente

Comparez Holt amorti à MM4 avec le code fourni. Expliquez ce qu’ajoute la pente et pourquoi elle n’assure pas une meilleure MAE.

Auto-vérification Je conserve le même apprentissage et les mêmes cibles. Je distingue pente et saisonnalité. Je garde ce complément séparé de la trace principale.

Autre cas, facultatif Tentez l’[exercice 13](exercices.llms.md#exercice-13) sur l’électricité après la démonstration.

## Exercices d’application

Les [quatre exercices suivis](../../modules/semaine-07-lissage/exercices.llms.md) reprennent l’électricité du module 06 avec des fenêtres, deux réactivités et un coût pédagogique. Le changement de cible, de calendrier et de décision oblige à lire les résultats obtenus. Le classement de la demande ne peut pas être recopié.

Les [huit pratiques supplémentaires](../../modules/semaine-07-lissage/exercices.llms.md#pratique-supplementaire), facultatives, renforcent les fenêtres, la fuite temporelle, la récurrence, les scores et la décision. Choisissez selon vos difficultés, tentez une réponse, puis refaites la question sans regarder le corrigé. L’[exercice 13](../../modules/semaine-07-lissage/exercices.llms.md#exercice-13) accompagne Holt séparément.

## Trace finale

Votre rapport `lissage_demande.qmd` rassemble, une seule fois:

1.  le protocole, les fenêtres et leur interprétation;
2.  les mises à jour manuelles, les deux lissages et le SES estimé;
3.  les quatre trajectoires, leurs erreurs et ME, MAE, RMSE;
4.  le coût annoncé, une recommandation chiffrée, une limite et une règle de surveillance.

Le rapport distinct `lissage_electricite.qmd` réunit les quatre exercices et la [conclusion de transfert](../../modules/semaine-07-lissage/exercices.llms.md#trace-finale). Redémarrez R, puis faites Render pour chacun: aucun objet créé uniquement dans la console ne doit être requis.

Les projets [démonstration complète de demande](telechargements/demonstration-lissage-demande.zip) et [corrigé complet d’électricité](telechargements/corrige-lissage-electricite.zip) permettent de vérifier votre démarche après votre tentative.

## Pour préparer la suite

Le module prépare la comparaison des méthodes et la lecture des erreurs au laboratoire 03, au mini-rapport 2 et à l’examen final. Les deux rapports sont des entraînements. Les [consignes d’évaluation](../../evaluations/index.llms.md) restent la référence pour les travaux évalués. Le mini-rapport 2 exige une analyse autonome.

Au laboratoire, apportez votre trace. Le [complément Holt](../../modules/semaine-07-lissage/capsules.llms.md#capsule-5) reste disponible si vous souhaitez explorer le lissage avec une pente. Le module 08 ajoute la tendance et les effets saisonniers explicites; le module 09 traite les variables externes et l’autocorrélation. Aucun de ces outils n’est nécessaire pour terminer les quatre activités principales.

## Ressources du module

[CapsulesVidéos et PDF annotés des quatre capsules principales; complément Holt en PDF et HTML.](capsules.llms.md) [Notes de coursSynthèse du parcours en diapositives HTML et PDF.](notes-cours.llms.md) [Démonstrations RAnalyse guidée complète, graphiques, scores et interprétations.](demonstrations.llms.md) [ExercicesQuatre exercices suivis, huit pratiques et un complément corrigés.](exercices.llms.md) [LecturesExplications françaises et passages externes ciblés.](lectures.llms.md)

## Erreurs fréquentes

- Comparer une observation à une moyenne qui la contient comme si elle avait été prévue auparavant.
- Confondre une fenêtre arrière et une moyenne centrée.
- Mettre à jour une prévision à origine fixe avec des observations futures.
- Donner des états initiaux différents aux deux alphas sans le dire.
- Croire que `frequency = 52` rend le SES saisonnier.
- Retenir le plus petit score sans ses unités, son coût et ses limites.
- Transformer une prévision en commande ou une consommation en facture.

## Auto-vérification

Je sais quand la fenêtre et le niveau sont disponibles.

Mes mises à jour manuelles concordent avec le code.

Je distingue alpha imposé et estimation sur l’apprentissage.

Les candidats partagent cibles, origine, horizons et information disponible.

J’interprète les scores et la perte asymétrique avec leurs unités.

Mes deux recommandations reposent sur leurs résultats propres.

Je nomme la validation connue et une réévaluation future.

Mes deux rapports se rendent après redémarrage de R.

## Je suis bloqué·e

Vérifiez dans l’ordre:

1.  Toute l’archive est décompressée et son `.Rproj` est ouvert.
2.  Les trois bibliothèques se chargent; `data/` et `R/fonctions-module07.R` sont présents.
3.  Les dates sont triées et le bon calendrier est utilisé: semaines ou mois.
4.  Le découpage est 91 + 13 pour la demande, 60 + 12 pour l’électricité.
5.  Les blocs visibles sont exécutés dans l’ordre; les corrigés 1 à 4 suivent la préparation commune.
6.  La [lecture ciblée](../../modules/semaine-07-lissage/lectures.llms.md) explique le geste qui bloque. Pour une commande, consultez l’[aide-mémoire R](../../ressources/aide-memoire-r.llms.md).

Si le blocage persiste, conservez le message d’erreur complet et le court morceau de code concerné pour demander de l’aide.

Vous pouvez travailler sans IA avec les lectures, la liste de vérification et les corrigés. Si vous utilisez le GPT du cours, demandez une critique de votre protocole après votre tentative, vérifiez sa réponse et respectez les [règles d’usage](../../ressources/ia.llms.md) et la [déclaration du cours](../../ressources/declaration-ia.llms.md). Ne transmettez aucune donnée personnelle ou confidentielle.

## Pour aller plus loin

Le [complément Holt](../../modules/semaine-07-lissage/capsules.llms.md#capsule-5) explique niveau, pente et amortissement avec code fourni. Il est facultatif pour les deux rapports. Les [autres lectures facultatives](../../modules/semaine-07-lissage/lectures.llms.md#complements) conservent différenciation, Holt-Winters, ETS et les pistes avancées de l’ancien matériel, avec leurs prérequis et limites.

### Cahier facultatif de méthodes conservées

Le [cahier de lissage](../../modules/semaine-07-lissage/complements.llms.md) conserve les différences et leur réintégration, Holt-Winters, ETS, BATS, TBATS et STL avec ETS, avec explications françaises et code complet. Son [projet autonome](telechargements/complements-lissage.zip) permet de les explorer sur l’électricité mensuelle. Ce sont des ressources de consolidation ou d’ouverture; elles ne s’ajoutent pas aux quatre productions principales et ne doivent pas toutes être utilisées dans une analyse.
