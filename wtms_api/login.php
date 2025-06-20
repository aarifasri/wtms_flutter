<<<<<<< HEAD
<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Content-Type: application/json");

include 'config.php';

$email = $_POST['email'];
$password = sha1($_POST['password']);

$response = [];

$sql = "SELECT * FROM users WHERE email = ? AND password = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ss", $email, $password);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    $response['success'] = true;
    $response['user'] = $row;
} else {
    $response['success'] = false;
    $response['message'] = "Invalid credentials";
}

echo json_encode($response);
?>
=======
<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Content-Type: application/json");

include 'config.php';

$email = $_POST['email'];
$password = sha1($_POST['password']);

$response = [];

$sql = "SELECT * FROM users WHERE email = ? AND password = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ss", $email, $password);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    $response['success'] = true;
    $response['user'] = $row;
} else {
    $response['success'] = false;
    $response['message'] = "Invalid credentials";
}

echo json_encode($response);
?>
>>>>>>> 8c09b11f198c75afa0393fb462aad473cd62d512
