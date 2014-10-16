<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 3/09/14
 * Time: 3:48 PM
 */

include_once $_SERVER["DOCUMENT_ROOT"].'/lib/controller/userAcceptOrDeclineFamilyInvitationController.php';
header('Content-Type: application/json');

if($_SERVER['REQUEST_METHOD']==='POST'){

    //1.get user id, get family id, requestType
    //2.put current user into  that special family group
    //3.update message status to 0 - compete

  if($_POST['requestType'] ==='accept'){

    if(!empty($_POST['user_id']) && !empty($_POST['family_id']) && !empty($_POST['message_id'])){

        $acceptOrDeclineFamily -> initialParamters($_POST['user_id'],$_POST['family_id'],$_POST['message_id']);

        $status=$acceptOrDeclineFamily -> updateStatus();

        if($status){
            echo json_encode(array('requestType'=>'userAcceptFamilyInvitation','status'=>'accept','success'=>'true'));
        }
        else{
            echo json_encode(array('requestType'=>'userAcceptFamilyInvitation','success'=>'false'));
        }
    }


  }
    elseif ($_POST['requestType'] === 'decline'){

            //will request message id only
        $status=$acceptOrDeclineFamily -> cancelMessage($_POST['message_id']);
        if($status){
            echo json_encode(array('requestType'=>'userDeclineFamilyInvitation','status'=>'decline','success'=>'true'));
        }
        else{
            echo json_encode(array('requestType'=>'userDeclineFamilyInvitation','success'=>'false'));
        }


    }
    else{
            echo json_encode(array('requestType'=>'userAcceptFamilyInvitation','success'=>'false'));
    }




}