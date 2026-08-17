# Vérifie les jeux de données étudiants et leurs copies publiées.
# Exécuter depuis la racine du projet :
# Rscript scripts/13_validate_data_assets.R

specifications <- list(
  list(path = "modules/atelier-01-r/data/ventes_pme_quebec.csv", rows = 60L, missing = 5L,
       columns = c("mois", "mois_label", "saison", "succursale", "region", "surface_m2", "campagne_locale", "depenses_marketing", "clients", "panier_moyen", "ventes", "delai_livraison_jours", "ruptures_stock", "satisfaction", "taux_retour")),
  list(path = "modules/atelier-02-regression/data/performance_succursales_quebec.csv", rows = 72L, missing = 0L,
       columns = c("mois", "mois_label", "saison", "succursale", "region", "surface_m2", "campagne_locale", "depenses_marketing", "achalandage", "heures_personnel", "ruptures_stock", "delai_service_minutes", "satisfaction", "ventes")),
  list(path = "modules/atelier-03-series-chronologiques/data/demande_hebdomadaire_quebec.csv", rows = 104L, missing = 0L,
       columns = c("semaine", "numero_semaine", "promotion", "prix_moyen", "demande")),
  list(path = "modules/atelier-04-recapitulation/data/cas_integrateur_quebec.csv", rows = 288L, missing = 0L,
       columns = c("date", "succursale", "indice_temps", "promotion", "capacite", "achalandage", "ruptures_stock", "temps_attente", "satisfaction", "ventes", "niveau_service_insuffisant")),
  list(path = "modules/semaine-01-introduction/data/birth_us.csv", rows = 3652L, missing = 0L,
       columns = c("year", "month", "date_of_month", "day_of_week", "births")),
  list(path = "modules/semaine-01-introduction/data/safety_airlines.csv", rows = 56L, missing = 0L,
       columns = c("airline", "avail_seat_km_per_week", "incidents_85_99", "fatal_accidents_85_99", "fatalities_85_99", "incidents_00_14", "fatal_accidents_00_14", "fatalities_00_14")),
  list(path = "modules/semaine-02-r-quarto/data/ventes_operations_quebec.csv", rows = 24L, missing = 3L,
       columns = c("mois", "mois_nom", "succursale", "region", "surface_m2", "campagne_locale", "canal_principal", "clients", "panier_moyen", "ventes", "delai_livraison_jours", "satisfaction")),
  list(path = "modules/semaine-03-regression-lineaire/data/campagnes_marketing_quebec.csv", rows = 60L, missing = 0L,
       columns = c("mois", "mois_label", "region", "canal", "saison", "budget_marketing", "visites_site", "rabais", "ventes", "satisfaction")),
  list(path = "modules/semaine-04-regression-nonlineaire/data/achalandage_saturation_quebec.csv", rows = 72L, missing = 0L,
       columns = c("mois", "mois_label", "saison", "succursale", "region", "surface_m2", "capacite_reference", "campagne_locale", "depenses_marketing", "achalandage", "taux_occupation", "ruptures_stock", "temps_attente_minutes", "panier_moyen", "satisfaction", "ventes")),
  list(path = "modules/semaine-06-series-chronologiques-intro/data/ventes_mensuelles_quebec.csv", rows = 72L, missing = 0L,
       columns = c("date", "annee", "mois", "mois_label", "trimestre", "jours_ouverture", "clients", "ventes")),
  list(path = "modules/semaine-07-lissage/data/demande_hebdomadaire_quebec.csv", rows = 104L, missing = 0L,
       columns = c("semaine", "numero_semaine", "promotion", "prix_moyen", "demande")),
  list(path = "modules/semaine-08-tendance-saisonnalite/data/ventes_saisonnieres_quebec.csv", rows = 72L, missing = 0L,
       columns = c("date", "annee", "mois", "mois_label", "trimestre", "indice_temps", "ventes", "budget_cible")),
  list(path = "modules/semaine-09-variables-externes-autocorrelation/data/ventes_promotions_quebec.csv", rows = 72L, missing = 0L,
       columns = c("date", "annee", "mois", "mois_label", "tendance", "promotion", "prix_moyen", "indice_confiance", "budget_marketing", "ventes")),
  list(path = "modules/semaine-10-classification-modeles-avances/data/fidelisation_clients_quebec.csv", rows = 650L, missing = 0L,
       columns = c("client_id", "anciennete_mois", "utilisation_mensuelle", "tickets_service_6m", "satisfaction", "type_contrat", "rabais_actuel", "valeur_mensuelle", "depart_90j"))
)

errors <- character()

add_error <- function(message) {
  errors <<- c(errors, message)
}

for (specification in specifications) {
  path <- specification$path

  if (!file.exists(path)) {
    add_error(paste0("Fichier absent : ", path))
    next
  }

  data <- tryCatch(
    read.csv(path, check.names = FALSE, stringsAsFactors = FALSE, na.strings = c("", "NA")),
    error = function(condition) condition
  )

  if (inherits(data, "condition")) {
    add_error(paste0("CSV illisible : ", path, " : ", conditionMessage(data)))
    next
  }

  if (nrow(data) != specification$rows) {
    add_error(paste0(path, " : ", nrow(data), " lignes trouvées, ", specification$rows, " attendues."))
  }

  if (!identical(names(data), specification$columns)) {
    add_error(paste0(path, " : schéma de colonnes inattendu."))
  }

  if (sum(is.na(data)) != specification$missing) {
    add_error(paste0(path, " : nombre de valeurs manquantes inattendu."))
  }

  if (anyDuplicated(data)) {
    add_error(paste0(path, " : lignes entièrement dupliquées."))
  }

  numeric_columns <- vapply(data, is.numeric, logical(1))
  if (any(vapply(data[numeric_columns], function(column) any(!is.finite(column[!is.na(column)])), logical(1)))) {
    add_error(paste0(path, " : valeur numérique non finie."))
  }

  published_path <- file.path("docs", path)
  if (!file.exists(published_path)) {
    add_error(paste0("Copie publiée absente : ", published_path))
  } else if (unname(tools::md5sum(path)) != unname(tools::md5sum(published_path))) {
    add_error(paste0("Copie publiée différente de la source : ", path))
  }
}

weekly_source <- "modules/semaine-07-lissage/data/demande_hebdomadaire_quebec.csv"
weekly_workshop <- "modules/atelier-03-series-chronologiques/data/demande_hebdomadaire_quebec.csv"
if (file.exists(weekly_source) && file.exists(weekly_workshop) &&
    unname(tools::md5sum(weekly_source)) != unname(tools::md5sum(weekly_workshop))) {
  add_error("Les copies du jeu demande_hebdomadaire_quebec.csv divergent.")
}

time_specs <- list(
  list(path = weekly_source, column = "semaine", group = NULL, expected_step = 7),
  list(path = weekly_workshop, column = "semaine", group = NULL, expected_step = 7),
  list(path = "modules/semaine-06-series-chronologiques-intro/data/ventes_mensuelles_quebec.csv", column = "date", group = NULL, expected_step = NULL),
  list(path = "modules/semaine-08-tendance-saisonnalite/data/ventes_saisonnieres_quebec.csv", column = "date", group = NULL, expected_step = NULL),
  list(path = "modules/semaine-09-variables-externes-autocorrelation/data/ventes_promotions_quebec.csv", column = "date", group = NULL, expected_step = NULL),
  list(path = "modules/atelier-04-recapitulation/data/cas_integrateur_quebec.csv", column = "date", group = "succursale", expected_step = NULL)
)

for (specification in time_specs) {
  data <- read.csv(specification$path, check.names = FALSE, stringsAsFactors = FALSE)
  dates <- as.Date(data[[specification$column]])

  if (anyNA(dates)) {
    add_error(paste0(specification$path, " : date invalide."))
    next
  }

  groups <- if (is.null(specification$group)) rep("ensemble", nrow(data)) else data[[specification$group]]
  for (group_name in unique(groups)) {
    group_dates <- dates[groups == group_name]
    steps <- as.integer(diff(group_dates))
    if (any(steps <= 0L)) {
      add_error(paste0(specification$path, " : ordre temporel invalide pour ", group_name, "."))
    }
    if (!is.null(specification$expected_step) && any(steps != specification$expected_step)) {
      add_error(paste0(specification$path, " : fréquence temporelle inattendue pour ", group_name, "."))
    }
  }
}

cat("Validation des données MQT-2101\n")
cat("Jeux vérifiés :", length(specifications), "\n")
cat("Erreurs :", length(errors), "\n")

if (length(errors)) {
  cat(paste0("- ", errors, collapse = "\n"), "\n")
  quit(status = 1)
}

cat("Données et copies publiées validées.\n")
