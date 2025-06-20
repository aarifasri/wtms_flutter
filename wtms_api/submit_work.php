<<<<<<< HEAD
<?php
require 'db.php'; // Your database connection file

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(["success" => false, "message" => "Invalid request method. Only POST is allowed."]);
    exit();
}

$data = json_decode(file_get_contents('php://input'), true);

if (!isset($data['work_id']) || !isset($data['worker_id']) || !isset($data['submission_text'])) {
    echo json_encode(["success" => false, "message" => "Missing required fields: work_id, worker_id, submission_text."]);
    exit();
}

$work_id = (int)$data['work_id'];
$worker_id = (int)$data['worker_id'];
$submission_text = trim($data['submission_text']);

if (empty($submission_text)) {
    echo json_encode(["success" => false, "message" => "Submission text cannot be empty."]);
    exit();
}

// Start transaction
$conn->begin_transaction();

try {
    // Insert into tbl_submissions
    $sql_submission = "INSERT INTO tbl_submissions (work_id, worker_id, submission_text) VALUES (?, ?, ?)";
    $stmt_submission = $conn->prepare($sql_submission);
    if ($stmt_submission === false) {
        throw new Exception("Failed to prepare submission statement: " . $conn->error);
    }
    $stmt_submission->bind_param("iis", $work_id, $worker_id, $submission_text);

    if (!$stmt_submission->execute()) {
        throw new Exception("Failed to insert submission: " . $stmt_submission->error);
    }
    $stmt_submission->close();

    // Optionally, update the status in tbl_works to 'submitted' or 'completed'
    $new_status = 'submitted'; // Or 'completed' based on your workflow
    $sql_update_work = "UPDATE tbl_works SET status = ? WHERE id = ? AND assigned_to = ?";
    $stmt_update_work = $conn->prepare($sql_update_work);
    if ($stmt_update_work === false) {
        throw new Exception("Failed to prepare work update statement: " . $conn->error);
    }
    $stmt_update_work->bind_param("sii", $new_status, $work_id, $worker_id);

    if (!$stmt_update_work->execute()) {
        throw new Exception("Failed to update work status: " . $stmt_update_work->error);
    }
    $stmt_update_work->close();

    // Commit transaction
    $conn->commit();
    echo json_encode(["success" => true, "message" => "Work submitted successfully."]);

} catch (Exception $e) {
    $conn->rollback(); // Rollback transaction on error
    echo json_encode(["success" => false, "message" => "Submission failed: " . $e->getMessage()]);
}

$conn->close();
?>
=======
<?php
require 'db.php'; // Your database connection file

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(["success" => false, "message" => "Invalid request method. Only POST is allowed."]);
    exit();
}

$data = json_decode(file_get_contents('php://input'), true);

if (!isset($data['work_id']) || !isset($data['worker_id']) || !isset($data['submission_text'])) {
    echo json_encode(["success" => false, "message" => "Missing required fields: work_id, worker_id, submission_text."]);
    exit();
}

$work_id = (int)$data['work_id'];
$worker_id = (int)$data['worker_id'];
$submission_text = trim($data['submission_text']);

if (empty($submission_text)) {
    echo json_encode(["success" => false, "message" => "Submission text cannot be empty."]);
    exit();
}

// Start transaction
$conn->begin_transaction();

try {
    // Insert into tbl_submissions
    $sql_submission = "INSERT INTO tbl_submissions (work_id, worker_id, submission_text) VALUES (?, ?, ?)";
    $stmt_submission = $conn->prepare($sql_submission);
    if ($stmt_submission === false) {
        throw new Exception("Failed to prepare submission statement: " . $conn->error);
    }
    $stmt_submission->bind_param("iis", $work_id, $worker_id, $submission_text);

    if (!$stmt_submission->execute()) {
        throw new Exception("Failed to insert submission: " . $stmt_submission->error);
    }
    $stmt_submission->close();

    // Optionally, update the status in tbl_works to 'submitted' or 'completed'
    $new_status = 'submitted'; // Or 'completed' based on your workflow
    $sql_update_work = "UPDATE tbl_works SET status = ? WHERE id = ? AND assigned_to = ?";
    $stmt_update_work = $conn->prepare($sql_update_work);
    if ($stmt_update_work === false) {
        throw new Exception("Failed to prepare work update statement: " . $conn->error);
    }
    $stmt_update_work->bind_param("sii", $new_status, $work_id, $worker_id);

    if (!$stmt_update_work->execute()) {
        throw new Exception("Failed to update work status: " . $stmt_update_work->error);
    }
    $stmt_update_work->close();

    // Commit transaction
    $conn->commit();
    echo json_encode(["success" => true, "message" => "Work submitted successfully."]);

} catch (Exception $e) {
    $conn->rollback(); // Rollback transaction on error
    echo json_encode(["success" => false, "message" => "Submission failed: " . $e->getMessage()]);
}

$conn->close();
?>
>>>>>>> 8c09b11f198c75afa0393fb462aad473cd62d512
