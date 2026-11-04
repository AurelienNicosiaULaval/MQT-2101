# Guide de la mission - Laboratoire 03

## Une seule mission

Dans un seul rapport Quarto, vérifiez la série et le calendrier, comparez le naïf saisonnier et le modèle avec tendance et mois sur les mêmes douze mois, puis recommandez une méthode avec deux mesures, le coût simulé, un intervalle identifié, une limite et une règle de surveillance.

Utilisez le [projet de départ](telechargements/laboratoire-03.zip). Les cartes, repères et présentation décrivent la même production dans `rapport-labo-03.qmd`. Essayez chaque étape avant d’ouvrir les indices ou la [démonstration complète](../../modules/atelier-03-series-chronologiques/demonstrations.llms.md).

## Auto-vérification

- J’ai précisé l’origine, les dates et les unités.
- Je compare les deux méthodes sur les mêmes douze cibles.
- Je nomme la méthode de l’intervalle et ses hypothèses.
- Ma recommandation cite des résultats, une limite et un suivi.

Les 72 mois sont simulés. Les 60 mois de 2020 à 2024 servent à l’apprentissage; la fin de décembre 2024 est l’origine et les douze mois de 2025 servent à comparer. Le bloc utilisé pour choisir n’est pas un test final indépendant.

Avant la mission, reprenez brièvement vos résultats du module 07 et la [comparaison hebdomadaire accompagnée](../../modules/atelier-03-series-chronologiques/demonstration-hebdomadaire.llms.md#decision) : pourquoi l’ajout d’une tendance ou un coût fictif des écarts peut-il modifier une recommandation de stock? Il n’est pas nécessaire de refaire les quatre prévisions.

## 1. Auditer et situer

Énoncez la cible, l’unité, l’origine et les douze mois de validation. Vérifiez dates, régularité et valeurs manquantes.

> **TIP:**
>
> Triez les dates et comptez les valeurs manquantes et les doublons. Un indice entier d’année et de mois permet de vérifier que deux mois consécutifs diffèrent de 1.

## 2. Explorer le passé

Tracez les 60 mois d’apprentissage et comparez les profils mensuels par année. Décrivez la tendance, la saison et une limite.

> **TIP:**
>
> Tracez la série d’apprentissage et les profils par mois pour chaque année. Un motif récurrent et une tendance ne démontrent pas une cause.

## 3. Construire les prévisions

Construisez le calendrier futur et comparez le naïf saisonnier à une régression avec tendance et mois, à la même origine. Interprétez la pente et le mois de référence.

> **TIP:**
>
> Le naïf saisonnier reprend les valeurs de 2024. L’indice de la régression continue de 60 à 61, puis jusqu’à 72; utilisez les mêmes niveaux de facteur dans le futur.

## 4. Comparer et lire l’incertitude

Calculez ME, MAE et RMSE sur les mêmes douze mois et interprétez un intervalle de prédiction du modèle combiné.

> **TIP:**
>
> Joignez les observations après avoir construit les prévisions. Calculez ME, MAE et RMSE en livraisons. L’intervalle de prédiction du modèle combiné dépend de ses hypothèses et ne garantit pas simultanément toute l’année.

## 5. Décider et surveiller

Comparez les coûts fictifs et formulez une recommandation avec une limite et une prochaine vérification.

> **TIP:**
>
> Avec erreur = observé − prévu, calculez `2 * pmax(erreur, 0) + pmax(-erreur, 0)` : ce sont des coûts fictifs en dollars. Une prévision ne suffit pas pour choisir une flotte optimale.

## Rapport et relecture

Gardez la question et le protocole, les contrôles, le graphique, les deux prévisions et leurs mesures, l’intervalle, les coûts, la recommandation et un court bilan de rétroaction. Demandez une relecture, corrigez ou justifiez un point, puis redémarrez R et rendez le rapport.

## Point de contrôle du mini-rapport 2

Pour la voie temporelle, préparez cible, origine, horizon, référence et validation. Pour la voie classification, préparez événement, date de décision, variables disponibles, séparation et règle de choix du seuil. Les [consignes du mini-rapport](../../evaluations/mini-rapport-2.llms.md) restent la référence. Les résultats de ce laboratoire ne remplacent pas une analyse autonome.
