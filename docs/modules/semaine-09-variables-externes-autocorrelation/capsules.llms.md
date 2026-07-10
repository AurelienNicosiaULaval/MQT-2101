# Capsules - Module 09

## Capsule 1 - Variables externes disponibles

## Vidéo

> **NOTE:**
>
> Durée cible : 7 à 9 minutes. Classer prix, promotion, calendrier et indicateur économique selon leur disponibilité au moment de prévoir.

## Deck de capsule

[Ouvrir le support visuel RevealJS](media/qmd/capsule-01-support.llms.md)

## Support écrit

Un prédicteur externe apporte de l’information autre que le passé de la cible. Avant de l’utiliser, classez-le :

- connu : calendrier ou promotion déjà planifiée;
- scénarisé : prix envisagé ou budget proposé;
- prévu séparément : indicateur économique futur;
- indisponible : valeur observée seulement après la période cible.

Utiliser une variable indisponible dans le futur crée une fuite d’information et une performance irréaliste.

### Activité 9.1

Classez la météo du mois prochain, une promotion déjà approuvée et les ventes réelles du mois prochain.

> **TIP:**
>
> La promotion est connue. La météo est prévue séparément et donc incertaine. Les ventes futures sont la cible et ne peuvent pas servir de prédicteur.

## Capsule 2 - Régression conditionnelle

## Vidéo

> **NOTE:**
>
> Durée cible : 7 à 9 minutes. Ajuster une régression avec tendance, promotion, prix et calendrier.

## Deck de capsule

[Ouvrir le support visuel RevealJS](media/qmd/capsule-02-support.llms.md)

## Support écrit

Une régression temporelle peut s’écrire :

\\ y_t=\beta_0+\beta_1t+\beta_2x\_{t}+\gamma\_{m(t)}+\eta_t. \\

Le coefficient de promotion est une association conditionnelle aux autres variables du modèle. Si les promotions ont été choisies précisément durant les mois faibles, une comparaison brute peut même sous-estimer leur contribution. Une analyse causale exigerait un plan différent.

### Activité 9.2

Pourquoi les ventes prévues sous « promotion oui » et « promotion non » ne constituent-elles pas automatiquement une estimation causale de la promotion?

> **TIP:**
>
> Le modèle observationnel peut omettre des facteurs associés au choix de la promotion et aux ventes. La différence est conditionnelle au modèle, pas à une assignation expérimentale.

## Capsule 3 - Autocorrélation des résidus

## Vidéo

> **NOTE:**
>
> Durée cible : 7 à 9 minutes. Lire une fonction d’autocorrélation et interpréter le test de Ljung-Box.

## Deck de capsule

[Ouvrir le support visuel RevealJS](media/qmd/capsule-03-support.llms.md)

## Support écrit

L’autocorrélation mesure la relation entre une série et ses valeurs décalées. Après modélisation, les résidus devraient idéalement ressembler à un bruit sans structure prévisible.

Un pic au retard 1 indique que des résidus voisins tendent à se ressembler. Le test de Ljung-Box évalue collectivement plusieurs autocorrélations. Une petite valeur p signale une incompatibilité avec l’absence globale d’autocorrélation, mais ne mesure pas à elle seule l’importance opérationnelle.

### Activité 9.3

Si les résidus positifs sont souvent suivis de résidus positifs, quel défaut pratique peut apparaître?

> **TIP:**
>
> Le modèle peut sous-prévoir plusieurs périodes consécutives. Les erreurs ne sont pas indépendantes et certaines structures temporelles restent inutilisées.

## Capsule 4 - Erreurs AR et scénarios

## Vidéo

> **NOTE:**
>
> Durée cible : 8 à 10 minutes. Comparer régression ordinaire et régression avec erreurs AR(1), puis prévoir sous scénarios.

## Deck de capsule

[Ouvrir le support visuel RevealJS](media/qmd/capsule-04-support.llms.md)

## Support écrit

Un modèle avec erreurs AR(1) suppose :

\\ \eta_t=\phi\eta\_{t-1}+\varepsilon_t, \\

où \\\varepsilon_t\\ n’est plus autocorrélé. Le modèle combine l’information des variables externes et la dépendance des erreurs.

Pour prévoir, il faut fournir les valeurs futures des prédicteurs. Si elles sont scénarisées, le résultat doit être présenté comme « prévision conditionnelle à ce scénario ».

### Activité 9.4

Rédigez une phrase complète présentant une prévision sous un scénario où une promotion est maintenue et le prix reste stable.

> **TIP:**
>
> La phrase doit nommer l’horizon, la cible et les hypothèses de promotion et de prix; elle ne doit pas présenter le résultat comme inconditionnel.
