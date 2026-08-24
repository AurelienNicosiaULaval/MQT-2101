# Vérifie les invariants pédagogiques et techniques communs aux modules.
# Exécuter depuis la racine du projet :
# Rscript scripts/12_validate_module_coherence.R

course_modules <- data.frame(
  id = c(
    "semaine-01-introduction",
    "semaine-02-r-quarto",
    "semaine-03-regression-lineaire",
    "semaine-04-regression-nonlineaire",
    "semaine-05-preparation-intra",
    "semaine-06-series-chronologiques-intro",
    "semaine-07-lissage",
    "semaine-08-tendance-saisonnalite",
    "semaine-09-variables-externes-autocorrelation",
    "semaine-10-classification-modeles-avances"
  ),
  capsules = c(6L, 6L, 6L, 6L, 6L, 4L, 4L, 4L, 4L, 4L),
  stringsAsFactors = FALSE
)

workshops <- c(
  "atelier-01-r",
  "atelier-02-regression",
  "atelier-03-series-chronologiques",
  "atelier-04-recapitulation"
)

required_module_files <- c(
  "index.qmd",
  "capsules.qmd",
  "notes-cours.qmd",
  "demonstrations.qmd",
  "exercices.qmd",
  "lectures.qmd",
  "solutions.qmd",
  "data/README.md"
)

required_workshop_files <- c(
  "index.qmd",
  "capsules.qmd",
  "guide-atelier.qmd",
  "demonstrations.qmd",
  "exercices.qmd",
  "lectures.qmd",
  "solutions.qmd",
  "data/README.md"
)

errors <- character()
warnings <- character()

add_error <- function(message) {
  errors <<- c(errors, message)
}

add_warning <- function(message) {
  warnings <<- c(warnings, message)
}

read_text <- function(path) {
  paste(readLines(path, warn = FALSE), collapse = "\n")
}

count_matches <- function(pattern, text) {
  matches <- gregexpr(pattern, text, perl = TRUE)[[1]]
  if (identical(matches, -1L)) 0L else length(matches)
}

check_required_files <- function(module_id, required_files) {
  directory <- file.path("modules", module_id)
  missing <- required_files[!file.exists(file.path(directory, required_files))]

  if (length(missing)) {
    add_error(paste0(module_id, " : fichiers manquants : ", paste(missing, collapse = ", ")))
  }
}

for (i in seq_len(nrow(course_modules))) {
  module_id <- course_modules$id[[i]]
  expected_capsules <- course_modules$capsules[[i]]
  directory <- file.path("modules", module_id)

  check_required_files(module_id, required_module_files)

  capsules_path <- file.path(directory, "capsules.qmd")
  index_path <- file.path(directory, "index.qmd")

  if (file.exists(capsules_path)) {
    capsules_text <- read_text(capsules_path)
    actual_capsules <- count_matches("(?m)^## Capsule [0-9]+", capsules_text)

    if (actual_capsules != expected_capsules) {
      add_error(paste0(module_id, " : ", actual_capsules, " capsules trouvées, ", expected_capsules, " attendues."))
    }
  }

  deck_paths <- sort(list.files(
    file.path(directory, "media", "qmd"),
    pattern = "^capsule-[0-9]{2}-support[.]qmd$",
    full.names = TRUE
  ))

  if (length(deck_paths) != expected_capsules) {
    add_error(paste0(module_id, " : ", length(deck_paths), " decks RevealJS trouvés, ", expected_capsules, " attendus."))
  }

  for (deck_path in deck_paths) {
    deck_text <- read_text(deck_path)
    expected_sections <- c(
      "revealjs",
      "## Pourquoi ça compte",
      "## Objectifs de la capsule",
      "## À retenir",
      "## Production autonome",
      "### Auto-vérification"
    )
    missing_sections <- expected_sections[
      !vapply(expected_sections, grepl, logical(1), x = deck_text, fixed = TRUE)
    ]

    if (length(missing_sections)) {
      add_error(paste0(
        deck_path,
        " : éléments de deck manquants : ",
        paste(missing_sections, collapse = ", ")
      ))
    }
  }

  if (file.exists(index_path)) {
    index_text <- read_text(index_path)
    has_purpose <- any(vapply(
      c(
        "Pourquoi ça compte",
        "Objectif de la préparation",
        "On passe au concret",
        "Ce module"
      ),
      grepl,
      logical(1),
      x = index_text,
      fixed = TRUE
    ))
    has_path <- any(vapply(
      c("Votre parcours", "Parcours recommandé", "## Parcours"),
      grepl,
      logical(1),
      x = index_text,
      fixed = TRUE
    ))
    has_self_check <- grepl("Auto-vérification", index_text, fixed = TRUE)

    if (!has_purpose) add_warning(paste0(module_id, " : objectif ou mise en contexte à rendre explicite."))
    if (!has_path) add_warning(paste0(module_id, " : parcours étudiant à rendre explicite."))
    if (!has_self_check) add_warning(paste0(module_id, " : auto-vérification à ajouter ou justifier."))
  }

  module_paths <- list.files(directory, pattern = "[.]qmd$", full.names = TRUE)
  module_text <- paste(vapply(module_paths, read_text, character(1)), collapse = "\n")
  has_concrete_trace <- any(vapply(
    c("Trace finale", "Production attendue", "À produire", ">Production<"),
    grepl,
    logical(1),
    x = module_text,
    fixed = TRUE
  ))

  if (!has_concrete_trace) {
    add_error(paste0(module_id, " : aucune trace ou production concrète annoncée."))
  }
}

for (workshop in workshops) {
  check_required_files(workshop, required_workshop_files)
}

extract_csv_names <- function(text) {
  matches <- regmatches(
    text,
    gregexpr("[A-Za-z0-9_-]+[.]csv", text, perl = TRUE)
  )[[1]]

  if (identical(matches, -1L)) character() else unique(matches)
}

extract_transfer_dataset <- function(path) {
  lines <- readLines(path, warn = FALSE)
  marker <- grep("Jeu de données de transfert", lines, fixed = TRUE)

  if (length(marker) != 1L) {
    return(character())
  }

  following_lines <- lines[seq.int(marker[[1]], min(length(lines), marker[[1]] + 2L))]
  extract_csv_names(paste(following_lines, collapse = "\n"))
}

learning_units <- c(course_modules$id, workshops)
published_csv <- basename(list.files(
  "modules",
  pattern = "[.]csv$",
  recursive = TRUE,
  full.names = TRUE
))

for (unit_id in learning_units) {
  directory <- file.path("modules", unit_id)
  exercise_path <- file.path(directory, "exercices.qmd")

  if (!file.exists(exercise_path)) {
    next
  }

  transfer_dataset <- extract_transfer_dataset(exercise_path)
  if (length(transfer_dataset) != 1L) {
    add_error(paste0(unit_id, " : un seul jeu de données de transfert doit être annoncé."))
    next
  }

  if (!transfer_dataset %in% published_csv) {
    add_error(paste0(
      unit_id,
      " : jeu de données de transfert introuvable : ",
      transfer_dataset,
      "."
    ))
  }

  guided_paths <- c(
    file.path(directory, "capsules.qmd"),
    file.path(directory, "guide-atelier.qmd"),
    list.files(
      file.path(directory, "media", "qmd"),
      pattern = "^capsule-[0-9]{2}-support[.]qmd$",
      full.names = TRUE
    )
  )
  guided_paths <- guided_paths[file.exists(guided_paths)]
  guided_text <- paste(vapply(guided_paths, read_text, character(1)), collapse = "\n")
  guided_datasets <- extract_csv_names(guided_text)

  if (transfer_dataset %in% guided_datasets) {
    add_error(paste0(
      unit_id,
      " : le jeu de données de transfert est déjà utilisé dans le parcours guidé : ",
      transfer_dataset,
      "."
    ))
  }
}

all_student_text <- paste(vapply(
  list.files("modules", pattern = "[.]qmd$", recursive = TRUE, full.names = TRUE),
  read_text,
  character(1)
), collapse = "\n")

audience_markers <- c(
  administration = "administr",
  genie = "génie|ingénier"
)

for (audience in names(audience_markers)) {
  if (!grepl(audience_markers[[audience]], all_student_text, ignore.case = TRUE, perl = TRUE)) {
    add_error(paste0("Public insuffisamment représenté dans les modules : ", audience, "."))
  }
}

transition_checks <- c(
  "semaine-05-preparation-intra/index.qmd" = "Après l'examen intra",
  "semaine-06-series-chronologiques-intro/index.qmd" = "Passage au bloc de prévision",
  "semaine-07-lissage/index.qmd" = "Continuité du parcours",
  "semaine-08-tendance-saisonnalite/index.qmd" = "Continuité du parcours",
  "semaine-09-variables-externes-autocorrelation/index.qmd" = "Continuité du parcours",
  "semaine-10-classification-modeles-avances/index.qmd" = "Continuité du parcours",
  "atelier-03-series-chronologiques/index.qmd" = "Lien avec le mini-rapport 2",
  "atelier-04-recapitulation/index.qmd" = "Continuité vers la fin du cours"
)

for (path in names(transition_checks)) {
  full_path <- file.path("modules", path)

  if (!file.exists(full_path) || !grepl(transition_checks[[path]], read_text(full_path), fixed = TRUE)) {
    add_error(paste0("Transition pédagogique manquante : ", full_path))
  }
}

module_qmd <- list.files("modules", pattern = "[.]qmd$", recursive = TRUE, full.names = TRUE)
library_calls <- unlist(lapply(module_qmd, function(path) {
  text <- read_text(path)
  regmatches(text, gregexpr("library\\([A-Za-z0-9.]+\\)", text, perl = TRUE))[[1]]
}))
used_packages <- unique(sub("^library\\(([A-Za-z0-9.]+)\\)$", "\\1", library_calls))

installer_lines <- readLines("scripts/00_install_packages.R", warn = FALSE)
installer_start <- grep("^required_packages <- c\\(", installer_lines)
installer_end <- grep("^\\)", installer_lines)
installer_end <- installer_end[installer_end > installer_start[[1]]][[1]]
installer_block <- installer_lines[seq.int(installer_start[[1]], installer_end)]
declared_packages <- unique(gsub("[^A-Za-z0-9.]", "", installer_block))
declared_packages <- declared_packages[nzchar(declared_packages)]
declared_packages <- setdiff(declared_packages, c("requiredpackages", "c"))

missing_packages <- setdiff(used_packages, declared_packages)
if (length(missing_packages)) {
  add_error(paste0(
    "Packages employés dans les modules mais absents de scripts/00_install_packages.R : ",
    paste(missing_packages, collapse = ", ")
  ))
}

cat("Validation de cohérence MQT-2101\n")
cat("Modules vérifiés :", nrow(course_modules), "\n")
cat("Ateliers vérifiés :", length(workshops), "\n")
cat("Decks RevealJS vérifiés :", sum(course_modules$capsules), "\n")
cat("Cas de transfert vérifiés :", length(learning_units), "\n")
cat("Packages employés :", paste(sort(used_packages), collapse = ", "), "\n")
cat("Erreurs :", length(errors), "\n")
cat("Avertissements :", length(warnings), "\n")

if (length(warnings)) {
  cat("\nAvertissements\n")
  cat(paste0("- ", warnings, collapse = "\n"), "\n")
}

if (length(errors)) {
  cat("\nErreurs\n")
  cat(paste0("- ", errors, collapse = "\n"), "\n")
  quit(status = 1)
}

cat("\nCohérence structurelle validée.\n")
