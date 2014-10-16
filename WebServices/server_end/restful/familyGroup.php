<?php
/**
 * This file is the family circle restful api, that allowed request to fetch own family circles
 * basically, one register can be creating more than one family circles.
 * Created by PhpStorm.
 * User: Shepard
 * Date: 7/08/14
 * Time: 1:05 PM
 */
include_once $_SERVER["DOCUMENT_ROOT"].'/lib/controller/FamilyController.php';
header('Content-Type: application/json');
if($_SERVER['REQUEST_METHOD']==='POST'){
    $requestType = $_POST['requestType'];
   if(!empty($requestType)){

       //add family group only
       if($requestType === 'add'){

           if(!empty($_POST['userId'])  && !empty($_POST['group_name']) && !empty($_POST['group_desc']) ){
               $family ->initialAddFamily($_POST['group_name'],$_POST['group_desc'],$_POST['userId']);
               echo  $family ->addFamilyApi();
           }
       }


       //modify family group only



       //delete family group only


       //fetch the families according to user id
       if($requestType==='fetchAll'){

           if(!empty($_POST['userId'])){

               echo json_encode(array('type'=>"fetchAll",'success'=>'true','families'=>$family->getFamiliesByUserId($_POST['userId'])));

           }
           else{
               echo json_encode(array('type'=>'fetchAll','success'=>'false'));
           }

       }

       if($requestType==='fetchFamilyMembers'){
           if(!empty($_POST['familyID'])){
               //according to family id to get its members
               echo json_encode(array('type'=>'fetchFamilyMembers','success'=>'true','membersDetails'=>$family->getMembersDetailsByFamilyId($_POST['familyID'])));
           }
           else{
               echo json_encode(array('type'=>'fetchFamilyMembers','success'=>'false'));

           }
       }



   }









}

?>