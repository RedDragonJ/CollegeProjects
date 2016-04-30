<div class="container body-container">
<h2><?=$page['staffCourseAssignments']['courseName']?> - Details</h2>
<div class="row">
	<div class="col-md-6">
		<h2>Assignment List</h2>
		<div class="well">
			<div class="list-group">	
			<?php
			foreach($page['staffCourseAssignments']['assignments'] as $ass){
				// For Each assignment
				?>			  
			  <a href="?action=assignment&assID=<?=$ass['assID']?>" class="list-group-item">
				<h4 class="list-group-item-heading"><?=$ass['assignmentName']?></h4>
				<p class="list-group-item-text">Needs Graded: <?=$ass['needsGraded']?></p>
				<p class="list-group-item-text">Status: <?=($ass['completed']?'Past Assignment':'Active Assignment')?></p>
			  </a>	
			   <?php		
					// End Each ass
				}
				?>			  
			  <a style="display:none" id="addRow" class="list-group-item">
			  
			  <input id="AssignmentName" type="text" class="form-control" placeholder="Assignment Name"><br>
			  <input id="AssignmentMaxPoints" type="number" class="form-control" placeholder="Max Points"><br>
			  <button id="addAss" class="btn btn-primary">Save</button> 
              <button id="cancelAddAss"  class="btn btn-danger">Cancel</button>
			  </a>
			  <a id="addAssRow" class="list-group-item hoverMouse">
				<h4 class="list-group-item-heading"> <button  class="btn btn-default pull-right "><span class="glyphicon glyphicon-plus" aria-hidden="true"></span></button> Add Assignment</h4>
			  </a> 
			
		</div>
		</div>
	</div>
	
	<div class="col-md-6">
		<h2>Student List</h2>
		<div class="well">
		<div class="row">
			<div class="col-sm-6">
			<h3>Enrolled</h3>
			<div id="enrolledList">
			<?php
			foreach($page['studentsEnrolled'] as $student){
				?>	
				<span data-studentID="<?=$student['studentID']?>" data-enrolled="1" class="label label-primary hoverMouse enrollClick"><?=$student['studentName']?></span>
			<?php }?>
			</div>
			
			</div>
			<div class="col-sm-6">
			<h3>Not Enrolled</h3>
			<div id="notEnrolledList">
				<?php
				foreach($page['studentsNotEnrolled'] as $student){
				?>	
				<span data-studentID="<?=$student['studentID']?>" data-enrolled="0" class="label label-default hoverMouse enrollClick"><?=$student['studentName']?></span>
				<?php
				}
				?>
			</div>
			</div>
		</div>
		</div>
	</div>
</div>

</div>

<script>
// second ajax spot
$(function() {
	$(".enrollClick").click(setClickEvents);
	
	$("#addAssRow").click(function(){
		$("#addRow").show();
		$(this).hide();
	});
	
	$("#cancelAddAss").click(function(e){
		$("#addRow").hide();
		$("#addAssRow").show();
		$("#AssignmentName").val("");
		
		
	});
	$("#addAss").click(function(e){
		assignmentName = $("#AssignmentName").val();
		maxPoints = $("#AssignmentMaxPoints").val();
		courseID = <?= $_GET['courseID'] ?>;
		$.ajax({
			method: "POST",
			url: "index.php?action=addAssignment",
			data: {name : assignmentName, maximumPoints : maxPoints, courseid : courseID }
		})
		.done(function(msg){
			toastr.success(msg);
			location.reload(); 
		});
		
		
	});
	
	
});

function setClickEvents(){
		isEnrolled = $(this).attr( 'data-enrolled' )
		isEnrolled = (isEnrolled=='1'?true:false);
		
		// AJAX INFO
		// STUDENT ID
		// COURSE ID  
		studentID = $(this).attr( 'data-studentID' );
		courseID = <?= $_GET['courseID'] ?>; // Fill This with PHP variable
		$me = $(this);
		semID = <?= $_GET['semesterID']; ?>;
		
		$(this).remove();		
		if(isEnrolled){
			// take out of enrollment

			$.ajax({
				method: "POST",
				url: "index.php?action=updateRemoveEnrollment",
				data: { studentID: studentID, courseID: courseID, semesterID : semID }
			})
			.done(function( msg ) {			
				$me.removeClass("label-primary");
				$me.addClass("label-default");
				$me.attr( 'data-enrolled',"0" );			
				$("#notEnrolledList").append($me);
				//toastr.options = {'positionClass': 'toast-top-center'}; 
				toastr.success(msg);			
			});		

		}else{
			// enroll
			$.ajax({
				method: "POST",
				url: "index.php?action=updateAddEnrollment",
				data: { studentID: studentID, courseID: courseID, semesterID : semID }
			})
			.done(function( msg ) {			
				$me.addClass("label-primary");
				$me.removeClass("label-default");
				$me.attr( 'data-enrolled',"1" );			
				$("#enrolledList").append($me);	
				//toastr.options = {'positionClass': 'toast-top-center'};
				toastr.success(msg);
			});	
				
		}
		// re apply click event
		$me.click(setClickEvents);
		
		
	}

</script>