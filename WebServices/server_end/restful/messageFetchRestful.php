<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 1/09/14
 * Time: 4:10 PM
 */

include_once $_SERVER["DOCUMENT_ROOT"].'/lib/controller/messageFetchController.php';
header('Content-Type: application/json');

if($_SERVER['REQUEST_METHOD']==='POST'){
    //fetch the number of Messages
    if($_POST['requestType']==='fetchTotalNumberOfMessages'){
         if(!empty($_POST['requestUserID'])){

            $messageFetch->requesting($_POST['requestUserID']);

            echo json_encode(array('requestType'=>'messageFetching','success'=>'true','messageNumbers'=>$messageFetch->getNumberOfMessages()));


        }
        else{
            echo json_encode(array('requestType'=>'messageFetching','success'=>'false'));

        }
    }
    else if($_POST['requestType'] === 'fetchDetailOfMessages'){
        //fetch messages detail
        if(!empty($_POST['requestUserID'])){
            $messageFetch->detailRequesting($_POST['requestUserID']);
            echo json_encode(array('requestType'=>'fetchAllMessagesDetail','success'=>'true','messageDetails'=>$messageFetch->getAllDetaillOfMessages()));
        }
        else{
            echo json_encode(array('requestType'=>'fetchAllMessagesDetail','success'=>'false'));

        }



    }



}