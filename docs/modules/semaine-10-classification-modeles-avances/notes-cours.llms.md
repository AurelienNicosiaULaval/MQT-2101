# Synthèse | Résultats binaires et classification

## Pourquoi ça compte

Que savons-nous avant d’agir et quelles erreurs pouvons-nous accepter?

Le risque de départ aide à préparer une décision; il ne mesure pas ce qu’un contact changerait.

## Objectifs du module

- Définir une cible binaire et des partitions adaptées.
- Interpréter probabilités, cotes et mesures de classification.
- Choisir puis évaluer une règle avant de recommander une action.

## Cible, unité et séparation

- Un résultat binaire décrit un événement observable avec une classe positive définie.
- La décision précède la réalisation de la cible : chaque prédicteur doit être disponible à cette origine.
- Séparer l’apprentissage, qui estime les coefficients, la validation, qui choisit une règle, et le test, qui l’évalue après fixation.

## Ouvrir les trois enveloppes dans l’ordre

Le tirage répartit les clients à l’intérieur de chaque classe.

| Ensemble | Restent | Partent | Total |
| --- | --- | --- | --- |
| Apprentissage | 271 | 118 | 389 |
| Validation | 90 | 40 | 130 |
| Test | 91 | 40 | 131 |

389 + 130 + 131 = 650 clients. Chaque identifiant apparaît dans un seul ensemble.

## Quel partage pour quatre succursales ?

Une ligne représente désormais une succursale pendant un mois. La cible concerne le mois suivant.

| Usage | Mois de décision |
| --- | --- |
| Ajuster | Janvier 2020 à novembre 2023 |
| Choisir la règle | Janvier à novembre 2024 |
| Évaluer | Janvier à décembre 2025 |

Pourquoi écarter décembre 2024 ? Son étiquette concerne janvier 2025, déjà dans la période de test.

## Logistique, cotes et probabilités

$$p=\frac{1}{1+\exp(-\eta)},\qquad \text{cote}=\frac{p}{1-p}.$$

- $\eta$ est le score linéaire du modèle.
- Pour une unité supplémentaire de $x$, à autres variables fixées, les cotes sont multipliées par $\exp(\beta_1)$.
- Un rapport de cotes n’est pas un rapport de probabilités.

## Du risque à la cote, puis retour

Sur 100 clients comparables, un risque de 20 % correspond à 20 départs attendus.

| Quantité | Calcul | Valeur |
| --- | --- | --- |
| Cote initiale | 20 / 80 | 0,25 |
| Cote doublée | 2 × 0,25 | 0,50 |
| Nouvelle probabilité | 0,50 / (1 + 0,50) | 33,3 % |

Doubler la cote fait passer le risque de 20 % à 33,3 % dans cet exemple.

## Deux fiches pour un seul contraste

Même contrat mensuel, 24 mois d’ancienneté, utilisation 12, satisfaction 7 et aucun rabais.

| Profil | Tickets sur six mois | Risque estimé |
| --- | --- | --- |
| A | 1 | 32,0 % |
| B | 3 | 49,5 % |

Le risque augmente d’environ 17,5 points de pourcentage entre les deux profils.

## Matrice et mesures

- Vrai positif (VP) : départ ciblé; faux négatif (FN) : départ non ciblé.
- Faux positif (FP) : non-départ ciblé; vrai négatif (VN) : non-départ non ciblé.

## Lire les mesures

Sensibilité

$\mathrm{VP}/(\mathrm{VP}+\mathrm{FN})$

Spécificité

$\mathrm{VN}/(\mathrm{VN}+\mathrm{FP})$

Précision

$\mathrm{VP}/(\mathrm{VP}+\mathrm{FP})$

L’exactitude est $(\mathrm{VP}+\mathrm{VN})/N$, où $N$ est le nombre de clients. Un dénominateur nul rend la mesure concernée indéfinie.

## Retrouver les 130 clients de validation

Au seuil de 0,30, complétez les totaux avant de calculer les pourcentages.

| Décision | Départ | Aucun départ | Total |
| --- | --- | --- | --- |
| Ciblé | 30 | 19 | 49 |
| Non ciblé | 10 | 71 | 81 |
| Total | 40 | 90 | 130 |

Une colonne répond à « parmi les départs ». Une ligne répond à « parmi les personnes ciblées ».

## Choisir le bon dénominateur

La même case de 30 vrais positifs répond à deux questions différentes.

| Question | Calcul | Réponse |
| --- | --- | --- |
| Parmi les départs, combien sont détectés ? | 30 / 40 | 75,0 % |
| Parmi les clients ciblés, combien partent ? | 30 / 49 | 61,2 % |
| Parmi les non-départs, combien sont écartés ? | 71 / 90 | 78,9 % |
| Quelle part des clients faut-il contacter ? | 49 / 130 | 37,7 % |

Dire « nous détectons 75 % des départs » précise la population au dénominateur.

## Seuil, coût et capacité

- Le seuil transforme une probabilité en classe.
- Pour des probabilités fixées, abaisser le seuil cible au moins autant de clients et de vrais départs.
- La précision peut augmenter ou diminuer. Les coûts et la capacité guident le choix.

## Facturer les deux types d’erreur

Dans cet exercice, un faux positif coûte une unité et un faux négatif en coûte quatre.

| Seuil | Faux positifs | Faux négatifs | Coût total |
| --- | --- | --- | --- |
| 0,30 | 19 × 1 | 10 × 4 | 59 unités |
| 0,50 | 7 × 1 | 23 × 4 | 99 unités |

Les nombres proviennent de la validation. Les coûts unitaires sont des hypothèses de décision.

## Que change le cas des succursales ?

L’équipe d’intervention choisit sur 44 mois-succursales de validation.

| Seuil | FP | FN | Coût : FP + 4 × FN |
| --- | --- | --- | --- |
| 0,25 | 9 | 6 | 33 |
| 0,50 | 3 | 8 | 35 |

Ici, la marge est de deux unités. Le plafond d’intervention s’applique à chaque mois, à l’échelle du réseau.

## Calibration et action

- Une calibration descriptive compare, par groupes de risques prédits, la probabilité moyenne à la fréquence observée.
- Les groupes peuvent être petits et les résultats incertains.
- Le score de Brier résume l’erreur quadratique des probabilités mais ne mesure pas uniquement la calibration.

## Lire un point de calibration

Les clients du test sont ordonnés par risque et répartis en cinq groupes d’effectifs proches.

| Groupe | Clients | Risque moyen | Fréquence observée |
| --- | --- | --- | --- |
| Risques les plus faibles | 27 | 6,4 % | 5 / 27 = 18,5 % |
| Risques les plus élevés | 26 | 57,3 % | 14 / 26 = 53,8 % |

Dans le premier groupe, la fréquence dépasse la prévision moyenne. Avec 27 clients, on ne peut pas présumer que cet écart se reproduira.

## Tenir la promesse de 15 %

Quinze pour cent de 131 vaut 19,65. Vingt contacts dépasseraient le plafond.

| Politique annoncée | Contacts | Départs détectés | Précision |
| --- | --- | --- | --- |
| Seuil 0,30 | 50 | 22 sur 40 | 44,0 % |
| 19 risques les plus élevés | 19 | 12 sur 40 | 63,2 % |

La liste courte concentre davantage les départs, mais elle en laisse 28 hors de la liste.

## À retenir

Probabilité

un risque prédit, sans certitude ni effet causal

Règle

choisir en validation avant d’évaluer sur le test

Décision

coûts, capacité et limites explicités

## Les deux traces

Rassemblez les productions 10.1 à 10.5, réalisées une seule fois, dans `classification_clients.qmd`. Conservez les exercices de transfert dans `classification_service.qmd`.

### Auto-vérification

- Je distingue probabilité, cote et classe prédite.
- Je sépare le choix en validation de l’évaluation sur le test.
- Je justifie les coûts, la capacité et les limites.
- Mes rapports se rendent après redémarrage de R.

## Références et crédits

James, Witten, Hastie et Tibshirani (2021), *An Introduction to Statistical Learning*, 2e édition.

Données fictives du cours MQT-2101, Université Laval.
