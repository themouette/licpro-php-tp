Traits Examples
===============

Some patterns are really common:

* manage attributes;
* manage options;
* manage parameters;
* allow configuration;
* singleton;
* invoke and store hooks;
* etc.

In order not to write the same code over and over, traits are useful.

Manage Attributes
-----------------

```php
trait Attributes
{
    private $attributes = array();

    public function setAttribute($key, $value)
    {
        $this->attributes[$key] = $value;
        
        return $this;
    }

    public function hasAttribute($key)
    {
        return isset($this->attributes[$key]);
    }

    public function getAttribute($key, $default = null)
    {
        return $this->hasAttribute($key) ? $this->attributes[$key] : $default;
    }
}
```

Singleton
---------

```php
trait Singleton
{
    private static $instance = null;

    protected function __construct() {}

    public static function getInstance()
    {
        if ($instance === null) {
            $instance = new self;
        }
        
        return $instance;
    }
}
```

Hooks
-----

```php
trait Hooks
{
    public function register($hook, $callback)
    {
    }

    public function trigger($hook, $params = array())
    {
    }
}
```

Exaple usage:

```php
$obj = new Hookable();

/* register hooks */
$obj->register('init', function() {/*...*/} );
$obj->register('init', function() {/*...*/} );
$obj->register('parse_request', function() {/*...*/} );

/* call them when needed */
$obj->trigger('init', $params);
$obj->trigger('parse_request', $params);
```

Using traits
------------

``` php
class DbConnection
{
    use Attributes;
    use Singleton;
}
```

``` php
$con = DbConnection::getInstance();

$con->setAttribute('foo', 'bar');
```

``` php
class Application
{
    use Attributes;
    use Hooks;
}
```

``` php
$app = new Application();

$app->setAttribute('database.con', $con);

$app->register('init', function () use ($app) {
    $app->getAttribute('database.con')->query('SELECT * FROM table');
});

$app->trigger('init'); // the SQL query will be executed just now
```
