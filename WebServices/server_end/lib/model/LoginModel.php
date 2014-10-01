<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 4/08/14
 * Time: 4:40 PM
 */
include_once $_SERVER["DOCUMENT_ROOT"].'/lib/model/DataBaseCRUDModel.php';
class Login extends DataBaseCRUDModel{
   private $userEmail;
   private $password;
   private $result;

    public function __construct(){
        parent::__construct();
    }

   public function loginApi($userEmail,$password){
        $this->userEmail = $userEmail;
        $this->password = $password;
   }



   /**
    * connect the database then get the compared result - for admin
    */
   public function loginValidationByadmin(){
        //prepare
        $this -> statement = 'SELECT administrator, password FROM iafamily_web_management WHERE administrator=? AND password=?';
        $this -> bindType = array('s','s');
        $this -> bindName = array($this->userEmail,$this->password);
        //execute query
        $this -> selectSQL();

        //after execute
        if(count($this -> selectedFetchResult)>0){
            $this->result = 1;
        }
       else{
            $this->result =0;
       }
   }

   /**
    * end
    */


    /**
     * connect the database then get the compared result - for user
     */
    public function loginValidation(){
        //prepare
        $this -> statement = 'SELECT user_id FROM iafamily_users WHERE user_email=? AND user_password=?';
        $this -> bindType = array('s','s');
        $this -> bindName = array($this->userEmail,$this->password);
        //execute query
        $this -> selectSQL();

        //after execute
        if(count($this -> selectedFetchResult)>0){
            $this->result = 1;
            $this->updateUserStatus($this->selectedFetchResult[0]['user_id']);

        }
        else{
            $this->result =0;
        }


    }


    //set current user's status to active

    private function updateUserStatus($userID){
        //prepare
        $this -> statement = 'UPDATE iafamily_users SET user_status=1 WHERE user_id=?';
        $this -> bindType = array('i');
        $this -> bindName = array($userID);
        //execute update query
        $this -> insertAndUpdateAndDeleteSQL();

    }




    /**
     * end
     */




    /**
     * execute
     */
    public function execute($role){
       if($role==='admin'){
           //only for administrator
            if($this->result===1){

                $_SESSION['username'] = $this->userEmail;
                return json_encode(array('success'=>'true'));
                //if match then return the correct

            }
            else{
                //if the current email and password doest match then return error message
                return json_encode(array('success'=>'false'));
            }
       }
        else{
            //only for normal user login -- this will be used on mobile api
            if($this->result>0){
                $_SESSION['username'] = $this->userEmail;
                return json_encode(array('user_id'=>$this->selectedFetchResult[0]['user_id'],'user_email'=>$this->userEmail,'user_password'=>$this->password,'success'=>'true'));
                //if match then return the correct

            }
            else{
                //if the current email and password doest match then return error message
                return json_encode(array('user_id'=>null,'success'=>'false'));
            }

        }

        //close db connection
        $this->closeDebConnection();

    }

    /**
     * end
     */



    /**
     * update the location
     */
    public function  updateLocation($latest_longitude,$latest_latitude){



    }

    /**
     * end
     */


} 