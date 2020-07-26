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
//$sold = '0';
$path = '../productimage/'.$codeno.'.jpg';

$sqlinsert = "INSERT INTO LAPTOP(CODENO,BRAND,MODEL,PROCESSOR,OSYSTEM,GRAPHIC,RAM,STORAGE,QUANTITY,PRICE) VALUES ('$codeno','$brand','$model','$processor','$osystem','$graphic','$ram','$storage','$quantity','$price')";
$sqlsearch = "SELECT * FROM LAPTOP WHERE CODENO='$codeno'";
$resultsearch = $conn->query($sqlsearch);
if ($resultsearch->num_rows > 0)
{
    echo 'found';
}else{
if ($conn->query($sqlinsert) === true)
{
    if (file_put_contents($path, $decoded_string)){
        echo 'success';
    }else{
        echo 'failed';
    }
}
else
{
    echo "failed";
}    
}


?>