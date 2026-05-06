# Scaffold the standard module structure for MQT-2101.

module_specs <- list(
  list(
    dir = "modules/semaine-01-introduction",
    label = "Semaine 01",
    titre = "Introduction au cours et evaluation des competences statistiques",
    type = "seance",
    source = "MQT-2101-A25_Séance 01 _  Introduction.zip",
    donnees = c("birth_us.csv", "safety_airlines.csv"),
    capsules = c(
      "Organisation du cours",
      "Modèles mathématiques et statistiques",
      "Préparation des données",
      "Exploration univariée",
      "Exploration bivariée"
    ),
    livrable = "Trace de portfolio sur le diagnostic de départ."
  ),
  list(
    dir = "modules/semaine-02-r-quarto",
    label = "Semaine 02",
    titre = "Introduction a l'analyse et au traitement des donnees avec R",
    type = "seance",
    source = "MQT-2101-A25_Séance 02 _  Introduction.zip",
    donnees = c("ventes_operations_quebec.csv"),
    capsules = c(
      "Installation et vérification de l'environnement",
      "Interface RStudio",
      "Projet R et organisation des fichiers",
      "Importation et inspection d'un CSV",
      "Traitement des données",
      "Graphique et rendu Quarto"
    ),
    livrable = "Mini-rapport Quarto reproductible."
  ),
  list(
    dir = "modules/atelier-01-r",
    label = "Atelier 01",
    titre = "Explorer un tableau de donnees d'affaires",
    type = "atelier",
    source = "MQT-2101-A25_Atelier en classe 1 .zip",
    donnees = c("ventes_pme_quebec.csv"),
    capsules = c(
      "Rappel du diagnostic statistique",
      "Importation et inspection",
      "Indicateurs descriptifs",
      "Graphiques exploratoires"
    ),
    livrable = "Court rapport Quarto d'exploration."
  ),
  list(
    dir = "modules/semaine-03-regression-lineaire",
    label = "Semaine 03",
    titre = "Regression lineaire",
    type = "seance",
    source = "MQT-2101-A25_Séance 03 _ Régression.zip",
    donnees = character(),
    capsules = c(
      "Relation entre deux variables d'affaires",
      "Modèle linéaire simple",
      "Interprétation des coefficients",
      "Qualité d'ajustement et résidus"
    ),
    livrable = "Interprétation courte d'un modèle linéaire."
  ),
  list(
    dir = "modules/semaine-04-regression-nonlineaire",
    label = "Semaine 04",
    titre = "Regression non lineaire et transformations",
    type = "seance",
    source = "MQT-2101-A25_Séance 04_ Régression non.zip",
    donnees = character(),
    capsules = c(
      "Limites de la relation linéaire",
      "Transformations de variables",
      "Modèles non linéaires simples",
      "Interprétation appliquée"
    ),
    livrable = "Comparaison de deux spécifications de modèle."
  ),
  list(
    dir = "modules/atelier-02-regression",
    label = "Atelier 02",
    titre = "Regression, etude de cas business",
    type = "atelier",
    source = "MQT-2101-A25_Atelier en classe 2.zip",
    donnees = character(),
    capsules = c(
      "Question d'affaires et variable réponse",
      "Nuage de points et relation",
      "Ajustement du modele",
      "Recommandation et limites"
    ),
    livrable = "Analyse de cas en regression."
  ),
  list(
    dir = "modules/semaine-05-preparation-intra",
    label = "Semaine 05",
    titre = "Preparation a l'examen intra",
    type = "seance",
    source = "MQT-2101-A25_Séance 05 _ Préparation à.zip",
    donnees = character(),
    capsules = c(
      "Synthèse des compétences",
      "Lire une question d'examen",
      "Structurer une reponse",
      "Erreurs frequentes"
    ),
    livrable = "Plan de révision et réponse type."
  ),
  list(
    dir = "modules/semaine-06-series-chronologiques-intro",
    label = "Semaine 06",
    titre = "Introduction a la prevision et aux series chronologiques",
    type = "seance",
    source = "MQT-2101-A25_Séance 06 _  La prévision.zip",
    donnees = character(),
    capsules = c(
      "Pourquoi prévoir en gestion",
      "Structure d'une serie chronologique",
      "Visualiser une serie",
      "Premiers diagnostics temporels"
    ),
    livrable = "Diagnostic initial d'une série de ventes ou de demande."
  ),
  list(
    dir = "modules/semaine-07-lissage",
    label = "Semaine 07",
    titre = "Methodes de lissage",
    type = "seance",
    source = "MQT-2101-A25_Séance 07 _ Méthodes de.zip",
    donnees = character(),
    capsules = c(
      "Prévision court terme",
      "Moyennes mobiles",
      "Lissage exponentiel",
      "Evaluation d'une prevision"
    ),
    livrable = "Comparaison de méthodes de lissage."
  ),
  list(
    dir = "modules/semaine-08-tendance-saisonnalite",
    label = "Semaine 08",
    titre = "Modeles avec tendance et saisonnalite",
    type = "seance",
    source = "MQT-2101-A25_Séance 08 _  Modèles.zip",
    donnees = character(),
    capsules = c(
      "Tendance",
      "Saisonnalité",
      "Variables indicatrices",
      "Modèle de prévision interprétable"
    ),
    livrable = "Modèle avec tendance et saisonnalité."
  ),
  list(
    dir = "modules/atelier-03-series-chronologiques",
    label = "Atelier 03",
    titre = "Series chronologiques et prevision",
    type = "atelier",
    source = "MQT-2101-A25_Atelier en classe 3.zip",
    donnees = character(),
    capsules = c(
      "Question de prévision",
      "Préparation d'une série",
      "Modèle de base",
      "Communication de la prévision"
    ),
    livrable = "Rapport de prevision court."
  ),
  list(
    dir = "modules/semaine-09-variables-externes-autocorrelation",
    label = "Semaine 09",
    titre = "Variables externes et autocorrelation",
    type = "seance",
    source = "MQT-2101-A25_Séance 09 _ Modèles basés.zip",
    donnees = character(),
    capsules = c(
      "Variables explicatives externes",
      "Autocorrélation",
      "Diagnostics temporels",
      "Interprétation décisionnelle"
    ),
    livrable = "Diagnostic d'un modele avec variables externes."
  ),
  list(
    dir = "modules/semaine-10-classification-modeles-avances",
    label = "Semaine 10",
    titre = "Resultats binaires et modeles avances",
    type = "seance",
    source = "MQT-2101-A25_Séance 10 _ Prévision des.zip",
    donnees = character(),
    capsules = c(
      "Résultat binaire",
      "Classification appliquée",
      "Probabilités et seuils",
      "Introduction aux modèles avancés"
    ),
    livrable = "Interpretation d'un modele de classification."
  ),
  list(
    dir = "modules/atelier-04-recapitulation",
    label = "Atelier 04",
    titre = "Integration et recapitulatif",
    type = "atelier",
    source = "MQT-2101-A25_Atelier en classe 4.zip et MQT-2101-A25_Séance 11 _.zip",
    donnees = character(),
    capsules = c(
      "Choisir une approche",
      "Relire les diagnostics",
      "Comparer les resultats",
      "Préparer la synthèse finale"
    ),
    livrable = "Synthèse intégratrice."
  )
)

yaml <- function(title) {
  c(
    "---",
    paste0("title: \"", title, "\""),
    "format:",
    "  html:",
    "    embed-resources: true",
    "---",
    ""
  )
}

write_qmd_if_missing <- function(path, lines) {
  if (!file.exists(path)) {
    dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
    writeLines(lines, path, useBytes = TRUE)
  }
}

write_if_missing <- function(path, lines = character()) {
  if (!file.exists(path)) {
    dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
    writeLines(lines, path, useBytes = TRUE)
  }
}

capsule_media_tabset <- function(i) {
  capsule_id <- sprintf("%02d", i)
  c(
    "",
    "::: {.panel-tabset}",
    "### Vidéo",
    "",
    "::: {.callout-note title=\"Vidéo à intégrer\"}",
    paste0("TODO intégrer ici la vidéo courte de la capsule ", i, "."),
    ":::",
    "",
    paste0("Emplacement prévu : `media/videos/capsule-", capsule_id, ".mp4` ou lien vidéo institutionnel."),
    "",
    "### Support QMD/PDF",
    "",
    paste0("TODO ajouter le support PDF généré à partir du contenu Quarto de la capsule ", i, "."),
    "",
    paste0("Emplacement prévu : `media/pdf/capsule-", capsule_id, "-support.pdf`."),
    "",
    "### Narration PDF",
    "",
    paste0("TODO ajouter la narration PDF de la capsule ", i, " lorsque le fichier est validé pour publication."),
    "",
    paste0("Emplacement prévu : `media/narration/capsule-", capsule_id, "-narration.pdf`."),
    ":::",
    ""
  )
}

learning_path_block <- function(spec) {
  step <- 1L
  rows <- c(
    "| Étape | À faire | Où aller | Trace attendue |",
    "|---:|---|---|---|",
    paste0(
      "| ", step, " | Lire l'objectif, la section `Let’s eat the cake` et le contexte. | Page actuelle | Une phrase sur ce que le module permet de faire. |"
    )
  )

  step <- step + 1L
  for (i in seq_along(spec$capsules)) {
    rows <- c(
      rows,
      paste0(
        "| ", step, " | Visionner la capsule ", i, " : ",
        spec$capsules[[i]],
        ". Utiliser les onglets `Vidéo`, `Support QMD/PDF` et `Narration PDF`. | [Capsules](capsules.qmd) | Notes courtes sur l'idée principale. |"
      )
    )
    step <- step + 1L
    rows <- c(
      rows,
      paste0(
        "| ", step, " | Faire la pause active associée à la capsule ", i, ". | [Capsules](capsules.qmd) | Réponse courte ou micro-tâche complétée. |"
      )
    )
    step <- step + 1L
  }

  rows <- c(
    rows,
    paste0(
      "| ", step, " | Reproduire les démonstrations R dans l'ordre. | [Démonstrations R](demonstrations.qmd) | Code exécuté et résultat observé. |"
    )
  )
  step <- step + 1L
  rows <- c(
    rows,
    paste0(
      "| ", step, " | Faire les exercices sans regarder les solutions. | [Exercices](exercices.qmd) | Réponses et code R personnels. |"
    )
  )
  step <- step + 1L
  rows <- c(
    rows,
    paste0(
      "| ", step, " | Ouvrir les solutions cachées pour corriger et annoter son travail. | [Exercices](exercices.qmd) | Corrections et questions restantes. |"
    )
  )
  step <- step + 1L
  rows <- c(
    rows,
    paste0(
      "| ", step, " | Consulter les lectures ciblées. | [Lectures](lectures.qmd) | Une idée ou référence à retenir. |"
    )
  )
  step <- step + 1L
  rows <- c(
    rows,
    paste0(
      "| ", step, " | Produire le livrable court. | [Informations](informations.qmd) | ", spec$livrable, " |"
    )
  )

  links <- c(
    "",
    "## Parcours d'apprentissage",
    "",
    "Cette page principale donne l'ordre de travail recommandé. Les pages spécialisées servent à consulter les capsules, les démonstrations, les exercices, les lectures et les consignes sans surcharger le parcours.",
    "",
    rows,
    "",
    "::: {.callout-tip title=\"Mode de travail\"}",
    "Le module est conçu pour être fait de façon autonome : capsule courte, pause active, démonstration R, exercice, correction, synthèse.",
    ":::"
  )

  if (identical(spec$type, "atelier") && file.exists(file.path(spec$dir, "guide-atelier.qmd"))) {
    links <- c(
      links,
      "",
      "Pour les ateliers, le [guide d'atelier](guide-atelier.qmd) donne aussi le déroulement détaillé en classe."
    )
  }

  c(links, "")
}

upsert_learning_path <- function(spec) {
  path <- file.path(spec$dir, "index.qmd")
  if (!file.exists(path)) return(invisible(FALSE))

  lines <- readLines(path, warn = FALSE)
  h1 <- grep("^# ", lines)[1]
  if (is.na(h1)) return(invisible(FALSE))

  old_start <- grep("^## (Pages du module|Parcours d'apprentissage)$", lines)
  if (length(old_start) > 0) {
    old_start <- old_start[1]
    following_h2 <- grep("^## ", lines)
    following_h2 <- following_h2[following_h2 > old_start]
    old_end <- if (length(following_h2) > 0) following_h2[1] - 1L else length(lines)
    before <- if (old_start > 1L) lines[seq_len(old_start - 1L)] else character()
    after <- if (old_end < length(lines)) lines[seq(from = old_end + 1L, to = length(lines))] else character()
    new_lines <- c(
      before,
      learning_path_block(spec),
      after
    )
  } else {
    new_lines <- append(lines, learning_path_block(spec), after = h1)
  }

  writeLines(new_lines, path, useBytes = TRUE)
  invisible(TRUE)
}

capsules_page <- function(spec) {
  capsule_lines <- unlist(lapply(seq_along(spec$capsules), function(i) {
    c(
      paste0("## Capsule ", i, " - ", spec$capsules[[i]]),
      capsule_media_tabset(i),
      "Durée cible : 5 à 8 minutes.",
      "",
      "Objectif : TODO traduire et synthétiser la portion correspondante du ou des PPT.",
      "",
      "À couvrir :",
      "",
      "- TODO idée principale;",
      "- TODO exemple simple;",
      "- TODO lien avec une décision ou une interprétation d'affaires.",
      "",
      "### Pause active",
      "",
      "TODO ajouter une question courte ou une micro-tâche à faire immédiatement après la capsule.",
      ""
    )
  }))

  c(
    yaml(paste0("Capsules - ", spec$label)),
    paste0("# Capsules - ", spec$label),
    "",
    "## Rôle de cette page",
    "",
    "Cette page reçoit la traduction des présentations PowerPoint en contenu Quarto. Les capsules doivent rester courtes, ciblées et suivies d'une pause active ou d'un exercice.",
    "",
    "Source ancienne :",
    "",
    paste0("- `", spec$source, "`"),
    "",
    capsule_lines,
    "## À compléter pendant la conversion des PPT",
    "",
    "- résumer chaque section au lieu de copier les diapositives;",
    "- remplacer les exemples trop génériques par des contextes de gestion lorsque pertinent;",
    "- garder les notations utiles, mais expliciter leur interprétation;",
    "- ajouter une transition vers les démonstrations R et les exercices.",
    ""
  )
}

demonstrations_page <- function(spec) {
  c(
    yaml(paste0("Démonstrations R - ", spec$label)),
    paste0("# Démonstrations R - ", spec$label),
    "",
    "## Objectif",
    "",
    "Regrouper les démonstrations reproductibles en R associées au module. Cette page doit montrer les gestes techniques attendus avant les exercices autonomes.",
    "",
    "## Préparation",
    "",
    "```{r}",
    "#| eval: false",
    "library(tidyverse)",
    "library(janitor)",
    "",
    "# TODO charger les packages propres au module.",
    "```",
    "",
    "## Démonstration 1 - Importer ou préparer les données",
    "",
    "```{r}",
    "#| eval: false",
    "# TODO lire le ou les fichiers de données du module.",
    "```",
    "",
    "## Démonstration 2 - Produire un résultat intermédiaire",
    "",
    "```{r}",
    "#| eval: false",
    "# TODO calculer un résumé, ajuster un modèle ou produire un diagnostic.",
    "```",
    "",
    "## Démonstration 3 - Interpréter pour une décision",
    "",
    "TODO formuler ce que le résultat permet de dire, ce qu'il ne permet pas de dire, et la décision qu'il peut éclairer.",
    "",
    "## À vérifier",
    "",
    "- le code s'exécute du début à la fin;",
    "- les chemins sont relatifs au projet;",
    "- les objets portent des noms explicites;",
    "- les graphiques ont des titres et des axes interprétables;",
    "- l'interprétation reste alignée avec la question d'affaires.",
    ""
  )
}

exercices_page <- function(spec) {
  c(
    yaml(paste0("Exercices - ", spec$label)),
    paste0("# Exercices - ", spec$label),
    "",
    "## Objectif",
    "",
    "Faire pratiquer les notions du module après les capsules et les démonstrations R.",
    "",
    "## Exercice 1 - Interprétation",
    "",
    "TODO ajouter une question courte qui force l'étudiant à expliquer le sens d'un concept dans le contexte du module.",
    "",
    "::: {.callout-tip collapse=\"true\"}",
    "### Solution",
    "",
    "TODO rédiger la solution courte.",
    ":::",
    "",
    "## Exercice 2 - Code R",
    "",
    "```{r}",
    "#| eval: false",
    "library(tidyverse)",
    "",
    "# TODO ajouter un exercice de manipulation, de visualisation ou de modélisation.",
    "```",
    "",
    "::: {.callout-tip collapse=\"true\"}",
    "### Solution",
    "",
    "```{r}",
    "#| eval: false",
    "# TODO ajouter le code solution.",
    "```",
    ":::",
    "",
    "## Exercice 3 - Réflexion critique",
    "",
    "TODO demander une limite, une mise en garde ou une interprétation prudente.",
    "",
    "::: {.callout-tip collapse=\"true\"}",
    "### Solution",
    "",
    "TODO rédiger les éléments attendus.",
    ":::",
    "",
    "## Livrable court",
    "",
    paste0("Livrable attendu : ", spec$livrable),
    ""
  )
}

lectures_page <- function(spec) {
  c(
    yaml(paste0("Lectures - ", spec$label)),
    paste0("# Lectures - ", spec$label),
    "",
    "## Objectif",
    "",
    "Identifier les lectures qui soutiennent le module sans publier de documents protégés par droit d'auteur.",
    "",
    "## Lectures obligatoires",
    "",
    "TODO ajouter les pages ou sections pertinentes du manuel ou des notes de cours.",
    "",
    "## Lectures facultatives",
    "",
    "TODO ajouter des ressources complémentaires fiables et utiles.",
    "",
    "## Ressources externes",
    "",
    "TODO ajouter les liens externes validés, en précisant ce que l'étudiant doit y chercher.",
    "",
    "## Lien avec l'ancien matériel",
    "",
    paste0("Source ancienne de référence : `", spec$source, "`."),
    "",
    "Les PDF, PowerPoint et documents protégés restent dans les sources privées locales et ne sont pas publiés dans le site.",
    ""
  )
}

informations_page <- function(spec) {
  data_lines <- if (length(spec$donnees) > 0) {
    paste0("- `data/", spec$donnees, "`")
  } else {
    "- TODO ajouter les fichiers de données publics du module."
  }

  c(
    yaml(paste0("Informations - ", spec$label)),
    paste0("# Informations - ", spec$label),
    "",
    "## Rôle de cette page",
    "",
    "Regrouper les informations pratiques du module : fichiers, consignes, livrable, critères de réussite et lien avec l'ancien matériel.",
    "",
    "## Fichiers publics",
    "",
    data_lines,
    "",
    "## Fichiers privés utilisés comme source",
    "",
    paste0("- `", spec$source, "`"),
    "",
    "Ces fichiers restent dans `anciens_documents/sources_privees/` et ne sont pas publiés.",
    "",
    "## Médias de capsule",
    "",
    "- `media/videos/` : vidéos courtes intégrées dans l'onglet `Vidéo`.",
    "- `media/pdf/` : supports PDF générés à partir des contenus Quarto.",
    "- `media/narration/` : narrations PDF validées pour publication.",
    "",
    "## Consignes de travail autonome",
    "",
    "1. Lire la page principale du module.",
    "2. Suivre les capsules dans l'ordre.",
    "3. Faire la pause active après chaque capsule.",
    "4. Reproduire les démonstrations R.",
    "5. Faire les exercices avant d'ouvrir les solutions cachées.",
    "6. Consulter les lectures indiquées.",
    "7. Produire le livrable court.",
    "",
    "## Livrable",
    "",
    spec$livrable,
    "",
    "## Critères de réussite",
    "",
    "- le code R s'exécute;",
    "- les résultats sont interprétés en mots;",
    "- les limites sont explicites;",
    "- la trace écrite est courte, claire et reproductible.",
    ""
  )
}

data_readme <- function(spec) {
  data_lines <- if (length(spec$donnees) > 0) {
    paste0("- `", spec$donnees, "` : TODO documenter les variables, l'origine et l'usage pédagogique.")
  } else {
    "- TODO ajouter les fichiers publics lorsque les données du module seront choisies."
  }

  c(
    paste0("# Données - ", spec$label),
    "",
    "Ce dossier contient uniquement les données publiques utilisées dans le module.",
    "",
    "## Fichiers",
    "",
    data_lines,
    "",
    "## Règles",
    "",
    "- ne pas placer de fichiers nominatifs dans ce dossier;",
    "- ne pas publier de fichiers provenant d'examens;",
    "- documenter l'origine, les variables et les transformations;",
    "- privilégier les formats `.csv` pour les exemples étudiants.",
    ""
  )
}

append_hidden_solution_model <- function(spec) {
  path <- file.path(spec$dir, "exercices.qmd")
  if (!file.exists(path)) return(invisible(FALSE))

  lines <- readLines(path, warn = FALSE)
  if (any(grepl("collapse=\"true\"", lines, fixed = TRUE))) return(invisible(FALSE))

  addition <- c(
    "",
    "## Modèle de solution cachée à utiliser",
    "",
    "Les solutions doivent rester cachées par défaut pour encourager une vraie tentative avant consultation.",
    "",
    "::: {.callout-tip collapse=\"true\"}",
    "### Solution",
    "",
    "TODO ajouter la solution de l'exercice ici.",
    "",
    "```{r}",
    "#| eval: false",
    "# Code R de solution à compléter.",
    "```",
    ":::",
    ""
  )

  writeLines(c(lines, addition), path, useBytes = TRUE)
  invisible(TRUE)
}

append_capsule_pause_model <- function(spec) {
  path <- file.path(spec$dir, "capsules.qmd")
  if (!file.exists(path)) return(invisible(FALSE))

  lines <- readLines(path, warn = FALSE)
  if (any(grepl("Pause active", lines, fixed = TRUE))) return(invisible(FALSE))

  addition <- c(
    "",
    "## Règle de découpage des capsules",
    "",
    "Chaque capsule doit être courte et suivie d'une pause active.",
    "",
    "### Pause active type",
    "",
    "TODO ajouter une question d'interprétation, un court calcul ou une micro-tâche en R.",
    ""
  )

  writeLines(c(lines, addition), path, useBytes = TRUE)
  invisible(TRUE)
}

insert_capsule_tabsets <- function(spec) {
  path <- file.path(spec$dir, "capsules.qmd")
  if (!file.exists(path)) return(invisible(FALSE))

  lines <- readLines(path, warn = FALSE)
  headings <- grep("^## Capsule [0-9]+", lines)
  if (length(headings) == 0L) return(invisible(FALSE))

  for (heading in rev(headings)) {
    next_h2 <- headings[headings > heading]
    next_h2 <- if (length(next_h2) > 0L) next_h2[1] else {
      other_h2 <- grep("^## ", lines)
      other_h2 <- other_h2[other_h2 > heading]
      if (length(other_h2) > 0L) other_h2[1] else length(lines) + 1L
    }

    body <- lines[seq(from = heading + 1L, to = next_h2 - 1L)]
    if (any(grepl("^::: \\{\\.panel-tabset\\}", body))) next

    capsule_number <- sub("^## Capsule ([0-9]+).*$", "\\1", lines[[heading]])
    if (!grepl("^[0-9]+$", capsule_number)) capsule_number <- "1"

    lines <- append(lines, capsule_media_tabset(as.integer(capsule_number)), after = heading)
  }

  writeLines(lines, path, useBytes = TRUE)
  invisible(TRUE)
}

upsert_media_info <- function(spec) {
  path <- file.path(spec$dir, "informations.qmd")
  if (!file.exists(path)) return(invisible(FALSE))

  lines <- readLines(path, warn = FALSE)
  if (any(grepl("^## Médias de capsule$", lines))) return(invisible(FALSE))

  private_section <- grep("^Ces fichiers restent dans `anciens_documents/sources_privees/`", lines)
  if (length(private_section) == 0L) return(invisible(FALSE))

  addition <- c(
    "",
    "## Médias de capsule",
    "",
    "- `media/videos/` : vidéos courtes intégrées dans l'onglet `Vidéo`.",
    "- `media/pdf/` : supports PDF générés à partir des contenus Quarto.",
    "- `media/narration/` : narrations PDF validées pour publication.",
    ""
  )

  lines <- append(lines, addition, after = private_section[1])
  writeLines(lines, path, useBytes = TRUE)
  invisible(TRUE)
}

ensure_capsule_sections <- function(spec) {
  path <- file.path(spec$dir, "capsules.qmd")
  if (!file.exists(path)) return(invisible(FALSE))

  lines <- readLines(path, warn = FALSE)
  headings <- grep("^## Capsule [0-9]+", lines)
  existing_numbers <- integer()

  if (length(headings) > 0L) {
    existing_numbers <- as.integer(sub("^## Capsule ([0-9]+).*$", "\\1", lines[headings]))
    existing_numbers <- existing_numbers[!is.na(existing_numbers)]
  }

  missing_numbers <- setdiff(seq_along(spec$capsules), existing_numbers)
  if (length(missing_numbers) == 0L) return(invisible(FALSE))

  insert_before <- grep("^## (Lien avec l'ancien matériel|À compléter|Règle de découpage)", lines)
  insert_at <- if (length(insert_before) > 0L) insert_before[1] - 1L else length(lines)

  additions <- unlist(lapply(missing_numbers, function(i) {
    c(
      "",
      paste0("## Capsule ", i, " - ", spec$capsules[[i]]),
      capsule_media_tabset(i),
      "Durée cible : 5 à 8 minutes.",
      "",
      "Objectif : TODO traduire et synthétiser la portion correspondante du ou des PPT.",
      "",
      "À couvrir :",
      "",
      "- TODO idée principale;",
      "- TODO exemple simple;",
      "- TODO lien avec une décision ou une interprétation d'affaires.",
      "",
      "### Pause active",
      "",
      "TODO ajouter une question courte ou une micro-tâche à faire immédiatement après la capsule.",
      ""
    )
  }))

  lines <- append(lines, additions, after = insert_at)
  writeLines(lines, path, useBytes = TRUE)
  invisible(TRUE)
}

ensure_media_dirs <- function(spec) {
  media_dirs <- file.path(spec$dir, "media", c("videos", "pdf", "narration"))
  for (media_dir in media_dirs) {
    dir.create(media_dir, recursive = TRUE, showWarnings = FALSE)
    write_if_missing(file.path(media_dir, ".gitkeep"))
  }

  write_if_missing(
    file.path(spec$dir, "media", "README.md"),
    c(
      paste0("# Médias - ", spec$label),
      "",
      "Ce dossier sert à préparer les médias publics du module.",
      "",
      "## Sous-dossiers",
      "",
      "- `videos/` : vidéos courtes intégrées dans les capsules.",
      "- `pdf/` : supports PDF générés à partir des contenus Quarto.",
      "- `narration/` : PDF de narration validés pour publication.",
      "",
      "## Règles",
      "",
      "- ne pas publier de documents privés ou protégés sans validation;",
      "- privilégier des vidéos courtes;",
      "- garder le même numéro de capsule entre vidéo, support et narration;",
      "- documenter toute source ancienne utilisée."
    )
  )
}

for (spec in module_specs) {
  dir.create(spec$dir, recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(spec$dir, "data"), recursive = TRUE, showWarnings = FALSE)
  ensure_media_dirs(spec)

  write_qmd_if_missing(file.path(spec$dir, "capsules.qmd"), capsules_page(spec))
  write_qmd_if_missing(file.path(spec$dir, "demonstrations.qmd"), demonstrations_page(spec))
  write_qmd_if_missing(file.path(spec$dir, "exercices.qmd"), exercices_page(spec))
  write_qmd_if_missing(file.path(spec$dir, "lectures.qmd"), lectures_page(spec))
  write_qmd_if_missing(file.path(spec$dir, "informations.qmd"), informations_page(spec))
  write_qmd_if_missing(file.path(spec$dir, "data", "README.md"), data_readme(spec))

  upsert_learning_path(spec)
  ensure_capsule_sections(spec)
  insert_capsule_tabsets(spec)
  upsert_media_info(spec)
  append_hidden_solution_model(spec)
  append_capsule_pause_model(spec)
}

message("Structure standard des modules créée ou complétée.")
