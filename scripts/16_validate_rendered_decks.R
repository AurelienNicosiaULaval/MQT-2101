# Vérifie que chaque diapositive rendue contient un contenu visible.

library(tidyverse)
library(xml2)

files <- Sys.glob("docs/modules/semaine-*/media/qmd/capsule-??-support.html")

slides <- purrr::map_dfr(files, function(path) {
  document <- xml2::read_html(path)
  nodes <- xml2::xml_find_all(
    document,
    "//section[contains(concat(' ', normalize-space(@class), ' '), ' slide ')]"
  )

  tibble(
    file = path,
    slide = seq_along(nodes),
    text = stringr::str_squish(xml2::xml_text(nodes)),
    visual_elements = purrr::map_int(nodes, ~ length(xml2::xml_find_all(
      .x,
      paste0(
        ".//img | .//table | .//pre | ",
        ".//*[contains(@class, 'metric-grid') or ",
        "contains(@class, 'concept-grid') or ",
        "contains(@class, 'statement-grid') or ",
        "contains(@class, 'self-check')]"
      )
    )))
  )
})

blank_like <- slides |>
  filter(nchar(text) < 25, visual_elements == 0)

cat("Validation des supports rendus MQT-2101\n")
cat("Supports :", length(files), "\n")
cat("Diapositives :", nrow(slides), "\n")
cat("Diapositives vides ou quasi vides :", nrow(blank_like), "\n")

if (length(files) != 50) {
  stop("Le nombre de supports rendus devrait être 50.")
}

if (nrow(blank_like) > 0) {
  purrr::pwalk(blank_like, function(file, slide, text, visual_elements) {
    cat("-", file, "| diapositive", slide, "| texte :", dQuote(text), "\n")
  })
  stop("Des diapositives rendues sont vides ou quasi vides.")
}

message("Tous les supports rendus contiennent un contenu visible.")
