# Prépare les quatre projets du module 6 sans données ni corrections privées.
library(knitr)

module <- "modules/semaine-06-series-chronologiques-intro"
destination <- file.path(module, "telechargements")
dir.create(destination, recursive = TRUE, showWarnings = FALSE)
lire <- function(path) paste(readLines(path, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
entete <- function(titre) paste0('---\ntitle: "', titre,
  '"\nlang: fr\nformat:\n  html:\n    embed-resources: true\n    code-copy: true\nexecute:\n  warning: false\n  message: false\n---\n\n')

source_autonome <- function(fichier, titre) {
  texte <- sub("(?s)^---\\n.*?\\n---\\n", "", lire(file.path(module, fichier)), perl = TRUE)
  # Les archives restent utilisables sans le site de cours ni ses téléchargements.
  texte <- sub("(?s)Décompressez le.*?Les bibliothèques nécessaires", "Les bibliothèques nécessaires", texte, perl = TRUE)
  texte <- sub("Décompressez le \\[projet.*?Tentez chaque question avant d’ouvrir son corrigé[.]",
               "Ouvrez le projet RStudio fourni et tentez chaque question avant d’ouvrir son corrigé.", texte, perl = TRUE)
  texte <- gsub("\\[projet des corrigés complets\\]\\([^)]*\\)", "projet des corrigés complets", texte)
  texte <- gsub("\\[lectures ciblées\\]\\(lectures.qmd\\)", "lectures ciblées du module", texte)
  texte <- gsub("../atelier-03-series-chronologiques/data/", "data/", texte, fixed = TRUE)
  paste0(entete(titre), texte, "\n")
}

preparer <- function(nom, csv, texte, titre, complet = FALSE) {
  base <- tempfile(paste0(nom, "-"))
  dossier <- file.path(base, nom)
  dir.create(file.path(dossier, "data"), recursive = TRUE)
  dir.create(file.path(dossier, "R"))
  on.exit(unlink(base, recursive = TRUE), add = TRUE)
  stopifnot(file.copy(csv, file.path(dossier, "data", basename(csv))),
            file.copy(file.path(module, "R/analyse-module06.R"), file.path(dossier, "R/analyse-module06.R")),
            file.copy(file.path(module, "data/dictionnaires.md"), file.path(dossier, "data/dictionnaires.md")))
  writeLines(c("Version: 1.0", "RestoreWorkspace: No", "SaveWorkspace: No", "AlwaysSaveHistory: No"),
             file.path(dossier, paste0(nom, ".Rproj")))
  qmd <- file.path(dossier, paste0(gsub("-", "_", nom), ".qmd"))
  writeLines(texte, qmd, useBytes = TRUE)
  if (complet) knitr::purl(qmd, output = sub("qmd$", "R", qmd), documentation = 1, quiet = TRUE)
  writeLines(c(paste0("# ", titre), "", "1. Décompressez toute l’archive.",
    "2. Ouvrez le fichier .Rproj, puis le document .qmd.",
    "3. Installez une fois tidyverse et forecast si nécessaire. R, RStudio et Quarto sont requis.",
    if (complet) "4. Exécutez le code dans l’ordre ou utilisez Render. Le script .R reprend les calculs." else
      "4. Complétez les six sections principales; les deux dernières sont facultatives. Le document se rend dès l’ouverture.",
    "5. Redémarrez R avant le rendu final. Conservez les dossiers R/ et data/.",
    "", "Les données sont simulées pour l’enseignement. Ce projet est un entraînement, pas une remise évaluée.",
    "Les deux compléments et les exercices de consolidation sont facultatifs.",
    "Les calculs utilisent uniquement les fichiers fournis; les liens bibliographiques sont des lectures complémentaires en ligne."),
    file.path(dossier, "README.md"), useBytes = TRUE)
  archive <- file.path(normalizePath(destination), paste0(nom, ".zip"))
  precedent <- getwd()
  setwd(base)
  tryCatch(utils::zip(archive, list.files(nom, recursive = TRUE, full.names = TRUE), flags = "-q"),
           finally = setwd(precedent))
}

bloc <- function(texte, label) {
  motif <- paste0("(?s)```\\{r\\}\\n#\\| label: ", label, ".*?```")
  regmatches(texte, regexpr(motif, texte, perl = TRUE))
}
intro <- function(titre, preparation) paste0(entete(titre),
  "## Préparation\n\n", preparation, "\n\n",
  paste0("## ", seq_along(etapes), ". ", etapes, ifelse(seq_along(etapes) > 6, " (facultatif)", ""),
         "\n\nAjoutez votre code, vos résultats et votre interprétation après l’activité correspondante du module.\n", collapse = "\n"),
  "\n## Conclusion\n\nJustifiez la référence retenue à partir des mesures, nommez une limite et précisez quand réévaluer les erreurs.\n")
etapes <- c("Cible et horizons", "Composantes et graphiques", "Calendrier et anomalies",
            "Références à origine fixe", "Mesures et diagnostic des erreurs", "Incertitude",
            "Validation à origines mobiles", "Méthodes, combinaison et suivi")
demo <- source_autonome("demonstrations.qmd", "Consommation d’électricité : démonstration complète")
corrige <- source_autonome("exercices.qmd", "Demande hebdomadaire et consolidation : corrigés de pratique")
csv_electricite <- file.path(module, "data/consommation_electrique_batiment_quebec.csv")
csv_demande <- "modules/atelier-03-series-chronologiques/data/demande_hebdomadaire_quebec.csv"
preparer("prevision-electricite", csv_electricite,
         intro("Consommation d’électricité : mon analyse", bloc(demo, "preparation-calculs-06")), "Projet guidé")
preparer("prevision-demande", csv_demande,
         intro("Demande hebdomadaire : mon analyse", bloc(corrige, "preparation-exercices-06")), "Projet de transfert")
preparer("demonstration-electricite", csv_electricite, demo, "Démonstration complète", complet = TRUE)
preparer("corrige-demande", csv_demande, corrige, "Corrigés de pratique", complet = TRUE)
message("Quatre projets préparés dans ", destination)
