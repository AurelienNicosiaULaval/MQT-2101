# Lectures - Module 09

Ces explications font partie du socle. Les liens vers l’ouvrage ouvrent des lectures ciblées et ne remplacent pas les démonstrations en R.

## Disponibilité et fuite

Une prévision doit reposer sur l’information disponible à son origine. Le calendrier est connu; une promotion ou un prix peuvent être connus si approuvés, ou seulement hypothétiques. L’indice économique peut nécessiter sa propre prévision. Une valeur du futur observée après coup est utile pour une analyse rétrospective, mais elle ne prouve pas la performance d’une prévision réalisable.

Par exemple, à la fin de décembre, le calendrier du mois de janvier est connu. Une promotion n’est connue que si la décision est déjà prise; sinon, on peut examiner un scénario. La valeur de l’indice effectivement observée en janvier devient disponible après l’origine : l’utiliser pour comparer rétrospectivement deux modèles ne donne pas une prévision réalisable à partir des seules informations de décembre. Une valeur passée déjà publiée peut être admissible si elle était disponible à cette date.

## Régression avec contexte

La régression combine tendance, mois, promotion, prix et indice. La promotion binaire se lit par rapport à la catégorie non, en dollars, les autres termes du modèle étant fixés. Une association conditionnelle n’est pas automatiquement causale : des facteurs omis ou le choix des promotions peuvent influencer la comparaison.

Supposons que le coefficient associé à « promotion oui » soit de 2 000 \$. Dans ce modèle, deux situations qui ne diffèrent que par l’indicateur de promotion ont des ventes ajustées qui diffèrent de 2 000 \$. Il s’agit d’une comparaison dans le modèle, avec prix, indice, mois et tendance identiques. Le responsable peut avoir décidé les promotions en fonction d’autres informations; le coefficient ne démontre donc pas l’effet d’une intervention.

## Résidus et autocorrélation

Le résidu est l’observation moins la valeur ajustée. Un retard 1 rapproche les erreurs de deux mois consécutifs; un retard 12 compare des mois séparés d’une année. Des signes positifs persistants peuvent signaler une sous-prévision répétée. Une ACF de la série brute peut refléter tendance et saisonnalité, et ne doit pas être confondue avec celle des résidus. Un test de Ljung-Box examine collectivement les autocorrélations jusqu’au retard choisi; une p-valeur élevée ne démontre pas leur absence ni l’indépendance.

Commencez par tracer les résidus dans l’ordre des mois. Plusieurs résidus positifs consécutifs peuvent indiquer que le modèle sous-estime successivement les observations; l’ACF donne ensuite un résumé par retard. Une barre à un retard indique une association estimée entre résidus séparés par ce nombre de mois, avec une incertitude d’échantillonnage. L’absence de barre marquée ne prouve pas l’indépendance et une barre marquée ne désigne pas à elle seule la cause du motif.

Sur un graphique d’ACF mensuelle, une barre positive au retard 1 indique que les résidus séparés d’un mois tendent à varier dans le même sens; une barre négative suggère une alternance. Au retard 12, la comparaison concerne des mois séparés d’une année. Les pointillés sont des repères approximatifs, pas une frontière qui prouverait l’indépendance : l’ajustement du modèle et la lecture de plusieurs retards invitent à la prudence. Comparez toujours l’ACF au graphique des résidus dans le temps.

Pour approfondir, le test de Ljung-Box regroupe plusieurs retards dans une même vérification. Une petite valeur p fournit un indice contre l’hypothèse testée; une grande valeur p ne démontre pas son exactitude. Le test est facultatif ici : le socle est la lecture du graphique des résidus et de leur ACF.

## Régression avec erreurs AR

Écrire \\y_t = x_t \beta + \eta_t\\ puis \\\eta_t = \phi \eta\_{t-1} + \varepsilon_t\\ signifie que la partie non expliquée par les prédicteurs a une mémoire d’un mois. Les innovations ε ne sont pas la même chose que les erreurs de régression η. Le modèle est estimé sur les 60 premiers mois. Les candidats sont comparés sur les mêmes 12 mois et les mêmes prédicteurs. Les paramètres estimés et les diagnostics restent incertains.

Une erreur AR(1) et une vente retardée utilisée comme prédicteur ne sont pas la même opération. Dans le premier cas, la dépendance est décrite dans la partie non expliquée par la régression; dans le second, on ajoute explicitement une vente passée à la formule. Pour chaque horizon, il faut vérifier que la vente retardée nécessaire est disponible à l’origine ou préciser comment elle sera prévue.

Cette structure est une option plus technique, présentée avec du code complet dans la démonstration. Pour l’activité, il suffit de lire et comparer les résultats fournis : on ne demande pas de construire le modèle AR(1) de mémoire. Une MAE plus faible sur les mêmes douze mois décrit une meilleure performance sur ce bloc pour ce critère; elle ne garantit pas la performance sur une autre période. Ici les valeurs externes de 2025 sont connues après coup : la comparaison est conditionnelle à ces valeurs.

## Scénarios et décision

Une prévision sous hypothèses est conditionnelle au prix, à la promotion et à l’indice fournis. Les intervalles d’une régression dynamique avec prédicteurs fixés ne couvrent pas toute l’incertitude sur ces futurs prédicteurs. Pour deux scénarios, maintenir les autres entrées identiques et préciser la date, les unités et le destinataire. Une différence prédite ne garantit pas l’effet d’une intervention.

Pour lire les intervalles, demandez-vous ce qui est supposé connu. Un intervalle calculé avec un prix et une promotion fixés décrit l’incertitude sous ces valeurs; il n’ajoute pas automatiquement l’incertitude sur un prix ou une promotion encore inconnus. Utilisez l’exercice de scénario pour comparer deux hypothèses à valeurs restantes identiques, puis formulez une limite opérationnelle.

## Lectures ciblées et documentation

Hyndman et Athanasopoulos (2021), *Forecasting: Principles and Practice*, 3e édition : [régression et prévision ex ante/ex post](https://otexts.com/fpp3/regression.html), sections 7.3 et 7.6; [diagnostic des résidus](https://otexts.com/fpp3/toolbox.html), section 5.4; [régression dynamique](https://otexts.com/fpp3/dynamic-regression.html), sections 10.1 à 10.3. La [documentation de forecast::Arima](https://pkg.robjhyndman.com/forecast/reference/Arima.html) explique `xreg` et `order`.

Pour approfondir seulement : [modèles ARIMA](https://otexts.com/fpp3/arima.html), sections 9.1 à 9.5, et [complément facultatif](../../modules/semaine-09-variables-externes-autocorrelation/complements.llms.md). Revenir à l’exercice correspondant après chaque lecture.
