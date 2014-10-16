<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 13/10/14
 * Time: 10:46 PM
 */
include_once $_SERVER["DOCUMENT_ROOT"].'/lib/model/DataBaseCRUDModel.php';
class MessageModifyModel extends DataBaseCRUDModel{

    public function __construct(){
        parent::__construct();
    }


    public function markMessageAlreadyRead($messageIdsArrays){

            try{
                foreach($messageIdsArrays as $value){
                    $this->remakeMessageStatus($value);
                }

                return true;

            }catch(Exception  $e){

                return false;

            }
    }

    private function remakeMessageStatus($singleMessageID){
        $this->statement ='UPDATE iafamily_message SET message_status=? WHERE message_id=?';
        $this->bindType= array('i','i');
        $this->bindName = array(0, $singleMessageID);
        $this->insertAndUpdateAndDeleteSQL();

    }




}