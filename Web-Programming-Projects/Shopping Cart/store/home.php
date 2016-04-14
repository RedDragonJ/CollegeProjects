<div class="container">

    <div class="panel panel-default">
        <div class="panel-body">

            <div class="jumbotron">
                <h1>AlgimStore</h1>
                <p class="lead">Use this webpage to view and pretend to buy Ink Stuff!! Most CSS Styling was done with
                    Bootstrap.<br>Please use appropriately.</p>
            </div>

            <?php include 'actionbar.php';?>


        </div>
    </div>

    <div class="well">

        <div class="row">
            <?php foreach ($items as &$item) {

                ?>

            <div class="col-sm-6 col-md-4">
                <div class="thumbnail">

                    <div class="caption">
                        <h3><?=$item['Desc']?></h3>
                        <p><b>Brand:</b> <?= getProductBrand($item['ID']);?></p>
                        <p><b>SKU:</b> <?=$item['SKU']?></p>
                        <p><b>Compatible Models:</b> <?php foreach (getProductMake($item['ID']) as &$make) { echo "{".$make."} "; }?></p>


                        <div class="input-group">
                            <span class="input-group-addon success"><strong>$<?=$item['Price']?></strong></span>
                            <input id="<?=$item['ID']?>-qty" type="text" class="form-control" placeholder="QTY" value="1" >
                            <span class="input-group-btn">
                        <button id="<?=$item['ID']?>" class="btn btn-primary addToCart" type="button"><span class="glyphicon glyphicon-shopping-cart" aria-hidden="true"></span> Add To Cart</button>
                        </span>
                        </div>



                    </div>
                </div>
            </div>
            <?php } ?>


        </div>



    </div>



</div>
<script>
$(".addToCart").click(function() {
    var $me = $(this);
    $.ajax({
    type: "POST",
    url: "index.php?action=mycart",
    data: "addID="+$me.attr('id'),
    success: function (data) {
        $.ajax({
            type: "POST",
            url: "index.php?action=updateQTY",
            data: "cpID="+data+"&Qty="+$("#"+$me.attr('id')+"-qty").val(),
            success: function (data) {
                window.location.href='index.php?action=mycart';
            }
        });

    }
    });
});
</script>
