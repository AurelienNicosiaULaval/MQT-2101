# Notes de cours - Lissage et erreurs de prévision

## Moyennes mobiles

Une moyenne mobile arrière est un outil descriptif et une référence de prévision. Sa fenêtre détermine le compromis entre réactivité et stabilité. Une moyenne centrée utilise des observations futures et ne peut donc pas servir telle quelle à une prévision en temps réel.

## Lissage exponentiel

Le lissage exponentiel simple estime un niveau qui est mis à jour après chaque observation. Les poids des observations passées diminuent exponentiellement. La méthode ne modélise pas explicitement une tendance ou une saisonnalité.

## Erreurs

Pour \\e_t=y_t-\widehat y_t\\ :

\\ \operatorname{MAE}=\frac{1}{n}\sum \|e_t\|, \qquad \operatorname{RMSE}=\sqrt{\frac{1}{n}\sum e_t^2}. \\

Le biais moyen \\\overline e\\ indique une tendance générale à sous-prévoir ou sur-prévoir. Une mesure moyenne doit être accompagnée d’un graphique pour repérer les périodes problématiques.

## Choisir une méthode

Le choix combine : performance hors échantillon, stabilité, coût des erreurs, interprétabilité, disponibilité des données et maintenance. Une différence minime entre deux MAE ne justifie pas automatiquement une méthode beaucoup plus complexe.

## Surveillance

Après déploiement, les erreurs doivent être recalculées dès que les observations réelles deviennent disponibles. Un modèle satisfaisant aujourd’hui peut se dégrader après un changement de marché ou de processus.
