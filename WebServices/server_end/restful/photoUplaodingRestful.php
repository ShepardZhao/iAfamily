<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 7/09/14
 * Time: 3:19 PM
 */
include_once $_SERVER["DOCUMENT_ROOT"].'/lib/controller/imageUploadController.php';
include_once $_SERVER["DOCUMENT_ROOT"].'/lib/controller/FamilyController.php';

header("Content-Type: application/json");

if($_SERVER['REQUEST_METHOD']==='POST'){
   $gps = json_decode($_POST['gpsArray']);

    //return members id
    $returnMembersIDs=array();

    //get images from files
    if(isset($_FILES) && isset($_POST['familiesIDs']) && isset($_POST['userId'])){
        $storeImageId=array();
        $storeImageIdAndPath=array();
        $storeAllMemberID=array();
        $userImageRootPath =  '/users_assets/'.$_POST['userId'].'/imageSets/';

            //set the default image uploaded path
        $imageUpload -> setDestination($_SERVER["DOCUMENT_ROOT"].$userImageRootPath);
        $index=0;
        foreach($_FILES as $key=>$content){
            //set image time
            $imageUpload -> setImageID($key);

            array_push($storeImageId,$imageUpload->getImageID());
            //set file name
            $imageUpload -> setFileName($content["name"]);
            //set print error
            $imageUpload -> setPrintError($content["error"]);
            //set max size
            $imageUpload -> setMaxSize($content["size"]);
            //set type
            $imageUpload -> setType($content["type"]);
            //get image name
            //resize image


            //here to doing the database operation
            //1.firstly, insert the record to iafamily_image
            //2.secondly, insert the record to iafamily_detail

            //prepare gps
            //$gps = $imageUpload->readGPSinfoEXIF();
            //if the gps existed
            $result = $imageUpload->insertImageBasicInformation($gps[$index][0],$gps[$index][1],$_POST['photoDescription']);



            //insert the image and resize image to image_detail

            //resize to half size, and thumb size
            if($result){
                $imageUpload -> resize($content['tmp_name'],300,300,'_icon'); //for thumb
                $imageUpload -> resize($content['tmp_name'],600,676,'_half'); //for slide
                $imageUpload -> upload($content['tmp_name']); //copy full size photo to user folder
                $imageUpload -> insertIntoImageDetail($userImageRootPath.$imageUpload->getfilename().'.jpeg',$userImageRootPath.'_icon'.$imageUpload->getfilename().'.jpeg',$userImageRootPath.'_half'.$imageUpload->getfilename().'.jpeg');
                array_push($storeImageIdAndPath,array('Description'=>$_POST['photoDescription'],'image_id'=>array($userImageRootPath.$imageUpload->getfilename().'.jpeg',$userImageRootPath.'_icon'.$imageUpload->getfilename().'.jpeg',$userImageRootPath.'_half'.$imageUpload->getfilename().'.jpeg')));
            }

            $index++;
        }



        //insert the data into image and group
        //loop family if there are multi-families ID
        foreach($_POST['familiesIDs'] as $familyId){

           array_push($storeAllMemberID, $family->getEachMemberId($familyId));

            foreach($storeImageId as $imageID){
                $imageUpload->insertIntoImageAndGroup($imageID,$_POST['userId'],$familyId);

            }
        }

        //put all member id into an array
        $tmpMemberID=array();
        foreach($storeAllMemberID as $key=>$array){
            foreach($array as $subKey=>$value){
                foreach($value as $finalKey=>$finalValue){
                    array_push($tmpMemberID,$finalValue);

                }
            }
        }
        //insert photo into the message
        //1. get family ids and analysis the member ids in these familyIDS
        array_unique($tmpMemberID);

        //2. push the message to these members cause they are in same family group

        foreach($tmpMemberID as $singleValue){
            if($singleValue!=$_POST['userId']){
                array_push($returnMembersIDs,'user_'.$singleValue);
                $imageUpload->photoMessageInsert(serialize($storeImageIdAndPath),$_POST['userId'],$singleValue);

            }

        }


        //3. return json and final members Ids and say true
        echo json_encode(array('success'=>'true','pushMembersIDs'=>$returnMembersIDs));







    }








}