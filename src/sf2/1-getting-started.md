Getting Started
---------------

Update the VM by running the following commands:

    $ cd $DOCROOT
    $ git stash
    $ git pull --rebase origin master
    $ git checkout symfony2-1
    $ git stash apply
    $ vagrant reload

Install the awesome
[symfony-licpro-edition](https://github.com/willdurand/symfony-licpro-edition):

    $ git clone git://github.com/willdurand/symfony-licpro-edition.git $DOCROOT/projects/sf2

Now, checkout the `0.0.1` tag which contains the code for this practical:

    $ cd $DOCROOT/projects/sf2
    $ git checkout 0.0.1

SSH into tour Virtual Machine, and setup the project:

    $ cd /var/www/sf2/
    $ composer install --dev

Run the `app/console` command:

    $ app/console

Browse
[http://localhost:8080/index_dev.php](http://localhost:8080/index_dev.php).

If everything seems ok, it's time to open the [Symfony2
documentation](http://symfony.com/doc/master/book/index.html).


## Start Hacking On Symfony2

Your job is to implement the web application you wrote in the previous
practicals.

Create your first bundle named: `LicwebLocationBundle`.

Your controllers have to extend the Symfony2 base `Controller`.

The **persistence layer** will use a `YAML` file. Put your file in the `cache`
directory. You can get its path with:

``` php
$path = $this->getContainer()->getParameter('kernel.cache_dir');
```

You won't use any templating engine. Either write your own template engine (like
the one you used in the last practicals, **or** manipulate strings in the
controller.
