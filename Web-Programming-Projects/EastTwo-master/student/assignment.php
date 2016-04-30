<div class="container body-container">
<h2>Submissions</h2>
<div class="well">
<h3><?=$page['studentAssSubmissions']['assignmentName']?></h3>
<?php
	if(!isset($page['studentAssSubmissions']['submissions'])){
		echo "There are no submissions at this time.";
	}
?>

<div class="list-group">
<?php foreach($page['studentAssSubmissions']['submissions'] as $submission){ ?>
  <a class="list-group-item <?=($submission['graded']?'':'')?>">
    <h4 class="list-group-item-heading"><?=$submission['submissionDate']?> Submission</h4>
    <p class="list-group-item-text">Comments: <?=$submission['comments']?></p>
	<p class="list-group-item-text">FeedBack: <?=$submission['feedback']?></p>
	<p class="list-group-item-text"><strong>Grade: <?=$submission['graded']?>/100</strong></p>
  </a>
 <?php }?>
</div>

</div>

<?php if($page['studentAssSubmissions']['canSubmit']){?>
<div class="well">
<h3>Submission Area</h3>
<!-- 
THIS Submission area will be a good place to put our required AJAX stuff..
-->

  <div class="form-group">
    <label for="submissionComments">Comments</label>
    <textarea class="form-control" id="subComments"rows="3"></textarea>
  </div>
  <div class="form-group">
    <label for="upLoadButton">Upload File</label><br>
      <span class="btn btn-default btn-file">
        Browse Files <input type="file">
    </span>
  </div>
  <div class="form-group">
  <button id="submitAssignment" class="btn btn-primary"> Submit Assignment </button>
  </div>


</div>
</div>
<?php } ?>

<script>
// Later I will make this update a file and post to a function to create a new submission
$(function() {

    //comments, feedback, fileloc, graded

  $("#submitAssignment").click(function(e){
    comments = $("#subComments").val();
    assID = <?= $_GET['assignmentID'] ?>;

    $.ajax({
      method: "POST",
      url: "index.php?action=addSubmission",
      data: {comments : comments, assignmentID : assID }
    })
    .done(function(msg){
      toastr.success(msg);
      location.reload(); 
    });
    
    
  });

});


</script>