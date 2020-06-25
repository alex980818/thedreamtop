<?php
error_reporting(0);
include_once ("dbconnect.php");
$orderid = $_POST['orderid'];

$sql = "SELECT LAPTOP.CODENO, LAPTOP.BRAND, LAPTOP.MODEL, LAPTOP.PRICE, LAPTOP.QUANTITY, CARTHISTORY.CQUANTITY FROM LAPTOP INNER JOIN CARTHISTORY ON CARTHISTORY.CODENO = LAPTOP.CODENO WHERE CARTHISTORY.ORDERID = '$orderid'";

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["carthistory"] = array();
    while ($row = $result->fetch_assoc())
    {
        $cartlist = array();
        $cartlist["codeno"] = $row["CODENO"];
        $cartlist["brand"] = $row["BRAND"];
        $cartlist["model"] = $row["MODEL"];
        $cartlist["price"] = $row["PRICE"];
        $cartlist["cquantity"] = $row["CQUANTITY"];
        array_push($response["carthistory"], $cartlist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>