The End
-------

This is your last practical, hurray!
First of all, if you didn't see these tweets yet, it's worth reading them:

* [https://twitter.com/couac/status/298754120653881344](https://twitter.com/couac/status/298754120653881344)
* [https://twitter.com/jeffsussna/status/299199722625855489](https://twitter.com/jeffsussna/status/299199722625855489)


## Introduction

The topic of this practical is to improve your REST API by allowing filtering
results.

At the moment, your API returns collections of resources, for instance a set of
locations, or a set of comments.

**But**, what if you want to return the last 5 comments? Or the locations
ordered by _name_?

First of all, you need to understand how a client will perform a request for
such a use case:

    GET /comments?limit=5&orderBy=createdAt

This literally means:

    Give me the last 5 comments

If you decompose the URI, the client adds two parameters to the **query
string**: `limit` and `orderBy`.

* `limit` stands for "number of results to return";
* `orderBy` is a criteria.

This criteria will be passed to the Model Layer, in order to fetch the results
the right way. In this example, the results in the database will be ordered by
date.

The SQL query will look like:

``` sql
SELECT * FROM comments
ORDER BY created_at
LIMIT 0, 5
```


## What You Have To Do

Your job is to modify your _Finders_ to allow the use of criterias.

Your `find*()` methods need a `$criterias` parameter. This parameter will modify
the SQL queries by adding SQL clauses like `LIMIT`, `ORDER BY`, `WHERE`, and so
on.

Write tests to prove everything works fine.

Now, update your controllers to allow filtering results. It only makes sense on
collections. You should be able to:

1. limit the number of results;
2. order results by a given column and a given direction (`ASC` or `DESC`).

That's all folks!
