# Module 10 - Résultats binaires et classification

> **NOTE:**
>
> Lorsque la cible est un départ, un défaut ou une réponse, la décision ne consiste pas seulement à estimer une moyenne. Il faut produire une probabilité, choisir un seuil et assumer les coûts différents des faux positifs et des faux négatifs.

## Frontière conceptuelle

Le module 04 étudiait des relations non linéaires pour une réponse continue. Ce module traite une réponse binaire et une décision de classification. La régression logistique modélise une probabilité; le seuil transforme ensuite cette probabilité en action.

## Continuité du parcours

Vous conservez les principes de question claire, de séparation entraînement-test, de diagnostic et de limite. La différence est la cible : au lieu de prévoir une valeur continue, vous estimez la probabilité d’un événement puis justifiez une règle de décision.

## Résultat attendu

À la fin du module, vous pourrez :

- définir une cible binaire et la classe positive;
- ajuster une régression logistique;
- interpréter le signe d’un coefficient et une probabilité prédite;
- construire une matrice de confusion;
- calculer exactitude, sensibilité, spécificité et précision;
- choisir un seuil selon le coût des erreurs;
- distinguer performance statistique et utilité décisionnelle.

Temps de travail indicatif : 3 heures.

## Données

Le fichier [`fidelisation_clients_quebec.csv`](data/fidelisation_clients_quebec.csv) décrit 650 clients fictifs et leur départ éventuel dans les 90 jours.

## Parcours

1.  [Capsules et activités](../../modules/semaine-10-classification-modeles-avances/capsules.llms.md)
2.  [Notes de cours](../../modules/semaine-10-classification-modeles-avances/notes-cours.llms.md)
3.  [Démonstrations R](../../modules/semaine-10-classification-modeles-avances/demonstrations.llms.md)
4.  [Exercices](../../modules/semaine-10-classification-modeles-avances/exercices.llms.md)
5.  [Lectures ciblées](../../modules/semaine-10-classification-modeles-avances/lectures.llms.md)

## Trace finale

Construisez une analyse de fidélisation comprenant : définition de la classe positive, séparation entraînement-test, régression logistique, calibration descriptive des probabilités, matrices de confusion à deux seuils, mesures de performance, coût des erreurs et recommandation de ciblage.

## Auto-vérification

La classe positive correspond à l’événement d’intérêt.

Le test n’a pas servi à ajuster le modèle ou le seuil.

Je distingue probabilité et classe prédite.

Je ne rapporte pas seulement l’exactitude.

Le seuil est justifié par une capacité ou un coût.

Je nomme une limite éthique ou opérationnelle.

## Lien avec l’évaluation

Le module prépare la classification et l’interprétation décisionnelle de l’examen final. Il offre aussi une option classification pour le mini-rapport 2.
