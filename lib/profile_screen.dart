import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  @override
  void initState() {
    super.initState();
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
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
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