# Données du laboratoire 04

Les deux fichiers sont fictifs, issus de `scripts/10_create_second_block_data.R` avec la graine 210110. Ils ne contiennent aucune donnée personnelle réelle et peuvent être redistribués avec le cours. `R/regenerer-donnees.R` conserve l’ordre des tirages du générateur et réécrit les deux CSV locaux.

## Fidélisation

650 clients simulés, une ligne par client, sans date de recrutement ni valeur manquante. `client_id` identifie le client; `anciennete_mois` mesure son ancienneté en mois; `utilisation_mensuelle` son utilisation mensuelle en unités d’usage fictives; `tickets_service_6m` compte les demandes sur six mois; `satisfaction` est une note de 1 à 10; `type_contrat` est mensuel ou annuel; `rabais_actuel` vaut aucun, fidélité ou rétention; `valeur_mensuelle` est une valeur simulée en dollars canadiens; `depart_90j` vaut 1 en cas de départ dans les 90 jours et 0 sinon. Pour l’exercice, les variables sont supposées connues au moment de décider; le fichier ne permet pas d’auditer leur date réelle. Les clients sont générés comme unités fictives distinctes; l’indépendance et la stabilité devraient être examinées pour des données réelles.

Pour rappel, le tirage stratifié du module 10 fixe la graine 210110 et alloue environ 60 %, 20 % et 20 % aux trois partitions, par classe. La validation sert à choisir entre les seuils 0,30 et 0,50. Le test, distinct, évalue la règle retenue. Le partage aléatoire est pédagogique, pas une preuve de validité temporelle.

## Service en succursale

288 lignes, 72 mois de janvier 2020 à décembre 2025 pour quatre succursales fictives. Une ligne représente un mois-succursale. `date` est le premier jour du mois; `succursale` le lieu fictif; `indice_temps` le rang du mois; `promotion` indique oui/non; `capacite` décrit la capacité de service; `achalandage` le nombre de visites; `ruptures_stock` le nombre de ruptures; `temps_attente` des minutes; `satisfaction` une note de 1 à 10; `taux_utilisation` un rapport; `ventes` des dollars canadiens. `service_insuffisant_mois_suivant` est une étiquette binaire simulée pour l’horizon suivant : elle est générée à partir des conditions courantes et n’est pas reconstruite à partir d’une observation réelle du mois suivant. Les lignes d’une même succursale sont liées au fil du temps.

Le transfert du module 10 utilise les mois de janvier 2020 à novembre 2023 pour ajuster, janvier à novembre 2024 pour choisir la règle, et janvier à décembre 2025 pour l’évaluer. Les mois de décembre 2023 et de décembre 2024 sont exclus du choix précédent pour que leurs étiquettes à horizon d’un mois ne nécessitent pas d’information postérieure à la fin de l’année. Les variables du mois courant sont supposées disponibles au moment de décider; les étiquettes du test ne sont disponibles qu’après l’horizon. Le fichier est aussi utilisé pour un autre objectif au module 09 et à l’atelier 04.


## Protocole du laboratoire 04

Voie A : les ventes des quatre succursales sur 2020 à 2024 servent à ajuster, celles de 2025 à une validation réutilisée. Le calendrier et la succursale sont supposés connus; les promotions observées en 2025 ne sont pas utilisées comme intrants futurs. La référence saisonnière utilise uniquement les valeurs de 2024.

Voie B : entraînement de janvier 2020 à novembre 2023, validation de janvier à novembre 2024 pour calibrer le seuil sur le 80e percentile des risques, puis validation réutilisée sur janvier à décembre 2025. Les mois de décembre 2023 et 2024 sont écartés du bloc précédent à cause de l’étiquette à un mois. Le seuil appris sur 2024 ne garantit pas 20 % d’interventions en 2025. Les mêmes données ont déjà été examinées dans les modules 09 et 10; aucune de ces comparaisons ne constitue un nouveau test final indépendant.
