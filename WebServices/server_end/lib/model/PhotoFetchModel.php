<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 14/09/14
 * Time: 8:40 PM
 */
include_once $_SERVER["DOCUMENT_ROOT"].'/lib/model/FamilyModel.php';
include_once $_SERVER["DOCUMENT_ROOT"].'/lib/model/commentModel.php';


class PhotoFetchModel extends  DataBaseCRUDModel{

    private $family;
    private $comment;
    public function __construct(){
        parent::__construct();
        $this-> family =  new Family();
        //getFamiliesIdsOnly
        $this->comment = new commentModel();

    }

    //get all family IDs, where current user has
    public function getImages($userID){
        $finalReturnImageSet =array();

        $familyIDs= $this->family->getFamiliesIdsOnly($userID);
        if(count($familyIDs)>0){


            $oneDimensionFamilyIDs=array();
            $finalImageSet=array();
            $tempImageSet =array();
            //get one dimension array
            foreach ($familyIDs as $key=>$array){
                foreach ($array as $subKey=>$value){
                    array_push($oneDimensionFamilyIDs,$value);
                }
            }



            //get images
            foreach($oneDimensionFamilyIDs as $singleFamilyId){
                $this->statement='SELECT iafamily_image.image_id, iafamily_image.image_name,iafamily_image.image_date, iafamily_image.image_latitude,iafamily_image.image_longitude,iafamily_image.image_desc,iafamily_image.image_like, iafamily_image_group.family_id FROM iafamily_image INNER JOIN iafamily_image_group ON iafamily_image.image_id = iafamily_image_group.image_id WHERE iafamily_image_group.family_id=? ORDER BY iafamily_image.image_date DESC';
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
                            array_push($tempImageSet,$subValue);

                            //add the image path
                            $subArray['imagePath'] =$this->getImagesPath($subValue);
                            //add comment
                            $this->comment->returnComments($subValue);
                            $subArray['comments']=$this->comment->getFinalComment();
                            array_push($finalReturnImageSet,$subArray);



                        }

                    }

                }


            }


            //insert to family information
            foreach($finalReturnImageSet as $key=>$subArray){
                $finalReturnImageSet[$key]['familyInfo']=array();

                foreach($subArray as $subKey=>$value){
                    if($subKey==='family_id'){
                        if(isset($value)){
                            $finalReturnImageSet[$key]['familyInfo']= $this->family->getFamilyInformation($value);
                        }

                    }



                }

            }
        }




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





    /**
     * get my photos
     */
    public function getMyImages($userID){
        $tempArray = $this->getImages($userID);
        $setTempArray = array();
        //get first level
        foreach($tempArray as $key=>$subArray){
            foreach($subArray as $subKey=>$value){
                if($subKey =='image_date'){
                    //save the date to temp array
                        //copy new item to array
                        $tempValue=$this->getDateAndTimeArray($value);
                        array_push($setTempArray,$tempValue[0]);

                }


            }

        }



        $uniqueDate = array_unique($setTempArray);
        $finalReturn = array();
        $finalReturn['globalContent']= array();
        $returnArray= array();
        //loop unique date
        foreach ($uniqueDate as $value){
            //loop target array
            foreach ($tempArray as $keys=>$subArrays){
                foreach($subArrays as $subTempKey=>$subTempValue){
                    if($subTempKey =='image_date'){
                        $temp=$this->getDateAndTimeArray($subTempValue);
                        if($value==$temp[0]){

                            $finalReturn['date']= $temp[0];
                            array_push($finalReturn['globalContent'],$subArrays);

                        }


                    }


                }

            }

            array_push($returnArray,$finalReturn);
            $finalReturn =array();
            $finalReturn['globalContent']= array();

        }

        return $returnArray;

    }

    /**
     * end
     */



    /**
     * split string to array
     */

    private function getDateAndTimeArray($string){
        $temp=explode(" ",$string);
        return $temp;
    }

    /**
     * end
     */




} 