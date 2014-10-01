<?php
/**
 * Created by PhpStorm.
 * User: Shepard
 * Date: 12/08/14
 * Time: 4:51 PM
 */
session_start();
if(!isset($_SESSION['username'])){
    header('Location: login.php');
}else{
 ?>
    <!--here to start the html code-->

    <!DOCTYPE html>
    <html lang="en">

    <head>

        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="">

        <title>iafamy - CMS</title>

        <!-- Bootstrap Core CSS -->
        <link href="css/bootstrap.min.css" rel="stylesheet">

        <link href="css/animate.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link href="css/iafamily.css" rel="stylesheet">

        <!-- Custom Fonts -->
        <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" rel="stylesheet">

        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
        <![endif]-->

    </head>

    <body>

    <div id="wrapper">

    <!-- Navigation -->
    <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
        <!-- Brand and toggle get grouped for better mobile display -->
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="index.html">Iafamily Content Management System</a>
        </div>
        <!-- Top Menu Items -->
        <ul class="nav navbar-right top-nav">


            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="fa fa-user"></i> <?php echo $_SESSION['username']?> <b class="caret"></b></a>
                <ul class="dropdown-menu">
                    <li>
                        <a href="/logoff.php"><i class="fa fa-fw fa-power-off"></i> Log Out</a>
                    </li>
                </ul>
            </li>
        </ul>
        <!-- Sidebar Menu Items - These collapse to the responsive navigation menu on small screens -->
        <div class="collapse navbar-collapse navbar-ex1-collapse">
            <ul class="nav navbar-nav side-nav">
                <li class="active">
                    <a id="systemSetting"><i class="fa fa-fw fa-wrench"></i> System Setting</a>
                </li>


                <li>
                    <a  href="javascript:;" data-toggle="collapse" data-target="#usersDowndrop"><i class="fa fa-fw fa-users"></i> Users <i class="fa fa-fw fa-caret-down"></i></a>
                    <ul id="usersDowndrop" class="collapse nav">
                        <li>
                            <a id="users">View Users</a>
                        </li>
                        <li>
                            <a id="register">Register</a>
                        </li>
                    </ul>
                </li>


                <li>
                    <a id="familyCircles"><i class="fa fa-fw  fa-circle-o-notch"></i> Family Circles</a>
                </li>
                <li>
                    <a id="photos"><i class="fa fa-fw fa-file-image-o"></i> Photos</a>
                </li>
                <li>
                    <a id="comments"><i class="fa fa-fw fa-comment"></i> Comments</a>
                </li>
              <!-- comments--
                <li>
                    <a href="javascript:;" data-toggle="collapse" data-target="#demo"><i class="fa fa-fw fa-arrows-v"></i> Dropdown <i class="fa fa-fw fa-caret-down"></i></a>
                    <ul id="demo" class="collapse">
                        <li>
                            <a href="#">Dropdown Item</a>
                        </li>
                        <li>
                            <a href="#">Dropdown Item</a>
                        </li>
                    </ul>
                </li>
               -->
            </ul>
        </div>
        <!-- /.navbar-collapse -->
    </nav>

    <div id="page-wrapper">

    <div class="container-fluid">

    <!-- Page Heading -->
    <!-- /.row -->

    <div class="row" id="content">
        <!-- here to use ajax to insert the page-->
    </div>
    <!-- /.row -->


    <!-- /.row -->

    </div>
    <!-- /.container-fluid -->

    </div>
    <!-- /#page-wrapper -->

    </div>
    <!-- /#wrapper -->

    <!-- jQuery Version 1.11.0 -->
    <script src="//code.jquery.com/jquery-1.11.1.min.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="js/bootstrap.min.js"></script>

    <script src="js/jquery.md5.js"></script>


    <script src="js/iafamily.js"></script>

    </body>

    </html>




<?php
}
