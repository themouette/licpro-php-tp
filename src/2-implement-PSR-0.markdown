PSR-0 autloading
================

In this practical you will create a `PSR-0` compliant autoloader.

Definition
----------

The following describes the mandatory requirements that must be adhered
to for autoloader interoperability.

### Mandatory

* A fully-qualified namespace and class must have the following
  structure `\<Vendor Name>\(<Namespace>\)*<Class Name>`
* Each namespace must have a top-level namespace ("Vendor Name").
* Each namespace can have as many sub-namespaces as it wishes.
* Each namespace separator is converted to a `DIRECTORY_SEPARATOR` when
  loading from the file system.
* Each `_` character in the CLASS NAME is converted to a
  `DIRECTORY_SEPARATOR`. The `_` character has no special meaning in the
  namespace.
* The fully-qualified namespace and class is suffixed with `.php` when
  loading from the file system.
* Alphabetic characters in vendor names, namespaces, and class names may
  be of any combination of lower case and upper case.

### Examples

* `\Doctrine\Common\IsolatedClassLoader` => `/path/to/project/lib/vendor/Doctrine/Common/IsolatedClassLoader.php`
* `\Symfony\Core\Request` => `/path/to/project/lib/vendor/Symfony/Core/Request.php`
* `\Zend\Acl` => `/path/to/project/lib/vendor/Zend/Acl.php`
* `\Zend\Mail\Message` => `/path/to/project/lib/vendor/Zend/Mail/Message.php`

Overview
--------

We'll achieve the PSR-0 autoloader with caching in 4 steps:

* implement autoloading from cache
* implement autloading from namespace
* implement autoloading for underscore notation
* register discovered classes in cache and dump it

To start, create `projects/practical2/psr0` directory and extract [this archive](archive.tgz)

    $ wget archive.tgz
    $ tar xvfz archive.tgz
    $ rm archive.tgz

running the `tree` command should display the following:

    ├ test.php
    ├ test_cache.php
    ├ test_namespace.php
    └ vendor/
        ├ autoload.php
        ├ autoload_cache.php
        ├ autoload_namespace.php
        ├ Coffe/
        │   ├ Bali.php
        │   ├ BlueMontain.php
        │   └ Sumatra.php
        ├ Soda/
        │   ├ Lemonade.php
        │   └ Juice.php
        │       └ Orange.php
        └ Wine/
            ├ Bordeaux.php
            └ Chinon.php

Every class under `vendor/` directory print it's name in the constructor:

``` php
<?php

class Foo
{
    public function __construct($log = true)
    {
        if ($log) {
            printf("%s\n", get_class($this));
        }
    }
}
```

Step 1: Register a new autoloader
---------------------------------

`SPL` allow us to register a custom autoloaders through `spl_autoload_register()`
and `spl_autoload_unregister()` methods.

This part will be tested thanks to `test_cache.php` script with following content:

``` php
<?php

/**
 * testing spl functions to register an autoloader
 */

include __DIR__ . "vendor/autoload_cache.php";

new Coffe\Bali();
new Coffe\BlueMontain();
new Coffe\Sumatra();
new Soda\Lemonade();
new Soda\Juice\Orange();
new Wine\Bordeaux();
new Wine\Chinon();
```

Register a closure as an autoloader in `vendor/autoload_cache.php`.

The closure _must_ use the following associative array:

``` php
$autoload_map = array(
    'Coffe\Bali'		=> 'Coffe/Bali.php',
    'Coffe\BlueMontain'	=> 'Coffe/BlueMontain.php',
    'Coffe\Sumatra'		=> 'Coffe/Sumatra.php',
    'Soda\Lemonade'		=> 'Soda/Lemonade.php',
    'Soda\Juice\Orange' => 'Soda/Juice/Orange.php',
    'Wine\Bordeaux'		=> 'Wine/Bordeaux.php',
    'Wine\Chinon'		=> 'Wine/Chinon.php',
);
```

To check if everything is fine, just run:

``` bash
vagrant@vm-licpro $ php test_cache.php
```

You should see:

    Coffe\Bali
    Coffe\BlueMontain
    Coffe\Sumatra
    Soda\Lemonade
    Soda\Juice\Orange
    Wine\Bordeaux
    Wine\Chinon


Step 2: Guess path from namespace
---------------------------------

Complete `vendor/autoload_namespace.php` to load classes based on namespace.

To check if everything is fine, just run:

``` bash
vagrant@vm-licpro $ php test_namespace.php
```

You should see:

    Coffe\Bali
    Coffe\BlueMontain
    Coffe\Sumatra
    Soda\Lemonade
    Soda\Juice\Orange
    Wine\Bordeaux
    Wine\Chinon

Step 3: load underscorized classnames
-------------------------------------

Complete `vendor/autoload_underscore.php' to successfuly execute `test_underscore.php`

``` bash
vagrant@vm-licpro $ php test_underscore.php
```

You should see:

    Soda\Juice\Pinapple

Step 4: combineit all
---------------------

Complete `vendor/autoload.php` in order to fully comply to PSR0.

Following steps should be executed:

* Load cache file;
* check if class is already in cache and load it if available;
* find class in definition map and add it to cache;
* save cache array in `vendor/cache.php` using `var_export` method.