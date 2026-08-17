# Harmonise les supports RevealJS des modules 01 à 05 avant l'enregistrement.
#
# Le script est idempotent : il ajoute les éléments de la charte seulement
# lorsqu'ils sont absents et conserve le contenu propre à chaque capsule.

library(tidyverse)

deck_files <- Sys.glob("modules/semaine-0[1-5]*/media/qmd/capsule-??-support.qmd")

deck_id <- function(path) {
  module <- stringr::str_match(path, "semaine-([0-9]{2})")[, 2]
  capsule <- stringr::str_match(path, "capsule-([0-9]{2})")[, 2]
  paste0(module, "-", capsule)
}

hooks <- list(
  `04-01` = c("Une forme qui change la décision", "Une droite peut-elle recommander toujours plus de clients quand la succursale est déjà saturée?", "Le nuage de points permet de voir si chaque client additionnel est associé au même gain de ventes. Une courbure ignorée peut transformer un ajustement commode en recommandation irréaliste."),
  `04-02` = c("Une contrainte à rendre visible", "Le ralentissement des ventes vient-il de la demande ou de la capacité à la servir?", "Le taux d'occupation, l'attente et les ruptures de stock donnent un sens opérationnel à la courbure. Ils suggèrent des mécanismes à vérifier sans, à eux seuls, les prouver."),
  `04-03` = c("Une forme à choisir", "Quelle courbe résume la saturation sans perdre le lien avec la décision?", "Le terme quadratique et le logarithme n'imposent pas la même forme. Les comparer oblige à relier le choix mathématique au nuage de points et à l'échelle des ventes."),
  `04-04` = c("Une comparaison loyale", "Quel modèle prédit le mieux des observations qu'il n'a pas utilisées pour s'ajuster?", "Une erreur calculée sur les données d'entraînement mesure surtout l'ajustement. Une période ou un échantillon test séparé permet une comparaison plus crédible des prédictions."),
  `04-05` = c("Une promesse à borner", "Que vaut une prévision lorsque l'achalandage sort de la plage observée?", "Une courbe peut se prolonger très vite hors des données. La plage observée et l'intervalle de prédiction rendent cette incertitude visible avant une décision de capacité."),
  `04-06` = c("Un choix à défendre", "Pourriez-vous justifier le modèle retenu sans montrer une seule ligne de code?", "La direction a besoin d'une forme observée, d'une comparaison hors échantillon, d'une conséquence et d'une limite. Une conclusion utile reste plus simple que le calcul qui la soutient."),
  `05-01` = c("La première minute compte", "Quelle méthode choisiriez-vous si le verbe de la question était le seul indice disponible?", "Décrire, comparer, modéliser et prédire ne demandent pas la même preuve. Lire la question avant de coder évite une réponse techniquement correcte à la mauvaise question."),
  `05-02` = c("Un diagnostic avant le calcul", "Une ligne, une variable ou une valeur manquante pourraient-elles changer votre conclusion?", "Nommer l'unité d'observation et les types de variables fixe le sens de chaque calcul. Le diagnostic minimal évite de découvrir une limite après avoir interprété le résultat."),
  `05-03` = c("Décrire sans expliquer", "Comment comparer deux groupes sans transformer un écart observé en cause?", "Un tableau, un graphique et une phrase peuvent suffire si les effectifs valides et les valeurs manquantes sont visibles. La description reste alors utile sans dépasser les données."),
  `05-04` = c("Une pente à traduire", "Que doit contenir une réponse de régression pour être vérifiable et interprétable?", "La formule seule ne suffit pas. Les unités, la qualité de l'ajustement, la structure des résidus et une limite causale transforment une sortie R en réponse statistique."),
  `05-05` = c("Un choix sous contrainte", "Le modèle le plus complexe reste-t-il le meilleur lorsqu'il doit prévoir de nouvelles observations?", "Les modèles doivent être comparés sur la même cible et les mêmes données test. L'erreur hors échantillon, la forme et l'interprétabilité répondent à des questions complémentaires."),
  `05-06` = c("La dernière minute compte aussi", "Quelle omission ferait perdre le sens d'une réponse pourtant bien calculée?", "Une unité oubliée, un graphique non commenté ou une limite absente affaiblissent la conclusion. Une courte grille de relecture rend la réponse complète sans l'allonger inutilement.")
)

self_checks <- list(
  `1` = c("J'ai nommé l'unité d'observation et le type des variables.", "Mon graphique ou mon résumé répond exactement à la question.", "Ma conclusion contient une limite descriptive."),
  `2` = c("Le document se rend du début à la fin sans intervention manuelle.", "Les valeurs manquantes et les unités sont signalées.", "Chaque résultat est accompagné d'une phrase d'interprétation."),
  `3` = c("La pente est interprétée avec ses variables et ses unités.", "J'ai distingué erreur du modèle et résidu observé.", "Je n'ai affirmé ni causalité ni validité hors de la plage observée."),
  `4` = c("Les modèles sont comparés sur les mêmes données test.", "La forme retenue est visible et interprétable.", "La prédiction reste dans la plage observée et son incertitude est indiquée."),
  `5` = c("La méthode répond au verbe de la question.", "Le résultat, le diagnostic et les unités sont présents.", "La conclusion distingue description, prédiction et causalité.")
)

insert_after <- function(x, index, addition) {
  c(x[seq_len(index)], addition, x[seq.int(index + 1L, length(x))])
}

next_heading <- function(lines, start) {
  candidates <- which(seq_along(lines) > start & stringr::str_detect(lines, "^## "))
  if (length(candidates)) min(candidates) else length(lines) + 1L
}

hook_lines <- function(values) {
  c(
    "", "## Pourquoi ça compte", "",
    "::: {.kicker}", values[[1]], ":::", "",
    "::: {.question-line}", values[[2]], ":::", "",
    "::: {.note-box}", values[[3]], ":::"
  )
}

metric_lines <- function(items) {
  items <- stringr::str_remove(items, "^-\\s+")
  items <- items[nzchar(items)][seq_len(min(3, length(items)))]
  c(
    "", "::: {.metric-grid}",
    unlist(lapply(seq_along(items), function(i) c(
      "::: {.metric}", "::: {.value}", as.character(i), ":::",
      "::: {.label}", items[[i]], ":::", ":::"
    ))),
    ":::"
  )
}

module04_setup <- c(
  "", "```{r}", "#| label: setup-module-04", "#| include: false",
  "library(tidyverse)",
  "data_candidates <- c(\"data/achalandage_saturation_quebec.csv\", \"../../data/achalandage_saturation_quebec.csv\", \"modules/semaine-04-regression-nonlineaire/data/achalandage_saturation_quebec.csv\")",
  "data_path <- data_candidates[file.exists(data_candidates)][1]",
  "saturation <- readr::read_csv(data_path, show_col_types = FALSE)",
  "set.seed(2101)",
  "id_entrainement <- sample(seq_len(nrow(saturation)), floor(0.80 * nrow(saturation)))",
  "entrainement <- saturation |> slice(id_entrainement)",
  "test <- saturation |> slice(-id_entrainement)",
  "modele_lin <- lm(ventes ~ achalandage, data = entrainement)",
  "modele_quad <- lm(ventes ~ achalandage + I(achalandage^2), data = entrainement)",
  "modele_log <- lm(ventes ~ log(achalandage), data = entrainement)",
  "```"
)

for (path in deck_files) {
  lines <- readLines(path, warn = FALSE)
  id <- deck_id(path)
  module <- as.integer(substr(id, 1, 2))

  yaml_end <- which(lines == "---")[[2]]

  if (module == 4 && !any(stringr::str_detect(lines, "setup-module-04"))) {
    lines <- insert_after(lines, yaml_end, module04_setup)
    lines <- stringr::str_replace(lines, "^```r$", "```{r}")
  }

  if (!any(lines == "## Pourquoi ça compte") && id %in% names(hooks)) {
    yaml_end <- which(lines == "---")[[2]]
    setup_end <- which(seq_along(lines) > yaml_end & lines == "```")
    insertion <- if (length(setup_end) && module == 4) setup_end[[1]] else yaml_end
    lines <- insert_after(lines, insertion, hook_lines(hooks[[id]]))
  }

  objectives <- which(lines == "## Objectifs de la capsule")
  if (length(objectives)) {
    stop_at <- next_heading(lines, objectives[[1]])
    section <- lines[(objectives[[1]] + 1L):(stop_at - 1L)]
    if (!any(section == "::: {.keypoints}")) {
      bullets <- which(stringr::str_detect(section, "^- "))
      if (length(bullets)) {
        section <- c(section[seq_len(min(bullets) - 1L)], "::: {.keypoints}", section[bullets], ":::")
        lines <- c(lines[seq_len(objectives[[1]])], section, lines[seq.int(stop_at, length(lines))])
      }
    }
  }

  activity <- which(stringr::str_detect(lines, "^## Activité [1-5]\\.[1-6]$"))
  if (length(activity)) {
    start <- activity[[1]]
    stop_at <- next_heading(lines, start)
    production <- lines[start:(stop_at - 1L)]
    production[[1]] <- stringr::str_replace(production[[1]], "^## Activité", "## Production autonome")
    keep <- c(seq_len(start - 1L), if (stop_at <= length(lines)) seq.int(stop_at, length(lines)) else integer())
    lines <- lines[keep]
    lines <- c(lines, "", production)
  }

  if (module %in% c(4, 5)) {
    retain <- which(lines == "## À retenir")
    if (length(retain)) {
      stop_at <- next_heading(lines, retain[[1]])
      section <- lines[(retain[[1]] + 1L):(stop_at - 1L)]
      bullets <- section[stringr::str_detect(section, "^- ")]
      if (length(bullets) >= 3 && !any(section == "::: {.metric-grid}")) {
        source <- if (module == 4) {
          c("", "::: {.notes}", "[Sources]", "- James, G., Witten, D., Hastie, T. et Tibshirani, R. (2023). An Introduction to Statistical Learning, 2e éd. https://www.statlearning.com/", ":::")
        } else {
          c("", "::: {.notes}", "[Sources]", "- R Core Team. Documentation de stats::lm et stats::predict.lm. https://stat.ethz.ch/R-manual/R-devel/library/stats/html/lm.html", ":::")
        }
        lines <- c(lines[seq_len(retain[[1]])], metric_lines(bullets), source, lines[seq.int(stop_at, length(lines))])
      }
    }
  }

  if (!any(lines == "### Auto-vérification")) {
    checks <- self_checks[[as.character(module)]]
    lines <- c(
      lines, "", "### Auto-vérification", "", "::: {.self-check}",
      paste0("- ", checks), ":::"
    )
  }

  if (module == 5) {
    lines <- stringr::str_replace(
      lines,
      fixed("- R Core Team. Documentation de stats::lm et stats::predict.lm. https://stat.ethz.ch/R-manual/R-devel/library/stats/html/lm.html"),
      "- Wickham, H., Çetinkaya-Rundel, M. et Grolemund, G. (2023). R for Data Science, 2e éd. https://r4ds.hadley.nz/"
    )
  }

  writeLines(lines, path, useBytes = TRUE)
}

message(length(deck_files), " supports des modules 01 à 05 harmonisés.")
