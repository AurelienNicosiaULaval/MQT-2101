# Recalculs indépendants dans deux archives extraites à l'extérieur du dépôt.
library(tidyverse)
library(forecast)
root <- normalizePath('.')
module <- file.path(root, 'modules/atelier-03-series-chronologiques')
preuves <- file.path(root, 'output/revision-laboratoire03-20261027/calculs')
dir.create(preuves, recursive = TRUE, showWarnings = FALSE)
base <- tempfile('verification-laboratoire03-');dir.create(base)
utils::unzip(file.path(module, 'telechargements/exemple-laboratoire-03.zip'), exdir = base)
utils::unzip(file.path(module, 'telechargements/corrige-transfert-labo-03.zip'), exdir = base)
d <- file.path(base, 'exemple-laboratoire-03');setwd(d)
guide <- new.env(parent = globalenv());sys.source('exemple-labo-03.R', envir = guide)
a <- guide$apprentissage;v <- guide$validation;p <- guide$previsions
stopifnot(nrow(a) == 91L, nrow(v) == 13L, all(p$semaine == v$semaine),
          as.character(max(a$semaine)) == '2025-09-22', as.character(guide$origine) == '2025-09-28',
          as.character(min(v$semaine)) == '2025-09-29', all(p$indice == 92:104),
          !any(c('observe','demande','promotion','prix_moyen') %in% names(guide$futur)))
stopifnot(all(p$Naive == tail(a$demande, 1)), all(p$MM4 == mean(tail(a$demande, 4))),
          all(p$Saisonnier == tail(a$demande, 52)[1:13]))
x <- cbind(1, a$indice);xf <- cbind(1, 92:104)
beta <- solve(crossprod(x), crossprod(x, a$demande))
stopifnot(max(abs(as.numeric(xf %*% beta) - p$Tendance)) < 1e-8)
for (method in c('Naive', 'MM4', 'SES', 'Saisonnier', 'Tendance')) {
  e <- v$demande - p[[method]]
  s <- guide$scores |> filter(methode == method)
  c <- guide$couts |> filter(methode == method)
  stopifnot(abs(s$ME - sum(e)/13) < 1e-8,
            abs(s$MAE - sum(abs(e))/13) < 1e-8,
            abs(s$RMSE - sqrt(sum(e^2)/13)) < 1e-8,
            abs(c$cout_total - sum(ifelse(e > 0, 18 * e, -5 * e))) < 1e-7)
}
stopifnot(guide$scores$methode[1] == 'Tendance', guide$couts$methode[1] == 'Tendance',
          abs((guide$scores |> filter(methode == 'Tendance'))$MAE - 93.1144768275) < 1e-8,
          abs((guide$couts |> filter(methode == 'MM4'))$cout_total - 21943.75) < 1e-7,
          all(guide$intervalles_ses$inf95 <= guide$intervalles_ses$inf80),
          all(guide$intervalles_ses$sup95 >= guide$intervalles_ses$sup80))
write_csv(guide$scores, file.path(preuves, 'scores-demande.csv'))
write_csv(guide$couts, file.path(preuves, 'couts-demande.csv'))
write_csv(guide$intervalles_ses, file.path(preuves, 'intervalles-ses.csv'))
write_csv(guide$evaluation, file.path(preuves, 'previsions-demande.csv'))
# Répéter les calculs avec d'autres valeurs en validation ne change aucune prévision.
valeurs_modifiees <- v |> mutate(demande = -1000)
stopifnot(all(p$semaine == valeurs_modifiees$semaine),
          max(abs(p$Tendance - as.numeric(xf %*% beta))) < 1e-8)
# Transfert mensuel dans un environnement distinct.
setwd(file.path(base, 'corrige-transfert-labo-03'))
transfert <- new.env(parent = globalenv());sys.source('corrige-transfert-labo-03.R', envir = transfert)
for (method in c('Calendrier', 'Saisonnier')) {
  row <- transfert$couts_previsions |> filter(methode == method)
  x <- transfert$evaluation |> filter(methode == method)
  e <- x$observe - x$prevision
  stopifnot(abs(row$MAE - sum(abs(e))/12) < 1e-6,
            abs(row$cout_total - sum(ifelse(e > 0, 1.5 * e, -.4 * e))) < 1e-5)
}
stopifnot(abs(transfert$budget_retro$cout_total - 1403013) < 1e-5,
          transfert$budget_retro$mois_au_dessus == 12L,
          sum(transfert$verif_intervalle$dans_intervalle) == 12L,
          all(transfert$exemple$MAE == c(5, 6)), all(transfert$exemple$cout_total == c(180, 60)))
write_csv(transfert$couts_previsions, file.path(preuves, 'couts-transfert.csv'))
write_csv(transfert$budget_retro, file.path(preuves, 'objectif-retrospectif.csv'))
write_csv(transfert$evaluation, file.path(preuves, 'previsions-transfert.csv'))
# Contrôler la fidélité des CSV et leur régénération dans une troisième copie.
for (nom in c('demande_hebdomadaire_quebec.csv', 'ventes_saisonnieres_quebec.csv')) {
  stopifnot(unname(tools::md5sum(file.path(module, 'data', nom))) ==
              unname(tools::md5sum(file.path(d, 'data', nom))))
}
dir.create(file.path(base, 'regeneration/data'), recursive = TRUE);setwd(file.path(base, 'regeneration'))
source(file.path(module, 'R/regenerer-donnees.R'), local = new.env(parent = globalenv()))
for (nom in c('demande_hebdomadaire_quebec.csv', 'ventes_saisonnieres_quebec.csv')) {
  stopifnot(unname(tools::md5sum(file.path(module, 'data', nom))) ==
              unname(tools::md5sum(file.path('data', nom))))
}
stopifnot(unname(tools::md5sum(file.path(module, 'data/demande_hebdomadaire_quebec.csv'))) ==
            unname(tools::md5sum(file.path(root, 'modules/semaine-07-lissage/data/demande_hebdomadaire_quebec.csv'))),
          unname(tools::md5sum(file.path(module, 'data/ventes_saisonnieres_quebec.csv'))) ==
            unname(tools::md5sum(file.path(root, 'modules/semaine-08-tendance-saisonnalite/data/ventes_saisonnieres_quebec.csv'))))
capture.output(sessionInfo(), file = file.path(preuves, 'sessionInfo.txt'))
writeLines(base, file.path(preuves, 'copie-execution.txt'))
message('Prévisions, mesures, coûts, intervalles et données reproduits dans des copies extérieures.')
