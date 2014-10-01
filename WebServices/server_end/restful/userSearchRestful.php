<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 27/08/14
 * Time: 5:27 PM
 */


include_once $_SERVER["DOCUMENT_ROOT"].'/lib/controller/SearchUserController.php';
header('Content-Type: application/json');

if($_SERVER['REQUEST_METHOD']==='POST'){

    if(!empty($_POST['requestType']) && !empty($_POST['requestString'])){

        echo json_encode(array('type'=>'searchUser','success'=>'true','searchResult'=>$searchUser -> searchResult($_POST['requestString'])));
    }
    else{
        echo json_encode(array('type'=>'searchUser','success'=>'false'));

    }



}