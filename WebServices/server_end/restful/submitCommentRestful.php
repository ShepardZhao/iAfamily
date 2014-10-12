<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 7/10/14
 * Time: 9:13 PM
 */


include_once $_SERVER["DOCUMENT_ROOT"].'/lib/controller/commentController.php';
header('Content-Type: application/json');

if($_SERVER['REQUEST_METHOD']==='POST'){

    if(isset($_POST['requestType']) && isset($_POST['userId']) && isset($_POST['imageID']) && isset($_POST['commentContent']) && isset($_POST['commentType']) && isset($_POST['commentID'])) {

        $comment ->initialParameters($_POST['userId'], $_POST['imageID'],$_POST['commentContent'], $_POST['commentType'],$_POST['commentID']);
        if($comment -> insertComment()){

            echo json_encode(array('success'=>'true'));
        }


    }
    else{

        echo json_encode(array('success'=>'false'));

    }


}