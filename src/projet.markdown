Projet de fin de module PHP
===========================

Préambule - modalités
---------------------

Le projet est à rendre par mail le XXX février à 23h59 dernier délais.
Les formats acceptés sont une archive (tar, tgz ou zip) ou un dépôt distant
(git, svn...) accompagné des instructions de mise en route.

Aucun retard ou problème technique ne sera toléré, c'est pourquoi il est
fortement conseillé de mettre également à disposition un lien de téléchargement
direct sur un service en ligne (dropbox, ubuntu one, google drive...).

Sujet
-----

En tant que roi des soirées étudiantes, vous êtes la référence en matière de
lieux branchés. Désireux de surfer sur cette vague et fatigué d'être sans arrêt
harcelé pour connaitre vos derniers bons plans, vous décidez de mettre en ligne
un outil pour partager vos trouvailles et commentaires.

Social et collaboratif, votre nouvel outil va cartonner, vous en êtes certain,
mais avant de se lancer tête dans le guidon, regardons d'un peu plus près ce à
quoi il va ressembler :

* Une aplication permet d'administrer le site, nous l'appellerons le `backend`.
    cette application est protégée par mot de passe.
* Le site, que nous appelleront l'application `frontend`, est accessible à tout
    le monde.
* Un lieux comporte au minimum un nom et une adresse. Il est possible qu'un
    lieu ait un texte de présentation et un numéro de téléphone.
* Une annimation comporte au minimum un horaire et peut comporter un message
    personnaliser.


### Application Backend

**RQB1** : toutes les pages de l'application sont protégées par mot de passe.

**RQB2** : une fois authentifié, un administrateur peut naviguer sans se
reconnecter à chaque page.

**RQB3** : Il est possible de se déconnecter.

**RQB4** : Il est possible de modifier ou supprimer des commentaires.

**RQB5** : Il est possible de modifier ou supprimer des lieux.

**RQB6** : Il est possible de modifier ou supprimer des annimations.

### Application Frontend

**RQF1** : la page d'accueil liste les prochaines soirées et les derniers
lieux ajoutés

**RQF2** : la page d'acceuil présente un lien vers la liste des lieux.

**RQF3** : la page d'acceuil présente un lien vers la liste des annimations
à venir.

**RQF4** : à partir de la liste des lieux, il est possible de proposer un
nouveau lieux.

**RQF5** : à partir de la liste des lieux, il est possible d'afficher la page
dédiée à un lieu en cliquant sur son nom dans la liste.

**RQF6** : sur la page de détail d'un lieux, les listes des commentaires et des
annimations de ce lieux sont affichées.

**RQF7** : sur la page de détail d'un lieu il est possible d'ajouter un
commentaire sur ce lieu.

**RQF8** : sur la page de détail d'un lieu il est possible d'ajouter une
annimation à venir.

**RQF9** : sur la page de détail d'un lieu les informations relatives à ce lieu
sont affichées. Les coordonnées peuvent être utilisées pour afficher une carte
ou sont affiches directement.

**RQF10** : un ami à vous dit faire une application mobile reprenant les mêmes
principes, vous mettez donc à sa dispoition une API JSON.

Pistes d'amélioration
---------------------


Outils utiles
-------------

### design

* [twitter bootstrap](http://twitter.github.com/bootstrap/)
* [zurb foundation](http://foundation.zurb.com/)
* [maxmertkit](http://maxmert.com/)

### Géolocalisation

* [geocoder](http://geocoder-php.org/)

### Frameworks

Vous pouvez en prendre un de la liste, un autre, ou aucun, c'est à vous de choisir !

* [code igniter](http://codeigniter.fr/user_guide/index.html)
* [eden](http://www.eden-php.com/documentation/mvc)
* [silex](http://silex.sensiolabs.org/)
* [slim](http://www.slimframework.com/)
* [symfony2](http://symfony.com/)
* [zend framework](http://framework.zend.com/)
