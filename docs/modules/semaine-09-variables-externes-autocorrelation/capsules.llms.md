# Capsules - Module 09

## Objectif

À la fin du parcours, vous pourrez comparer deux prévisions de ventes et expliquer à la direction quelles hypothèses rendent leur utilisation possible. Ouvrez le [projet guidé](telechargements/variables-ventes.zip) et suivez la [préparation en R](../../modules/semaine-09-variables-externes-autocorrelation/demonstrations.llms.md#preparation). Consignez chaque production une seule fois dans `variables_ventes.qmd`. Vous retrouverez la même consigne sur l’accueil et à la fin du diaporama.

Téléchargez le [lot PDF pour tablette](telechargements/module-09-pdf-2026-11-25-annote.zip) : les cinq supports, leurs versions annotées et les notes de cours.

## Capsule 1 - Auditer les variables

À la fin de décembre, quelles colonnes de la ligne de janvier peut-on vraiment remplir ? Utilisez le prix moyen et la date de diffusion de l’indice pour trancher.

## Vidéo

[Ouvrir la capsule 1 sur YouTube](https://www.youtube.com/watch?v=C_iJnWW_FhI)

## PDF

[Ouvrir le PDF](media/pdf/capsule-01-support.pdf) · [Télécharger le PDF](media/pdf/capsule-01-support.pdf)

## PDF annoté

[Ouvrir le PDF annoté](media/pdf/capsule-01-support-annote.pdf) · [Télécharger le PDF annoté](media/pdf/capsule-01-support-annote.pdf)

## HTML

[Ouvrir les diapositives](media/qmd/capsule-01-support.llms.md) · [Télécharger les diapositives](media/qmd/capsule-01-support.llms.md)

### Activité 9.1

Classez la promotion, le prix, l’indice de confiance et les ventes futures selon leur disponibilité à la fin de 2024. Indiquez pour chacun une source connue, un scénario ou une information indisponible.

Auto-vérification : Je précise l’origine. Je distingue une valeur prévue d’une valeur observée après coup. Je ne mets pas la cible future parmi les prédicteurs.

> **TIP:**
>
> À la fin de décembre 2024, le calendrier de janvier est connu. Classez la promotion et le prix comme connus seulement si un plan daté les confirme. Sinon, indiquez les valeurs retenues comme hypothèses. Pour l’indice de confiance, il faut une prévision disponible à cette date ou une valeur posée par scénario. Les ventes de janvier sont la cible. Le fichier donne les valeurs réalisées en 2025, sans établir qu’elles étaient connues au départ.
>
> [Reprendre cette étape dans la démonstration R](../../modules/semaine-09-variables-externes-autocorrelation/demonstrations.llms.md#disponibilite).

> **NOTE:**
>
> Poursuivez avec le [transfert](../../modules/semaine-09-variables-externes-autocorrelation/exercices.llms.md#exercice-1).

## Capsule 2 - Ajuster et interpréter

Les ventes moyennes sont plus élevées les mois de promotion. Comparez cet écart brut au coefficient ajusté, puis faites varier le prix.

## Vidéo

[Ouvrir la capsule 2 sur YouTube](https://www.youtube.com/watch?v=y_t__plVm_0)

## PDF

[Ouvrir le PDF](media/pdf/capsule-02-support.pdf) · [Télécharger le PDF](media/pdf/capsule-02-support.pdf)

## PDF annoté

[Ouvrir le PDF annoté](media/pdf/capsule-02-support-annote.pdf) · [Télécharger le PDF annoté](media/pdf/capsule-02-support-annote.pdf)

## HTML

[Ouvrir les diapositives](media/qmd/capsule-02-support.llms.md) · [Télécharger les diapositives](media/qmd/capsule-02-support.llms.md)

### Activité 9.2

Ajustez la régression des ventes sur la tendance, le mois, la promotion, le prix et l’indice de confiance avec les 60 premiers mois. Interprétez le coefficient de promotion en dollars, à autres variables fixées, sans conclure à un effet causal.

Auto-vérification : Je nomme la catégorie de référence et les unités. Je distingue association conditionnelle et causalité. Je n’utilise pas les douze mois de validation pour ajuster le modèle.

> **TIP:**
>
> Sur les 60 mois de 2020 à 2024, le coefficient de `promotionoui` vaut environ 47 566 \$. Pour un même mois, une même tendance, un même prix et un même indice, le modèle associe la promotion à des ventes ajustées supérieures de 47 566 \$ à celles de la catégorie de référence « non ». Les décisions de promotion peuvent dépendre d’autres facteurs. Ce coefficient ne suffit donc pas pour attribuer cet écart à la promotion.
>
> [Reprendre cette étape dans la démonstration R](../../modules/semaine-09-variables-externes-autocorrelation/demonstrations.llms.md#regression).

> **NOTE:**
>
> Après la capsule 3, faites l’[exercice 2](../../modules/semaine-09-variables-externes-autocorrelation/exercices.llms.md#exercice-2), qui combine l’ajustement et le diagnostic par succursale.

## Capsule 3 - Diagnostiquer dans le temps

Calculez le résidu de juillet 2020. Suivez quatre mois successifs sur le tracé avant de lire les retards 1 et 12 de l’ACF.

## Vidéo

[Ouvrir la capsule 3 sur YouTube](https://www.youtube.com/watch?v=undNxWDkMCE)

## PDF

[Ouvrir le PDF](media/pdf/capsule-03-support.pdf) · [Télécharger le PDF](media/pdf/capsule-03-support.pdf)

## PDF annoté

[Ouvrir le PDF annoté](media/pdf/capsule-03-support-annote.pdf) · [Télécharger le PDF annoté](media/pdf/capsule-03-support-annote.pdf)

## HTML

[Ouvrir les diapositives](media/qmd/capsule-03-support.llms.md) · [Télécharger les diapositives](media/qmd/capsule-03-support.llms.md)

### Activité 9.3

Tracez les résidus de la régression en fonction du temps et leur autocorrélation. Décrivez les motifs observés et expliquez pourquoi ils ne prouvent pas à eux seuls l’indépendance des résidus.

Auto-vérification : Je garde l’ordre des mois et distingue résidus et erreurs de prévision. Je décris les retards et les motifs visibles. Je sais qu’une ACF peu marquée ne prouve pas l’indépendance.

> **TIP:**
>
> Sur les 60 mois d’entraînement, des écarts de même signe tendent à se suivre. L’ACF des résidus vaut environ 0,41 au retard 1 et −0,30 au retard 12, au-delà des repères approximatifs de ±0,25. La première valeur suggère une persistance d’un mois à l’autre. La seconde invite à examiner les mois séparés d’un an. Une seule barre ne permet pas d’identifier une cause saisonnière et ces graphiques ne démontrent pas l’indépendance.
>
> [Reprendre cette étape dans la démonstration R](../../modules/semaine-09-variables-externes-autocorrelation/demonstrations.llms.md#diagnostic).

> **NOTE:**
>
> Poursuivez avec le [diagnostic par succursale](../../modules/semaine-09-variables-externes-autocorrelation/exercices.llms.md#exercice-2).

## Capsule 4 - Comparer deux modèles

Suivez la propagation d’un écart dans un modèle AR(1), puis départagez les deux modèles sur janvier, juillet et enfin sur les douze mois.

## Vidéo

[Ouvrir la capsule 4 sur YouTube](https://www.youtube.com/watch?v=_D9EQnQFy6M)

## PDF

[Ouvrir le PDF](media/pdf/capsule-04-support.pdf) · [Télécharger le PDF](media/pdf/capsule-04-support.pdf)

## PDF annoté

[Ouvrir le PDF annoté](media/pdf/capsule-04-support-annote.pdf) · [Télécharger le PDF annoté](media/pdf/capsule-04-support-annote.pdf)

## HTML

[Ouvrir les diapositives](media/qmd/capsule-04-support.llms.md) · [Télécharger les diapositives](media/qmd/capsule-04-support.llms.md)

### Activité 9.4

À partir de la démonstration fournie, comparez la régression ordinaire et la régression avec erreurs AR(1) sur les mêmes douze mois à l’aide de la MAE et de la RMSE. Indiquez que les prédicteurs de validation sont les valeurs effectivement observées.

Auto-vérification : Je compare les deux modèles sur les mêmes observations et prédicteurs. J’exprime les scores en dollars. Je présente cette comparaison comme conditionnelle aux valeurs réalisées.

> **TIP:**
>
> Sur les mêmes douze mois de 2025, la régression ordinaire obtient une MAE de 5 088 \$ et une RMSE de 6 272 \$. Avec les erreurs AR(1), elles atteignent respectivement 5 380 \$ et 6 417 \$. Les deux critères favorisent donc la régression ordinaire pour cette période. Les deux modèles utilisent les prédicteurs effectivement observés en 2025. Pour évaluer la décision telle qu’elle se présentait fin 2024, il faudrait les prévisions ou les scénarios de prédicteurs disponibles à cette date.
>
> [Reprendre cette étape dans la démonstration R](../../modules/semaine-09-variables-externes-autocorrelation/demonstrations.llms.md#comparaison).

Le transfert reprend à la capsule 5 avec la décision de capacité de la succursale de Québec.

## Capsule 5 - Communiquer un scénario

Comparez les deux fiches de janvier, déplacez le prix dans la zone commune et examinez ce qui change lorsque l’indice passe de 100 à 105.

## Vidéo

[Ouvrir la capsule 5 sur YouTube](https://www.youtube.com/watch?v=SDH0CIlCli8)

## PDF

[Ouvrir le PDF](media/pdf/capsule-05-support.pdf) · [Télécharger le PDF](media/pdf/capsule-05-support.pdf)

## PDF annoté

[Ouvrir le PDF annoté](media/pdf/capsule-05-support-annote.pdf) · [Télécharger le PDF annoté](media/pdf/capsule-05-support-annote.pdf)

## HTML

[Ouvrir les diapositives](media/qmd/capsule-05-support.llms.md) · [Télécharger les diapositives](media/qmd/capsule-05-support.llms.md)

### Activité 9.5

Pour janvier 2025, comparez les prévisions de la régression ordinaire sous promotion oui et non, à prix et indice identiques. Présentez les hypothèses, une limite causale et l’incertitude non couverte liée aux prédicteurs futurs.

Auto-vérification : Je donne la cible, l’horizon et les valeurs du scénario. Je ne présente pas la différence comme un effet causal établi. Je rappelle que le scénario n’est pas nécessairement le futur réalisé.

> **TIP:**
>
> Pour janvier 2025, avec un prix de 60 \$ et un indice de 100, la régression ordinaire prévoit 498 619 \$ sans promotion et 546 185 \$ avec promotion. L’écart de 47 566 \$ décrit les deux scénarios du modèle. À 60 \$, le scénario avec promotion sort de la plage observée à l’entraînement, de 53,17 \$ à 57,86 \$. Le scénario sans promotion reste dans sa plage, de 57,47 \$ à 62,72 \$. La comparaison ne permet pas d’attribuer un gain à la promotion et laisse ouverte l’incertitude sur le prix et l’indice futurs.
>
> [Reprendre cette étape dans la démonstration R](../../modules/semaine-09-variables-externes-autocorrelation/demonstrations.llms.md#scenario).

> **NOTE:**
>
> Poursuivez avec le [scénario de transfert](../../modules/semaine-09-variables-externes-autocorrelation/exercices.llms.md#exercice-3), puis la [recommandation](../../modules/semaine-09-variables-externes-autocorrelation/exercices.llms.md#exercice-4).

## Après les capsules

Redémarrez R et rendez votre rapport guidé dans son projet. Relisez la [synthèse](notes-cours.llms.md), puis vérifiez que votre [recommandation pour la succursale de Québec](../../modules/semaine-09-variables-externes-autocorrelation/exercices.llms.md#exercice-4) précise son horizon et la limite des données sur la capacité.
