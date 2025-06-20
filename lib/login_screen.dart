import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'task_list_screen.dart'; // Changed from ProfileScreen
import 'register_screen.dart';
import 'worker_home_page.dart';


class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool _rememberMe = false;
  String? errorMessage; // 👈 for showing login failure

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  void _loadUserPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMePreference = prefs.getBool('remember_me_preference') ?? false;
    String? rememberedEmail = prefs.getString('remembered_email');

    setState(() {
      _rememberMe = rememberMePreference;
      if (_rememberMe && rememberedEmail != null) {
        emailController.text = rememberedEmail;
      }
    });
  }



  void handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = null; // clear previous error
    });

    final response = await loginUser(emailController.text.trim(), passwordController.text);

    if (!mounted) return;

    setState(() => isLoading = false);

    if (response['success']) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("user_id", response['user']['id']);

      if (_rememberMe) {
        await prefs.setBool('remember_me_preference', true);
        await prefs.setString('remembered_email', emailController.text.trim());
      } else {
        await prefs.setBool('remember_me_preference', false);
        await prefs.remove('remembered_email');
      }
      if (mounted) {
        // Navigate to TaskListScreen instead of ProfileScreen
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => WorkerHomePage()));
      }
    } else {
      if (mounted) {
        setState(() {
          errorMessage = response['message'] ?? "Wrong email or password";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
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
                    )
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock, size: 80, color: Colors.blueAccent),
                      SizedBox(height: 24),
                      Text(
                        "Worker Task Management System",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28, // Slightly larger for main title
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800, // A deep blue
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(height: 32),

                      // Email
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
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
                          if (!emailRegex.hasMatch(value.trim())) {
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

                      // Remember Me Checkbox
                      CheckboxListTile(
                        title: Text("Remember Me"),
                        value: _rememberMe,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _rememberMe = newValue ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading, // Checkbox on the left
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ),
                      SizedBox(height: 8), // Adjusted spacing
                      // Error Message
                      if (errorMessage != null)
                        Text(
                          errorMessage!,
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                        ),
                      SizedBox(height: 8),
                      // Login button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : handleLogin,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
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
                              : Text("Login", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                      SizedBox(height: 12),

                      // Register
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen()));
                        },
                        child: Text(
                          "Don't have an account? Register",
                          style: TextStyle(color: Colors.blueAccent),
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}