<html>
<head>
	<title>Edit</title>
</head>

<body>
	<?php
		date_default_timezone_set("America/New_York");
		global $newArr;
		$myID = $_GET['id'];
		$myNewfn = $_GET['newFirstName'];
		$myNewLn = $_GET['newLastName'];
		$myNewSport = $_GET['newFavoriteSport'];
		$myNewID = $_GET['newID'];
		$myDate = date("Y-m-d");
		$myTime = date("h:i:sa");

		if ($myID == NULL)
		{
			echo "Please include the ID to edit";
		}
		else 
		{
			$count = 0;
			$myReadFile = fopen("records.txt", "r") or die("Unable to open file!");
			if (flock($myReadFile,LOCK_SH))
  			{
  				while(!feof($myReadFile))
				{
					$str = fgets($myReadFile);
					$myReadData = explode("|",$str);
					if (strcmp($myReadData[0], $myID) == 0)
					{
						if ($myNewID != NULL)
						{
							$myReadData[0] = $myNewID;
						}
						
						if ($myNewfn != NULL) 
						{
							$myReadData[1] = $myNewfn;
						}
						
						if ($myNewLn != NULL) 
						{
							$myReadData[2] = $myNewLn;
						}
						
						if ($myNewSport != NULL) 
						{
							$myReadData[3] = $myNewSport;
						}
						$newString = "$myReadData[0]|$myReadData[1]|$myReadData[2]|$myReadData[3]|$myDate $myTime\n";
						echo $newString;
						$newArr[$count++] = $newString;
					}
					else
					{
						$newArr[$count++] = $str;
					}
				}
  				flock($myReadFile,LOCK_UN);
  			}
			fclose($myReadFile);

			$myFileWrite = fopen("records.txt", "w") or die("Unable to open file!");
			if (flock($myFileWrite,LOCK_EX))
  			{
  				foreach ($newArr as $key => $value) 
  				{
  					fwrite($myFileWrite, $value);
  				}
  				flock($myFileWrite,LOCK_UN);
  				//echo "The data has been edited from file successful!";
  			}
			else
  			{
  				echo "Error locking file!";
  			}
			fclose($myFileWrite);
		}
		header('Location: display.php');
	?>
</body>
</html>