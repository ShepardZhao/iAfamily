<?php
/**
 * Restful API: login api includes the mail and password check, and return the result from the JSON data
 * User: Shepard
 * Date: 4/08/14
 * Time: 10:05 PM
 */

include_once $_SERVER["DOCUMENT_ROOT"].'/lib/controller/loginController.php';
header('Content-Type: application/json');
if($_SERVER['REQUEST_METHOD']==='POST'){


    if(!empty($_POST['loginEmail']) && !empty($_POST['password']) && !empty($_POST['role'])){
        //initial code header
        $login -> loginApi($_POST['loginEmail'],$_POST['password']);

        //distinguish the user login type and use different function

        if($_POST['role']==="admin"){

            $login -> loginValidationByadmin();
        }
        else{
            $login -> loginValidation();
        }


        //return the json result
         echo $login -> execute($_POST['role']);


    }

}



?>