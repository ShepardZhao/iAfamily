<?php include_once "lib/controller/userInfoFetchController.php";?>
<div class="col-lg-12">
    <div class="panel panel-default">
        <div class="panel-heading">
            <h3 class="panel-title"><i class="fa fa-wrench fa-fw"></i> Administrator Accounts</h3>
        </div>
        <div class="panel-body">
            <?php
            $userInfoFetch ->fetchAdminsInfoApi($Mysql_Connection);
            $getArray =json_decode($userInfoFetch->execute());

            echo '<div class="table-responsive">';

            echo '<table class="table table-bordered table-hover">';

            echo '<thead>';

            echo '<tr>';

            echo '<th>Email</th>';
            echo '<th>Password</th>';
            echo '<th>Operation</th>';
            echo '</tr>';
            echo '</thead>';
            echo '<tbody>';
            echo '<tr>';

            foreach ($getArray as $key=>$value){
                   if($key==='administrator'){
                       echo '<td>'.$value.'</td>';
                   }
                   elseif($key==='password'){
                       echo '<td>'.$value.'</td>';
                   }
            }
            echo '<td><button type="button" class="btn btn-default btn-sm">Modifiy</button></td>';

            echo '</tr>';

            echo '</tbody>';

            echo '</table>';
            echo '</div>';

            ?>
        </div>
    </div>

    <!-- users -->
    <div class="panel panel-default">
        <div class="panel-heading">
            <h3 class="panel-title"><i class="fa fa-wrench fa-fw"></i> Users' Accounts</h3>
        </div>
        <div class="panel-body">
            <?php

            $userInfoFetch ->fetchUsersInfoApi($Mysql_Connection);
            $getArray =json_decode($userInfoFetch->execute());

            echo '<div class="table-responsive">';

            echo '<table class="table table-bordered table-hover">';

            echo '<thead>';

            echo '<tr>';
            echo '<th>Profile</th>';
            echo '<th>ID</th>';
            echo '<th>Email</th>';
            echo '<th>Age</th>';
            echo '<th>Name</th>';
            echo '<th>Phone</th>';
            echo '<th>Type</th>';
            echo '<th>Gender</th>';
            echo '<th>Status</th>';
            echo '<th>Operation</th>';



            echo '</tr>';
            echo '</thead>';
            echo '<tbody>';

            foreach ($getArray as $index=>$subArray){
                $userId =null; //Temp store UserID
                $userEmail = null;
                $userAge = null;
                $userName = null;
                $userPhone = null;
                $userType = null;
                $userGender = null;
                echo '<tr>';
                foreach ($subArray as $subIndex=>$value){
                    if($subIndex==='userAvatar'){
                        echo $value;
                       if($value==''){
                           echo '<td><img src="/img/default.png" alt="default header Profile"></td>';

                       }
                    }
                    if($subIndex==='userId'){
                        $userID = $value;
                        echo '<td>'.$value.'</td>';
                    }
                    if($subIndex==='userEmail'){
                        $userEmail = $value;
                        echo '<td>'.$value.'</td>';
                    }
                    if($subIndex==='userAge'){
                        $userAge = $value;

                        echo '<td>'.$value.'</td>';
                    }
                    if($subIndex==='userName'){
                        $userName = $value;

                        echo '<td>'.$value.'</td>';
                    }
                    if($subIndex==='userPhone'){
                        $userPhone = $value;

                        echo '<td>'.$value.'</td>';
                    }
                    if($subIndex==='userType'){
                        $userType = $value;
                        echo '<td>'.$value.'</td>';
                    }

                    if($subIndex==='userGender'){
                        $userGender = $value;
                        echo '<td>'.$value.'</td>';
                    }

                    if($subIndex==='userStatus'){
                        if($value===0){
                            echo '<td><i class="fa fa-circle" style="color:#BDC3C7 "></i></td>';

                        }
                        elseif($value ===1){
                            echo '<td><i class="fa fa-circle" style="color:#2ECC71 "></i></td>';

                        }
                    }

                }
                echo '<td><button type="button" id='.$userID.' class="userModifyBtn btn btn-default btn-sm">Modifiy</button></td>';

                echo '</tr>';
                echo "<tr class='active rowDetail rowDetail_$userID'><td colspan='9'>";
                ?>
                <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">

                        <div class="panel-body">
                            <div class="input-group col-lg-4 col-sm-12 col-md-12">
                                <input type="text" id="modifiedUserID" class="form-control" disabled value="<?php echo $userID;?>">
                            </div>
                            <br>
                            <div class="input-group col-lg-4 col-sm-12 col-md-12">
                                <input type="email" id="email" class="form-control" value="<?php echo $userEmail;?>">
                            </div>
                            <br>

                            <div class="input-group col-lg-4 col-sm-12 col-md-12">
                                <input type="password" id="password_1" class="form-control" placeholder="Password">
                            </div>
                            <br>

                            <div class="input-group col-lg-4 col-sm-12 col-md-12">
                                <input type="password" id="password_2" class="form-control" placeholder="Re-Password">
                            </div>
                            <br>

                            <div class="input-group col-lg-4 col-sm-12 col-md-12">
                                <input type="text" id="name" class="form-control" value="<?php echo $userName;?>">
                            </div>
                            <br>

                            <div class="input-group col-lg-4 col-sm-12 col-md-12">
                                <select  id="age" class="form-control">
                                    <?php
                                    echo '<option value="Age" default selected>Age</option>';
                                    for($i=1;$i<=100;$i++){
                                        echo '<option value='.$i.'>'.$i.'</option>';
                                    }
                                    ?>

                                </select>
                            </div>
                            <br>

                            <div class="input-group col-lg-4 col-sm-12 col-md-12">
                                <input type="text" id="phone" class="form-control" value="<?php echo $userPhone;?>">
                            </div>

                            <div class="input-group col-lg-4 col-sm-12 col-md-12">
                                <?php
                                if($userGender === 'Male'){
                                ?>
                                    <label class="radio-inline">
                                        <input type="radio" class="gender" name="inlineRadioOptions_<?php echo $userID?>" value="Male" checked="checked"> Male
                                    </label>
                                    <label class="radio-inline">
                                        <input type="radio"  class="gender" name="inlineRadioOptions_<?php echo $userID?>" value="Female"> Female
                                    </label>
                                <?php
                                }
                                elseif($userGender === 'Female'){
                                    ?>
                                    <label class="radio-inline">
                                        <input type="radio" class="gender" name="inlineRadioOptions_<?php echo $userID?>" value="Male"> Male
                                    </label>
                                    <label class="radio-inline">
                                        <input type="radio"  class="gender" name="inlineRadioOptions_<?php echo $userID?>" value="Female" checked="checked"> Female
                                    </label>

                                <?php
                                }?>
                            </div>
                            <br>
                            <button type="button" id="ModifiiedButton" class="btn btn-default">Submit</button>

                        </div>
                    </div>
                </div>
                </div>

                <?


                echo '</td></tr>';

            }




            echo '</tbody>';

            echo '</table>';
            echo '</div>';

            ?>






        </div>
    </div>









</div>