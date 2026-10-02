# Livraisons régionales québécoises fictives

Source : jeu de données entièrement simulé pour MQT-2101, version du 1er octobre 2026. Il ne décrit aucune entreprise ni aucune livraison réelle. Les données peuvent être redistribuées avec le matériel du cours.

Chaque ligne correspond à une livraison depuis un centre vers une destination. La durée inclut le déplacement, la réception des colis et un éventuel retard dû à un incident. La distance est celle du trajet aller. Les centres sont fictifs et portent les noms de quatre villes québécoises.

| Variable | Type et unité | Description |
|---|---|---|
| livraison_id | texte | Identifiant unique, L001 à L096 |
| date | date au format AAAA-MM-JJ | Jour de la livraison en 2025 |
| centre | catégorie | Québec, Lévis, Sherbrooke ou Trois-Rivières |
| distance_km | numérique, km | Distance du trajet aller |
| colis | entier, colis | Nombre de colis de la livraison, information de contexte |
| incident | catégorie | aucun ou panne confirmée |
| duree_minutes | numérique, min | Durée totale observée de la livraison |

Le fichier comporte 96 lignes et sept colonnes : huit livraisons par mois, deux par centre, de janvier à décembre. Aucun identifiant n'est répété et aucune valeur n'est manquante.

La livraison L072 a une distance de 78 km et une durée de 165 minutes. La panne est confirmée dans le scénario : ces valeurs sont exactes pour cette livraison fictive. Conservez cette observation dans le parcours essentiel du laboratoire. Une valeur atypique n'est pas nécessairement une erreur de saisie.

Les périodes sont définies avant l'analyse : dates antérieures au 1er octobre 2025 pour l'apprentissage, dates à partir du 1er octobre pour la validation. Celle-ci porte sur des livraisons ultérieures des mêmes centres. Puisqu'elle sert à choisir entre les modèles, elle ne constitue pas un test final indépendant du modèle retenu.

Les deux modèles du parcours essentiel utilisent uniquement la distance comme variable explicative. Le nombre de colis et le centre servent à décrire le contexte; aucun modèle multiple ni modèle par centre n'est demandé. Au départ, l'analyse vise des livraisons comparables à celles du fichier, incidents inclus. Si vous étudiez ensuite les livraisons sans incident, précisez ce changement dans votre question.
