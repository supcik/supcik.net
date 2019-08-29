---
title: "Les Commits Conventionnels (ou Commits Sémantiques)"
date: 2019-08-29T08:24:23.941Z
draft: false
---

{{% bbox class="has-background-white-ter" %}}

_(This article is only available in French / cet article n'est disponible qu'en français)_

{{% /bbox %}}

Aujourd'hui, rare sont les développeurs qui remettent en cause l'utilisation d'un
logiciel de gestion des versions tel que «[git](https://git-scm.com/)» et pour la plupart, c'en est même
devenu ou outil indispensable qu'ils utilisent tous les jours.

La tâche principale d'un logiciel de gestion des versions est de gérer plusieurs versions des
fichiers qui composent un projet informatique (ou autre). Pour cela, le développeur effectue
régulièrement des _commits_ qui permettent de figer l'état des fichiers à un instant donné.
Plus tard, le développeur pourra revenir à un état précédent ou consulter les modifications
qui ont été faites entre deux _commits_. A chaque _commit_ le développeur **doit** associer
un texte qui décrit les changements faits depuis le _commit_ précédent et c'est là que
la créativité des développeurs est souvent mise à mal.

L'illustration suivante, publiée sur [xkcd](https://xkcd.com/1296/) illustre de manière
amusante comment évoluent ces messages:

![git commits](git_commit.png)

Ces messages sont cependant importants pour comprendre comment le code évolue et aussi
pour les autres développeurs qui essayent de comprendre ce qui a changé dans un logiciel.

Déjà en 2008, Tim Pope, sur son blog [tbaggery](https://tbaggery.com/), écrivait un [article qui
expliquait comment rédiger de bons messages](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html).
Plus tard, le forum [365GIT](https://365git.tumblr.com) publiait lui aussi un [article sur le sujet](https://365git.tumblr.com/post/3308646748/writing-git-commit-messages).
En 2012, le projet [erlang/OTP](https://github.com/erlang/otp) donnait lui aussi des [directives
concernant la rédaction des messages](https://github.com/erlang/otp/wiki/writing-good-commit-messages) et 
en 2014, Chris Beam adressait également ce problème sur [son blog](https://chris.beams.io/posts/git-commit/)

Ces conseils sont encore en partie valables, mais parallèlement à ces publications, une nouvelle
«bonne pratique», encore plus précise, commençait à être adoptée, il s'agit des [Commits Conventionnels](https://www.conventionalcommits.org/fr/). Le premier document que j'ai trouvé qui mentionne cette convention est
le [AngularJS Git Commit Message Conventions](https://docs.google.com/document/d/1QrDFcIiPjSLDn3EL15IJygNPiHORgU1_OOAqWjiDU5Y)
publié en 2011 et repris en 2015 sur le dépôt git de Angular avec le titre [Angular Commit Message Guidelines](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#commit).
Ce document reste d'ailleurs souvent cité comme modèle pour les commits conventionnels et à inciter des projets
tels que [Karma](https://karma-runner.github.io) à [adopter les mêmes conventions](http://karma-runner.github.io/0.10/dev/git-commit-msg.html).

La technique des commits conventionnels est parfois aussi appelé commits sémantiques, ce qui nous fait penser
à la [gestion sémantique de version](https://semver.org/lang/fr/) et nous verrons que ces concepts sont en effet lié.
Le terme «semantic commit» à été utilise par Jeremy Mack dans un [article publié sur Sparkbox](https://seesparkbox.com/foundry/semantic_commit_messages).

Voici à quoi ressemble un [message](https://github.com/angular/angular/commit/5da5ca5c236afefb0a985c3cda242fab1fa7b038) qui suit la convention des commits conventionnels

```
fix(bazel): pin `@microsoft/api-extractor` (#32187)

The API of `@microsoft/api-extractor` changed in a minor version which
is causes an error when using dts flattening downstream.

API wil be updated on master #32185

PR Close #32187
```
<br/>

On reconnait la structure suivante:

```
<type>[optional scope]: <description>

[optional body]

[optional footer]
```
<br/>

Voici les «types» les plus couramment utilisés:

Type     | Signification / utilisation
---------|----------------------------
feat     | Introduction d'une nouvelle _feature_ (fonctionnalité)
fix      | Correction d'une erreur (_bug_)
docs     | Modification de la documentation uniquement
style    | Changement qui n'affecte pas la signification du code (espace, formatage, points-virgules manquants, etc.)
refactor | Changement de code qui ne corrige pas d'erreur et n'ajoute pas de fonctionnalité
perf     | Changement de code qui améliore les performances
test     | Ajout de tests manquants ou correction des tests existants
revert   | Annule un commit précédent. Le message commencer par «revert:» : suivi du message du commit à annuler
build    | Changement qui affectent le système de compilation ou les dépendances externes
ci       | Modification des fichiers de configuration d'intégration continue (CI)
chore    | Changement des scripts de construction du logiciel uniquement (pas de changement du code de l'application)

En lien avec les commits conventionnels, une autre approche moderne consiste à remplacer
le type du changement par un emoji.
Voici quelques références qui vous permettront d'en savoir plus et qui devraient vous
permettre de savoir si cette approche vous convient:

- [Commit Message Emoji](https://github.com/dannyfritz/commit-message-emoji)
- [Gitmoji](https://gitmoji.carloscuesta.me/)
- [Emoji-Log: A new way to write Git commit messages](https://opensource.com/article/19/2/emoji-log-git-commit-messages)


Comme mentionné plus haut, il existe des parallèles entre les commits conventionnels et la gestion sémantique de version.
Pour rappel, un numéro de version qui suit la règle de gestion sémantique de version se compose de 3 parties principales :
un numéro de version **majeur** (major), un numéro de version **mineur** (minor) et un numéro de version de **correctif** (patch).
Le numéro de version de correctif est incrémenté quand il y a des corrections d’anomalies qui n'entrainent pas de problème
de compatibilité avec la version précédente. Le numéro de version mineur est incrémenté lorsqu'il y a des ajouts de fonctionnalités rétrocompatibles. Le numéro de version majeur est lui incrémenté quand il y a des changements **non rétrocompatibles** avec la version
précédente.

Pour faire le lien avec les commits conventionnels, un message de type **feat** est utlilsé pour introduire une
nouvelle fonctionnalité et implique donc l'incrément du numéro de version **mineur**. Les autres types (**fix**, **docs**, **style**, ...) n'apportent pas nouvelle fonctionnalité et impliquent l'incrément du numéro de version de **correctif**.
Pour incrémenter le numéro de version **majeur**, il faut un changement qui casse la compatibilité avec la version précédente.
Il n'y a pas type précis pour indiquer ce genre de changement et la solution est de mettre le texte **BREAKING CHANGE** (tout en majuscules) dans la description ou dans le corps du message. Voici un [exemple](https://github.com/angular/angular/commit/0cc77b4) pour un tel message:

```
refactor(compiler): split compiler and core (#18683)

After this, neither @angular/compiler nor @angular/comnpiler-cli depend
on @angular/core.

This add a duplication of some interfaces and enums which is stored
in @angular/compiler/src/core.ts

BREAKING CHANGE:
- `@angular/platform-server` now additionally depends on
  `@angular/platform-browser-dynamic` as a peer dependency.


PR Close #18683
```
<br/>

On trouve aujourd'hui des outils qui permettent de comprendre les commits conventionnels
et d'automatiser l'incrément de version et la production de «release» pour un logiciel.
Le premier outil s'appelle «semantic-release» et est décrit dans
[ce document](https://semantic-release.gitbook.io/semantic-release/). L'autre projet
est «[go-semrel-gitlab](https://juhani.gitlab.io/go-semrel-gitlab/)» et à été conçu
spécialement pour les programmes écrits en go.

J'espère que cet article vous permettra d'écrire de meilleurs messages. En tous cas,
moi je vais utiliser le plus possible ces conventions et également les nouveaux outils
de _semantic release_.

<br/>