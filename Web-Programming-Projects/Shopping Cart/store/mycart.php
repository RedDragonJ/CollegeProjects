<?php
$cartID = $_SESSION['cartID'];
$mysqli = new mysqli("localhost", "root", "killian", "store");
if ($mysqli->connect_errno) {
	echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
}
$sqlSingle = "SELECT p.ID as pID, cp.ID as cpID, cp.Qty, p.SKU, p.Descript, p.Price FROM CartProducts cp, Product p WHERE cp.ProductID = p.ID AND cp.CartID =".$cartID;
$result=mysqli_query($mysqli,$sqlSingle);
$count = 0;
$array = null;
while ($row = $result->fetch_assoc()) {
	$array[$count]['Qty'] = $row['Qty'];
	$array[$count]['SKU'] = $row['Descript'];
	$array[$count]['Descript'] = $row['Descript'];
	$array[$count]['cpID'] = $row['cpID'];
	$array[$count]['pID'] = $row['pID'];
	$array[$count]['Price'] = $row['Price'];
	$count++;
}

$query = mysqli_query($mysqli, "SELECT Status FROM SessionCart WHERE CID=".$cartID);
$complete = mysqli_fetch_assoc($query)['Status'];

?>

<div class="container">
	<div class="panel panel-default">
        <div class="panel-body">

            <div class="jumbotron">
                <h1>My Shopping Cart</h1>
                <p class="lead">List of your items below</p>
            </div>




        </div>
    </div>
	
	<div class="row">
		<?php if($complete==1){echo "<div class='well'>Your Order has been placed already.  Please Leave and wait for shippment</div>";}else{ ?>
		<div class="col-xs-6">
            <div class="well">

				<select id="shippingType">
					<option value="10">Ground $10</option>
					<option value="15">Over Night $15</option>
					<option value="20">Over Night $20</option>
				</select>

				<br>
			
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
									<input cost="<?=$item['Price']?>" id="<?=$item['cpID']?>" class="form-control qtymeter" type="text" name="fname" value="<?=$item['Qty']?>" size="4">
									<br>
									<p><strong>Total Cost:</strong></p>
									<p>$<span class="itemCost" id="<?=$item['cpID']?>-tot"><?=($item['Price']*$item['Qty'])?></span></p>
									<br>
									<button id="<?=$item['cpID']?>" class="btn btn-danger btn-sm removeItem">Remove Item</button>
								</div>
							</div>
						</div>
					</li>

					<?php } ?>

				</ul>
	
			</div>
        </div>
        <div class="col-xs-6">
            <div class="well">
				<h3 class="register text-center"><strong>Order Summary</strong></h3>
				<div class="well" style="background-color:white">
					<div class="row">
						<div class="col-xs-6">
							<p class="text-left"><strong>Subtotal:</strong></p> 
							<p class="text-left"><strong>Shipping:</strong></p> 
							<h3 class="register text-left"><strong>Total:</strong></h3>
						</div>
						<div class="col-xs-6">
							<p class="text-right">$<span id="subtotalc"></span></p>
							<p class="text-right">$<span id="shippingc"></span></p>
							<h3 class="register text-right"><strong>$<span id="totalc"></span></strong></h3>
						</div>
					</div>
				</div>
				<a href="index.php?action=final" class="btn btn-warning center-block btn-lg">Check Out</a>
				<br>
			</div>
        </div>
	
	</div>
<?php } ?>
</div>
<script>

	function updateTotals(){
		var subtot = 0;
		$( ".itemCost" ).each(function( index ) {
			subtot+= parseFloat($(this).text());
		});

		$("#subtotalc").text(subtot);
		$("#shippingc").text($( "#shippingType option:selected" ).val());
		var tott = parseFloat($("#subtotalc").text())  + parseFloat($("#shippingc").text());
		$("#totalc").text(tott);
	}

	$(".qtymeter").keyup(function() {
		var $me = $(this)
		$.ajax({
			type: "POST",
			url: "index.php?action=updateQTY",
			data: "cpID="+$(this).attr('id')+"&Qty="+$(this).val(),
			success: function (data) {
				$("#"+data+"-tot").text($me.val()*$me.attr("cost"));
				updateTotals();
			}
		});

	});

	$(".removeItem").click(function() {
		var $me = $(this);
		$.ajax({
			type: "POST",
			url: "index.php?action=removeItem",
			data: "cpID="+$(this).attr('id'),
			success: function (data) {
				$("#"+data+"-li").remove();
				updateTotals();
			}
		});
	});

	$(function() {
		updateTotals();
	});

	$("#shippingType").change(updateTotals);




</script>