# Depuis la racine du module ou celle du cours.
library(ggplot2)
racines <- c(".", "modules/semaine-09-variables-externes-autocorrelation")
racine <- racines[file.exists(file.path(racines, "data/ventes_promotions_quebec.csv"))][1]
stopifnot(!is.na(racine))
v <- read.csv(file.path(racine, "data/ventes_promotions_quebec.csv"))
v$date <- as.Date(v$date)
v <- v[order(v$date), ]
v$mois <- factor(v$mois, levels = 1:12)
v$promotion <- factor(v$promotion, levels = c("non", "oui"))
a <- subset(v, date < as.Date("2025-01-01"))
stopifnot(nrow(a) == 60, nrow(v) == 72)
m <- lm(ventes ~ tendance + promotion + prix_moyen + indice_confiance + mois, a)
couleurs <- c(non = "#28536B", oui = "#A23C37")
style <- theme_minimal(base_size = 19) +
  theme(panel.grid.minor = element_blank(), legend.position = "bottom",
        axis.title = element_text(colour = "#273A42"))
sauver <- function(nom, graphique, hauteur = 3.5) {
  ggsave(file.path(racine, "media", paste0(nom, ".png")), graphique + style,
         width = 11, height = hauteur, dpi = 145, bg = "white")
}
p <- ggplot(a, aes(date, ventes / 1000)) +
  geom_line(colour = "#637680", linewidth = 0.65) +
  geom_point(aes(colour = promotion, shape = promotion), size = 2.7) +
  scale_colour_manual("Promotion", values = couleurs) +
  scale_shape_manual("Promotion", values = c(non = 1, oui = 17)) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  labs(x = NULL, y = "Ventes mensuelles (milliers de $)")
sauver("ventes-origine", p)
moyennes <- aggregate(ventes ~ promotion, a, mean)
p <- ggplot(a, aes(promotion, ventes / 1000, colour = promotion)) +
  geom_point(position = position_jitter(width = .16, height = 0, seed = 9),
             size = 2.4, alpha = .75) +
  geom_point(data = moyennes, shape = 23, fill = "white", colour = "black", size = 5) +
  scale_colour_manual(values = couleurs, guide = "none") +
  scale_x_discrete(labels = c(non = "Sans promotion (42 mois)", oui = "Avec promotion (18 mois)")) +
  labs(x = NULL, y = "Ventes mensuelles (milliers de $)")
sauver("mois-promotion", p)
d <- data.frame(date = a$date[-1], precedent = head(resid(m), -1) / 1000,
                courant = tail(resid(m), -1) / 1000)
juillet <- subset(d, date == as.Date("2020-07-01"))
p <- ggplot(d, aes(precedent, courant)) +
  geom_hline(yintercept = 0, colour = "grey55") +
  geom_vline(xintercept = 0, colour = "grey55") +
  geom_point(colour = "#28536B", size = 2.5) +
  geom_point(data = juillet, shape = 21, colour = "#A23C37", fill = "white", size = 4) +
  geom_text(data = juillet, label = "juin → juillet 2020", hjust = 1.08, size = 4.7) +
  labs(x = "Résidu du mois précédent (milliers de $)", y = "Résidu du mois courant\n(milliers de $)")
sauver("paires-residus", p, 3.6)
x <- model.matrix(m)[, -1, drop = FALSE]
ar <- forecast::Arima(a$ventes, order = c(1, 0, 0), xreg = x)
h <- 0:5
effet <- data.frame(h, dollars = 10000 * unname(coef(ar)["ar1"]) ^ h)
p <- ggplot(effet, aes(h, dollars)) + geom_hline(yintercept = 0, colour = "grey55") +
  geom_segment(aes(xend = h, yend = 0), colour = "#28536B", linewidth = 1) +
  geom_point(colour = "#A23C37", size = 3.5) +
  scale_x_continuous(breaks = h) +
  scale_y_continuous(labels = scales::label_number(big.mark = " ", accuracy = 1)) +
  labs(x = "Mois depuis l’écart initial", y = "Contribution attendue ($)")
sauver("memoire-ar1", p)
