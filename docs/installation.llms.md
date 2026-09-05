# Installation

# Installer R et RStudio, pas à pas

Commencez ici avant le module 2. Aucune expérience en programmation n'est nécessaire : suivez les quatre étapes, dans l'ordre, puis vérifiez les résultats indiqués.

[1. Installer les logiciels](#logiciels) [Déjà installés? Faire les tests](#console) [J'ai besoin d'aide](#depannage)

01

Installer R, puis RStudio

02

Obtenir le résultat 2

03

Ajouter les extensions du module

04

Ouvrir un premier document HTML

## Avant de commencer

Utilisez un ordinateur Windows ou Mac, connecté à Internet. Un iPad ou un téléphone permet de consulter les capsules, mais ne permet pas de suivre cette installation de RStudio Desktop.

R effectue les calculs. RStudio est la fenêtre dans laquelle vous travaillerez. Les deux logiciels sont gratuits; aucun compte ni abonnement n'est nécessaire pour les utiliser. Dans le module 2, les démonstrations se font dans RStudio.

Quarto sert à produire vos rapports. Il est déjà inclus dans les versions récentes de RStudio : nous le vérifierons à l'étape 4. Vous n'avez pas à télécharger le site du cours ni à configurer GitHub pour cette installation.

R et RStudio sont déjà installés? Commencez à l'étape 2. Si les tests réussissent, gardez votre installation actuelle.

## 1. Installer R, puis RStudio

Ouvrez uniquement les instructions correspondant à votre ordinateur. Télécharger un fichier ne suffit pas : il faut ensuite l'ouvrir pour installer le logiciel.

J'utilise Windows

Le téléchargement RStudio proposé ici est prévu pour Windows 11. Si votre ordinateur utilise Windows 10, Windows en mode S ou un autre système, consultez [l'aide pour votre ordinateur](#ordinateur-ancien) avant de poursuivre.

### Installer R

1.  Ouvrez la [page officielle de R pour Windows](https://cran.r-project.org/bin/windows/base/).
2.  Cliquez sur le lien « Download R-… for Windows », tout en haut de la page.
3.  Ouvrez le dossier Téléchargements de votre ordinateur, puis double-cliquez sur le fichier qui commence par `R-` et se termine par `.exe`.
4.  Suivez les fenêtres d'installation. Gardez les choix proposés et le dossier proposé, puis cliquez sur Terminer à la fin. Si Windows demande une autorisation d'installation, vérifiez qu'elle concerne bien le fichier R que vous venez de télécharger.

### Installer RStudio

1.  [Téléchargez RStudio Desktop gratuit pour Windows 11](https://download1.rstudio.org/electron/windows/RStudio-2026.08.2-200.exe).
2.  Dans Téléchargements, double-cliquez sur le fichier `RStudio-2026.08.2-200.exe`.
3.  Suivez les fenêtres d'installation, en gardant les choix proposés, jusqu'à la fin.
4.  Ouvrez le menu Démarrer, tapez `RStudio`, puis ouvrez l'application RStudio.

Vous devez voir la fenêtre RStudio, avec un onglet Console. Passez à l'étape 2 ci-dessous.

J'utilise un Mac

Les téléchargements proposés ici conviennent à macOS 14 (Sonoma) ou plus récent. Pour connaître votre version et votre type de Mac, cliquez sur le menu Pomme, en haut à gauche, puis sur À propos de ce Mac.

Si votre version de macOS est plus ancienne, consultez [l'aide pour votre ordinateur](#ordinateur-ancien) avant de poursuivre.

### Installer R

1.  Dans À propos de ce Mac, repérez la ligne Puce ou Processeur. Choisissez un seul des deux téléchargements ci-dessous.

[La ligne Puce indique Apple : télécharger R](https://cran.r-project.org/bin/macosx/sonoma-arm64/base/R-4.6.1-arm64.pkg) [La ligne Processeur indique Intel : télécharger R](https://cran.r-project.org/bin/macosx/big-sur-x86_64/base/R-4.6.1-x86_64.pkg)

2.  Dans le Finder, ouvrez Téléchargements, puis double-cliquez sur le fichier R qui se termine par `.pkg`.
3.  Suivez les fenêtres d'installation : Continuer, puis Installer. Gardez les choix proposés. Si macOS le demande, utilisez le mot de passe qui sert à ouvrir votre session sur ce Mac.
4.  Attendez le message de fin d'installation, puis fermez la fenêtre.

### Installer RStudio

1.  [Téléchargez RStudio Desktop gratuit pour Mac](https://download1.rstudio.org/electron/macos/RStudio-2026.08.2-200.dmg).
2.  Dans Téléchargements, double-cliquez sur `RStudio-2026.08.2-200.dmg`.
3.  Dans la fenêtre qui s'ouvre, faites glisser l'icône RStudio vers le dossier Applications.
4.  Dans le Finder, ouvrez Applications, puis double-cliquez sur RStudio. Si macOS demande de confirmer l'ouverture de l'application téléchargée, cliquez sur Ouvrir. Si une fenêtre propose d'installer Rosetta, suivez ses instructions.

Vous devez voir la fenêtre RStudio, avec un onglet Console. Passez à l'étape 2 ci-dessous.

Liens vérifiés le 5 septembre 2026 : R 4.6.1 et RStudio Desktop 2026.08.2. Les pages officielles de [R pour Mac](https://cran.r-project.org/bin/macosx/) et de [RStudio Desktop](https://docs.posit.co/ide/user/#direct-downloads-open-source) permettent de retrouver les téléchargements.

## 2. Faire votre premier calcul dans RStudio

À partir de maintenant, ouvrez RStudio pour travailler. L'application R peut rester fermée.

1.  Dans RStudio, cliquez sur l'onglet Console, généralement à gauche. Le signe `>` indique où écrire. Choisissez bien Console, et non Terminal.
2.  Cliquez après le signe `>`, tapez `1 + 1`, puis appuyez sur Entrée.

Ce que vous devez voir

    > 1 + 1
    [1] 2
    >

Le résultat est 2 et le signe `>` revient. R et RStudio communiquent correctement. Le `[1]` fait partie de l'affichage normal.

## 3. Ajouter les extensions nécessaires au module 2

Une extension, appelée « package » dans RStudio, ajoute des fonctions à R. Cette installation se fait une fois; elle peut prendre plusieurs minutes.

1.  Dans la barre de menus de RStudio, cliquez sur Tools, puis sur Install Packages…
2.  Dans Install from, gardez Package Repository (CRAN).
3.  Copiez les cinq noms ci-dessous avec le bouton Copier, puis collez-les dans le champ Packages. Sous Windows, le raccourci pour coller est Ctrl + V; sur Mac, c'est ⌘ + V.

Champ Packages

    tidyverse janitor lubridate scales rmarkdown

4.  Laissez Install dependencies coché et cliquez sur Install.
5.  Laissez RStudio travailler. Beaucoup de lignes vont défiler dans Console. Attendez que le signe `>` réapparaisse. Si R propose de créer une bibliothèque personnelle, acceptez : il s'agit du dossier de vos extensions.

Les quatre premiers packages servent aux analyses du module. Le package `rmarkdown` installe aussi les outils nécessaires pour exécuter le code R dans les rapports Quarto.

Vérifiez maintenant les quatre packages de la capsule 1 : cliquez sur Copier ci-dessous, collez le bloc dans Console, puis appuyez sur Entrée si nécessaire.

Console de RStudio

    library(tidyverse)
    library(janitor)
    library(lubridate)
    library(scales)

La console revient à `>` sans message « Error » ou « Erreur ». Des messages comme « Attaching packages » ou « Conflicts » peuvent apparaître : ils annoncent les fonctions chargées et ne signifient pas que l'installation a échoué.

À chaque nouvelle séance, les lignes `library(...)` chargent les extensions déjà installées. Il n'est pas nécessaire de refaire l'installation à chaque fois.

## 4. Vérifier Quarto avec un fichier prêt à ouvrir

Quarto est inclus dans les versions récentes de RStudio. Ce petit test produit une page HTML, c'est-à-dire un document qui s'ouvre dans un navigateur. Vous n'avez pas encore à écrire votre propre rapport.

1.  [Téléchargez le fichier test-installation.qmd](assets/exemples/test-installation.qmd). Il contient toutes les données de son exemple : aucun autre fichier n'est nécessaire.
2.  Dans RStudio, cliquez sur File, puis Open File… Choisissez `test-installation.qmd` dans Téléchargements et cliquez sur Open. Ouvrez-le depuis RStudio, même si votre ordinateur ne reconnaît pas l'icône du fichier.
3.  Le fichier s'ouvre dans un onglet. Cliquez sur Render, en haut du document. Si RStudio propose d'installer un package manquant, acceptez et attendez la fin de l'installation.
4.  Attendez l'ouverture de l'aperçu, dans RStudio ou dans votre navigateur.

Vous devez voir le titre « Mon installation fonctionne », le résultat 2, un tableau de trois mois et un graphique à trois points. Le fichier `test-installation.html` est créé à côté du fichier téléchargé.

Ce document sert uniquement à tester vos outils. Votre propre mini-rapport commencera à la capsule 3 et sera complété à la capsule 6.

## C'est terminé lorsque…

RStudio s'ouvre et `1 + 1` donne `2`.

Les quatre lignes `library(...)` fonctionnent sans erreur.

Le fichier de test affiche le résultat, le tableau et le graphique après un clic sur Render.

Les trois vérifications réussissent? Votre installation est prête pour commencer le module 2. Gardez le fichier de test pour pouvoir refaire cette vérification au besoin. Vous n'avez rien à remettre pour ce test.

[Commencer le module 2](modules/semaine-02-r-quarto/index.llms.md)

## Si une étape bloque

Ouvrez le cas qui correspond à ce que vous voyez. Si le problème persiste, demandez de l'aide avec les renseignements indiqués à la fin de cette page.

Mon ordinateur est ancien, géré par un employeur, ou ce n'est pas un Windows ou un Mac

Notez votre système et sa version. Sur Mac : menu Pomme, puis À propos de ce Mac. Sous Windows : Paramètres, puis Système, puis Informations système (ou À propos).

Si les tests des étapes 2 à 4 réussissent avec une installation existante, vous pouvez la garder. Sinon, contactez l'équipe enseignante avant de changer de système ou d'acheter du matériel. Précisez aussi si l'installation exige un mot de passe administrateur que vous n'avez pas.

Les versions récentes de RStudio ont des exigences précises. La [page de compatibilité de Posit](https://docs.posit.co/supported-versions/rstudio.html) servira à trouver une version adaptée avec vous. Si vous utilisez Linux, un Chromebook ou seulement une tablette, signalez-le également.

RStudio indique que R est introuvable

Vérifiez que vous avez bien ouvert le fichier d'installation de R et terminé son installation à l'étape 1. Quittez ensuite complètement RStudio, puis rouvrez-le. R et RStudio sont deux installations distinctes.

Je vois un signe + dans la console, ou ma commande ne donne rien

Un `+` en début de ligne signifie que R attend la suite d'une commande. Appuyez sur Échap pour retrouver `>`, puis recopiez la commande complète. Ne recopiez pas le signe `>`. Vérifiez aussi que vous êtes dans Console.

Je vois « there is no package called… » ou « aucun package nommé… »

L'extension indiquée manque. Reprenez Tools, puis Install Packages… à l'étape 3 et entrez son nom exact. Quand l'installation est terminée, relancez les quatre lignes `library(...)`, puis le test Quarto.

L'installation des packages demande une compilation ou affiche une erreur

Si R demande « Do you want to install from sources the packages which need compilation? », choisissez Non, ou tapez `n` puis Entrée. Pour commencer, utilisez les versions déjà préparées pour votre ordinateur. Si aucune version compatible n'est proposée ou si l'installation échoue, copiez le message complet pour demander de l'aide.

Un avertissement mentionnant Rtools ne suffit pas, à lui seul, à conclure que l'installation a échoué : vérifiez les lignes `library(...)` et le test Quarto. N'ajoutez pas d'autres outils au hasard.

Je ne trouve pas Render, ou Quarto ne démarre pas

Vérifiez le nom de l'onglet ouvert : il doit se terminer par `.qmd`. Le bouton Render se trouve au-dessus de ce document. Utilisez File, puis Open File… pour l'ouvrir à nouveau dans RStudio.

Si Quarto est explicitement signalé comme introuvable, quittez puis rouvrez RStudio. Si cela ne suffit pas, consultez l'équipe enseignante. Elle pourra vérifier votre version de RStudio ou vous accompagner avec [l'installation officielle de Quarto](https://quarto.org/docs/download/).

Si le rendu se termine mais qu'aucun aperçu n'apparaît, ouvrez `test-installation.html` dans Téléchargements avec votre navigateur.

### Pour demander de l'aide

Dans le forum du cours sur Brio, indiquez : votre système (Windows ou Mac et sa version), le numéro de l'étape qui bloque, le bouton utilisé et le message d'erreur complet. Une capture montrant la fenêtre concernée peut aider. Si vous ne connaissez pas un renseignement, dites-le simplement.

## Sources officielles

Consignes vérifiées le 5 septembre 2026 auprès du [projet R (Windows)](https://cran.r-project.org/bin/windows/base/), du [projet R (Mac)](https://cran.r-project.org/bin/macosx/), de [Posit (RStudio)](https://docs.posit.co/ide/user/) et d'[Apple (type de Mac)](https://support.apple.com/fr-ca/116943). L'inclusion de Quarto dans RStudio est décrite par [Posit](https://docs.posit.co/ide/user/ide/guide/documents/quarto-project.html#installing-quarto); les packages nécessaires au rendu R sont précisés dans la [documentation de Quarto](https://quarto.org/docs/computations/r.html#installation).
