<html>
<head>
	<title>display</title>
</head>

<body>
	<?php
		$count = 0;
		$ch = (string)$_GET['order'];
		$myFile = fopen("records.txt", "r") or die("Unable to open file!");
		if (flock($myFile,LOCK_SH))
  		{
  			while(!feof($myFile))
			{
				$str = fgets($myFile);
				$myData = explode("|",$str);
				$newArr[$count++][$myData[2]] = $str;
			}
  			flock($myFile,LOCK_UN);
  		}
		fclose($myFile);

		if (strcmp("asc", "$ch")==0)
		{
			echo "asc<br>";
			ksort($newArr);
		}
		elseif (strcmp("desc", "$ch")==0) 
		{
			echo "desc";
			krsort($newArr);
		}
		else
		{
			echo "anything else<br>";
			ksort($newArr);
		}

		foreach($newArr as $item) 
		{
			foreach($item as $value) 
			{
    			echo $value;
    			echo "<br>";
    		}
		}
	?>
</body>
</html>