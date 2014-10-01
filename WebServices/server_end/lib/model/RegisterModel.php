<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 4/08/14
 * Time: 9:16 PM
 */

include_once $_SERVER["DOCUMENT_ROOT"].'/lib/model/DataBaseCRUDModel.php';

class Register extends DataBaseCRUDModel{
    private $userID;
    private $userEmail;
    private $userPasswd;
    private $userAge;
    private $userName;
    private $userPhone;
    private $userType;
    private $userStatus;
    private $result;
    /**
     * constructor
     * initial parameters
     */
    public function __construct($userEmail,$userPasswd,$userName,$userAge,$userPhone,$userGender){

        parent::__construct();
        $this->userID = time();
        $this->userEmail = $userEmail;
        $this->userPasswd = $userPasswd;
        $this->userAge = $userAge;
        $this->userName = $userName;
        $this->userPhone = $userPhone;
        $this->userGender = $userGender;
        $this->userStatus = 0;
        $this->userType = $this->GetUserType();
        $this->result = 0;
    }
    /**
     * end
     */

    /**
     * get the user type according to user type
     */
    private function GetUserType(){

        if($this->userAge <=15){
            return 'child';
        }
        elseif (16<=$this->userAge && $this->userAge<=59){
            return 'Adult';
        }
        elseif (60<=$this->userAge && $this->userAge<=100){
            return 'Old People';
        }

    }

    /**
     * end
     */





    /**
     * register
     * ready to register
     */
    public function registerApi(){
        //here to insert the db connect prepare statement
        //here to insert into data connection
       if($this->emailCheck()===0){
            $this->statement = 'INSERT INTO iafamily_users (user_id, user_email, user_password, user_age, user_gender, user_name, user_phone,user_status, user_type  ) VALUES (?,?,?,?,?,?,?,?,?)';
            $this->bindType= array('i','s','s','i','s','s','i','i','s');
            $this->bindName =  array($this->userID,$this->userEmail, $this->userPasswd, $this->userAge,$this->userGender, $this->userName, $this->userPhone, $this->userStatus, $this->userType);
            $this->insertAndUpdateAndDeleteSQL();
            $this->result =$this->affectedResult;
       }
        else{
            $this->result=0;
        }

    }

    /**
     * end
     */


    /**
     * repeated email check
     */
    private function emailCheck(){
        $this->statement ='SELECT user_email FROM iafamily_users WHERE user_email = ?';
        $this->bindType= array('s');
        $this->bindName= array($this->userEmail);
        $this->selectSQL();
        return count($this->selectedFetchResult);

    }

    /**
     * end
     */



    /**
     * execute
     */
    public function execute(){
        if($this->result>0 ){
            //create the user folder
            $this->createrUserFolder();
            return json_encode(array('type'=>'register','userArray'=>array('user_id'=>$this->userID,'user_email'=>$this->userEmail,'user_age'=>$this->userAge,'user_gender'=>$this->userGender,'user_name'=>$this->userName,'user_phone'=>$this->userPhone,'user_type'=>$this->userType),'success'=>'true'));
        }
        else{
            return json_encode(array('type'=>'register','success'=>'false','error'=>'@repeated Email address '.$this->userEmail));
        }

    }

    /**
     * end
     */




    /**
     * creater user folder
     */
       private function  createrUserFolder(){

           $folderNameRoot = $_SERVER["DOCUMENT_ROOT"].'/users_assets/'.$this->userID;
           $folderHeaderProfile = $folderNameRoot.'/header_profile';
           $folderHeaderImagesSets = $folderNameRoot.'/imageSets';

           mkdir($folderNameRoot, 0777, true);
           mkdir($folderHeaderProfile, 0777, true);
           mkdir($folderHeaderImagesSets, 0777, true);


           chmod($folderNameRoot, 0777);
           chmod($folderHeaderProfile, 0777);
           chmod($folderHeaderImagesSets, 0777);




       }


    /**
     * end
     *
     */



}

