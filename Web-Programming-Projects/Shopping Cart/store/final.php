<?php
$mysqli = new mysqli("localhost", "root", "killian", "store");
if ($mysqli->connect_errno) {
    echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
}
$sqlSingle = "SELECT * FROM User WHERE ID=".$_SESSION["user"];
$result=mysqli_query($mysqli,$sqlSingle);
$row = $result->fetch_assoc();

$cartID = $_SESSION['cartID'];
$sqlSingle = "SELECT p.ID as pID, cp.ID as cpID, cp.Qty, p.SKU, p.Descript, p.Price FROM CartProducts cp, Product p WHERE cp.ProductID = p.ID AND cp.CartID =".$cartID;
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
<div class="container">
    <div class="panel panel-default">
        <div class="panel-body">

            <div class="jumbotron">
                <h1>Finalize Order</h1>
                <p class="lead">Details</p>
            </div>




        </div>
    </div>

    <div class="well">
     <div class="row">
         <div class="col-md-6">
             <h3>User Details</h3>
             <p><b>Name:</b> <?=$row['FirstName']?>  <?=$row['LastName']?></p>
             <p><b>Address:</b> <?=$row['Address']?>  <?=$row['City']?><br><?=$row['State']?>, <?=$row['Zip']?></p>

         </div>

         <div class="col-xs-6">
             <div class="well">

                 <h3 class="register text-center"><strong>Order Summary</strong></h3>
                 <div class="well" style="background-color:white">
                     * Only Ground Shipping available currently. Sorry for the inconvenience.
                     <div class="row">
                         <div class="col-xs-6">
                             <p class="text-left"><strong>Subtotal:</strong></p>
                             <p class="text-left"><strong>Shipping:</strong></p>
                             <h3 class="register text-left"><strong>Total:</strong></h3>
                         </div>
                         <div class="col-xs-6">
                             <p class="text-right">$<span id="subtotalc"><?= $total?></span></p>
                             <p class="text-right">$<span id="shippingc">10</span></p>
                             <h3 class="register text-right"><strong>$<span id="totalc"><?= $total+10?></span></strong></h3>
                         </div>
                     </div>
                 </div>
                 <a href="index.php?action=final&done=1" class="btn btn-warning center-block btn-lg">Finish</a>
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
                                     <p><strong>Price:</strong></p>
                                     <p>$<?=$item['Price']?></p>

                                     <p><strong>Quantity:</strong></p>
                                    <?=$item['Qty']?>
                                     <br>
                                     <p><strong>Total Cost:</strong></p>
                                     <p>$<span class="itemCost" id="<?=$item['cpID']?>-tot"><?=($item['Price']*$item['Qty'])?></span></p>


                                 </div>
                             </div>
                         </div>
                     </li>

                 <?php } ?>

             </ul>
         </div>




         </div>
     </div>
    </div>

