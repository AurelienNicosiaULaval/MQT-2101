# Repères préparatoires - Atelier 03

## Repère 1 - Formuler la mission

Complétez avant la séance :

> À la fin de \_\_\_\_\_\_\_\_\_\_, prévoir \_\_\_\_\_\_\_\_\_\_ pour les \_\_\_\_\_\_\_\_\_\_ prochaines semaines afin de \_\_\_\_\_\_\_\_\_\_.

La phrase doit nommer le point d’origine, la cible, l’horizon et la décision.

## Repère 2 - Préserver le futur

La période test sera constituée des treize dernières semaines. Elle ne doit servir ni au choix de la fenêtre, ni à l’estimation du lissage, ni à une transformation apprise.

> **WARNING:**
>
> Si votre code calcule une moyenne avec des semaines situées après la semaine prévue, il contient une fuite temporelle.

## Repère 3 - Références minimales

Préparez trois idées :

- naïve : dernière demande observée;
- moyenne des quatre dernières semaines;
- lissage exponentiel simple.

Une méthode plus complexe n’est utile que si elle améliore la décision hors échantillon.

## Repère 4 - Coûts asymétriques

Une sous-prévision peut créer une rupture; une sur-prévision peut créer du stock inutilisé. Notez avant l’atelier laquelle est la plus coûteuse dans votre scénario et pourquoi.

## Auto-diagnostic

1.  Quelle mesure pénalise davantage une grande erreur isolée?
2.  Que signifie un biais positif si l’erreur est `observé - prévu`?
3.  Pourquoi le classement des méthodes peut-il changer à une autre période?

> **TIP:**
>
> 1.  La RMSE. 2. Une sous-prévision moyenne. 3. Les structures et les chocs de la série changent; une seule période test fournit une preuve limitée.
