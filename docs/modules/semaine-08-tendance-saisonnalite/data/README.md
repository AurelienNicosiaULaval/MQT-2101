# Données du module 08

`ventes_saisonnieres_quebec.csv` et `ventes_promotions_quebec.csv` contiennent chacun 72 mois simulés, janvier 2020 à décembre 2025, avec ventes en dollars canadiens. Les deux séries sont distinctes. Le dictionnaire détaille variables, unités, dépendance et protocole 60 + 12 mois.

Ces fichiers ne décrivent aucune organisation réelle et peuvent être redistribués avec le cours. Ils proviennent de `scripts/10_create_second_block_data.R`, graine 210110. Le script autonome `R/regenerer-donnees.R` conserve les tirages intermédiaires nécessaires à leur reproduction exacte et ne réécrit que les CSV du projet dans lequel il est exécuté.

Le budget cible n’est pas un prédicteur du parcours. Prix et promotions futurs ne sont pas utilisés dans les prévisions principales. Le complément commercial distingue contexte réalisé et scénario hypothétique. Les données ne permettent aucune conclusion causale sur une organisation réelle.
