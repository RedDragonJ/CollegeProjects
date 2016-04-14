<?php

$mysqli = new mysqli("localhost", "root", "killian", "store");
if ($mysqli->connect_errno) {
    echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
}

$sqlSingle = "SELECT * FROM User WHERE ID=".$_SESSION["user"];
$result=mysqli_query($mysqli,$sqlSingle);
$row = $result->fetch_assoc();
?>
<div class="container">

    <div class="panel panel-default">
        <div class="panel-body">

            <div class="jumbotron">
                <h1>Update Algimee</h1>
                <p class="lead">Your Account</p>
            </div>




        </div>
    </div>

    <div class="well">

        <form action="index.php?action=update" method="post" class="form-horizontal">
            <div class="form-group">
                <label for="email" class="col-sm-2 control-label">Email Address:</label>
                <div class="col-sm-10">
                    <input value="<?=$row['Email']?>" type="text" class="form-control" name="Email" placeholder="Email" required>
                </div>
            </div>
            <br>
            <div class="form-group">
                <label for="firstname" class="col-sm-2 control-label">First Name:</label>
                <div class="col-sm-10">
                    <input value="<?=$row['FirstName']?>" type="text" class="form-control" name="FirstName" placeholder="First Name" required>
                </div>
            </div>
            <br>
            <div class="form-group">
                <label for="lastname" class="col-sm-2 control-label">Last Name:</label>
                <div class="col-sm-10">
                    <input value="<?=$row['LastName']?>" type="text" class="form-control" name="LastName" placeholder="Last Name" required>
                </div>
            </div>
            <br>
            <div class="form-group">
                <label for="address" class="col-sm-2 control-label">Address:</label>
                <div class="col-sm-10">
                    <input value="<?=$row['Address']?>" type="text" class="form-control" name="Address" placeholder="Address" required>
                </div>
            </div>
            <br>
            <div class="form-group">
                <label for="city" class="col-sm-2 control-label">City:</label>
                <div class="col-sm-10">
                    <input value="<?=$row['City']?>" type="text" class="form-control" name="City" placeholder="City" required>
                </div>
            </div>
            <br>
            <div class="form-group">
                <label for="state" class="col-sm-2 control-label">State:</label>
                <div class="col-sm-10">
                    <input value="<?=$row['State']?>" type="text" class="form-control" name="State" placeholder="State" required>
                </div>
            </div>
            <br>
            <div class="form-group">
                <label for="zip" class="col-sm-2 control-label">Zip:</label>
                <div class="col-sm-10">
                    <input value="<?=$row['Zip']?>" type="text" class="form-control" name="Zip" placeholder="Zip Code" required>
                </div>
            </div>
            <br>
            <div class="form-group">
                <label for="Phone" class="col-sm-2 control-label">Phone:</label>
                <div class="col-sm-10">
                    <input value="<?=$row['Phone']?>" type="text" class="form-control" name="Phone" placeholder="Phone Number" required>
                </div>
            </div>
            <br>
            <div class="form-group">
                <label for="creaditcard" class="col-sm-2 control-label">Credit Card:</label>
                <div class="col-sm-10">
                    <input value="<?=$row['Credit Card']?>" type="text" class="form-control" name="CC" placeholder="Credit Card Number" required>
                </div>
            </div>
            <br>

            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-10">
                    <button type="submit" class="btn btn-primary btn-lg btn-block">Update</button>
                </div>
            </div>
        </form>


    </div>



</div>
