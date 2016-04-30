<div class="container body-container">
	<h2><?=$page['staffStudentSubmissions']['assignmentName']?> - Submissions</h2>
	<?php
	if(!isset($page['staffStudentSubmissions']['students'])){
		echo "There are no submissions at this time.";
	}
	foreach($page['staffStudentSubmissions']['students'] as $student){
		// For Each assignment
		?>		
	<div class="well">
		<h3><?= $student['studentName']?></h3>
		<div class="list-group">
		
		<?php
		$recent = true;
		foreach($student['submissions'] as $submission){
		// For Each submission
		?>	
		
		<span class="list-group-item">
		<h4 class="list-group-item-heading"><?=$submission['submissionDate']?></h4>
		<p class="list-group-item-text">FileDownload: <a href="#">HERE</a> </p>
		<p class="list-group-item-text">Comments: <?=$submission['comments']?></p>
		<?php if($recent){
			if($submission['graded']==null){
		?>
		<p class="list-group-item-text">FeedBack: <span id="FeedBackReplace<?=$submission['submissionID']?>"><input id="FeedBack<?=$submission['submissionID']?>" type="text" class="form-control" placeholder="Leave Some Feedback"></span></p>
		<p class="list-group-item-text">Grade: <span id="GradeReplace<?=$submission['submissionID']?>"><input id="Grade<?=$submission['submissionID']?>" type="numeric" class="form-control" placeholder="Assignment Name"></span> <strong>/<?=$page['staffStudentSubmissions']['assignmentMax']?></strong></p>
		<button data-submissionID="<?=$submission['submissionID']?>" class="btn btn-primary gradeButton">Grade</button> 
		<?php } else { ?>
		<p class="list-group-item-text">FeedBack:<?=$submission['feedback']?></p>
		<p class="list-group-item-text">Grade: <?=$submission['graded'].'/'.$page['staffStudentSubmissions']['assignmentMax']?></p>		
		
		<?php	}
		} ?>
		</span>
		
			   <?php		
			// End Each submission
			$recent = false;
		}
		?>		
		</div>
	</div>
	   <?php		
			// End Each student
		}
		?>	

</div>

<script>
$(function() {
	$(".gradeButton").click(function(){
		submissionID=$(this).attr( 'data-submissionID' );
		feedback=$("#FeedBack"+submissionID).val();
		grade=$("#Grade"+submissionID).val();
		// Check and validation stuff
		
		$.ajax({
			method: "POST",
			url: "index.php?action=gradeSubmission",
			data: {submissionID : submissionID, feedback : feedback, grade : grade}
		})
		.done(function(msg){
		    $("#FeedBackReplace"+submissionID).html(feedback);
		    $("#GradeReplace"+submissionID).html(grade);
		    $(this).hide();
			location.reload();
			toastr.success(msg); 
		});

	});
	
});
</script>