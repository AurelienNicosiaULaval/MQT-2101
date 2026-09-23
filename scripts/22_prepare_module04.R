# Préparer les projets étudiants du module 4 à partir des sources publiques.
# Exécuter à la racine du dépôt. Aucun ajustement ni donnée privée n’est ajouté.
library(knitr)

module <- "modules/semaine-04-regression-nonlineaire"
destination <- file.path(module, "telechargements")
dir.create(destination, recursive = TRUE, showWarnings = FALSE)
site <- "https://aureliennicosiaulaval.github.io/MQT-2101/"

lire <- function(path) paste(readLines(path, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
entete <- function(titre) paste0('---\ntitle: "', titre,
  '"\nlang: fr\nformat:\n  html:\n    embed-resources: true\n    code-copy: true\nexecute:\n  warning: false\n  message: false\n---\n\n')

# Le seul bloc retiré configure la racine du site, sans calcul statistique.
# Tous les blocs visibles restent présents, dont la fonction nombre_fr().
source_autonome <- function(nom, titre) {
  texte <- lire(file.path(module, nom))
  texte <- sub("(?s)^---\\n.*?\\n---\\n", "", texte, perl = TRUE)
  texte <- gsub("(?s)```\\{r\\}\\n#\\| label: racine-[^`]*```\\n", "", texte, perl = TRUE)
  # Les liens de lecture continuent d’ouvrir les ressources publiques du cours.
  liens <- regmatches(texte, gregexpr("\\]\\(([^ )]+)\\)", texte, perl = TRUE))[[1]]
  for (lien in unique(liens)) {
    cible <- substr(lien, 3, nchar(lien) - 1)
    if (grepl("^(https?://|#)", cible)) next
    cible <- sub("\\.qmd(?=#|$)", ".html", cible, perl = TRUE)
    morceaux <- strsplit(paste(module, cible, sep = "/"), "/", fixed = TRUE)[[1]]
    resolu <- character()
    for (morceau in morceaux) {
      if (morceau == "..") resolu <- head(resolu, -1) else if (morceau != ".") resolu <- c(resolu, morceau)
    }
    nouveau <- paste0("](", site, paste(resolu, collapse = "/"), ")")
    texte <- gsub(lien, nouveau, texte, fixed = TRUE)
  }
  paste0(entete(titre), texte, "\n")
}

preparer <- function(nom, donnees, texte, titre, complet = FALSE) {
  base <- tempfile(paste0(nom, "-"))
  dossier <- file.path(base, nom)
  dir.create(file.path(dossier, "data"), recursive = TRUE)
  on.exit(unlink(base, recursive = TRUE), add = TRUE)
  file.copy(donnees, file.path(dossier, "data", basename(donnees)))
  file.copy(file.path(module, "data/dictionnaires.md"), file.path(dossier, "data/dictionnaires.md"))
  writeLines(c("Version: 1.0", "RestoreWorkspace: No", "SaveWorkspace: No", "AlwaysSaveHistory: No"),
             file.path(dossier, paste0(nom, ".Rproj")))
  qmd <- file.path(dossier, paste0(gsub("-", "_", nom), ".qmd"))
  writeLines(texte, qmd, useBytes = TRUE)
  if (complet) knitr::purl(qmd, output = sub("qmd$", "R", qmd), documentation = 1, quiet = TRUE)
  writeLines(c(paste0("# ", titre), "", "1. Décompressez toute l’archive avant d’ouvrir le fichier .Rproj.",
    "2. Les préalables sont R, RStudio, Quarto et le package tidyverse (voir le guide d’installation du cours).",
    "3. Ouvrez le document .qmd. Le dossier data contient le CSV et les dictionnaires.",
    if (complet) "4. Après votre tentative, exécutez le code dans l’ordre ou cliquez sur Render. Le script .R reprend tous les calculs." else
      "4. Le document se rend dès l’ouverture. Complétez les sections avec les blocs et les explications accessibles sur le site.",
    "5. Redémarrez R, puis utilisez Render : le document doit se recalculer sans objets de console.",
    "", paste0("Parcours : ", site, module, "/index.html"),
    "Les données sont simulées pour l’enseignement. Ces projets sont des entraînements et ne constituent pas une remise évaluée."),
    file.path(dossier, "README.md"), useBytes = TRUE)
  archive <- normalizePath(file.path(destination), mustWork = TRUE)
  archive <- file.path(archive, paste0(nom, ".zip"))
  precedent <- getwd()
  setwd(base)
  tryCatch(utils::zip(archive, files = list.files(nom, recursive = TRUE, full.names = TRUE), flags = "-q"),
           finally = setwd(precedent))
}

guide <- source_autonome("demonstrations.qmd", "Achalandage et ventes : démonstration complète")
corrige <- source_autonome("exercices.qmd", "Utilisation et attente : corrigés détaillés")
# Extraire seulement l’importation publique pour les documents de départ.
bloc <- function(texte, label) {
  motif <- paste0("(?s)```\\{r\\}\\n#\\| label: ", label, ".*?```")
  regmatches(texte, regexpr(motif, texte, perl = TRUE))
}
intro <- function(titre, code, activites) paste0(entete(titre),
  "## Préparation\n\n", code, "\n\n",
  paste0("## ", seq_along(activites), ". ", activites, "\n\nAjoutez votre code, vos résultats et votre interprétation après avoir suivi l’étape correspondante du site.\n", collapse = "\n"))
preparer("comparaison-achalandage", file.path(module, "data/achalandage_saturation_quebec.csv"),
  intro("Achalandage et ventes : mon analyse", bloc(guide, "importation-demo-04"),
    c("Nuage et unités", "Indices de contexte", "Trois modèles et différences prédites", "Comparaison et résidus", "Prédictions et extrapolation", "Conclusion")), "Projet guidé")
preparer("comparaison-attente", "modules/atelier-04-recapitulation/data/cas_integrateur_quebec.csv",
  intro("Utilisation et attente : mon analyse", bloc(corrige, "preparation-exercices-04"),
    c("Graphique", "Deux modèles", "RMSE", "Diagnostic et scénarios", "Conclusion", "Vérification du rapport")), "Projet d’exercices")
preparer("demonstration-achalandage", file.path(module, "data/achalandage_saturation_quebec.csv"), guide,
         "Démonstration complète", complet = TRUE)
preparer("corrige-attente", "modules/atelier-04-recapitulation/data/cas_integrateur_quebec.csv", corrige,
         "Corrigés des quatorze exercices", complet = TRUE)
message("Quatre projets préparés dans ", destination)
