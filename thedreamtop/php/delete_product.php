<?php
error_reporting(0);
include_once("dbconnect.php");
$codeno = $_POST['codeno'];


if (isset($_POST['codeno'])){
    $sqldelete = "DELETE FROM LAPTOP WHERE CODENO='$codeno'";
}
    
    if ($conn->query($sqldelete) === TRUE){
       echo "success";
    }else {
        echo "failed";
    }
?>