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
     * get all detail of messages
     */

    public  function  detailRequesting($userID){

        $this->statement ='SELECT message_id,message_content,message_type,sender_id,receiver_id,create_date FROM iafamily_message WHERE receiver_id=? AND message_status=1 ORDER BY create_date';
        $this->bindType = array('i');
        $this->bindName = array($userID);
        $this->selectSQL();

        foreach ($this->selectedFetchResult as $index=>$array){

            $this->userInfoFetch->fetchSpecificUsersInfoApi($this->selectedFetchResult[$index]['sender_id']);
            $this->selectedFetchResult[$index]['senderUrl'] = $this->userInfoFetch->selectedFetchResult[0]['user_avatar'];
            $this->selectedFetchResult[$index]['senderName'] = $this->userInfoFetch->selectedFetchResult[0]['user_name'];

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
     * get All detail Of Messages
     */

    public function getAllDetaillOfMessages(){
        return $this->selectedFetchResult;
    }
    /**
     * end
     */

}