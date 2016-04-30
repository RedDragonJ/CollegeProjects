<html>
<head>
    <title><?=(isset($page['title'] )?$page['title'] :"Unknown page")?></title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" rel="stylesheet">
    <link type="text/css" rel="stylesheet" href="http://gregfranko.com/jquery.selectBoxIt.js/css/jquery.selectBoxIt.css" />
    <link type="text/css" href="css/signin.css"  rel="stylesheet" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/js/toastr.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/css/toastr.css" rel="stylesheet">
</head>
<body>

<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="?action=home">East 2.0</a>
        </div>
        <div id="navbar" class="collapse navbar-collapse">

			
            <ul class="nav navbar-nav">
                <li class="active"><a href="?action=home">Home</a></li>
				<?php if(isLoggedIn()){?><li><a href="?action=myaccount">My Account</a></li><?php } ?>
				<?php if(isLoggedIn()){?><li><a href="?action=logout">Log Out</a></li><?php } ?>
                <?php if ($_SESSION['userType'] == 1){?><li><a href="?action=addUsers">Add User</a></li><?php } ?>
            </ul>
        </div><!--/.nav-collapse -->
    </div>
</nav>





