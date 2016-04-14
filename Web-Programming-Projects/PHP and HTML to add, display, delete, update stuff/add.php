<html>
<head>
	<title>Add</title>
</head>

<body>
	<?php
		date_default_timezone_set("America/New_York");
		$myID = $_GET['id'];
		$myFirstName = (string)$_GET['FirstName'];
		$myLastName = (string)$_GET['LastName'];
		$myFavSport = $_GET['FavoriteSport'];
		$myDate = date("Y-m-d");
		$myTime = date("h:i:sa");

		if ($myID == NULL)
		{
			echo "Missing id";
		}
		elseif ($myFirstName == NULL) {
			echo "Missing First Name";
		}
		elseif ($myLastName == NULL) {
			echo "Missing Last Name";
		}
		elseif ($myFavSport == NULL) {
			echo "Missing Favorite Sport";
		}
		else
		{
			$myTxt = "$myID|$myFirstName|$myLastName|$myFavSport|$myDate $myTime\n";
			$myFile = fopen("records.txt", "a") or die("Unable to open file!");
			if (flock($myFile,LOCK_EX))
  			{
  				fwrite($myFile, $myTxt);
  				flock($myFile,LOCK_UN);
  			}
			else
  			{
  				echo "Error locking file!";
  			}
			fclose($myFile);
			//echo "Save to file successful!";
		}
		header('Location: display.php');
	?>
</body>
</html>