# Practical #2

The aim of this practical is to continue the work you started last week.


## Templating

Use **Twig** as template engine. Follow the three-level approach.


## DependencyInjection

### The Extension Class

Write an `Extension` class that allows you to load configuration (using a
`Configuration` class). You should be able to configure your bundle that way:

``` yaml
licweb_location:
    data_file: "%kernel.cache_dir%/locations.yml"
```

### Service

Create a service that manipulates the data. This service should abstract the
YAML manipulation. The implementation has to fit the following interface:

``` php
<?php

interface LocationRepositoryInterface
{
    /**
     * Returns a location by its id.
     *
     * @param int $id
     */
    public function get($id);

    /**
     * Returns all locations.
     *
     * @return array
     */
    public function getAll();

    /**
     * Add a location
     *
     * @param string $name
     */
    public function add($name);
}
```

> **Important:** Find a name for your class and your service, and ask the teacher
> for validation.

This service should take the `data_file` parameter as argument. You will have to
find how to achieve that part.

Use this service in your controller.


## Commands

In both exercices, use the service created above.

### The ListCommand

Write a `ListCommand` that exposes a `licweb:location:list` command. The aim of
this command is to list all locations.

    $ php app:console licweb:location:list
        1 | Paris
       23 | New-York

You can use the `sprintf()` function to format a string. You can use
placeholders to align numbers. For instance, `%4d` will always use 4 rows to
print the number:

       1
      23
     456
    7890


### The AddCommand

Write a `AddCommand` that exposes a `licweb:location:add` command. The aim of
this command is to add new locations in th `data_file` file seen above.

The command takes only one argument: the location's name.

    $ php app/console licweb:location:add Paris

The command provides an option to clear all locations before inserting  the
new location into the `data_file`:

    $ php app/console licweb:location:add Paris --clear
