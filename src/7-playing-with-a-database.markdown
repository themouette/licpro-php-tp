Playing With A Database
=======================

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

This update adds a [MySQL](http://www.mysql.fr/) database server, its client,
and it also creates a database named `uframework`. You can access this database
with the user `uframework` and the password `uframework123`.


## Your First Database Layer

Write a SQL script named `schema.sql` to create a `locations` table with the
following rules:

* This table contains three columns: `id`, `name` and `created_at`;
* The `id` column contains `integer` values;
* The `id` column cannot be **null**;
* The `id` column is **auto incremented**;
* The `id` column is a **primary key**;
* The `name` column contains strings (less than 250 chars);
* The `name` column cannot be **null**;
* The `created_at` column contains **datetime** values;
* The `created_at` column can be **null**.

The script MUST contain a constraint if the table already exists, something
like:

``` sql
CREATE TABLE IF NOT EXISTS tbl_name
```

This file has to be created in `/var/www/uframework/app/config`.

Now, create your database:

``` bash
vagrant@vm-licpro:/var/www/uframework$ mysql uframework -uuframework -puframework123 < app/config/schema.sql
```

Now that you have a database, and a table. Update your model layer (aka the
`Locations` class) to manipulate a database instead of a file.

In order to do that, you HAVE TO:

* use [PDO](http://php.net/manual/book.pdo.php);
* use a `Connection` class as described in the last course;
* inject a `Connection` instance in the `Locations` class;
* use the `Connection` instance to execute queries, then again it has been
  described in the last course;
* ignore the `created_at` column by now.

The `find*()` methods won't use the `executeQuery()` method, you will have to
write your own logic to return the data (hint: `FETCH_ASSOC`).

You MAY need to update the templates and/or the JSON data.

The `Connection` should be created in `app/app.php` and passed to the
`Locations` instance(s). That way, the configuration part is located in only
one place (into the `app/app.php` file).

Now, check everything still works.


## In-Depth With The Database

Start by writing a `Location` class (read the name carefully, there is no "s"
here). This class should contain getters/setters for the following attributes:

* `id`;
* `name`;
* `createdAt`.

The constructor of this class takes the same parameters. Removing the setter for
the `id` attribute sounds like a good idea.

It's time to use this class. In method `findAll()` use `array_map()` to return a
set of `Location` objects. Each object will be created on the fly.

In method `findOneById()`, return an instance of `Location`, or `null` if not
found.

Update your templates to reflect these changes. Also, update the JSON part
(either by using getters, or by using the Serializer component).


## Introducing The Data Mapper

So, you have a Model Layer with a **Data Access Layer** thanks to the
`Connection` class.

Implement a `LocationDataMapper` class. This class HAS TO implement the **Data
Mapper** design pattern, and should leverage the `Connection` class. Write an
interface for such a design pattern, and use it in your `LocationDataMapper`
class.

Remove the `PersistenceInterface` from your project, and remove the code related
to this interface in the `Locations` class.

Now, rename your `Locations` class to `LocationFinder` class.

You should have a cleaner Model Layer containing:

* a DAL thanks to the `Connection` class;
* a DataMapper to persist/remove Plain Old PHP Objects (POPO);
* a Finder to perform queries and retrieve sets of POPOs.

Update your controllers to use these classes when it's needed.


// to be continued
