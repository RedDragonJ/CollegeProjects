<html>
<head>
   <title>editform</title>
      <style>
      input[type=text], select 
      {
          width: 100%;
          padding: 10px 10px;
          margin: 8px 0;
          display: inline-block;
          border: 1px solid #ccc;
          border-radius: 4px;
          box-sizing: border-box;
      }

      input[type=submit] 
      {
          width: 100%;
          background-color: #4CAF50;
          color: white;
          padding: 14px 20px;
          margin: 8px 0;
          border: none;
          border-radius: 4px;
          cursor: pointer;
      }

      input[type=submit]:hover 
      {
          background-color: #45a049;
      }

      div 
      {
	  width: 40%;
          border-radius: 5px;
          background-color: #B8B8B8;
          padding: 40px;
      }
      </style>
</head>

<body>
    <div>
    <h1>   Edit Form</h1>

    <?php
      $myID = $_GET['id'];
      $myFN = $_GET['FirstName'];
      $myLN = $_GET['LastName'];
      $myFSport = $_GET['FavoriteSport'];

	    echo "<form action='edit.php' method='get'>";
  	  echo "<label for='ID'>ID</label><br>";
  	  echo "<input type='text' name='id' value='$myID' readonly><br>";

  	  echo "<label for='FName'>First Name</label><br>";
  	  echo "<input type='text' name='newFirstName' value='$myFN' ><br>";

  	  echo "<label for='LName'>Last Name</label><br>";
  	  echo "<input type='text' name='newLastName' value='$myLN' ><br>";
  	
      echo "<label for='FavSport'>Favorite Sports</label><br>";
      echo "<input type='text' name='newFavoriteSport' value='$myFSport' ><br>";
  	
      echo "<label for='NewID'>New ID</label><br>";
      echo "<input type='text' name='newID' value=''><br>";

  	  echo "<input type='submit' value='Submit'>";
    	echo "</form>"; 
    ?>
    </div>
</body>
</html>