<html>
<head>
	<title>delete</title>
</head>

<body>
	<?php
		$myID = $_GET['id'];
		global $myArrContent;
		if ($myID == NULL)
		{
			echo "Please include your ID";
		}
		else
		{
			$count = 0;
			$myFileRead = fopen("records.txt", "r") or die("Unable to open file!");
			if (flock($myFileRead,LOCK_SH))
  			{
  				while(!feof($myFileRead))
				{
					$str = fgets($myFileRead);
					$myData = explode("|", $str);
					if (strcmp($myData[0], $myID) != 0) 
					{
    					$myArrContent[$count++] = $str;
					}
				}
  				flock($myFileRead,LOCK_UN);
  			}
			fclose($myFileRead);

			$myFileWrite = fopen("records.txt", "w") or die("Unable to open file!");
			if (flock($myFileWrite,LOCK_EX))
  			{
  				for ($i=0; $i<count($myArrContent); $i++)
  				{
  					fwrite($myFileWrite, $myArrContent[$i]);
  				}
  				flock($myFileWrite,LOCK_UN);
  				echo "The data has been deleted from file successful!";
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