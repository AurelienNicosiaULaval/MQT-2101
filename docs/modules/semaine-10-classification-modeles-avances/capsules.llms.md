# Capsules - Module 10

## Objectif

Ouvrez le [projet de départ sur les clients](telechargements/classification-clients.zip). Les cinq capsules suivent la décision de l’équipe de fidélisation, depuis les informations disponibles avant le départ jusqu’au nombre de contacts à prévoir. La [démonstration R](../../modules/semaine-10-classification-modeles-avances/demonstrations.llms.md#preparation) accompagne chaque calcul. Chaque production est celle de l’accueil et de la diapositive de production correspondante : réalisez-la une seule fois dans le rapport guidé.

Les cinq capsules et la synthèse sont regroupées dans le [lot PDF des cinq capsules et des notes de cours](telechargements/module-10-pdf-2026-11-20-tournage.zip).

## Capsule 1 - Définir la cible et les partitions

## PDF

[Ouvrir le PDF](media/pdf/capsule-01-support.pdf) · [Télécharger le PDF](media/pdf/capsule-01-support.pdf)

## HTML

[Ouvrir le diaporama HTML](media/qmd/capsule-01-support.llms.md)

### Activité 10.1

Définissez l’unité, la classe positive, l’horizon et le moment des prédicteurs. Séparez les clients en apprentissage, validation et test; vérifiez les effectifs et l’absence de clients communs.

Auto-vérification : Je définis un départ observable dans les 90 jours. Je vérifie les identifiants et les trois partitions. Je réserve le test à la règle choisie.

> **TIP:**
>
> Sur les 650 clients, l’apprentissage compte 389 personnes (118 départs), la validation 130 (40 départs) et le test 131 (40 départs). Chaque personne appartient à un seul ensemble. Les prédicteurs sont supposés connus à la décision. L’absence de dates dans le fichier empêche de contrôler cette hypothèse et l’évolution de la clientèle.
>
> [Retrouver le calcul dans la démonstration](../../modules/semaine-10-classification-modeles-avances/demonstrations.llms.md#preparation).

> **NOTE:**
>
> Faites l’[exercice 1](../../modules/semaine-10-classification-modeles-avances/exercices.llms.md#exercice-1) sur le mois-succursale.

## Capsule 2 - Estimer et interpréter

## PDF

[Ouvrir le PDF](media/pdf/capsule-02-support.pdf) · [Télécharger le PDF](media/pdf/capsule-02-support.pdf)

## HTML

[Ouvrir le diaporama HTML](media/qmd/capsule-02-support.llms.md)

### Activité 10.2

Ajustez une régression logistique sur l’apprentissage. Interprétez un rapport de cotes et deux probabilités prédites sans les présenter comme une certitude ou un effet causal.

Auto-vérification : Je distingue une cote d’une probabilité. Je nomme la référence et les variables maintenues fixes. Je ne prétends pas mesurer l’effet de l’intervention.

> **TIP:**
>
> À autres variables fixées, la cote de départ est multipliée par environ 1,443 pour un ticket supplémentaire. Pour les profils à un et trois tickets, le modèle donne 32,0 % et 49,5 %. L’écart de 17,5 points compare des profils hypothétiques. Il ne chiffre pas l’effet d’une modification du service.
>
> [Retrouver le calcul dans la démonstration](../../modules/semaine-10-classification-modeles-avances/demonstrations.llms.md#modele).

> **NOTE:**
>
> Faites l’[exercice 2](../../modules/semaine-10-classification-modeles-avances/exercices.llms.md#exercice-2) sur les ruptures de stock.

## Capsule 3 - Lire une matrice de confusion

## PDF

[Ouvrir le PDF](media/pdf/capsule-03-support.pdf) · [Télécharger le PDF](media/pdf/capsule-03-support.pdf)

## HTML

[Ouvrir le diaporama HTML](media/qmd/capsule-03-support.llms.md)

### Activité 10.3

Sur la validation, construisez les matrices aux seuils 0,30 et 0,50. Calculez sensibilité, spécificité, précision et proportion ciblée; expliquez les deux types d’erreur.

Auto-vérification : Je vérifie la classe positive. Je distingue faux positifs et faux négatifs. Je précise les dénominateurs et les mesures éventuellement indéfinies.

> **TIP:**
>
> Au seuil de 0,30, on compte 30 VP, 19 FP, 71 VN et 10 FN. La sensibilité vaut 30/40, la spécificité 71/90, la précision 30/49 et la part ciblée 49/130. Au seuil de 0,50, on compte 17 VP, 7 FP, 83 VN et 23 FN. Les quatre rapports deviennent 17/40, 83/90, 17/24 et 24/130.
>
> [Retrouver le calcul dans la démonstration](../../modules/semaine-10-classification-modeles-avances/demonstrations.llms.md#matrices).

> **NOTE:**
>
> Conservez vos deux matrices. L’exercice 3 sur les succursales vient après la capsule 4, une fois les coûts expliqués.

## Capsule 4 - Choisir une règle avant le test

## PDF

[Ouvrir le PDF](media/pdf/capsule-04-support.pdf) · [Télécharger le PDF](media/pdf/capsule-04-support.pdf)

## HTML

[Ouvrir le diaporama HTML](media/qmd/capsule-04-support.llms.md)

### Activité 10.4

Sur la validation seulement, comparez les deux seuils avec un coût fictif de 4 unités par faux négatif et 1 par faux positif. Retenez le seuil au plus faible coût, avec 0,30 en cas d’égalité.

Auto-vérification : Je fixe les coûts et les seuils avant la comparaison. Je n’utilise pas le test pour choisir le seuil. Je présente le coût comme une hypothèse pédagogique.

> **TIP:**
>
> La validation donne 19 + 4 × 10 = 59 unités au seuil de 0,30 et 7 + 4 × 23 = 99 unités au seuil de 0,50. On fixe donc le seuil à 0,30 parmi ces deux candidats pour les coûts indiqués. Le test reste réservé à l’évaluation.
>
> [Retrouver le calcul dans la démonstration](../../modules/semaine-10-classification-modeles-avances/demonstrations.llms.md#validation).

> **NOTE:**
>
> Faites l’[exercice 3](../../modules/semaine-10-classification-modeles-avances/exercices.llms.md#exercice-3) et fixez le seuil du transfert avant d’ouvrir son test.

## Capsule 5 - Évaluer et recommander

## PDF

[Ouvrir le PDF](media/pdf/capsule-05-support.pdf) · [Télécharger le PDF](media/pdf/capsule-05-support.pdf)

## HTML

[Ouvrir le diaporama HTML](media/qmd/capsule-05-support.llms.md)

### Activité 10.5

Appliquez au test le seuil retenu, décrivez la calibration par groupes et examinez la règle alternative préétablie des 15 % de risques les plus élevés. Formulez une recommandation avec deux limites.

Auto-vérification : Je sépare choix en validation et évaluation en test. Je décris la calibration sans la prouver. Je distingue risque de départ et effet d’un contact.

> **TIP:**
>
> Sur le test, le seuil de 0,30 cible 50 clients et détecte 22 des 40 départs. La règle des 15 % en cible 19 et détecte 12 départs. Dans le groupe de risque le plus faible, le risque moyen est de 6,4 % et la fréquence observée de 18,5 % sur 27 personnes. Ces résultats dépendent de la cohorte. Un essai comparatif serait nécessaire pour mesurer l’effet des contacts.
>
> [Retrouver le calcul dans la démonstration](../../modules/semaine-10-classification-modeles-avances/demonstrations.llms.md#test).

> **NOTE:**
>
> Terminez les [exercices 4 et 5](../../modules/semaine-10-classification-modeles-avances/exercices.llms.md#exercice-4) sur la capacité mensuelle et la recommandation.
