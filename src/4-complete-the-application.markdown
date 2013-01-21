Complete The Application
========================

In this practical, you will continue to write your own micro-framework.

**Important:** You have to finish the previous practical to start that one.


## Introduction

Since last week, you are building your own framework and an application that leverages
this framework. The aim of the last practical was to discover the framework,
its architecture, to understand what you have to do, and to start playing with it.

In this practical, you have to build a complete web application. You have to provide
a web application that can **list** a set of locations, **create** new ones, but also
**delete** and **update** existing locations.

This application has to be designed like a **RESTful API**. However, it won't be a **true**
API at the moment, because you need to provide a user interface. Basically, you have to
design the **Controller Layer** like a REST API, but you will render HTML templates.

In the next practical ([#5](5-content-negotiation.html)), you will write a **true** API
on top of what you have to do today.

At the end, you will get an awesome application that combines a web application **and** a
REST API. Nowadays, that's the state of the art in web development.



## The Model Layer

You implemented a nice **Model Layer** in the previous practical. In order to be
consistent, implement the following `PersistenceInterface` interface:

``` php
<?php

namespace Model;

interface PersistenceInterface
{
    /**
     * @param string $name Name of the new location
     *
     * @return int Id of the new location
     */
    public function create($name);

    public function update($id, $name);

    public function delete($id);
}
```

This interface should be added to your project (`src/Model/PersistenceInterface.php`).

It should be a matter of renaming your methods into the `Locations` class.


## The Request Class

You should know that a web application is about **converting a request into a
response**. A client sends a request to a server, and the server returns a
response.

In uFramework, there is no `Request` object, and it's quite bad. That's why you
will create it in `src/Http/Request.php`:

``` php
<?php

namespace Http;

class Request
{
}
```


### Using the Request In uFramework

1. Modify the method `run()` in the `App` class to take an optional `Request`
object as parameter.

2. Move the constants (`GET`, `POST`, etc.) from the `App` class to the
`Request` class, and updates the `App` class to use them.

3. Create the first two new methods in the `Request` class:

* `getMethod()`: returns the method (aka HTTP verb);
* `getUri()`: returns the URI.

Look at the code of the `run()` method in the `App` class to know how to
implement these methods. Basically, it's just copy and paste.

**Important:** we will use the term _method_ to describe the HTTP verb (`GET`,
`POST`, etc.).

The URI is what you described in previous practical. Add the following code to
the `getUri()` method:

``` php
if ($pos = strpos($uri, '?')) {
    $uri = substr($uri, 0, $pos);
}
```

It will remove the query string from the `REQUEST_URI` value:

    /locations?foo=bar

What we want here is `/locations`. The query string starts after the `?` sign:
`foo=bar`.


4. Use these methods in the `run()` method of the `App` class:

``` php
public function run(Request $request = null)
{
    $method = $request->getMethod();
    $uri    = $request->getUri();

    // ...
}
```

5. Implement a **static** method in the `Request` class to create a new
`Request` instance. This method **HAS** to be named `createFromGlobals()`.

Returning an instance of the current class can be achieved using the following
code:

``` php
return new self();
```

This method will contain more logic later, but by now, it should just return a
new instance.

6. Update the `run()` method to create a `Request` object if the argument is
`null`:

``` php
if (null === $request) {
    $request = Request::createFromGlobals();
}
```


### Using The Request In Your Application's Controllers

At the moment, your `Request` class does not do a lot of work. You just moved
some code into it. Actually, it's better for something we call **Separation of
Concerns**. It's Request's responsability to determine the _method_ used by the
client.

You know that a web application is about converting a _request_ into a
_response_. In a **Model View Controller** architecture, this is handled by the
**Controller Layer**. So, it seems like a good idea to inject the `Request` in
your controllers:

``` php
$app->get('/locations', function (Request $request) use ($app) {
});
```

You may wonder why we don't pass the `$request` instance in the closure's
context. That's a good question. Actually, you can consider the closure's
context as a _shared_ or _global_ context.

In order to inject the `Request` in your controllers, you will have to modify
the `App` class. First, you have to pass the `$request` instance from the
`run()` method to the `process()` method.

Then, update the code of the `process()` method to add the `$request` as first
argument:

``` php
$arguments = $route->getArguments();
array_unshift($arguments, $request);

$response = call_user_func_array($route->getCallable(), $arguments);
```

Now, it will automatically inject a `Request` instance **as first argument**  in
your closures.

> **Note:** The **Controller Layer** is located in the `app/app.php` file. A
> specific _controller_ is represented by a _closure_ in this application.


### Abstracting Global Variables

In PHP, you can access data via `$_GET` and `$_POST`. You could use them, but
now that you have a `Request` class, you should rely on it.

> **Note:** Avoid the use of global variables in your code, as much as you can.
> Use classes that can abstract these variables. That's why you have a `Request`
> class.

Add a constructor method to your `Request` class:

``` php
__construct(array $query = array(), array $request = array())
```

`$query` is an array of `GET` parameters (`$_GET`). We use the term `query` as
these parameters are part of the **Query String**.

`$request` is an array of `POST` parameters (`$_POST`). We use the term `request`
as these parameters are part of the **Request Body**.

Declare a new attribute named `$parameters` in your `Request` class, and
initialize it in the constructor by merging both `$query` and `$request`.

Implement a new method:

``` php
public function getParameter($name, $default = null)
{
}
```

Modify the `createFromGlobals()` method to inject the global variables.


## Completing your application

Now that you have a working `Request` class, you can write your application.


### Fixing The Browser

You know that a RESTful application leverages the HTTP verbs. Unfortunately, web
browsers only support `GET` and `POST`. In order to by pass this limitation, we
will use a _hack_.

The hack consists in using a hidden parameter in the request that defines the
real HTTP verb the client wants to use. In a form, you will set the `POST`
method, and use a hidden field named `_method` with the real HTTP verb:

``` html
<form action="..." method="POST">
    <input type="hidden" name="_method" value="PUT" />
</form>
```

Modify the `getMethod()` method in your `Request` class to use this hack. This
snippet could be useful:

``` php
if (self::POST === $method) {
    return $this->getParameter('_method', $method);
}
```


### Creating New Resources

In a RESTful application, we use the `POST` HTTP verb to create new resources,
and we "post" data to the collection.

In your application, you will have to "post" data to `/locations`. It will call
the corresponding action registered in your application:

``` php
$app->post('/locations', function () use ($app) {
   // this is the corresponding action
});
```

> **Note:** Generally speaking, the term **action** represents a method in a controller.
> As you don't use a controller class, but a closure, the term **action** represents
> this closure.

In a browser, you can call this action by using a `form`. The following code could be
added to the `app/templates/locations.php` template:

```
<form action="/locations" method="POST">
    <label for="name">Name:</label>
    <input type="text" name="name" />

    <input type="submit" value="Add New" />
</form>
```

The user data will be accessible through the `Request` object.

``` php
$request->getParameter();
```

Once you created a new location, redirect the user to the list. It should be
done for two reasons:

* if the user reloads the page, it won't create a new location again;
* it's better for the user experience.

Redirecting the user requires a new method in the `App` class:

``` php
public function redirect($to, $statusCode = 302)
{
    http_response_code($statusCode);
    header(sprintf('Location: %s', $to));

    die;
}
```

Now you can redirect the user to the list view by using:

``` php
$app->redirect('/locations');
```

> _Note:_ a REST API should return a `201` status code which stands for
> `Created`. It will be useful for the next practical. By now, you can
> live without that.


### Updating An Existing Resource

In a RESTful application, we use the `PUT` HTTP verb to update an existing
resource, and we "put" updated data to the resource we want to update.

In your application, you will have to "put" data to `/locations/id`. It will
call the corresponding action registered in your application:

``` php
$app->put('/locations/(\d+)', function (Request $request, $id) use ($app) {
});
```

Why `/locations(\d+)`? The following methods `get()`, `post()`, `put()`, and
`delete()` take a regular expression as first argument. It defines the pattern
for each URI you want to implement.

`(\d+)` means numbers. Each URI MUST be unique, that's why we use numbers to
identify a specific resource.

This number will be injected in your controller's closure, that's why we
declare the `$id` parameter.

The first thing to do in this function is to retrieve your model object by its
identifier. You can rely on the `findOneById()` method, part of the `FinderInterface`
interface.

If the object doesn't exist, you will get `null`. In this case, you will have to
return a `HttpException` with status code `404` which stands for `Not Found`:

``` php
throw new HttpException(404, "Object doesn't exist");
```

If you get an object, then you will have to update it using the user data.

As we saw in section _Fixing The Browser_, we can't use the `PUT` keyword in
your form, so we need to use a special parameter, using a hidden field, and the
`POST` method in the form.

The following code could be added to the `app/templates/location.php` template:

```
<form action="/locations/<?= $id ?>" method="POST">
    <input type="hidden" name="_method" value="PUT" />
    <input type="text" name="name" value="<?= $location ?>" />
    <input type="submit" value="Update" />
</form>
```

The user data will be accessible through the `Request` object.

``` php
$request->getParameter();
```

Redirect the user to the detail view of the updated location once the
location is updated.


### Deleting A Resource

In a RESTful application, we use the `DELETE` HTTP verb to delete resources,
and we "delete" a resource.

In your application, you will have to "delete" a resource at `/locations/id`. It
will call the corresponding action registered in your application:

``` php
$app->delete('/locations/(\d+)', function (Request $request, $id) use ($app) {
});
```

The first thing to do in this function is to retrieve your model object by its
identifier. You can rely on the `findOneById()` method, part of the`FinderInterface`
interface.

If the object doesn't exist, you will get `null`. In this case, you will have to
return a `HttpException` with status code `404` which stands for `Not Found`:

``` php
throw new HttpException(404, "Object doesn't exist");
```

If you get an object, then you can delete it.

As we saw in section _Fixing The Browser_, we can't use the `DELETE` keyword in
your form, so we need to use a special parameter, using a hidden field, and the
`POST` method in the form:

The following could be added to the `app/templates/location.php` template:

```
<form action="/locations/<?= $id ?>" method="POST">
    <input type="hidden" name="_method" value="DELETE" />
    <input type="submit" value="Delete" />
</form>
```

Redirect the user to the list view.

> _Note:_ a REST API should return a `204` status code which stands for
> `No Content`. You will need this information in the next practical.


## The End

You should have a working web application. Jump to [the next practical](5-content-negotiation.html).
