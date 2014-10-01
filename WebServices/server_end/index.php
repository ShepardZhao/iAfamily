<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 5/08/14
 * Time: 5:23 PM
 */



session_start();
if(isset($_SESSION['username'])){
    header('Location: admin.php');
}
else{
    header('Location: login.php');
}


