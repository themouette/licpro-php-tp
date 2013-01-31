TP0 : Faire connaissance avec l'environnement
=============================================

Vous allez utiliser une **machine virtuelle** préconfigurée avec
[Puppet](http://puppetlabs.com/).
Cette machine inclut tout le necessaire pour faire fonctionner vos TPs et
comporte les programmes suivants :

* Apache2
* PHP
* MySQL


La machine virtuelle
--------------------

Tous les TPs se dérouleront dans une machine virtuelle _headless_, c'est à dire
sans interface graphique.
Cette machine est pilotée par [Vagrant](http://www.vagrantup.com), un programme
en ruby qui abstrait la configuration et la manipulation de la machine.

Tout se passe comme si la machine virtuelle était un serveur accessible
uniquement en réseau, via un tunnel `ssh`.

Votre machine redirige toutes les connexions entrantes sur le port `8080` vers
le port `80` de la machine virtuelle.

![schema réseau de l'installation](../images/vm-network.png)


### Installer la machine virtuelle

Vous allez installer la configuration de Vagrant dans le répertoire
`/usr/local/licphp/workspace/vm-$USER`.

Dans la suite du document, nous utiliserons `DOCROOT` pour parler de ce chemin.

Pour faciliter la suite, vous êtes invité à définir une variable d'environnement :

    $ export DOCROOT="/usr/local/licphp/workspace/vm-$USER"

Vous pouvez ajouter cette ligne à votre fichier `.bashrc`.

Maintenant, récupérez la configuration de la machine virtuelle :

    $ git clone https://github.com/willdurand/licpro-php-vm.git --recursive $DOCROOT
    $ cd $DOCROOT

En listant le répertoire, vous devez avoir une sortie similaire :

    DOCROOT $ ls -alh

    drwxr-xr-x 4 julien julien 4.0K Jan  4 00:26 .
    drwxrwxr-x 7 julien julien 4.0K Jan  3 00:07 ..
    drwxrwxr-x 9 julien julien 4.0K Jan  3 00:08 .git
    -rw-rw-r-- 1 julien julien    9 Jan  3 00:08 .gitignore
    -rw-rw-r-- 1 julien julien  813 Jan  3 00:08 .gitmodules
    drwxrwxr-x 4 julien julien 4.0K Jan  3 00:08 puppet
    drwxrwxr-x 4 julien julien 4.0K Jan  3 00:08 projects
    -rw-rw-r-- 1 julien julien  905 Jan  3 00:08 README.md
    -rw-rw-r-- 1 julien julien 4.6K Jan  4 00:34 Vagrantfile

La configuration est située dans le fichier `Vagrantfile` et la recette
d'installation du serveur est située dans le dossier `puppet/manifests/`.

### Démarrer la machine virtuelle

    DOCROOT $ vagrant up

### Eteindre la machine virtuelle

    DOCROOT $ vagrant halt

_Note :_ Merci de bien éteindre la machine virtuelle à la fin de la séance.

### Vérifier que tout fonctionne

Ouvrez un navigateur, et rendez vous à l'adresse `http://localhost:8080/`.
Vous devriez voir apparaître un message de bienvenue.

### Dossier partagé

Un dossier est partagé en _NFS_ entre votre machine et la machine virtuelle.
Tous les fichiers que vous éditez dans ce répertoire seront également modifiés
dans la machine virtuelle.

    Votre machine        ~>    Machine virtuelle
    DOCROOT              ~>    /vagrant
    DOCROOT/projects     ~>    /var/www

_Info :_ ce partage est configuré dans le fichier `Vagrantfile`.

Pour vérifier que tout fonctionne, ajoutez votre nom dans le fichier
`DOCROOT/projects/index.php` pour vous féliciter personnellement.
Enregistrez puis rafraichissez le navigateur. Si vos modifications apparaissent,
tout fonctionne normalement.

### Accès SSH

    $ vagrant ssh

Une fois dans la machine virtuelle, vous pouvez prendre les droits `root` via
`sudo`.

Installer à la maison
---------------------

Vous aurez besoin de [`git`](http://git-scm.com/), de `ruby` et de
[`Vagrant`](http://docs.vagrantup.com). Pour les systèmes basés sur debian :

    $ aptitude install ruby vagrant git

Pour les système OSX, reportez vous à la [documentation](http://docs.vagrantup.com).

Pour les autres, une installation Windows existe, mais il vous faudra du
courage.

_Note :_ Vous pouvez demander de l'aide par email pour l'installation, ou hors
TPs, mais nous ne ferons pas d'installation sur vos machines pendant vos TPs.

### Installer la [configuration](https://github.com/willdurand/licpro-php-vm) :

    $ mkdir ~/vagrant ; cd ~/vagrant
    ~/vagrant $ git clone git://github.com/willdurand/licpro-php-vm.git --recursive

### Installer la clé SSH

Vous pouvez commenter la ligne #16 dans le Vagrantfile :

    config.ssh.private_key_path = "~/.ssh/insecure_private_key"

ou alors installer la clé :

    $ wget https://raw.github.com/mitchellh/vagrant/master/keys/vagrant -O ~/.ssh/insecure_private_key
    $ chmod 400 ~/.ssh/insecure_private_key

### Premier démarrage

    $ cd ~/vagrant/licpro
    ~/vagrant/licpro $ vagrant up


### Problèmes Rencontrés

##### Unable To Connect To Github.com

Vous obtenez le message suivant lors du `git clone` :

    fatal: unable to connect to github.com:
    github.com[0: 207.97.227.239]: errno=Connexion terminée par expiration du délai d'attente

Vous avez probablement un proxy (Auversup?) qui empêche d'atteindre GitHub de
manière classique. Remplacez `git://` par `https://` dans l'URL du dépôt et ne
clonez pas avec l'option `--recursive` :

    $ git clone https://github.com/willdurand/licpro-php-vm.git

Allez dans le dossier créé :

    $ cd licpro-php-vm

Maintenant, ouvrez le fichier nommé `.gitmodules`, et remplacez toutes les
occurences de `git://` par `https://`.

Désormais, vous pouvez récupérer les _submodules_ :

    $ git submodule update --init

Le tour est joué.


##### There was a problem with the configuration of Vagrant

Vous obtenez le message suivant :

    There was a problem with the configuration of Vagrant. The error message(s)
    are printed below:

    ssh:
    * `private_key_path` file must exist: ~/.ssh/insecure_private_key

Relisez le fichier README ou la procédure d'installation Vagrant, pour installer
la clé privée.


##### Erreur Puppet

Vous obtenez le message suivant lors du _provisioning_ Puppet :

    err: /Stage[main]/Bazinga::Apt/Apt::Key[ondrej-php5]/Exec[df83210b394e5618d854baf93e57a9aa52f580c5]/returns:
    change from notrun to 0 failed: apt-key adv --keyserver 'keyserver.ubuntu.com'
    --recv-keys 'E5267A6C' returned 2 instead of one of [0] at
    /tmp/vagrant-puppet/modules-0/apt/manifests/key.pp:54

Encore un problème lié à un proxy (Auversup?). Il faut lancer la VM :

    $ vagrant up

Puis se connecter en SSH :

    $ vagrant ssh

Maintenant, installez `add-apt-key` :

    $ sudo apt-get install add-apt-key

Lancez la commande suivante :

    $ sudo add-apt-key -k hkp://keyserver.ubuntu.com:80 E5267A6C

Puis celle-ci :

    $ sudo apt-get update

Déconnectez vous :

    $ exit

Relancez le _provisioning_ :

    $ vagrant provision

Il peut y avoir encore un problème :

    WARNING: The following packages cannot be authenticated!
    <package 1> <package 2> ...
    E: There are problems and -y was used without --force-yes

Reconnectez vous à la VM, et lancez un `apt-get install` sur l'un des paquets :

    $ sudo apt-get install <package 1>

Déconnectez vous et relancez le _provisioning_.


##### No Input File Specified

Vous obtenez l'erreur **No input file specified**, c'est probablement un problème
de permissions sur vos fichiers. Pour corriger, placez vous dans le dossier de
votre projet sur la machine virtuelle et exécutez les deux commandes suivantes :

```
$ find * -type f -exec chmod 644 "{}" ";"
$ find * -type d -exec chmod 755 "{}" ";"
```


Guide de survie avec Git
------------------------

`git` est un gestionnaire de version distribué massivement utilisé dans le
monde Open Source grâce à [GitHub](http://github.com), mais également chez
Google, Facebook, Yahoo, Amazon, etc.

La [documentation](http://git-scm.com/book) est bien
faite et très progressive. Il est possible de la télécharger en pdf :
[Pro Git PDF](https://github.s3.amazonaws.com/media/progit.en.pdf). Une version
en français existe, cherchez-là ;-)

Il existe également un [tutoriel
interactif](http://try.github.com/levels/1/challenges/1) de 15 minutes pour
vous familiariser avec `git`.

Les commandes principales pour débuter sont :

    $ git init       # initialise un nouveau dépôt dans le répertoire courant
    $ git status     # affiche l'état du répertoire de travail
    $ git add file   # ajoute `file` à la staging area
    $ git commit     # empile la staging area dans le dépôt
                     # vous entrez votre message de commit dans vi
    $ git push       # vous poussez vos changements sur un serveur central,
                     # utile pour travailler en équipe

En image:

![](../images/git.png)

Vous êtes invité à utiliser `git` pour maintenir la cohérence entre votre
environnement personnel et celui de l'IUT.
Vous pouvez héberger vos dépôts publiquement sur [github.com](http://github.com)
ou de manière privée sur [bitbucket.org](http://bitbucket.org).


Guide de survie avec VI
-----------------------

Sur un serveur, il n'est pas rare de devoir éditer des fichiers. Sans interface
graphique, le nombre d'éditeurs est limité, mais il y aura toujours `vi`.

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
mais le mieux reste de faire le tutoriel, pour cela tapez `vimtutor` dans un
terminal.


PHP
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
Il y a la configuration pour le mode cli et la configuration pour Apache2.

Apache2
-------

Apache2 est un serveur web permettant de servir des fichiers soit directement,
soit en exécutant des programmes externes.

Le serveur écoute sur le port 80 et répond en fonction de la configuration que
vous avez fait.

### Configuration

La configuration se trouve dans le répertoire `/etc/apache2/` et est organisée
comme suit :

* `/etc/apache2/sites-available` contient les sites configurés ;
* `/etc/apache2/sites-enabled` contient des liens symboliques vers les sites
    disponibles. Ce sont les sites actifs ;
* `/etc/apache2/conf.d` contient la configuration de base et des modules.

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

Puis redémarrer Apache.

Vous accédez désormais au contenu de `/var/www/tp1` via l'URL
`http://localhost:8080/tp1`.
