<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$codeno = $_POST['codeno'];


if (isset($_POST['codeno'])){
    $sqldelete = "DELETE FROM CART WHERE EMAIL = '$email' AND CODENO='$codeno'";
}else{
    $sqldelete = "DELETE FROM CART WHERE EMAIL = '$email'";
}
    
    if ($conn->query($sqldelete) === TRUE){
       echo "success";
    }else {
        echo "failed";
    }
?>