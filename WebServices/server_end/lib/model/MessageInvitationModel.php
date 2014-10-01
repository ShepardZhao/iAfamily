<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 28/08/14
 * Time: 12:01 AM
 */
include_once $_SERVER["DOCUMENT_ROOT"].'/lib/model/DataBaseCRUDModel.php';

class MessageInvitationModel extends DataBaseCRUDModel {

    private $message_id; //message id
    private $sender; //sender id --
    private $receiver; // the user who received the message
    private $content;  //what is the message
    private $invitator;  // who try to send invitation // user name
    private $senderName; // sender name here is the family name
    private $messageStatus;
    private $messageType;
    private $create_date;

    public function __construct(){
        parent::__construct();
    }


    public function setSenderAndReceiverAndMessageType($sender,$receiver,$invitator,$senderName,$invitatorHeaderImageUrl){
            $this->message_id = time();
            $this->sender = $sender;
            $this->receiver = $receiver;
            $this->invitator = $invitator;
            $this->senderName = $senderName;
            $this->content = serialize(array('invitator'=>$this->invitator,'invitator_image_url'=>$invitatorHeaderImageUrl, 'senderName'=>$this->senderName, 'message'=> ' invites you to join the group '));
            $this->messageStatus =1;
            $this->messageType ='invitation';
            $this->create_date = date('Y-m-d H:i:s');
    }




    public function senderMessage(){

        $result = false;
        if($this->repeatCheck()){
            $this->statement ='INSERT INTO iafamily_message (message_id, message_content, message_type, message_status,sender_id, receiver_id,create_date) VALUES (?,?,?,?,?,?,?)';
            $this->bindType= array('i','s','s','i','i','i','s');
            $this->bindName = array($this->message_id, $this->content,$this->messageType , $this->messageStatus,$this->sender,$this->receiver,$this->create_date);

            $this->insertAndUpdateAndDeleteSQL();
            if(count($this->affectedResult)>0){

                $result=true;
            }


        }

        return $result;

    }




/**
 * repeat user check
 */

    private  function repeatCheck(){

        $this->statement='SELECT message_id FROM  iafamily_message WHERE sender_id=? AND receiver_id=?';
        $this->bindType= array('i','i');
        $this->bindName = array($this->sender,$this->receiver);
        $this-> selectSQL();


        if(count($this->selectedFetchResult)===0){

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