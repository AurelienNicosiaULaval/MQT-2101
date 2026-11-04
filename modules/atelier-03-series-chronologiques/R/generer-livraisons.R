# Données mensuelles fictives pour une coopérative de livraison.
# Une ligne correspond au nombre total de livraisons d'un mois.
set.seed(210103)
mois <- seq(as.Date('2020-01-01'), by = 'month', length.out = 72)
indices_saisonniers <- c(-140, -110, -80, -40, 5, 65, 120, 150, 75, 30, -10, -65)
indice <- seq_along(mois)
volume <- round(1100 + 4 * indice + rep(indices_saisonniers, 6) + rnorm(72, sd = 45))
donnees <- data.frame(date = mois, livraisons = volume)
dir.create('data', showWarnings = FALSE)
write.csv(donnees, 'data/livraisons_mensuelles_fictives.csv', row.names = FALSE)
