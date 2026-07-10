# Atelier 03 - Prévoir la demande

> **NOTE:**
>
> Une équipe d’approvisionnement doit prévoir la demande des treize prochaines semaines. Vous devez comparer des références simples, choisir une méthode et traduire les erreurs en risque de stock.

## Résultat attendu

À la fin de l’atelier, votre fichier Quarto contiendra :

- la cible, l’origine et l’horizon;
- un audit de la série;
- un graphique annoté;
- une période test chronologique;
- au moins trois méthodes comparées;
- MAE, RMSE et biais;
- une recommandation de stock et une règle de surveillance.

Temps indicatif en classe : 2 h 30.

## Préparation avant la séance

1.  Téléchargez [`demande_hebdomadaire_quebec.csv`](data/demande_hebdomadaire_quebec.csv).
2.  Relisez les [repères préparatoires](../../modules/atelier-03-series-chronologiques/capsules.llms.md).
3.  Ouvrez un nouveau fichier Quarto et vérifiez qu’il se rend en HTML.
4.  Apportez votre trace des modules 06 à 08.

## Déroulement

Suivez le [guide en classe](../../modules/atelier-03-series-chronologiques/guide-atelier.llms.md), puis utilisez les [démonstrations](../../modules/atelier-03-series-chronologiques/demonstrations.llms.md) uniquement pour débloquer une étape. Les [exercices](../../modules/atelier-03-series-chronologiques/exercices.llms.md) servent à consolider et à vérifier la trace finale.

## Lien avec le mini-rapport 2

Cet atelier est le point de contrôle pédagogique du [mini-rapport 2](../../evaluations/mini-rapport-2.llms.md). Apportez une question, une cible et une première idée de jeu de données si vous souhaitez vérifier que votre projet respecte la logique de prévision et de validation temporelle.

## Critères de réussite

Aucune information future n’entre dans l’entraînement.

Les méthodes utilisent la même période test.

Une référence naïve est incluse.

La méthode retenue est justifiée par les données et la décision.

La recommandation reconnaît l’incertitude et le coût des erreurs.

> **NOTE:**
>
> Après avoir produit votre première comparaison, vous pouvez demander au GPT du cours de relever une fuite temporelle possible ou une incohérence entre mesure et recommandation. Vous devez vérifier puis documenter la correction retenue.
