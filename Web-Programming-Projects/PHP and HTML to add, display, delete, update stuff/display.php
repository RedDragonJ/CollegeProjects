<html>
<head>
	<title>display</title>
	<style>
		table, th, td 
		{
    		border: 1px solid black;
    		border-collapse: collapse;
		}
		th, td 
		{
    		padding: 5px;
    		text-align: center;
		}
		#header 
		{
    		background-color:LightGray;
    		color:black;
    		text-align:center;
    		padding:5px;
		}
		#nav 
		{
    		line-height:30px;
    		background-color:#eeeeee;
    		height:300px;
    		width:230px;
    		float:left;
    		padding:5px;	      
		}
		#section 
		{
    		width:1000px;
    		float:left;
    		padding:10px;	 	 
		}
		a 
		{
			display:inline-block;
			margin-right:20px;
		}
	</style>
</head>

<body>
	<div id="header">
	<h1>Simple Record Management System</h1>
	</div>

	<div id="nav">
	<a href="addform.html">Add New Record</a>
	<br>
	<form method="get">
  		<input type="text" name="searchbox" value="">
  		<input type="submit" value="Search">
	</form>
	</div>

	<div id="section">
	<table style="width:100%">
    	<tr>
    		<th>ID</th>
    		<th>Firstname</th>
    		<th>Lastname</th>		
    		<th>Sports</th>
    		<th></th>
  		</tr>

		<?php
			global $myData;
			$mySearchVal = $_GET['searchbox'];
			$count = 0;

			if ($mySearchVal != NULL)
			{
				$myFileRead = fopen("records.txt", "r") or die("Unable to open file!");
				if (flock($myFileRead,LOCK_SH))
  				{
  					while(!feof($myFileRead))
					{
						$str = fgets($myFileRead);
						$myData = explode("|",$str);
						if ((strpos($myData[1], $mySearchVal) !== false) || (strpos($myData[2], $mySearchVal) !== false))
						{
    						echo "<tr><td>$myData[0]</td><td>$myData[1]</td><td>$myData[2]</td><td>$myData[3]</td><td><a href=\"editform.php?id=$myData[0]&FirstName=$myData[1]&LastName=$myData[2]&FavoriteSport=$myData[3]\">Edit</a>   <a href=\"delete.php?id=$myData[0]\">Delete</a></td></tr>";
						}
					}
  					flock($myFileRead,LOCK_UN);
  				}
				fclose($myFileRead);
			}
			else
			{
				$myFile = fopen("records.txt", "r") or die("Unable to open file!");
				if (flock($myFile,LOCK_SH))
  				{
  					while(!feof($myFile))
					{
						$str = fgets($myFile);
						$myData = explode("|",$str);
						if ($myData[0] != NULL)
						{
							echo "<tr><td>$myData[0]</td><td>$myData[1]</td><td>$myData[2]</td><td>$myData[3]</td><td><a href=\"editform.php?id=$myData[0]&FirstName=$myData[1]&LastName=$myData[2]&FavoriteSport=$myData[3]\">Edit</a>   <a href=\"delete.php?id=$myData[0]\">Delete</a></td></tr>";
						}	
					}
  					flock($myFile,LOCK_UN);
  				}
				fclose($myFile);
			}
		?>
	</table>
	</div>
</body>
</html>