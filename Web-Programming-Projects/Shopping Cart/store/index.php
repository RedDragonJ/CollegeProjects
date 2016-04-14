<?php
require_once 'functions.php';
session_start();
checkSession();

$action = (isset($_GET['action'])!=null?$_GET['action']:"home");


switch ($action) {
    case "home":
        $pageTitle = "AlgimStore - Home Page";

        require_once 'header.php';


        // Home needs list of items
        $keyword = (isset($_GET['keyword'])!=null?$_GET['keyword']:"");
        $brand = ((isset($_GET['brand'])!=null&&$_GET['brand']!=-1)?$_GET['brand']:null);
        $make = ((isset($_GET['make'])!=null&&$_GET['make']!=-1)?$_GET['make']:null);
        //$keyword="",$brand=null,$make=null
        $items = getProducts($keyword,$brand,$make);
        require_once 'home.php';

        require_once 'footer.php';

        break;

    case "login":
        $pageTitle = "AlgimStore - Login";
        if(isset($_POST['Email'])) {
            $mysqli = new mysqli("localhost", "root", "killian", "store");
            if ($mysqli->connect_errno) {
                echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
            }
            $query = mysqli_query($mysqli, "SELECT ID FROM User WHERE Email='".$_POST['Email']."' AND Password='".$_POST['Password']."' ");

            if(mysqli_num_rows($query) > 0){
                $_SESSION["user"] = mysqli_fetch_assoc($query)['ID'];
                $query = mysqli_query($mysqli, "SELECT ID FROM Sessions WHERE UserID=".$_SESSION["user"]);
                $_SESSION["sessionID"] = mysqli_fetch_assoc($query)['ID'];

                $query = mysqli_query($mysqli, "SELECT CID FROM SessionCart WHERE SessionID=".$_SESSION["sessionID"]);
                $_SESSION["cartID"] = mysqli_fetch_assoc($query)['CID'];
                header('Location: index.php?action=mycart');
            } else {
                require_once 'header.php';

                require_once 'login.php';

                require_once 'footer.php';
            }

        }else {
            if (!isLoggedin()) {
                $pageTitle = "AlgimStore - Login";

                require_once 'header.php';

                require_once 'login.php';

                require_once 'footer.php';
            } else {
                header('Location: index.php?action=myaccount');
            }
        }

        break;

    case "create":
        if(!isset($_POST['Email'])) {
            $pageTitle = "AlgimStore - Create Account";

            require_once 'header.php';

            require_once 'create.php';

            require_once 'footer.php';
        } else {

            $mysqli = new mysqli("localhost", "root", "killian", "store");
            if ($mysqli->connect_errno) {
                echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
            }
            $sqlSingle = "INSERT INTO `store`.`User` (`ID`, `FirstName`, `LastName`, `Email`, `Address`, `City`, `State`, `Zip`, `Phone`, `Credit Card`, `Password`) VALUES (NULL, '".$_POST['FirstName']."', '".$_POST['LastName']."', '".$_POST['Email']."', '".$_POST['Address']."', '".$_POST['City']."', '".$_POST['State']."', '".$_POST['Zip']."', '".$_POST['Phone']."', '".$_POST['CC']."', '".$_POST['pass']."');";
            mysqli_query($mysqli, $sqlSingle);

            $_SESSION["user"] = $mysqli->insert_id;
            $query = mysqli_query($mysqli, "UPDATE Sessions SET UserID=".$_SESSION["user"]." WHERE ID=".$_SESSION["sessionID"]);
            header('Location: index.php?action=mycart');
        }

        break;
	case "mycart":
        $pageTitle = "AlgimStore - My Cart";
        if(isset($_POST['addID'])){
            $id = $_POST['addID'];
            $mysqli = new mysqli("localhost", "root", "killian", "store");
            if ($mysqli->connect_errno) {
                echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
            }
            $query = mysqli_query($mysqli, "SELECT Status FROM SessionCart WHERE CID=".$_SESSION['cartID']);
            $complete = mysqli_fetch_assoc($query)['Status'];
            if($complete==0) {
                $query = mysqli_query($mysqli, "SELECT * FROM CartProducts WHERE CartID='" . $_SESSION['cartID'] . "' AND ProductID=" . $id);

                if (mysqli_num_rows($query) > 0) {
                    $query = mysqli_query($mysqli, "UPDATE CartProducts SET Qty=Qty+1 WHERE CartID='" . $_SESSION['cartID'] . "' AND ProductID=" . $id);
                    $qty = mysqli_fetch_assoc(mysqli_query($mysqli, "SELECT ID FROM CartProducts WHERE CartID='" . $_SESSION['cartID'] . "' AND ProductID=" . $id));
                    echo $qty['ID'];
                    error_log("WER HERE");
                } else {
                    $sqlSingle = "INSERT INTO `store`.`CartProducts` (`ID`, `CartID`, `ProductID`, `Qty`) VALUES (NULL, '" . $_SESSION['cartID'] . "', '" . $id . "', '1');";
                    mysqli_query($mysqli, $sqlSingle);
                    echo $mysqli->insert_id;
                }
            }


        }else {
            $pageTitle = "AlgimStore - My Cart";

            require_once 'header.php';

            require_once 'mycart.php';

            require_once 'footer.php';
        }

        break;

    case "compatibleJSON":
        $id = (isset($_GET['id'])!=null?$_GET['id']:"");
        getBrandCompatibleMakes($id);
        break;

    case "updateQTY":

        if(isset($_POST['cpID'])!=null && isset($_POST['Qty'])!=null){
            echo updateQTY($_POST['cpID'],$_POST['Qty']);
        }

        break;

    case "removeItem":

        if(isset($_POST['cpID'])!=null){
            echo removeItem($_POST['cpID']);
        }

        break;

    case "logout":
        session_destroy();
        header('Location: index.php?action=home');
        break;

    case "myaccount":
        if (isLoggedin()) {
            $pageTitle = "AlgimStore - My Account";

            require_once 'header.php';

            require_once 'myaccount.php';

            require_once 'footer.php';
        } else {
            header('Location: index.php?action=login');
        }
        break;

    case "final":
        if (!isLoggedin()) {
            header('Location: index.php?action=create');
        }else{
            if(isset($_GET['done'])!=null) {
                $mysqli = new mysqli("localhost", "root", "killian", "store");
                if ($mysqli->connect_errno) {
                    echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
                }
                $query = mysqli_query($mysqli, "UPDATE SessionCart SET Status=1, CompleteDate=NOW() WHERE CID=".$_SESSION["cartID"]);
                header('Location: index.php');
            }else {
                $pageTitle = "AlgimStore - Finalize";

                require_once 'header.php';

                require_once 'final.php';

                require_once 'footer.php';
            }
        }
        break;
    case "update":
        $mysqli = new mysqli("localhost", "root", "killian", "store");
        if ($mysqli->connect_errno) {
            echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
        }
        $sqlSingle = "Update `store`.`User` SET `FirstName`='".$_POST['FirstName']."', `LastName`='".$_POST['LastName']."', `Email`='".$_POST['Email']."', `Address`='".$_POST['Address']."', `City`='".$_POST['City']."', `State`='".$_POST['State']."', `Zip`='".$_POST['Zip']."', `Phone`='".$_POST['Phone']."', `Credit Card`='".$_POST['CC']."' WHERE ID=".$_SESSION['user'];
        error_log($sqlSingle);
        mysqli_query($mysqli, $sqlSingle);
        header('Location: index.php?action=myaccount');
        break;



    default:
        echo "You Must Be Lost!";
}


