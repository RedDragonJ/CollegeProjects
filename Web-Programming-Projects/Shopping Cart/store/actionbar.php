<form id="actionBarForm" action="index.php?action=home" method="get">
<div class="row">
    <div class="col-md-6">
        <div class="input-group">
            <input name="keyword" value="<?=(isset($_GET['keyword'])!=null?$_GET['keyword']:"")?>" type="text" class="form-control" placeholder="Keyword Search">
                        <span class="input-group-btn">
                        <input type="submit" class="btn btn-default" value="Search">
                        </span>
        </div>
    </div>
    <div class="col-md-3">
        <select id="brand" name="brand" class="form-control">
            <option value="-1">Select A Brand</option>
            <option <?=((isset($_GET['brand'])!=null&&$_GET['brand']==2)?"selected":"");?> value="2">IBM </option>
            <option <?=((isset($_GET['brand'])!=null&&$_GET['brand']==1)?"selected":"");?> value="1">Lexmark</option>
            <option <?=((isset($_GET['brand'])!=null&&$_GET['brand']==3)?"selected":"");?> value="3">Hewlett Packard </option>
            <option <?=((isset($_GET['brand'])!=null&&$_GET['brand']==4)?"selected":"");?> value="4">Canon</option>
        </select>
    </div>
    <div class="col-md-3">
        <select id="makeSelect" name="make" disabled class="form-control">
            <option value="-1">Select A Make</option>
        </select>
    </div>
	
</div>
</form>

<script>
    $(function() {
        $("#brand").change(function() {
                $('#makeSelect').prop('disabled', true);

            $("#actionBarForm").submit();
        })
        $("#makeSelect").change(function() {
            $("#actionBarForm").submit();
        })

        <?php
        if(isset($_GET['brand'])!=null&&$_GET['brand']!=-1){
            ?>

        id = <?=$_GET['brand']?>;
        $('#makeSelect').prop('disabled', false);
        $form = $("#actionBarForm");
        $('#makeSelect').children().remove();
        $('#makeSelect').append('<option value="-1">Select A Make</option>');
        $.ajax({
            type: "GET",
            url: $form.attr('action'),
            data: "action=compatibleJSON&id=" + id,
            success: function (data) {
                data = JSON.parse(data);
                $.each(data, function (key, item) {
                    <?php
                    if(isset($_GET['make'])!=null&&$_GET['make']!=-1){
                    echo "selectID = ".$_GET['make'].";";
                    ?>
                    $('#makeSelect').append("<option "+(selectID==item.ID?"Selected":"")+" value='" + item.ID + "' > " + item.Title + "</option>");
                    <?php } else { ?>
                    $('#makeSelect').append("<option value='" + item.ID + "' > " + item.Title + "</option>");
                    <?php }?>
                });
            }
        });
        $('#makeSelect').focus();
        //$('#makeSelect').data("selectBoxIt").refresh();

        <?php
        }
        ?>



    });


</script>
