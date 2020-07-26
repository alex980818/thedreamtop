<?php
error_reporting(0);
include_once ("dbconnect.php");
$codeno = $_POST['codeno'];
$brand = $_POST['brand'];
$model = $_POST['model'];
$processor = $_POST['processor'];
$osystem = $_POST['osystem'];
$graphic = $_POST['graphic'];
$ram = $_POST['ram'];
$storage = $_POST['storage'];
$quantity  = $_POST['quantity'];
$price  = $_POST['price'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$path = '../productimage/'.$codeno.'.jpg';


$sqlupdate = "UPDATE LAPTOP SET CODENO = '$codeno', BRAND = '$brand',MODEL = '$model',PROCESSOR = '$processor', OSYSTEM = '$osystem',GRAPHIC = '$graphic', RAM = '$ram', STORAGE = '$storage', QUANTITY = '$quantity', PRICE = '$price' WHERE CODENO = '$codeno'";

if (file_put_contents($path, $decoded_string) && $conn->query($sqlupdate) === true)
{
    
        echo 'success';
   
}
else
{
    echo "failed";
}


?>