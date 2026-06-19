# Charte des capsules vidéo - MQT-2101

Standard à appliquer à **toutes les capsules de tous les modules**. Objectif : des supports cohérents, peu chargés à l'écran mais jamais vides, pensés pour la narration vidéo et pour les deux publics (génie / administration).

Ce document est la référence de format. Les principes pédagogiques de fond restent ceux de `interne/principes-refonte.qmd` ; cette charte les traduit en règles de mise en page concrètes.

---

## 1. Principes directeurs (rappel)

- **Une idée maîtresse par capsule.** Si une capsule couvre plus d'un concept central, la scinder.
- **Ouvrir par l'utilité concrète** (« Let's eat the cake ») : une décision réelle avant la théorie.
- **Alterner les publics** : sur l'ensemble d'un module, des exemples opérations/ingénierie ET ventes/marketing/finance/RH.
- **Données prioritaires** : québécoises > canadiennes > simulées réalistes > anciennes réutilisées.
- **Posture descriptive prudente** : nommer les variables, l'unité et l'échelle ; toujours finir par une limite ; pas de conclusion causale tant qu'on décrit.

---

## 2. Gabarit d'une capsule (ordre des diapos)

1. **Diapo titre** (générée par le YAML - voir §6).
2. **Pourquoi ça compte** - accroche concrète. **Obligatoire, en 2e position.** (voir §3)
3. **Objectifs de la capsule** - 3 à 4 puces courtes, pas davantage.
4. **Corps** - une idée par diapo, visuels prioritaires (voir §4 et §5).
5. **À retenir** - 3 cartes `.metric-grid` qui résument la capsule.
6. **Production autonome X.Y** - la tâche d'application + un bloc `.self-check`.

L'ordre et les libellés (« Objectifs de la capsule », « À retenir », « Production autonome X.Y », « Auto-vérification ») sont identiques d'une capsule à l'autre : c'est ce qui crée le réflexe chez l'étudiant·e.

---

## 3. La diapo « Pourquoi ça compte » (accroche)

Toujours juste après le titre. Elle répond à : *pourquoi devrais-je regarder cette capsule ?* en partant d'une **décision réelle**, pas d'une définition.

Structure type :

```markdown
## Pourquoi ça compte

::: {.kicker}
Une décision concrète
:::

::: {.question-line}
[Une question directe, liée à une décision réelle]
:::

::: {.note-box}
[Une à deux phrases : le scénario concret et le risque si on s'y prend mal.]
:::
```

Règles :

- La question doit pouvoir se lire à voix haute en 5 secondes.
- Le scénario doit nommer un contexte d'affaires ou d'opérations réel.
- On annonce souvent ce que la capsule permettra de **décider** ou d'**éviter**, pas ce qu'elle « présentera ».

---

## 4. Règle d'allègement visuel - « jamais une diapo vide »

C'est la règle la plus importante pour la vidéo.

- **Maximum ~5 ancres courtes par diapo.** Une ancre = 2 à 6 mots, pas une phrase complète.
- **La phrase complète se dit, ne s'écrit pas.** Ce qui était une puce-phrase devient un mot-clé à l'écran ; le développement passe à l'oral.
- **Alléger ne veut pas dire vider.** Quand on retire du texte, on le remplace par un **composant visuel** : carte, grille, bandeau de variables, schéma d'étapes, petit tableau ou figure. Une diapo ne doit jamais se réduire à un titre + deux mots seuls.
- **Une diapo = un message.** Si deux messages cohabitent, séparer en deux diapos plutôt que tasser.

Test rapide : si, en répétant, vous vous surprenez à **lire la diapo mot à mot**, c'est qu'elle est trop dense - déplacez le texte vers la parole et gardez l'ancre.

---

## 5. Bibliothèque visuelle (composants disponibles)

Ces classes sont définies dans `assets/ulaval-reveal.scss` et s'écrivent en divs Quarto imbriqués. **Privilégier ces composants aux longues listes à puces.**

| Composant | Quand l'utiliser | Couleur/forme |
|---|---|---|
| `.question-line` | accroche, grande question à l'écran | grand texte noir |
| `.kicker` | sur-titre court au-dessus d'une accroche | petites majuscules grises |
| `.data-strip` + `.data-field` (`.name`/`.value`) | présenter les variables d'un jeu de données | bandeau de 5 cartes, noms en mono |
| `.journey` + `.journey-step` (`.num`/`.text`) | étapes, processus, cycle, rythme | rangée de cartes numérotées |
| `.metric-grid` + `.metric` (`.value`/`.label`) | 3 idées clés, « À retenir » | 3 cartes, gros chiffre rouge |
| `.concept-grid` + `.concept-card` (`.tag`/`.text`) | 2 concepts en parallèle | 2 cartes ; `.accent` = filet rouge |
| `.statement-grid` + `.statement-card` | phrases modèles | `.acceptable` (filet rouge) / `.warning` (filet or) |
| `.note-box` | nuance, règle, mise en garde | filet vert |
| `.example-box` | exemple concret | filet or |
| `.self-check` | auto-vérification de l'activité | encadré vert |
| `.keypoints` | courte liste de repères (à doser) | filet bleu |
| `.columns` + `.column` | comparaison côte à côte | deux colonnes |
| `.visual-note` | légende/remarque sous une figure | petit texte, filet or |

Syntaxe d'imbrication (exemple `.journey`) :

```markdown
::: {.journey}
::: {.journey-step}
::: {.num}
1
:::
::: {.text}
Identifier le problème
:::
:::
::: {.journey-step}
::: {.num}
2
:::
::: {.text}
Formuler le modèle
:::
:::
:::
```

Correspondances utiles :

- Liste de variables d'un CSV → `.data-strip` (et non un tableau brut).
- Étapes d'un processus / cycle → `.journey`.
- « phrase acceptable » vs « à éviter » → `.statement-grid` avec `.acceptable` et `.warning`.
- « ce n'est pas / c'est » → `.concept-grid`.

---

## 6. En-tête YAML standard

Tous les supports de capsule partagent le même en-tête (ne pas le modifier sans raison) :

```yaml
---
title: "Capsule N - Titre court"
subtitle: "MQT-2101 - Analyse et modélisation des données"
institute: "Faculté des sciences de l'administration - Université Laval"
lang: fr
format:
  revealjs:
    theme:
      - default
      - ../../../../assets/ulaval-reveal.scss
    width: 1600
    height: 900
    margin: 0.06
    center: false
    logo: ../../../../assets/logos/ulaval/UL-FSA-C-d.png
    slide-number: c/t
    controls: true
    progress: true
    hash: true
    transition: fade
    code-copy: true
    code-overflow: wrap
    embed-resources: true
execute:
  warning: false
  message: false
editor: visual
---
```

Le chemin relatif du thème et du logo (`../../../../`) suppose l'emplacement `modules/<module>/media/qmd/`. Le conserver.

---

## 7. Conventions de contenu

- **Accroche** : une décision réelle + une question directe.
- **Tout exemple** nomme : la ou les variables, l'unité d'observation, l'échelle.
- **Toujours une limite** d'interprétation à la fin d'un raisonnement.
- **Aucune conclusion causale** dans les capsules descriptives ; distinguer association et cause.
- **Code R** : montrer le **geste** essentiel (ex. `make_date()`, `factor()`), pas tout le détail technique. Le détail complet vit dans les démonstrations.
- **Chemins de données robustes** : dans les chunks, tester plusieurs chemins (`data/`, `../../data/`, chemin module) comme dans les capsules 5 et 6.
- **Liens vers les données** : utiliser la classe `.data-link` vers la page `donnees/`. Ne pas mettre une balise de lien comme **titre** de diapo (titre simple, lien dans le corps).
- **Deux publics** : viser, par module, au moins un exemple opérations/ingénierie et un exemple gestion/affaires.

---

## 8. Notes de narration (optionnel)

Le bloc `::: {.notes}` de Quarto/Revealjs permet d'écrire un script parlé visible seulement en mode présentateur (touche `S`), invisible à l'écran et dans le PDF.

Comme les capsules sont **enregistrées en vidéo**, ces notes ne sont **pas obligatoires** : la narration est portée par la voix. Elles restent utiles si on veut préparer un script avant de filmer. À utiliser librement, capsule par capsule, selon la préférence de l'enseignant.

Exemple :

```markdown
## Ma diapo

[contenu visible]

::: {.notes}
Texte que je dis à l'oral, non affiché.
:::
```

---

## 9. Durée

**Aucune durée imposée** sur les diapos ni dans les supports. Le rythme reste au jugement de l'enseignant lors de l'enregistrement.

---

## 10. Checklist d'acceptation d'une capsule

Une capsule respecte la charte si :

- [ ] elle traite **une idée maîtresse** claire ;
- [ ] la 2e diapo est une accroche **« Pourquoi ça compte »** concrète ;
- [ ] les objectifs tiennent en 3–4 puces ;
- [ ] **aucune diapo n'est une liste de phrases complètes** ; le texte long est passé à l'oral ;
- [ ] **aucune diapo n'est vide** : chaque diapo allégée porte un composant visuel ;
- [ ] les exemples nomment variables, unité et échelle ;
- [ ] il y a au moins **une limite d'interprétation** ;
- [ ] la capsule se termine par **À retenir** (3 cartes) puis **Production autonome** + auto-vérification ;
- [ ] les liens `.data-link` et les chunks R fonctionnent (chemins robustes) ;
- [ ] sur l'ensemble du module, les **deux publics** sont servis.
