# Synthèse - Tendance et saisonnalité

MQT-2101 - Analyse et modélisation des données


## Pourquoi ça compte

Comment tenir compte de la tendance et des saisons pour planifier?

Une tendance linéaire, des effets mensuels et une comparaison commune permettent de préparer une décision prudente.

## Objectifs du module

- Lire les motifs dans le passé.
- Ajuster et interpréter tendance et mois.
- Diagnostiquer, comparer et communiquer.

## Le protocole

60 mois

apprentissage de 2020 à 2024

12 mois

validation sur 2025

Origine

fin décembre 2024

## Une formule simple

\\y_t=\beta_0+\beta_1t+\gamma\_{m(t)}+\varepsilon_t.\\

- Un indice temporel continu.
- Un facteur mensuel, janvier comme référence.
- Une pente globale et des écarts en dollars.

## Trois modèles, une référence

Tendance

hausse sans mois

Saison

mois sans hausse

Combiné

hausse et mois, comparés au naïf saisonnier

## Interpréter sans causalité

- Pente : dollars par unité d’indice, à mois du calendrier égal.
- Décembre : différence avec janvier à indice égal.
- Changer la référence réécrit les coefficients, sans changer les prévisions.

## Examiner les résidus

- Ordre temporel et dispersion.
- Les indicatrices imposent des sommes mensuelles nulles.
- Cette moyenne nulle ne prouve pas la stabilité future de la saisonnalité.

## Prévoir avant de mesurer

- Les indices futurs continuent de 61 à 72.
- Le calendrier est connu, les ventes ne le sont pas.
- Les quatre candidats partagent les mêmes cibles et informations.

## Lire les scores dans le contexte

Guidé

calendrier : MAE ≈ 9 891 \$

Transfert

calendrier : MAE ≈ 32 389 \$

Validation

choix provisoire, sans test indépendant

## Communiquer les limites

- Intervalle de confiance pour la moyenne; intervalle de prédiction pour une observation.
- Intervalles marginaux sous hypothèses.
- Planification et suivi, sans garantie de budget ou de capacité.

## À retenir

Calendrier

coder explicitement

Comparaison

respecter l’origine

Décision

chiffrer et limiter la conclusion

## Les deux traces

Rassemblez les activités 8.1 à 8.5 une seule fois dans tendance_ventes.qmd, puis les cinq exercices dans tendance_commerce.qmd.

### Auto-vérification

- Mes coefficients et scores ont leurs unités.
- Je distingue les deux cas et leurs limites.
- Les rapports se rendent après redémarrage de R.

## Les compléments restent facultatifs

- Formes quadratique et exponentielle: consolidation du module 04.
- Décomposition et harmoniques: autres représentations des saisons.
- Stationnarité et KPSS: ouverture avancée.
- Prix, promotions et autocorrélation: suite au module 09.

## Références et crédits

- Hyndman et Athanasopoulos (2021), Forecasting: Principles and Practice, 3e édition.
- R Core Team: lm, predict.lm et décomposition.
- Données simulées du cours MQT-2101, Université Laval.
- Ancien notebook Amtrak consulté: Paolo Landa (2021).

Les références détaillées et les explications françaises sont dans les lectures et le guide séparé. Les anciens documents protégés ne sont pas redistribués.
