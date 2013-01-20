Content Negotiation
===================

**WARNING:** Before starting this practical, a working _µFramework_
implementation is required.

Goal of this practical is to implement a simple content negotiation layer in
your `µFramework`.

By the end of this session your application will serve resources in:

* `HTML` using a template;
* `JSON` encoded data.

Your implementation will also accept parameters encoded in:

* `application/form-url-encoded`;
* `application/json`.


## Theory

Content negotiation is part of the `HTTP` protocol, used to serve a media in the
best format for a client.

[RFC 2616: HTTP/1.1](http://pretty-rfc.herokuapp.com/RFC2616) - [RFC 2295:
content negotiation](http://pretty-rfc.herokuapp.com/RFC2295).

Content negotiation means that a single resource can be presented in different
ways, depending on the client. To achieve this goal, `HTTP headers` are used by
a client to present accepted formats. Based on this `Accept` header, server can
guess the best content to deliver.

Here is an example:

    #Client
    GET /locations/1 HTTP/1.1
    Host: www.example.org
    Accept: text/html; q=1.0, text/*; q=0.8, image/gif; q=0.6, image/jpeg; q=0.6, image/*; q=0.5, */*; q=0.1

    #Server
    HTTP/1.1 200 OK
    Date: Mon, 23 May 2005 22:38:34 GMT
    Server: Apache/1.3.3.7 (Unix) (Red-Hat/Linux)
    Last-Modified: Wed, 08 Jan 2003 23:11:55 GMT
    Accept-Ranges:  none
    Content-Length: 438
    Connection: close
    Content-Type: text/html; charset=UTF-8

    <!DOCtYPE html>
    <html>
        <head>
        </head>
        <body>
            <h1>New York</h1>
        </body>
    </html>

Same request performed by another client:

    #Client
    GET /locations/1 HTTP/1.1
    Host: www.example.org
    Accept: application/json; q=1.0, text/*; q=0.8

    #Server
    HTTP/1.1 200 OK
    Date: Mon, 23 May 2005 22:38:34 GMT
    Server: Apache/1.3.3.7 (Unix) (Red-Hat/Linux)
    Last-Modified: Wed, 08 Jan 2003 23:11:55 GMT
    Accept-Ranges:  none
    Content-Length: 438
    Connection: close
    Content-Type: application/json; charset=UTF-8

    {"id":"1","name":"New York"}


## Add Content Negotiation For Resource Representation

### Functional Analysis (Requirements)

First, grab a piece of paper and write an example of `GET /locations/1`
response for every format and call for validation.

### Conception

#### Guessing The Best Format To Return

It's Request's responsability to resolve the best format to serve, so we need
a `guessBestFormat()` method in this class.

[Negotiation](https://github.com/willdurand/negotiation) will help you to get the
best format from headers by handling content negotiation.

Thanks to this new method, it is now possible to render different content based
on the best fit.

#### Formatting Your Data The Right Way

HTML rendering is achieved through your template engine. Rendering your data in
other formats is called _serialization_. Serialization is the process of
converting a data structure or object state into a format that can be stored.

The serialization has to be handled by a Serializer. This serializer can be as
simple as the `json_encode()` function or you can use the [Serializer
Component](
http://symfony.com/doc/current/components/serializer.html).


#### Introducing A Response Object

To fit the HTTP protocol, every response should contain at least:

* a Content-Type header to describe the content;
* a status code to give feedback on what happened;
* the content or body of the response.

That makes a lot of things to handle, it cannot all fit in the App class. A
`Response` class will be in charge of response configuration.


### Implementation

You will use Composer to manage your project, and its libraries.

#### Create `composer.json` file

In your project, create a `composer.json` file with the following content:

```json
{
    "require": {
        "symfony/serializer": "~2.1",
        "willdurand/negotiation": "1.0.*@dev"
    },
    "autoload": {
        "psr-0": { "": "src/" }
    }
}
```

Now, run:

```bash
vagrant@vm-licpro:/var/www/uframework$ composer install
```

It will install two libraries in the `vendor/` folder.

Run the test suite, does it fail?

Edit the `tests/boostrap.php` file, by replacing its content with:

``` php
$loader = require __DIR__ . '/../vendor/autoload.php';
$loader->add('', __DIR__);
```


#### Replace Your Autoloader With Composer's One

When you run `composer install`, it will also generate an autoloader file in
`vendor/autoload.php`. That one is optimized and probably better than yours.
Moreover, it's automatically generated and you don't need to waste your time on
that.

In `app/app.php`, replace autoloader with `vendor/autoload.php`.

You can safely delete the `autoload.php` file you wrote in the previous
practical.


#### Update Your Request Class

Create the `guessBestFormat()` method as specified. Rely on the Negotiation
library if you think it's worth using it ;-)

The `Accept` header can be found in `$_SERVER['HTTP_ACCEPT']`.


#### Add A Response Class

The following `Response` class will be used:

```php
<?php

namespace Http;

class Response
{
    private $content;

    private $statusCode;

    private $headers;

    public function __construct($content, $statusCode = 200, array $headers = array())
    {
        $this->content    = $content;
        $this->statusCode = $statusCode;
        $this->headers    = array_merge('Content-Type' => 'text/html'), $headers);
    }

    public function getStatusCode()
    {
        return $this->statusCode;
    }

    public function getContent()
    {
        return $this->content;
    }

    public function sendHeaders()
    {
        http_response_code($this->statusCode);

        foreach ($this->headers as $name => $value) {
            header(sprintf('%s: %s', $name, $value));
        }
    }

    public function send()
    {
        $this->sendHeaders();

        echo $this->content;
    }
}
```

Update the `process()` method in the `App` class to use this new class:

```php
$response = call_user_func_array($route->getCallable(), $arguments);

if (!$response instanceof Response) {
    $response = new Response($response);
}

$response->send();
```

Now, you can return a string as you used to do **OR** directly return
a `Response` object.

Check everything works.


#### Update Your Controllers

Use the new methods created in the `Request` class, and return a `Response` with
the right content/headers, in each controller's function. You can rely on the
Serializer component, but using `json_encode()` is ok.

You can use a lambda function to factorize some code.

When you return a JSON response, set the right status code to the response. It
has been described in the previous practical.


### Testing

In a terminal, run:

```bash
$ curl -XGET "http://localhost:8090/locations" -H "Accept: application/json"
```

You should see the list of locations as described in _Functional Analysis_.

```bash
$ curl -XGET "http://localhost:8090/locations/1" -H "Accept: application/json"
```

You should see the New York location details as described in _Functional Analysis_.


## Decode Parameters Based On the Content Type

When a request has a body, it should provide a `Content-Type`.
This content type header is available in ` $_SERVER['HTTP_CONTENT_TYPE']`.

Modify the `createFromGlobals()` method to convert a JSON content
(`application/json`) into parameters, and use them as _request_ parameters.

This snippet is useful:

``` php
$data    = file_get_contents('php://input');
$request = @json_decode($data, true);
```


### Testing

Use `var_dump()` to print the `$request` variable in your "post" controller,
and run the following command:

```bash
vagrant@licphp:~ $ curl -XPOST "http://uframework:81/locations" -H "Accept: application/json" -H 'content-type: application/json' -d '{"name":"Paris"}'
```

The same way, you can send `PUT` and `DELETE` requests:

```bash
vagrant@licphp:~ $ curl -XPUT "http://uframework:81/locations/paris" -H "Accept: application/json" -H 'content-type: application/json' -d '{"name":"Paris"}'

vagrant@licphp:~ $ curl -XDELETE "http://uframework:81/locations/paris" -H "Accept: application/json"
```

Going Further
=============

### Testing Automation

Using [Goutte](https://github.com/fabpot/Goutte) or [Buzz
](https://github.com/kriswallsmith/Buzz) HTTP clients, create a simple script
executing scenarios to test your API content negotiation feature.

If you feel like using [PHPUnit](http://phpunit.de/) to implement your tests,
go ahead, it will be useful for your whole php developer life!
