import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'profile_screen.dart' as ps; // Import with an alias
import 'dart:developer' as developer;

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Add this line
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth App',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id') != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While the future is resolving, show a loading indicator.
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          // If the future completes with an error, display an error message.
          // It's good practice to log the error for debugging.
          developer.log('Error in SplashScreen: ${snapshot.error}', name: 'SplashScreen');
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Failed to initialize. Please check your connection and try again.'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // For a StatelessWidget, a true "retry" of the future is complex.
                      // Navigating to a fallback screen like LoginScreen is a common approach.
                      // If ProfileScreen is accessible without login, that's an issue.
                      // Assuming LoginScreen is the safe fallback.
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                      );
                    },
                    child: const Text('Go to Login'),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasData) {
          // If the future completes successfully with data.
          // snapshot.data will be non-null here because hasData is true
          // and the future returns bool (a non-nullable type).
          return snapshot.data! ? ps.ProfileScreen() : LoginScreen(); // Use the alias
        } else {
          // This case (e.g., future completes with null, no error, but Future<bool> shouldn't do this)
          // is unlikely for a Future<bool> but acts as a fallback.
          return const Scaffold(body: Center(child: Text('Something unexpected happened.')));
        }
      },
    );
  }
}