# Capsules - Module 07

## Objectif

Les quatre capsules principales construisent une seule analyse guidée de demande fictive. Les productions 7.1 à 7.4 sont identiques aux activités de l’accueil et aux fins de capsule: réalisez chacune une seule fois dans `lissage_demande.qmd`. Le [projet de départ](telechargements/lissage-demande.zip), les [lectures françaises](../../modules/semaine-07-lissage/lectures.llms.md) et les [démonstrations complètes](../../modules/semaine-07-lissage/demonstrations.llms.md) permettent de travailler sans vidéo.

Les supports disponibles sont PDF et HTML. Aucune vidéo ni annotation n’a été produite ici. L’onglet HTML permet de copier le code; les explications détaillées sont dans les lectures. Le [lot PDF du 3 novembre 2026](telechargements/module-07-pdf-2026-11-03.zip) regroupe les quatre capsules, le complément Holt et la synthèse.

## Capsule 1 - Choisir une fenêtre de lissage

Que peut-on savoir avant la semaine suivante? Consultez la [lecture 1](../../modules/semaine-07-lissage/lectures.llms.md#lecture-1) et la [démonstration associée](../../modules/semaine-07-lissage/demonstrations.llms.md#moyennes-mobiles).

## PDF

[Ouvrir le PDF](media/pdf/capsule-01-support.pdf) · [Télécharger le PDF](media/pdf/capsule-01-support.pdf)

## HTML

[Ouvrir le support HTML dans un nouvel onglet](media/qmd/capsule-01-support.llms.md)

Production guidée 7.1, à réaliser une seule fois : Sur les 91 semaines d’apprentissage, tracez MM4 et MM13. Calculez la moyenne de 980, 1 020, 1 080 et 1 120 unités. Expliquez le retard d’une fenêtre longue et distinguez niveau observé et prévision à origine fixe.

Auto-vérification:

- J’ai utilisé seulement les 91 semaines d’apprentissage.
- J’obtiens 1 050 unités et je précise quand la moyenne est disponible.
- Je distingue fenêtre arrière, fenêtre centrée et prévision émise avant la cible.

> **NOTE:**
>
> Faites l’[exercice 1](../../modules/semaine-07-lissage/exercices.llms.md#exercice-1) sur l’électricité dans `lissage_electricite.qmd`, après la [préparation commune](../../modules/semaine-07-lissage/exercices.llms.md#preparation). Tentez une réponse avant d’ouvrir le corrigé.

## Capsule 2 - Mettre à jour un niveau

Quelle part de l’écart faut-il corriger? Consultez la [lecture 2](../../modules/semaine-07-lissage/lectures.llms.md#lecture-2) et la [démonstration associée](../../modules/semaine-07-lissage/demonstrations.llms.md#lissage-exponentiel).

## PDF

[Ouvrir le PDF](media/pdf/capsule-02-support.pdf) · [Télécharger le PDF](media/pdf/capsule-02-support.pdf)

## HTML

[Ouvrir le support HTML dans un nouvel onglet](media/qmd/capsule-02-support.llms.md)

Production guidée 7.2, à réaliser une seule fois : Avec un niveau initial de 100 et deux observations de 140, calculez les mises à jour pour alpha = 0,2 et 0,8. Tracez ces deux lissages sur l’apprentissage, puis estimez le SES principal. Distinguez alpha imposé, alpha estimé et tendance.

Auto-vérification:

- Les deux calculs partagent le même état initial.
- J’obtiens 108 puis 114,4 et 132 puis 138,4.
- J’estime le SES sur l’apprentissage et je sais que ses prévisions sont constantes.

> **NOTE:**
>
> Faites l’[exercice 2](../../modules/semaine-07-lissage/exercices.llms.md#exercice-2) sur l’électricité dans `lissage_electricite.qmd`, après la [préparation commune](../../modules/semaine-07-lissage/exercices.llms.md#preparation). Tentez une réponse avant d’ouvrir le corrigé.

### Prolongement facultatif : Holt

Holt ajoute une pente au niveau, et son amortissement limite la contribution de cette pente à long horizon. Le [complément accompagné ci-dessous](#capsule-5), la [lecture](../../modules/semaine-07-lissage/lectures.llms.md#holt) et le [code fourni](../../modules/semaine-07-lissage/demonstrations.llms.md#holt) permettent d’explorer le lissage avec une pente. Il ne s’ajoute pas aux candidats du rapport principal.

## Capsule 3 - Lire les erreurs de prévision

Quelle erreur le score moyen cache-t-il? Consultez la [lecture 3](../../modules/semaine-07-lissage/lectures.llms.md#lecture-3) et la [démonstration associée](../../modules/semaine-07-lissage/demonstrations.llms.md#erreurs).

## PDF

[Ouvrir le PDF](media/pdf/capsule-03-support.pdf) · [Télécharger le PDF](media/pdf/capsule-03-support.pdf)

## HTML

[Ouvrir le support HTML dans un nouvel onglet](media/qmd/capsule-03-support.llms.md)

Production guidée 7.3, à réaliser une seule fois : Émettez les treize prévisions naïves, MM4, SES et saisonnières à la même origine. Calculez ME, MAE et RMSE, puis tracez les prévisions et leurs erreurs. Interprétez le signe de ME et la sensibilité de RMSE aux grandes erreurs.

Auto-vérification:

- Les quatre méthodes utilisent les mêmes treize cibles, sans mise à jour future.
- Mes scores sont en unités de produit, avec erreur = observé moins prévu.
- Je relie le classement au graphique et je distingue validation et test indépendant.

> **NOTE:**
>
> Faites l’[exercice 3](../../modules/semaine-07-lissage/exercices.llms.md#exercice-3) sur l’électricité dans `lissage_electricite.qmd`, après la [préparation commune](../../modules/semaine-07-lissage/exercices.llms.md#preparation). Tentez une réponse avant d’ouvrir le corrigé.

## Capsule 4 - Choisir et surveiller une référence

Le plus petit score suffit-il pour décider? Consultez la [lecture 4](../../modules/semaine-07-lissage/lectures.llms.md#lecture-4) et la [démonstration associée](../../modules/semaine-07-lissage/demonstrations.llms.md#decision).

## PDF

[Ouvrir le PDF](media/pdf/capsule-04-support.pdf) · [Télécharger le PDF](media/pdf/capsule-04-support.pdf)

## HTML

[Ouvrir le support HTML dans un nouvel onglet](media/qmd/capsule-04-support.llms.md)

Production guidée 7.4, à réaliser une seule fois : Comparez le coût moyen avec une sous-prévision coûtant 2 et une sur-prévision coûtant 1. Recommandez une référence pour la demande avec deux résultats chiffrés, une limite et une règle de surveillance. Expliquez pourquoi ce choix ne fixe pas une quantité à commander.

Auto-vérification:

- Les coefficients du coût sont annoncés avant le calcul.
- Ma recommandation utilise les résultats de cette validation connue.
- Je nomme les informations manquantes pour commander et une réévaluation future.

> **NOTE:**
>
> Faites l’[exercice 4](../../modules/semaine-07-lissage/exercices.llms.md#exercice-4) sur l’électricité dans `lissage_electricite.qmd`, après la [préparation commune](../../modules/semaine-07-lissage/exercices.llms.md#preparation). Tentez une réponse avant d’ouvrir le corrigé.

## Capsule 5 - Holt accompagné (facultatif)

Prérequis: niveau lissé, origine, horizon et pente. Ce complément n’est pas nécessaire aux quatre activités principales. Le code est fourni pour explorer cette méthode; le calcul manuel des récurrences n’est pas demandé.

## PDF

[Ouvrir le PDF](media/pdf/capsule-05-support.pdf) · [Télécharger le PDF](media/pdf/capsule-05-support.pdf)

## HTML

[Ouvrir le support HTML dans un nouvel onglet](media/qmd/capsule-05-support.llms.md)

Pratique facultative 7.5, à réaliser une seule fois : Comparez Holt amorti à MM4 avec le code fourni. Expliquez ce qu’ajoute la pente et pourquoi elle n’assure pas une meilleure MAE.

Auto-vérification:

- Je conserve le même apprentissage et les mêmes cibles.
- Je distingue pente et saisonnalité.
- Je garde ce complément séparé de la trace principale.

Utilisez le [code complet](../../modules/semaine-07-lissage/demonstrations.llms.md#holt). Pour un autre cas, tentez l’[exercice 13](../../modules/semaine-07-lissage/exercices.llms.md#exercice-13). Ces ajouts ne sont pas requis dans les deux traces principales.

## Autres méthodes conservées: cahier facultatif

Le [cahier de méthodes](../../modules/semaine-07-lissage/complements.llms.md) donne les explications françaises et le code complet des différences, de Holt-Winters, d’ETS et des méthodes avancées. Il complète les lectures sans nouvelle capsule, sans nouvelle vidéo et sans production obligatoire. Choisissez un prolongement selon votre besoin; le parcours principal reste celui des activités 7.1 à 7.4.
