# Vérifier les calculs du projet de démonstration dans une copie extraite.
library(tidyverse)

racine <- normalizePath('.')
module <- file.path(racine, 'modules/atelier-03-series-chronologiques')
base <- tempfile('verification-laboratoire03-')
dir.create(base)
utils::unzip(file.path(module, 'telechargements/exemple-laboratoire-03.zip'), exdir = base)
dossier <- file.path(base, 'exemple-laboratoire-03')
ancien <- getwd(); setwd(dossier)
on.exit(setwd(ancien), add = TRUE)
resultat <- new.env(parent = globalenv())
sys.source('exemple-labo-03.R', envir = resultat)
a <- resultat$apprentissage
v <- resultat$validation
futur <- resultat$futur
p <- resultat$comparaison
stopifnot(nrow(a) == 60L, nrow(v) == 12L,
          as.character(max(a$date)) == '2024-12-01',
          as.character(min(v$date)) == '2025-01-01',
          identical(futur$date, v$date), identical(futur$indice, 61:72),
          !any(c('livraisons', 'observe') %in% names(futur)))
# Recalcul matriciel de la régression, sans predict.lm.
x <- model.matrix(resultat$modele)
xf <- model.matrix(delete.response(terms(resultat$modele)), futur,
                   contrasts.arg = resultat$modele$contrasts)
beta <- solve(crossprod(x), crossprod(x, a$livraisons))
attendu <- as.numeric(xf %*% beta)
p_reg <- p |> filter(methode == 'Tendance et mois')
p_ref <- p |> filter(methode == 'Naïf saisonnier')
stopifnot(max(abs(p_reg$prevision - attendu)) < 1e-8,
          identical(as.numeric(p_ref$prevision), as.numeric(tail(a$livraisons, 12))))
# Vérifier séparément chaque mesure et le coût asymétrique annoncé.
for (methode in unique(p$methode)) {
  calcul <- p |> filter(.data$methode == !!methode)
  e <- v$livraisons - calcul$prevision
  stopifnot(max(abs(calcul$erreur - e)) < 1e-8,
            max(abs(calcul$cout - ifelse(e > 0, 2 * e, -e))) < 1e-8)
}
# Reconstituer l'intervalle de prédiction classique à 95 %.
s2 <- sum((a$livraisons - x %*% beta)^2) / (nrow(x) - ncol(x))
vf <- diag(xf %*% solve(crossprod(x)) %*% t(xf))
marge <- qt(.975, nrow(x) - ncol(x)) * sqrt(as.numeric(s2) * (1 + vf))
stopifnot(max(abs(resultat$intervalle[, 'fit'] - attendu)) < 1e-8,
          max(abs(resultat$intervalle[, 'upr'] - attendu - marge)) < 1e-8,
          max(abs(resultat$intervalle[, 'lwr'] - attendu + marge)) < 1e-8)
# La régénération du CSV s'effectue dans une copie isolée.
source('R/generer-livraisons.R', local = new.env(parent = globalenv()))
stopifnot(unname(tools::md5sum('data/livraisons_mensuelles_fictives.csv')) ==
            unname(tools::md5sum(file.path(module, 'data/livraisons_mensuelles_fictives.csv'))))
message('Calendrier, prédictions, coûts, intervalles et données vérifiés.')
