# Livraisons régionales québécoises fictives

Source : jeu entièrement simulé pour MQT-2101, version du 1er octobre 2026. Aucune entreprise, personne, livraison ou mesure réelle. Données redistribuables avec le matériel du cours. Le script de génération et ses contrôles sont conservés dans le kit enseignant.

Une ligne correspond à une livraison depuis un centre vers une destination. La durée inclut le déplacement, la réception et un incident éventuel. La distance est celle du trajet aller; ce n'est pas la durée ni un nombre de livraisons. Les centres sont fictifs, nommés d'après quatre villes québécoises.

| Variable | Type et unité | Description |
|---|---|---|
| livraison_id | texte | Identifiant unique, L001 à L096 |
| date | date ISO | Jour de la livraison en 2025 |
| centre | catégorie | Québec, Lévis, Sherbrooke ou Trois-Rivières |
| distance_km | numérique, km | Distance du trajet aller |
| colis | entier, colis | Nombre de colis de la livraison, information de contexte |
| incident | catégorie | aucun ou panne confirmée |
| duree_minutes | numérique, min | Durée totale observée de la livraison |

Le fichier comporte 96 lignes et sept colonnes : huit livraisons par mois, deux par centre, de janvier à décembre. Aucun identifiant n'est répété et aucune valeur n'est manquante.

La livraison L072 a une distance de 78 km et une durée de 165 minutes. La panne a été confirmée dans le scénario : ces valeurs sont exactes pour cette livraison fictive. Les conserver est le choix de départ. Le qualificatif « atypique » ne signifie pas « erreur de saisie ».

Protocole fixé avant l'analyse : dates antérieures au 1er octobre 2025 pour l'apprentissage, dates à partir du 1er octobre pour la validation. Celle-ci concerne des livraisons ultérieures des mêmes centres. Comme elle sert à choisir la forme, elle n'est pas un test final indépendant de cette sélection.

Les deux modèles essentiels utilisent uniquement la distance comme explicative. Les colis et les centres permettent de discuter le contexte; aucun modèle multiple ou par centre n'est demandé. La mission vise les livraisons comparables à celles du fichier, incidents inclus au départ. Un changement de population doit être nommé.
