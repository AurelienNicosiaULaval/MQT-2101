# Fonctions utilitaires pour MQT-2101.

theme_mqt <- function(base_size = 12) {
  ggplot2::theme_minimal(base_size = base_size) +
    ggplot2::theme(
      plot.title.position = "plot",
      panel.grid.minor = ggplot2::element_blank(),
      legend.position = "bottom"
    )
}

read_course_csv <- function(path, ...) {
  if (!file.exists(path)) {
    stop("Fichier introuvable : ", path, call. = FALSE)
  }

  readr::read_csv(path, show_col_types = FALSE, ...)
}

summarise_missing <- function(data) {
  tibble::tibble(
    variable = names(data),
    missing = vapply(data, function(x) sum(is.na(x)), integer(1)),
    pct_missing = missing / nrow(data)
  )
}

format_currency_ca <- function(x, digits = 0) {
  scales::dollar(
    x,
    prefix = "",
    suffix = " $",
    big.mark = " ",
    decimal.mark = ",",
    accuracy = 10^-digits
  )
}

