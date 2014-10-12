<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 6/10/14
 * Time: 6:54 PM
 */

include_once $_SERVER["DOCUMENT_ROOT"].'/lib/model/DataBaseCRUDModel.php';
include_once $_SERVER["DOCUMENT_ROOT"].'/lib/model/PhotoFetchModel.php';


class SortModel extends DataBaseCRUDModel{

    private $photoFetch;
    /**
     * construct
     */
    public function __construct(){
            parent::__construct();
            $this->photoFetch = new PhotoFetchModel();
    }

    /**
     * end
     */

    /**
     * sort by date
     */

    public function sortByDate($userID){
        $this->selectedFetchResult = $this->photoFetch->getMyImages($userID);
    }



    /**
     * end
     */


    /**
     * sort by family
     */

    public function sortByFamily($userID){

        $sourceArray = $this->photoFetch->getImages($userID);

        $getUniqueSortFilter = $this->uniqueSortFilter($sourceArray,'family_id');
        //to get family name
        $this->selectedFetchResult = $this->getSortFamilyGroup($getUniqueSortFilter,$sourceArray);

    }


    private function getSortFamilyGroup($uniqueFilters, $sourcesArray){
            $tempArray = array();
            foreach ($uniqueFilters as $key=>$value){
                foreach($sourcesArray as $sourceKey=>$sourceValue){
                    foreach($sourceValue as $subSourceKey=>$subSourceValue){



                    }
                }

            }





    }




    /**
     * end
     */


    /**
     * get unique filter
     */
    private function uniqueSortFilter($sortArray,$filterContent){
        $tempArray=array();
        foreach($sortArray as $key=>$subArray){
            foreach($subArray as $subKey=>$value){
                if($subKey===$filterContent){
                    array_push($tempArray,$value);
                }
            }

        }

        return array_unique($tempArray);

    }


    /**
     * end
     */



    /**
     * sort by uploader
     */
    public function sortByUploader(){



    }
    /**
     * end
     */


    /**
     * sort by favorite
     */
    public function sortByFavorite(){




    }

    /**
     * end
     */



    /**
     * return final sorted value
     */
    public function getFinalSort(){
        return $this->selectedFetchResult;
    }


    /**
     * end
     */






} 