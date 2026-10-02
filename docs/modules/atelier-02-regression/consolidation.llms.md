# Consolidation pour l’intra - Laboratoire 02

Interpréter sans exécuter R

## Premier essai individuel

Répondez aux cinq questions sans R ni IA. Comparez ensuite vos réponses avec celles d’une autre personne et corrigez-les au besoin. Les valeurs sont fictives et ne proviennent pas du CSV du laboratoire. Cette fiche sert à vous entraîner; ce n’est pas un sujet officiel d’examen.

Une droite estime la durée y, en minutes, selon la distance x, en kilomètres :

\\\widehat y = 12 + 1{,}1x.\\

La plage d’apprentissage va de 8 à 60 km. À 25 km, la durée observée est 44 minutes.

### 1. Unités et prédiction

Interprétez la pente pour cinq kilomètres supplémentaires et calculez la durée moyenne estimée à 25 km. Ce modèle permet-il de garantir le temps gagné si l’on raccourcit un itinéraire?

### 2. Résidu et ordonnée à l’origine

Calculez le résidu de la livraison observée à 25 km et interprétez son signe. Que représente l’ordonnée à l’origine, ou intercept? Quelle limite faut-il signaler compte tenu des distances d’apprentissage?

### 3. Comparer l’apprentissage et la validation

| Forme       | RMSE apprentissage (min) | RMSE validation (min) |
|-------------|-------------------------:|----------------------:|
| Droite      |                        5 |                     6 |
| Quadratique |                        4 |                     8 |

Quel modèle privilégier sur cette validation? Pourquoi le classement d’apprentissage ne suffit-il pas? L’écart de RMSE signifie-t-il que chaque livraison sera deux minutes plus rapide?

### 4. Une hausse, deux points de départ

Un autre modèle quadratique fictif estime la durée, en minutes, selon la distance, en kilomètres :

\\\widehat y = 30 + 0{,}7x + 0{,}008x^2.\\

Calculez la hausse de durée prédite de 20 à 25 km, puis de 50 à 55 km. Dans chaque cas, soustrayez la prédiction à la distance la plus courte de celle à la distance la plus longue. Pourquoi le coefficient 0,7 ne suffit-il pas pour obtenir cette hausse?

### 5. Limites d’utilisation

Pour la droite de la question 1, une prédiction à 95 km reste-t-elle dans la plage d’apprentissage? Si les résultats de validation servent à choisir le modèle, peut-on encore les présenter comme un test final indépendant de ce choix? Proposez une vérification à faire ensuite.

## Garder une trace

Notez une erreur corrigée ou un point qui reste à clarifier, puis la notion à revoir au module 05.
