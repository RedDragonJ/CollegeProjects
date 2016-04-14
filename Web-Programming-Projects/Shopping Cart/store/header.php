<html>
<head>
    <title><?=(isset($pageTitle)?$pageTitle:"Unknown page")?></title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" rel="stylesheet">
    <link type="text/css" rel="stylesheet" href="http://gregfranko.com/jquery.selectBoxIt.js/css/jquery.selectBoxIt.css" />
    <link type="text/css" href="css/inputsidecolors.css"  rel="stylesheet" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
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
            <a class="navbar-brand" href="?action=home">AlgimStore</a>
        </div>
        <div id="navbar" class="collapse navbar-collapse">
            <ul class="nav navbar-nav pull-right">
                <li><a href="?action=login">My Account</a></li>
               <?php if(!isLoggedin()){?> <li><a href="?action=create">Create Account</a></li><?php }else{echo ' <li><a href="?action=logout">Log Out</a></li>';} ?>
                <li><a href="?action=final">Checkout</a></li>
				<li><a href="?action=mycart"><span style="color:Orange" class="glyphicon glyphicon-shopping-cart" aria-hidden="true"></span> My Shopping Cart</a></li>
            </ul>
			
            <ul class="nav navbar-nav">
                <li class="active"><a href="?action=home">Home</a></li>
            </ul>
        </div><!--/.nav-collapse -->
    </div>
</nav>





