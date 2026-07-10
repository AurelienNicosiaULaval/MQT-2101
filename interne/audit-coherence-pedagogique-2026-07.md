# Audit de cohérence pédagogique MQT-2101

Date de mise à jour : 10 juillet 2026.

Cette note interne fixe les invariants vérifiés dans le parcours public. Elle
sert à éviter qu'une modification locale rende un module difficile à relier au
reste du cours.

## Portée

L'audit couvre :

- les modules 01 à 10;
- les ateliers 01 à 04;
- les 50 supports RevealJS de capsules;
- les pages de capsules, de démonstrations, d'exercices, de lectures et de
  données;
- les transitions entre les blocs et les liens avec les évaluations;
- les packages R employés dans les activités exécutables.

Il ne constitue pas une expertise disciplinaire externe ni une révision mot à
mot de chaque source historique. Les archives restent dans
anciens_documents et ne sont pas la source publiée.

## Progression retenue

| Étape | Rôle pédagogique | Trace ou transfert attendu |
|---|---|---|
| Module 01 | Lire un tableau avant de modéliser | Constats descriptifs prudents |
| Module 02 | Travailler dans un projet R et Quarto reproductible | Mini-rapport descriptif |
| Atelier 01 | Appliquer importation, diagnostic et visualisation | Priorité d'analyse défendable |
| Modules 03 et 04 | Modéliser une réponse continue et comparer les formes | Régression, diagnostics et limites |
| Atelier 02 | Justifier une recommandation par régression | Mini-analyse appliquée |
| Module 05 | Consolider les réflexes du premier bloc | Réponse d'examen structurée |
| Modules 06 à 09 | Prévoir dans le temps, évaluer et scénariser | Prévision validée hors échantillon |
| Atelier 03 | Comparer des méthodes de prévision | Point de contrôle du mini-rapport 2 |
| Module 10 | Décider à partir d'une cible binaire | Règle de classification justifiée |
| Atelier 04 | Intégrer choix de cible, validation et décision | Préparation intégratrice à la fin du cours |

## Invariants étudiants

Chaque module autonome comprend :

1. une mise en contexte ou un objectif explicite;
2. des capsules avec une activité immédiate;
3. un support visuel RevealJS par capsule;
4. des démonstrations R reproductibles;
5. des exercices avant les solutions;
6. des lectures ciblées et des données documentées;
7. une trace finale ou, pour le module 05, une synthèse de révision;
8. une auto-vérification;
9. un lien explicite avec la suite du parcours ou l'évaluation.

Les ateliers utilisent la même logique, adaptée à une séance en classe :
préparation, guide principal, démonstrations, exercices, production attendue et
critères de réussite.

## Décisions d'harmonisation

- Le libellé étudiant canonique est Activité X.Y. Les anciens intitulés
  Production autonome X.Y ont été remplacés dans les supports RevealJS.
- Les modules 01 à 05 conservent six capsules, car leurs premiers gestes sont
  volontairement découpés. Les modules 06 à 10 gardent quatre capsules, chacune
  organisée autour d'une décision complète et d'une activité immédiate.
- La différence de nombre de capsules ne change pas l'invariant : chaque
  capsule possède un objectif, un support visuel, une idée centrale, un exemple,
  un piège, une synthèse et une activité.
- Les supports écrits des modules 06 à 10 restent accessibles sans vidéo. Les
  decks RevealJS servent de fil visuel aux futures capsules vidéo.
- Les temps, cibles, horizons et évaluations ne doivent pas être déduits d'un
  module précédent. Ils sont explicités là où ils deviennent nécessaires.

## Corrections réalisées

- ajout de 20 supports RevealJS pour les capsules des modules 06 à 10;
- ajout de liens vers ces supports dans les pages de capsules;
- normalisation du vocabulaire des activités dans les 18 supports des modules
  01 à 03 et dans les notes du module 01;
- ajout des transitions entre le premier bloc, la prévision, les ateliers 03 et
  04, le mini-rapport 2 et l'examen final;
- ajout du validateur scripts/12_validate_module_coherence.R.

## Contrôle à relancer

Depuis la racine du projet :

~~~sh
Rscript scripts/12_validate_module_coherence.R
quarto render --no-cache
~~~

Le validateur vérifie les fichiers obligatoires, les 50 decks, les libellés
essentiels, les transitions et la couverture des packages R par le script
d'installation.
