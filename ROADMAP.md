# Roadmap de refonte du cours MQT-2101

Cette roadmap résume le suivi interne de la refonte du cours autour d'un site Quarto appliqué, orienté administration, décision d'affaires, analyse de données et R.

Cette page est une note interne de développement. Elle n'est pas destinée aux étudiantes et étudiants et n'est pas publiée dans la navigation du site de cours.

Les outils Git et GitHub servent au développement, à la sauvegarde et à la publication du site par l'enseignant. Ils ne font pas partie des outils demandés aux étudiantes et étudiants dans le cours.

## État au 18 mai 2026

- Le site Quarto est publié et rend correctement dans `docs/`.
- La navigation étudiante ne contient plus de roadmap, de pages internes enseignantes ou de références visibles aux outils de développement.
- Les pages d'accueil, plan de cours, calendrier, installation, évaluations et ressources ont été refondues visuellement.
- Le calendrier public présente un déroulement simple par blocs, sans dates précises ni mention de session.
- La structure d'évaluation est définie : deux mini-rapports en équipe et deux examens individuels en personne.
- La politique IA est clarifiée dans les ressources étudiantes, avec une page de déclaration d'usage de l'IA.
- Le GPT du cours est créé, intégré au site et présenté comme tuteur pédagogique.
- Les guides étudiants pour RStudio ou Positron, Quarto, R, statistique, modélisation, IA et mini-rapports sont maintenant publics.
- Les gabarits internes de module, de notes de cours et de principes de refonte sont conservés dans `interne/`, mais retirés du site public.
- Les solutionnaires demeurent exclus du rendu public.
- La cartographie de l'ancien matériel est disponible.
- Les modules et ateliers sont scaffoldés; les semaines 1 et 2 et l'atelier 01 de la semaine 3 sont les plus avancés.

## Décisions retenues

1. Garder le site étudiant centré sur les contenus utiles au cours, sans exposer les outils de développement.
2. Ne pas afficher les dates précises dans le calendrier du site tant que les dates officielles ne sont pas arrêtées.
3. Conserver une progression hebdomadaire simple.
4. Remplacer les questionnaires évalués par deux mini-rapports évalués.
5. Garder les questionnaires comme exercices formatifs non évalués.
6. Garder les examens intra et final individuels, en personne.
7. Pondération : 15 %, 30 %, 15 %, 40 %.
8. Autoriser l'IA dans les mini-rapports avec déclaration.
9. Interdire l'IA pendant les examens.
10. Utiliser le GPT du cours comme tuteur pédagogique : https://chatgpt.com/g/g-6a0b2ec33d948191ad25b2f247b15de1-analyse-et-modelisation-des-donnees?ref=mini

## Décisions à préciser plus tard

1. Procédure de validation des jeux de données choisis par les équipes.
2. Dates officielles de remise.
3. Durée et ressources permises pour les examens en personne.
4. Grilles détaillées des mini-rapports et des examens.
5. Maintien des instructions et de la base de connaissances du GPT du cours.
6. Niveau de détail attendu pour les notes de cours des semaines 3 à 10.
7. Place exacte des ateliers dans la séquence de remise des mini-rapports.

## Phases

| Phase | Statut | Résultat attendu |
|---|---|---|
| 0. Stabiliser le dépôt et le site | Terminé | Site publié, dépôt propre, archives privées ignorées |
| 1. Cartographier l'ancien matériel | Terminé pour la relance | Table de correspondance entre ancien et nouveau cours |
| 2. Définir la progression pédagogique | Partiellement terminé | Objectifs, compétences et livrables par semaine |
| 3. Construire les données du cours | Commencé | Jeux de données propres et documentés |
| 4. Rédiger les semaines | Commencé | Notes, capsules, exercices et mini-cas |
| 5. Développer les ateliers | Commencé | Ateliers guidés et appliqués |
| 6. Refaire les évaluations | Structure publique terminée | Mini-rapports, examens, questionnaires formatifs et grilles |
| 7. Produire les ressources | Terminé pour la première version publique | Guides R, Quarto, IA, statistiques, modélisation et mini-rapports |
| 8. Tester et améliorer | Continu | Site fiable et prêt pour l'enseignement |

## Dernière livraison

Livraison du 18 mai 2026 :

- refonte complète de la section `ressources`;
- retrait public des pages internes enseignantes;
- déplacement des fichiers internes vers `interne/`;
- harmonisation visuelle avec les pages d'accueil, plan de cours, calendrier, installation et évaluations;
- rendu local complet avec Quarto;
- vérification locale des pages principales;
- vérification publique après publication.

## Prochaines priorités

1. Compléter les contenus des semaines 3 à 10.
2. Finaliser les ateliers 02, 03 et 04.
3. Documenter les jeux de données du cours avec dictionnaires de variables et exemples d'importation.
4. Rédiger les grilles détaillées des deux mini-rapports.
5. Préparer les consignes finales des examens en personne.
6. Tester l'ensemble du site comme parcours étudiant, de l'accueil à la remise d'un mini-rapport.
