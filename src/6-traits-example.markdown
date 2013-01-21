Traits examples
===============

Some patterns are really common:

* manage attributes;
* manage options;
* manage parameters;
* allow configuration;
* Singleton;
* invoke and store hooks;
* etc.

In order not to write the same code over and over, traits are useful.

Manage attributes
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
    public static function instance() {
        static $instance = null;
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
    public function add_action($hook, $callback)
    {
    }

    public function do_action($hook, $params = array())
    {
    }

    public function add_filter($hook, $callback)
    {
    }

    public function apply_filter($hook, $params = array())
    {
    }
}
```

Exaple usage:

```php
$obj = new Hookable();

/* register hooks */
$obj->add_action('init', function() {/*...*/} );
$obj->add_action('init', function() {/*...*/} );
$obj->add_action('parse_request', function() {/*...*/} );

/* call them when needed */
$obj->do_action('init', $params);
$obj->do_action('parse_request', $params);
```

Using traits
------------

```
class DbConnection
{
    use Attributes;
    use Singleton;
}
```

```
class Application
{
    use Attributes;
    use Hooks;
}
```
