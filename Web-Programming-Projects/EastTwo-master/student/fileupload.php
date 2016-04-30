<?php
	
if (!isset($_FILES['upfile']['error']) || is_array($_FILES['upfile']['error'])) //is it more than one file or a bad upload???
{
	echo 'Invalid parameters.';
}
	
switch ($_FILES['upfile']['error']) 
{
	case UPLOAD_ERR_OK:
		break;
	case UPLOAD_ERR_NO_FILE:
		echo 'No file sent.';
	case UPLOAD_ERR_INI_SIZE:
	case UPLOAD_ERR_FORM_SIZE:
		echo 'Exceeded filesize limit.';
	default:
		echo 'Unknown errors.';
}
	
if ($_FILES['upfile']['size'] > 10000)   //limit file size for our demo
{
    echo 'File too big.';
}

if (!($_FILES['upfile']['type'] == 'text/plain')) //limit this to text file uploads
{
	echo 'Invalid file format.';
}

$fileContent = file_get_contents($_FILES['upfile']['tmp_name']);
$fileName = basename($_FILES['upfile']['name']); //not sure if this will work, needs tested


//temp vars
$comment = "my comment";
$feedback = "my feedback";
$assignmentId = 1;
$studentId = 1;


$query = "INSERT INTO submissions (comments, feedback, filename, filedata) VALUES ('" . $comment . "', '" . $feedback . "', '" . $fileName . "', '" . $fileContent . "')";
echo $query;

$result = $conn->query($sql)
if ($result) 
{
    echo "Inserted uploaded file";
	$last_id = $conn->insert_id;
	
	$query = "INSERT INTO assignmentsubmissions (AssID, SubID, StudentID) VALUES (" . $assignmentId  . ", " . $last_id . ", " . $studentId . ")";
    echo $query;
	
	$result = $conn->query($sql)
	
	if ($result) 
	{
		echo "Inserted assignment sub";
	}
	else 
	{
		echo "Failed to insert assignment sub";
	}
} 
else 
{
	echo "Failed to insert uploaded file!";
}

?>