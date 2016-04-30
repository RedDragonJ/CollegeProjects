<?php
error_reporting(0);
require_once "functions.php";
$action = (isset($_GET['action'])!=null?$_GET['action']:"home");

session_start();
// Just for testing
//$_SESSION['userID'] = 1;
//$_SESSION['userType'] = 0; // = 0 Student, = 1 Staff

//session_unset(); // Uncomment to view login page

if(isset($_POST['Email']) && isset($_POST['Password']))
{
    $email =  $_POST['Email'];
	$password = $_POST['Password'];

	// Remove all illegal characters from email
	$email = filter_var($email, FILTER_SANITIZE_EMAIL);

	// Validate e-mail
	if (!filter_var($email, FILTER_VALIDATE_EMAIL) === false) {
	    checkUserAccount($email, $password);
	} else {
	    echo("$email is not a valid email address");
	}
}

if(!isLoggedIn()){
			// Display Login Form
			$page['title'] = "Login";
			require_once 'header.php';
			require_once 'login.php';
			require_once 'footer.php';

} else {
	switch ($action) {
		case "home":	
			if(isStudent()){
				$page['title'] = "Student - Class List";
				$page['studentCourseList'] = getStudentCourses();
				
				require_once 'header.php';				
				require_once 'student/classlist.php';
			} else {
				$page['title'] = "Faculty - Class List";
				$page['staffCourseList'] = getStaffCourses();
				require_once 'header.php';
				require_once 'staff/classlist.php';
			}	
			
			require_once 'footer.php';
			break;  
		
		case "course":
			if(isStudent()){
				$page['title'] = "Student - Assignment List";	
				$courseID = $_GET['courseID'];
				$page['studentCourseAssignments'] = getStudentCourseAssignments($courseID);

				require_once 'header.php';				
				require_once 'student/assignlist.php';
			} else {
				$page['title'] = "Faculty - Assignment List";
				require_once 'header.php';
						
				$courseID = $_GET['courseID'];				
				$page['studentsNotEnrolled'] = getStudentsNotInCourse($courseID);
				$page['studentsEnrolled'] = getStudentsInCourse($courseID);				
				$page['staffCourseAssignments'] = getStaffCourseAssignments($courseID);				
				require_once 'staff/assignlist.php';
			}
			require_once 'footer.php';			

			
		break;
		
		case "assignment":	
				if(isStudent()){
					$page['title'] = "Student - Assignment";
					$assID = $_GET['assignmentID'];
					$page['studentAssSubmissions'] = getStudentAssignmentSubmissions($assID);
					require_once 'header.php';
					require_once 'student/assignment.php';
				} else {
					$page['title'] = "Faculty - Assignment";
					require_once 'header.php';		

					$assID = $_GET['assID'];
					$page['staffStudentSubmissions'] = getStaffStudentSubmission($assID);
					require_once 'staff/assignment.php';
				}
				require_once 'footer.php';				
			
		break;

        case "logout":
        		session_unset();
        		header('Location: index.php?action=home');

        case "addUsers":
	        	$page['title'] = "Faculty - Add New Users";
	        	require_once 'header.php';
	        	require_once 'staff/addUsers.php';
	        	require_once 'footer.php';

	    break;
		case 'myaccount':
			$page['title'] = "My Account";
			require_once 'header.php';
			require_once 'myaccount.php';
			require_once 'footer.php';
		break;

		case 'changepassword':
				changepassword($_SESSION['userID'], $_POST['NewPassword']);
		break;

        case "createUser":
        		addUser();
	    break;

	    case "addCourse":
        		addNewCourse();
	    break;

	    case "addSemester":
	    		addNewSemester();
	    break;

	    case "addAssignment":
	    		addNewAssignment();
	    break;

	    case "updateRemoveEnrollment":
	    		updateRemoveEnrollment();
	    break;

	    case "updateAddEnrollment":
	    		updateAddEnrollment();
	    break;

	    case "gradeSubmission":
	    		gradeSubmission();
	    break;

	    case "addSubmission":
	    		addSubmission();
	    break;

	
		default:
		    require_once 'header.php';
			require_once 'new404.php';
			//echo "You Must Be Lost!";
	}
}

?>
