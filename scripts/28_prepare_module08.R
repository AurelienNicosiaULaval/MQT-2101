# Préparer les quatre projets du socle et le cahier facultatif du module 08.
library(knitr)
module <- "modules/semaine-08-tendance-saisonnalite"
destination <- file.path(module, "telechargements")
dir.create(destination, recursive = TRUE, showWarnings = FALSE)
lire <- function(p) paste(readLines(p, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
entete <- function(titre) paste0('---\ntitle: "', titre,
  '"\nlang: fr\nformat:\n  html:\n    embed-resources: true\n    code-copy: true\n    code-fold: false\n    code-overflow: wrap\nexecute:\n  warning: false\n  message: false\n---\n\n')
portable <- function(fichier, titre) {
  s <- sub("(?s)^---\\n.*?\\n---\\n", "", lire(file.path(module, fichier)), perl = TRUE)
  s <- gsub("(?s)```\\{r\\}\\n#\\| include: false\\n.*?```\\n", "", s, perl = TRUE)
  # Les liens de données et les ancres internes restent locaux. Les autres
  # pages et téléchargements peuvent précéder leur version publique.
  s <- gsub('\\[([^]\\n]+)\\]\\((telechargements/[^)]+|(lectures|demonstrations|exercices|capsules|notes-cours|index|complements|decomposition-guidee)\\.qmd[^)]*)\\)',
            '\\1', s, perl = TRUE)
  paste0(entete(titre), s, "\n")
}
bloc <- function(s, label) {
  motif <- paste0("(?s)```\\{r\\}\\n#\\| label: ", label, "\\n.*?```")
  r <- regmatches(s, regexpr(motif, s, perl = TRUE))
  stopifnot(length(r) == 1, nzchar(r))
  r
}
preparer <- function(nom, rapport, texte, complet = FALSE, facultatif = FALSE) {
  base <- tempfile("mqt08-projet-")
  dossier <- file.path(base, nom)
  dir.create(file.path(dossier, "data"), recursive = TRUE)
  dir.create(file.path(dossier, "R"))
  on.exit(unlink(base, recursive = TRUE), add = TRUE)
  donnees <- list.files(file.path(module, "data"), pattern = "\\.(csv|md)$", full.names = TRUE)
  stopifnot(all(file.copy(donnees, file.path(dossier, "data"))))
  stopifnot(all(file.copy(file.path(module, c("R/fonctions-module08.R", "R/regenerer-donnees.R")),
                         file.path(dossier, "R"))))
  qmd <- file.path(dossier, paste0(rapport, ".qmd"))
  writeLines(texte, qmd, useBytes = TRUE)
  if (nom %in% c("tendance-ventes", "demonstration-tendance-ventes")) {
    stopifnot(file.copy(file.path(module, "decomposition-guidee.qmd"),
                        file.path(dossier, "decomposition-guidee.qmd")))
  }
  if (complet) knitr::purl(qmd, output = sub("qmd$", "R", qmd), quiet = TRUE)
  writeLines(c("Version: 1.0", "RestoreWorkspace: No", "SaveWorkspace: No",
               "AlwaysSaveHistory: No"), file.path(dossier, paste0(nom, ".Rproj")))
  writeLines(c(paste0("# ", nom), "", "Module 08, automne 2026.",
    "1. Décompressez toute l’archive et ouvrez le .Rproj.",
    "2. Installez tidyverse et broom si nécessaire. R, RStudio et Quarto sont requis.",
    if (facultatif) "3. Installez aussi forecast et tseries au besoin." else if (nom %in% c("tendance-ventes", "demonstration-tendance-ventes"))
      "3. Pour lire la décomposition, ouvrez decomposition-guidee.qmd, installez forecast au besoin et cliquez sur Render." else
      "3. Les cinq exercices suivis se font avec le fichier de ventes commerciales.",
    "4. Ouvrez le .qmd, redémarrez R, puis faites Render. Les projets de départ se rendent avant d’être complétés.",
    if (complet) "5. Les blocs visibles s’exécutent dans l’ordre. Le script .R reprend les calculs." else
      "5. Ajoutez vos calculs et interprétations à chaque étape, une seule fois.",
    "6. Conservez data/ et R/. Aucun objet créé seulement dans la console n’est requis.",
    "", "Deux séries québécoises entièrement simulées. Chaque fichier décrit 72 mois, janvier 2020 à décembre 2025.",
    "Les calculs apprennent sur 60 mois, puis comparent 12 mois. La validation sert au choix, sans test final indépendant.",
    if (facultatif) "Cahier de consolidation et d’ouverture: aucun nouveau rapport obligatoire et aucune exigence de tout utiliser." else
      "Le rapport est un entraînement. Les compléments ne sont pas requis dans la trace principale.",
    "Le budget cible n’est pas un prédicteur. Les prix et promotions futurs observés ne sont pas utilisés dans le socle.",
    "Les exercices commerciaux accompagnés utilisent explicitement un contexte réalisé ou un scénario hypothétique.",
    "Pour régénérer les deux CSV dans une copie: source('R/regenerer-donnees.R'). Ce script réécrit les fichiers locaux.",
    "Les liens officiels des ouvrages sont des compléments en ligne; les calculs utilisent seulement les fichiers fournis.",
    "Attribution: matériel du cours MQT-2101, Université Laval; données simulées redistribuables avec le cours.",
    "Ancien notebook Amtrak consulté: Paolo Landa, 16 mars 2021. Les anciens documents protégés ne sont pas inclus."),
    file.path(dossier, "README.md"), useBytes = TRUE)
  archive <- file.path(normalizePath(destination), paste0(nom, ".zip"))
  if (file.exists(archive)) unlink(archive)
  avant <- getwd();setwd(base)
  tryCatch(utils::zip(archive, list.files(nom, recursive = TRUE, full.names = TRUE), flags = "-q"),
           finally = setwd(avant))
}
demo <- portable("demonstrations.qmd", "Ventes : démonstration de tendance et saisonnalité")
corrige <- portable("exercices.qmd", "Commerce : exercices et corrigés de tendance et saisonnalité")
complements <- portable("complements.qmd", "Tendance : cahier facultatif de consolidation et d’ouverture")
consignes <- vapply(1:5, function(i) {
  s <- lire(file.path(module, sprintf("media/qmd/capsule-%02d-support.qmd", i)))
  motif <- "(?s)## Production autonome.*?::: \\{\\.lead\\}\\n(.*?)\\n:::"
  sub(motif, "\\1", regmatches(s, regexpr(motif, s, perl = TRUE)), perl = TRUE)
}, character(1))
stopifnot(all(nzchar(consignes)))
depart <- paste0(entete("Ventes : mon analyse de tendance et saisonnalité"),
  "## Préparation\n\n", bloc(demo, "preparation-m08"), "\n\n",
  "Données simulées. Ajustez sur les 60 mois de 2020 à 2024. Comparez les prévisions des quatre candidats sur 2025, à l’origine de fin 2024.\n\n",
  "Pour la lecture de la décomposition à l’activité 8.1, ouvrez le fichier `decomposition-guidee.qmd` de ce projet et cliquez sur Render. Notez un écart et une limite dans ce rapport.\n\n",
  paste0("## Activité 8.", 1:5, "\n\n", consignes,
         "\n\nAjoutez votre code, vos résultats et votre interprétation. Cette activité se réalise une seule fois.\n\n", collapse = ""))
source_ex <- lire(file.path(module, "exercices.qmd"))
enonces <- vapply(1:5, function(i) {
  motif <- paste0("(?s)## Exercice ", i, " - .*?\\n:::: \\{\\.callout-tip")
  s <- regmatches(source_ex, regexpr(motif, source_ex, perl = TRUE))
  stopifnot(nzchar(s));sub("\\n:::: \\{\\.callout-tip$", "", s)
}, character(1))
transfert <- paste0(entete("Commerce : mon analyse de tendance et saisonnalité"),
  "## Préparation\n\n", bloc(corrige, "preparation-transfert-m08"), "\n\n",
  "Quatre candidats: tendance seule, saison seule, tendance et mois, naïf saisonnier. Les variables commerciales futures ne sont pas des prédicteurs du socle.\n\n",
  paste0(enonces, "\n\nAjoutez votre code et votre interprétation avant le corrigé.\n\n", collapse = ""))
preparer("tendance-ventes", "tendance_ventes", depart)
preparer("tendance-commerce", "tendance_commerce", transfert)
preparer("demonstration-tendance-ventes", "tendance_ventes", demo, TRUE)
preparer("corrige-tendance-commerce", "tendance_commerce", corrige, TRUE)
preparer("complements-tendance", "complements_tendance", complements, TRUE, TRUE)
message("Quatre projets du socle et un cahier facultatif préparés.")
