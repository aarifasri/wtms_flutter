<<<<<<< HEAD
<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Content-Type: application/json");

include 'config.php';

$name = $_POST['name'];
$email = $_POST['email'];
$password = sha1($_POST['password']);
$phone = $_POST['phone'];
$address = $_POST['address'];

$response = [];

$sql = "INSERT INTO users (name, email, password, phone, address) VALUES (?, ?, ?, ?, ?)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("sssss", $name, $email, $password, $phone, $address);

if ($stmt->execute()) {
    $response['success'] = true;
    $response['message'] = "Registration successful!";
} else {
    $response['success'] = false;
    $response['message'] = "Error: " . $stmt->error;
}

echo json_encode($response);
?>
=======
<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Content-Type: application/json");

include 'config.php';

$name = $_POST['name'];
$email = $_POST['email'];
$password = sha1($_POST['password']);
$phone = $_POST['phone'];
$address = $_POST['address'];

$response = [];

$sql = "INSERT INTO users (name, email, password, phone, address) VALUES (?, ?, ?, ?, ?)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("sssss", $name, $email, $password, $phone, $address);

if ($stmt->execute()) {
    $response['success'] = true;
    $response['message'] = "Registration successful!";
} else {
    $response['success'] = false;
    $response['message'] = "Error: " . $stmt->error;
}

echo json_encode($response);
?>
>>>>>>> 8c09b11f198c75afa0393fb462aad473cd62d512
