<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 7/08/14
 * Time: 5:02 PM
 */
include_once $_SERVER["DOCUMENT_ROOT"].'/lib/model/DataBaseCRUDModel.php';

class UserInfoFetch extends DataBaseCRUDModel{
    /**
     * get administrator user info api
     */

    public function __construct(){
        parent::__construct();
    }

    public function fetchAdminsInfoApi(){
        $this->statement='SELECT administrator,password FROM iafamily_web_management';
        $this->bindType=null;
        $this->bindName=null;
        $this->selectSQL();

    }
    /**
     * end
     */

    /**
     * get user info api -- requests from mobile end and desktop
     */
    public function fetchUsersInfoApi(){

        $this->statement='SELECT user_id,user_email, user_age, user_name,user_phone, user_avatar, user_status, user_type, user_gender FROM iafamily_users';
        $this->bindType=null;
        $this->bindName=null;
        $this->selectSQL();

    }

    /**
     * end
     */

    /**
     * fetch specific user info
     */
    public function fetchSpecificUsersInfoApi($userID){

        $this->statement='SELECT user_id,user_email, user_age, user_name,user_phone, user_avatar, user_status, user_type, user_gender,latest_longitude,latest_latitude FROM iafamily_users WHERE user_id=?';
        $this->bindType=array('i');
        $this->bindName=array($userID);
        $this->selectSQL();

    }


    /**
     * end
     */

    /**
    * execute
    */
    public function execute(){
        if(count($this->selectedFetchResult)>0){
            return $this->selectedFetchResult;
        }
    }

    /**
     * end
     */








} 