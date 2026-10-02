# Autoévaluation et erreurs fréquentes - Module 05

## Évaluer une compétence à partir d’une réponse

Après les [exercices progressifs](../../modules/semaine-05-preparation-intra/exercices.llms.md), puis la [pratique individuelle](../../modules/semaine-05-preparation-intra/pratique.llms.md), attribuez un état à chaque ligne : acquis si vous répondez et justifiez sans aide; à consolider si le résultat est juste mais le raisonnement hésitant; à reprendre si une correction ou une aide reste nécessaire. Une réussite obtenue après lecture du corrigé sert à apprendre; refaites une question analogue sans aide pour vérifier l’acquisition.

| Je peux… | Preuve à rechercher | Où vérifier | État et action à noter |
|----|----|----|----|
| Nommer l’unité et classer les variables | Jour-point, lot ou inscription; code, date, mesure et unités | Ex. 1 et 2; Q1 | \_\_\_ |
| Diagnostiquer les données | NA comptés, agrégats séparés, clé répétée à vérifier | Ex. 1; Q1 et Q4 | \_\_\_ |
| Choisir et lire tableau et graphique | Question, axes, centre, dispersion et dénominateur | Ex. 2 et 3; Q2 et Q3 | \_\_\_ |
| Lire une droite et une sortie R | Réponse, pente, intercept, unités et test | Ex. 4; Q5 | \_\_\_ |
| Calculer une prédiction et un résidu | Substitution, unité, signe et plage | Ex. 4; Q6 | \_\_\_ |
| Lire R² et corrélation | Variation d’ajustement; association linéaire | Ex. 4 et 8; Q5 | \_\_\_ |
| Utiliser quadratique et logarithme | Carré avec terme simple, x positif, différence de prédictions | Ex. 7; Q8 et Q9 | \_\_\_ |
| Lire les résidus | Motif décrit et vérification justifiée | Ex. 5; Q7 | \_\_\_ |
| Comparer sur les mêmes observations | Même cible, unité, lignes; RMSE de validation | Ex. 5; Q9 | \_\_\_ |
| Distinguer les intervalles | Moyenne ou nouvelle observation; hypothèses | Ex. 8; Q10 | \_\_\_ |
| Conclure avec mesure et prudence | Résultat, décision, diagnostic et limite précise | Ex. 6; Q10 | \_\_\_ |
| Reconstruire l’analyse avec R | Bibliothèques, tableaux et calculs présents dans le fichier; rendu autonome | Ex. 1 à 5 | \_\_\_ |

Les numéros Q renvoient à la pratique individuelle. Pour la reprise, la [série de vrai ou faux et de choix multiples](../../modules/semaine-05-preparation-intra/questions-courtes.llms.md) associe ses 24 questions aux compétences du cours. Cette grille ne calcule pas une note d’examen et ne prédit pas la réussite.

## Vérifier un choix et sa justification

Après la série courte, distinguez le verdict ou la lettre de l’argument. Une lettre correcte obtenue par élimination incertaine ne suffit pas pour déclarer la compétence acquise.

| Je peux… | Trace à garder |
|----|----|
| Corriger un vrai ou faux erroné | La phrase corrigée et le détail de l’énoncé qui la justifie |
| Justifier mon choix multiple | Le résultat pertinent et une explication de l’erreur d’une autre option |
| Situer un calcul | L’unité, le sens du signe et la cible : moyenne ou nouvelle observation |
| Reconnaître une conclusion excessive | Ce que les données permettent de dire et la vérification encore nécessaire |

Reprenez en priorité une réponse fausse donnée avec assurance et une bonne réponse dont vous ne pouvez pas expliquer le raisonnement. Comparez votre nouvelle justification sans aide à celle conservée lors de la première tentative.

## Erreurs fréquentes et correction à apporter

| Erreur | Pourquoi elle pose problème | Réflexe de correction |
|----|----|----|
| « 60 lignes, donc 60 succursales » | Des succursales sont répétées à différents mois | Lire la clé mois-succursale |
| Moyenner un identifiant numérique | Le code distingue des catégories | Revenir au dictionnaire de variables |
| Remplacer NA par zéro ou tout supprimer | Change le sens des données ou perd des lignes utiles | Compter les NA; cibler les variables nécessaires |
| Présenter un score sur 10 comme un pourcentage de personnes | Le score agrégé ne donne pas les réponses individuelles | Nommer le score moyen et sa portée |
| Confondre n total et n disponible | Le résumé peut utiliser moins de valeurs | Montrer les deux effectifs |
| Comparer des ventes totales sans examiner le volume | Le classement peut refléter la taille | Justifier un ratio et son dénominateur |
| Choisir un histogramme pour deux variables | Il ne montre pas leur association | Utiliser un nuage de points |
| Inverser `ventes ~ clients` | Change la question et le modèle | Placer la réponse à gauche de `~` |
| Oublier de convertir centaines ou milliers | Multiplie mal la pente ou le scénario | Écrire l’unité de x avant de substituer |
| Lire l’intercept hors de la plage comme une observation | Zéro peut être une extrapolation | Dire ce que b0 signifie algébriquement et sa limite |
| Calculer ajusté moins observé | Inverse le signe du résidu du cours | Écrire e = observé - ajusté |
| « R² = proportion de prédictions correctes » | R² décrit une variation sur l’ajustement | Nommer les données d’ajustement |
| « p = probabilité que H0 soit vraie » | Inverse le conditionnement du test | Interpréter sous H0 et les hypothèses |
| Garder seulement `x^2` ou l’écrire sans `I()` | Ne représente pas la quadratique attendue | Utiliser `y ~ x + I(x^2)` |
| « Le coefficient de x est la pente constante de la quadratique » | x² change également | Soustraire les deux prédictions |
| « Logarithmique = logistique » | Le premier cas transforme x et garde une réponse quantitative | Revenir aux trois formes enseignées au module 04 |
| « Log(x) impose un plateau » | Le logarithme croissant n’est pas borné | Distinguer ralentissement et plafond |
| Retenir le plus grand R² automatiquement | L’ajout de termes augmente mécaniquement l’ajustement | Examiner validation, forme et résidus |
| Comparer apprentissage et validation entre modèles | Les erreurs portent sur des données différentes | Même période et mêmes lignes pour les deux modèles |
| « Résidus moyens nuls, donc toutes les hypothèses sont valides » | La moyenne nulle est une propriété de l’ajustement avec constante | Examiner motifs, groupes et contexte |
| « Petite valeur p, donc cause démontrée » | Le test porte sur une association dans le modèle | Nommer les facteurs possibles et la limite causale |
| Recommander une prédiction très au-delà de la plage | La forme n’y a pas été validée | Donner la plage et demander une nouvelle vérification |

## Trace finale

Conservez vos premières réponses, les corrections expliquées et un plan personnel de trois lignes :

1.  La compétence à reprendre et l’erreur précise observée.
2.  Le passage du cours et l’exercice à refaire.
3.  Une date de reprise, idéalement deux jours plus tard, avec une question analogue sans aide.

Exemple : « J’ai appliqué une pente par cent affiches au nombre d’affiches. Je reprends les unités de la pente au module 03 et l’exercice 4. Deux jours plus tard, je reconstruis une prédiction pour un autre lot sans ouvrir le corrigé. »

## Deux façons de vérifier

Avec R et les ressources : reproduisez les résultats, inspectez le graphique, puis expliquez chaque sortie. Une aide du cours ou le GPT du cours peut clarifier une erreur après une tentative, conformément à la [politique IA](../../ressources/ia.llms.md). Lisez et vérifiez toute aide conservée.

Sans aide ni IA : refaites une question en expliquant le raisonnement avec les unités. Si vous bloquez, notez l’endroit exact puis passez à la suite. Ouvrez le corrigé après la série et retravaillez la compétence ciblée. Cet entraînement est une consigne pédagogique; le matériel autorisé à l’examen est confirmé dans Brio.
