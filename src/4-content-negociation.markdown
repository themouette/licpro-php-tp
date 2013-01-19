Content negociation
===================

**WARNING:** Before starting this pracical, a working _µFramework_
implementation is required.

Goal of this practical is to implement a simple content negociation layer in
your `µFraework`.

By the end of this session your server will serve ressources in:

* `HTML` using a template
* `JSON` encoded data
* `XML` encoded data

Your implementation will also accept parameters encoded in:

* `application/form-url-encoded`
* `application/json`

Theory
------

Content negociation is a part of `HTTP` protocol used to serve a media in the
best format for a client.
[RFC 2616: HTTP/1.1](http://pretty-rfc.herokuapp.com/RFC2616) - [content
negociation chapter](http://www.w3.org/Protocols/rfc2616/rfc2616-sec12.html).

Content negociation means that a single ressource can be presented in different
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


Add content negociation for ressource presentation
--------------------------------------------------

### Functional analysis (requirements)

First things first,

### Conception

### Implementation

### Testing

Decode parameters from content type
-----------------------------------



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
* `PSON` (PHP serialized Object Notation);
* etc.

### Testing automation

Using [Goute](https://github.com/fabpot/Goutte) or [Buzz
](https://github.com/kriswallsmith/Buzz) HTTP clients, create a simple script
executing scenarios to test your API content negociation feature.

If you feel like using [phpunit](http://phpunit.de/) to implement your tests,
go ahead, it will be useful for your whole php developper life !
