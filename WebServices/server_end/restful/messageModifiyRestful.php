<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 13/10/14
 * Time: 10:37 PM
 */
include_once $_SERVER["DOCUMENT_ROOT"].'/lib/controller/messageModifyController.php';
header('Content-Type: application/json');
if($_SERVER['REQUEST_METHOD']==='POST') {
    if($_POST['requestType']==='readMessage'){
        if($messageModify->markMessageAlreadyRead($_POST['messageIDArrays'])){

            echo json_encode(array('requestType'=>'readMessage','success'=>'true'));

        }
        else{
            echo json_encode(array('requestType'=>'readMessage','success'=>'false'));

        }

    }
    else{
        echo json_encode(array('requestType'=>'readMessage','success'=>'false'));

    }

}
else{
    echo json_encode(array('requestType'=>'readMessage','success'=>'false'));

}