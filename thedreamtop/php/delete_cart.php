<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$CODENO = $_POST['CODENO'];


if (isset($_POST['prodid'])){
    $sqldelete = "DELETE FROM CART WHERE EMAIL = '$email' AND CODENO='$CODENO'";
}else{
    $sqldelete = "DELETE FROM CART WHERE EMAIL = '$email'";
}
    
    if ($conn->query($sqldelete) === TRUE){
       echo "success";
    }else {
        echo "failed";
    }
?>