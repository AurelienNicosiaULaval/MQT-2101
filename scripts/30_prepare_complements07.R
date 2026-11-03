# Cahier facultatif ajouté après l'audit de couverture de l'ancienne séance.
library(knitr)
module <- normalizePath("modules/semaine-07-lissage")
base <- tempfile("mqt07-complements-")
dossier <- file.path(base, "complements-lissage")
dir.create(dossier, recursive = TRUE)
stopifnot(all(file.copy(file.path(module, c("data", "R")), dossier, recursive = TRUE)))
# Le code de production des diapositives n'est pas utile dans ce projet.
unlink(file.path(dossier, "R/analyse-supports.R"))
s <- paste(readLines(file.path(module, "complements.qmd"), warn = FALSE), collapse = "\n")
s <- sub("(?s)^---\\n.*?\\n---\\n", "", s, perl = TRUE)
s <- gsub("(?s)```\\{r\\}\\n#\\| include: false\\n.*?```\\n", "", s, perl = TRUE)
s <- gsub("\\[([^]\\n]+)\\]\\(telechargements/[^)]+\\)", "\\1", s, perl = TRUE)
entete <- '---\ntitle: "Lissage : cahier facultatif"\nlang: fr\nformat:\n  html:\n    embed-resources: true\n    code-copy: true\n    code-fold: false\n    code-overflow: wrap\nexecute:\n  warning: false\n  message: false\n---\n\n'
qmd <- file.path(dossier, "complements_lissage.qmd")
writeLines(paste0(entete, s, "\n"), qmd, useBytes = TRUE)
purl(qmd, output = file.path(dossier, "complements_lissage.R"), quiet = TRUE)
writeLines(c("Version: 1.0", "RestoreWorkspace: No", "SaveWorkspace: No", "AlwaysSaveHistory: No"),
           file.path(dossier, "complements-lissage.Rproj"))
writeLines(c("# Cahier facultatif du module 07", "",
  "Décompressez tout, ouvrez le .Rproj et redémarrez R avant Render du .qmd.",
  "Installez une fois tidyverse, slider et forecast si nécessaire. R, RStudio et Quarto sont requis.",
  "Le script .R reprend tous les calculs. Aucun objet de console ou accès au dépôt n'est requis.",
  "Ce cahier ne crée aucune production obligatoire. Le socle reste les quatre activités.",
  "L'électricité est une simulation québécoise; 60 mois d'apprentissage puis 12 mois déjà connus.",
  "Différences réintégrées, Holt-Winters, ETS, BATS, TBATS et STL sont des illustrations, sans gain garanti.",
  "R/regenerer-donnees.R réécrit les deux CSV dans la copie courante, sans toucher au dépôt.",
  "Attribution: cours MQT-2101, Université Laval. Données simulées redistribuables avec le cours.",
  "Ancien script consulté: Paolo Landa (16 mars 2021). Aucun ancien document protégé n'est inclus."),
  file.path(dossier, "README.md"), useBytes = TRUE)
archive <- file.path(module, "telechargements/complements-lissage.zip")
if (file.exists(archive)) unlink(archive)
setwd(base)
utils::zip(archive, list.files("complements-lissage", recursive = TRUE, full.names = TRUE), flags = "-q")
message("Cahier facultatif du module 07 préparé.")
