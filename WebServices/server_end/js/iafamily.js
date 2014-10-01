/**
 * Created by Shepard on 5/08/14.
 */

$(document).ready(function(){

    /**
     * login ajax
     */

    $('body').on('click','#login',function(){

        loginAjax();

    });

    //login check
    function loginAjax(){
        $('#login').text('Waiting...');
        if($('#email').val()!=='' && $('#password').val()!==''){
            $.ajax({
                type: "POST",
                url: 'restful/loginRestful.php',
                data: {'loginEmail':$('#email').val(),
                       'password': $.md5($('#password').val()),
                       'role':'admin'
                },
                dataType: 'json'
            })
              .done(function( data ) {
                    console.log(data);
                    if(data.success!=='true'){
                        $("<div class='alert alert-warning' role='alert'>Sorry!, wrong Email or password</div>").insertBefore($('#login'));
                        $('#login').text('Login');
                    }
                    else{
                        if($('.alert').length>0){
                        $('.alert').fadeOut(500,function(){$('body').find('.alert').remove();$("<div class='alert alert-success' role='alert'>Great! you username and password has been authorised</div>").insertBefore($('#login')); window.location.href = "admin.php";});
                        }
                        else{
                            $("<div class='alert alert-success' role='alert'>Great! you username and password has been authorised</div>").insertBefore($('#login'));
                             window.location.href = "admin.php";
                        }
                    }
              });
        }
    else{
            //insert the error message
            $("<div class='alert alert-warning' role='alert'>Sorry!, wrong Email or password</div>").insertBefore($('#login'));
            $('#login').text('Login');
            }

    }




    /**
     * end
     */


    $(function(){
        if($('#content').find('.panel').length==0){
            contentAjax("systemSetting.php");
        }
    });




    /**
     * ajax to insert the systemSetting
     */
    $('body').on('click','#systemSetting',function(){
        //call ajax
        addActiveClass($(this));
        contentAjax("systemSetting.php");

    });




    /**
     * end
     */


    /**
     * ajax to insert the users
     */
    $('body').on('click','#users',function(){
        //call ajax
        addActiveClass($(this));
        contentAjax("users.php");

    });



    /**
     * end
     */


    /**
     * ajax to insert the register
     */
    $('body').on('click','#register',function(){
        //call ajax
        addActiveClass($(this));
        contentAjax("register.php");
    });


    //click submit button
    $('body').on('click','#registerButton',function(){
        var success = true;
        var name = new Array();
        if($('#email').val()==''){
            //the email should not be empty
            success = false;
            name.push('email');
        }

        if($.md5($('#password_1').val())!= $.md5($('#password_2').val())){
            //the password should be matched
            success = false;
            name.push('password');
        }

        if($('#name').val()==''){
            //the name should not be empty
            success = false;
            name.push('name');
        }

        if($('#age').val()=="Age"){
            //the age should not be empty
            success = false;
            name.push('age');

        }

        if($('#phone').val()=='' || !$.isNumeric($('#phone').val())){
            //the phone should not be empty
            success = false;
            name.push('phone');
        }

        if($('.gender').val()==''){
            //the gender should be chosen
            success = false;
            name.push('gender');
        }



        if(success && name.length==0){
            //here to submit the form
            registerAjaxForm();
        }
        else{
            //to display the error message
            $('<div class="alert alert-warning" role="alert">Sorry!, The <b style="color: #E74C3C">' + name + ' </b>field(s) has or have error</div>').insertBefore($('#registerButton'));


        }

    });


    //ajax to submit the register form
    function registerAjaxForm(){
        var request = $.ajax({
            url: "restful/registerRestful.php",
            type: "GET",
            data: { 'email' : $('#email').val(), 'password':$.md5($('#password_1').val()),'name':$('#name').val(),'age':$('#age').val(),'phone':$('#phone').val(),'gender':$('.gender').val() },
            dataType: "json"
        });

        request.done(function( data ) {
            if(data.success=='true'){
                $('<div class="alert alert-success" role="alert">Great! your account has been created.</div>').insertBefore($('#registerButton'));

            }
            else if(data.success=='false' && data.error!=''){
                $('<div class="alert alert-warning" role="alert">Sorry!, The email address <b style="color: #E74C3C">' + data.error + ' </b>already existed.</div>').insertBefore($('#registerButton'));

            }


        });

        request.fail(function( jqXHR, textStatus ) {
            alert( "Request failed: " + textStatus );
        });
    }


    /**
     * end
     */


    /**
     * ajax to insert the familyCircle
     */
    $('body').on('click','#familyCircles',function(){
        //call ajax
        addActiveClass($(this));
        contentAjax("familyCircles.php");
    });

    /**
     * end
     */



    /**
     * ajax to insert the familyCircle
     */
    $('body').on('click','#photos',function(){
        //call ajax
        addActiveClass($(this));
        contentAjax("photos.php");
    });

    /**
     * end
     */


    /**
     * ajax to insert the familyCircle
     */
    $('body').on('click','#comments',function(){
        //call ajax
        addActiveClass($(this));
        contentAjax("comments.php");
    });

    /**
     * end
     */


    /**
     * common ajax function
     * @param page
     * @constructor
     */
    function contentAjax(page){
        $('#content').fadeOut(500,function(){$(this).empty().append('<div class="row"><div class="col-lg-12 text-center"><i class="fa fa-circle-o-notch fa-spin fa-2x" style="color: #1ABC9C"></i></div></div>').fadeIn();});
        $.get(page, function(data) {
            if(data!=''){
                $('#content').fadeOut(500,function(){$(this).empty().append(data).fadeIn(); $('.rowDetail').hide();});

            }

        })

    }

    /**
     * end
     */


    /**
     * add active class
     */
    function addActiveClass(GetThis){
        $('li').removeClass('active');
        $(GetThis).parent().addClass('active');


    }


    /**
     * end
     */


    /**
     * slide the the user manage window
     */
    $('body').on('click','.userModifyBtn',function(){
        var uniqueID = $(this).attr('id');
        var className = '.rowDetail_'+uniqueID;
        $(this).parent().parent().parent().find(className).fadeIn();

    });


    /**
     * end
     */

    /**
     * change the user info
     */
    $('body').on('click','.ModifiiedButton',function(){
        var request = $.ajax({
            url: "restful/userInfoChangeRestful.php",
            type: "GET",
            data: { 'modifiedUserID' : $('#modifiedUserID').val(), 'modifiedmail':$('#email').val(),'modifiedName':$('#name').val() ,'modifiedPassword':$.md5($('#password_1').val()),'modifiedAge':$('#age').val(),'modifiedPhone':$('#phone').val(),'modifiedGender':$('.gender').val() },
            dataType: "json"
        });

        request.done(function( data ) {
            if(data.success=='true'){
                $('<div class="alert alert-success" role="alert">Great! your account has been created.</div>').insertBefore($('#registerButton'));

            }
            else if(data.success=='false' && data.error!=''){
                $('<div class="alert alert-warning" role="alert">Sorry!, The email address <b style="color: #E74C3C">' + data.error + ' </b>already existed.</div>').insertBefore($('#registerButton'));

            }


        });

        request.fail(function( jqXHR, textStatus ) {
            alert( "Request failed: " + textStatus );
        });
    });





    /**
     * end
     */



});