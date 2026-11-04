# Préparer les deux projets de la mission mensuelle du laboratoire 03.
# Les archives facultatives de l'ancien transfert restent distinctes.
library(knitr)

module <- normalizePath("modules/atelier-03-series-chronologiques")
destination <- normalizePath(file.path(module, "telechargements"))
lire <- function(chemin) paste(readLines(chemin, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
entete <- function(titre) paste0('---\ntitle: "', titre,
  '"\nlang: fr\nformat:\n  html:\n    embed-resources: true\n    code-copy: true\n    code-overflow: wrap\nexecute:\n  warning: false\n  message: false\n---\n\n')

guide <- lire(file.path(module, "guide-atelier.qmd"))
demo <- lire(file.path(module, "demonstrations.qmd"))
mission <- sub('(?s).*?## Une seule mission\\n\\n(.*?)\\n\\n.*', '\\1', guide, perl = TRUE)
stopifnot(grepl("Dans un seul rapport Quarto", mission, fixed = TRUE))

etapes <- vapply(seq_len(5), function(i) {
  motif <- paste0('(?s)## ', i, '\\. [^\\n]+\\n\\n[^\\n]+')
  resultat <- regmatches(guide, regexpr(motif, guide, perl = TRUE))
  stopifnot(length(resultat) == 1L, nzchar(resultat))
  gsub(' \\{#[^}]+\\}', '', resultat)
}, character(1))

# Le bloc caché de recherche du chemin est utile au site, pas au projet extrait.
demo_portable <- sub('(?s)^---\\n.*?\\n---\\n', '', demo, perl = TRUE)
demo_portable <- gsub('(?s)```\\{r\\}\\n#\\| include: false\\n.*?```\\n', '', demo_portable, perl = TRUE)
demo_portable <- gsub('\\[([^]\\n]+)\\]\\((telechargements/[^)]+|[^)]*\\.qmd[^)]*)\\)', '\\1', demo_portable, perl = TRUE)
bloc_preparation <- regmatches(demo_portable, regexpr('(?s)```\\{r\\}\\n#\\| label: preparation-labo03-mensuel\\n.*?```', demo_portable, perl = TRUE))
stopifnot(length(bloc_preparation) == 1L, nzchar(bloc_preparation))

introduction <- paste0('## Mission\n\n', mission,
  '\n\nLes données sont fictives. Les 60 mois de 2020 à 2024 servent à l’apprentissage; les 12 mois de 2025 servent à comparer les méthodes. Ce bloc utilisé pour le choix n’est pas un test final indépendant.\n\n',
  'Avant la mission, reprenez les résultats hebdomadaires du module 07 : un nouveau candidat ou un coût fictif peut modifier une recommandation. Il n’est pas nécessaire de refaire les quatre prévisions.\n\n')
rapport <- paste0(entete("Mon rapport du laboratoire 03"), introduction,
  '## Préparation\n\n', bloc_preparation, '\n\n',
  paste0(etapes, '\n\nAjoutez votre code, vos résultats et votre interprétation.\n\n', collapse = ''),
  '## Point de contrôle et rétroaction\n\nPrésentez votre protocole de mini-rapport et notez un point de rétroaction ainsi que votre correction ou votre choix justifié.\n')
exemple <- paste0(entete("Exemple complet du laboratoire 03"), demo_portable)

preparer <- function(nom, fichier, texte, complet = FALSE) {
  base <- tempfile("mqt-laboratoire03-")
  dossier <- file.path(base, nom)
  dir.create(file.path(dossier, "data"), recursive = TRUE)
  dir.create(file.path(dossier, "R"))
  on.exit(unlink(base, recursive = TRUE), add = TRUE)
  stopifnot(file.copy(file.path(module, "data/livraisons_mensuelles_fictives.csv"), file.path(dossier, "data")))
  stopifnot(file.copy(file.path(module, "R/generer-livraisons.R"), file.path(dossier, "R")))
  qmd <- file.path(dossier, fichier)
  writeLines(texte, qmd, useBytes = TRUE)
  if (complet) knitr::purl(qmd, output = sub("qmd$", "R", qmd), quiet = TRUE)
  writeLines(c("Version: 1.0", "RestoreWorkspace: No", "SaveWorkspace: No", "AlwaysSaveHistory: No"),
             file.path(dossier, paste0(nom, ".Rproj")))
  writeLines(c(paste0("# ", nom), "", "Décompressez le dossier et ouvrez le projet dans RStudio.",
    "R, Quarto et tidyverse sont nécessaires. Rendez le fichier Quarto après avoir redémarré R.",
    "La série représente 72 mois de livraisons fictives. Le bloc 2025 sert à choisir et n’est pas un test final indépendant.",
    "Le script R/generer-livraisons.R régénère le CSV dans la copie courante à partir de la graine 210103.",
    "Les coûts sont fictifs. La mission est une pratique distincte du mini-rapport.",
    "Matériel du cours MQT-2101, Université Laval; données simulées pour le cours."),
    file.path(dossier, "README.md"), useBytes = TRUE)
  writeLines(c("# Données de livraisons fictives", "", "Une ligne représente un mois de janvier 2020 à décembre 2025.",
    "date : premier jour du mois; livraisons : nombre simulé de livraisons durant le mois.",
    "La série ne comporte aucune valeur manquante; les observations successives sont temporellement liées."),
    file.path(dossier, "data/README.md"), useBytes = TRUE)
  archive <- file.path(destination, paste0(nom, ".zip"))
  if (file.exists(archive)) unlink(archive)
  avant <- getwd(); setwd(base)
  statut <- tryCatch(utils::zip(archive, list.files(nom, recursive = TRUE, full.names = TRUE), flags = "-q -X"),
                     finally = setwd(avant))
  stopifnot(statut == 0L)
}
preparer("laboratoire-03", "rapport-labo-03.qmd", rapport)
preparer("exemple-laboratoire-03", "exemple-labo-03.qmd", exemple, TRUE)
message("Deux projets mensuels du laboratoire 03 préparés.")
