<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 19/08/14
 * Time: 2:36 PM
 */
include_once $_SERVER["DOCUMENT_ROOT"].'/lib/model/DataBaseCRUDModel.php';
class Family extends DataBaseCRUDModel{
    private $familyId;
    private $familyName;
    private $familyDate;
    private $familyDesc;
    private $userID;
    private $result;


    public function __construct(){
        parent::__construct();
    }


    public function initialAddFamily($familyName,$familyDesc,$userID){
        $this->familyId = time();
        $this->familyDesc = $familyDesc;
        $this->familyName = $familyName;
        $this->familyDate = date('Y-m-d H:i:s');
        $this->userID = $userID;
        $this->result =0;
    }




    /**
     * add the family for a user -- api
     */
    public function  addFamilyApi(){
        //1.here you have to insert the new family into the iafamily_gorup table first
        //2.then insert the current family ID and user_id (will become member_user_id) into the table of iafamily_member

       $this->statement = 'INSERT INTO iafamily_group (family_id,family_name, family_date, family_desc,user_id) VALUES(?,?,?,?,?)';
       $this->bindType = array('i','s','s','s','i');
       $this->bindName = array($this->familyId,$this->familyName,$this->familyDate,$this->familyDesc,$this->userID);

       //insert query
       $this->insertAndUpdateAndDeleteSQL();

       //bind result
        $step1= $this->affectedResult;


        $this->statement = 'INSERT INTO iafamily_member (family_id, member_user_id) VALUES(?,?)';
        $this->bindType = array('i','i');
        $this->bindName = array($this->familyId,$this->userID);

        //insert query
        $this->insertAndUpdateAndDeleteSQL();

        //bind result
        $step2= $this->affectedResult;

        //if both tables been inserted the data then given the result to class where its result is been set up 1
        if($step1 >0 && $step2>0){
            return json_encode(array('type'=>"AddAFamily",'success'=>'true'));
        }
        else{
            return json_encode(array('type'=>"AddAFamily",'success'=>'false'));
        }


    }

    /**
     * end
     */


    /**
     * fetch families according to userId
     */
    public  function  getFamiliesByUserId($userID){

        //fetch the families ids
        $familiesArray = $this->getFamiliesIdsOnly($userID);


        //if we have families IDs
        if(count($familiesArray)>0){
            //then we get detail of the family
            $getFamilyDetail = $this->getFamiliesDetailsOnly($familiesArray);
        }
        else{
            $getFamilyDetail=array();
        }


         return json_encode(array('type'=>"fetchAll",'success'=>'true','families'=>$getFamilyDetail));




    }


    public function getFamiliesIdsOnly($userID){
        $this->statement = 'SELECT family_id FROM iafamily_member WHERE member_user_id=?';
        $this->bindType = array('i');
        $this->bindName = array($userID);

        //select query
        $this->selectSQL();

        return $this->selectedFetchResult;
    }



    private function getFamiliesDetailsOnly($familiesIds){
        //fetch detail only
        $detailArray=array();

        foreach ($familiesIds as $index=>$singleFamilyIdArray){
                $this->statement = 'SELECT family_id,family_name,family_date,family_desc,user_id FROM iafamily_group WHERE family_id=?';
                $this->bindType = array('i');
                $this->bindName = array($singleFamilyIdArray['family_id']);
                $this->selectSQL();

                $final = array_reduce($this->selectedFetchResult, function($_, $inner){
                return $_ = array_merge((array)$_, $inner);
                });
                array_push($detailArray,$final);

        }

        //read through all family id and find each member users' detail


        foreach ($familiesIds as $singleFamilyIdArray){
            foreach ($singleFamilyIdArray as $key=>$value){
                foreach($detailArray as $index=>$valueArray){
                    foreach($valueArray as $keyName=>$valueName){
                        if($keyName==='family_id' && $valueName === $value){

                            $detailArray[$index]['number_members'] = count($this->getEachMemberId($value));
                            $detailArray[$index]['creator'] = $this->getCreatorName($value);
                        }
                    }

                }


            }
        }


        return $detailArray;




    }



    public function getEachMemberId($familyId){
        $this->statement = 'SELECT member_user_id FROM iafamily_member WHERE family_id=?';
        $this->bindType = array('i');
        $this->bindName = array($familyId);
        $this->selectSQL();
        return $this->selectedFetchResult;

    }


    private function getCreatorName($familyId){
        $this->statement = 'SELECT user_name FROM iafamily_users INNER JOIN iafamily_group ON iafamily_users.user_id = iafamily_group.user_id WHERE family_id=?';
        $this->bindType = array('i');
        $this->bindName = array($familyId);
        $this->selectSQL();
        $final = array_reduce($this->selectedFetchResult, function($_, $inner){
            return $_ = array_merge((array)$_, $inner);
        });

        return $final['user_name'];

    }


    /**
     * end
     */


    /**
     *get members details by family id
     */
    public function getMembersDetailsByFamilyId($familyID){
        $getEachMemebrsID = $this->getEachMemberId($familyID);
        return $this->loopMembers($getEachMemebrsID);
    }

    //Loop members and return the detail
    private function loopMembers($getEachMemebrsID){
        $memberArrayDetail = array();
            foreach ($getEachMemebrsID as $singleMemberID){
              foreach($singleMemberID as $value){
                  $this->statement = 'SELECT user_id,user_email,user_age,user_gender,user_name, user_phone,user_avatar,user_status, user_type,latest_longitude,latest_latitude FROM iafamily_users WHERE user_id=?';
                  $this->bindType = array('i');
                  $this->bindName = array($value);
                  $this->selectSQL();
                  $final = array_reduce($this->selectedFetchResult, function($_, $inner){
                      return $_ = array_merge((array)$_, $inner);
                  });
                  array_push($memberArrayDetail,$final);

              }

            }

    return $memberArrayDetail;


    }



    /**
     * end
     */







}
