# Guide en classe - Atelier 02

> **NOTE:**
>
> La direction veut savoir quel levier actionner pour augmenter les ventes des succursales : marketing, personnel ou ruptures de stock. Un modèle de régression peut éclairer ce choix, à condition de lire ses coefficients avec prudence. À la fin de la séance, vous aurez une recommandation appuyée sur un modèle et une limite assumée.

> **NOTE:**
>
> Cet atelier se fait après le module 3. Il sert à passer d’une régression linéaire simple à une mini-analyse appliquée : question d’affaires, exploration, modèle, diagnostic et recommandation.

## Objectif du parcours

Question centrale :

> Quels facteurs sont associés aux ventes mensuelles des succursales, et quelle piste d’action peut-on recommander prudemment?

L’objectif n’est pas de trouver une réponse automatique. L’objectif est de produire une analyse claire qui montre ce que le modèle estime, ce que les données suggèrent et ce qu’il faut encore vérifier.

## Ce que vous allez construire

À la fin de l’atelier, vous aurez une mini-analyse Quarto contenant :

- une question d’affaires reformulée;
- une description du tableau;
- un graphique exploratoire;
- un modèle simple;
- un modèle enrichi;
- un diagnostic des résidus;
- une recommandation prudente;
- une limite explicite.

## Organisation du parcours

L’atelier est construit en épisodes courts. Chaque épisode ajoute une pièce à la trace finale. Ne gardez pas seulement le code : écrivez aussi les phrases d’interprétation pendant que les résultats sont encore frais.

1

### Question

Clarifier la décision et les variables.

2

### Données

Comprendre les lignes, les colonnes et les limites.

3

### Graphique

Observer la relation avant le modèle.

4

### Modèles

Ajuster, comparer et interpréter.

5

### Diagnostic

Vérifier les résidus et les limites.

6

### Recommandation

Transformer les résultats en décision prudente.

## Données et préparation

Fichier : [performance_succursales_quebec.csv](../../donnees/#performance-de-succursales-québécoises-fictives).

[Télécharger le fichier CSV](data/performance_succursales_quebec.csv)

``` r
library(tidyverse)

data_path <- if (file.exists("data/performance_succursales_quebec.csv")) {
  "data/performance_succursales_quebec.csv"
} else {
  "modules/atelier-02-regression/data/performance_succursales_quebec.csv"
}

performance <- read_csv(data_path, show_col_types = FALSE)
```

## Étape 1 - Comprendre la question

Avant de coder, écrivez une phrase qui relie l’analyse à une décision.

> **TIP:**
>
> Nous voulons comprendre quels facteurs sont associés aux ventes mensuelles des succursales afin de prioriser une piste d’amélioration à tester.

Variables à repérer :

- `ventes` : variable réponse;
- `achalandage` : volume de clients ou clientes;
- `depenses_marketing` : effort marketing mensuel;
- `heures_personnel` : capacité opérationnelle;
- `ruptures_stock` : contrainte opérationnelle;
- `campagne_locale` : indicateur d’action locale.

> **TIP:**
>
> Écrivez votre propre version de la question en une phrase. Elle doit mentionner les ventes, les succursales et l’idée d’une décision à éclairer.

> **IMPORTANT:**
>
> Avant de continuer, vérifiez que vous pouvez distinguer la variable réponse des variables explicatives. Si ce n’est pas clair, le modèle sera difficile à interpréter.

## Étape 2 - Inspecter le tableau

``` r
glimpse(performance)
```

    Rows: 72
    Columns: 14
    $ mois                  <date> 2025-01-01, 2025-01-01, 2025-01-01, 2025-01-01,…
    $ mois_label            <chr> "janvier", "janvier", "janvier", "janvier", "jan…
    $ saison                <chr> "moyenne", "moyenne", "moyenne", "moyenne", "moy…
    $ succursale            <chr> "Gatineau", "Montréal", "Québec", "Saguenay", "S…
    $ region                <chr> "Outaouais", "Montréal", "Capitale-Nationale", "…
    $ surface_m2            <dbl> 420, 560, 470, 350, 390, 365, 420, 560, 470, 350…
    $ campagne_locale       <chr> "oui", "oui", "non", "non", "oui", "non", "non",…
    $ depenses_marketing    <dbl> 5977, 6162, 4978, 2981, 5061, 3279, 4677, 4693, …
    $ achalandage           <dbl> 1653, 2043, 1864, 1202, 1362, 1369, 1486, 2179, …
    $ heures_personnel      <dbl> 483, 528, 499, 450, 476, 493, 498, 577, 495, 465…
    $ ruptures_stock        <dbl> 1, 1, 2, 1, 0, 1, 0, 1, 6, 3, 0, 2, 1, 0, 1, 2, …
    $ delai_service_minutes <dbl> 5.5, 6.8, 3.8, 5.4, 3.8, 5.5, 5.0, 6.2, 6.5, 5.3…
    $ satisfaction          <dbl> 7.7, 8.0, 7.7, 7.4, 8.7, 8.4, 8.6, 8.3, 7.1, 7.6…
    $ ventes                <dbl> 163260, 180567, 166706, 126460, 151254, 132775, …

``` r
performance |>
  group_by(succursale) |>
  summarise(
    ventes_moyennes = mean(ventes),
    achalandage_moyen = mean(achalandage),
    depenses_moyennes = mean(depenses_marketing),
    ruptures_moyennes = mean(ruptures_stock),
    .groups = "drop"
  ) |>
  arrange(desc(ventes_moyennes))
```

    # A tibble: 6 × 5
      succursale     ventes_moyennes achalandage_moyen depenses_moyennes
      <chr>                    <dbl>             <dbl>             <dbl>
    1 Montréal               183803.             2129.             6216.
    2 Québec                 163630.             1754.             5853.
    3 Gatineau               155196.             1631.             5339.
    4 Sherbrooke             144795.             1529              4520.
    5 Trois-Rivières         144135.             1450.             5045.
    6 Saguenay               133635.             1360.             3977.
    # ℹ 1 more variable: ruptures_moyennes <dbl>

> **NOTE:**
>
> Quelles succursales ont les ventes moyennes les plus élevées? Est-ce que cela semble cohérent avec l’achalandage moyen?

> **TIP:**
>
> Ajoutez à votre trace une phrase qui indique ce que représente une ligne du tableau, puis nommez trois variables qui seront utiles pour la décision.

### Trace finale

Votre mini-analyse doit maintenant contenir la question d’affaires et une courte description des données.

## Étape 3 - Visualiser avant de modéliser

``` r
ggplot(performance, aes(x = achalandage, y = ventes)) +
  geom_point(aes(colour = succursale), alpha = 0.8, size = 2.4) +
  geom_smooth(method = "lm", se = FALSE, colour = "#0B4F6C", linewidth = 1.1) +
  labs(
    title = "Ventes selon l'achalandage",
    x = "Achalandage mensuel",
    y = "Ventes",
    colour = "Succursale"
  ) +
  theme_minimal(base_size = 12) +
  theme(panel.grid.minor = element_blank())
```

![](guide-atelier_files/figure-html/graphique-exploration-guide-1.png)

> **TIP:**
>
> Le nuage de points suggère une relation positive entre achalandage et ventes. Cette observation justifie un premier modèle, mais ne suffit pas à conclure à un effet causal.

> **TIP:**
>
> Écrivez deux phrases : une sur la direction de la relation entre `achalandage` et `ventes`, puis une sur une limite visible ou possible du graphique.

## Étape 4 - Ajuster un modèle simple

``` r
modele_simple <- lm(ventes ~ achalandage, data = performance)

summary(modele_simple)
```


    Call:
    lm(formula = ventes ~ achalandage, data = performance)

    Residuals:
         Min       1Q   Median       3Q      Max
    -18695.7  -4922.6   -294.8   5934.3  18386.3

    Coefficients:
                Estimate Std. Error t value Pr(>|t|)
    (Intercept) 50540.53    5526.11   9.146 1.43e-13 ***
    achalandage    63.12       3.31  19.069  < 2e-16 ***
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 8433 on 70 degrees of freedom
    Multiple R-squared:  0.8386,    Adjusted R-squared:  0.8363
    F-statistic: 363.6 on 1 and 70 DF,  p-value: < 2.2e-16

Notez la pente de `achalandage`.

``` r
pente_achalandage <- coef(modele_simple)["achalandage"]

pente_achalandage
```

    achalandage
       63.12511

> **TIP:**
>
> Dans ce modèle simple, une unité supplémentaire d’achalandage est associée à une augmentation moyenne estimée des ventes de 63.1 dollars. Cette phrase décrit une association moyenne dans les données.

> **WARNING:**
>
> Ne dites pas que l’achalandage cause les ventes. Le modèle estime une association moyenne dans des données observationnelles.

> **TIP:**
>
> Rédigez une phrase qui interprète la pente avec les unités. Commencez par « Dans ce modèle… » pour garder visible le fait que l’interprétation dépend du modèle ajusté.

## Étape 5 - Ajouter des variables de contexte

``` r
modele_enrichi <- lm(
  ventes ~ achalandage + depenses_marketing + heures_personnel + ruptures_stock,
  data = performance
)

summary(modele_enrichi)
```


    Call:
    lm(formula = ventes ~ achalandage + depenses_marketing + heures_personnel +
        ruptures_stock, data = performance)

    Residuals:
        Min      1Q  Median      3Q     Max
    -8940.3 -2956.8  -437.2  2763.3 12110.6

    Coefficients:
                         Estimate Std. Error t value Pr(>|t|)
    (Intercept)         5098.7691  9382.6231   0.543    0.589
    achalandage           34.7889     3.6456   9.543 4.12e-14 ***
    depenses_marketing     5.9455     0.6318   9.411 7.08e-14 ***
    heures_personnel     131.4254    25.6218   5.129 2.68e-06 ***
    ruptures_stock     -1947.2759   404.7535  -4.811 8.89e-06 ***
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 4995 on 67 degrees of freedom
    Multiple R-squared:  0.9458,    Adjusted R-squared:  0.9426
    F-statistic: 292.3 on 4 and 67 DF,  p-value: < 2.2e-16

Dans le modèle enrichi, chaque coefficient se lit en gardant constantes les autres variables du modèle. Cette idée est essentielle pour éviter les interprétations trop rapides.

``` r
tibble(
  modele = c("Simple", "Enrichi"),
  r_carre = c(summary(modele_simple)$r.squared, summary(modele_enrichi)$r.squared),
  r_carre_ajuste = c(
    summary(modele_simple)$adj.r.squared,
    summary(modele_enrichi)$adj.r.squared
  )
)
```

    # A tibble: 2 × 3
      modele  r_carre r_carre_ajuste
      <chr>     <dbl>          <dbl>
    1 Simple    0.839          0.836
    2 Enrichi   0.946          0.943

> **NOTE:**
>
> Est-ce que le modèle enrichi améliore assez l’ajustement pour justifier une interprétation plus complexe? Notez un avantage et une limite du modèle enrichi.

> **TIP:**
>
> Remplissez une mini-grille avec trois colonnes : modèle simple, modèle enrichi, ce que cela change dans l’interprétation.

## Étape 6 - Diagnostiquer le modèle

``` r
performance_modele <- performance |>
  mutate(
    ventes_predites = predict(modele_enrichi),
    residu = residuals(modele_enrichi)
  )
```

``` r
ggplot(performance_modele, aes(x = ventes_predites, y = residu)) +
  geom_hline(yintercept = 0, colour = "#7A1C24", linewidth = 0.9) +
  geom_point(alpha = 0.8, size = 2.4, colour = "#0B4F6C") +
  labs(
    title = "Résidus du modèle enrichi",
    x = "Ventes prédites",
    y = "Résidu"
  ) +
  theme_minimal(base_size = 12) +
  theme(panel.grid.minor = element_blank())
```

![](guide-atelier_files/figure-html/graphique-residus-guide-1.png)

> **NOTE:**
>
> Le graphique des résidus sert à vérifier si les erreurs du modèle semblent réparties autour de zéro. Si un motif clair apparaît, il faut le mentionner dans la limite de l’analyse.

> **TIP:**
>
> Ajoutez une phrase à votre trace : les résidus semblent-ils raisonnablement répartis autour de zéro ou montrent-ils une structure à mentionner?

> **IMPORTANT:**
>
> Une recommandation sans diagnostic est fragile. Avant de rédiger, assurez-vous d’avoir au moins une phrase sur les résidus ou sur une limite du modèle.

## Étape 7 - Choisir une piste prioritaire

Le modèle enrichi peut suggérer plusieurs pistes : achalandage, marketing, capacité de service, ruptures de stock. Votre rôle n’est pas de transformer un coefficient en certitude, mais de choisir une piste raisonnable à tester ou à approfondir.

``` r
coef(modele_enrichi)
```

           (Intercept)        achalandage depenses_marketing   heures_personnel
           5098.769070          34.788875           5.945467         131.425422
        ruptures_stock
          -1947.275885

> **TIP:**
>
> Choisissez une variable prioritaire. Justifiez-la avec un résultat du modèle et un élément de contexte. Ajoutez immédiatement une limite.

## Étape 8 - Rédiger la recommandation

Utilisez le modèle pour prioriser une piste, mais gardez l’incertitude visible.

Modèle de paragraphe à adapter

``` markdown
Les données suggèrent que [facteur prioritaire] est associé aux ventes mensuelles.
Dans le modèle, [résultat chiffré ou direction de l'effet] indique que ce facteur
mérite une attention particulière. Je recommande donc de [action prudente à tester
ou à approfondir]. Cette recommandation doit rester prudente, car les données sont
observationnelles et le modèle ne prouve pas à lui seul une relation causale.
Une prochaine étape serait de [validation ou analyse complémentaire].
```

> **TIP:**
>
> Rédigez cinq à sept lignes. Votre recommandation doit nommer le facteur prioritaire, le résultat qui l’appuie, l’action prudente à tester et une limite.

## Étape 9 - Mise en commun

En petits groupes, comparez vos recommandations. Cherchez surtout les différences d’interprétation :

- avez-vous choisi le même facteur prioritaire?
- avez-vous utilisé le même argument statistique?
- avez-vous nommé la même limite?
- votre recommandation dépasse-t-elle ce que les données permettent de dire?

Après la mise en commun, ajustez votre recommandation si un autre groupe a repéré une limite ou une formulation plus prudente.

## Gabarit minimal pour votre mini-analyse

Structure Quarto à copier

``` markdown
---
title: "Atelier 02 - Régression"
format:
  html:
    embed-resources: true
---

## Question d'affaires

## Données

## Exploration

## Modèle simple

## Modèle enrichi

## Diagnostic

## Recommandation prudente
```

## Trace finale

Votre trace finale doit être courte, mais complète. Elle doit contenir :

1.  la question d’affaires;
2.  une description minimale des données;
3.  un graphique exploratoire;
4.  un modèle simple ou enrichi;
5.  une interprétation de coefficient;
6.  un diagnostic des résidus;
7.  une recommandation prudente;
8.  une limite et une prochaine vérification.

## Grille formative

La question d’affaires est claire.

Le graphique est interprété avant le modèle.

Le modèle est écrit avec `lm()`.

Au moins un coefficient est interprété avec les unités.

Le modèle enrichi est comparé au modèle simple.

Les résidus sont commentés.

La recommandation est prudente et orientée vers l’action.

La limite causale est explicite.

## Auto-vérification assistée par IA

Vous pouvez demander au [GPT du cours](https://chatgpt.com/g/g-6a0b2ec33d948191ad25b2f247b15de1-analyse-et-modelisation-des-donnees?ref=mini) de relire votre trace. Demandez-lui de vérifier la structure, la reproductibilité du code, l’interprétation de la pente, le diagnostic et la prudence de la recommandation. Ne lui demandez pas de rédiger la recommandation finale à votre place.

Suggestion de demande :

> Voici ma trace finale de l’atelier 02. Vérifie si la question, le graphique, le modèle, l’interprétation de coefficient, le diagnostic des résidus, la recommandation et la limite sont présents et cohérents. Donne-moi une rétroaction concrète sans réécrire mon texte.

## Fin de l’atelier

Avant de quitter, vérifiez que votre fichier contient :

- au moins un graphique;
- au moins un modèle ajusté avec `lm()`;
- une interprétation de coefficient;
- un diagnostic des résidus;
- une recommandation qui ne confond pas association et causalité.
