<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 6/10/14
 * Time: 10:23 AM
 */

include_once $_SERVER["DOCUMENT_ROOT"].'/lib/controller/sortController.php';

header("Content-Type: application/json");

  if($_SERVER['REQUEST_METHOD']==='POST'){

      if($_POST['requestType']==='sortByDate'){
          //sort by date
          $sort->sortByDate($_POST['requestUserID']);
          echo json_encode(array('requestType'=>'sortByDate','success'=>'true','imageSets'=>$sort->getFinalSort()));
      }
      if($_POST['requestType']==='sortByFamilies'){
          //sort by family
          $sort->sortByFamily($_POST['requestUserID']);
          echo json_encode(array('requestType'=>'sortByFamilies','success'=>'true','imageSets'=>$sort->getFinalSort()));
      }
      if($_POST['requestType']==='sortByUploader'){
        //sort by uploader
          $sort->sortByUploader($_POST['requestUserID']);
          echo json_encode(array('requestType'=>'sortByUploader','success'=>'true','imageSets'=>$sort->getFinalSort()));
      }
      if($_POST['requestType']==='SortByFavorite'){
        //display favorite
          $sort->sortByFavorite($_POST['requestUserID']);
          echo json_encode(array('requestType'=>'SortByFavorite','success'=>'true','imageSets'=>$sort->getFinalSort()));

      }








  }