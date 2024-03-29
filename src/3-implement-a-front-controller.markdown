Implement A Front Controller
============================

<br />

#### Working in room A10 (IUT)

You can easily install the environment you use at IUT - **B19**, either in room
**A10**, or on your laptop. You have to follow the same steps you followed in
the first practical:

``` bash
$ git clone https://github.com/willdurand/licpro-php-vm.git --recursive $DOCROOT
$ cd $DOCROOT
$ vagrant up
```

<br />

#### UPDATE: READ THIS CAREFULLY

All of you, students, have to run the following commands. I said **ALL** of you.

Update the configuration by running the following commands on the host machine:

``` bash
$ git pull origin master
$ git submodule update --init
$ vagrant reload
```

If something went wrong, **email us** as soon as possible!

<br />

Extra Configuration
-------------------

So, the virtual machine configuration has been updated with a set to virtual
hosts. The use of aliases is nice, but when you deploy a web application, you
often use a domain name to access it.

That's what we did. Until now, the files located under `$DOCROOT/projects/` were
available at `http://localhost:8080/`. That's called **port forwarding**.

We decided to use a great tool named [xip.io](http://xip.io).  This service is a
magic domain name that provides wildcard DNS for any IP address.
**Don't worry if you don't get that, it's not a problem**, just understand that
you can use `foobar.127.0.0.1.xip.io` as a domain name, and it will redirect you
to `127.0.0.1`.

Basically, your files under `$DOCROOT/projects/` should be available at:
`http://www.33.33.33.10.xip.io/`. **Unfortunately**, I doesn't always work as
expected.

You can get bad response times, or even errors. That's why you can still use
`http://localhost:8080/`.

Another domain name has been configured:
`http://uframework.33.33.33.10.xip.io/` that points to `/var/www/uframework/web/`
on the virtual machine, also known as `$DOCROOT/projects/uframework/web/` on the
host machine.

Then again, it doesn't work as expected, so you can access it using
`http://locahost:8090/`. Double check the port number, it's `8090` here, not
`8080`.

To sum up:

```
URL to use in your browser (host machine)           Directory on the VM         Directory on the Host Machine

http://www.33.33.33.10.xip.io/              ~>      /var/www/projects/          $DOCROOT/projects/
http://uframework.33.33.10.xip.io/          ~>      /var/www/uframework/web/    $DOCROOT/projects/uframework/web/

http://localhost:8080/                      ~>      /var/www/projects/          $DOCROOT/projects/
http://localhost:8090/                      ~>      /var/www/uframework/web/    $DOCROOT/projects/uframework/web/
```

**Important:** if the `*.xip.io` URLs don't work, use the `localhost:port` ones.


Getting Started
---------------

Get the code of uFramework by downloading this [archive](uframework.tgz).

As seen in practical #1, you can extract this archive in
`DOCROOT/projects/uframework` on the host machine:

``` bash
$ mkdir $DOCROOT/projects/uframework
$ wget http://williamdurand.fr/licpro-php-practicals/tp2/uframework.tgz -O $DOCROOT/projects/uframework/uframework.tgz
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
vagrant@vm-licpro $ chmod a+x phpunit.phar
vagrant@vm-licpro $ sudo mv phpunit.phar /usr/bin/phpunit
```

Did it work? Try to print the PHPUnit version:

``` bash
vagrant@vm-licpro $ phpunit --version
```

Run a test suite with the following command:

``` bash
vagrant@vm-licpro $ phpunit
```


Anatomy of uFramework
---------------------

uFramework is **your** micro-framework, the one you will build in the practical.
Its API has been influenced by existing like [Silex](http://silex.sensiolabs.org)
or [Slim](http://www.slimframework.com).

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

### `web` directory

Contains the public files. Most of the time, we put assets (CSS, JS files)
and a `index.php` file.

The `index.php` file is the only entry point for this application.
It is called a `front controller`.


Goal
----

So, we wrote some parts of your micro-framework but you have to improve it. This
is more than a micro-framework actually, because it also embeds the application
itself.

Today's goal is to create a simple PHP application to **C**reate, **R**etrieve,
**U**pdate, and **D**elete locations.

This is called a **CRUD** application.

This application will respect **REST** conventions, that means the use of HTTP
verbs, and consistent URIs.

All routes will be declared in `app/app.php` as follow:

```php
$app->post('/locations', $callable);
$app->get('...', $callable);
$app->put('...', $callable);
$app->delete('...', $callable);
```

`$callable` can either be a closure, an array or a function name.
More on this in the [PHP manual](http://php.net/manual/en/language.types.callable.php).

We recommend the use of closures here:

```php
function ($params) use ($something) {
    // controller code
}
```

**Your first job** is to take a piece of paper, a pen, and to write your world's
domination plan. Well, at least write the API methods you need in a REST-style:

```
GET /something
POST /...
...
```

The important thing here is to determine what you want to achieve **before**
writing your application. The use of a sheet of paper is **mandatory**!

Last but not the least, you will manage `location` resources, in a CRUD way.

**This plan HAS to be validated by your teacher!**

**Email us if we didn't check your plan, ok?**


Autoloading
-----------

In the previous practical, you wrote a PSR-0 compliant autoloader. The
uFramework has a `autoload.php` file, but it's empty. Reuse what you've done
before to autoload your classes. You should load classes from `src/` and
`tests/`.

Check whether it works but running the tests:

```
vagrant@vm-licpro $ phpunit
```


Create Routes and Templates
---------------------------

### Create a Model class

Create a `Locations` class in `src/Model`. This class **must** implement
`Model\FinderInterface`. It's your job ;-)

You can reuse the set of data used in practical #1.

### Complete uFramework kernel

The kernel is defined in `src/App.php` and has been altered. Complete the
`registerRoute()` method. Try to list your locations by refreshing
`http://localhost:8090/locations`.

Complete `put()`, `post()`, and `delete()` methods as well.

Check everything is ok by **running the test suite**.

### Complete GET Routes

Complete the `GET` routes predefined in `app/app.php` file and create the
corresponding templates.

You should be able to:

* list locations under `GET /locations`;
* display a location using its `id` under `GET /locations/(\d+)`;

Why `/locations(\d+)`? The following methods `get()`, `post()`, `put()`, and
`delete()` take a regular expression as first argument. It defines the pattern
for each URI you want to implement.

Basically, when you declare a route:

``` php
$app->get('/locations/(\d+)', function ($id) use ($app) {
});
```

It will match all URIs starting with `/locations/` and finishing with a number
(`/locations/0`, `/locations/1`, `/locations/123`, etc.).

You can declare more parameters:

``` php
$app->get('/locations/(\d+)/comments/(\d+)', function ($locationId, $commentId) use ($app) {
});
```

`(\d+)` is a regular expression that matches numbers only, but you can match
whatever you want. Note that using numbers as identifiers is a good idea.

This number (`0`, `1` or `123` in the examples) will be injected as argument of
the closure, that's why we declare a `$id` parameter. Use this parameter to
retrieve the corresponding location.

If you can't find a location for a given id, then you should throw a
`HttpException` with status code set to `404` which stands for `Not Found`.
Look at the `HttpException` class, the first argument is the status code, and
the second one is a message.

Check everything works. You should write two templates, one for the list view,
another one for the detail view.


### Add a basic Model Persistence

Locations will now be stored in `data/locations.json`. Rework your `Locations`
class to add a persistence behaviour.

To manipulate JSON, SPL defines both `json_encode()` and `json_decode()`. Use
the [PHP manual](http://php.net) to know how to use these methods in order to
create a persistent model layer.

> **Hint:** one method returns an array from a JSON string, the one is able to
transform an array into a JSON string. You saw a few methods last week that can
be used to read/write files.
