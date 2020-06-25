<?php
$servername = "localhost";
$username   = "justforl_thedreamtopadmin";
$password   = "n7Uy^PGi7[]y";
$dbname     = "justforl_thedreamtop";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
 die("Connection failed: " . $conn->connect_error);
}
?>