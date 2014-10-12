<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 3/09/14
 * Time: 10:04 PM
 */
include_once $_SERVER["DOCUMENT_ROOT"].'/lib/model/DataBaseCRUDModel.php';


class imageUploadModel extends  DataBaseCRUDModel{

    private $destination;
    private $fileName;
    private $maxSize = '1000048576'; // bytes (1048576 bytes = 1 meg)
    private $allowedExtensions = array('jpg','png','gif','JPG','PNG','GIF','jpeg','JPEG');
    private $type;
    private $nwidth;
    private $nheight;
    private $printError = TRUE;
    public $error = '';
    private  $imageID;


    public function __construct(){
        parent::__construct();
    }

    //START: Functions to Change Default Settings
    public function setDestination($newDestination) {
        $this->destination = $newDestination;
    }
    public function setFileName($newFileName) {
        $this->fileName = $newFileName;
    }
    public function setPrintError($newValue) {
        $this->printError = $newValue;
    }
    public function setMaxSize($newSize) {
        $this->maxSize = $newSize;
    }
    public function setImageID($key){
        $this->imageID=time()+$key;
    }

    public function getImageID(){
        return $this->imageID;

    }
    public function setAllowedExtensions($newExtensions) {
        if (is_array($newExtensions)) {
            $this->allowedExtensions = $newExtensions;
        }
        else {
            $this->allowedExtensions = array($newExtensions);
        }
    }
    //set type
    public function setType($type){
        $this -> type = $type;
    }

    //END: Functions to Change Default Settings

    //START: Process File Functions
    public function upload($file) {
       move_uploaded_file($file, $this-> getDestination().$this-> getfilename().'.jpeg');
    }
    public function delete($file) {

        if (file_exists($file)) {
            unlink($file) or $this->error .= 'Destination Directory Permission Problem.<br />';
        }
        else {
            $this->error .= 'File not found! Could not delete: '.$file.'<br />';
        }

        if ($this->error && $this->printError) print $this->error;
    }
    //END: Process File Functions

    //START: Helper Functions
    public function validate($file) {

        $error = '';

        //check file exist
        if (empty($file['name'])) $error .= 'No file found.<br />';
        //check allowed extensions
        if (!in_array($this->getExtension($file),$this->allowedExtensions)) $error .= 'Extension is not allowed.<br />';
        //check file size
        if ($file['size'] > $this->maxSize) $error .= 'Max File Size Exceeded. Limit: '.$this->maxSize.' bytes.<br />';

        $this->error = $error;
    }
    public function getExtension($file) {
        $filepath = $file['name'];
        $ext = pathinfo($filepath, PATHINFO_EXTENSION);
        return $ext;
    }

    //Get attributes
    //get error info
    public function NonError(){
        if ($this -> error ==''){
            return true;
        }
        else{
            return false;
        }
    }

    //get Destination

    public function getDestination(){
        return $this -> destination;
    }

    //get filename
    public function getfilename(){
        return $this -> fileName;

    }

    //get size
    public function getfilesize(){
        return $this -> maxSize;

    }

    //get type
    public function getType(){
        return $this-> type;
    }

    //get newwidth
    public function getNewWidth(){
        return $this -> nwidth;
    }


    //get newheight
    public function getNewheight(){
        return $this -> nheight;
    }

    //get error message
    public function getErrorMessage(){
        return $this-> error;
    }
    //get createdtime
    public function getCreatedTime(){
        $getexif = read_exif_data($this->destination.$this -> fileName);
        if(isset($getexif['DateTime'])){
            return $getexif['DateTime'];
        }
        else{
            return date("Y-m-d", $getexif['FileDateTime']);
        }
    }

    //imagecopyresized to resize the image
    public function resize($tempfile,$dst_w,$dst_h,$resetName){

// *** 1) Initialize / load image
        //$resizeObj = new imageResize($tempfile);

// *** 2) Resize image (options: exact, portrait, landscape, auto, crop)
       // $resizeObj -> resizeImage($dst_w, $dst_h, 'crop');

// *** 3) Save image
        //$resizeObj -> saveImage($this->getDestination().$resetName.$this -> getfilename().'.gif', 100);
        /*
        $thumb = new Imagick($tempfile);

        $thumb->resizeImage($dst_w,$dst_h,Imagick::FILTER_LANCZOS,1);
        $thumb->writeImage($this->getDestination().$resetName.$this -> getfilename().'.jpeg');

        $thumb->destroy();

        */



         list($src_w,$src_h)=getimagesize($tempfile);  // get primitive image

         $dst_scale = $dst_h/$dst_w; //dst ratio
         $src_scale = $src_h/$src_w; //primitive ratio

         if ($src_scale>=$dst_scale){  // over height
             $w = intval($src_w);
             $h = intval($dst_scale*$w);

             $x = 0;
             $y = ($src_h - $h)/3;
         } else { // over width
             $h = intval($src_h);
             $w = intval($h/$dst_scale);

             $x = ($src_w - $w)/2;
             $y = 0;
         }

         //crop
         $source=imagecreatefromjpeg($tempfile);
         $croped=imagecreatetruecolor($w, $h);
         imagecopy($croped, $source, 0, 0, $x, $y, $src_w, $src_h);

         //resize
         $scale = $dst_w / $w;
         $target = imagecreatetruecolor($dst_w, $dst_h);
         $final_w = intval($w * $scale);
         $final_h = intval($h * $scale);
         $this -> nwidth = $final_w;
         $this -> nheight = $final_h;
         imagecopyresampled($target, $croped, 0, 0, 0, 0, $final_w,$final_h, $w, $h);


         //save
         imagejpeg($target, $this->getDestination().$resetName.$this -> getfilename().'.jpeg',100);

         imagedestroy($target);

         //roate

         $this -> error ='';







    }



    //geolocation extra from image
    public function readGPSinfoEXIF()
    {
        $exif=read_exif_data($this->destination.$this->fileName.'.jpeg');
        if(!$exif || $exif['GPSLatitude']== '') {
            return false;
        } else {

            //get the Hemisphere multiplier
            $LatM = 1; $LongM = 1;
            if($exif["GPSLatitudeRef"] == 'S')
            {
                $LatM = -1;
            }
            if($exif["GPSLongitudeRef"] == 'W')
            {
                $LongM = -1;
            }

            //get the GPS data
            $gps['LatDegree']=$exif["GPSLatitude"][0];
            $gps['LatMinute']=$exif["GPSLatitude"][1];
            $gps['LatgSeconds']=$exif["GPSLatitude"][2];
            $gps['LongDegree']=$exif["GPSLongitude"][0];
            $gps['LongMinute']=$exif["GPSLongitude"][1];
            $gps['LongSeconds']=$exif["GPSLongitude"][2];

            //convert strings to numbers
            foreach($gps as $key => $value)
            {
                $pos = strpos($value, '/');
                if($pos !== false)
                {
                    $temp = explode('/',$value);
                    $gps[$key] = $temp[0] / $temp[1];
                }
            }

            //calculate the decimal degree
            $result['latitude'] = $LatM * ($gps['LatDegree'] + ($gps['LatMinute'] / 60) + ($gps['LatgSeconds'] / 3600));
            $result['longitude'] = $LongM * ($gps['LongDegree'] + ($gps['LongMinute'] / 60) + ($gps['LongSeconds'] / 3600));




            return array($result['latitude'], $result['longitude']);

        }
    }



    /**
     * insert into user table
     */
    public function updateHeaderProflieForUserTable($path,$userId){

        $this->statement='UPDATE iafamily_users SET user_avatar=? WHERE user_id=?';
        $this->bindType= array('s','i');
        $this->bindName= array($path,$userId);
        $this->insertAndUpdateAndDeleteSQL();

        if($this->affectedResult>=1){
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
     * inserting uploaded photo information
     */

    public function insertImageBasicInformation($image_latitude,$image_longitude,$image_desc){

        $this->statement='INSERT INTO iafamily_image (image_id,image_name,image_date,image_latitude,image_longitude,image_desc) VALUES(?,?,?,?,?,?)';
        $this->bindType= array('i','s','s','s','s','s');
        $this->bindName= array($this->imageID,$this->fileName,date('Y-m-d H:i:s'),$image_latitude,$image_longitude,$image_desc);
        $this->insertAndUpdateAndDeleteSQL();
        if($this->affectedResult>0){
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
     *insert the image and group
     */
    public function insertIntoImageAndGroup($imageId,$userId,$familyId){
        $this->statement='INSERT INTO iafamily_image_group (image_id,family_id,uploader_id) VALUES(?,?,?)';
        $this->bindType= array('i','i','i');
        $this->bindName= array($imageId,$familyId,$userId);
        $this->insertAndUpdateAndDeleteSQL();

    }


    /**
     * end
     */




    /**
     * insert into iafamily_image_detail
     */
    public function insertIntoImageDetail($fullImagePath,$resizeImagePath,$halfResizeImagePath){
        $this->statement='INSERT INTO iafamily_image_detail (image_id,image_full_size,image_thumb_size,image_half_size) VALUES(?,?,?,?)';
        $this->bindType= array('i','s','s','s');
        $this->bindName= array($this->imageID,$fullImagePath,$resizeImagePath,$halfResizeImagePath);
        $this->insertAndUpdateAndDeleteSQL();

    }


    /**
     * end
     */




    /**
     *
     * Photo message insert function
     */
    public function photoMessageInsert($messageContent,$senderId,$receiverId){

        $this->statement='INSERT INTO iafamily_message (message_id,message_content,message_type,message_status,sender_id,receiver_id,create_date) VALUES(?,?,?,?,?,?,?)';
        $this->bindType= array('i','s','s','i','i','i','s');
        $this->bindName= array(time(),$messageContent,'photo',1,$senderId,$receiverId,date('Y-m-d H:i:s'));
        $this->insertAndUpdateAndDeleteSQL();

    }


    /**
     * end
     */



}