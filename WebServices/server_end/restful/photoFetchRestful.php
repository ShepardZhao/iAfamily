<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 14/09/14
 * Time: 8:39 PM
 */

include_once $_SERVER["DOCUMENT_ROOT"].'/lib/controller/PhotoFetchController.php';
header('Content-Type: application/json');



if($_SERVER['REQUEST_METHOD']==='POST'){
   if($_POST['requestType'] === 'fetchAllImages'){
       if(isset($_POST['requestUserID'])){
           echo  json_encode(array('requestType'=>'fetchAllImages','success'=>'true','imageSets'=>$photoFetch->getImages($_POST['requestUserID'])));

       }


   }




}