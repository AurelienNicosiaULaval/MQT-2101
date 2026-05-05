# Vérifie et installe les packages R nécessaires au cours MQT-2101.

required_packages <- c(
  "tidyverse",
  "quarto",
  "readr",
  "readxl",
  "janitor",
  "lubridate",
  "broom",
  "modelr",
  "tidymodels",
  "forecast",
  "fable",
  "feasts",
  "tsibble",
  "slider",
  "scales",
  "here"
)

installed_packages <- rownames(installed.packages())
missing_packages <- setdiff(required_packages, installed_packages)

if (length(missing_packages) > 0) {
  install.packages(missing_packages, repos = "https://cloud.r-project.org")
}

invisible(lapply(required_packages, require, character.only = TRUE))

message("Packages vérifiés pour MQT-2101.")
