# Repères préparatoires - Laboratoire 03

## Une seule mission

Dans un seul rapport Quarto, vérifiez la série et le calendrier, comparez le naïf saisonnier et le modèle avec tendance et mois sur les mêmes douze mois, puis recommandez une méthode avec deux mesures, le coût simulé, un intervalle identifié, une limite et une règle de surveillance.

- J’ai précisé l’origine, les dates et les unités.
- Je compare les deux méthodes sur les mêmes douze cibles.
- Je nomme la méthode de l’intervalle et ses hypothèses.
- Ma recommandation cite des résultats, une limite et un suivi.

## Du module 07 à la nouvelle situation

Le module 07 comparait quatre prévisions sur la demande hebdomadaire. L’ajout d’un candidat ou un coût fictif des écarts peut modifier une recommandation de stock; reprenez la [comparaison accompagnée](../../modules/atelier-03-series-chronologiques/demonstration-hebdomadaire.llms.md#decision) sans refaire les calculs. La mission utilise une nouvelle série mensuelle fictive. Ses 60 premiers mois servent à l’apprentissage; les douze suivants servent à comparer et non à confirmer indépendamment le choix.

## Repères utiles

Le naïf saisonnier reprend les mois correspondants de l’année précédente. Le modèle combiné ajoute une tendance et des écarts mensuels; son indice doit continuer en 2025. La ME, la MAE et la RMSE s’expriment en nombre de livraisons. Un intervalle de prédiction est associé à une méthode et dépend de ses hypothèses. Les coûts de 2 \$ et 1 \$ par livraison d’écart sont fictifs.

## Auto-diagnostic

1.  Pourquoi une validation utilisée pour choisir n’est-elle pas un test final indépendant?
2.  Quelle mesure donne davantage de poids aux grandes erreurs?
3.  Un intervalle mensuel à 95 % garantit-il l’ensemble des douze mois?

> **TIP:**
>
> 1.  Le choix a utilisé les mêmes résultats. 2. La RMSE. 3. Non, chaque intervalle est marginal et dépend des hypothèses du modèle.

Retrouvez les [étapes de la mission](../../modules/atelier-03-series-chronologiques/guide-atelier.llms.md), la [démonstration](../../modules/atelier-03-series-chronologiques/demonstrations.llms.md) et les [lectures](../../modules/atelier-03-series-chronologiques/lectures.llms.md). La [comparaison hebdomadaire antérieure](../../modules/atelier-03-series-chronologiques/demonstration-hebdomadaire.llms.md) reste disponible pour révision.
