// lib/task_list_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'task_model.dart';
import 'dart:developer' as developer; // Import developer for logging
import 'submit_completion_screen.dart'; // We'll create this next
import 'profile_screen.dart'; // To navigate to profile
import 'submission_history_screen.dart'; // Make sure this exists


class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> _tasks = [];
  bool _isLoading = true;
  String? _errorMessage;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUserIdAndFetchTasks();
  }

  Future<void> _loadUserIdAndFetchTasks() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentUserId = prefs.getInt('user_id');
    developer.log('Current User ID: $_currentUserId', name: 'TaskListScreen.loadUserId');

    if (_currentUserId == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = "User not logged in. Please login again.";
        // Optionally navigate to login screen
      });
      return;
    }
    await _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    if (_currentUserId == null) return;

    setState(() {
      _isLoading = true; // Show loader during refresh
      _errorMessage = null;
    });

    try {
      final response = await getAssignedWorks(_currentUserId!);
      developer.log('API Response for getAssignedWorks: $response', name: 'TaskListScreen.fetchTasks');
      if (!mounted) return;

      if (response['success'] == true) {
        final List<dynamic> worksData = response['works'] ?? [];
        developer.log('Works Data from API: $worksData', name: 'TaskListScreen.fetchTasks');
        setState(() {
          _tasks = worksData.map((data) => Task.fromJson(data as Map<String, dynamic>)).toList();
          _isLoading = false;
        });
        developer.log('Processed tasks: ${_tasks.length} tasks loaded.', name: 'TaskListScreen.fetchTasks');
      } else {
        developer.log('API call successful but response indicates failure: ${response['message']}', name: 'TaskListScreen.fetchTasks');
        setState(() {
          _isLoading = false;
          _errorMessage = response['message'] ?? "Failed to load tasks.";
        });
      }
    } catch (e) {
      if (!mounted) return;
      developer.log('Error fetching tasks: $e', name: 'TaskListScreen.fetchTasks', error: e);
      setState(() {
        _isLoading = false;
        _errorMessage = "An error occurred: $e";
      });
    }
  }

  void _navigateToSubmitCompletion(Task task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubmitCompletionScreen(task: task, workerId: _currentUserId!),
      ),
    );

    // If submission was successful, refresh the task list
    if (result == true) {
      _fetchTasks();
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date); // e.g., 25 May 2025
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'in progress':
        return Colors.blue;
      case 'submitted':
        return Colors.green;
      case 'completed':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Text("My Assigned Tasks"),
  actions: [
    IconButton(
      icon: Icon(Icons.history),
      tooltip: "Submission History",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SubmissionHistoryScreen()),
        );
      },
    ),
    IconButton(
      icon: Icon(Icons.person),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
      },
    ),
    IconButton(
      icon: Icon(Icons.refresh),
      onPressed: _fetchTasks,
    ),
  ],
),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(_errorMessage!, style: TextStyle(color: Colors.red, fontSize: 16), textAlign: TextAlign.center),
                  ),
                )
              : _tasks.isEmpty
                  ? Center(
                      child: Text("No tasks assigned to you yet.", style: TextStyle(fontSize: 16)),
                    )
                  : RefreshIndicator(
                      onRefresh: _fetchTasks,
                      child: ListView.builder(
                        itemCount: _tasks.length,
                        itemBuilder: (context, index) {
                          final task = _tasks[index];
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            elevation: 3,
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16),
                              title: Text(task.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8),
                                  Text("Task ID: ${task.id}", style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                                  SizedBox(height: 4),
                                  Text(task.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                                  SizedBox(height: 8),
                                  Text("Assigned: ${_formatDate(task.dateAssigned)}", style: TextStyle(color: Colors.grey[700])),
                                  SizedBox(height: 4),
                                  Text("Due Date: ${_formatDate(task.dueDate)}", style: TextStyle(color: Colors.grey[700])),
                                  SizedBox(height: 8), // Adjusted for better spacing before status
                                  Row(
                                    children: [
                                      Text("Status: ", style: TextStyle(color: Colors.grey[700])),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(task.status).withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          task.status.toUpperCase(),
                                          style: TextStyle(
                                            color: _getStatusColor(task.status),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              isThreeLine: true,
                              trailing: Icon(Icons.arrow_forward_ios, size: 16),
                              onTap: () => _navigateToSubmitCompletion(task),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
