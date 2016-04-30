<div class="container body-container">
<h2>Course List</h2>
<?php
foreach($page['studentCourseList'] as $semester){
	// For Each Semseter
	?>
<div class="well">
<h3><?=$semester['semseterName']?></h3>
<div class="list-group">	
	<?php
	foreach($semester['courses'] as $course){
			// For Each Course In A Semester
		?>
  <a href="?action=course&courseID=<?=$course['courseID']?>" class="list-group-item">
    <h4 class="list-group-item-heading"><?=$course['courseName']?></h4>
    <p class="list-group-item-text">Current Assignments: <?=$course['dueAss']?> - Late: <strong style="color:red;"><?=$course['lateAss']?></strong></p>
  </a>
 
	
     <?php		
		// End Each Course
	}
	?>
</div>
</div>
	<?php
// End Each Semester
}
?>
</div>