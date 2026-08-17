# Génère les supports RevealJS des capsules des modules 06 à 10.
#
# Ces decks reprennent les notions, exemples et activités déjà présents dans
# les pages `capsules.qmd`. Ils sont le fil visuel prévu pour l'enregistrement
# des vidéos et suivent la même charte que les supports des modules 01 à 05.

deck <- function(number, title, kicker, question, why, objectives, idea,
                 example, code, pitfall, key_points, activity) {
  list(
    number = number,
    title = title,
    kicker = kicker,
    question = question,
    why = why,
    objectives = objectives,
    idea = idea,
    example = example,
    code = code,
    pitfall = pitfall,
    key_points = key_points,
    activity = activity
  )
}

deck_yaml <- function(title) {
  c(
    "---",
    paste0("title: \"", title, "\""),
    "subtitle: \"MQT-2101 - Analyse et modélisation des données\"",
    "institute: \"Faculté des sciences de l'administration - Université Laval\"",
    "lang: fr",
    "format:",
    "  revealjs:",
    "    theme:",
    "      - default",
    "      - ../../../../assets/ulaval-reveal.scss",
    "    width: 1600",
    "    height: 900",
    "    margin: 0.06",
    "    center: false",
    "    logo: ../../../../assets/logos/ulaval/UL-FSA-C-d.png",
    "    slide-number: c/t",
    "    controls: true",
    "    progress: true",
    "    hash: true",
    "    transition: fade",
    "    code-copy: true",
    "    code-overflow: wrap",
    "    embed-resources: true",
    "execute:",
    "  warning: false",
    "  message: false",
    "editor: visual",
    "---"
  )
}

keypoints <- function(items) c("::: {.keypoints}", paste0("- ", items), ":::")

metric_grid <- function(items) {
  items <- unique(items)
  if (length(items) < 3) {
    items <- c(items, "La décision reste liée aux données disponibles.")
  }
  items <- items[seq_len(3)]
  c(
    "::: {.metric-grid}",
    unlist(lapply(seq_along(items), function(i) c(
      "::: {.metric}",
      "::: {.value}", as.character(i), ":::",
      "::: {.label}", items[[i]], ":::",
      ":::"
    ))),
    ":::"
  )
}

module_num <- function(module_name) {
  as.integer(sub("^semaine-([0-9]+).*$", "\\1", module_name))
}

deck_key <- function(module_name, capsule_number) {
  sprintf("%02d-%d", module_num(module_name), capsule_number)
}

objective_3 <- c(
  `06-1` = "Vérifier que l'ordre des lignes respecte la chronologie.",
  `06-2` = "Relier un motif visuel à une question de prévision.",
  `06-3` = "Choisir un horizon compatible avec le délai de décision.",
  `06-4` = "Justifier une séparation chronologique des données.",
  `07-1` = "Comparer la réactivité de plusieurs fenêtres.",
  `07-2` = "Distinguer estimation du paramètre et évaluation du modèle.",
  `07-3` = "Relier chaque mesure d'erreur à une conséquence opérationnelle.",
  `07-4` = "Défendre un choix de méthode avec un protocole commun.",
  `08-1` = "Comparer les mêmes mois sur plusieurs années.",
  `08-2` = "Fixer explicitement la catégorie de référence.",
  `08-3` = "Vérifier si la saisonnalité restante est structurée.",
  `08-4` = "Distinguer valeur centrale et plage de prévision.",
  `09-1` = "Classer les prédicteurs selon leur disponibilité future.",
  `09-2` = "Formuler une interprétation conditionnelle et non causale.",
  `09-3` = "Relier un diagnostic de résidus à un risque concret.",
  `09-4` = "Nommer les hypothèses d'un scénario de prévision.",
  `10-1` = "Mesurer la fréquence de la classe positive.",
  `10-2` = "Lire une probabilité sans la transformer en certitude.",
  `10-3` = "Calculer les mesures adaptées aux deux types d'erreur.",
  `10-4` = "Vérifier une règle de capacité sur des données test."
)

idea_titles <- c(
  `06-1` = "Le temps change l'unité d'analyse",
  `06-2` = "Un motif doit se répéter pour devenir crédible",
  `06-3` = "La prévision commence par une date d'origine",
  `06-4` = "Le test doit vraiment représenter le futur",
  `07-1` = "La fenêtre règle le compromis réactivité-stabilité",
  `07-2` = "Alpha est estimé avant d'être évalué",
  `07-3` = "Deux erreurs moyennes peuvent cacher des risques différents",
  `07-4` = "Le protocole commun précède le classement",
  `08-1` = "Tendance et saisonnalité répondent à deux questions",
  `08-2` = "Janvier ne devient référence que si on le demande",
  `08-3` = "Le modèle additif impose une forme précise",
  `08-4` = "Une prévision utile montre aussi son incertitude",
  `09-1` = "Un bon prédicteur peut être inutilisable en production",
  `09-2` = "Le coefficient dépend du scénario et du modèle",
  `09-3` = "Les résidus successifs ne devraient pas se répondre",
  `09-4` = "Une prévision conditionnelle inclut ses hypothèses",
  `10-1` = "La cible doit précéder l'intervention",
  `10-2` = "La probabilité ordonne un risque, elle ne rend pas un verdict",
  `10-3` = "L'exactitude seule masque les départs manqués",
  `10-4` = "La capacité de contact définit une règle testable"
)

example_titles <- c(
  `06-1` = "Une ligne, deux identifiants",
  `06-2` = "Décembre élevé ou véritable saisonnalité?",
  `06-3` = "Prévoir le trimestre au moment utile",
  `06-4` = "Douze mois vraiment hors échantillon",
  `07-1` = "Quatre semaines donnent 1 050 unités",
  `07-2` = "Une hausse récente révèle l'effet d'alpha",
  `07-3` = "Même MAE, mais pas le même risque",
  `07-4` = "Un gain de 1 % peut coûter trop cher",
  `08-1` = "Comparer janvier avec janvier",
  `08-2` = "Le vrai coefficient de décembre",
  `08-3` = "Quand l'amplitude croît avec le niveau",
  `08-4` = "Trois scénarios plutôt qu'un chiffre certain",
  `09-1` = "Promotion connue, météo prévue, ventes inconnues",
  `09-2` = "Promotion oui n'est pas une expérience aléatoire",
  `09-3` = "Plusieurs sous-prévisions de suite",
  `09-4` = "Avril sous promotion maintenue",
  `10-1` = "198 départs observables sur 650 clients",
  `10-2` = "Un risque de 0,70 reste une estimation",
  `10-3` = "Le coût d'un départ non détecté",
  `10-4` = "Cibler les 15 % les plus à risque"
)

code_titles <- c(
  `06-1` = "Vérifier l'ordre et la fréquence en R",
  `06-2` = "Tracer la série avant de modéliser",
  `06-3` = "Écrire la cible, l'origine et l'horizon",
  `06-4` = "Geler la période test",
  `07-1` = "Calculer une moyenne mobile arrière",
  `07-2` = "Ajuster le lissage sur l'entraînement",
  `07-3` = "Calculer MAE et RMSE dans leurs unités",
  `07-4` = "Comparer quatre méthodes sur les mêmes semaines",
  `08-1` = "Visualiser les mois sur plusieurs années",
  `08-2` = "Fixer janvier avant d'interpréter",
  `08-3` = "Ajuster tendance et mois ensemble",
  `08-4` = "Produire un intervalle de prédiction",
  `09-1` = "Documenter la disponibilité des prédicteurs",
  `09-2` = "Ajuster une régression conditionnelle",
  `09-3` = "Inspecter l'ACF et le test de Ljung-Box",
  `09-4` = "Ajuster une régression avec erreurs AR",
  `10-1` = "Compter la classe positive",
  `10-2` = "Produire des probabilités hors échantillon",
  `10-3` = "Construire la matrice de confusion",
  `10-4` = "Tester une règle de capacité"
)

pitfall_titles <- c(
  `06-1` = "Quand un tri alphabétique détruit le temps",
  `06-2` = "Voir ensemble ne signifie pas causer",
  `06-3` = "Une cible sans horizon reste ambiguë",
  `06-4` = "Le mélange aléatoire regarde vers le futur",
  `07-1` = "Une fenêtre centrée utilise demain",
  `07-2` = "Le test ne sert pas à choisir alpha",
  `07-3` = "La plus petite erreur n'est pas toujours la moins coûteuse",
  `07-4` = "Changer d'horizon invalide la comparaison",
  `08-1` = "Une seule année ne prouve pas une saisonnalité",
  `08-2` = "La référence implicite change l'interprétation",
  `08-3` = "Plus de coefficients ne garantit rien",
  `08-4` = "La valeur centrale seule masque le risque",
  `09-1` = "Une variable future observée crée une fuite",
  `09-2` = "Association estimée n'est pas effet causal",
  `09-3` = "Une valeur p ne remplace pas le graphique",
  `09-4` = "Un scénario oublié devient une fausse certitude",
  `10-1` = "Une information postérieure au départ triche",
  `10-2` = "Une probabilité individuelle n'est jamais certaine",
  `10-3` = "L'exactitude favorise la classe majoritaire",
  `10-4` = "Le seuil de 0,5 n'a rien d'automatique"
)

setup_lines <- function(module_name, capsule_number) {
  n <- module_num(module_name)
  label <- sprintf("setup-m%02d-c%02d", n, capsule_number)
  file_name <- switch(
    as.character(n),
    `6` = "ventes_mensuelles_quebec.csv",
    `7` = "demande_hebdomadaire_quebec.csv",
    `8` = "ventes_saisonnieres_quebec.csv",
    `9` = "ventes_promotions_quebec.csv",
    `10` = "fidelisation_clients_quebec.csv"
  )
  object_name <- switch(as.character(n), `6` = "ventes", `7` = "demande", `8` = "ventes", `9` = "ventes", `10` = "clients")
  lines <- c(
    "```{r}",
    paste0("#| label: ", label),
    "#| include: false",
    "library(tidyverse)",
    if (n == 7) "library(slider)" else character(),
    if (n %in% c(7, 9)) "library(forecast)" else character(),
    paste0("data_candidates <- c(\"data/", file_name, "\", \"../../data/", file_name, "\", \"modules/", module_name, "/data/", file_name, "\")"),
    "data_path <- data_candidates[file.exists(data_candidates)][1]",
    paste0(object_name, " <- readr::read_csv(data_path, show_col_types = FALSE)"),
    if (n %in% c(6, 8, 9)) "ventes <- ventes |> mutate(date = as.Date(date)) |> arrange(date)" else character(),
    if (n == 7) "demande <- demande |> mutate(semaine = as.Date(semaine)) |> arrange(semaine)" else character(),
    if (n == 6) c("train <- ventes |> filter(date < as.Date(\"2025-01-01\"))", "test <- ventes |> filter(date >= as.Date(\"2025-01-01\"))") else character(),
    if (n == 7) c("horizon <- 13", "train <- demande |> slice_head(n = nrow(demande) - horizon)", "test <- demande |> slice_tail(n = horizon)", "serie <- ts(train$demande, frequency = 52)") else character(),
    if (n == 8) c("mois_fr <- c(\"janvier\", \"février\", \"mars\", \"avril\", \"mai\", \"juin\", \"juillet\", \"août\", \"septembre\", \"octobre\", \"novembre\", \"décembre\")", "ventes <- ventes |> mutate(mois_label = factor(mois_label, levels = mois_fr))", "train <- ventes |> slice_head(n = 60)", "test <- ventes |> slice_tail(n = 12)", "modele <- lm(ventes ~ indice_temps + mois_label, data = train)") else character(),
    if (n == 9) c("mois_fr <- c(\"janvier\", \"février\", \"mars\", \"avril\", \"mai\", \"juin\", \"juillet\", \"août\", \"septembre\", \"octobre\", \"novembre\", \"décembre\")", "ventes <- ventes |> mutate(mois_label = factor(mois_label, levels = mois_fr))", "train <- ventes |> slice_head(n = 60)", "test <- ventes |> slice_tail(n = 12)", "modele <- lm(ventes ~ tendance + promotion + prix_moyen + mois_label, data = train)") else character(),
    if (n == 10) c("set.seed(2101)", "train <- clients |> group_by(depart_90j) |> slice_sample(prop = 0.80) |> ungroup()", "test <- anti_join(clients, train, by = \"client_id\")", "modele <- glm(depart_90j ~ anciennete_mois + utilisation_mensuelle + tickets_service_6m + satisfaction + type_contrat, family = binomial(), data = train)", "probabilite <- predict(modele, newdata = test, type = \"response\")") else character(),
    "```"
  )
  lines[nzchar(lines)]
}

source_notes <- function(module_name) {
  n <- module_num(module_name)
  if (n <= 9) {
    c(
      "::: {.notes}",
      "[Sources]",
      "- Hyndman, R. J. et Athanasopoulos, G. (2021). Forecasting: Principles and Practice, 3e éd. https://otexts.com/fpp3/",
      ":::"
    )
  } else {
    c(
      "::: {.notes}",
      "[Sources]",
      "- R Core Team. Documentation de stats::glm. https://stat.ethz.ch/R-manual/R-devel/library/stats/html/glm.html",
      "- Tidymodels. Classification metrics. https://yardstick.tidymodels.org/",
      ":::"
    )
  }
}

self_check_items <- function(module_name) {
  n <- module_num(module_name)
  if (n <= 6) {
    c("J'ai nommé la variable, l'unité, la période et l'horizon.", "Je n'ai utilisé aucune information future.", "Ma conclusion contient une limite explicite.")
  } else if (n <= 9) {
    c("Toutes les méthodes utilisent la même période test.", "J'ai interprété l'erreur dans son unité.", "J'ai relié le résultat à une décision et à une limite.")
  } else {
    c("J'ai défini la classe positive et la période test.", "J'ai rapporté les deux types d'erreur, pas seulement l'exactitude.", "Ma règle respecte la capacité et évite une interprétation individuelle certaine.")
  }
}

deck_lines <- function(spec, module_name) {
  key <- deck_key(module_name, spec$number)
  spec$objectives <- unique(c(spec$objectives, unname(objective_3[[key]])))
  idea_block <- c(paste0("## ", unname(idea_titles[[key]])), "", keypoints(spec$idea))
  example_block <- c(
    paste0("## ", unname(example_titles[[key]])), "",
    "::: {.example-box}", spec$example, ":::"
  )
  code_block <- c(
    paste0("## ", unname(code_titles[[key]])), "",
    "```{r}",
    paste0("#| label: code-m", sprintf("%02d", module_num(module_name)), "-c", sprintf("%02d", spec$number)),
    "#| echo: true",
    "#| eval: true",
    spec$code,
    "```"
  )
  pitfall_block <- c(
    paste0("## ", unname(pitfall_titles[[key]])), "",
    "::: {.warning-box}", spec$pitfall, ":::"
  )
  body <- switch(
    as.character(spec$number),
    `1` = c(idea_block, "", example_block, "", code_block, "", pitfall_block),
    `2` = c(example_block, "", idea_block, "", code_block, "", pitfall_block),
    `3` = c(idea_block, "", code_block, "", example_block, "", pitfall_block),
    `4` = c(example_block, "", code_block, "", idea_block, "", pitfall_block)
  )
  c(
    deck_yaml(paste0("Capsule ", spec$number, " - ", spec$title)),
    "",
    setup_lines(module_name, spec$number),
    "",
    "## Pourquoi ça compte",
    "",
    "::: {.kicker}", spec$kicker, ":::",
    "",
    "::: {.question-line}", spec$question, ":::",
    "",
    "::: {.note-box}", spec$why, ":::",
    "",
    "## Objectifs de la capsule",
    "",
    keypoints(spec$objectives),
    "",
    body,
    "",
    "## À retenir",
    "",
    metric_grid(spec$key_points),
    "",
    source_notes(module_name),
    "",
    paste0("## Production autonome ", spec$activity_number),
    "",
    "::: {.lead}", spec$activity, ":::",
    "",
    "### Auto-vérification",
    "",
    "::: {.self-check}", paste0("- ", self_check_items(module_name)), ":::"
  )
}

module_specs <- list(
  `semaine-06-series-chronologiques-intro` = list(
    deck(1, "Reconnaître une série chronologique", "Prévoir exige de respecter le temps.", "Qu'est-ce qui transforme un tableau en série chronologique?", "L'ordre des observations porte de l'information. Une ligne de mars ne peut pas être traitée comme interchangeable avec une ligne de février.", c("Nommer l'unité d'observation, la fréquence et la période.", "Distinguer données transversales et données temporelles."), c("Une série est repérée dans le temps.", "La date et la fréquence doivent être explicites.", "La chronologie ne doit pas être détruite."), "Une ligne peut représenter un mois-succursale, mais seulement si la date et la succursale sont toutes deux identifiées.", c("library(tidyverse)", "ventes |> arrange(date) |> glimpse()"), "Trier une date stockée comme texte peut produire un ordre faux. Vérifiez toujours la classe de la date.", c("Une unité, une variable, une fréquence et une période définissent la série.", "L'ordre temporel est une information, pas une colonne décorative."), "Pour chaque situation, indiquez si elle décrit une série chronologique et justifiez votre réponse.") ,
    deck(2, "Lire un graphique temporel", "Le premier modèle est souvent un graphique bien construit.", "Quels motifs le temps rend-il visibles?", "Un graphique temporel permet de voir le niveau, la tendance, les motifs récurrents et les ruptures avant de choisir une méthode.", c("Construire un graphique qui respecte l'ordre temporel.", "Distinguer tendance, saisonnalité et variation irrégulière."), c("La tendance est un mouvement de long terme.", "La saisonnalité est un motif qui revient selon une période connue.", "Une pointe isolée ne prouve pas une saisonnalité."), "Un décembre élevé une seule année peut être une observation inhabituelle. Il faut comparer plusieurs décembres.", c("ventes |> ggplot(aes(date, ventes)) +", "  geom_line(colour = \"#0B4F6C\", linewidth = 0.8) +", "  labs(x = NULL, y = \"Ventes mensuelles ($)\") +", "  theme_minimal(base_size = 14)"), "Attribuer une hausse à une promotion seulement parce que les deux apparaissent au même moment dépasse ce que montre le graphique.", c("Décrire un motif n'est pas expliquer sa cause.", "Chercher aussi les données manquantes et les changements de variabilité."), "Tracez les ventes selon la date, puis nommez deux motifs visibles et une question qui reste ouverte.") ,
    deck(3, "Définir la cible et l'horizon", "Une prévision utile répond à une décision concrète.", "Que faut-il préciser avant de choisir un modèle?", "La cible, l'origine, la fréquence et l'horizon doivent être définis avant l'ajustement. Sinon, on ne sait pas quelle prévision est réellement évaluée.", c("Distinguer cible, origine et horizon.", "Formuler une prévision liée à une décision."), c("La cible est la valeur future à prévoir.", "L'horizon est la distance entre l'origine et la période visée.", "La fréquence doit être compatible avec la décision."), "À la fin de décembre, prévoir les ventes mensuelles de janvier à mars pour planifier les achats du trimestre.", c("origine <- as.Date(\"2025-12-01\")", "horizon_mois <- 3", "tibble(cible = \"ventes mensuelles\", origine, horizon_mois)"), "Dire seulement « prévoir les ventes » ne précise ni la période, ni le moment où la prévision est produite, ni son usage.", c("Une formulation précise évite une évaluation ambiguë.", "L'horizon dépend du délai réel de décision."), "Formulez une cible compatible avec un délai de commande de six semaines.") ,
    deck(4, "Évaluer sans regarder le futur", "Une bonne prévision doit survivre à des données qu'elle n'a pas vues.", "Pourquoi réserver une période test chronologique?", "L'évaluation doit reproduire la situation réelle : le futur n'était pas disponible au moment de prévoir.", c("Séparer entraînement et test dans l'ordre du temps.", "Comparer un modèle à une référence naïve.", "Interpréter la MAE dans l'unité de la cible."), c("Le test vient après l'entraînement.", "La méthode naïve utilise la dernière valeur observée.", "La MAE mesure une erreur moyenne dans l'unité de la cible."), "Une méthode complexe qui ne bat pas la méthode naïve n'a pas encore démontré une valeur pratique supplémentaire.", c("tibble(", "  periode = c(\"Entraînement\", \"Test\"),", "  debut = c(min(train$date), min(test$date)),", "  fin = c(max(train$date), max(test$date)),", "  mois = c(nrow(train), nrow(test))", ")"), "Mélanger aléatoirement les mois donne au modèle une information qui aurait été future au point d'origine.", c("L'évaluation temporelle protège contre la fuite vers le futur.", "La référence simple est un seuil minimal de valeur."), "Expliquez en deux phrases pourquoi une séparation aléatoire des mois est irréaliste.")
  ),
  `semaine-07-lissage` = list(
    deck(1, "Moyennes mobiles", "Lisser aide à décider sans réagir à chaque fluctuation.", "Comment réduire le bruit sans regarder vers le futur?", "Une moyenne mobile arrière utilise uniquement des observations déjà disponibles. La taille de sa fenêtre règle le compromis entre réactivité et stabilité.", c("Calculer une moyenne mobile arrière.", "Expliquer l'effet d'une fenêtre courte ou longue."), c("Une fenêtre courte réagit vite.", "Une fenêtre longue lisse davantage.", "Pour prévoir, la fenêtre doit être arrière."), "Les quatre dernières demandes 980, 1 020, 1 080 et 1 120 donnent une moyenne mobile de 1 050 unités.", c("demande |>", "  mutate(mm4 = slider::slide_dbl(", "    demande, mean, .before = 3, .complete = TRUE", "  )) |>", "  select(semaine, demande, mm4) |>", "  slice_tail(n = 6)"), "Une moyenne mobile centrée peut être utile pour décrire, mais elle utilise des valeurs futures et ne convient pas à une prévision en temps réel.", c("La fenêtre détermine la réactivité.", "Une moyenne mobile ne modélise pas automatiquement la tendance ou la saisonnalité."), "Calculez la moyenne mobile des quatre dernières demandes et nommez ce qu'elle ignore.") ,
    deck(2, "Lissage exponentiel simple", "Les observations récentes peuvent compter davantage sans effacer tout l'historique.", "Quel rôle joue le paramètre alpha?", "Le lissage exponentiel met à jour un niveau estimé en pondérant la dernière observation et le niveau précédent.", c("Expliquer le rôle de alpha.", "Choisir le lissage simple seulement lorsque sa structure est plausible."), c("Un alpha élevé réagit plus vite.", "Un alpha faible produit un niveau plus stable.", "Le lissage simple n'est pas adapté à une forte tendance non modélisée."), "Avec une demande en hausse, alpha = 0,8 se rapproche beaucoup plus vite de la dernière observation que alpha = 0,2.", c("fit <- forecast::ses(serie, h = horizon)", "autoplot(fit) +", "  labs(x = \"Semaine\", y = \"Demande (unités)\") +", "  theme_minimal(base_size = 14)"), "Alpha est estimé sur les données d'entraînement. La méthode est ensuite évaluée une seule fois sur la période test; le test ne sert pas à choisir alpha.", c("Le niveau lissé est une prévision révisable.", "La méthode doit être comparée à une référence."), "Comparez qualitativement les effets de alpha = 0,2 et alpha = 0,8 pour une demande récente en hausse.") ,
    deck(3, "Mesurer les erreurs", "La meilleure erreur dépend des conséquences opérationnelles.", "Que mesure MAE, RMSE et MAPE?", "Les mesures résument des erreurs différentes. Il faut conserver leur unité, leur sensibilité et leur limite avant de les utiliser pour choisir une méthode.", c("Calculer et interpréter MAE et RMSE.", "Identifier la limite du MAPE près de zéro."), c("La MAE reste dans l'unité de la cible.", "La RMSE pénalise les grandes erreurs.", "Le MAPE est instable près de zéro."), "Deux méthodes peuvent avoir la même MAE. Celle qui fait une erreur extrême aura généralement une RMSE plus élevée.", c("prevision <- as.numeric(forecast::ses(serie, h = horizon)$mean)", "erreur <- test$demande - prevision", "tibble(", "  mesure = c(\"MAE\", \"RMSE\"),", "  valeur = c(mean(abs(erreur)), sqrt(mean(erreur^2)))", ")"), "Choisir la plus petite mesure sans relier l'erreur au coût des ruptures ou des surplus donne une décision incomplète.", c("L'erreur doit être lue avec son unité.", "Une grande erreur peut compter plus qu'une petite amélioration moyenne."), "Indiquez quelle mesure distinguera davantage deux méthodes ayant la même MAE mais des erreurs extrêmes différentes.") ,
    deck(4, "Comparer équitablement", "Une comparaison de méthodes doit être équitable avant d'être impressionnante.", "Qu'est-ce qui doit rester identique entre les méthodes?", "La même origine, le même horizon, la même période test et les mêmes mesures sont nécessaires pour attribuer une différence à la méthode plutôt qu'au protocole.", c("Construire une période test commune.", "Choisir une méthode selon l'erreur et l'usage."), c("Toutes les méthodes prédisent les mêmes semaines.", "Le classement numérique ne suffit pas.", "La stabilité et le coût de maintenance comptent."), "Une réduction de MAE de 1 % peut ne pas justifier un outil coûteux ou fragile.", c("previsions <- test |>", "  transmute(", "    observe = demande,", "    naive = tail(train$demande, 1),", "    moyenne_4 = mean(tail(train$demande, 4)),", "    SES = as.numeric(forecast::ses(serie, h = horizon)$mean),", "    Holt = as.numeric(forecast::holt(serie, h = horizon, damped = TRUE)$mean)", "  )", "previsions |>", "  pivot_longer(-observe, names_to = \"methode\", values_to = \"prevision\") |>", "  group_by(methode) |>", "  summarise(", "    MAE = mean(abs(observe - prevision)),", "    RMSE = sqrt(mean((observe - prevision)^2)),", "    .groups = \"drop\"", "  ) |>", "  arrange(MAE)"), "Comparer les erreurs sur des horizons ou des semaines différents invalide le classement.", c("Comparer d'abord à protocole constant.", "Choisir ensuite la solution qui sert réellement la décision."), "Formulez une décision prudente lorsqu'une méthode améliore peu la MAE mais augmente fortement les coûts de maintenance.")
  ),
  `semaine-08-tendance-saisonnalite` = list(
    deck(1, "Distinguer tendance et saisonnalité", "Un niveau qui monte peut masquer des mois systématiquement forts ou faibles.", "Comment séparer l'évolution de long terme des effets de calendrier?", "La tendance change graduellement le niveau. La saisonnalité est un motif récurrent à une fréquence connue. Les deux peuvent être présents simultanément.", c("Définir tendance et saisonnalité.", "Chercher une récurrence sur plusieurs cycles."), c("Une seule année ne prouve pas la saisonnalité.", "Comparer les mêmes mois sur plusieurs années.", "La tendance peut modifier le niveau général."), "Regrouper les observations de janvier permet de comparer janvier d'une année à l'autre malgré une tendance globale.", c("ventes |> ggplot(aes(mois_label, ventes)) +", "  geom_boxplot()"), "Interpréter une hausse de janvier à décembre dans une seule année comme une saisonnalité confond un trajet unique et un motif récurrent.", c("La tendance est un mouvement de long terme.", "La saisonnalité revient selon un calendrier."), "Expliquez pourquoi il est utile de comparer toutes les observations de janvier.") ,
    deck(2, "Coder le calendrier", "Le calendrier devient utile lorsqu'il est représenté explicitement dans le modèle.", "Que représente un coefficient de décembre?", "Un indice de temps porte la tendance et un facteur mois porte les différences saisonnières par rapport à une référence choisie.", c("Créer un indice de temps et un facteur mois.", "Interpréter une catégorie de référence."), c("L'indice de temps augmente d'une unité par période.", "Le mois est un facteur pour le modèle.", "La référence fixe la comparaison, elle n'est pas la meilleure catégorie."), "Dans les 60 mois d'entraînement, décembre est associé à environ 32 700 $ de ventes supplémentaires par rapport à janvier, à tendance égale.", c("ventes <- ventes |>", "  mutate(mois_label = factor(mois_label, levels = mois_fr))", "modele_calendrier <- lm(ventes ~ indice_temps + mois_label, data = train)", "tibble(", "  reference = levels(train$mois_label)[1],", "  coefficient_decembre = coef(modele_calendrier)[[\"mois_labeldécembre\"]]", ")"), "Présenter un coefficient de mois comme un effet causal du calendrier dépasse un modèle observationnel.", c("La référence est un point de comparaison.", "Les coefficients se lisent conditionnellement au modèle."), "Interprétez le coefficient de décembre affiché avec les mots « à tendance égale ».") ,
    deck(3, "Ajuster un modèle tendance-saisonnalité", "Un modèle simple peut rendre un budget plus défendable.", "Quelle structure le modèle additif suppose-t-il?", "Une régression avec indice de temps et facteur mois suppose que les écarts saisonniers restent approximativement constants quand le niveau change.", c("Ajuster un modèle avec tendance et mois.", "Diagnostiquer une structure saisonnière restante."), c("Le modèle est additif.", "Les résidus doivent être inspectés.", "Une amplitude croissante suggère une autre structure."), "Si l'amplitude saisonnière croît avec les ventes, une transformation logarithmique peut être plus appropriée.", c("modele <- lm(ventes ~ indice_temps + mois_label, data = train)", "broom::tidy(modele)"), "Choisir le modèle uniquement parce qu'il produit davantage de coefficients ne garantit ni une meilleure prévision ni une meilleure interprétation.", c("Le modèle doit représenter un motif utile.", "Les résidus révèlent ce qui reste à expliquer."), "Nommez un graphique de résidus qui pourrait signaler qu'un modèle additif est insuffisant.") ,
    deck(4, "Prévoir et communiquer l'incertitude", "Un budget est une décision sous incertitude, pas une certitude déguisée.", "Pourquoi montrer un intervalle de prédiction?", "Une prévision ponctuelle donne une valeur centrale. L'intervalle de prédiction décrit une plage plausible pour une nouvelle observation, selon le modèle.", c("Produire une prévision ponctuelle et un intervalle.", "Relier l'incertitude à un scénario budgétaire."), c("L'intervalle de prédiction concerne une nouvelle observation.", "Il est généralement plus large que l'intervalle de confiance de la moyenne.", "La décision peut prévoir des scénarios de capacité."), "Un budget peut utiliser une valeur centrale, un scénario prudent et un scénario de capacité élevée plutôt qu'un seul chiffre présenté comme certain.", c("pred <- as.data.frame(", "  predict(modele, newdata = test, interval = \"prediction\")", ")", "bind_cols(test |> select(date), pred) |>", "  slice_head(n = 4)"), "Communiquer seulement la valeur centrale masque la variabilité qui compte pour les stocks, les équipes et la capacité.", c("Une prévision doit être accompagnée de son incertitude.", "Une décision robuste prévoit des scénarios."), "Expliquez pourquoi l'intervalle de prédiction est plus large que l'intervalle de confiance de la moyenne.")
  ),
  `semaine-09-variables-externes-autocorrelation` = list(
    deck(1, "Variables externes disponibles", "Une variable utile dans un modèle peut être inutilisable au moment de prévoir.", "Quelles informations seront réellement connues dans le futur?", "Avant d'ajouter un prédicteur, il faut vérifier son statut au point d'origine. Une variable future indisponible crée une fuite d'information.", c("Classer un prédicteur selon sa disponibilité future.", "Repérer une fuite d'information."), c("Le calendrier et une promotion approuvée peuvent être connus.", "Un prix envisagé doit être scénarisé.", "La cible future observée est indisponible, mais ses valeurs retardées peuvent être connues."), "Une promotion approuvée est connue. La météo est prévue séparément. Les ventes réelles du mois prochain sont la cible et restent inconnues au point d'origine.", c("predicteurs <- tribble(", "  ~variable, ~statut,", "  \"promotion approuvée\", \"connue\",", "  \"météo du mois prochain\", \"prévue séparément\",", "  \"ventes du mois prochain\", \"inconnues\",", "  \"ventes du mois courant\", \"connues et retardées\"", ")", "predicteurs"), "Utiliser les ventes observées du mois prochain comme variable explicative améliore artificiellement la performance sans aider la décision réelle.", c("La disponibilité future est une condition de validité.", "Un scénario doit être annoncé comme tel."), "Classez une promotion approuvée, la météo du mois prochain, les ventes du mois prochain et les ventes du mois courant.") ,
    deck(2, "Régression conditionnelle", "Une prévision avec promotion ou prix est toujours liée aux hypothèses retenues.", "Que permet réellement un coefficient de promotion?", "Le coefficient d'une variable externe décrit une association conditionnelle aux autres variables du modèle. Il ne prouve pas à lui seul un effet causal.", c("Ajuster une régression temporelle avec prédicteurs externes.", "Employer un langage conditionnel et non causal."), c("Le modèle combine tendance, calendrier et prédicteurs.", "Les coefficients dépendent des autres variables incluses.", "Les prédictions sont conditionnelles au scénario."), "Comparer « promotion oui » et « promotion non » dans un modèle observationnel ne reproduit pas une expérimentation aléatoire.", c("modele <- lm(", "  ventes ~ tendance + promotion + prix_moyen + mois_label,", "  data = train", ")", "broom::tidy(modele) |>", "  filter(term %in% c(\"promotionoui\", \"prix_moyen\"))"), "Transformer une association estimée en promesse d'effet causal peut produire une recommandation injustifiée.", c("Les coefficients sont conditionnels au modèle.", "Une question causale exige un autre plan d'étude."), "Expliquez pourquoi deux prévisions sous des niveaux de promotion différents ne prouvent pas automatiquement un effet causal.") ,
    deck(3, "Autocorrélation des résidus", "Des résidus organisés dans le temps indiquent une information encore inutilisée.", "Que signifie un résidu positif suivi souvent d'un autre résidu positif?", "Après modélisation, les résidus devraient ressembler à du bruit. Une dépendance temporelle restante peut rendre les prévisions successivement trop basses ou trop hautes.", c("Lire une fonction d'autocorrélation.", "Interpréter prudemment un test de Ljung-Box."), c("Un pic au retard 1 concerne des voisins temporels.", "Le test de Ljung-Box examine plusieurs retards.", "Une valeur p ne mesure pas à elle seule le coût opérationnel."), "Des résidus positifs consécutifs peuvent signaler plusieurs sous-prévisions successives et un risque accru de rupture.", c("acf(residuals(modele))", "Box.test(residuals(modele), lag = 12, type = \"Ljung-Box\")"), "Se limiter à une valeur p sans regarder le graphique des résidus empêche de comprendre le motif et son importance pratique.", c("Inspecter le temps avant de conclure.", "Un diagnostic statistique doit conduire à une question de décision."), "Décrivez le risque pratique associé à une succession de résidus positifs.") ,
    deck(4, "Erreurs AR et scénarios", "Les variables externes et la mémoire des erreurs peuvent contribuer ensemble à une prévision.", "Que signifie une prévision conditionnelle?", "Un modèle avec erreurs AR(1) ajoute une dépendance entre les erreurs. Pour l'utiliser, les prédicteurs futurs doivent être connus, prévus ou scénarisés.", c("Comparer une régression ordinaire et une régression avec erreurs AR.", "Communiquer une prévision conditionnelle à un scénario."), c("AR(1) relie une erreur à l'erreur précédente.", "Les scénarios doivent expliciter les valeurs futures des prédicteurs.", "Le résultat n'est pas une prévision inconditionnelle."), "Une prévision pour avril suppose ici qu'une promotion est maintenue et que le prix reste stable. Ces hypothèses font partie du résultat.", c("xreg_train <- model.matrix(", "  ~ promotion + prix_moyen, data = train", ")[, -1, drop = FALSE]", "modele_ar <- forecast::Arima(", "  train$ventes, order = c(1, 0, 0), xreg = xreg_train", ")", "tibble(parametre = names(coef(modele_ar)), estimation = coef(modele_ar)) |>", "  slice_head(n = 4)"), "Omettre les hypothèses sur prix et promotion donne l'impression trompeuse que le modèle connaît automatiquement le futur.", c("Les scénarios sont des intrants du modèle.", "Une recommandation doit nommer ses hypothèses."), "Rédigez une phrase complète présentant une prévision sous un scénario de promotion maintenue et de prix stable.")
  ),
  `semaine-10-classification-modeles-avances` = list(
    deck(1, "Définir une cible binaire", "Une classification utile commence par un événement mesurable.", "Que signifie exactement « client à risque »?", "Une cible binaire doit définir l'événement, l'horizon, la classe positive et la période à laquelle les prédicteurs sont disponibles.", c("Définir une classe positive vérifiable.", "Éviter une fuite de cible."), c("La classe positive est l'événement à détecter.", "L'horizon rend la cible mesurable.", "Les prédicteurs doivent précéder l'événement."), "« Départ dans les 90 jours » est une cible vérifiable. « Client à risque » est une intuition trop vague pour entraîner un modèle.", c("clients |> count(depart_90j)", "prop.table(table(clients$depart_90j))"), "Utiliser une information créée après le départ dans les prédicteurs donne une performance irréaliste et une intervention impossible à temps.", c("Une cible doit être définie avant le modèle.", "La chronologie protège aussi la classification."), "Expliquez pourquoi « client à risque » est une cible insuffisante.") ,
    deck(2, "Probabilité logistique", "Une probabilité est plus utile qu'une étiquette lorsqu'il faut prioriser une intervention.", "Comment passer d'un score à une probabilité entre zéro et un?", "La régression logistique modélise les log-cotes, puis les traduit en probabilités. Pour communiquer, les probabilités prédites dans des scénarios sont souvent plus parlantes que les coefficients seuls.", c("Interpréter le signe d'un coefficient logistique.", "Distinguer probabilité prédite et classe."), c("Un coefficient positif augmente les log-cotes de la classe positive.", "Une probabilité n'est pas une certitude individuelle.", "Un seuil transforme ensuite la probabilité en action."), "Une probabilité de 0,70 signifie que le modèle estime un risque élevé selon ses données et hypothèses, pas qu'un départ est certain.", c("modele <- glm(", "  depart_90j ~ anciennete_mois + utilisation_mensuelle +", "    tickets_service_6m + satisfaction + type_contrat,", "  family = binomial(), data = train", ")", "probabilite <- predict(modele, newdata = test, type = \"response\")", "summary(probabilite)"), "Présenter une probabilité comme un verdict individuel confond incertitude statistique et certitude opérationnelle.", c("Les probabilités servent à ordonner les priorités.", "La règle de décision exige un seuil explicite."), "Expliquez pourquoi une probabilité prédite de 0,70 ne garantit pas un départ.") ,
    deck(3, "Matrice de confusion", "Une décision de ciblage crée des erreurs différentes, pas seulement un pourcentage global.", "Que se passe-t-il après le choix d'un seuil?", "Le seuil crée des vrais positifs, faux positifs, vrais négatifs et faux négatifs. Les mesures doivent correspondre au coût de ces erreurs.", c("Construire une matrice de confusion.", "Interpréter sensibilité, spécificité et précision."), c("La sensibilité mesure les départs détectés.", "La spécificité mesure les non-départs écartés.", "La précision décrit la part des clients ciblés qui partent réellement."), "Avec une classe positive minoritaire, prédire toujours la classe majoritaire peut donner une exactitude élevée tout en ratant les clients à retenir.", c("seuil <- 0.30", "prediction <- as.integer(probabilite >= seuil)", "table(observe = test$depart_90j, predit = prediction)", "tibble(", "  sensibilite = sum(prediction == 1 & test$depart_90j == 1) / sum(test$depart_90j == 1),", "  precision = sum(prediction == 1 & test$depart_90j == 1) / sum(prediction == 1)", ")"), "Rapporter seulement l'exactitude peut masquer une méthode incapable de détecter la classe positive.", c("La matrice montre le type d'erreur.", "La mesure choisie doit servir la décision."), "Nommez l'erreur associée à un client qui part sans être ciblé et son coût possible.") ,
    deck(4, "Choisir un seuil décisionnel", "Le seuil est une règle de gestion, pas une constante mathématique.", "Pourquoi 0,5 n'est-il pas automatiquement le bon choix?", "Un seuil plus bas cible davantage de clients et augmente souvent la sensibilité, mais il utilise aussi plus de capacité et peut réduire la précision.", c("Comparer des seuils sur une période test.", "Relier le seuil à la capacité et au coût des erreurs.", "Vérifier la proportionnalité et l'équité avant le déploiement."), c("Le seuil transforme une probabilité en intervention.", "La capacité de contact peut définir une règle réaliste.", "La règle doit être validée hors échantillon.", "Le suivi doit comparer la qualité de service entre les groupes pertinents et prévoir un recours humain."), "Si l'équipe peut contacter 15 % des clients, elle peut ordonner les probabilités et cibler les 15 % les plus élevés, puis vérifier cette règle sur le test.", c("seuil <- quantile(probabilite, probs = 0.85)", "cible <- probabilite >= seuil", "tibble(", "  clients_test = nrow(test),", "  clients_cibles = sum(cible),", "  departs_detectes = sum(cible & test$depart_90j == 1),", "  precision = mean(test$depart_90j[cible])", ")"), "Fixer 0,5 sans regarder la capacité, la valeur d'un client ou le coût des faux négatifs donne une décision arbitraire.", c("Un seuil est un choix explicite de gestion.", "Il doit être justifié et testé.", "L'intervention doit rester proportionnée et révisable."), "Proposez une règle de ciblage lorsque l'équipe peut contacter seulement 15 % des clients, puis nommez une vérification d'équité à effectuer avant le déploiement.")
  )
)

for (module_name in names(module_specs)) {
  output_dir <- file.path("modules", module_name, "media", "qmd")
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

  for (spec in module_specs[[module_name]]) {
    module_number <- sub("^semaine-([0-9]+).*$", "\\1", module_name)
    spec$activity_number <- paste0(as.integer(module_number), ".", spec$number)
    output_file <- file.path(output_dir, sprintf("capsule-%02d-support.qmd", spec$number))
    writeLines(deck_lines(spec, module_name), output_file, useBytes = TRUE)
  }
}

add_deck_links <- function(module_name) {
  path <- file.path("modules", module_name, "capsules.qmd")
  lines <- readLines(path, warn = FALSE)

  if (any(grepl("media/qmd/capsule-01-support.html", lines, fixed = TRUE))) {
    return(invisible(FALSE))
  }

  output <- character()
  capsule_number <- NA_integer_

  for (line in lines) {
    if (grepl("^## Capsule [0-9]+", line)) {
      capsule_number <- as.integer(sub("^## Capsule ([0-9]+).*$", "\\1", line))
    }

    if (identical(line, "### Support écrit")) {
      output <- c(
        output,
        "### Deck de capsule",
        "",
        paste0(
          "[Ouvrir le support visuel RevealJS](media/qmd/capsule-",
          sprintf("%02d", capsule_number),
          "-support.html)"
        ),
        "",
        line
      )
    } else {
      output <- c(output, line)
    }
  }

  writeLines(output, path, useBytes = TRUE)
  invisible(TRUE)
}

invisible(lapply(names(module_specs), add_deck_links))

# Le site emploie déjà « Activité » dans les pages d'entrée. Les supports des
# modules 01 à 03 utilisaient encore l'ancien libellé « Production autonome ».
for (module_name in c(
  "semaine-01-introduction",
  "semaine-02-r-quarto",
  "semaine-03-regression-lineaire"
)) {
  files <- list.files(
    file.path("modules", module_name, "media", "qmd"),
    pattern = "support[.]qmd$",
    full.names = TRUE
  )

  for (file in files) {
    lines <- readLines(file, warn = FALSE)
    lines <- sub("^## Production autonome ", "## Activité ", lines)
    writeLines(lines, file, useBytes = TRUE)
  }
}

message("Supports RevealJS créés et vocabulaire des activités harmonisé.")
