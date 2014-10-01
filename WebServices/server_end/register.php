<div class="col-lg-12">
    <div class="panel panel-default">
        <div class="panel-heading">
            <h3 class="panel-title"><i class="fa fa-wrench fa-fw"></i> Register</h3>
        </div>
        <div class="panel-body">
            <div class="input-group col-lg-4 col-sm-12 col-md-12">
                <input type="email" id="email" class="form-control" placeholder="Email">
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
                <input type="text" id="name" class="form-control" placeholder="Name">
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
                <input type="text" id="phone" class="form-control" placeholder="Phone">
            </div>

            <div class="input-group col-lg-4 col-sm-12 col-md-12">
                <label class="radio-inline">
                    <input type="radio" class="gender" name="inlineRadioOptions" value="Male" checked="checked"> Male
                </label>
                <label class="radio-inline">
                    <input type="radio"  class="gender" name="inlineRadioOptions" value="Female"> Female
                </label>
            </div>
            <br>
            <button type="button" id="registerButton" class="btn btn-default">Submit</button>

        </div>
    </div>
</div>