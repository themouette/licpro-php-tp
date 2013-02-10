Partiel PHP - Lundi 11 Février 2013
-----------------------------------

Documents interdits. Durée : 1h.

Lorsqu'il est indiqué de répondre en une ligne, il est très important de
respecter cette règle. Ne pas respecter cette règle peut entraîner une perte de
points pour cause d'imprécision.


## Questions

1. En une ligne et d'un point de vue HTTP, quel est le rôle d'un serveur web ?


2. Quelle est la différence entre une _closure_  et une _lambda function_ (fonction anonyme) ?


3. En une ligne, qu'est-ce que _l'autoloading_ ?


4. En une ligne, qu'est ce que la session ?


5. Qu'est-ce qu'un "POPO" ?


6. Parmis les fonctions PHP suivantes, quelle est celle qui permet de vérifier
le contenu d'une variable ? (Entourer la bonne réponse)

* `print_r()`
* `var_dump()`
* `var_export()`
* `printf()`
* `error_log()`


7. Quelle fonction permet de déterminer la classe d'une instance ?


8. Corriger ce code :

``` php
<?php

class Foo
{
    private $value;

    function __construct($v)
    {
        $value = $v;
    }
}
```


9. Quel est le nom de la bibliothèque standard ? (Entourer la bonne réponse)

* LSP
* SPL
* PSL


10. Quel verbe HTTP est utilisé pour mettre à jour une ressource ? (Entourer la
bonne réponse)

* UPDATE,
* POST
* PUT
* PATCH


11. Quelle variable va vous servir pour accéder aux variables du corps d'une
requête au format `URL Form Encoded` ? (Entourer la bonne réponse)

* `$_POST`
* `$REQUEST`
* `$_GET`
* `$_REQUEST`


12. Quelle variable va vous servir pour accéder aux variables du corps d'une
requête au format `JSON` ? (Entourer la bonne réponse)

* `$_POST`
* `$REQUEST`
* `$_GET`
* `$_REQUEST`

13. Que signifie "DSN" ?

* Dance Surounded by Nerds
* Data Simple Node
* Data Source Name


14. Que signifie "ORM" ?

* Object Relational Mapping
* Oriented Relation Mapping
* Oriented Rubber Monkey


15. Compléter l'affirmation suivante : "Un contrôleur ..."

* contient la logique métier
* est la logique applicative
* fait le lien entre le modèle et la vue
* poinçonne un ticket


16. Quelle fonction permet d'enregistrer un autoloader ?

* `spl_autoload_register()`
* `__autoload()`
* `register_autoloader()`


17. Donner **deux** avantages des requêtes préparées par rapport à une requête
forgée ?


1. En une ligne, décrire le principe de _routing_.


1. Quel est le pseudo type d'une _closure_ ?


1. Citer **une** méthode magique.


1. Quel est le nom de l'outil de gestion de dépendances que vous avez utilisé en
PHP ?


1. En trois lignes, quelle est la différence entre _Active Record_ et _Data Mapper_ ?


1. A quoi sert le design pattern _Identity Map_ ?


1. Quel est le code HTTP (_status code_) à utiliser dans une réponse à une requête
`DELETE` ?


1. En une ligne, qu'est-ce que le _Content Negotiation_ ?


1. Lorsque l'on écrit un test unitaire, que testons nous ?

* une méthode
* un comportement
* que tout fonctionne

27. En une ligne, à quoi sert un _Finder_ ?


1. En une ligne, que peut-on tester avec un test fonctionnel ?


1. En une ligne, que fait le code suivant :

``` php
<?php

class A {}

class B {}

$A = 'B';
echo get_class(new $A());
```

30. Quel design pattern représente un _Data Access Object_ ?


1. Quelle commande puis-je utiliser pour lancer mon application web sur le
port `4000` ?


1. Corriger ce code :

``` php
<?php

public class Bar
{
    public function __construct()
    {
    }
}
```


33. Décrire, comme cela a été fait en TP, une API de gestion des utilisateurs ?
Les ressources doivent être nommées en anglais. Il est nécessaire de décrire
chaque fonction d'API. Vous devez présenter une API "CRUD". (3 points)


1. Que doit obligatoirement retourner une _réponse HTTP_ ?


1. En deux lignes, expliquer le principe d'une _Data Access Layer_.
