<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 14/09/14
 * Time: 8:40 PM
 */
include_once $_SERVER["DOCUMENT_ROOT"].'/lib/model/FamilyModel.php';


class PhotoFetchModel extends  DataBaseCRUDModel{

    private $family;
    public function __construct(){
        parent::__construct();
        $this-> family =  new Family();
        //getFamiliesIdsOnly

    }

    //get all family IDs, where current user has
    public function getImages($userID){
       $familyIDs= $this->family->getFamiliesIdsOnly($userID);
       $oneDimensionFamilyIDs=array();
       $finalImageSet=array();
       $tempImageSet =array();
       $finalReturnImageSet =array();
       //get one dimension array
       foreach ($familyIDs as $key=>$array){
           foreach ($array as $subKey=>$value){
                   array_push($oneDimensionFamilyIDs,$value);

           }
       }



       //get images
        foreach($oneDimensionFamilyIDs as $singleFamilyId){
            $this->statement='SELECT iafamily_image.image_id, iafamily_image.image_name,iafamily_image.image_date, iafamily_image.image_latitude,iafamily_image.image_longitude,iafamily_image.image_desc,iafamily_image.image_like FROM iafamily_image  JOIN iafamily_image_group ON iafamily_image.image_id = iafamily_image_group.image_id WHERE iafamily_image_group.family_id=?';
            $this->bindType=array('i');
            $this->bindName=array($singleFamilyId);
            $this->selectSQL();
            array_push($finalImageSet,$this->selectedFetchResult);
        }

        $final = array_reduce($finalImageSet, function($_, $inner){
            return $_ = array_merge((array)$_, $inner);
        });


        //insert the image path to array
        foreach($final as $key=>$subArray){
            foreach($subArray as $subKey=>$subValue){
              if($subKey==='image_id'){

                  if(in_array($subValue,$tempImageSet)){
                      break;
                  }
                  else{
                      $subArray['imagePath'] =$this->getImagesPath($subValue);
                      array_push($finalReturnImageSet,$subArray);

                      array_push($tempImageSet,$subValue);
                  }

              }

            }


        }


        //return unique image sets while multiple families fetched






        return $finalReturnImageSet;
    }




    /**
     * get image path
     */
    private function getImagesPath($imageId){
        $this->statement ='SELECT image_full_size,image_thumb_size,image_half_size FROM iafamily_image_detail WHERE image_id=?';
        $this->bindType = array('i');
        $this->bindName = array($imageId);
        $this->selectSQL();
        $final = array_reduce($this->selectedFetchResult, function($_, $inner){
            return $_ = array_merge((array)$_, $inner);
        });
        return $final;
    }



    /**
     * end
     */





} 