<?php
function getProducts($keyword="",$brand=null,$make=null){
    $mysqli = new mysqli("localhost", "root", "killian", "store");
    if ($mysqli->connect_errno) {
        echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
    }
    $PMComp = ($make?"AND pmc.MakeID = ".$make:"");
    $BComp = ($brand?"AND b.ID = ".$brand:"");
    $sqlSingle = "SELECT p.ID, p.SKU,p.Descript,p.Price FROM Product p, PMCompatability pmc, Brand b, Make m WHERE b.ID=m.BrandID AND m.ID=pmc.MakeID AND pmc.ProductID = p.ID ".$PMComp." ".$BComp." AND (p.Descript LIKE '%".$keyword."%' OR p.SKU LIKE '%".$keyword."%' OR b.Title LIKE '%".$keyword."%' OR m.Title LIKE '%".$keyword."%') GROUP BY p.ID";
    $result=mysqli_query($mysqli,$sqlSingle);
    $count = 0;
    while ($row = $result->fetch_assoc()) {
        $array[$count]['ID'] = $row['ID'];
        $array[$count]['SKU'] = $row['SKU'];
        $array[$count]['Desc'] = $row['Descript'];
        $array[$count]['Price'] = $row['Price'];
        $count++;
    }


    return $array;
}

function getProductBrand($id){
    $mysqli = new mysqli("localhost", "root", "killian", "store");
    if ($mysqli->connect_errno) {
        echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
    }

    $sqlSingle = 'SELECT DISTINCT b.Title FROM Brand b,Make m,PMCompatability pmc WHERE b.ID = m.BrandID AND m.ID = pmc.MakeID AND pmc.ProductID ='.$id;
    $result=mysqli_query($mysqli,$sqlSingle);
    $row=mysqli_fetch_row($result);

    return $row[0];

}
function getProductMake($id){
    $mysqli = new mysqli("localhost", "root", "killian", "store");
    if ($mysqli->connect_errno) {
        echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
    }

    $sqlSingle = 'SELECT m.Title FROM Brand b,Make m,PMCompatability pmc WHERE b.ID = m.BrandID AND m.ID = pmc.MakeID AND pmc.ProductID ='.$id;
    $result=mysqli_query($mysqli,$sqlSingle);
    $count = 0;
    while ($row = $result->fetch_assoc()) {
        $array[$count] = $row['Title'];

        $count++;

    }

    return $array;

}

function getBrandCompatibleMakes($id)
{
    $mysqli = new mysqli("localhost", "root", "killian", "store");
    if ($mysqli->connect_errno) {
        echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
    }

    $sqlSingle = 'SELECT m.ID, m.Title FROM Make m WHERE m.BrandID='.$id;
    $result=mysqli_query($mysqli,$sqlSingle);
    $count = 0;
    while ($row = $result->fetch_assoc()) {
        $array[$count]['ID']=$row['ID'];
        $array[$count]['Title']=$row['Title'];
        $count++;
    }

    echo json_encode($array);


}

function isLoggedin(){
    return (isset($_SESSION["user"])&&$_SESSION["user"]!=null);
}

function updateQTY($id,$qty){
    $mysqli = new mysqli("localhost", "root", "killian", "store");
    if ($mysqli->connect_errno) {
        echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
    }

    $query = mysqli_query($mysqli, "UPDATE CartProducts SET Qty=".$qty." WHERE CartID='".$_SESSION['cartID']."' AND ID=".$id);
    error_log("SDFDS ".$id." ".$qty." HERE");
    return $id;
}

function removeItem($id){
    $mysqli = new mysqli("localhost", "root", "killian", "store");
    if ($mysqli->connect_errno) {
        echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
    }

    $query = mysqli_query($mysqli, "DELETE FROM CartProducts WHERE ID = ".$id);
    return $id;
}

function checkSession(){

    if(!isset($_SESSION["sessionID"])&&!isLoggedin()){
        $mysqli = new mysqli("localhost", "root", "killian", "store");
        if ($mysqli->connect_errno) {
            echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
        }
        $sqlSingle = "INSERT INTO `store`.`Sessions` (`ID`, `UserID`) VALUES (NULL, NULL);";
        $result=mysqli_query($mysqli,$sqlSingle);
        $_SESSION["sessionID"] = $mysqli->insert_id;

        $sqlSingle = "INSERT INTO `store`.`SessionCart` (`CID`, `SessionID`) VALUES (NULL, ".$_SESSION["sessionID"].");";
        $result=mysqli_query($mysqli,$sqlSingle);
        $_SESSION["cartID"] = $mysqli->insert_id;


    }
}