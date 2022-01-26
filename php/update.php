<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$prid = $_POST['prid'];
$prname = $_POST['prname'];
$prdesc = $_POST['prdesc'];
$prprice = $_POST['prprice'];


if (isset($_POST['image'])) {
    $encoded_string = $_POST['image'];
}
$sqlupdate = "UPDATE tbl_product SET Product_Name ='$prname', Product_Detail='$prdesc', Product_Price='$prprice' WHERE  Product_ID = '$prid'";
if ($conn->query($sqlupdate) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    if (!empty($encoded_string)) {
        $decoded_string = base64_decode($encoded_string);
        $path = '../images/products/' . $prid . '.png';
        $is_written = file_put_contents($path, $decoded_string);
    }
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}


function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>