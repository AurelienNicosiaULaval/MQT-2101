# Données - Module 05

## Exemples commentés et pratique individuelle

Les exemples commentés utilisent les données simulées déjà présentes dans le cours : `performance_succursales_quebec.csv` pour le service, puis `achalandage_saturation_quebec.csv` pour comparer les formes du module 04.

Les sorties R de la pratique individuelle utilisent `ventes_pme_quebec.csv`, à son chemin d'origine dans `modules/atelier-01-r/data/`. Les tableaux et motifs schématiques indiqués comme fictifs y servent au raisonnement.

## Exercices progressifs, révision du 2 octobre 2026

Les huit exercices utilisent des mini-cas entièrement fictifs, distincts des données et scénarios des capsules. Les petits tableaux sont fournis dans `exercices.qmd`, avec le code R qui les crée. Ils ne décrivent aucune organisation réelle et ne nécessitent aucun nouveau fichier à télécharger.

| Cas | Unité et variables principales | Construction pédagogique |
|---|---|---|
| Ressourcerie | Jour-point de collecte; date, point, code et masse en kg | Deux niveaux mêlés, clé répétée et masse manquante |
| Formation | Atelier-programme; inscriptions et présences | Deux dénominateurs qui donnent des classements inverses |
| Prêt d'équipement | Préparation d'un kit; équipe et durée en minutes | Moyennes proches, distributions différentes |
| Imprimerie | Lot; affiches et coût en dollars canadiens | Explicative en centaines, prédiction de budget et résidu |
| Céramique | Lot; pièces, minutes et rôle fixé | 12 lots d'apprentissage, six de validation; erreurs copiées depuis deux ensembles |
| Bibliothèque | Comptoir; nombre de bornes, attente et type | Direction globale différente de celle visible dans chaque groupe |
| Prototype de formation | Nombre d'essais et temps en secondes | Équations fournies; différences quadratiques et logarithmiques |
| Budget d'impression | Nouveau lot de 1 000 affiches | Reprise du cas d'imprimerie pour distinguer moyenne et nouvelle observation |

Les équations du prototype sont fournies pour les calculs. Un tableau construit avec la quadratique sert seulement à vérifier les formules R; l'ajustement logarithmique sur ce tableau ne prétend pas reproduire les coefficients de l'équation logarithmique donnée.

## Vrai ou faux et choix multiples

`questions-courtes.qmd` fournit 24 questions dans des situations fictives. Les tables, équations et nombres nécessaires sont intégrés aux énoncés. Le cas des casques audio utilise dix appareils construits pour produire une sortie `lm()` et deux intervalles classiques exécutés pendant le rendu. Le cas du séchage utilise 24 charges construites pour montrer une dispersion croissante des résidus. Le tableau de RMSE du service d'archives est explicitement fictif et fourni pour comparer les raisonnements; il ne prétend pas provenir d'un fichier observé.

Le petit tableau de compost est reconstruit dans son corrigé R. Aucun téléchargement n'est nécessaire. Les codes exécutables des corrigés servent à vérifier les réponses après une première tentative sans aide.

Les jeux de données des modules précédents sont conservés. Les compétences restent celles des modules 01 à 04; aucune méthode de séries chronologiques, classification ou régression multiple n'est ajoutée.
