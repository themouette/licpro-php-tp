TP0 : faire connaissance avec l'environnement
=============================================

Vous allez développer dans une **machine virtuelle** préconfigurée par via
[puppet](http://puppetlabs.com/).
Cette machine inclue tout le necessaire pour faire fonctionner vos TP et la
configuration est écrasée à chaque démarrage pour les programmes suivants :

* apache
* php
* mysql

La machine virtuelle
--------------------

Tout les TP se dérouleront dans une machine virtuelle headless, c'est à dire
sans interface graphique.
Cette machine est pilotée par [vagrant](http://www.vagrantup.com), un programme
en ruby qui abstrait la configuration et la manupulation de la machine.

Tout se passe comme si la machine virtuelle était un serveur accessible
uniquement en réseau, via un tunel `ssh`.

Votre machine redirige toutes les connexions entrantes sur le port `8080` vers
la machine virtuelle.
En activant dans la configuration `vagrant` l'interface réseau `:bridge`, vous
autorisez un accès direct de la machine virtuelle sur Internet.

![schema réseau de l'installation](../image/vm-network.png)

### Installer la machine virtuelle

Vous installerez la configuration de vagrant dans le répertoire
`/usr/local/licphp/vm-$USER`.
Dans la suite du document nous utilisons `DOCROOT` pour parler de ce chemin.

Pour faciliter la suite, vous êtes invité à définir une variable :

    $ DOCROOT="/usr/local/licphp/vm-$USER"
    $ export DOCROOT

Clonnons la configuration :

    $ git clone https://github.com/willdurand/licpro-php-vm --recursive DOCROOT
    $ cd DOCROOT

En listant le répertoire, vous devez avoir une sortie similaire :

    $ ls -alh

    drwxr-xr-x 4 julien julien 4.0K Jan  4 00:26 .
    drwxrwxr-x 7 julien julien 4.0K Jan  3 00:07 ..
    drwxrwxr-x 9 julien julien 4.0K Jan  3 00:08 .git
    -rw-rw-r-- 1 julien julien    9 Jan  3 00:08 .gitignore
    -rw-rw-r-- 1 julien julien  813 Jan  3 00:08 .gitmodules
    drwxrwxr-x 4 julien julien 4.0K Jan  3 00:08 puppet
    drwxrwxr-x 4 julien julien 4.0K Jan  3 00:08 projects
    -rw-rw-r-- 1 julien julien  905 Jan  3 00:08 README.md
    -rw-rw-r-- 1 julien julien   61 Jan  4 00:26 .vagrant
    -rw-rw-r-- 1 julien julien 4.6K Jan  4 00:34 Vagrantfile

La configuration est située dans le fichier `Vagrantfile` et la recette
d'installation du serveur est située dans le dossier `puppet`.

### Démarrer la machine virtuelle

    DOCROOT $ vagrant up

### Eteindre la machine virtuelle

    DOCROOT $ vagrant halt

### Vérifier que tout fonctionne

rendez-vous dans un navigateur à l'adresse `http://localhost:8080`.
Vous devriez voir apparaître un message de bienvenue.

### Dossier partagé

Un dossier est partagé en `nfs` entre votre machine et la machine virtuelle.
Tous les fichiers que vous éditez dans ce répertoire seront également modifiés
dans la machine virtuelle.

    Votre machine        ~>    Machine virtuelle
    DOCROOT/projects     ~>    /var/www/

_info_ : ce partage est configuré dans le fichier `Vagrantfile`.

Pour vérifier que tout fonctionne, ajoutez votre nom dans le fichier
`DOCROOT/projects/index.html` pour vous féliciter personnellement, enregistrez
puis rafraichissez le navigateur. Si vos modifications apparaissent, tout
fonctionne normalement.

### Accès ssh

    $ vagrant ssh

Une fois dans la machine virtuelle, vous pouvez prendre les droits root via
`sudo`.

Installer à la maison
---------------------

Vous aurez besoin de [`git`](http://git-scm.com/), de `ruby` et de [`vagrant`](http://docs.vagrantup.com).
Pour les systèmes basés sur debian :

    $ aptitude install ruby vagrant git

Pour les système OSX, reportez vous à la [documentation](http://docs.vagrantup.com).

Les autres, une installation windows existe, mais vous êtes encouragés à
installer un dual boot.

### Télécharger l'image de base :

    $ vagrant box add lucid32 http://files.vagrantup.com/lucid32.box

### Installer la [configuration](https://github.com/willdurand/licpro-php-vm) :

    $ mkdir ~/vagrant ; cd ~/vagrant
    ~/vagrant $ git clone https://github.com/willdurand/licpro-php-vm.git --recursive

### Installer la clé ssh :

Vous pouvez commenter la ligne #16 dans le Vagrantfile :

    config.ssh.private_key_path = "~/.ssh/insecure_private_key"

ou alors installer la clé

    $ wget https://raw.github.com/mitchellh/vagrant/master/keys/vagrant -O ~/.ssh/insecure_private_key
    $ chmod 400 ~/.ssh/insecure_private_key

### Ajouter l'accès à internet (nécessaire pour l'installation)

Il vous suffit de décommeter la ligne #33 `config.vm.network :bridged`

### Premier démarrage :

    $ cd ~/vagrant/licpro
    ~/vagrant/licpro $ vagrant up

Git
---

`git` est un gestionnaire de version distribué massivement utilisé dans le
monde opensource grâce notament à github.

La [Documentation](http://git-scm.com/book) est bien
faite et très progressive. Il est possible de la télécharger en pdf :
[pro git pdf](https://github.s3.amazonaws.com/media/progit.en.pdf)

En bonus track, voici mon [`.gitconfig`](https://github.com/themouette/puppet-me/blob/master/me/templates/dotfiles/gitconfig.erb)
à placer dans votre home en remplacant les lignes #2 et #3.

Les commande principales pour débuter sont :

    $ git init       # initialize un nouveau dépôt dans le répertoire courant
    $ git status     # affiche l'état du répertoire de travail
    $ git add file   # ajoute file à la staging area
    $ git commit     # empile la staging area dans le dépôt
                     # vous entrez votre message de commit dans vi

Vous êtes invité à utiliser git pour maintenir la cohérence entre votre
environnement personnel et celui du laboratoire.
Vous pouvez héberger vos dépôts publiquement sur github.com ou de manière
privée sur bitbucket.org.

Guide de survie avec Vi
-----------------------

Sur un serveur, il n'est pas rare de devoir éditer des fichiers. Sans interface
graphique, le nombre d'éditeurs est limité, mais il y aura toujours vi.

Voici quelques commandes de bases :

* `i` : passer en mode insertion
* `esc` : passer en mode commande (les commandes commencent par `:`)
* `:w` : écrit le buffer courant
* `:q` : ferme le buffer actif (quitte vi)
* `:wq` : ecrit et ferme le buffer courant
* `:tabnew file` : ouvre file dans un nouveau buffer
* `gt` : passer au buffer suivant
* `gT` : passer au buffer précédent
* `:30` : aller à la ligne 30
* `:s:regex:replacement:` : chercher remplacer
* `dXd` : coupe X lignes
* `yXy` : copie X lignes
* `p` : coller

Un [guide plus complet](http://www.worldtimzone.com/res/vi.html) est disponible
mais le mieux reste de faire le tutoriel, pour celà tapez `vimtutor` dans un
terminal.

Php
---

### L'interpréteur interactif

Sur la machine virtuelle, pour lancer un interpréteur interactif, utilisez la
commande :

    $ php -a

Vous pouvez alors exécuter des commandes directement à partir de cette
interface.
C'est très utile pour vérifier le résultat d'une commande lorsque vous avez un
doute.

Pour quitter le mode insteractif, utilisez :

    php > exit

ou `<Ctrl>+C`.

### Configuration

La configuration de php se trouve dans `/etc/php5`.
Il y a la configuration pour le mode cli et la configuration pour apache.

Apache
------

Apache est un serveur web permettant de servir des fichiers soit directement,
soit en exécutant des programmes externes.

Le serveur écoute sur le port 80 et répond en fonction de la configuration que
vous avez fait.

### Configuration

La configuration se trouve dans le répertoire `/etc/apache2/` et est organisée
comme suit :

* `/etc/apache2/sites-available` contient les sites configurés
* `/etc/apache2/sites-enabled` contient des liens symboliques vers les sites
    disponibles. Ce sont les sites actifs
* `/etc/apache2/conf.d` contient la configuration de base et des modules

### Commandes de base

Le service `apache2` se commande via `apache2ctl`:

    $ sudo apache2ctl start
    $ sudo apache2ctl stop
    $ sudo apache2ctl restart
    $ sudo apache2ctl status

Pour gérer les sites actifs, utiliser `a2ensite` et `a2dissite`

    $ sudo a2ensite tp1
    $ sudo apache2ctl restart

### Créer un alias

Pour chaque TP, nous allons créer un alias apache.

Entrer dans la machine virtuelle :

    $ vagrant ssh

Créer un fichier de configuration :

    $ sudo vim /etc/apache2/sites-available/tp1

En vous aidant du guide de survie, configurer l'alias comme suit :

    Alias /tp1 /var/www/tp1

Enregistrer, quitter puis activer le nouveau site :

    $ sudo a2ensite tp1

puis redémarrer apache.

Vous accédez désormais au contenu de `/var/www/tp1` via l'url
`http://localhost:8080/tp1`
