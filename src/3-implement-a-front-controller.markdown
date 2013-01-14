Frontend controller
===================

Extra configuration
-------------------

Virtual machine configuration has been updated with a virtualhost on port 81.
You can access this virtualhost at `http://33.33.33.10:81`.

It point to virtual machine `/var/www/uframework/web/` folder.

In this folder, extract this [archive](uframework.tgz)

```
$ mkdir $DOCROOT/projects/uframework
$ wget uframework.tgz -O $DOCROOT/projects/uframework/uframework.tgz
$ cd $DOCROOT/projects/uframework
$ tar xvzf uframework.tgz
```


phpunit
-------

Phpunit is php test framework based on XUnit standard.
To install it globally simply run:

``` bash
vagrant@vm-licpro $ wget http://pear.phpunit.de/get/phpunit.phar
vagrant@vm-licpro $ chmod a+x
vagrant@vm-licpro $ sudo mv phpunit.phar /usr/bin/phpunit
```

To launch a test suite, just run:

```
vagrant@vm-licpro $ phpunit -c phpunit.xml.dist tests/
```

`phar` execution might require to add `/etc/php5/cli/conf.d/suhosin-allow-phar.ini`
with following content:

``` ini
suhosin.executor.include.whitelist="phar"
```

Anatomy of uFramework
---------------------

The directory layout looks like this:

    ├ app/      # the application directory
    ├ src/      # the framework source
    ├ tests/    # framework tests
    ├ web/    # public directory
    └ autoload.php

### `app` directory

Your application controllers will be registered as closures in `app.php`.
Templates will be put in `tempaltes/` directory.

### `src` directory

The framework source. You will have to complete missing parts.

### `tests` directory

framework tests, all tests have to pass at the end :)

To launch a test suite, just run:

```
vagrant@vm-licpro $ phpunit -c phpunit.xml.dist tests/
```

### `web` directory

Contains the public part.

The `index.php` file is the only entry point for this application. It is called a `frontend controller`.

Goal
----

Today goal is to create a simple php application to Create, Retrieve, Update
and Delete locations.

This is called CRUD application.

This application will respect REST conventions, that means HTTP verbs and consistent URIs.

All routes are declared in `app/app.php` as follow:

```php
$app->get('/location/:id', $callable);
$app->put('/location/:id', $callable);
$app->post('/location', $callable);
$app->delete('/location/:id', $callable);
```

`$callbale` can either be a closure, an array or a function name.
More on this in [php manual](http://php.net/manual/en/language.types.callable.php).

Create routes and templates
---------------------------

Create a Model class
--------------------

Create a Location class in `src/Model`. This class **must** implement
`Model\FinderInterface`.

Complete uFramework kernel
--------------------------


Add persistence
---------------

In a json file using `json_encode()` and `json_decode()`

