# Exercices progressifs - Laboratoire 02

## Parcours essentiel

Suivez une seule analyse dans le [guide](../../modules/atelier-02-regression/guide-atelier.llms.md) :

1.  comprendre les livraisons et séparer les périodes;
2.  ajuster la droite et la quadratique, interpréter et prendre position;
3.  comparer les erreurs sur les livraisons suivantes;
4.  diagnostiquer, traiter l’incident et auditer trois affirmations;
5.  relire et recalculer;
6.  faire la [consolidation](../../modules/atelier-02-regression/consolidation.llms.md).

Les indices aident après une tentative. Les corrections détaillées restent réservées à l’enseignant.

## Prolongements facultatifs

Jeu principal pour les trois prolongements ci-dessous : [livraisons_regionales_quebec.csv](data/livraisons_regionales_quebec.csv), avec son [dictionnaire](data/dictionnaire-livraisons.md).

Le transfert porte ici sur une nouvelle question du même contexte. Choisissez une seule piste après le parcours essentiel.

### 1. Sensibilité à une livraison avec incident

Le parcours essentiel conserve L072. Pour étudier la question différente des livraisons sans panne confirmée, refaites les deux ajustements sur les 71 autres observations d’apprentissage. Gardez les mêmes 24 observations de validation et les mêmes formules.

Comparez les erreurs et les prévisions à 25 et 95 km avant et après. Décrivez ce qui change et ce que cette comparaison ne démontre pas. Conservez aussi les résultats complets; ne supprimez pas L072 du rapport initial.

Trace attendue : petit tableau de sensibilité et trois phrases sur la population visée, la stabilité et la limite.

> **TIP:**
>
> Filtrez uniquement l’apprentissage, puis réajustez les deux modèles. La qualité de la mesure de L072 est confirmée. L’exclusion vise une autre population; elle ne se justifie pas par une amélioration numérique à elle seule. Vérifiez aussi la nouvelle plage des distances.

### 2. Une troisième forme et le choix après validation

Le logarithme est déjà enseigné, mais essayer une troisième forme après avoir vu les deux erreurs change la procédure de sélection.

Proposez d’abord, par écrit, une justification du logarithme de la distance et une nouvelle période qui pourrait évaluer ce choix. Vous pouvez ensuite l’ajuster sur l’apprentissage initial et calculer les prédictions sur la validation actuelle, en présentant ce résultat comme une exploration supplémentaire, pas comme une confirmation indépendante.

Trace attendue : protocole annoncé, calcul exploratoire et limite de sélection.

> **TIP:**
>
> Vérifiez les distances strictement positives. Seule l’explicative est transformée; la réponse et les erreurs restent en minutes.

### 3. Le classement global résiste-t-il aux centres?

Avec les deux modèles essentiels inchangés, calculez les RMSE de validation par centre. Donnez les effectifs et comparez le classement local au classement global. Ne réajustez pas un modèle par centre.

Trace attendue : tableau par centre et phrase expliquant pourquoi six observations par centre donnent une comparaison limitée.

> **TIP:**
>
> Créez les deux colonnes de prédictions avec `predict()`, puis utilisez `group_by(centre)` et `summarise()`. Les petits groupes et le contexte ne permettent pas de conclure qu’un centre est causalement responsable des écarts.

### 4. Transfert à une question de service

Jeu de données de transfert : [performance_succursales_quebec.csv](data/performance_succursales_quebec.csv).

Ce jeu complémentaire est conservé dans le cours, mais il n’est plus celui de la mission. Posez une question différente des ventes des capsules : le délai de service en minutes selon l’achalandage en milliers de visites. Une ligne est un mois d’une succursale.

Fixez janvier à septembre pour l’apprentissage et octobre à décembre pour la validation. Comparez droite et quadratique sur les mêmes lignes; calculez les deux RMSE en minutes. N’imposez pas le classement obtenu sur les livraisons. Interprétez la pente pour 100 visites, la différence de deux prédictions de la courbe et une limite des mois répétés.

Trace attendue : un petit tableau, une différence en contexte et trois phrases de conclusion. Si vous choisissez cette piste, elle remplace les autres prolongements.

> **TIP:**
>
> La réponse est `delai_service_minutes`, pas `ventes`. Mettez l’achalandage à l’échelle avant d’ajuster. La validation concerne les mêmes succursales à des mois ultérieurs, pas de nouvelles succursales. Vos comparaisons restent descriptives.
