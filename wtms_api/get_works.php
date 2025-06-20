<<<<<<< HEAD
<?php
require 'db.php'; // Your database connection file

header('Content-Type: application/json');

// --- Start Debugging ---
// error_reporting(E_ALL); // Show all errors
// ini_set('display_errors', 1); // Display errors (for development only!)

// $input = file_get_contents('php://input');
// var_dump($input); // Check raw input

$data = json_decode(file_get_contents('php://input'), true);

// var_dump($data); // Check decoded data
// --- End Debugging ---


if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(["success" => false, "message" => "Invalid request method. Only POST is allowed."]);
    exit();
}

if (!isset($data['worker_id'])) {
    // echo json_encode(["success" => false, "message" => "Worker ID is required. Data received:", "debug_data" => $data]); // More debug info
    echo json_encode(["success" => false, "message" => "Worker ID is required."]);
    exit();
}

$worker_id = (int)$data['worker_id'];

// --- Debug worker_id ---
// echo json_encode(["debug_worker_id" => $worker_id]);
// exit();
// ---

$sql = "SELECT id, title, description, date_assigned, due_date, status FROM tbl_works WHERE assigned_to = ?";
// --- Debug SQL ---
// echo json_encode(["debug_sql" => $sql]);
// exit();
// ---

$stmt = $conn->prepare($sql);

if ($stmt === false) {
    // Log detailed error: error_log("Failed to prepare statement: " . $conn->error);
    echo json_encode(["success" => false, "message" => "Failed to prepare statement: " . $conn->error]);
    exit();
}

$stmt->bind_param("i", $worker_id);
$stmt->execute();
$result = $stmt->get_result();

$works = [];
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $works[] = $row;
    }
    echo json_encode(["success" => true, "works" => $works]);
} else {
    // It's not an error if no tasks are found, but good to know
    echo json_encode(["success" => true, "works" => [], "message" => "No tasks found for this worker."]);
}

$stmt->close();
$conn->close();
?>
=======
<?php
require 'db.php'; // Your database connection file

header('Content-Type: application/json');

// --- Start Debugging ---
// error_reporting(E_ALL); // Show all errors
// ini_set('display_errors', 1); // Display errors (for development only!)

// $input = file_get_contents('php://input');
// var_dump($input); // Check raw input

$data = json_decode(file_get_contents('php://input'), true);

// var_dump($data); // Check decoded data
// --- End Debugging ---


if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(["success" => false, "message" => "Invalid request method. Only POST is allowed."]);
    exit();
}

if (!isset($data['worker_id'])) {
    // echo json_encode(["success" => false, "message" => "Worker ID is required. Data received:", "debug_data" => $data]); // More debug info
    echo json_encode(["success" => false, "message" => "Worker ID is required."]);
    exit();
}

$worker_id = (int)$data['worker_id'];

// --- Debug worker_id ---
// echo json_encode(["debug_worker_id" => $worker_id]);
// exit();
// ---

$sql = "SELECT id, title, description, date_assigned, due_date, status FROM tbl_works WHERE assigned_to = ?";
// --- Debug SQL ---
// echo json_encode(["debug_sql" => $sql]);
// exit();
// ---

$stmt = $conn->prepare($sql);

if ($stmt === false) {
    // Log detailed error: error_log("Failed to prepare statement: " . $conn->error);
    echo json_encode(["success" => false, "message" => "Failed to prepare statement: " . $conn->error]);
    exit();
}

$stmt->bind_param("i", $worker_id);
$stmt->execute();
$result = $stmt->get_result();

$works = [];
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $works[] = $row;
    }
    echo json_encode(["success" => true, "works" => $works]);
} else {
    // It's not an error if no tasks are found, but good to know
    echo json_encode(["success" => true, "works" => [], "message" => "No tasks found for this worker."]);
}

$stmt->close();
$conn->close();
?>
>>>>>>> 8c09b11f198c75afa0393fb462aad473cd62d512
