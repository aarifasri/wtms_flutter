import 'dart:convert'; //for encoding &decoding
import 'package:http/http.dart' as http; //to make http request name as http

// Use localhost for Chrome web, 10.0.2.2 for Android Emulator, or IP for real device
const String baseUrl = "http://localhost/wtms_api"; // hold root url of the api

Future<Map<String, dynamic>> registerUser(
  String name,
  String email,
  String password,
  String phone,
  String address,
) async {
  final response = await http.post(
    Uri.parse("$baseUrl/register.php"),
    body: {
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
      "address": address,
    },
  );

  return json.decode(response.body); // convert json text received from server
}

Future<Map<String, dynamic>> loginUser(String email, String password) async {
  final response = await http.post(
    Uri.parse("$baseUrl/login.php"),
    body: {
      'email': email,
      'password': password,
    },
  );
  return json.decode(response.body);
}

Future<Map<String, dynamic>> getUserProfile(int userId) async {
  final response = await http.post(
    Uri.parse("http://localhost/wtms_api/get_user_profile.php"),
    body: {"id": userId.toString()},
  );

  return jsonDecode(response.body);
}


Future<Map<String, dynamic>> getAssignedWorks(int workerId) async {
  final url = Uri.parse('$baseUrl/get_works.php');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'worker_id': workerId}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {'success': false, 'message': 'Server error: ${response.statusCode}'};
    }
  } catch (e) {
    return {'success': false, 'message': 'An error occurred: $e'};
  }
}

Future<Map<String, dynamic>> submitWorkCompletion(int workId, int workerId, String submissionText) async {
  final url = Uri.parse('$baseUrl/submit_work.php');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'work_id': workId, 'worker_id': workerId, 'submission_text': submissionText}),
    );
    return jsonDecode(response.body);
  } catch (e) {
    return {'success': false, 'message': 'An error occurred: $e'};
  }
}




Future<Map<String, dynamic>> fetchExistingSubmission(int workId, int workerId) async {
  final url = Uri.parse('$baseUrl/get_submission.php');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'work_id': workId, 'worker_id': workerId}),
    );
    return jsonDecode(response.body);
  } catch (e) {
    return {'success': false, 'message': 'Failed to fetch submission: $e'};
  }
}

Future<Map<String, dynamic>> fetchWorkerSubmissions(int workerId) async {
  final url = Uri.parse('$baseUrl/get_submission.php');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'worker_id': workerId}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {'success': false, 'message': 'Failed with status ${response.statusCode}'};
    }
  } catch (e) {
    return {'success': false, 'message': 'Error: $e'};
  }
}

Future<Map<String, dynamic>> getSubmissionHistory(int workerId) async {
  final url = Uri.parse('$baseUrl/get_submission.php');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'worker_id': workerId}),
    );

    print("getSubmissionHistory response: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {'success': false, 'message': 'Server error: ${response.statusCode}'};
    }
  } catch (e) {
    return {'success': false, 'message': 'Error: $e'};
  }
}

Future<Map<String, dynamic>> updateSubmission(int submissionId, String newText) async {
  final response = await http.post(
    Uri.parse('http://localhost/wtms_api/update_submission.php'),
    body: {
      'submission_id': submissionId.toString(),
      'submission_text': newText,
    },
  );

  return jsonDecode(response.body);
}





Future<Map<String, dynamic>> updateUserProfile(
  int userId,
  String name,
  String email,
  String phone,
  String address,
) async {
  final response = await http.post(
    Uri.parse("http://localhost/wtms_api/update_profile.php"),
    body: {
      "id": userId.toString(),
      "name": name,
      "email": email,
      "phone": phone,
      "address": address,
    },
  );

  return jsonDecode(response.body);
}
