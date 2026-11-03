# Questionnaire formatif - Prévision et classification

## Mode d’emploi

Répondez sans notes ni IA au premier essai. Consultez ensuite les rétroactions et créez une liste de trois notions à reprendre. Ce questionnaire est formatif et non évalué.

## 1. Fréquence et horizon

Une série mensuelle doit soutenir une commande livrée dans trois mois. Quel horizon minimal faut-il étudier?

> **TIP:**
>
> Au moins trois mois. La cible et l’origine doivent aussi être précisées.

## 2. Tendance ou saisonnalité

Les ventes augmentent progressivement depuis quatre ans et culminent chaque décembre. Nommez les deux structures.

> **TIP:**
>
> Une tendance croissante et une saisonnalité annuelle avec niveau élevé en décembre.

## 3. Fuite temporelle

Pourquoi une séparation aléatoire des mois est-elle inadéquate pour évaluer une prévision réelle?

> **TIP:**
>
> Elle peut utiliser des mois futurs pour entraîner un modèle évalué sur des mois antérieurs et ne reproduit pas l’information disponible au point d’origine.

## 4. Moyenne mobile

Que change une fenêtre de 12 semaines comparativement à une fenêtre de 4 semaines?

> **TIP:**
>
> Elle lisse davantage et réagit plus lentement aux changements récents.

## 5. MAE et RMSE

Les erreurs absolues de la méthode A sont 0, 0, 0 et 20; celles de la méthode B sont 5, 5, 5 et 5. Calculez la MAE et la RMSE de chaque méthode. Quelle mesure distingue ici la grande erreur?

> **TIP:**
>
> Les deux MAE valent 5. La RMSE de A vaut 10 et celle de B vaut 5 : la RMSE distingue ici la grande erreur, car elle utilise les carrés des écarts. Une erreur maximale plus grande ne suffit toutefois pas, à elle seule, à garantir une RMSE plus élevée.

## 6. Biais

Avec `erreur = observé - prévu`, un biais moyen positif indique quoi?

> **TIP:**
>
> Une tendance moyenne à sous-prévoir.

## 7. Variable externe

À la fin de janvier, on veut prévoir les ventes de février. Une variable associée aux ventes de février ne sera publiée qu’à la fin de mars. Peut-on utiliser sa valeur de février comme prédicteur connu à la fin de janvier? Qu’en est-il d’une valeur plus ancienne déjà publiée?

> **TIP:**
>
> Non pour sa valeur de février : elle n’est pas encore disponible à l’origine. On peut envisager une prévision ou un scénario pour cette valeur, ou une valeur passée déjà publiée, à condition de vérifier sa date de disponibilité et sa pertinence.

## 8. Autocorrélation

Des résidus positifs sont fréquemment suivis de résidus positifs. Que suggère ce motif?

> **TIP:**
>
> Une autocorrélation positive et une structure temporelle non captée par le modèle.

## 9. Classe positive

Dans une analyse de départ client, pourquoi faut-il définir explicitement la classe positive?

> **TIP:**
>
> Les mesures comme sensibilité et précision dépendent de l’événement considéré positif. Ici, il s’agit normalement du départ à détecter.

## 10. Seuil

Quel effet général produit une diminution du seuil de classification?

> **TIP:**
>
> Davantage de cas sont classés positifs. La sensibilité augmente souvent, mais les faux positifs et la capacité nécessaire peuvent augmenter aussi.

## 11. Exactitude trompeuse

Seulement 5 % des cas sont positifs. Une règle qui prédit toujours « négatif » obtient quelle exactitude et quelle sensibilité?

> **TIP:**
>
> Exactitude de 95 %, mais sensibilité de 0 %. La règle est inutile pour détecter les cas positifs.

## 12. Décision finale

Une méthode réduit la MAE de 2 %, mais double le coût de maintenance et exige une variable future incertaine. Formulez une décision prudente.

> **TIP:**
>
> La réponse compare le gain à son incertitude et aux coûts. Elle peut retenir la méthode simple, demander une validation supplémentaire ou utiliser des scénarios plutôt que présenter le gain comme certain.

> **NOTE:**
>
> Demandez au GPT du cours de générer une question analogue sur la notion la moins maîtrisée, sans solution visible. Résolvez-la, puis demandez seulement une critique de votre raisonnement.
