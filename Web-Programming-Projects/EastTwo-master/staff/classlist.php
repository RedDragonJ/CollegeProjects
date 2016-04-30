<div class="container body-container">
<h2>Course List</h2>

<?php
foreach($page['staffCourseList'] as $semester){
	// For Each Semseter
	?>
<div class="well">
<h3><?=$semester['semseterName']?></h3>
<div class="list-group">	
<?php
	foreach($semester['courses'] as $course){
			// For Each Course In A Semester
?>
  <a href="?action=course&courseID=<?=$course['courseID']?>&semesterID=<?=$semester['semesterID']?>" class="list-group-item">
    <h4 class="list-group-item-heading"><?=$course['courseName']?></h4>
    <p class="list-group-item-text">Current Assignments: <?=$course['assignments']?></p>
	<p class="list-group-item-text">Current Students: <?=$course['students']?></p>
  </a>
   <?php		
		// End Each Course
	}
	?>
  <span style="display:none" id="addCourseBox<?=$semester['semesterID']?>" class="list-group-item hoverMouse">
  <h4 class="list-group-item-heading">Adding Course</h4>
   <div class="row">
   <div class="col-sm-6"><input id="addCourseName<?=$semester['semesterID']?>" type="text" class="form-control" placeholder="Course Name"></div>
   <div class="col-sm-6"><button data-semesterID="<?=$semester['semesterID']?>"  class="btn btn-primary saveAddCouse">Save</button> 
   <button data-semesterID="<?=$semester['semesterID']?>"  class="btn btn-danger cancelAddCouse">Cancel</button></div>
   </div>
  </span>
  
  <span data-semesterID="<?=$semester['semesterID']?>" id="addCourse<?=$semester['semesterID']?>" class="list-group-item hoverMouse addCourse">
    <h4 class="list-group-item-heading"><button  class="btn btn-default pull-right "><span class="glyphicon glyphicon-plus" aria-hidden="true"></span></button> Add Course</h4>
  </span>
 
	
     
</div>
</div>
	<?php
// End Each Semester
}
?>

<div style="display:none"  id="addSemesterBox" class="well hoverMouse">
	<h3>Adding Semester</h3>
   <div class="row">
   <div class="col-sm-6"><input id="addSemesterName" type="text" class="form-control" placeholder="Semester Name"></div>
   <div class="col-sm-6"><button id="saveAddSemester" class="btn btn-primary">Save</button> <button id="cancelAddSemester" class="btn btn-danger">Cancel</button></div>
   </div>

</div>

<div id="addSemester" class="well hoverMouse">
<h3><button class="btn btn-default pull-right "><span class="glyphicon glyphicon-plus" aria-hidden="true"></span></button>Add Semester</h3>

</div>


</div>

<script>
// second ajax spot
$(function() {
	// ADDING COURSE STUFF
	$(".addCourse").click(function(e){
		$(this).hide();
		semID = $(this).attr( 'data-semesterID' )
		$("#addCourseBox"+semID).show();
		
		
	});
	$(".cancelAddCouse").click(function(e){
		semID = $(this).attr( 'data-semesterID' )
		$("#addCourseBox"+semID).hide();
		$("#addCourse"+semID).show();
		$("#addCourseName"+semID).val("");
		
		
	});
	$(".saveAddCouse").click(function(e){
		semID = $(this).attr( 'data-semesterID' );
		newCourseName = $('#addCourseName' + semID).val();
		$.ajax({
			method: "POST",
			url: "index.php?action=addCourse",
			data: {semesterId : semID, newCourse : newCourseName}
		})
		.done(function(msg){
			alert(msg);
			location.reload(); 
		});
		
		
		
	});
	// END COURSE STUFF
	
	// ADD SEMESTER STUFF
	$("#addSemester").click(function(e){
		$(this).hide();
		$("#addSemesterBox").show();
		
		
	});
	$("#cancelAddSemester").click(function(e){
		$("#addSemesterBox").hide();
		$("#addSemester").show();
		$("#addSemesterName").val("");
		
		
	});
	$("#saveAddSemester").click(function(e){
        newSemesterName = $("#addSemesterName").val();
		$.ajax({
			method: "POST",
			url: "index.php?action=addSemester",
			data: {newSemesterName : newSemesterName}
		})
		.done(function(msg){
			alert(msg);
			location.reload(); 
		});
		
		
	});
	// END ADD SEMESTER STUFF
});
</script>