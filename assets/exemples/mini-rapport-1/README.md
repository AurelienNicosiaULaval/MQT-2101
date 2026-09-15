# Mini-rapport 1 : dossier de travail

## Démarrer dans RStudio

1. Extrayez complètement le ZIP dans un dossier de travail de votre ordinateur.
2. Ouvrez `mini-rapport-1.Rproj`, puis `mini-rapport-1.qmd` dans RStudio.
3. Cliquez sur Render. Le gabarit produit un HTML sans données : ce premier
   rendu vérifie l'installation, mais le rapport reste à compléter.
4. Si une bibliothèque manque, installez-la une seule fois dans la console R :
   `install.packages(c("tidyverse", "janitor", "broom"))`.
   N'ajoutez pas l'installation au rapport.
5. Placez vos données autorisées dans `data/`, adaptez le code et remplacez
   les indications du gabarit par votre analyse. Les lignes précédées de `#`
   sont des commentaires; adaptez les exemples avant de les activer.
6. Refaites un rendu après chaque étape importante.

Les consignes, la grille et le calendrier se trouvent sur le site du cours :
https://aureliennicosiaulaval.github.io/MQT-2101/evaluations/mini-rapport-1.html

## Informations à compléter par l'équipe

- Membres : à compléter.
- Source et droits des données : à compléter.
- Fichier de données ou procédure d'importation : à compléter.
- Bibliothèques supplémentaires utilisées : à compléter, ou « Aucune ».
- Étapes nécessaires avant Render : à compléter, ou « Aucune ».

Utilisez des chemins relatifs comme `data/mon_fichier.csv`. Si les droits ne
permettent pas de joindre les données, fournissez un script d'importation
reproductible et documentez ses étapes. N'incluez pas de données personnelles,
confidentielles, de mot de passe ou de clé d'accès dans l'archive.

## Vérifier et remettre

- Complétez le rapport, les contributions et la déclaration IA ou de non-usage.
- Conservez `embed-resources: true` pour produire un HTML autonome.
- Redémarrez R, puis cliquez sur Render sans exécuter de code dans la console.
- Ouvrez le HTML et vérifiez les textes, tableaux et graphiques.
- Créez un ZIP avec le QMD, le HTML, les données ou leur script d'importation,
  les scripts appelés, ce README complété et le projet RStudio.
- Extrayez ce ZIP dans un autre dossier et refaites Render dans le projet extrait.
  Le travail ne doit pas dépendre de fichiers restés dans le dossier original.
- Un seul membre dépose le ZIP pour l'équipe dans l'évaluation « Mini-rapport 1 »
  de Brio et vérifie que le fichier remis apparaît bien.

L'échéance est indiquée dans Brio et dans le calendrier du cours.
