Projet de fin de module PHP
===========================

Préambule - Modalités
---------------------

Le projet est à rendre par mail le 17 février à 23h59 dernier délai. La
pénalité de retard se comptera à la minute près !

Les formats acceptés sont :

* une archive (`tar`, `tgz` ou `zip`) ;
* **ou** un dépôt distant (`git`, `svn`, etc.).

Le projet doit être accompagné des instructions de mise en route. Ainsi que
d'un bilan rapide de ce qui a été fait/pas fait. Le format pour ce fichier doit
être **textuel**, donc `txt` ou `markdown`. Nous ne pouvons pas ouvrir les
fichiers Word ou Open Office.

Ce bilan n'est pas un compte rendu formel, vous pouvez simplement énumérer ce
qui a été fait et ce qui n'a pas été fait, en faisant des phrases courtes. Il
devrait tenir sur une page, et c'est un fichier **obligatoire**.

Aucun retard ou problème technique ne sera toléré, c'est pourquoi il est
fortement conseillé de mettre également à disposition un lien de téléchargement
direct sur un service en ligne (dropbox, ubuntu one, google drive, etc.).

Si votre archive est corrompue, vous serez défaillant, faites en sorte d'envoyer
quelque chose de correct. Nous vérifierons ce point à chaque réception d'un
projet. Si votre archive est corrompue, nous vous l'indiquerons et vous aurez
avant 23h59 pour renvoyer une archive valide.

Vous devez nommer l'archive comme suit : `projet_<nom 1>_<nom 2>.zip`. Le mail
doit comporter la mention `[PROJET PHP]` dans le sujet du mail.


Sujet
-----

En tant que roi des soirées étudiantes, vous êtes la référence en matière de
lieux branchés. Désireux de surfer sur cette vague et fatigué d'être sans arrêt
harcelé pour connaitre vos derniers bons plans, vous décidez de mettre en ligne
un outil pour partager vos trouvailles.

Social et collaboratif, votre nouvel outil va cartonner, vous en êtes certain,
mais avant de se lancer tête dans le guidon, regardons d'un peu plus près ce à
quoi cela va ressembler. Votre projet se décompose en plusieurs parties :

* Une aplication permet d'administrer le site, nous l'appellerons le _Backend_,
  cette application est protégée par mot de passe et seul les _administrateurs_
  pourront y accéder ;
* Le site, que nous appellerons l'application _Frontend_, est accessible à tout
  le monde.

Ce projet permet de gérer trois types d'information :

* Un **lieu** comporte au minimum un nom et une adresse. Il est possible qu'un
  lieu ait un texte de présentation et un numéro de téléphone ;
* Une **soirée** comporte au minimum un horaire et peut comporter un message
  personnalisé ;
* Un **commentaire** comporte au minium un nom de la personne qui a écrit le
  commentaire et le message ;
* Un **lieu** peut avoir plusieurs **commentaires** ;
* Un **lieu** peut avoir plusieurs **soirées**.

Tous les "éléments" sont identifiés par un identifiant unique.

**Important :** l'absence de design ne sera pas pénalisant, il est conseillé de
ne pas s'éterniser sur cette partie. L'important est d'avoir une application
fonctionnelle.


### Application Frontend

L'application _Frontend_ est l'application "publique", au sens où tout le monde
peut y accéder librement.


#### RQF1 : La page d'accueil liste les prochaines soirées et les 5 derniers lieux ajoutés

En tant qu'utilisateur du site, dans le but d'être informé directement et
rapidement, je peux accéder à la page principale du site (accueil), sur laquelle
je peux voir toutes les prochaines soirées ainsi que les 5 derniers lieux
ajoutés.

#### RQF2 : La page d'accueil présente un lien vers la liste des lieux

En tant qu'utilisateur du site, dans le but de voir tous les lieux du site,  je
dispose d'un bouton "Voir tous les lieux" (ou d'un lien) permettant d'accéder à
la liste de tous les lieux enregistrés sur le site.

#### RQF3 : La page d'accueil présente un lien vers la liste des soirées

En tant qu'utilisateur du site, dans le but de voir toutes les soirées, je
dispose d'un bouton "Voir toutes les soirées" (ou d'un lien) permettant
d'accéder à la liste de toutes les soirées enregistrées sur le site.

#### RQF4 : A partir de la liste des lieux, il est possible de proposer un nouveau lieu

En tant qu'utilisateur, dans le but de partager un bon plan, je peux créer un
nouveau lieu à l'aide d'un formulaire. Ce lieu sera automatiquement ajouté et
visible sur le site.

#### RQF5 : A partir de la liste des lieux, il est possible d'afficher la page dédiée à un lieu en cliquant sur son nom dans la liste

En tant qu'utilisateur, dans le but d'obtenir plus d'informations sur un lieu
précis, je peux accéder à une page contenant les détails de ce lieu, ceci à
partir de la "Liste des lieux". Cette page de détail est unique pour un lieu
donné.

#### RQF6 : Sur la page de détail d'un lieu, les listes des commentaires et des soirées de ce lieu sont affichées

En tant qu'utilisateur, en naviguant sur la "Page de détail" d'un lieu, je peux
voir les listes des commentaires et des soirées pour ce lieu.

#### RQF7 : Sur la page de détail d'un lieu il est possible d'ajouter un commentaire sur ce lieu

En tant qu'utilisateur, dans le but de donner mon avis sur un lieu, je dispose
d'un formulaire me permettant de soumettre un nouveau commentaire. Ce
commentaire est directement visible.

Idéalement, je ne dois pas changer de page pendant cette étape.

#### RQF8 : Sur la page de détail d'un lieu il est possible d'ajouter une soirée à venir

En tant qu'utilisateur, dans le but d'informer les autres utilisateurs d'une
nouvelle soirée, je dispose d'un formulaire me permettant de soumettre une
nouvelle soirée à venir, dans ce lieu donné.

Idéalement, je ne dois pas changer de page pendant cette étape.

#### RQF9 : Sur la page de détail d'un lieu les informations relatives à ce lieu sont affichées

En tant qu'utilisateur, dans le but d'être informé, je dois pouvoir lire toutes
les informations relatives à un lieu donné, sur sa "Page de détail".

#### RQF10 : Mise en place d'une API REST, exposant les données en JSON

En tant que développeur mobile, dans le but de créer une application mobile
(Android ou iOS), je peux accéder aux mêmes fonctionnalités de l'application
_Frontend_ grâce à une API RESTful, utilisant le format de données JSON.

Idéalement, les URIs utilisées pour les fonctions décrites ci-avant restent les
mêmes, et tout est basé sur le principe de Content Negotiation.


### Application Backend

L'application _Backend_ permet d'administrer le site. Cette partie est entièrement
protégée, et accessible uniquement par des administrateurs.

#### RQB1 : Toutes les pages de l'application sont protégées par mot de passe

En tant qu'utilisateur, je ne peux pas accéder à l'application _Backend_.

#### RQB2 : Une fois authentifié, un administrateur peut naviguer sans se reconnecter à chaque page

En tant qu'administrateur, dans le but d'administrer l'application, je peux
accéder à une page de connexion, me demandant un nom d'utilisateur et un mot de
passe. Une fois authentifié, je peux accéder librement à l'ensemble de
l'application _Backend_.

#### RQB3 : Il est possible de se déconnecter

En tant qu'administrateur connecté à l'application _Backend_, j'ai accès à un
bouton "Logout" (ou "Déconnexion") me permettant de me déconnecter de cette
application _Backend_.

Une fois déconnecté, je ne peux plus accéder aux pages protégées de
l'application _Backend_.

#### RQB4 : Il est possible de modifier ou supprimer des lieux

En tant qu'administrateur, dans le but de gérer des lieux, je dispose
d'une vue "Liste des lieux", me permettant de visualiser l'ensemble des
lieux de l'application.

En tant qu'administrateur, dans le but de gérer des lieux, je dispose
d'un bouton pour chaque lieu, me permettant de le supprimer.
Eventuellement, un message d'information m'indique que le lieu a bien été
supprimé. Ce message doit apparaître au niveau de la "Liste des lieux".

En tant qu'administrateur, dans le but de gérer les lieux, je dispose
d'un bouton pour chaque lieu, me permettant de le modifier. Ce bouton
m'amène sur une page d'édition du lieu. Je peux :

* annuler mon opération en cliquant sur un bouton "Annuler", ce qui me ramène
  à la liste des lieux ;
* sauvegarder les modifications que j'ai apporté au lieu. Une fois ces
  modifications sauvegardées, je suis ramené à la liste des lieux.

Eventuellement, un message d'information s'affiche une fois le lieu mis à
jour. Ce message doit s'afficher sur la page "Liste des lieux".


Améliorations Possibles
-----------------------

Ces améliorations vous permettront de gagner plus de points. Il est fortement
conseillé d'implémenter **une** amélioration au moins. Vous pouvez également en
proposer d'autres. Enfin, vous ne perdrez pas de points sur l'implémentation de
ces améliorations.

### Application Backend

#### Il est possible de modifier ou supprimer des soirées

En tant qu'administrateur, dans le but de gérer des soirées, je dispose
d'une vue "Liste des soirées", me permettant de visualiser l'ensemble des
soirées de l'application.

En tant qu'administrateur, dans le but de gérer des soirées, je dispose
d'un bouton pour chaque soirée, me permettant de le supprimer.
Eventuellement, un message d'information m'indique que le soirée a bien été
supprimé. Ce message doit apparaître au niveau de la "Liste des soirées".

En tant qu'administrateur, dans le but de gérer les soirées, je dispose
d'un bouton pour chaque soirée, me permettant de le modifier. Ce bouton
m'amène sur une page d'édition du soirée. Je peux :

* annuler mon opération en cliquant sur un bouton "Annuler", ce qui me ramène
  à la liste des soirées ;
* sauvegarder les modifications que j'ai apporté au soirée. Une fois ces
  modifications sauvegardées, je suis ramené à la liste des soirées.

Eventuellement, un message d'information s'affiche une fois le soirée mis à
jour. Ce message doit s'afficher sur la page "Liste des soirées".

#### Il est possible de modifier ou supprimer des commentaires

En tant qu'administrateur, dans le but de gérer les commentaires, je dispose
d'une vue "Liste des commentaires", me permettant de visualiser l'ensemble des
commentaires de l'application.

En tant qu'administrateur, dans le but de gérer les commentaires, je dispose
d'un bouton pour chaque commentaire, me permettant de le supprimer.
Eventuellement, un message d'information m'indique que le commentaire a bien été
supprimé. Ce message doit apparaître au niveau de la "Liste des commentaires".

En tant qu'administrateur, dans le but de gérer les commentaires, je dispose
d'un bouton pour chaque commentaire, me permettant de le modifier. Ce bouton
m'amène sur une page d'édition du commentaire. Je peux :

* annuler mon opération en cliquant sur un bouton "Annuler", ce qui me ramène à
  la liste des commentaires ;
* sauvegarder les modifications que j'ai apporté au commentaire. Une fois ces
  modifications sauvegardées, je suis ramené à la liste des commentaires.

Eventuellement, un message d'information s'affiche une fois le commentaire mis à
jour. Ce message doit s'afficher sur la page "Liste des commentaires".

#### Il est possible d'utiliser des filtres dans les listes

En tant qu'administrateur, dans le but de trouver rapidement un commentaire, je
dispose de filtres permettant de réduire la "Liste des commentaires". Un filtre
réduit généralement le nombre de résultats.

La "Liste des commentaires" est potentiellement très longue. Dans le but
d'améliorer l'expérience utilisateur, la "Liste des commentaires" pourrait être
paginée. La pagination permet de séparer l'ensemble des commentaires en
plusieurs pages.

Ces deux améliorations peuvent être également faites sur la "Liste des soirées"
et la "Liste des lieux".


### Application Frontend

#### SPAM Assassin

Dans le but d'éviter le SPAM, les lieux, soirées et commentaires ne sont pas
directement publiés sur le site. Ils sont en statut "en attente de modération".
Un administrateur peut, dans l'application _Backend_, les valider ou les rejeter.

#### Géolocalisation

Dans le but d'afficher la position exacte d'un lieu, l'application peut
automatiquement géocoder l'adresse saisie par l'utilisateur. Géocoder une
adresse signifie récupérer ses coordonnées géographiques (latitude, longitude)
via un service web.
Grâce à ces coordonnées, il devient possible d'afficher une carte sur la "Page
de détail" d'un lieu.


Outils Utiles
-------------

### Bibliothèques

Vous pouvez vous servir de bibliothèques existantes, faites un tour sur
[Packagist](http://packagist.org).

### Frameworks

Vous pouvez réutiliser votre travail réalisé pendant les TPs.

Vous pouvez égalment en prendre un de la liste, un autre, ou aucun, c'est à vous
de choisir !

* [Silex](http://silex.sensiolabs.org/)
* [Slim](http://www.slimframework.com/)
* [Symfony2](http://symfony.com/)

### Géolocalisation

* [Geocoder](http://geocoder-php.org/)

### Design

* [Twitter Bootstrap](http://twitter.github.com/bootstrap/)
* [Zurb Foundation](http://foundation.zurb.com/)
* [Maxmertkit](http://maxmert.com/)
