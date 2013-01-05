Discover PHP
============

Interactive command line
------------------------

All this section will take place in the virtual machine.
Access it through ssh :

    $ vagrant ssh
    vagrant@vm-licpro:~$ php -a

### 1. Hello world

``` php
php > echo "Hello world";
hello world

php > print "Hello world";
hello world

php > echo sprintf("Hello %s", "Votre prénom");
Hello Votre prénom
```


### 2. Variables

``` php
php > $a = 1;
php > var_dump($a);
int(1)

php > $b = 3;
php > printf("%d + %d = %d", $a, $b, $a + $b);
1 + 3 = 4

php > $b = "foo";
php > var_dump($b);
string(3) "foo"

php > print_r($b);
foo

php > echo var_export($b);
'foo'
```

### 3. Include

In host machine, create `DOCROOT/tp1/shell.php` and insert :

``` php
<?php
$foo = 1;
```

Then, from interactive shell in virtual machine :

``` php
php > var_dump($foo);   // foo is not defined
PHP Notice:  Undefined variable: foo in php shell code on line 1
NULL

php > include "/vat/www/tp1/shell.php";
php > var_dump($foo);   // all code in file is executed
int(1)
```

Apache environment
------------------

Configure an alias as described in tutorial :

    $ vagrant ssh
    vagrant@vm-licpro:~$ php -a
    vagrant@vm-licpro:~$ echo "Alias /tp1 /var/www/tp1/public" | sudo \
                                tee -a /etc/apache2/sites-available/tp1
    vagrant@vm-licpro:~$ sudo a2ensite tp1
    vagrant@vm-licpro:~$ sudo apache2ctl restart

### 1. Check it works

Create `DOCROOT/tp1/public/index.php` and insert :

``` php
<!DOCTYPE HTML>
<html>
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <title>Bienvenue</title>
    </head>
    <body>
        <p>Félicitatations <?php echo "Votre prénom" ?></p>
    </body>
</html>
```

Open your browser at `http://localhost:8080/tp1/index.html`

You should see a congratulation message.

### Client and server


### MVC architecture

let's create a few dirs and files :

    $ mkdir -p DOCROOT/tp1/{public,model,view}
    $ touch DOCROOT/tp1/public/cities.php DOCROOT/tp1/model/cities.php DOCROOT/tp1/view/cities.php

``` php
<?php
// DOCROOT/tp1/public/cities.php

// include model
include __DIR__ . '/../model/cities.php';

// include view
include __DIR__ . '/../view/cities.php';
```

``` php
<?php
// DOCROOT/tp1/model/cities.php
$cities = array(
    array("name" => "San Francisco", "country" => "USA"),
    array("name" => "Paris", "country" => "France"),
    array("name" => "New york", "country" => "USA"),
    array("name" => "Berlin", "country" => "Germany"),
    array("name" => "Bamako", "country" => "Malia"),
    array("name" => "Buenos Aires", "country" => "Argentina"),
    array("name" => "Santiago", "country" => "Chile"),
    array("name" => "Bombay", "country" => "India"),
    array("name" => "Vancouver", "country" => "Canada"),
);
```

``` php
<!-- DOCROOT/tp1/view/cities.php -->
<!DOCTYPE HTML>
<html>
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <title>All cities</title>
    </head>
    <body>
        <h1>All cities</h1>
        <table>
        <?php foreach($cities as $city_id => $city): ?>
            <tr>
                <td><a href="/tp1/city.php?id=<?php echo $city_id; ?>"><?php echo $city["name"]; ?></a></td>
                <td><?php echo $city["country"]; ?></td>
            </tr>
        <?php endforeach; ?>
        </table>
    </body>
</html>
```

open `http://localhost:8080/tp1/cities.php`

### Add a dynamic controller

Let's define a page to present a city :

``` php
<?php
// DOCROOT/tp1/public/city.php
include __DIR__ . '/../model/cities.php';

/**
 * render a 404 page
 */
function page_not_found()
{
    header("HTTP/1.0 404 Not Found");
    include __DIR__ . '/../view/404.html';
    die();
}

// retrieve id from url parameter
$city_id = $_GET["id"];
if (empty($city_id) || !is_numeric($city_id) || !isset($cities[$city_id])) {
    // No id given or invalid id
    page_not_found();
}

// retrieve city from dataset
$city = $cities[$city_id];
// define some more variables
$title = sprintf("City %s", $city["name"]);

// include view
include __DIR__ . '/../view/city.php';
```

``` php
<!-- DOCROOT/tp1/view/city.php -->
<!DOCTYPE HTML>
<html>
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <title><?php echo $title ?></title>
    </head>
    <body>
        <h1><?php echo $city["name"] ?></h1>
        <footer>
            <a href="/tp1/cities.php">Back to list</a>
        </footer>
    </body>
</html>
```

``` html
<!-- DOCROOT/tp1/view/404.html -->
<!DOCTYPE HTML>
<html>
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <title>Not found</title>
    </head>
    <body>
        <h1>404 not found</h1>
        <footer>
            <a href="/tp1/cities.php">Back to list</a>
        </footer>
    </body>
</html>
```

Cli environment
---------------

All cli programs are run into the virtual machine.

It is possible to invoke `php` directly form command line and give file as
first argument :

    $ php my/file.php

or you can use the `#!/usr/bin/env php` header and make file executable :

    $ echo "#!/usr/bin/env php" > /your/php/file.php
    $ chmod a+x /your/php/file.php

then simply invoke the script by runing :

    $ /your/php/file.php

### Our first cli programm

Let's write "Hello world !" in the console :

Create file `DOCROOT/projects/tp1/cli/hello.php` with following content :

``` php
#!/usr/bin/env php
<?php

echo "Hello world\n";
```

### User interractions

Create file `DOCROOT/projects/tp1/cli/hello-you.php` with following content :

``` php
#!/usr/bin/env php
<?php

echo "Enter your name: ";
$name = trim(fgets(STDIN));

printf("Hello %s\n", $name);
```

### Command line arguments

Let's create a command adding an alias to apache.
In the file `DOCROOT/projects/tp1/cli/a2AddAlias`

``` php
#!/usr/bin/env php
<?php

function usage($exitCode = 1)
{
    echo <<<EOF
Usage:

sudo a2AddAlias tp1 /var/www/tp1/public

EOF;
    exit($exitCode);
}

// retrieve arguments and validate
if ($argc !== 3) {
    usage();
}

$alias = $argv[1];
$dir = $argv[2];

// check file exists
if (!file_exists($dir)) {
    printf("Directory %s does not exist", $dir);
    usage(0);
}

// only  characters are allowed in alias name
if (!preg_match('#^\w+$#', $alias)) {
    printf("Alias %s contains illegal characters", $alias);
    usage();
}

// generate alias template
$template = <<<EOF
# Generated on %date%
Alias /%alias% %dir%
EOF;

$content = strtr($template, array(
    '%date%'    => date('l jS \of F Y h:i:s A'),
    '%dir%'     => $dir,
    '%alias%'   => $alias
));

$filename = sprintf('/etc/apache2/sites-available/%s', $alias);
file_put_contents($content, $filename);
system(sprintf('a2ensite %s', $alias));
system('apache2ctl restart');
```

Exercises
---------

### Filter cities by country

Add a link to country list and create page for a country, listing all its
cities.

### Data store

Read cities from a csv file :

``` csv
San Francisco;USA
Paris;France
New york;USA
Berlin;Germany
Bamako;Malia
Buenos Aires;Argentina
Santiago;Chile
Bombay;India
Vancouver;Canada,
```

and create a command line program to add one at the end.

You might need [filesytem related functions](http://php.net/manual/en/ref.filesystem.php)
and [explode](http://fr2.php.net/manual/en/function.explode.php).
