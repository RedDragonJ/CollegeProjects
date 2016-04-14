<html>
<head>
	<title>A Chuck Norris Thing</title>

	<style>
		img 
		{
    		float: left;
		}

		p
		{
			font-size: 40px;
		}

		button 
		{
			background-color: #008CBA;
			font-size: 20px;
			border-radius: 4px;
			border: none;
			color: white;
		}
	</style>
</head>
<body>
	<div>
	<img src="http://media2.newsnet5.com/photo/2014/03/10/chuck%20norris_crop_1394454213136_3349583_ver1.0_640_480.jpg" style="width:380px;height:300px;">
	</div>

	<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
	<button onclick="myFunction()">Another Quote</button>

	<?php
		include ('login.php');

		// Create connection
		$conn = new mysqli($server, $db_username, $db_password, $db_name);
		
		// Check connection
		if ($conn->connect_error) 
		{
     		die("Connection failed: " . $conn->connect_error);
		} 
		else
		{
			//echo "Connected successfully <br>";
			$sql = "SELECT Quote FROM ChuckNorris ORDER BY RAND() LIMIT 1";
			$result = $conn->query($sql);
			if (!$result) 
			{
    			echo "query not right <br>";
			}
			else
			{
				//echo "query is ok <br>";
				if ($result->num_rows > 0) 
				{
					//echo "table exist <br>";
					while($row = $result->fetch_assoc()) 
					{
						echo "<p>" . $row["Quote"] . "</p>";
					}
				}
				else
				{
					echo "table no result";
				}
			}

		
		}
		$conn->close();
	?>

	<script>
	function myFunction() 
	{
    	location.reload();
	}
</script>
</body>
</html>