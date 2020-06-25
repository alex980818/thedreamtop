<?php
error_reporting(0);
include_once ("dbconnect.php");
$brand = $_POST['brand'];
$model = $_POST['model'];

if (isset($brand)){
    if ($brand == "Recent"){
        $sql = "SELECT * FROM LAPTOP ORDER BY CODENO";    
    }else{
        $sql = "SELECT * FROM LAPTOP WHERE BRAND = '$brand'";    
    }
}else{
    $sql = "SELECT * FROM LAPTOP ORDER BY CODENO";    
}
if (isset($model)){
  $sql = "SELECT * FROM LAPTOP WHERE MODEL LIKE '%$model%'";
}

//$sql = "SELECT * FROM  LAPTOP ORDER BY CODENO";

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["products"] = array();
    while ($row = $result->fetch_assoc())
    {
        $productlist = array();
        $productlist["codeno"] = $row["CODENO"];
        $productlist["brand"] = $row["BRAND"];
        $productlist["model"] = $row["MODEL"];
        $productlist["processor"] = $row["PROCESSOR"];
        $productlist["osystem"] = $row["OSYSTEM"];
        $productlist["graphic"] = $row["GRAPHIC"];
        $productlist["ram"] = $row["RAM"];
        $productlist["storage"] = $row["STORAGE"];
        $productlist["price"] = $row["PRICE"];
        $productlist["quantity"] = $row["QUANTITY"];
        array_push($response["products"], $productlist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>