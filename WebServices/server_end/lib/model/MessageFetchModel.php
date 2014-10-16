<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 1/09/14
 * Time: 4:11 PM
 */
include_once $_SERVER["DOCUMENT_ROOT"].'/lib/model/UserInfoFetchModel.php';

class MessageFetchModel extends DataBaseCRUDModel {
    private $numberOfMessages;
    private $userInfoFetch;

    public function __construct(){
        parent::__construct();
        $this->userInfoFetch= new UserInfoFetch();
    }


    /**
     * get all the number of messages
     * @param $userId
     */
    public function requesting($userId){
        $this->statement ='SELECT message_id FROM iafamily_message WHERE receiver_id=? AND message_status=1';
        $this->bindType =array('i');
        $this->bindName =array($userId);
        $this->selectSQL();
        $this->selectedFetchResult;
        $this->numberOfMessages = count($this->selectedFetchResult);

    }

    public function getNumberOfMessages(){
        return $this->numberOfMessages;

    }


    /**
     * end
     */


    /**
     * get invitation of message
     */
    public function detailInvitationRequesting($userID){
        $this->statement ="SELECT message_id,message_content,sender_id,receiver_id,create_date FROM iafamily_message WHERE receiver_id=? AND message_type='invitation' AND message_status=1 ORDER BY create_date DESC";
        $this->bindType = array('i');
        $this->bindName = array($userID);
        $this->selectSQL();
        //unserialize
        $this->unserializeContent();
    }

    /**
     *
     */


    /**
     * sub function to unserialize
     */

    private function unserializeContent(){

        //unserialize
        foreach ($this->selectedFetchResult as $index=>$array){
            foreach ($array as $key=>$value){
                if($key==='message_content'){
                    $this->selectedFetchResult[$index][$key]= unserialize($value);
                }

            }
        }




    }



    /**
     * end
     */

    /**
     * get all detail of messages
     */

    public  function  detailRequesting($userID){

        $temp = array();

        $finalValue =array();

        $this->statement ="SELECT message_id,message_content,sender_id,receiver_id,create_date, message_status FROM iafamily_message WHERE receiver_id=? AND message_type='photo' ORDER BY create_date DESC";
        $this->bindType = array('i');
        $this->bindName = array($userID);
        $this->selectSQL();


        //copy sender id into an array
        foreach ($this->selectedFetchResult as $index=>$array){
            foreach($array as $key=>$value){
                if($key==='sender_id'){
                    array_push($temp,$value);

                }
            }

        }

        //make the sender id unique
        $uniquedSenderIds = array_unique($temp);

        //unserialize
        $this->unserializeContent();

        $returnArray=array();

        //copy same sender id
        foreach($uniquedSenderIds as $keyValue){
            $finalValue['sender_id'] = $keyValue;
            $finalValue['content'] = array();
            foreach ($this->selectedFetchResult as $index=>$array){
                foreach ($array as $key=>$value){
                    if($key==='sender_id'){
                        if($keyValue ==$value){
                            array_push($finalValue['content'],$array);
                        }
                    }

                }
            }
            $this->userInfoFetch->fetchSpecificUsersInfoApi($keyValue);
            $finalValue['senderUrl'] = $this->userInfoFetch->selectedFetchResult[0]['user_avatar'];
            $finalValue['senderName'] = $this->userInfoFetch->selectedFetchResult[0]['user_name'];

            array_push($returnArray,$finalValue);

        }



        $this->selectedFetchResult =$returnArray;

    }

    /**
     * end
     */




    /**
     * get All detail Of Messages
     */

    public function getAllDetaillOfMessages(){
        return $this->selectedFetchResult;
    }
    /**
     * end
     */

}