<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 23/08/14
 * Time: 3:05 PM
 */


include_once $_SERVER["DOCUMENT_ROOT"].'/lib/controller/imageUploadController.php';
header('Content-Type: application/json');

if($_SERVER['REQUEST_METHOD']==='POST'){

    //set destination
    $imageUpload -> setDestination($_SERVER["DOCUMENT_ROOT"].'/users_assets/'.$_POST['userId'].'/header_profile/');
    //set file name
    $imageUpload -> setFileName($_FILES[0]["name"]);
    //set print error
    $imageUpload -> setPrintError($_FILES[0]["error"]);
    //set max size
    $imageUpload -> setMaxSize($_FILES[0]["size"]);
    //set type
    $imageUpload -> setType($_FILES[0]["type"]);
    //get image name
    //resize image
    $imageUpload -> upload($_FILES[0]['tmp_name']);


  echo  ($imageUpload->updateHeaderProflieForUserTable('/users_assets/'.$_POST['userId'].'/header_profile/'.$imageUpload-> getfilename().'.jpeg',$_POST['userId'])) ? json_encode(array('file'=>$_FILES,'success'=>'true')) : json_encode(array('success'=>'false'));





}




