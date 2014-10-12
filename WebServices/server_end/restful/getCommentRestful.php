<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 7/10/14
 * Time: 11:31 PM
 */


include_once $_SERVER["DOCUMENT_ROOT"].'/lib/controller/commentController.php';
header('Content-Type: application/json');

if($_SERVER['REQUEST_METHOD']==='POST') {
    if(isset($_POST['requestType']) && isset($_POST['imageID'])){
            $comment->returnComments($_POST['imageID']);

        echo json_encode(array('success'=>'true','comments'=>$comment->getFinalComment()));
    }
    else{

        echo json_encode(array('success'=>'false'));
    }
}
else{

    echo json_encode(array('success'=>'false'));


}