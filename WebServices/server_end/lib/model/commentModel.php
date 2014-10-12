<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 7/10/14
 * Time: 9:17 PM
 */

include_once $_SERVER["DOCUMENT_ROOT"].'/lib/model/DataBaseCRUDModel.php';


class commentModel extends DataBaseCRUDModel{

    private $commentUserID;
    private $commentImageID;
    private $commentContent;
    private $commentID;
    private $commentType;
    private $commentDate;



    /**
     * construct
     */

    public function __construct(){
        parent::__construct();
        $this->commentDate = date('Y-m-d H:i:s');
    }
    /**
     * end
     */


    /**
     * initial parameters
     */
    public function initialParameters($commentUserID,$commentImageID,$commentContent,$commentType,$commentID){
            $this->commentUserID = $commentUserID;
            $this->commentImageID = $commentImageID;
            $this->commentContent = $commentContent;
            $this->commentType = $commentType;
            $this->commentID = $commentID;

    }

    /**
     * end
     */


    /**
     * insert comment
     */
    public function insertComment(){
        $this->statement = 'INSERT INTO iafamily_image_comment (member_user_id,comments_id, image_id, comment_type,comment_content,comment_date,comment_status) VALUES(?,?,?,?,?,?,?)';
        $this->bindType = array('i','i','i','s','s','s','i');
        $this->bindName = array($this->commentUserID,$this->commentID,$this->commentImageID,$this->commentType,$this->commentContent,$this->commentDate,1);

        //insert query
        $this->insertAndUpdateAndDeleteSQL();

        //bind result
        $affect= $this->affectedResult;

        if($affect>0){
            return true;
        }
        else
        {
            return false;
        }


    }


    /**
     * end
     */


    /**
     * get comment for current Image id
     */

    public function returnComments($imageId){

        $this->statement = 'SELECT C.comments_id, C.comment_type, C.comment_content,U.user_id, U.user_avatar, C.comment_date FROM iafamily_image_comment AS C LEFT JOIN iafamily_users AS U ON C.member_user_id=U.user_id WHERE C.image_id=? ORDER BY C.comment_date DESC ';
        $this->bindType = array('i');
        $this->bindName = array($imageId);
        //query
        $this->selectSQL();

    }

    /**
     * end
     */



    /**
     * return comment
     */
    public function getFinalComment(){
        return $this->selectedFetchResult;

    }


    /**
     * end
     */



} 