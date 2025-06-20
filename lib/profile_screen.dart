import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
<<<<<<< HEAD
import 'api_service.dart'; // Your API service file
import 'login_screen.dart'; // Import LoginScreen for navigation

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  bool _isEditing = false;
  bool _isSaving = false;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  int? userId;
  String? error;
  String? success;
=======
import 'dart:developer' as developer; // For logging
import 'api_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? user;
  bool isLoading = true;
>>>>>>> 8c09b11f198c75afa0393fb462aad473cd62d512

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');

    if (userId == null) {
      setState(() {
        _isLoading = false;
        error = "User not found. Please log in again.";
      });
      return;
    }

    final response = await getUserProfile(userId!);
    if (response['success']) {
      final user = response['user'];
      nameController = TextEditingController(text: user['name']);
      emailController = TextEditingController(text: user['email']);
      phoneController = TextEditingController(text: user['phone']);
      addressController = TextEditingController(text: user['address']);
      _isEditing = false;
    } else {
      error = response['message'] ?? "Failed to load user data";
    }

    setState(() => _isLoading = false);
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate() || userId == null) return;

    setState(() {
      _isSaving = true;
      success = null;
      error = null;
    });

    final response = await updateUserProfile(
      userId!,
      nameController.text.trim(),
      emailController.text.trim(),
      phoneController.text.trim(),
      addressController.text.trim(),
    );

    if (response['success']) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('remembered_email', emailController.text.trim());

      setState(() {
        success = "Profile updated successfully!";
        _isEditing = false;
      });
    } else {
      setState(() {
        error = response['message'] ?? "Failed to update profile.";
      });
    }

    setState(() => _isSaving = false);
  }

  void _cancelEditing() {
    setState(() => _isEditing = false);
  }

  Future<void> _logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('remember_me_preference');
    await prefs.remove('remembered_email');

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false, // Remove all previous routes
=======
    loadUserProfile();
  }

  void loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    
    if (userId != null) {
      try {
        final response = await getUserProfile(userId);
        if (!mounted) return; // Check if the widget is still in the tree

        // Log the raw user data from API for inspection
        developer.log('User profile API response: $response', name: 'ProfileScreen');

        if (response['success'] == true && response['user'] != null) {
          setState(() {
            user = response['user'] as Map<String, dynamic>; // Explicit cast
            isLoading = false;
          });
           // Log the processed user map
          developer.log('Processed user data: $user', name: 'ProfileScreen.User');
        } else {
          setState(() {
            isLoading = false;
            // user remains null, UI will show "User not found" or specific message from API
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message']?.toString() ?? "Failed to load profile data.")),
          );
        }
      } catch (e, stackTrace) {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        developer.log('Error loading profile: $e', name: 'ProfileScreen', error: e, stackTrace: stackTrace);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred: ${e.toString()}")),
        );
      }
    } else {
      // userId is null, meaning user is not logged in or ID wasn't saved.
      if (!mounted) return;
      setState(() {
        isLoading = false;
        // user remains null, UI will show "User not found"
      });
      developer.log('User ID not found in SharedPreferences.', name: 'ProfileScreen');
      // Optionally, inform the user or navigate to login
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("User session not found. Please log in again.")),
      // );
    }
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Only remove the user session ID, keep other preferences like 'remembered_email'
    // and 'remember_me_preference' if they exist.
    await prefs.remove('user_id'); 

    if (mounted) { // Check if the widget is still in the widget tree
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
>>>>>>> 8c09b11f198c75afa0393fb462aad473cd62d512
      );
    }
  }

<<<<<<< HEAD


  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    FormFieldValidator<String>? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: readOnly ? Colors.grey.shade100 : Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        style: readOnly ? TextStyle(color: const Color.fromARGB(255, 0, 0, 0)) : null,
      ),
    );
  }

=======
>>>>>>> 8c09b11f198c75afa0393fb462aad473cd62d512
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
<<<<<<< HEAD
            tooltip: 'Logout',
            onPressed: _logoutUser,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.blueAccent,
                            child: Icon(Icons.person, size: 50, color: Colors.white),
                          ),
                          SizedBox(height: 12),
                          Text(
                            nameController.text,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    if (error != null)
                      Text(error!, style: TextStyle(color: Colors.red)),
                    if (success != null)
                      Text(success!, style: TextStyle(color: Colors.green)),

                    SizedBox(height: 16),
                    _buildTextField(
                      label: "Name",
                      controller: nameController,
                      readOnly: true,
                    ),
                    _buildTextField(
                      label: "Email",
                      controller: emailController,
                      readOnly: !_isEditing,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Email required';
                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        return emailRegex.hasMatch(value) ? null : 'Invalid email';
                      },
                    ),
                    _buildTextField(
                      label: "Phone",
                      controller: phoneController,
                      readOnly: !_isEditing,
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                          value!.isEmpty ? "Phone cannot be empty" : null,
                    ),
                    _buildTextField(
                      label: "Address",
                      controller: addressController,
                      readOnly: !_isEditing,
                      maxLines: 2,
                      validator: (value) =>
                          value!.isEmpty ? "Address cannot be empty" : null,
                    ),
                    SizedBox(height: 20),
                    if (_isEditing)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isSaving ? null : _saveProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: _isSaving
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 2),
                                    )
                                  : Text(
                                      "Save Changes",
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isSaving ? null : _cancelEditing,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                              ),
                              child: Text("Cancel", style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      )
                    else
                      ElevatedButton(
                        onPressed: () => setState(() => _isEditing = true),
                        child: Text("Edit Profile"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          minimumSize: Size.fromHeight(50),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
=======
            onPressed: logout,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : user == null
              ? Center(child: Text("User not found"))
              : LayoutBuilder(
                  builder: (context, constraints) {
                    double width = constraints.maxWidth;
                    double contentWidth = width < 600 ? width * 0.9 : 500;

                    return SingleChildScrollView(
                      child: Center(
                        child: Container(
                          width: contentWidth,
                          padding: EdgeInsets.all(16),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Icon(Icons.person, size: 80, color: Colors.blue),
                                  ),
                                  SizedBox(height: 20),
                                  profileItem("Worker ID", user!['id']?.toString() ?? "N/A"), // Safer access
                                  profileItem("Full Name", user!['name']),
                                  profileItem("Email", user!['email']),
                                  profileItem("Phone Number", user!['phone']),
                                  profileItem("Address", user!['address']),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget profileItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info, color: Colors.blueAccent, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    )),
                SizedBox(height: 4),
                Text(value,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
>>>>>>> 8c09b11f198c75afa0393fb462aad473cd62d512
