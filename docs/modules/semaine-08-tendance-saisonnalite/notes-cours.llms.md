# Notes de cours - Tendance et saisonnalité

## Tendance

Une tendance linéaire suppose un changement moyen constant par période. Elle est utile sur une plage limitée, mais extrapoler très loin peut produire des valeurs irréalistes.

## Saisonnalité

La saisonnalité est associée à une période connue : semaine, mois, trimestre ou jour de la semaine. Le facteur calendrier permet d’estimer un écart pour chaque saison relativement à une référence.

## Modèle additif

\\ y_t=\beta_0+\beta_1t+\gamma\_{m(t)}+\varepsilon_t. \\

Le modèle est additif lorsque l’amplitude des effets saisonniers reste approximativement constante. Si l’amplitude augmente avec le niveau, le logarithme transforme souvent une relation multiplicative en relation additive.

## Prévision

Pour prévoir, les valeurs futures de l’indice temporel et du calendrier sont connues. On obtient une valeur centrale et un intervalle. L’intervalle de prédiction doit être privilégié lorsqu’on parle d’une future observation.

## Diagnostic

Les résidus doivent être examinés dans le temps, selon les valeurs ajustées et selon les mois. Un motif persistant signale qu’une structure n’a pas été captée. L’autocorrélation sera approfondie au module 09.

## Décision

Un budget saisonnier doit s’appuyer sur une valeur centrale, une plage plausible et un mécanisme de révision. Un modèle n’élimine ni l’incertitude ni le besoin de jugement opérationnel.
