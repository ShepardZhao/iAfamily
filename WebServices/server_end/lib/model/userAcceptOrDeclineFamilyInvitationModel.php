<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 3/09/14
 * Time: 4:21 PM
 */
include_once $_SERVER["DOCUMENT_ROOT"].'/lib/model/DataBaseCRUDModel.php';

class userAcceptOrDeclineFamilyInvitationModel extends DataBaseCRUDModel{
    private $userId;
    private $familyId;
    private $messageId;


    public function __construct(){
        parent::__construct();
    }


    public function initialParamters($userId,$familyId,$messageId){
        $this->userId = $userId;
        $this->familyId = $familyId;
        $this->messageId = $messageId;

    }


    public function updateStatus(){

        if($this->insertRecord() && $this->ChangeMessgaeStatus()){

            return true;

        }
        else{
            return false;
        }

    }



    public function cancelMessage($messageId){
        $this->messageId = $messageId;
        if($this->ChangeMessgaeStatus()){
            return true;
        }
        else{
            return false;
        }

    }




    /**
     * if current user accept the request then we need to insert the new record,
     * that combined with userid and family into the table iafamily_member
     */
    private  function insertRecord(){
        $this->statement='INSERT INTO iafamily_member (family_id,member_user_id) VALUES (?,?)';
        $this->bindType=array('i','i');
        $this->bindName= array($this->familyId,$this->userId);
        $this->insertAndUpdateAndDeleteSQL();


        if($this->affectedResult===1){
            return true;
        }
        else{
            return false;
        }

    }


    /**
     * end
     */



    /**
     * remove the message status from 1 to 0, which means current message is not available
     */
    private function ChangeMessgaeStatus(){

        $this->statement='DELETE FROM iafamily_message WHERE message_id=?';
        $this->bindType=array('i');
        $this->bindName= array($this->messageId);
        $this->insertAndUpdateAndDeleteSQL();


        if($this->affectedResult===1){
            return true;
        }
        else{
            return false;
        }

    }


    /**
     * end
     */

}