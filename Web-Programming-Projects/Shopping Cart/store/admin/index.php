
<?php
require_once '../functions.php';
session_start();
checkSession();

if (!isLoggedin()) {

echo "You need to login.. Go here <a href='../index.php?action=login'>Login</a>";

}else{
    if($_SESSION["user"]!=1){
        echo "You are the wrong user..";
    } else {


        $mysqli = new mysqli("localhost", "root", "killian", "store");
        if ($mysqli->connect_errno) {
            echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
        }


        if(!isset($_GET['deets'])) {

            $sql = "SELECT * FROM SessionCart WHERE Status=1 ORDER BY CompleteDate DESC";
            $result = mysqli_query($mysqli, $sql);
            echo "List Of Completed Transacions<table><tr><th>ID</th><th>Date</th></tr>";
            while ($row = $result->fetch_assoc()) {
                echo "<tr>";
                echo "<td><a href='index.php?deets=" . $row['CID'] . "'>" . $row['CID'] . "</a></td>";
                echo "<td>" . $row['CompleteDate'] . "</td>";
                echo "</tr>";
            }
        }else{
echo '<a href="index.php">Back</a>';
            $sql = "SELECT * FROM SessionCart sc, Sessions s, User u WHERE s.UserID=u.ID AND s.ID=sc.SessionID AND sc.CID=".$_GET['deets'];
            error_log($sql);
            $result = mysqli_query($mysqli, $sql);
            while ($row = $result->fetch_assoc()) {
                ?>
<div class="col-md-6">
    <h3>User Details</h3>
    <p><b>Name:</b> <?=$row['FirstName']?>  <?=$row['LastName']?></p>
    <p><b>Address:</b> <?=$row['Address']?>  <?=$row['City']?><br><?=$row['State']?>, <?=$row['Zip']?></p>

</div>
<?php
            }

            $sqlSingle = "SELECT p.ID as pID, cp.ID as cpID, cp.Qty, p.SKU, p.Descript, p.Price FROM CartProducts cp, Product p WHERE cp.ProductID = p.ID AND cp.CartID =".$_GET['deets'];
            $result=mysqli_query($mysqli,$sqlSingle);
            $count = 0;
            $array = null;
            $total = 0;
            while ($row2 = $result->fetch_assoc()) {
                $array[$count]['Qty'] = $row2['Qty'];
                $array[$count]['SKU'] = $row2['Descript'];
                $array[$count]['Descript'] = $row2['Descript'];
                $array[$count]['cpID'] = $row2['cpID'];
                $array[$count]['pID'] = $row2['pID'];
                $array[$count]['Price'] = $row2['Price'];
                $total+= $row2['Price']*$row2['Qty'];
                $count++;
            }



            ?>

<div class="col-xs-6">
    <div class="well">

        <h3 class="register text-center"><strong>Order Summary</strong></h3>
        <div class="well" style="background-color:white">
            * Only Ground Shipping available currently. Sorry for the inconvenience.<br>
            Subtotal:$<?= $total?><br>
            Shipping:10<br>
            Total:$<span id="totalc"><?= $total+10?><br>
                </div>

            </div>
        </div>
        <br>
    </div>
</div>
<div class="col-md-6">
    <ul class="list-group">
        <?php foreach ($array as &$item) { ?>
            <li id="<?=$item['cpID']?>-li" class="list-group-item">
                <div class="well">
                    <div class="row">
                        <div class="col-xs-6">
                            <p><strong><?= getProductBrand($item['pID']);?> <?= getProductMake($item['pID'])[0];?><?=$item['Descript']?></strong></p>
                        </div>
                        <div class="col-xs-6">
                            <p><strong>Price:</strong>
                            $<?=$item['Price']?></p>

                            <p><strong>Quantity:</strong>
                            <?=$item['Qty']?>

                            <p><strong>Total Cost:</strong>
                            $<span class="itemCost" id="<?=$item['cpID']?>-tot"><?=($item['Price']*$item['Qty'])?></span></p>


                        </div>
                    </div>
                </div>
            </li>

        <?php } ?>

    </ul>


<?php






        }



    }
}

?>


