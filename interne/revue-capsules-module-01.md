# Revue pédagogique - Module 1 « Introduction »

Revue des 6 supports de capsules vidéo (`media/qmd/capsule-0X-support.qmd`) en vue de l'enregistrement.
Critères : clarté pour la narration vidéo, force pédagogique, exactitude technique, engagement des deux publics (génie / administration).

Date : 19 juin 2026 · Statut du module : rédigé, non encore publié dans `_quarto.yml` au-delà des semaines 01–05.

---

## 1. Synthèse

Le module 1 est **solide sur le fond et très cohérent dans sa structure**. Chaque capsule suit le même squelette (Objectifs → contenu → À retenir → Production autonome → Auto-vérification), le fil « comprendre un tableau avant de modéliser » est clair, et la posture descriptive prudente (association ≠ causalité, échelle, exposition) est exactement la bonne pour une première semaine. Les vérifications techniques que j'ai faites sont conformes (voir section 5).

Le principal risque pour la **version vidéo** n'est pas le contenu mais la **densité** : les diapositives sont rédigées comme un document (phrases complètes en puces), ce qui pousse à lire la diapo à voix haute - le piège classique d'une capsule ennuyeuse. Les cinq priorités d'action ci-dessous règlent l'essentiel.

### Cinq priorités avant d'enregistrer

1. **Ajouter des notes de narration** (`::: {.notes}`) sous chaque diapo. C'est le levier nº 1 : tu prépares ton texte parlé une fois, et la diapo peut alors être allégée. Aujourd'hui aucune capsule n'a de notes.
2. **Alléger le texte à l'écran** : viser un titre + 3 à 5 ancres courtes par diapo, et déplacer les phrases complètes dans les notes. La parole porte la phrase, la diapo porte le repère visuel.
3. **Ouvrir chaque capsule par 10–15 s d'utilité concrète** (le principe « Let's eat the cake » des principes de refonte). Une décision réelle, un coût d'erreur - avant les objectifs abstraits.
4. **Dégonfler la capsule 1 et la capsule 2**, qui sont les deux plus chargées (voir détail). La 1 mélange orientation, évaluations, IA et traces ; la 2 empile une taxonomie théorique lourde.
5. **Indiquer une durée cible par capsule** (suggestions en section 6) pour cadrer le tournage et garder des capsules courtes « une idée ».

---

## 2. Constats transversaux (valables pour les 6 capsules)

**Densité / une idée par diapo.** Les principes de refonte demandent qu'une capsule « vise une seule idée importante ». Dans les faits, plusieurs capsules couvrent beaucoup de sous-thèmes. Ce n'est pas un défaut de contenu, mais un signal qu'il faut soit alléger chaque diapo, soit scinder (capsule 1 surtout).

**Diapo = script.** Beaucoup de puces sont des phrases complètes. À l'oral, on ne veut pas lire la diapo. Recommandation systématique : transformer chaque puce-phrase en 2–4 mots à l'écran + la phrase complète en `::: {.notes}`.

**Pas de notes de présentateur.** Aucun bloc `::: {.notes}` dans les 6 fichiers. Pour quelqu'un qui s'apprête à enregistrer, c'est le manque le plus coûteux. Revealjs/Quarto les affiche dans le mode présentateur (touche `S`) sans les montrer à l'écran.

**Accroche utilité.** Les capsules 1, 3, 4, 5 ouvrent sur « Objectifs de la capsule » (abstrait). La capsule 2 a une bonne accroche (« un calcul peut être exact tout en répondant à une mauvaise question ») - à généraliser. Une diapo « Pourquoi ça compte » concrète avant les objectifs augmente l'engagement.

**Deux publics.** Le module repose sur `birth_us.csv` (naissances US, neutre) et `safety_airlines.csv` (sécurité aérienne, plutôt génie/opérations). La capsule 2 réussit l'ancrage gestion (prévision de demande, stocks, succursales). Pour le reste, l'admin/ventes-marketing-finance est peu présent et les données ne sont pas québécoises (priorité nº 1 des principes de refonte). Piste légère : garder `birth_us` comme fil rouge technique, mais ajouter dans 2–3 capsules un mini-exemple parallèle d'affaires (ex. ventes quotidiennes d'une PME, file d'attente, taux de défaut) pour montrer que la même grille de lecture sert partout.

**Cohérence terminologique.** Bonne dans l'ensemble. Quelques termes apparaissent sans définition courte : « robuste » (médiane, capsule 5), « stochastique/déterministe » (capsule 2). Une incise de 5 mots suffit.

**Accessibilité narration.** Les `.metric-grid` qui affichent un gros chiffre (1, 2, 3) + un libellé sont excellents à l'écran et faciles à commenter. À conserver et à privilégier par rapport aux longues puces.

---

## 3. Revue capsule par capsule

### Capsule 1 - Organisation et fonctionnement du cours

**Forces.** Scaffolding clair ; les blocs 1–6 de la progression du cours en `.metric-grid` sont visuellement efficaces ; la double diapo « Ce que la trace n'est pas / est » est pédagogiquement très juste ; la politique IA est posée clairement (non permise aux examens, permise avec déclaration dans les mini-rapports).

**À améliorer.**
- **Surcharge.** ~16 diapos couvrant progression, rythme hebdo, rôle des activités, séance vs atelier, évaluations, IA, traces, usage du site, méthode de travail. C'est une capsule d'orientation, pas de statistique, et c'est la plus longue. Deux options : (a) la scinder en 1a « Comment fonctionne le cours » (progression, rythme, séance/atelier) et 1b « Évaluations, IA et traces » ; ou (b) la garder unique mais retirer 4–5 diapos redondantes (le contenu « traces » est répété sur 3 diapos + déjà détaillé dans `index.qmd` et `capsules.qmd`).
- **Vague assumé.** « quatre évaluations… les dates et modalités officielles doivent être vérifiées dans le plan de cours ». Correct, mais à l'écran ça affaiblit. Mieux : une diapo qui montre la structure (2 mini-rapports en équipe + intra + final) et renvoie au plan de cours en une ligne.
- **Narration.** Plusieurs diapos sont des listes de phrases (rythme d'une semaine, utiliser le site, méthode de travail). À condenser en mots-clés + notes.

**Action concrète.** Viser ≤ 10 diapos, ouvrir par « À quoi sert cette semaine pour toi » (1 décision concrète), déplacer les détails IA/évaluations vers les notes ou la page `index.qmd`.

---

### Capsule 2 - Modèles mathématiques et statistiques

**Forces.** Très bonne accroche conceptuelle (« un calcul exact peut répondre à une mauvaise question »). L'exemple « question floue vs question modélisable » sur les ventes par succursale est excellent et directement pertinent en gestion. Le rappel « un modèle ne prouve pas une cause » est bien placé.

**À améliorer.**
- **Taxonomie lourde.** « Trois formes de modèles » (iconique / analogique / symbolique) + « statique/dynamique » + « déterministe/stochastique » : c'est la typologie classique de recherche opérationnelle (style Anderson). À la semaine 1, pour ces publics, elle est abstraite et peu réutilisée par la suite. Suggestion : ne garder que la distinction **déterministe vs stochastique** (utile car elle introduit l'incertitude, cœur du cours) et déplacer iconique/analogique vers les lectures, ou en mention rapide d'une diapo.
- **Phases de modélisation.** La diapo numérote 3 phases (identifier, formuler, choisir une méthode) puis traite la validation sur une diapo séparée. La séquence paraît tronquée. Mieux : présenter un cycle complet et court - problème → modèle → résolution → **validation** → décision - sur une seule diapo, la validation étant une étape du cycle plutôt qu'un ajout.
- **Engagement génie.** L'exemple est gestion (stocks). Une variante d'une ligne côté opérations/ingénierie (ex. délai de production, taux de rebut) équilibrerait les deux publics.

**Action concrète.** Couper ~2 diapos de taxonomie, fusionner le cycle de modélisation, garder l'accroche forte en ouverture.

---

### Capsule 3 - Typologie des données

**Forces.** Claire et bien rythmée. L'idée centrale - « un code numérique n'est pas une quantité » illustrée par `day_of_week` (1 à 7) - est la bonne et bien amenée. Bon enchaînement vers la préparation (capsule 4).

**À améliorer.**
- **Titre de diapo en HTML brut.** Le titre `## <a class="data-link" href=...>birth_us.csv</a>` met une balise `<a>` comme titre de diapositive. C'est fragile au rendu reveal et difficile à narrer. Mieux : titre simple (« La base birth_us.csv ») et lien dans le corps.
- **Nominal vs ordinal absent.** La diapo « Variables catégorielles » dit « l'ordre des modalités peut être absent ou important » sans nommer **nominal / ordinal**. Or l'ordinal (échelles de satisfaction 1–5, niveaux de risque) est omniprésent en administration - c'est une occasion d'ancrage admin gratuite.
- **Discret vs continu.** `births` est un **dénombrement** (discret) ; le terme n'apparaît qu'en capsule 5. Une demi-ligne ici renforcerait la cohérence.

**Action concrète.** Renommer la diapo titre, nommer nominal/ordinal avec un exemple admin, mentionner discret/continu.

---

### Capsule 4 - Préparation des données

**Forces.** Très concrète et opérationnelle : tableaux avant/après, création d'une vraie date, recodage du jour, vérifications (manquants, codes impossibles, doublons, cohérence temporelle), et surtout l'insistance sur « documenter les transformations ». C'est l'une des meilleures capsules du lot.

**À améliorer.**
- **Densité de tableaux.** Beaucoup de tableaux successifs : à l'écran c'est beaucoup à lire. Garder, mais commenter chaque tableau à l'oral plutôt que le laisser parler seul (d'où l'intérêt des notes).
- **Aucun code R, alors que la transformation est trivialement montrable.** Les capsules 5 et 6 affichent du R (`make_date`, `factor`) ; ici on décrit conceptuellement ce que ce code fait, sans le montrer. Si le choix est « concept en 1–4, code en 5–6 et démonstrations », c'est défendable - mais ajoute alors une diapo de transition explicite : « le code de cette préparation est montré dans la démonstration 1 ». Sinon, une diapo avec le `mutate()` (make_date + factor) rendrait la capsule plus actionnable.
- **Lien causal week-end (occasion manquée).** La préparation de `jour_semaine` prépare directement le constat fort de la capsule 6 (chute des naissances le week-end). Une phrase de teasing (« ce recodage va nous servir à voir un écart frappant ») crée du fil narratif.

**Action concrète.** Ajouter la transition vers le code (ou une diapo de code), commenter les tableaux à l'oral, teaser le week-end.

---

### Capsule 5 - Exploration univariée

**Forces.** Vraie capsule appliquée : code R reproductible, tableau min/moy/méd/max, histogramme avec ligne de médiane. La grille min/moy/méd/max est nette. Distinction moyenne/médiane bien posée.

**À améliorer.**
- **La bimodalité de `births` est l'occasion en or, et elle est sous-exploitée.** L'histogramme des naissances quotidiennes est nettement **bimodal** : deux paquets (jours de semaine élevés, week-ends bas), confirmé par les données (samedi/dimanche ~8 000 vs semaine ~11 000). Or la diapo parle seulement de « valeurs inhabituelles ». C'est dommage : la forme à deux bosses est visible, intrigante, et **motive directement la capsule 6**. Recommandation forte : nommer explicitement la bimodalité, demander « pourquoi deux groupes ? », et annoncer qu'on l'explorera en comparant par jour.
- **Moyenne vs médiane à l'écran.** L'histogramme trace la médiane mais pas la moyenne. Ajouter une seconde ligne (moyenne) rendrait visible le point théorique de la diapo précédente.
- **« robuste »** introduit sans glose. Ajouter « (peu sensible aux valeurs extrêmes) ».

**Action concrète.** Exploiter la bimodalité comme accroche et pont vers la capsule 6 ; ajouter la ligne de moyenne ; gloser « robuste ».

---

### Capsule 6 - Comparer prudemment

**Forces.** Excellente capsule de clôture. Le boxplot `births` par `jour_semaine` paie le teasing de la 5 ; le passage nombre brut → taux ajusté à l'exposition (avec `safety_airlines`) est exactement la bonne leçon, et la distinction association/causalité est bien tenue. La double « phrase acceptable » de limite est un modèle utile pour les étudiant·es.

**À améliorer.**
- **Énoncer le constat du boxplot.** La diapo montre le graphique mais ne formule pas le résultat descriptif (« les week-ends ont des niveaux nettement plus bas »). Le donner en exemple - puis enchaîner sur « ce que ça ne prouve pas » - referme proprement la boucle bimodalité → comparaison.
- **Hypothèse de l'exposition à expliciter à l'oral.** `exposition = avail_seat_km_per_week * 52 * 15` applique un volume hebdomadaire ~récent à 15 ans (2000–2014). C'est une **approximation** (bien signalée par « approximée » dans le texte), mais à l'oral il vaut la peine de dire en une phrase *pourquoi* c'est approximatif, sinon un·e étudiant·e attentif·ve le prendra pour exact. La formule est par ailleurs cohérente (incidents 2000–2014 = 15 ans). Voir section 5.
- **Angle admin.** L'exemple « brut vs taux » se transpose parfaitement en gestion (plaintes par 1 000 clients, défauts par lot, ventes par employé). Une variante d'une ligne élargirait la portée au public admin.

**Action concrète.** Verbaliser le constat du boxplot, expliciter l'hypothèse d'exposition, ajouter une transposition d'affaires du ratio.

---

## 4. Tableau récapitulatif des actions

| Capsule | Forces | Action prioritaire |
|---|---|---|
| 1 - Organisation | Structure, blocs 1–6, « trace n'est pas / est » | Dégonfler (≤10 diapos) ou scinder 1a/1b |
| 2 - Modèles | Accroche « mauvaise question », ex. ventes | Couper la taxonomie OR ; fusionner le cycle de modélisation |
| 3 - Typologie | « un code n'est pas une quantité » | Nommer nominal/ordinal (ex. admin) ; corriger le titre HTML |
| 4 - Préparation | Avant/après, vérifications, documentation | Montrer/renvoyer au code R ; teaser le week-end |
| 5 - Univariée | Code, tableau, histogramme | Exploiter la bimodalité comme pont vers la 6 |
| 6 - Comparer | Brut vs taux, association ≠ cause | Énoncer le constat du boxplot ; expliciter l'exposition |
| **Toutes** | Cohérence, posture prudente | **Notes de narration + alléger le texte + accroche utilité** |

---

## 5. Vérifications techniques effectuées

**Codage `day_of_week` - CORRECT.** Le mapping de la capsule 4 (1 = lundi … 6 = samedi, 7 = dimanche) est conforme aux données. Contrôle : la 1re ligne de `birth_us.csv` est `1994-01-01`, codée `day_of_week = 6` ; le 1er janvier 1994 était bien un **samedi**. Les naissances y sont basses (8 096 le samedi, 7 772 le dimanche) contre ~10 000–11 000 en semaine - cohérent avec un effet week-end.

**Structure de `births` - bimodale.** Confirmée par les données (deux niveaux semaine/week-end). À exploiter pédagogiquement (capsule 5 → 6).

**Formule d'exposition (capsule 6) - cohérente, approximative et signalée.** `incidents_00_14` couvre 2000–2014, soit 15 ans ; `avail_seat_km_per_week * 52 * 15` estime donc le total de sièges-kilomètres sur la période. L'approximation (volume hebdomadaire ~récent appliqué à toute la période) est correctement présentée comme « exposition approximée » et le texte précise que le taux « ne résume pas tous les facteurs ». Aucune correction nécessaire ; seulement l'expliciter à l'oral.

**Robustesse des chemins de données.** Les chunks R des capsules 5 et 6 testent trois chemins (`data/`, `../../data/`, chemin module) - bon réflexe de reproductibilité.

**Note hors capsules.** Le README du module date `birth_us` comme naissances US ; les données commencent en 1994 (pas 2000–2014). Aucun texte de capsule ne fixe une plage pour `births`, donc pas de contradiction - mais à garder en tête si tu ajoutes une mention de période.

---

## 6. Suggestions de durée et de découpage pour l'enregistrement

À titre indicatif, pour des capsules « courtes, une idée » :

- **Capsule 1** - 6–8 min (ou 2 × 4 min si scindée). C'est de l'orientation : rester vif.
- **Capsule 2** - 6–7 min après allègement de la taxonomie.
- **Capsule 3** - 5–6 min.
- **Capsule 4** - 6–7 min (beaucoup de tableaux : commenter, ne pas lire).
- **Capsule 5** - 6–7 min (montrer le graphique se construire/se lire).
- **Capsule 6** - 7–8 min (deux exemples : boxplot + taux).

Astuce tournage : prépare d'abord les blocs `::: {.notes}` comme script, enregistre une capsule « pilote » (la 3, courte et autonome) pour caler ton débit et ton gabarit, puis applique le même format aux autres.

---

*Revue produite à partir des fichiers `capsule-01..06-support.qmd`, `capsules.qmd`, `index.qmd` et `interne/principes-refonte.qmd`. Aucune modification apportée aux supports : ce document est une revue avec recommandations.*
