<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 13/08/14
 * Time: 4:11 PM
 */

include_once $_SERVER["DOCUMENT_ROOT"].'/lib/controller/userInfoFetchController.php';
header('Content-Type: application/json');
if($_SERVER['REQUEST_METHOD']==='POST'){

    if($_POST['requestType'] === 'AllUsers' && !empty($_POST['userId'])){
        $userInfoFetch ->fetchSpecificUsersInfoApi($_POST['userId']);
        $returnInfoFetch = $userInfoFetch->execute();
        echo json_encode($returnInfoFetch[0]);
    }

}