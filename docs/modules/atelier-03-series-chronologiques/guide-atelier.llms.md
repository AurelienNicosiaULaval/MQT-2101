# Guide de la mission - Laboratoire 03

## Une seule mission

Dans un seul rapport Quarto, vérifiez la série et le calendrier, comparez les cinq prévisions sur les mêmes treize semaines, puis recommandez une méthode avec deux mesures, le coût simulé, un intervalle identifié, une limite et une règle de surveillance.

Utilisez le [projet de départ](telechargements/laboratoire-03.zip), avec un seul rapport `rapport-labo-03.qmd`. Les étapes, repères et diapositives reprennent ce même travail. Tentez chaque étape avant d’ouvrir les indices. Un [exemple complet](../../modules/atelier-03-series-chronologiques/demonstrations.llms.md) et son [projet exécutable](telechargements/exemple-laboratoire-03.zip) restent disponibles pour débloquer ou vérifier.

## Auto-vérification de la production

- J’ai précisé l’origine, les dates et les unités.
- Je compare les cinq méthodes sur les mêmes cibles.
- Je distingue l’intervalle du SES et la méthode retenue.
- Ma recommandation cite des résultats, une limite et un suivi.

Les données sont fictives; la demande est en unités de produit par semaine. Une ligne commence un lundi et la demande de toute la semaine n’est connue que le dimanche suivant. Apprentissage : 91 semaines, dernière commençant le 22 septembre 2025. Origine : fin du 28 septembre. Validation : 13 semaines commençant le 29 septembre et se terminant le 28 décembre. Ces données et cette validation sont déjà connues des modules 06 et 07; aucun nouveau test final indépendant n’est créé.

## 1. Auditer et situer

Énoncez la cible, l’unité, le calendrier, l’origine et les 13 semaines de validation. Vérifiez dates distinctes, régularité et valeurs manquantes.

> **TIP:**
>
> Comptez les lignes, dates distinctes, manquants et écarts entre dates triées. Une différence de sept jours et l’absence de doublon vérifient le calendrier ici. Précisez ce que représente le lundi, la fin de la dernière semaine d’apprentissage et la date de la première cible.

## 2. Explorer le passé

Tracez la demande d’apprentissage, décrivez une tendance ou un motif possible et distinguez les promotions observées des informations futures.

> **TIP:**
>
> Tracez les 91 semaines d’apprentissage avec leurs unités. Les promotions connues sur cet historique peuvent être indiquées, sans attribuer automatiquement un effet causal. Le prix et les promotions de validation ne sont pas des prédicteurs disponibles à l’origine.

> **NOTE:**
>
> Montrez la cible, l’origine, le calendrier et le graphique d’apprentissage. Expliquez ce que vous savez déjà sur les cinq candidats et ce qu’une tendance linéaire ajoute. Corrigez une ambiguïté avant la comparaison.

## 3. Émettre cinq prévisions

Émettez à la même origine les cinq prévisions : naïve, moyenne des quatre dernières semaines, SES, naïve saisonnière et tendance linéaire.

| Méthode | Règle ou apport |
|----|----|
| Naïve | Répéter la dernière demande connue |
| MM4 | Répéter la moyenne des quatre dernières semaines connues |
| SES | Estimer le niveau et son initialisation sur l’apprentissage |
| Naïve saisonnière | Répéter les semaines correspondantes à retard 52 |
| Tendance linéaire | Ajuster une droite à l’indice 1 à 91, puis prévoir les indices 92 à 104 |

> **TIP:**
>
> Construisez un calendrier futur avec `seq.Date()` et un indice continu. `mean(tail(..., 4))` est répété aux treize horizons. `ses()` estime le paramètre et l’état initial sur la série d’apprentissage; `snaive()` utilise la fréquence 52 comme retard. `lm(demande ~ indice)` et `predict(..., newdata = futur)` fournissent la tendance. La fréquence 52 ne rend pas le SES saisonnier.

Vous pouvez reprendre les quatre prévisions déjà produites au module 07 en vérifiant leur origine et leurs cibles. Ajoutez la tendance au même tableau.

La tendance seule n’est pas un modèle saisonnier. Le module 08 montre aussi des indicatrices mensuelles; ici, 91 semaines offrent moins de deux cycles de 52 semaines. Il n’est pas demandé d’estimer 52 effets hebdomadaires pour accomplir la mission.

## 4. Comparer et lire l’incertitude

Comparez ME, MAE et RMSE, tracez les erreurs ou les prévisions et interprétez les intervalles à 80 % et 95 % du SES.

> **TIP:**
>
> Joignez les observations seulement après avoir construit les prévisions. Avec `erreur = observe - prevision`, la ME positive indique une sous-prévision moyenne. La MAE vaut `mean(abs(erreur))`; la RMSE vaut `sqrt(mean(erreur^2))`. Les trois sont en unités de produit. Comparez aussi les trajectoires, pas seulement leur rang.
>
> Les colonnes `lower` et `upper` de `ses(..., level = c(80, 95))` donnent deux intervalles de prédiction pour le SES, conditionnels aux hypothèses de son modèle. L’intervalle à 95 % est plus large que celui à 80 % pour le même horizon. Ce ne sont pas automatiquement les intervalles d’une autre méthode.

La validation sert à comparer et à choisir parmi les cinq candidats. Elle ne prouve pas la performance future et ne devient pas indépendante parce qu’on ajoute une méthode. L’ajout de la tendance modifie la liste des candidats utilisée au module 07; il peut donc modifier le classement.

## 5. Décider et surveiller

Calculez les coûts fictifs, justifiez une méthode et rédigez une recommandation avec une limite et une prochaine vérification.

Le scénario pédagogique initial attribue un coût fictif de 18 \$ par unité sous-prévue et de 5 \$ par unité sur-prévue. Ces valeurs ne sont pas des tarifs mesurés. Calculez le coût sur les mêmes treize semaines pour les cinq méthodes.

> **TIP:**
>
> Pour `erreur = observe - prevision`, le coût hebdomadaire fictif est `18 * pmax(erreur, 0) + 5 * pmax(-erreur, 0)`. Additionnez les treize valeurs par méthode. Distinguez la méthode que vous retenez, les intervalles du SES, les limites du scénario et les informations de stock manquantes.

Une prévision et un coût illustratif ne déterminent pas à eux seuls une commande ou un stock optimal. Il faudrait notamment connaître stock initial, délais, capacité, disponibilité et coûts réels. Proposez une surveillance aux prochaines origines et une action si les erreurs changent.

## Rapport et relecture

Dans `rapport-labo-03.qmd`, rassemblez la question et le protocole, les contrôles et le graphique, les cinq prévisions, les mesures et les coûts, l’intervalle identifié, la recommandation et un court bilan de rétroaction. Gardez les résultats lisibles et le code nécessaire à leur reproduction.

| Critère | Pour vérifier |
|----|----|
| Calendrier | Cible, unités, origine, horizon et distinction début/fin de semaine |
| Comparaison | Cinq prévisions sur les mêmes cibles, sans information future |
| Interprétation | ME, MAE, RMSE et coût expliqués dans leurs unités |
| Incertitude et décision | Méthode de l’intervalle nommée, hypothèses, limite et suivi |
| Reproductibilité | Le rapport se rend en session neuve, avec les fichiers fournis |

Avant le rendu final, une autre personne indique un point réussi et une amélioration précise. Corrigez ou justifiez votre choix et notez l’aide utilisée. Redémarrez R, faites Render et vérifiez le HTML. Conservez le dossier complet.

## Point de contrôle et compléments

Le point de contrôle porte sur votre projet autonome de [mini-rapport 2](../../evaluations/mini-rapport-2.llms.md). Pour la voie temporelle, apportez cible, origine, horizon et validation; pour la voie classification, reprenez le [parcours anticipé](../../modules/semaine-10-classification-modeles-avances/index.llms.md#parcours-anticipe). Les consignes de l’évaluation restent la référence.

Si vous avez terminé, examinez [Holt et ses intervalles](../../modules/atelier-03-series-chronologiques/demonstrations.llms.md#holt), puis les [exercices mensuels](../../modules/atelier-03-series-chronologiques/exercices.llms.md). Le [cahier du module 07](../../modules/semaine-07-lissage/complements.llms.md) conserve ETS, Holt-Winters, BATS, TBATS et STL avec ETS; celui du [module 08](../../modules/semaine-08-tendance-saisonnalite/complements.llms.md) conserve les autres formes et décompositions. Ces compléments sont facultatifs.
