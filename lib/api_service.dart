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

Future<Map<String, dynamic>> getUserProfile(int id) async {
  final response = await http.post(
  Uri.parse("$baseUrl/profile.php"),
  body: {'id': id.toString()},
);
  return json.decode(response.body);
}
