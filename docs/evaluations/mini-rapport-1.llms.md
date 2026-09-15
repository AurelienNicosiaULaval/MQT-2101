# Mini-rapport 1 - Exploration et régression

## Objectif et pondération

Produire en équipe une analyse reproductible allant de la compréhension des données à une recommandation prudente appuyée par une régression.

Pondération : 15 % de la note finale.

Le travail mobilise les modules 01 à 04 : formuler une question, préparer les données, explorer une relation, comparer des régressions et communiquer une conclusion. Les rétroactions du laboratoire 01 vous aident à améliorer votre démarche et votre rapport Quarto.

## Pour commencer

1.  Formez une équipe de 2 ou 3 personnes.
2.  Choisissez une question liée à une décision et un jeu de données adapté à la régression.
3.  Téléchargez le [dossier de départ et le gabarit](../ressources/gabarit-mini-rapport-1.llms.md), puis faites un premier rendu dans RStudio.
4.  Complétez progressivement l’analyse en vous appuyant sur les attentes ci-dessous et la [grille commune](../evaluations/grille-mini-rapports.llms.md).

## Échéancier pédagogique

- Choix du jeu de données : au plus tard au début du module 04.
- Pour un jeu qui n’est pas déjà autorisé, envoyez votre proposition au plus tard au début du module 04 et obtenez son approbation avant de commencer la modélisation.
- Remise : consulter le [calendrier du cours](../calendrier.llms.md).

Le dépôt se fait dans l’évaluation « Mini-rapport 1 - Exploration et régression » de Brio. Un seul membre remet l’archive pour l’équipe; le rapport doit identifier tous les membres.

## Modalité

- Équipe de 2 ou 3 personnes.
- Environ 1 200 à 1 600 mots, hors code et références.
- Maximum de quatre figures et tableaux principaux au total. Sélectionnez les sorties utiles et commentez-les dans le texte.
- IA permise avec déclaration selon la [politique du cours](../ressources/ia.llms.md).

## Livrables

Remettre une archive `.zip` contenant :

1.  le fichier source `.qmd`;
2.  le fichier HTML autonome;
3.  le jeu de données autorisé ou un script reproductible d’importation;
4.  un court `README.md` indiquant comment rendre le document;
5.  la déclaration IA, ou la mention explicite « Aucun usage d’IA ayant influencé le livrable »;
6.  une déclaration de contribution d’une phrase par membre.

Les déclarations IA et de contribution peuvent figurer à la fin du rapport, comme dans le gabarit. Incluez aussi les éventuels scripts appelés par le `.qmd`. Le HTML doit contenir les figures et les ressources nécessaires à sa lecture, grâce à `embed-resources: true`.

## Validation des données

Suivez la [procédure de validation](../evaluations/validation-donnees.llms.md). Les jeux identifiés comme simulés pour le cours dans la section [Données](../donnees/index.llms.md) sont déjà autorisés; aucune approbation supplémentaire n’est nécessaire. Pour un autre jeu, soumettez une proposition selon cette procédure.

Choisissez une variable réponse quantitative et des variables explicatives pertinentes pour votre question. Un jeu autorisé n’est pas nécessairement adapté à toutes les questions. Si vous utilisez un jeu du cours, développez votre propre analyse : reprendre le corrigé d’un exercice ne constitue pas le mini-rapport.

Aucun renseignement personnel, confidentiel ou non autorisé ne doit être inclus dans les fichiers remis ou téléversé dans un outil d’IA.

## Contenu attendu

### Question et données

- question d’analyse liée à une décision;
- origine, droit d’utilisation et limites;
- unité d’observation et variables;
- contrôles de qualité et transformations justifiées.

Indiquez le nombre d’observations avant et après la préparation. Expliquez les valeurs manquantes, les exclusions et les transformations qui ont un effet sur votre analyse.

### Exploration

- résumé descriptif ciblé;
- au moins une visualisation répondant à la question;
- distinction entre observation, association et causalité.

### Régression

Présentez un modèle simple de référence et une variante pertinente, puis justifiez le modèle retenu pour répondre à la question. La référence peut être retenue si la variante n’apporte pas d’amélioration utile. La complexité n’est pas un objectif en soi.

- Décrivez la variable réponse, les variables explicatives et la forme de chaque modèle. Par exemple, les modules 03 et 04 permettent de comparer une droite à une relation quadratique ou à une transformation justifiée.
- Comparez les modèles sur les mêmes observations et pour la même variable réponse. Présentez une mesure d’ajustement adaptée, par exemple le R² ou la RMSE, ainsi que les avantages et limites en matière d’interprétation et d’utilité. Un R² calculé pour une réponse transformée, par exemple log(Y), ne se compare pas directement à celui d’un modèle pour Y.
- Interprétez au moins deux coefficients dans le contexte, en précisant les unités et la portée de l’interprétation. Si vous interprétez l’ordonnée à l’origine, indiquez si la valeur zéro des variables explicatives a un sens et se situe dans le domaine observé. Pour une relation quadratique, l’effet de la variable dépend de son niveau : le coefficient du terme au carré n’est pas une variation constante de la réponse.
- Présentez au moins un graphique de diagnostic des résidus, par exemple résidus contre valeurs ajustées pour le modèle retenu. Décrivez ce qu’il montre et discutez une limite concrète du modèle.

Pour ce premier mini-rapport, une séparation apprentissage/test ou une validation croisée n’est pas obligatoire. Une mesure calculée sur les données ayant servi à ajuster le modèle décrit son ajustement; elle ne démontre pas sa performance sur de nouvelles données. Respectez cette limite dans votre conclusion.

### Décision

- recommandation répondant à la question;
- incertitude ou réserve importante;
- prochaine vérification à réaliser avant une décision réelle.

## Grille

La [grille commune des mini-rapports](../evaluations/grille-mini-rapports.llms.md) est appliquée sur 100 points puis convertie en 15 %.

## Vérification avant remise

Le HTML se rend sur un autre ordinateur à partir des fichiers remis.

Le rendu a été refait après redémarrage de R, à partir de l’archive extraite dans un autre dossier.

Les bibliothèques sont chargées explicitement.

Les chemins sont relatifs.

Les modèles comparés portent sur les mêmes observations et la même réponse.

Au moins deux coefficients et un diagnostic des résidus sont interprétés.

Les graphiques comportent titre, axes et unités.

Le rapport respecte la longueur et la limite de quatre figures et tableaux principaux au total.

La conclusion répond à la question sans causalité non démontrée.

Les contributions et l’usage de l’IA sont documentés.

Un membre a déposé le ZIP dans la bonne évaluation Brio et vérifié la présence du fichier remis.

## Gabarit

Utilisez le [gabarit du mini-rapport 1](../ressources/gabarit-mini-rapport-1.llms.md).
