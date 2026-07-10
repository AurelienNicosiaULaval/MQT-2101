# Exercices - Atelier 01

## Objectif

Ces exercices accompagnent le travail en classe. Ils servent à produire les éléments du court rapport Quarto attendu.

Ils ne forment pas un deuxième parcours séparé. Ils correspondent aux moments « À vous » du [guide complet de l’atelier](guide-atelier.llms.md) : après avoir vu une démonstration, vous faites l’exercice associé, puis vous gardez le résultat utile dans votre trace finale.

> **NOTE:**
>
> Pendant la séance, ouvrez d’abord le guide complet. Utilisez cette page comme liste de vérification des productions attendues : description du tableau, dictionnaire, diagnostic des valeurs manquantes, tableau synthèse, graphiques, constats et recommandation.

## Exercice 1 - Décrire le tableau

À partir de [ventes_pme_quebec.csv](../../donnees/#ventes-mensuelles-dune-pme-québécoise-fictive) :

- importez le fichier;
- indiquez le nombre de lignes et de colonnes;
- nommez l’unité d’observation;
- classez cinq variables selon leur type.

## Exercice 2 - Construire un dictionnaire rapide

Produisez un tableau qui contient, pour chaque variable :

- le nom de la variable;
- son type;
- le nombre de valeurs manquantes;
- un exemple de valeur observée.

À écrire :

- cinq variables utiles pour une décision de gestion;
- le rôle de chacune : performance commerciale, clientèle, marketing, opérations ou satisfaction.

## Exercice 3 - Diagnostiquer les valeurs manquantes

Produisez un tableau qui indique, pour chaque variable, le nombre de valeurs manquantes.

À écrire :

- quelles variables sont touchées;
- pourquoi cela peut influencer certains indicateurs;
- la précaution à prendre dans les résumés.

Comparez aussi au moins une moyenne calculée avec et sans `na.rm = TRUE`, puis expliquez pourquoi le résultat change ou devient manquant.

## Exercice 4 - Résumer par succursale

Produisez un tableau synthèse par succursale contenant :

- les ventes totales;
- le nombre total de clients;
- le panier moyen;
- la satisfaction moyenne;
- le délai moyen de livraison;
- le nombre total de ruptures de stock.

À écrire :

- deux résultats qui ressortent du tableau;
- une limite de comparaison.

## Exercice 5 - Produire deux graphiques

Graphique obligatoire :

- ventes totales par succursale.

Graphique au choix :

- satisfaction et ruptures de stock;
- ventes et dépenses marketing;
- satisfaction et délai de livraison;
- ventes selon la saison.

Chaque graphique doit avoir un titre, des axes clairs et une phrase d’interprétation.

## Exercice 6 - Choisir une priorité de prochaine analyse

La direction hésite entre trois priorités :

- marketing;
- opérations;
- saisonnalité.

Choisissez une seule priorité et appuyez-la avec un tableau ou un graphique.

À écrire :

- la priorité choisie;
- le résultat descriptif qui appuie cette priorité;
- une limite d’interprétation;
- ce qu’il faudrait vérifier avec une méthode plus avancée.

## Exercice 7 - Préparer la suite

Choisissez une paire de variables qui pourrait être étudiée plus tard avec une régression ou une autre méthode de modélisation.

À écrire :

- la variable à expliquer ou à prévoir;
- la variable explicative envisagée;
- la question descriptive actuelle;
- ce qu’il faudrait vérifier avant d’aller plus loin.

## Trace finale courte

La trace finale attendue est un court rapport Quarto contenant :

- le code d’importation;
- une inspection du tableau;
- un dictionnaire rapide des variables clés;
- un diagnostic des valeurs manquantes;
- un tableau synthèse;
- deux graphiques;
- trois constats descriptifs;
- une limite d’interprétation;
- une recommandation de prochaine analyse.
