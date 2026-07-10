# Aide-mémoire statistique

# Aide-mémoire statistique

Cette page résume les notions à mobiliser avant d'interpréter un tableau, un graphique, une régression ou une prévision.

[Décrire](#decrire) [Associer](#associer) [Incertitude](#incertitude)

01

Décrire avant de modéliser

02

Distinguer association et causalité

03

Vérifier les résidus et les limites

04

Interpréter pour une décision

## Décrire une variable

Les statistiques descriptives résument les données observées. Elles ne suffisent pas à expliquer une cause.

### Moyenne

Valeur moyenne observée. Elle est sensible aux valeurs extrêmes.

R

    mean(variable, na.rm = TRUE)

### Médiane

Valeur qui sépare les observations en deux groupes de même taille. Elle est plus robuste aux valeurs extrêmes.

R

    median(variable, na.rm = TRUE)

### Écart-type

Mesure de dispersion autour de la moyenne. Son unité est la même que celle de la variable.

R

    sd(variable, na.rm = TRUE)

## Association, prédiction et causalité

Une analyse peut décrire une relation ou améliorer une prédiction sans démontrer une relation causale. La conclusion doit donc correspondre au plan d'analyse et aux données disponibles.

### Description

Dire ce qui est observé dans les données : moyenne, distribution, tendance ou différence entre groupes.

### Association

Décrire comment deux variables varient ensemble, sans conclure automatiquement à une cause.

### Prédiction

Évaluer si un modèle améliore la capacité à prévoir une valeur future ou inconnue.

### Causalité

Exige un raisonnement supplémentaire sur le plan d'étude, les variables confondantes et l'identification.

## Lire une régression

Une sortie de régression doit être traduite en unités concrètes.

1.  01

    ### Signe

    Le coefficient est-il positif, négatif ou près de zéro?

2.  02

    ### Unité

    Quelle variation de la variable réponse correspond à une unité de la variable explicative?

3.  03

    ### Incertitude

    L'estimation est-elle précise ou très incertaine?

4.  04

    ### Limites

    Quelles hypothèses ou particularités des données limitent l'interprétation?

## Résidus, erreur et incertitude

Un modèle utile n'est pas seulement un modèle qui produit une valeur ajustée. Il doit aussi être vérifié : qualité des résidus, performance de prédiction, stabilité et interprétation prudente.

### Résidu

Différence entre une valeur observée et la valeur ajustée par le modèle.

### Erreur de prévision

Différence entre une valeur observée et une valeur prévue pour une période ou observation non utilisée de la même manière.

### Intervalle

Rappel visuel ou numérique que l'estimation n'est pas une valeur certaine.

### Diagnostic

Vérification graphique ou numérique pour repérer une structure non modélisée.

## Phrases utiles

Une bonne interprétation indique le résultat, son contexte et sa limite.

Interprétation

    Dans ces données, une augmentation de [x] est associée à une variation moyenne de [y].
    Cette relation est utile pour [décision], mais elle ne suffit pas à établir une cause.
    Le résultat doit être interprété avec prudence parce que [limite principale].
