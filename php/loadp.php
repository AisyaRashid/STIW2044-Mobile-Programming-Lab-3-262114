<?php
include_once("dbconnect.php");

$sqlloadproduct = "SELECT * FROM tbl_product";
$result = $conn->query($sqlloadproduct);

if ($result->num_rows > 0) {
     $products["products"] = array();

while ($row = $result->fetch_assoc()) {
        $prlist = array();
        $prlist['prid'] = $row['Product_ID'];
        $prlist['prname'] = $row['Product_Name'];
        $prlist['prprice'] = $row['Product_Price'];
	    $prlist['prdesc'] = $row['Product_Detail'];

        array_push($products["products"],$prlist);
    }
     $response = array('status' => 'success', 'data' => $products);
    sendJsonResponse($response);

}else{

    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>