<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 28/08/14
 * Time: 12:00 AM
 * Message type is adding user to family
 *
 */

include_once $_SERVER["DOCUMENT_ROOT"].'/lib/controller/messageInvitationController.php';
header('Content-Type: application/json');
if($_SERVER['REQUEST_METHOD']==='POST'){
    if(!empty($_POST['requestType'])){
        if(!empty($_POST['sender']) &&!empty($_POST['receiver']) && !empty($_POST['invitator']) && !empty($_POST['senderName'])){
            $message ->setSenderAndReceiverAndMessageType($_POST['sender'],$_POST['receiver'], $_POST['invitator'] ,$_POST['senderName'],$_POST['invitatorHeadImageUrl']);

            if($message->senderMessage()){

                echo json_encode(array('type'=>'message','success'=>'true'));

            }
            else{
                echo json_encode(array('type'=>'message','success'=>'false','reason'=>'repeated'));

            }
        }
        else{
            echo json_encode(array('type'=>'message','success'=>'false'));

        }
    }
    else{
        echo json_encode(array('type'=>'message','success'=>'false'));
    }





}