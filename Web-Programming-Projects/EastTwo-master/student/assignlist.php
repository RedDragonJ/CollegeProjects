<div class="container body-container">
<h2>Assignment List</h2>
<div class="well">
<h3><?=$page['studentCourseAssignments']['courseName']?></h3>
<div class="list-group">
<?php
	if(!isset($page['studentCourseAssignments']['assignments'])){
		echo "There are no assignments at this time.";
	}
foreach($page['studentCourseAssignments']['assignments'] as $ass){
?>
  <a href="?action=assignment&assignmentID=<?=$ass['assID']?>" class="list-group-item">
    <h4 class="list-group-item-heading"><?=$ass['assignmentName']?></h4>
    <p class="list-group-item-text">Due: <?=$ass['dueDate']?></p>
	<p class="list-group-item-text"><?=($ass['submitted']?"Submitted":"Not Turned In")?></p>
  </a>
<?php 
 }
?>
 
</div>

</div>


</div>