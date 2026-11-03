# Préparer des projets autonomes à partir des sources du laboratoire 03.
library(knitr)
module <- normalizePath('modules/atelier-03-series-chronologiques')
dest <- file.path(module, 'telechargements')
lire <- function(p) paste(readLines(p, warn = FALSE, encoding = 'UTF-8'), collapse = '\n')
entete <- function(titre) paste0('---\ntitle: "', titre, '"\nlang: fr\nformat:\n  html:\n    embed-resources: true\n    code-copy: true\n    code-fold: false\n    code-overflow: wrap\nexecute:\n  warning: false\n  message: false\n---\n\n')
portable <- function(nom, titre) {
  s <- sub('(?s)^---\\n.*?\\n---\\n', '', lire(file.path(module, nom)), perl = TRUE)
  s <- gsub('(?s)```\\{r\\}\\n#\\| include: false\\n.*?```\\n', '', s, perl = TRUE)
  # Supprimer uniquement les liens vers les pages du site ou leurs téléchargements.
  s <- gsub('\\[([^]\\n]+)\\]\\((telechargements/[^)]+|(guide-atelier|demonstrations|exercices|capsules|lectures|presentation|index)\\.qmd[^)]*|\\.\\./[^)]*\\.qmd[^)]*)\\)', '\\1', s, perl = TRUE)
  paste0(entete(titre), s, '\n')
}
bloc <- function(s, label) {
  motif <- paste0('(?s)```\\{r\\}\\n#\\| label: ', label, '\\n.*?```')
  a <- regmatches(s, regexpr(motif, s, perl = TRUE));stopifnot(length(a) == 1, nzchar(a));a
}
mission <- trimws(lire('output/revision-laboratoire03-20261027/mission.txt'))
steps <- jsonlite::fromJSON('output/revision-laboratoire03-20261027/etapes.json', simplifyVector = FALSE)
demo <- portable('demonstrations.qmd', 'Demande : exemple complet du laboratoire 03')
corrige <- portable('exercices.qmd', 'Ventes : corrigé du transfert du laboratoire 03')
depart <- paste0(entete('Demande : mon rapport du laboratoire 03'),
  '## Mission\n\n', mission, '\n\nCe rapport regroupe les cinq étapes une seule fois.\n\n',
  '## Préparation\n\n', bloc(demo, 'preparation-labo03'), '\n\n',
  paste(vapply(seq_along(steps), function(i) paste0('## ', i, '. ', steps[[i]][[1]], '\n\n', steps[[i]][[4]],
    '\n\nAjoutez votre code, vos résultats et leur interprétation ici.\n'), character(1)), collapse = '\n'),
  '\n## Rétroaction et bilan\n\nIndiquez un point reçu, votre correction ou votre choix justifié et l’aide utilisée.\n')
source_ex <- lire(file.path(module, 'exercices.qmd'))
enonces <- vapply(1:6, function(i) {
  motif <- if (i <= 4) paste0('(?s)## Exercice ', i, ' - .*?\\n:::: \\{\\.callout-tip') else
    paste0('(?s)## Pratique ', i, ' - .*?\\n:::: \\{\\.callout-tip')
  s <- regmatches(source_ex, regexpr(motif, source_ex, perl = TRUE));stopifnot(nzchar(s));sub('\\n:::: \\{\\.callout-tip$', '', s)
}, character(1))
transfert <- paste0(entete('Ventes : mon transfert facultatif'),
  '## Préparation\n\n', bloc(corrige, 'preparation-transfert-labo03'), '\n\n',
  'Données simulées; 60 mois pour apprendre et 12 mois de validation déjà connue.\n\n',
  paste0(enonces, '\n\nAjoutez votre réponse et, si nécessaire, votre code.\n\n', collapse = ''))
preparer <- function(nom, fichier, texte, complet, facultatif) {
  base <- tempfile('mqt-laboratoire03-');d <- file.path(base, nom)
  dir.create(file.path(d, 'data'), recursive = TRUE);dir.create(file.path(d, 'R'))
  on.exit(unlink(base, recursive = TRUE), add = TRUE)
  data <- list.files(file.path(module, 'data'), pattern = '\\.(csv|md)$', full.names = TRUE)
  stopifnot(all(file.copy(data, file.path(d, 'data'))),
            file.copy(file.path(module, 'R/regenerer-donnees.R'), file.path(d, 'R')))
  q <- file.path(d, paste0(fichier, '.qmd'));writeLines(texte, q, useBytes = TRUE)
  if (complet) purl(q, output = sub('qmd$', 'R', q), quiet = TRUE)
  writeLines(c('Version: 1.0', 'RestoreWorkspace: No', 'SaveWorkspace: No', 'AlwaysSaveHistory: No'),
             file.path(d, paste0(nom, '.Rproj')))
  writeLines(c(paste0('# ', nom), '', 'Version locale du 27 octobre 2026.',
    '1. Décompressez toute l’archive et ouvrez le .Rproj dans RStudio.',
    '2. Installez une fois tidyverse et forecast si nécessaire. R, RStudio et Quarto sont requis.',
    '3. Ouvrez le .qmd, redémarrez R et faites Render. Conservez data/ et R/.',
    if (complet) '4. Le .qmd et le .R reprennent les calculs complets depuis une session neuve.' else
      '4. Le premier rendu fonctionne; ajoutez ensuite vos résultats et interprétations aux sections.',
    if (facultatif) 'Cette pratique est facultative et ne crée pas un deuxième rapport obligatoire.' else
      'Le rapport de laboratoire est une pratique distincte du mini-rapport 2.',
    'Les deux jeux sont fictifs, entièrement simulés et redistribuables avec le cours.',
    'Les périodes de validation sont déjà connues; les scores servent au choix, sans test final indépendant.',
    'Coûts pédagogiques fictifs; aucune commande ni politique de stock optimale n’est calculée.',
    'Pour reproduire les CSV dans la copie seulement : source("R/regenerer-donnees.R").',
    'Attribution : matériel du cours MQT-2101, Université Laval; données simulées du cours.',
    'Les anciennes archives, données de tiers et fichiers enseignants ne sont pas inclus.'),
    file.path(d, 'README.md'), useBytes = TRUE)
  archive <- file.path(dest, paste0(nom, '.zip'));if (file.exists(archive)) unlink(archive)
  avant <- getwd();setwd(base);on.exit(setwd(avant), add = TRUE)
  status <- utils::zip(archive, list.files(nom, recursive = TRUE, full.names = TRUE), flags = '-q -X')
  stopifnot(status == 0L)
}
preparer('laboratoire-03', 'rapport-labo-03', depart, FALSE, FALSE)
preparer('exemple-laboratoire-03', 'exemple-labo-03', demo, TRUE, FALSE)
preparer('transfert-labo-03', 'transfert-labo-03', transfert, FALSE, TRUE)
preparer('corrige-transfert-labo-03', 'corrige-transfert-labo-03', corrige, TRUE, TRUE)
message('Quatre projets autonomes préparés.')
