# Recalcul ciblé et contrôles indépendants du module 07, dans une copie séparée.
library(tidyverse)
library(slider)
library(forecast)
module <- normalizePath("modules/semaine-07-lissage")
preuves <- normalizePath("output/revision-module07-20261026/calculs")
base <- tempfile("mqt07-verification-")
dir.create(base)
file.copy(file.path(module, c("R", "data")), base, recursive = TRUE)
avant <- getwd()
setwd(base)
on.exit(setwd(avant))
source(file.path(module, "R/analyse-supports.R"))
# Le code technique du support lit les CSV et fonctions de la copie, sans réécrire le dépôt.
stopifnot(nrow(previsions) == 13L, nrow(previsions_e) == 12L,
          nrow(erreurs) == 13L * 4L, nrow(erreurs_e) == 12L * 5L,
          as.character(max(apprentissage$semaine)) == "2025-09-22",
          as.character(min(validation$semaine)) == "2025-09-29")
stopifnot(identical(previsions$Saisonnier, apprentissage$demande[40:52] * 1),
          identical(previsions_e$Saisonnier, tail(apprentissage_e$consommation_kwh, 12) * 1))
stopifnot(sum(is.na(lissage$mm4)) == 3L, sum(is.na(lissage$mm13)) == 12L,
          tail(lissage$mm4, 1) == mean(tail(apprentissage$demande, 4)))
# Vérification directe, distincte du helper de mesure.
for (methode in c("Naive", "MM4", "SES", "Saisonnier")) {
  e <- previsions$observe - previsions[[methode]]
  ligne <- scores |> filter(.data$methode == .env$methode)
  stopifnot(abs(ligne$MAE - sum(abs(e)) / 13) < 1e-10,
            abs(ligne$RMSE - sqrt(sum(e * e) / 13)) < 1e-10,
            abs(ligne$ME - sum(e) / 13) < 1e-10)
}
for (methode in c("Naive", "MM3", "SES02", "SES08", "Saisonnier")) {
  e <- previsions_e$observe - previsions_e[[methode]]
  ligne <- scores_e |> filter(.data$methode == .env$methode)
  cout_direct <- sum(ifelse(e >= 0, 2 * e, -e)) / 12
  stopifnot(abs(ligne$MAE - sum(abs(e)) / 12) < 1e-8,
            abs(ligne$cout_moyen - cout_direct) < 1e-8)
}
stopifnot(all.equal(niveau_ses(c(100, 140, 140), 0.2), c(100, 108, 114.4)),
          all.equal(niveau_ses(c(100, 140, 140), 0.8), c(100, 132, 138.4)))
# Contrôle des deux alphas contre l’implémentation forecast avec initialisation simple.
for (alpha in c(0.2, 0.8)) {
  p <- as.numeric(ses(serie_e, h = 12, alpha = alpha, initial = "simple")$mean)
  manuel <- rep(tail(niveau_ses(apprentissage_e$consommation_kwh, alpha), 1), 12)
  stopifnot(max(abs(p - manuel)) < 1e-7)
}
stopifnot((scores |> arrange(MAE))$methode[1] == "MM4",
          (scores_e |> arrange(MAE))$methode[1] == "Saisonnier",
          (scores_e |> arrange(cout_moyen))$methode[1] == "Saisonnier",
          (scores_e |> filter(methode != "Saisonnier") |> arrange(MAE))$methode[1] == "SES02",
          (scores_e |> filter(methode != "Saisonnier") |> arrange(cout_moyen))$methode[1] == "MM3")
# Reproduire les CSV dans une autre copie et comparer leurs octets.
dir.create("regeneration")
dir.create("regeneration/data")
setwd("regeneration")
source(file.path(module, "R/regenerer-donnees.R"))
setwd(base)
for (nom in c("demande_hebdomadaire_quebec.csv", "consommation_electrique_batiment_quebec.csv")) {
  stopifnot(unname(tools::md5sum(file.path("data", nom))) ==
              unname(tools::md5sum(file.path("regeneration/data", nom))))
}
write_csv(scores, file.path(preuves, "demande-recalcule.csv"))
write_csv(scores_e, file.path(preuves, "electricite-recalcule.csv"))
write_csv(previsions, file.path(preuves, "previsions-demande.csv"))
write_csv(previsions_e, file.path(preuves, "previsions-electricite.csv"))
capture.output(sessionInfo(), file = file.path(preuves, "sessionInfo.txt"))
writeLines(base, file.path(preuves, "copie-execution.txt"))
message("Calculs, récurrences, références et CSV régénérés concordants.")
