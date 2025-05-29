import 'package:flutter/material.dart';
import 'api_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final response = await registerUser(
      fullNameController.text,
      emailController.text,
      passwordController.text,
      phoneController.text,
      addressController.text,
    );

    if (!mounted) return; // Check if widget is still in the tree

    setState(() => isLoading = false);

    final message = response['message'] ?? 'Registration failed';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

    if (response['success'] && mounted) Navigator.pop(context); // Back to login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text("Register"),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          double contentWidth = width < 600 ? width * 0.9 : 500;

          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Container(
                width: contentWidth,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Icon(Icons.app_registration, size: 80, color: Colors.blueAccent),
                      SizedBox(height: 16),
                      Text(
                        "Create Account",
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                      ),
                      SizedBox(height: 32),

                      // Full Name
                      TextFormField(
                        controller: fullNameController,
                        decoration: InputDecoration(
                          labelText: "Full Name",
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Full name is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Email
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email is required';
                          }
                          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Password
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Confirm Password
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          prefixIcon: Icon(Icons.lock_outline), // Using a slightly different lock icon
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Phone
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Phone number is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Address
                      TextFormField(
                        controller: addressController,
                        decoration: InputDecoration(
                          labelText: "Address",
                          prefixIcon: Icon(Icons.home),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Address is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : handleRegister,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            backgroundColor: Colors.blueAccent,
                          ),
                          child: isLoading
                              ? SizedBox(
                                  height: 24, // Consistent height for indicator
                                  width: 24,  // Consistent width for indicator
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : Text("Register", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}