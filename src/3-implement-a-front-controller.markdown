Front controller
================

Extra Configuration
-------------------

The virtual machine configuration has been updated with a virtualhost on port
`81`. You can access this virtual host at `http://33.33.33.10:81` or
`http://locahost:8090`.

It points to the virtual machine `/var/www/uframework/web/` folder.

In this folder, extract this [archive](uframework.tgz). As seen in practical #1,
you can extract this archive on the host machine at
`DOCROOT/projects/uframework`:

```
$ mkdir $DOCROOT/projects/uframework
$ wget uframework.tgz -O $DOCROOT/projects/uframework/uframework.tgz
$ cd $DOCROOT/projects/uframework
$ tar xvzf uframework.tgz
$ rm uframework.tgz
```


PHPUnit
-------

[`phpunit`](http://phpunit.de) is a PHP testing framework part of the _xUnit_
family. To install it globally in the virtual machine, run:

``` bash
vagrant@vm-licpro $ wget http://pear.phpunit.de/get/phpunit.phar
vagrant@vm-licpro $ chmod a+x
vagrant@vm-licpro $ sudo mv phpunit.phar /usr/bin/phpunit
```

Run a test suite with the following command:

```
vagrant@vm-licpro $ phpunit
```

The `phar` execution might require to add
`/etc/php5/cli/conf.d/suhosin-allow-phar.ini` with the following content:

``` ini
suhosin.executor.include.whitelist="phar"
```

Anatomy of uFramework
---------------------

The directory layout looks like this:

    ├ app/      # the application directory
    ├ src/      # the framework sources
    ├ tests/    # the test suite
    ├ web/      # public directory
    └ autoload.php

### `app` directory

Your application controllers will be registered as closures in `app.php`.
Templates will be put in the `templates/` directory.

### `src` directory

The framework sources. You will have to complete the missing parts.

### `tests` directory

The test suite, all tests have to pass at the end :)

Run it with the following command:

```
vagrant@vm-licpro $ phpunit
```

### `web` directory

Contains the public part.

The `index.php` file is the only entry point for this application.
It is called a `front controller`.

Goal
----

Today's goal is to create a simple PHP application to **C**reate, **R**etrieve,
**U**pdate, and **D**elete locations.

This is called a **CRUD** application.

This application will respect **REST** conventions, that means the use of HTTP
verbs, and consistent URIs.

All routes will be declared in `app/app.php` as follow:

```php
$app->post('/locations', $callable);
$app->get('/locations/(\d+)', $callable);
$app->put('/locations/(\d+)', $callable);
$app->delete('/locations/(\d+)', $callable);
```

`$callable` can either be a closure, an array or a function name.
More on this in the [PHP manual](http://php.net/manual/en/language.types.callable.php).

Create Routes and Templates
---------------------------

## Create a Model class

Create a Location class in `src/Model`. This class **must** implement
`Model\FinderInterface`.

## Complete GET Routes

Complete get routes predefined in `app/app.php` file and create associated
templates.

You should be able to:

* list locations under `GET /locations`;
* display location with `id` under `GET /locations/id`;

When loading `http://33.33.33.10:81/` an error should appear.
Let's fix this by implementing uFramework missing parts.

## Complete uFramework kernel

Kernel is defined in `src/App.php` file and has been altered. Complete the
`registerRoute()` method.

Complete `put()`, `post()`, and `delete()` methods as well.

## Add a basic Model Persistence

Locations will be stored in `data/locations.json`.

To manipulate JSON, SPL defines both `json_encode()` and `json_decode()`.

Add a form on the location list page. This form will POST data to `/locations` in
order to create a new location.

Add a form on the location details page to enable edition. This form will PUT
changes at `/locations/id` in order to update the resource.

On the location detail page, another form will DELETE the resource located at
`/locations/id`.
