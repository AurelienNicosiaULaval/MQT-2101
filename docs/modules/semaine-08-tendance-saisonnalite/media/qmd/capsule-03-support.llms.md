# Capsule 3 - Lire les résidus

MQT-2101 - Analyse et modélisation des données


## Pourquoi ça compte

Qu’est-ce que le modèle laisse encore dans la série?

Un modèle peut décrire les moyennes mensuelles et laisser une structure importante dans ses écarts.

## Objectifs de la capsule

- Distinguer observation, ajustement et résidu.
- Examiner l’ordre temporel et la dispersion des résidus.
- Nommer une limite qui reste à vérifier.

## Le signe du résidu

\\r_t=y_t-\widehat y_t.\\

r \> 0

ajustement trop bas

r \< 0

ajustement trop haut

Apprentissage

données ayant servi à ajuster

## Examiner l’ordre temporel

![](capsule-03-support_files/figure-html/m08-c3-temps-1.png)

## Examiner la dispersion

![](capsule-03-support_files/figure-html/m08-c3-dispersion-1.png)

## Ce que les indicatrices imposent

Avec les indicatrices mensuelles, les sommes de résidus par mois sont nulles sur l’apprentissage, à l’arrondi près.

Constater cette propriété ne prouve pas que la saisonnalité future est stable.

## Ce qui reste à regarder

- Courbure et dispersion qui changent.
- Événement inhabituel ou séquences de même signe.
- Information commerciale manquante.
- Dépendance temporelle: approfondissement au module 09.

## À retenir

Résidu

écart après ajustement

Graphiques

temps et dispersion

Limite

une moyenne nulle ne suffit pas

## Production autonome 8.3

Examinez les résidus du modèle combiné dans le temps et selon les valeurs ajustées. Comparez les résidus moyens par mois des trois modèles. Expliquez pourquoi une moyenne mensuelle presque nulle ne suffit pas à valider la saisonnalité future.

Cette production se réalise une seule fois dans le rapport guidé.

### Auto-vérification

- Je distingue observation, valeur ajustée et résidu.
- J’examine le temps et la dispersion au-delà des moyennes.
- Je sais que les indicatrices imposent des sommes résiduelles mensuelles nulles.
