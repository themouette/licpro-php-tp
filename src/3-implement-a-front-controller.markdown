Implement A Front Controller
============================

Extra Configuration
-------------------

The virtual machine configuration has been updated with a set to virtual hosts.
The use of aliases is nice, but when you deploy a web application, you often use
a domain name to access it.

That's what we did. Until now, the files located under `$DOCROOT/projects/` were
available at `http://localhost:8080/`. With the new configuration, you won't use
port forwarding anymore, but real domain names thanks to
[xip.io](http://xip.io).

This service is a magic domain name that provides wildcard DNS for any IP address.
**Don't worry if you don't get that, it's not a problem**, just understand that
you can use `foobar.127.0.0.1.xip.io` as a domain name, and it will redirect you
to `127.0.0.1`.

Basically, your files under `$DOCROOT/projects/` should be available at:
`http://www.33.33.33.10.xip.io`.

Another domain name has been configured: `http://uframework.33.33.33.10.xip.io`
that points to `/var/www/uframework/web/` on the virtual machine, also known as
`$DOCROOT/projects/uframework/web/` on the host machine.

Update the configuration by running the following commands on the host
machine:

```
$ git pull origin master
$ git submodule update --init
$ vagrant reload
```

Get the code of uFramework by downloading this [archive](uframework.tgz). As seen
in practical #1, you can extract this archive in  `DOCROOT/projects/uframework`
on the host machine:

```
$ mkdir $DOCROOT/projects/uframework
$ wget uframework.tgz -O $DOCROOT/projects/uframework/uframework.tgz
$ cd $DOCROOT/projects/uframework
$ tar xvzf uframework.tgz
$ rm uframework.tgz
```

Then again, you now have two projects:

```
URL                                     Directory on the VM
http://www.33.33.33.10.xip.io/      ~>  /var/www/projects/
http://uframework.33.33.10.xip.io/  ~>  /var/www/uframework/web/
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

```
vagrant@vm-licpro $ phpunit --version
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

uFramework is your micro-framework, the one you will build in the practical. Its
API has been influenced by existing like [Silex](http://silex.sensiolabs.org) or
[Slim](http://www.slimframework.com).

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

Your first job is to take a piece of paper, a pen, and to write your world's
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

### Complete GET Routes

Complete the `GET` routes predefined in `app/app.php` file and create the
corresponding templates.

You should be able to:

* list locations under `GET /locations`;
* display a location with `id` under `GET /locations/id`;

When loading `http://uframework.33.33.33.10.xip.io/` an error should appear.
Let's fix this by implementing uFramework missing parts.

### Complete uFramework kernel

The kernel is defined in `src/App.php` and has been altered. Complete the
`registerRoute()` method. Try to list your locations by refreshing
`http://uframework.33.33.33.10.xip.io/locations`.

Complete `put()`, `post()`, and `delete()` methods as well.

### Add a basic Model Persistence

Locations will now be stored in `data/locations.json`. Rework your `Locations`
class to add a persistence behaviour.

To manipulate JSON, SPL defines both `json_encode()` and `json_decode()`. Use
the [PHP manual](http://php.net) to know how to use these methods in order to
create a persistent model layer.

> _Hint:_ one method returns an array from a JSON string, the one is able to
transform an array into a JSON string. You saw a few methods last week that can
be used to read/write files.

### Complete the Application

Add a form on the locations list page. This form will `POST` data to `/locations` in
order to create a new location:

```
<form action="/locations" method="POST">
</form>
```

When you create a new resource, you should return a `201` status code which
stands for `Created`. Also, you should just return the `id` of your resource.

Add a form on the location details page to enable edition. This form will `PUT`
changes at `/locations/id` in order to update the resource.

On the location detail page, another form will `DELETE` the resource located at
`/locations/id`. When you delete a resource, you should return a `204` status
code which stands for `No Content`.
