# Guide en classe - Laboratoire 04

## Une seule mission

Dans un seul rapport Quarto, définissez la décision et la cible, vérifiez les données, développez une voie avec une référence et des mesures adaptées, puis formulez une recommandation avec une limite et un suivi. Résumez l’autre voie en trois phrases.

Cette mission se réalise une fois. Choisissez la voie A ou B et conservez un seul rapport; les cinq étapes ne sont pas des rapports supplémentaires.

## Auto-vérification de la production

Je précise la cible, l’origine, l’horizon et l’unité.

Je compare la méthode et sa référence sur les mêmes observations.

Je distingue la validation réutilisée d’un nouveau test indépendant.

Ma recommandation cite les résultats, une limite et une règle de suivi.

## 1. Situer la décision

Définissez le destinataire, la cible, l’unité mois-succursale, l’origine et l’horizon. Pour les ventes, l’origine est la fin de 2024 et l’horizon va de janvier à décembre 2025. Pour le service, la décision intervient à la fin du mois courant et l’étiquette concerne le mois suivant.

> **TIP:**
>
> Une somme de ventes est une réponse continue; un service insuffisant est une étiquette binaire simulée. Un prédicteur n’est utile que s’il est disponible à la décision ou explicitement scénarisé.

## 2. Vérifier et explorer

Contrôlez l’unicité mois-succursale, la continuité du calendrier, les valeurs manquantes et les unités. Conservez un graphique ou tableau pertinent sur le passé utilisé pour ajuster.

> **TIP:**
>
> Le fichier contient 288 lignes, 72 mois et quatre succursales. Les périodes successives d’une même succursale sont liées; une ligne n’est pas un client indépendant.

## 3. Construire méthode et référence

Voie A : ajustez une régression avec temps, mois et succursale, puis reportez les ventes de 2024 aux mois correspondants de 2025. Voie B : ajustez une logistique avec conditions du mois courant et calculez sur les scores de validation 2024 le seuil du 80e percentile; la référence prédit la classe majoritaire de l’apprentissage.

> **TIP:**
>
> Les promotions et l’achalandage futurs ne sont pas présumés connus dans la voie A. En B, le seuil est fixé avant les résultats 2025; des étiquettes à un mois exigent d’écarter les mois de décembre 2023 et 2024 des blocs précédents.

## 4. Comparer et interpréter

Comparez les mêmes 48 mois-succursales de 2025. En A, utilisez ME, MAE et RMSE en dollars. En B, calculez VP, FP, VN, FN, sensibilité, spécificité, précision et proportion ciblée. Comparez aussi les résultats par succursale.

> **TIP:**
>
> Les données de 2025 ont déjà été examinées : elles ne constituent pas un nouveau test indépendant. Une précision peut être indéfinie si aucun cas n’est ciblé. Un seuil issu de 2024 ne garantit pas exactement 20 % de ciblage en 2025.

## 5. Recommander et surveiller

Rédigez une recommandation appuyée sur les résultats, une limite et une condition de révision. Résumez l’autre voie en trois phrases : cible, référence et mesure adaptée. Pour la voie B, examinez la concentration du ciblage sans supposer qu’il démontre automatiquement une iniquité ou l’effet d’une intervention.

> **TIP:**
>
> « Nous avons analysé… », « Sur la validation réutilisée… », « Nous recommandons… », « Cette recommandation dépend de… et sera revue lorsque… ».

## Rapport et relecture

Remettez une synthèse de deux pages maximum, en plus du code repliable. Une seule voie analytique doit être développée en profondeur. L’autre doit être résumée en trois phrases pour montrer que vous comprenez la différence de cible et de mesures. Le choix de la voie fait partie de l’évaluation. Il doit correspondre à la décision formulée. Incluez une déclaration IA, si applicable.

Vérifiez le rendu, demandez une relecture à un autre binôme ou à l’enseignant, puis corrigez un point précis. Le [transfert facultatif](../../modules/atelier-04-recapitulation/exercices.llms.md) est distinct du rapport principal.
