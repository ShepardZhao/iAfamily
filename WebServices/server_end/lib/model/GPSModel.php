<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 8/09/14
 * Time: 4:18 PM
 */
include_once $_SERVER["DOCUMENT_ROOT"].'/lib/model/DataBaseCRUDModel.php';

class GPSModel extends  DataBaseCRUDModel{
    public function __construct(){
        parent::__construct();

    }


    /**
     * update the user's location
     *
     */
    public function updateLocationByUseId($latest_longitude,$latest_latitude,$userId){
        $this->statement = 'UPDATE iafamily_users SET latest_longitude=?, latest_latitude=?  WHERE user_id=?';
        $this->bindType = array('s','s','i');
        $this->bindName = array($latest_longitude,$latest_latitude,$userId);
        $this->insertAndUpdateAndDeleteSQL();
        //return affect row
        return json_encode(array('success'=>'true'));



    }


    /**
     * end
     */







} 