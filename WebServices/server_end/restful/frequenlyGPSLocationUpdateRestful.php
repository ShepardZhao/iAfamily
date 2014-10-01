<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 8/09/14
 * Time: 4:15 PM
 */
include_once $_SERVER["DOCUMENT_ROOT"].'/lib/controller/gpsLocationController.php';
header('Content-Type: application/json');

if($_SERVER['REQUEST_METHOD']==='POST'){
    if(isset($_POST['latitude']) && isset($_POST['longitude']) && isset($_POST['userId'])){
       echo $gps->updateLocationByUseId($_POST['longitude'],$_POST['latitude'],$_POST['userId']);
    }



}
