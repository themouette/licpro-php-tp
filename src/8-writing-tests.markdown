Writing Tests
=============

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

The aim of this practical is to learn how to test your project. Software testing
is a **requirement** for all developers. Your job is **not** to write code, it's
all about providing solutions for given problems. The right solution is always
the one that just works.

The question is: how do you ensure that your solution works? You cannot rely on
the well-known _it works on my machine™_. This is just silly. What you need to
do is to provide a set of automated tests.

Tests are more than just _assertions_ on some properties of your application,
it's also the best documentation you can provide to your customers/users because
tests are always up to date.

For all these reasons, you have to learn how to write tests. In this practical,
we will focus on two kind of tests: **unit tests**, and **functional tests**.


## Unit Tests

Unit testing is about testing some parts of your application in a **white box**
approach. The main idea is to test algorithms, methods, functions one by one.
That doesn't mean you have to test your `private` methods, because these methods
should be used by your `public` methods. To sum up, only test your `public`
methods.

The PHP unit testing framework in PHP is named [PHPUnit](http://phpunit.de).
Look at the `tests/` directory in uFramework.

In this part, your job is to test your `Model` layer. For instance, the
`DataMapper` class requires a `Connection` instance to work. You won't provide a
real `Connection` instance here, because you don't want to use a database in
order to run your tests.

Unit tests should not contain hard dependencies to external services. In order
to avoid that, we often rely on **mocks**. A **mock** is an implementation that
you control in your tests.

Creating a mock is easy. You can either create your own class (by using
inheritance), or you can use a mocking framework. PHPUnit has its own mocking
framework:
[http://www.phpunit.de/manual/3.0/en/mock-objects.html](http://www.phpunit.de/manual/3.0/en/mock-objects.html).

Try to test your _mappers_. Mock the `Connection` to return the executed SQL
queries, and compare them to queries you expect to execute.

This can be useful to ensure your `persist()` method distinguishes the state of
the object. Note that `PDO` cannot be mocked out of the box. You have to extend
it, and avoid to call its constructor:

    !php
    class MockConnection extends Connection
    {
        public function __construct()
        {
        }
    }

Now, you can mock your `Connection`:

    !php
    $this->getMock('MockConnection');

You now ensure that your _mappers_ execute valid SQL queries. However, you
cannot ensure the well-execution of your methods. For instance, you are not sure
that the `persist()` method actually persists your POPO.

This introduces the next part of this practical: functional tests.


## Functional Tests

Functional tests are tests that ensure correctness of your application by
focusing on use cases/user stories at the application level (the ones your
client described).
The goal is to not only test a method, but this method and its interactions with
the rest of the application. In other words, they test the system the way the
end user would use it.

For instance, you cannot test a controller because its job is to glue all
components of your application to fit a given use case. For example, a
controller relies on the Model layer to retrieve data, and use the View layer
to render the data to the client.

As said in the previous section, we need to know whether the _mappers_ actually
persist your POPO. Your connection class is configurable through the **DSN**,
and supports [various drivers](http://php.net/manual/en/pdo.drivers.php).

You can write your first functional tests by testing your _mappers_ using a
configured `Connection` instance (leveraging the SQLite database), instead of
using a mock.

    !php
    class LocationDataMapperTest extends \TestCase
    {
        private $con;

        public function setUp()
        {
            $this->con = new \Model\Connection('sqlite::memory:');
            $this->con->exec(<<<SQL
    CREATE TABLE IF NOT EXISTS locations(
        id INTEGER NOT NULL PRIMARY KEY,
        name VARCHAR(250) NOT NULL,
        created_at DATETIME
    );
    SQL
            );
        }

        public function testPersist()
        {
            $mapper = new \Model\LocationDataMapper($this->con);

            // ...

            // Example on how to count rows in the table
            // $rows = $this->con->query('SELECT COUNT(*) FROM locations')->fetch(\PDO::FETCH_NUM);
            // $this->assertEquals(0, $rows[0]);
        }
    }


Test your Model layer using SQLite. As you may noticed, you have to adjust your
SQL statements.

Another part you may want to test is the API. It's a pain to use `curl` to test
each API method, and we don't do that in real life. Instead, prefer
[Goutte](https://github.com/fabpot/Goutte), a simple PHP web scrapper:

    !php
    $client   = new Client();
    $endpoint = 'http://localhost:8090';

    // GET
    $crawler  = $client->request('GET', sprintf('%s/locations', $endpoint));
    $response = $client->getResponse();

    // POST
    // See: https://github.com/symfony/BrowserKit/blob/master/Client.php#L242
    $client->request('POST', sprintf('%s/locations', $endpoint), $request, [], $headers, $content);

    // Examples of assertions:
    // $this->assertEquals(200, $response->getStatus());
    // $this->assertEquals('text/html', $response->getHeader('Content-Type'));
    //
    // $data = json_decode($response->getContent(), true);
    // $this->assertArrayHasKey('name', $data);


Test your API using this client. Your application has to run in order to test it.
