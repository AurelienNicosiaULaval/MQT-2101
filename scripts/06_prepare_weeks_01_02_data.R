# Préparation des données publiques pour les semaines 01 et 02.

options(warn = -1)

suppressPackageStartupMessages({
  library(tidyverse)
  library(janitor)
  library(lubridate)
})

archives_dir <- file.path("anciens_documents", "sources_privees", "archives_zip")

week_01_data_dir <- file.path("modules", "semaine-01-introduction", "data")
week_02_data_dir <- file.path("modules", "semaine-02-r-quarto", "data")

dir.create(week_01_data_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(week_02_data_dir, recursive = TRUE, showWarnings = FALSE)

archives_zip <- list.files(
  archives_dir,
  pattern = "\\.zip$",
  full.names = TRUE
)

seance_01_zip <- archives_zip |>
  keep(~ str_detect(basename(.x), "ance 01") && str_detect(basename(.x), "Introduction"))

if (length(seance_01_zip) != 1L) {
  stop("L'archive de la séance 01 doit être trouvée une seule fois dans : ", archives_dir)
}

extract_dir <- file.path(tempdir(), "mqt2101_seance_01_publics")
unlink(extract_dir, recursive = TRUE)
dir.create(extract_dir, recursive = TRUE, showWarnings = FALSE)

if (nzchar(Sys.which("bsdtar"))) {
  status <- system2(
    "bsdtar",
    c("-xf", shQuote(seance_01_zip), "-C", shQuote(extract_dir))
  )
  if (!identical(status, 0L)) {
    stop("Extraction impossible avec bsdtar : ", seance_01_zip)
  }
} else {
  utils::unzip(seance_01_zip, exdir = extract_dir, overwrite = TRUE)
}

birth_file <- list.files(
  extract_dir,
  pattern = "^BirthUS\\.csv$",
  recursive = TRUE,
  full.names = TRUE
)

safety_file <- list.files(
  extract_dir,
  pattern = "^SafetyAirlines\\.csv$",
  recursive = TRUE,
  full.names = TRUE
)

if (length(birth_file) != 1L || length(safety_file) != 1L) {
  stop("Les fichiers BirthUS.csv et SafetyAirlines.csv doivent être trouvés une seule fois.")
}

birth_us <- readr::read_csv(birth_file, show_col_types = FALSE) |>
  janitor::clean_names()

safety_airlines <- readr::read_csv(safety_file, show_col_types = FALSE) |>
  janitor::clean_names()

readr::write_csv(birth_us, file.path(week_01_data_dir, "birth_us.csv"))
readr::write_csv(safety_airlines, file.path(week_01_data_dir, "safety_airlines.csv"))

set.seed(210102)

succursales <- tibble(
  succursale = c("Québec", "Montréal", "Sherbrooke", "Trois-Rivières"),
  region = c("Capitale-Nationale", "Montréal", "Estrie", "Mauricie"),
  surface_m2 = c(420, 540, 360, 335),
  indice_achalandage = c(1.02, 1.25, 0.90, 0.82)
)

mois <- seq.Date(
  from = as.Date("2025-01-01"),
  to = as.Date("2025-06-01"),
  by = "month"
)

mois_fr <- c("janvier", "février", "mars", "avril", "mai", "juin")

ventes_operations_quebec <- tidyr::crossing(mois = mois, succursales) |>
  mutate(
    mois_nom = mois_fr[month(mois)],
    campagne_locale = sample(c("oui", "non"), n(), replace = TRUE, prob = c(0.35, 0.65)),
    canal_principal = sample(
      c("magasin", "web", "telephone"),
      n(),
      replace = TRUE,
      prob = c(0.62, 0.30, 0.08)
    ),
    clients = round(
      rnorm(
        n(),
        mean = 1750 * indice_achalandage + if_else(campagne_locale == "oui", 185, 0),
        sd = 95
      )
    ),
    panier_moyen = round(
      rnorm(
        n(),
        mean = 58 + if_else(canal_principal == "web", 4, 0),
        sd = 4.2
      ),
      2
    ),
    ventes = round(clients * panier_moyen),
    delai_livraison_jours = round(
      pmax(
        1.2,
        rnorm(
          n(),
          mean = 3.8 - 0.002 * surface_m2 + if_else(canal_principal == "web", 0.8, 0),
          sd = 0.5
        )
      ),
      1
    ),
    satisfaction = round(
      pmin(
        10,
        pmax(
          1,
          rnorm(
            n(),
            mean = 8.6 - 0.25 * delai_livraison_jours + if_else(campagne_locale == "oui", 0.25, 0),
            sd = 0.5
          )
        )
      ),
      1
    )
  ) |>
  select(
    mois,
    mois_nom,
    succursale,
    region,
    surface_m2,
    campagne_locale,
    canal_principal,
    clients,
    panier_moyen,
    ventes,
    delai_livraison_jours,
    satisfaction
  )

ventes_operations_quebec$satisfaction[c(5, 14)] <- NA_real_
ventes_operations_quebec$delai_livraison_jours[c(9)] <- NA_real_

readr::write_csv(
  ventes_operations_quebec,
  file.path(week_02_data_dir, "ventes_operations_quebec.csv")
)

message("Données publiques préparées pour les semaines 01 et 02.")
