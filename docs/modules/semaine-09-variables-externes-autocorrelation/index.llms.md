# Module 09 - Variables externes et autocorrélation

> **NOTE:**
>
> Les promotions, les prix et les indicateurs économiques peuvent améliorer une prévision, mais seulement si leur valeur future est connue ou peut être scénarisée au moment de prévoir. Les résidus doivent aussi être examinés dans leur ordre temporel : une dépendance restante indique que le modèle laisse de l’information exploitable.

## Continuité du parcours

Le module 08 a modélisé tendance et calendrier à partir du passé de la série. Ici, vous ajoutez des prédicteurs externes, mais vous devez d’abord vérifier qu’ils seront réellement connus, prévus ou scénarisés au moment de la décision.

## Résultat attendu

À la fin du module, vous pourrez :

- distinguer une variable future connue, scénarisée ou inconnue;
- construire une régression de ventes avec facteurs externes;
- interpréter un coefficient sans lui attribuer automatiquement une causalité;
- représenter et tester l’autocorrélation des résidus;
- comparer une régression ordinaire à une régression avec erreurs AR(1);
- formuler une prévision conditionnelle à un scénario.

Temps de travail indicatif : 3 heures.

## Données

Le fichier [`ventes_promotions_quebec.csv`](data/ventes_promotions_quebec.csv) contient 72 mois fictifs de ventes, promotions, prix moyen, budget marketing et indice de confiance.

## Parcours

1.  [Capsules et activités](../../modules/semaine-09-variables-externes-autocorrelation/capsules.llms.md)
2.  [Notes de cours](../../modules/semaine-09-variables-externes-autocorrelation/notes-cours.llms.md)
3.  [Démonstrations R](../../modules/semaine-09-variables-externes-autocorrelation/demonstrations.llms.md)
4.  [Exercices](../../modules/semaine-09-variables-externes-autocorrelation/exercices.llms.md)
5.  [Lectures ciblées](../../modules/semaine-09-variables-externes-autocorrelation/lectures.llms.md)

## Trace finale

Comparez un modèle de régression avec variables externes et une version avec erreurs AR(1), sur les douze derniers mois. Incluez : justification des prédicteurs, statut de disponibilité future, diagnostic des résidus, MAE test, scénario de promotion et limite causale.

## Auto-vérification

Chaque prédicteur serait réellement disponible au point d’origine ou fait l’objet d’un scénario explicite.

La période test suit l’entraînement.

Les résidus sont examinés dans l’ordre du temps.

Une association de promotion n’est pas présentée comme un effet causal prouvé.

La prévision est identifiée comme conditionnelle au scénario des prédicteurs.

## Lien avec l’évaluation

Ce module prépare les questions du final sur les variables externes, les diagnostics temporels et la validité d’une prévision conditionnelle.
