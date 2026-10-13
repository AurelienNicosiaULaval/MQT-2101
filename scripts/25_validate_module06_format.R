#!/usr/bin/env Rscript

# Contrat de présentation du module 6, établi à partir des modules 1 à 4.
# Les vérifications visuelles et la couverture théorique restent dans l'audit enseignant.
module <- "modules/semaine-06-series-chronologiques-intro"
errors <- character()
read_text <- function(path) paste(readLines(path, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
require_condition <- function(ok, message) {
  if (!isTRUE(ok)) errors <<- c(errors, message)
}

pages <- c("index", "capsules", "demonstrations", "exercices", "lectures")
for (page in pages) {
  text <- read_text(file.path(module, paste0(page, ".qmd")))
  yaml <- strsplit(text, "\n---\n", fixed = TRUE)[[1]][1]
  require_condition(grepl("embed-resources: true", yaml, fixed = TRUE), paste(page, ": ressources non embarquées"))
  require_condition(grepl("toc-depth: 2", yaml, fixed = TRUE), paste(page, ": profondeur du sommaire différente"))
  require_condition(grepl("code-copy: true", yaml, fixed = TRUE), paste(page, ": copie du code absente"))
  require_condition(grepl("code-overflow: wrap", yaml, fixed = TRUE), paste(page, ": retour à la ligne du code absent"))
  require_condition(grepl("code-fold: false", yaml, fixed = TRUE), paste(page, ": code replié par défaut"))
  if (page %in% c("capsules", "demonstrations", "exercices")) {
    require_condition(grepl("(?m)^## Objectif$", text, perl = TRUE), paste(page, ": objectif de page absent"))
  }
}

capsules <- read_text(file.path(module, "capsules.qmd"))
starts <- gregexpr("(?m)^## (Capsule [1-6] -|Complément [AB] -)", capsules, perl = TRUE)[[1]]
require_condition(length(starts) == 8L, "Huit sections de supports étaient attendues")
if (length(starts) == 8L) {
  ends <- c(starts[-1] - 1L, nchar(capsules))
  for (i in seq_along(starts)) {
    block <- substr(capsules, starts[i], ends[i])
    headings <- regmatches(block, gregexpr("(?m)^### [^\n]+", block, perl = TRUE))[[1]]
    tabs <- sub("^### ", "", headings)
    expected <- if (i <= 6L) c("Vidéo", "PDF", "PDF annoté", "HTML") else c("PDF", "HTML")
    require_condition(identical(tabs, expected), paste("Support", i, ": onglets différents du format validé"))
    if (i <= 6L) {
      require_condition(grepl("Production guidée, à réaliser une seule fois", block, fixed = TRUE), paste("Capsule", i, ": production guidée absente"))
      require_condition(grepl('title="Exercice d’application distinct"', block, fixed = TRUE), paste("Capsule", i, ": exercice de transfert non identifié"))
    }
  }
}

index <- read_text(file.path(module, "index.qmd"))
count <- function(pattern, text) length(regmatches(text, gregexpr(pattern, text, perl = TRUE))[[1]])
require_condition(count('class="path-card"', index) == 6L, "Le parcours doit conserver six cartes")
require_condition(count('class="resource-row"', index) == 5L, "Le bas de page doit conserver cinq ressources")
lectures <- read_text(file.path(module, "lectures.qmd"))
require_condition(grepl("Statut et passage à lire", lectures, fixed = TRUE), "Le tableau des lectures doit préciser le statut")
require_condition(grepl("Ce qu’il faut en retenir", lectures, fixed = TRUE), "Le tableau des lectures doit préciser les acquis attendus")
require_condition(grepl(".table-responsive", lectures, fixed = TRUE), "Le tableau des lectures doit rester consultable sur petit écran")

for (i in 1:8) {
  path <- file.path(module, "media/qmd", sprintf("capsule-%02d-support.qmd", i))
  text <- read_text(path)
  for (setting in c("width: 1600", "height: 900", "margin: 0.06", "slide-number: c/t", "embed-resources: true")) {
    require_condition(grepl(setting, text, fixed = TRUE), paste(basename(path), ":", setting, "absent"))
  }
  require_condition(grepl("../../../../assets/ulaval-reveal.scss", text, fixed = TRUE), paste(basename(path), ": thème différent"))
  require_condition(grepl("(?m)^## Pourquoi ça compte$", text, perl = TRUE), paste(basename(path), ": accroche absente"))
  require_condition(grepl("(?m)^## À retenir$", text, perl = TRUE), paste(basename(path), ": synthèse absente"))
  require_condition(grepl("::: {.lead}", text, fixed = TRUE), paste(basename(path), ": consigne hors du style commun"))
  require_condition(grepl("::: {.self-check}", text, fixed = TRUE), paste(basename(path), ": auto-vérification absente"))
  check <- sub("(?s).*::: \\{\\.self-check\\}\\n(.*?)\\n:::.*", "\\1", text, perl = TRUE)
  require_condition(count("(?m)^- ", check) >= 3L, paste(basename(path), ": critères d'auto-vérification incomplets"))
}
notes <- read_text(file.path(module, "notes-cours.qmd"))
for (setting in c("width: 1600", "height: 900", "margin: 0.06", "slide-number: c/t", "embed-resources: true", "../../assets/ulaval-reveal.scss")) {
  require_condition(grepl(setting, notes, fixed = TRUE), paste("notes-cours.qmd :", setting, "absent"))
}

pdfs <- list.files(file.path(module, "media/pdf"), pattern = "[.]pdf$", full.names = TRUE)
require_condition(length(pdfs) == 15L, "Quinze PDF, dont six annotés, étaient attendus")
for (path in pdfs) {
  public <- file.path("docs", path)
  require_condition(file.exists(public), paste("PDF public absent :", path))
  if (file.exists(public)) require_condition(identical(unname(tools::md5sum(path)), unname(tools::md5sum(public))), paste("PDF public désynchronisé :", path))
}
archive <- file.path(module, "telechargements/module-06-pdf-2026-10-13.zip")
require_condition(file.exists(archive), "L'archive PDF datée est absente")
if (file.exists(archive)) {
  extraction <- tempfile("controle-pdf-module06-")
  dir.create(extraction)
  extracted <- utils::unzip(archive, exdir = extraction)
  archived_pdfs <- extracted[grepl("[.]pdf$", extracted)]
  require_condition(setequal(basename(archived_pdfs), basename(pdfs)), "L'archive PDF ne contient pas les quinze supports attendus")
  for (path in pdfs) {
    match <- archived_pdfs[basename(archived_pdfs) == basename(path)]
    require_condition(length(match) == 1L, paste("PDF absent ou répété dans l'archive :", basename(path)))
    if (length(match) == 1L) {
      require_condition(identical(unname(tools::md5sum(path)), unname(tools::md5sum(match))), paste("PDF périmé dans l'archive :", basename(path)))
    }
  }
  unlink(extraction, recursive = TRUE)
  require_condition(identical(unname(tools::md5sum(archive)), unname(tools::md5sum(file.path("docs", archive)))), "L'archive PDF publiée diffère de la source")
}
require_condition(!file.exists(file.path("docs", module, "solutions.html")), "Une page de solutions enseignantes ne doit pas être publiée")

cat("Format du module 06 : cinq pages, neuf supports et quinze PDF contrôlés.\n")
cat("Écarts :", length(errors), "\n")
if (length(errors)) {
  cat(paste0("- ", errors), sep = "\n")
  stop("Le module 06 s'écarte du format validé.")
}
