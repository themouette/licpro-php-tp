Content negotiation
===================

**WARNING:** Before starting this pracical, a working _µFramework_
implementation is required.

Goal of this practical is to implement a simple content negotiation layer in
mmyour `µFramework`.

By the end of this session your server will serve ressources in:

* `HTML` using a template
* `JSON` encoded data
* `XML` encoded data

Your implementation will also accept parameters encoded in:

* `application/form-url-encoded`
* `application/json`

Theory
------

Content negotiation is a part of `HTTP` protocol used to serve a media in the
best format for a client.

[RFC 2616: HTTP/1.1](http://pretty-rfc.herokuapp.com/RFC2616) - [RFC 2295:
content negotiation](http://pretty-rfc.herokuapp.com/RFC2295).

Content negotiation means that a single ressource can be presented in different
ways, depending on the client. To achieve this goal, `HTTP headers` are used by
a client to present accepted formats. Based on this `Accept` header, server can
guess the best content to deliver.

Here is an example:

    #Client
    GET /locations/new-york HTTP/1.1
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
    GET /locations/new-york HTTP/1.1
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

    {"id":"new-york","name":"New York"}


Add content negotiation for ressource presentation
--------------------------------------------------

### Functional analysis (requirements)

First things first, grab a piece of paper and write an example of
`GET /locations/new-york` response for every format and call for validation.

### Conception

**Guess the best format to return**

It is Request object responsbility to resolve best format to serve, so we'll
need a guessBestFormat method.

[Negotiation](https://github.com/willdurand/negotiation) will help to get the
best format from headers by handling content negotiation.

Thanks to this new method, it is now possible to render different content based
on the best fit.

**Format the right way**

Your controllers will be updated to handle formats.

HTML rendering is achieved through your template engine, serialization has to
be handled by a Serializer. This serializer can be as simple as `json_encode`
or you can use [Serializer component](
http://symfony.com/doc/current/components/serializer.html).

**Introduce a Response object**

To fit HTTP protocol every response should contain at least:

* a Content-Type header to describe the content
* a status code to give feedback on what happened
* the content or body of the response.

That makes a lot of things to handle, it cannot all fit in the App class. A
`Response` class will be in charge of response configuration and formatting.

### Implementation

#### Install composer

In virtual machine, just run:

```bash
vagrant@licphp:~ $ curl -s https://getcomposer.org/installer | php
vagrant@licphp:~ $ sudo mv composer.phar /usr/local/bin/composer
```

More details on [composer homepage](http://getcomposer.org).

#### Create `composer.json` file

In your project root, just copy the following in a `composer.json` file:

```json
{
    "require": {
        "symfony/serializer": "~2.1",
        "willdurand/negotiation": "1.0.*@dev"
    },

    "autoload": {
        "psr-0": {"": "src/"}
    }
}
```

then run:

```bash
vagrant@licphp:~$ composer install
```

#### Replace your autoloader with composer's one

In `app/app.php`, just replace autoloader with `vendor/autoload.php`, check
that website is functional as before.

#### Update request

Create the `guessBestFormat` method as specified.

#### Complete `Response` class

Following `Response` class will be used:

```php
<?php
namespace Response;

class Response
{
    private $headers = array();
    private $statusCode;
    private $content;

    /**
     * create a new Response with $content
     */
    public function __construct($content = '', $statusCode = 200)
    {
        $this->setContentType('text/html');
        $this->setStatusCode($statusCode);
        $this->setContent($content);
    }

    /**
     * set response status code
     * @param integer $statusCode
     */
    public function setStatusCode($statusCode)
    {
        $this->statusCode = $statusCode;
    }

    /**
     * add a header to response
     */
    public function addHeader($name, $value)
    {
        $name = ucwords($name);
        $this->headers[$name] = $value;
        return $this;
    }

    /**
     * set response content type
     * @param string $contentType
     */
    public function setContentType($contentType = 'text/html')
    {
        $this->addHeader('Content-Type', $contentType);
        return $this;
    }

    public function setContent($content)
    {
        $this->content = $content;
        return $this;
    }

    /**
     * redirect to $to.
     */
    public function redirect($to, $statusCode = 302)
    {
        $this->addHeader('Location', $to);
        $this->setStatusCode($statusCode);
        return $this;
    }

    /**
     * send request headers.
     * add content length if not given.
     */
    public function sendHeaders()
    {
        http_response_code($this->statusCode);

        foreach ($this->headers as $name => $value) {
            header(sprintf("%s: %s", $name, $value));
        }
    }

    /**
     * send the response headers and content to client.
     */
    public function send()
    {
        $this->sendHeaders();
        echo $this->content;
    }
}
```

Update `App` class `process` method:

```php
$response = call_user_func_array($route->getCallable(), $route->getArguments());
if (!$response instanceof Response) {
    $response = new Response($response);
}
$response->send();
```

From now on, you can return a string as you used to do **OR** directly return
a `Response` object.

Check everything works as previously.

#### update your controllers



### Testing

In a terminal, run:

```bash
$ curl -XGET "http://localhost:8090/locations" -H "Accept: application/json"
```

You should see the list of locations just as described in `Functional analysis`.

```bash
$ curl -XGET "http://localhost:8090/location/new-york" -H "Accept: application/json"
```

You should se New York location details as described in `Functional analysis`.

Decode parameters from content type
-----------------------------------

When a request has a body, it should provide a `content type`.
This `content type` header is available in ` $_SERVER["CONTENT_TYPE"]`.

### Decode response content

Add following function to your `Request` class and call it in the
`createFromGlobals` method when content type is `application/json`.

```php
static function decodeJSONBody()
{
    try
    {
        $data = file_get_contents('php://input');
        $data = json_decode($data, true);
        switch(json_last_error()) {
            case JSON_ERROR_NONE:
                return $data;
            break;
            case JSON_ERROR_DEPTH:
                throw new InvalidArgumentException('Maximum stack depth exceeded');
            break;
            case JSON_ERROR_STATE_MISMATCH:
                throw new InvalidArgumentException('Underflow or the modes mismatch');
            break;
            case JSON_ERROR_CTRL_CHAR:
                throw new InvalidArgumentException('Unexpected control character found');
            break;
            case JSON_ERROR_SYNTAX:
                throw new InvalidArgumentException('Syntax error, malformed JSON');
            break;
            case JSON_ERROR_UTF8:
                throw new InvalidArgumentException('Malformed UTF-8 characters, possibly incorrectly encoded');
            break;
            default:
                throw new InvalidArgumentException('Unknown error');
            break;
        }
    } catch (InvalidArgumentException $e) {
        throw new HttpException(400, $e->getMessage());
    }
}
```

### Testing

```bash
vagrant@licphp:~ $ curl -XPOST "http://uframework:81/locations" -H "Accept: application/json" -H 'content-type: application/json' -d '{"name":"Paris"}'
```

Go further
----------

### More formats

It is possible to render ressources in extra formats, depending on your needs,
For instance you can implement all or parts of:

* Images (`png`, `gif`, `jpeg`): can be rendered with
    [Imagick]( http://php.net/manual/fr/book.imagick.php);
* `PDF`: can be rendered thanks to
    [pdf extension](http://php.net/manual/en/book.pdf.php),
    [Snappy](https://github.com/KnpLabs/snappy), etc;
* etc.

### Testing automation

Using [Goute](https://github.com/fabpot/Goutte) or [Buzz
](https://github.com/kriswallsmith/Buzz) HTTP clients, create a simple script
executing scenarios to test your API content negotiation feature.

If you feel like using [phpunit](http://phpunit.de/) to implement your tests,
go ahead, it will be useful for your whole php developper life !

### Add content type header to response

You'll need a `Response` object with following interface:

