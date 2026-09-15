# Gabarit du mini-rapport 1

# Gabarit du mini-rapport 1

Ce gabarit soutient une analyse reproductible centrée sur la préparation des données, l'exploration, la visualisation, la régression et l'interprétation.

[Télécharger le dossier de départ (.zip)](../assets/exemples/mini-rapport-1.zip) [Télécharger le fichier .qmd](../assets/exemples/mini-rapport-1/mini-rapport-1.qmd) [Consignes](../evaluations/mini-rapport-1.llms.md) [Modèle .qmd](#modele-qmd) [Déclaration IA](declaration-ia.llms.md) [Grille](../evaluations/grille-mini-rapports.llms.md)

01

Question et données

02

Préparation et exploration

03

Visualisation et régression

04

Interprétation et limites

## Structure attendue

Le mini-rapport doit montrer une démarche courte, claire et défendable.

1.  01

    ### Question

    Définir ce que l'analyse cherche à éclairer.

2.  02

    ### Données

    Présenter la source, l'unité d'observation, les variables et les limites.

3.  03

    ### Analyse

    Explorer les données, comparer une référence à une variante et examiner les résidus.

4.  04

    ### Conclusion

    Interpréter les coefficients, recommander une action et préciser les limites.

## Premier rendu dans RStudio

Le dossier contient un projet RStudio, le gabarit QMD, un README et un dossier data/ à compléter.

1.  Téléchargez le ZIP et extrayez-le complètement dans un dossier de travail.
2.  Ouvrez `mini-rapport-1.Rproj`, puis `mini-rapport-1.qmd` dans RStudio.
3.  Cliquez sur *Render*. Si une bibliothèque manque, suivez l'indication du README.
4.  Choisissez vos données autorisées, adaptez le code et remplacez les indications par votre analyse.

Le premier rendu fonctionne sans données et sert à vérifier l'installation. Le gabarit reste à compléter : un HTML produit sans erreur ne signifie pas que le travail est terminé.

Le rapport est réalisé en équipe de 2 ou 3 personnes : environ 1 200 à 1 600 mots hors code et références, avec au maximum quatre figures et tableaux principaux au total.

## Flux de travail recommandé

Travaillez dans Quarto dès le début pour éviter de reconstruire le rapport à la fin.

### Choisir une question précise

La question doit pouvoir être étudiée avec les variables disponibles.

### Nettoyer seulement ce qui est nécessaire

Documentez les transformations importantes et leur justification.

### Interpréter en unités réelles

Les coefficients de régression doivent être traduits dans le contexte du problème.

## Modèle .qmd

Cet aperçu correspond au fichier téléchargeable. Les blocs de code sont des emplacements à compléter; les exemples précédés de \# doivent être adaptés avant de les activer.

mini-rapport-1.qmd

    ---
    title: "Mini-rapport 1 : titre de votre analyse"
    author: "Prénoms et noms des 2 ou 3 membres"
    lang: fr
    format:
      html:
        embed-resources: true
        toc: true
        code-fold: true
    execute:
      message: false
    ---

    <!-- Gabarit à compléter. Il se rend avant l'ajout des données, mais ne contient
    encore aucune analyse. Remplacez les indications par votre travail et supprimez
    les commentaires d'aide devenus inutiles. Les exemples de code précédés de #
    ne s'exécutent pas : adaptez-les avant de retirer #. -->

    ```{r}
    #| label: configuration
    #| include: false

    # Charger explicitement les bibliothèques utilisées dans le rapport.
    library(tidyverse)
    library(janitor)
    library(broom)
    ```

    ## Question et décision

    À compléter : formulez une question précise, indiquez à qui s'adresse l'analyse
    et quelle décision elle peut éclairer.

    ## Données et préparation

    À compléter : source et lien, producteur, droits d'utilisation, caractère simulé
    le cas échéant, unité d'observation, variable réponse quantitative et variables
    explicatives avec leurs unités. Indiquez les limites connues des données.

    ```{r}
    #| label: importation

    # Placez le fichier autorisé dans data/, puis adaptez ce chemin.
    # donnees_brutes <- read_csv("data/nom_du_fichier.csv", show_col_types = FALSE)
    # donnees <- donnees_brutes |> clean_names()
    ```

    ```{r}
    #| label: preparation

    # Examinez les types, valeurs manquantes, doublons et valeurs inhabituelles.
    # Construisez donnees_analyse après avoir justifié les traitements nécessaires.
    # Utilisez les mêmes observations pour les deux modèles comparés.
    ```

    À compléter : nombre de lignes avant et après préparation, contrôles réalisés,
    exclusions et transformations justifiées. Expliquez leur effet sur l'analyse.

    ## Exploration

    ```{r}
    #| label: resume-descriptif

    # Produisez un résumé ciblé des variables utiles à votre question.
    ```

    ```{r}
    #| label: visualisation

    # Produisez au moins une visualisation utile, avec titre, axes et unités.
    ```

    À compléter : décrivez les principaux constats et expliquez ce qu'ils suggèrent
    pour la régression. Distinguez observation, association et causalité.

    ## Régression et comparaison

    À compléter : présentez un modèle simple de référence et une variante pertinente.
    Justifiez la forme des modèles en vous appuyant sur la question et l'exploration.

    ```{r}
    #| label: modeles

    # Exemple de structure à adapter, si une courbure est pertinente :
    # modele_reference <- lm(reponse ~ explicative, data = donnees_analyse)
    # modele_variante <- lm(reponse ~ explicative + I(explicative^2),
    #                       data = donnees_analyse)
    # Les noms reponse et explicative doivent être remplacés par vos variables.
    # Une relation quadratique n'est pas imposée : justifiez votre variante.
    ```

    ```{r}
    #| label: comparaison

    # Comparez les modèles sur les mêmes observations et pour la même réponse.
    # Par exemple : broom::glance() fournit le R² d'un modèle lm.
    # La RMSE d'ajustement peut se calculer avec sqrt(mean(residuals(modele)^2)).
    # Le nom modele doit être remplacé par celui du modèle évalué.
    # Présentez une comparaison concise et identifiez le modèle retenu.
    ```

    À compléter : comparez l'ajustement, l'interprétabilité et l'utilité des modèles.
    Le modèle de référence peut être retenu. Le R² et la RMSE calculés sur les
    données d'ajustement ne démontrent pas la performance sur de nouvelles données.
    Une séparation apprentissage/test n'est pas obligatoire pour ce mini-rapport.

    ### Interprétation des coefficients

    ```{r}
    #| label: coefficients

    # Extrayez les coefficients utiles, par exemple avec broom::tidy().
    # Vous pouvez les présenter dans le texte pour éviter un tableau supplémentaire.
    ```

    À compléter : interprétez au moins deux coefficients dans le contexte, avec
    leurs unités et leurs limites. Pour l'ordonnée à l'origine, précisez si zéro a
    un sens et appartient au domaine observé. Dans une relation quadratique,
    l'effet de la variable dépend de son niveau; le terme au carré n'est pas
    un effet constant à interpréter isolément.

    ### Diagnostic des résidus

    ```{r}
    #| label: diagnostic-residus

    # Pour le modèle retenu, produisez au moins un graphique de diagnostic.
    # Par exemple : résidus contre valeurs ajustées avec une ligne horizontale à 0.
    # broom::augment() fournit notamment .fitted et .resid pour un modèle lm.
    ```

    À compléter : décrivez ce que montre le diagnostic et discutez une limite
    concrète du modèle. Reliez cette limite à la prudence de votre recommandation.

    ## Recommandation, limites et suite

    À compléter : répondez à la question, proposez une recommandation proportionnée
    aux résultats, indiquez une incertitude ou une réserve importante et nommez
    la prochaine vérification à réaliser avant une décision réelle.

    ## Références

    À compléter : sources des données et des ressources utilisées, avec les liens
    permettant de les retrouver.

    ## Contributions

    - Membre 1, prénom et nom : une phrase décrivant sa contribution.
    - Membre 2, prénom et nom : une phrase décrivant sa contribution.
    - Membre 3, s'il y a lieu : une phrase décrivant sa contribution.

    ## Déclaration d'usage de l'IA

    À compléter : si une aide a influencé le code, l'analyse, l'interprétation,
    la documentation ou le texte, indiquez l'outil, l'usage précis, les vérifications
    réalisées et ce qui a été retenu ou corrigé. Suivez la déclaration du cours :
    <https://aureliennicosiaulaval.github.io/MQT-2101/ressources/declaration-ia.html>.

    Si aucun usage n'a influencé le livrable, remplacez ce paragraphe par la mention :
    « Aucun usage d'IA ayant influencé le livrable ».

    <!-- Avant remise : environ 1 200 à 1 600 mots hors code et références;
    quatre figures et tableaux principaux au total au maximum. Remettez le QMD,
    le HTML autonome, les données autorisées ou leur script d'importation,
    les éventuels scripts appelés et le README complété dans une archive ZIP.
    Vérifiez son rendu après extraction dans un autre dossier et redémarrage de R.
    Un seul membre dépose l'archive pour toute l'équipe dans Brio. -->

## Vérification finale

Avant la remise, chaque élément ci-dessous devrait être vérifié par l'équipe.

### Le rapport se rend

Après extraction du ZIP dans un autre dossier et redémarrage de R, le HTML est produit sans erreur.

### La question est claire

La conclusion répond à la question annoncée.

### Le code est minimal

Le rapport contient le code nécessaire, sans blocs inutiles.

### La régression est interprétée

La comparaison des modèles, au moins deux coefficients et un diagnostic des résidus sont expliqués.

### Les limites sont présentes

Les limites des données et de la méthode sont nommées.

### Les contributions sont documentées

Chaque membre décrit sa contribution; l'usage de l'IA ou son absence d'influence est déclaré.
