<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 27/08/14
 * Time: 5:27 PM
 */
include_once $_SERVER["DOCUMENT_ROOT"].'/lib/model/DataBaseCRUDModel.php';

class SearchUserModel extends DataBaseCRUDModel{
    private $searchItem; //could be email, phone number, user id, or user name
    private $sqlStatement = "SELECT user_id,user_email,user_age,user_gender,user_name,user_phone,user_avatar,user_status,user_type FROM iafamily_users WHERE ";

    public function __construct(){
        parent::__construct();
    }


    public function searchResult($items){
            $this -> searchItem = $items;

        //try to search user by item from different ways

        return $this->combinResult();

    }



    /**
     * db execution
     */
    private function setExecuttion($prepareStatement,$bindType){
         $this->statement = $prepareStatement;
         $this->bindType=array($bindType);
         $this->bindName=array($this->searchItem);
         $this->selectSQL();
         return $this->selectedFetchResult;

    }



    /**
     * end
     */

    /**
     * combine the search result together
     */

    private function combinResult(){

        $array = array();


        if(count($this->searchByEmail())>0){
            $array = $this->searchByEmail();

        }
        elseif(count($this->searchById())>0){
            $array= $this->searchById();
        }
        elseif(count($this->searchByName())>0){
            $array= $this->searchByName();
        }
        elseif(count($this->searchByPhone())>0){
            $array= $this->searchByPhone();
        }

        return $array;

    }

    /**
     * end
     */


    /**
     * search the user by email
     */

    private function searchByEmail(){
        $completeStatement = $this-> sqlStatement."user_email=?";
        return $this->setExecuttion($completeStatement,'s');

    }

    /**
     * end
     */


    /**
     * search the user by id
     */
    private function searchById(){

        $completeStatement = $this-> sqlStatement."user_id=?";
        return $this->setExecuttion($completeStatement,'i');
    }


    /**
     * end
     */



    /**
     * search the user by name
     */
    private function searchByName(){

        $completeStatement = $this-> sqlStatement."user_name=?";
        return $this->setExecuttion($completeStatement,'s');
    }

    /**
     * end
     */


    /**
     * search the user by phone
     */

    private function searchByPhone(){

        $completeStatement = $this-> sqlStatement."user_phone=?";
        return $this->setExecuttion($completeStatement,'i');
    }



    /**
     * end
     */



} 