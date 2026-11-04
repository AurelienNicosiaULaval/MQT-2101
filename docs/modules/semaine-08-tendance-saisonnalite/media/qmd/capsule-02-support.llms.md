# Capsule 2 - Ajuster tendance et mois

MQT-2101 - Analyse et modélisation des données


## Pourquoi ça compte

Que représente un coefficient de décembre?

Un indice continu représente la tendance; un facteur mois représente les différences récurrentes.

## Objectifs de la capsule

- Coder temps et mois.
- Ajuster trois structures simples.
- Interpréter pente et référence.

## L’indice progresse, les mois se répètent

1 à 60

indices de l’apprentissage

61 à 72

indices de 2025

Janvier

référence du facteur mois

## Trois questions, trois modèles

- Tendance seule : le niveau augmente-t-il?
- Saison seule : comment les ventes diffèrent-elles selon le mois?
- Tendance avec mois : comment combiner les deux?

## La forme combinée

\\y_t=\beta_0+\beta_1t+\gamma\_{m(t)}+\varepsilon_t.\\

Une pente globale et des écarts mensuels constants en dollars, avec janvier comme référence.

## Le mois est une catégorie

12 mois

11 écarts par rapport à janvier

Non ordonné

janvier comme catégorie de référence

13 coefficients

constante, pente et contrastes

## Lire les coefficients calculés

| Terme              | Estimation | Erreur-type |
|:-------------------|:-----------|:------------|
| Tendance           | 2 884      | 72          |
| Décembre − janvier | 32 705     | 6 026       |

Pente : dollars par unité d’indice, à mois du calendrier égal. Contraste : différence en dollars avec janvier, à indice égal.

## Une interprétation conditionnelle

À indice de temps égal, les ventes prédites de décembre dépassent celles de janvier d’environ 32 705 \$.

Cette différence ne mesure pas un effet causal. Changer la référence réécrit les coefficients sans changer les prévisions.

## Ajuster dans R

``` r
modele_calendrier <- lm(
  ventes ~ indice_temps + mois,
  data = apprentissage,
  contrasts = list(mois = "contr.treatment")
)
```

La préparation complète, les bibliothèques et les données sont fournies dans la démonstration.

## À retenir

Indice

une unité par mois

Référence

interpréter le contraste

Forme

une pente et des écarts mensuels fixes

## Production autonome 8.2

Vérifiez l’indice continu et le facteur mois avec janvier comme référence. Ajustez tendance seule, saison seule et tendance avec mois. Interprétez la pente et le contraste décembre-janvier du modèle combiné, puis nommez une hypothèse de sa forme.

Cette production se réalise une seule fois dans le rapport guidé.

### Auto-vérification

- Mon indice augmente d’une unité par mois et mon facteur n’est pas ordonné.
- Je précise janvier comme référence et les unités des coefficients.
- Je distingue comparaison conditionnelle et effet causal.
