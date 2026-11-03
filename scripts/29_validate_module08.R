# Recalcul indépendant du socle, dans une copie extérieure au dépôt.
library(tidyverse)
library(broom)
module <- normalizePath("modules/semaine-08-tendance-saisonnalite")
preuves <- file.path(getwd(), "output/revision-module08-20261026/calculs")
dir.create(preuves, recursive = TRUE, showWarnings = FALSE)
base <- tempfile("mqt08-verification-")
dir.create(base)
stopifnot(all(file.copy(file.path(module, c("R", "data")), base, recursive = TRUE)))
setwd(base)
source(file.path(module, "R/analyse-supports.R"))
stopifnot(nrow(apprentissage) == 60L, nrow(validation) == 12L,
          identical(as.integer(futur$indice_temps), 61:72),
          identical(futur$date, validation$date),
          !any(c("ventes", "budget_cible", "promotion", "prix_moyen") %in% names(futur)),
          nrow(model.matrix(modele_calendrier)) == 60L,
          ncol(model.matrix(modele_calendrier)) == 13L,
          levels(apprentissage$mois)[1] == "janvier")
# Formule directe des coefficients et des intervalles, distincte de predict.lm.
x <- model.matrix(modele_calendrier)
xf <- model.matrix(delete.response(terms(modele_calendrier)), futur,
                   contrasts.arg = list(mois = "contr.treatment"))
beta_direct <- solve(crossprod(x), crossprod(x, apprentissage$ventes))
s2 <- sum((apprentissage$ventes - x %*% beta_direct)^2) / (60 - 13)
v <- diag(xf %*% solve(crossprod(x)) %*% t(xf))
marge_ip <- qt(.975, 47) * sqrt(as.numeric(s2) * (1 + v))
marge_ic <- qt(.975, 47) * sqrt(as.numeric(s2) * v)
stopifnot(max(abs(xf %*% beta_direct - ip[, "fit"])) < 1e-6,
          max(abs(marge_ip - (ip[, "upr"] - ip[, "fit"]))) < 1e-6,
          max(abs(marge_ic - (ic[, "upr"] - ic[, "fit"]))) < 1e-6,
          all(marge_ip > marge_ic))
# Changer le mois de référence ne doit pas changer les prévisions.
recode <- apprentissage |> mutate(mois = relevel(mois, ref = "décembre"))
autre <- lm(ventes ~ indice_temps + mois, data = recode,
            contrasts = list(mois = "contr.treatment"))
stopifnot(max(abs(predict(autre, futur) - ip[, "fit"])) < 1e-6)
for (nom in unique(previsions$methode)) {
  p <- previsions |> filter(methode == nom)
  s <- scores |> filter(methode == nom)
  e <- p$observe - p$prevision
  stopifnot(abs(s$ME - sum(e) / 12) < 1e-8,
            abs(s$MAE - sum(abs(e)) / 12) < 1e-8,
            abs(s$RMSE - sqrt(sum(e^2) / 12)) < 1e-8)
}
stopifnot(scores$methode[1] == "Calendrier",
          abs(scores$MAE[1] - 9891.25) < 1e-5,
          max(abs((previsions |> filter(methode == "Saisonnier_naif"))$prevision -
                    tail(apprentissage$ventes, 12))) == 0)
write_csv(scores, file.path(preuves, "scores-guides.csv"))
write_csv(previsions, file.path(preuves, "previsions-guidees.csv"))
write_csv(previsions_intervalle, file.path(preuves, "intervalles-guides.csv"))
write_csv(tidy(modele_calendrier, conf.int = TRUE), file.path(preuves, "coefficients-guides.csv"))
# Vérification du transfert avec un calcul direct sur les matrices.
commerce <- read_csv("data/ventes_promotions_quebec.csv", show_col_types = FALSE) |>
  preparer_calendrier()
train_c <- commerce |> slice_head(n = 60)
val_c <- commerce |> slice_tail(n = 12)
modeles_c <- list(Tendance = lm(ventes ~ indice_temps, train_c),
  Saison = lm(ventes ~ mois, train_c, contrasts = list(mois = "contr.treatment")),
  Calendrier = lm(ventes ~ indice_temps + mois, train_c,
                  contrasts = list(mois = "contr.treatment")))
pred_c <- imap_dfr(modeles_c, function(m, nom) {
  xx <- model.matrix(m)
  xxx <- model.matrix(delete.response(terms(m)), futur, contrasts.arg = m$contrasts)
  direct <- as.numeric(xxx %*% solve(crossprod(xx), crossprod(xx, train_c$ventes)))
  stopifnot(max(abs(direct - predict(m, futur))) < 1e-6)
  tibble(date = futur$date, methode = nom, observe = val_c$ventes, prevision = direct)
}) |> bind_rows(tibble(date = futur$date, methode = "Saisonnier_naif",
                       observe = val_c$ventes, prevision = tail(train_c$ventes, 12)))
scores_c <- pred_c |> group_by(methode) |>
  summarise(ME = sum(observe - prevision) / 12,
            MAE = sum(abs(observe - prevision)) / 12,
            RMSE = sqrt(sum((observe - prevision)^2) / 12), .groups = "drop") |> arrange(MAE)
stopifnot(scores_c$methode[1] == "Calendrier",
          abs(scores_c$MAE[1] - 32389.0333333333) < 1e-5,
          abs(coef(modeles_c$Calendrier)["moisdécembre"] - 13190.75) < 1)
write_csv(scores_c, file.path(preuves, "scores-transfert.csv"))
write_csv(pred_c, file.path(preuves, "previsions-transfert.csv"))
write_csv(tidy(modeles_c$Calendrier, conf.int = TRUE), file.path(preuves, "coefficients-transfert.csv"))
# Les prévisions sont identiques si on remplace les ventes de validation:
# elles utilisent le calendrier construit avant toute lecture de ces cibles.
alteree <- validation |> mutate(ventes = -1, budget_cible = -1)
stopifnot(identical(futur, calendrier_futur(min(alteree$date), 12, 60)),
          max(abs(predict(modele_calendrier, futur) - ip[, "fit"])) == 0)
dir.create("regeneration/data", recursive = TRUE)
setwd("regeneration")
source(file.path(module, "R/regenerer-donnees.R"))
setwd(base)
for (nom in c("ventes_saisonnieres_quebec.csv", "ventes_promotions_quebec.csv")) {
  stopifnot(unname(tools::md5sum(file.path("data", nom))) ==
              unname(tools::md5sum(file.path("regeneration/data", nom))))
}
capture.output(sessionInfo(), file = file.path(preuves, "sessionInfo.txt"))
writeLines(base, file.path(preuves, "copie-execution.txt"))
message("Socle, scores directs, intervalles, référence du facteur, absence de fuite et CSV concordants.")
