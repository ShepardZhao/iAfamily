<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 4/08/14
 * Time: 4:41 PM
 */



 class DatabaseSingletonModel extends mysqli {

    public function __construct($host, $user, $pass, $db) {
        parent::__construct($host, $user, $pass, $db);

        if (mysqli_connect_error()) {
            die('Connect Error (' . mysqli_connect_errno() . ') '
                . mysqli_connect_error());
        }
    }

 }