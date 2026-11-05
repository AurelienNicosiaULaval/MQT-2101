# Préparer les quatre projets du module 07 à partir des sources publiques actuelles.
library(knitr)
# Sans argument : les quatre projets. Un ou plusieurs noms limitent la reconstruction.
noms_projets <- c("lissage-demande", "lissage-electricite",
                  "demonstration-lissage-demande", "corrige-lissage-electricite")
arguments <- commandArgs(trailingOnly = TRUE)
projets_a_preparer <- if (length(arguments)) unique(arguments) else noms_projets
stopifnot(all(projets_a_preparer %in% noms_projets))
module <- "modules/semaine-07-lissage"
destination <- file.path(module, "telechargements")
dir.create(destination, recursive = TRUE, showWarnings = FALSE)
lire <- function(p) paste(readLines(p, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
entete <- function(titre, css = NULL) paste0('---\ntitle: "', titre,
  '"\nlang: fr\nformat:\n  html:\n    embed-resources: true\n    code-copy: true\n    code-fold: false\n    code-overflow: wrap\n', if (!is.null(css)) paste0('    css: ', css, '\n') else '', 'execute:\n  warning: false\n  message: false\n---\n\n')
source_portable <- function(fichier, titre) {
  s <- lire(file.path(module, fichier))
  s <- sub("(?s)^---\\n.*?\\n---\\n", "", s, perl = TRUE)
  # Supprimer uniquement la préparation technique du site (les calculs restent visibles).
  s <- gsub("(?s)```\\{r\\}\\n#\\| include: false\\n.*?```\\n", "", s, perl = TRUE)
  # Les liens de données restent locaux. Les liens des pages et téléchargements
  # du module deviennent des libellés, pour ne pas viser une version publique
  # qui peut précéder ce projet local. Les ancres internes restent fonctionnelles.
  s <- gsub('\\[([^]\\n]+)\\]\\((telechargements/[^)]+|(lectures|demonstrations|exercices|capsules|notes-cours|index)\\.qmd[^)]*)\\)',
            '\\1', s, perl = TRUE)
  paste0(entete(titre, css = if (fichier == "exercices.qmd") "media/module07-exercices.css" else NULL), s, "\n")
}
bloc <- function(s, label) {
  motif <- paste0("(?s)```\\{r\\}\\n#\\| label: ", label, "\\n.*?```")
  r <- regmatches(s, regexpr(motif, s, perl = TRUE))
  stopifnot(length(r) == 1, nzchar(r))
  r
}
preparer <- function(nom, texte, complet = FALSE) {
  base <- tempfile("mqt07-projet-")
  dossier <- file.path(base, nom)
  dir.create(file.path(dossier, "data"), recursive = TRUE)
  dir.create(file.path(dossier, "R"))
  on.exit(unlink(base, recursive = TRUE), add = TRUE)
  donnees <- list.files(file.path(module, "data"), pattern = "\\.(csv|md)$", full.names = TRUE)
  stopifnot(all(file.copy(donnees, file.path(dossier, "data"))))
  fonctions <- file.path(module, c("R/fonctions-module07.R", "R/regenerer-donnees.R"))
  stopifnot(all(file.copy(fonctions, file.path(dossier, "R"))))
  nom_rapport <- if (grepl("electricite", nom)) "lissage_electricite" else "lissage_demande"
  qmd <- file.path(dossier, paste0(nom_rapport, ".qmd"))
  writeLines(texte, qmd, useBytes = TRUE)
  if (complet) {
    knitr::purl(qmd, output = sub("qmd$", "R", qmd), quiet = TRUE)
    if (grepl("electricite", nom)) {
      dir.create(file.path(dossier, "media"))
      stopifnot(file.copy(file.path(module, "media/module07-exercices.css"),
                          file.path(dossier, "media/module07-exercices.css")))
    }
  }
  writeLines(c("Version: 1.0", "RestoreWorkspace: No", "SaveWorkspace: No",
               "AlwaysSaveHistory: No"), file.path(dossier, paste0(nom, ".Rproj")))
  writeLines(c(paste0("# ", nom), "", "Projet préparé à partir des sources du module 07.",
    "1. Décompressez toute l’archive et ouvrez le .Rproj.",
    "2. Installez une fois tidyverse, slider et forecast si nécessaire. R, RStudio et Quarto sont requis.",
    "3. Ouvrez le .qmd, redémarrez R, puis faites Render. Le projet de départ se rend avant d’être complété.",
    if (complet) "4. Les blocs visibles sont exécutables dans l’ordre. Le script .R reprend les calculs." else
      "4. Réalisez chaque activité une seule fois. Les sections indiquent le travail à ajouter.",
    "5. Conservez data/, R/ et media/ si présent. Les calculs ne nécessitent ni connexion au dépôt ni données distantes.",
    "", "Deux séries fictives québécoises, sans mesure réelle. Les périodes de validation sont déjà connues du module 06.",
    "Les coûts sont pédagogiques, sans tarif réel. Ce rapport est un entraînement, pas une remise évaluée.",
    "Les compléments Holt et les pratiques supplémentaires sont facultatifs.",
    "Pour reproduire les CSV dans une copie: source('R/regenerer-donnees.R'). Ce script réécrit les CSV locaux.",
    "Les liens vers le cours et les ouvrages sont des compléments en ligne; cette version locale révisée peut précéder le site public.",
    "Attribution: matériel du cours MQT-2101, Université Laval. Les données simulées sont redistribuables avec le cours.",
    "Ancien matériel consulté: séance 07; script attribué à Paolo Landa (2021), sans redistribution des archives."),
    file.path(dossier, "README.md"), useBytes = TRUE)
  archive <- file.path(normalizePath(destination), paste0(nom, ".zip"))
  if (file.exists(archive)) unlink(archive)
  avant <- getwd()
  setwd(base)
  tryCatch(utils::zip(archive, list.files(nom, recursive = TRUE, full.names = TRUE), flags = "-q"),
           finally = setwd(avant))
}
demo <- source_portable("demonstrations.qmd", "Demande : démonstration complète du lissage")
corrige <- source_portable("exercices.qmd", "Électricité : exercices et corrigés de lissage")
# Récupérer les consignes canoniques dans les supports, sans nouvelle formulation.
consignes <- vapply(1:4, function(i) {
  s <- lire(file.path(module, sprintf("media/qmd/capsule-%02d-support.qmd", i)))
  motif <- "(?s)## Production autonome.*?::: \\{\\.lead\\}\\n(.*?)\\n:::"
  sub(motif, "\\1", regmatches(s, regexpr(motif, s, perl = TRUE)), perl = TRUE)
}, character(1))
stopifnot(all(nzchar(consignes)))
depart_demande <- paste0(entete("Demande : mon analyse de lissage"),
  "## Préparation\n\n", bloc(demo, "preparation-m07"), "\n\n",
  "Données simulées; 91 semaines puis 13 semaines de validation connue. Les fonctions sont fournies dans R/.\n\n",
  paste0("## Activité 7.", 1:4, "\n\n", consignes,
         "\n\nAjoutez votre code, vos résultats et votre interprétation. Réalisez cette activité une seule fois.\n\n", collapse = ""),
  "## Pour terminer\n\nRelisez les quatre réponses, nommez une limite et redémarrez R avant Render. Holt reste facultatif.\n")
# Les énoncés sont extraits de la page des exercices avant la solution.
enonces <- vapply(1:4, function(i) {
  motif <- paste0("(?s)## Exercice ", i, " - .*?\\n:::: \\{\\.callout-tip")
  s <- regmatches(corrige, regexpr(motif, corrige, perl = TRUE))
  sub("\\n:::: \\{\\.callout-tip$", "", s)
}, character(1))
depart_electricite <- paste0(entete("Électricité : mon analyse de lissage"),
  "## Préparation\n\n", bloc(corrige, "preparation-transfert-m07"), "\n\n",
  "Données simulées; 60 mois puis 12 mois de validation connue. Candidats: naïf, MM3, SES02, SES08, saisonnier. Même initialisation pour les deux alphas.\n\n",
  paste0(enonces, "\n\nAjoutez votre code et votre interprétation avant le corrigé.\n\n", collapse = ""))
textes_projets <- list("lissage-demande" = depart_demande,
                       "lissage-electricite" = depart_electricite,
                       "demonstration-lissage-demande" = demo,
                       "corrige-lissage-electricite" = corrige)
for (nom in projets_a_preparer) {
  preparer(nom, textes_projets[[nom]],
           complet = nom %in% c("demonstration-lissage-demande", "corrige-lissage-electricite"))
}
message(length(projets_a_preparer), " projet(s) préparé(s) à partir des sources actuelles.")
