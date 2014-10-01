<?php
/**
 * The Restful API:
 * User: Shepard
 * Date: 4/08/14
 * Time: 10:06 PM
 */

include_once $_SERVER["DOCUMENT_ROOT"].'/lib/controller/registerController.php';
header('Content-Type: application/json');

if($_SERVER['REQUEST_METHOD']==='POST'){
    if(!empty($_POST['email']) && !empty($_POST['password']) && !empty($_POST['name']) && !empty($_POST['age']) && !empty($_POST['phone'])  && !empty($_POST['gender'])){

        $Register = new Register($_POST['email'],$_POST['password'],$_POST['name'],$_POST['age'],$_POST['phone'],$_POST['gender']);
        $Register -> registerApi();
        echo $Register -> execute();


    }
    else{
        echo json_encode(array('request'=>'failure'));

    }




}