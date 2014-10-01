<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 13/08/14
 * Time: 11:36 PM
 */

session_start();
unset($_SESSION['username']);
header('location:login.php');