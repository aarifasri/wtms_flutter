import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'api_service.dart';

class SubmissionHistoryScreen extends StatefulWidget {
  @override
  _SubmissionHistoryScreenState createState() => _SubmissionHistoryScreenState();
}

class _SubmissionHistoryScreenState extends State<SubmissionHistoryScreen> {
  List<Map<String, dynamic>> _submissions = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSubmissions();
  }

  Future<void> _loadSubmissions() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');

    if (userId == null) {
      setState(() {
        _isLoading = false;
        _error = "User not logged in.";
      });
      return;
    }

    final response = await getSubmissionHistory(userId);

    if (response['success']) {
      setState(() {
        _submissions = List<Map<String, dynamic>>.from(response['submissions']);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
        _error = response['message'] ?? "Failed to load submissions.";
      });
    }
  }

  Future<void> _editSubmission(int submissionId, String currentText) async {
    TextEditingController controller = TextEditingController(text: currentText);

    bool? confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit Submission"),
        content: TextField(
          controller: controller,
          maxLines: 5,
          decoration: InputDecoration(labelText: "Submission Text"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Cancel")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text("Save"))
        ],
      ),
    );

    if (confirm == true) {
      final response = await updateSubmission(submissionId, controller.text.trim());

      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Submission updated.")));
        _loadSubmissions();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'] ?? "Failed to update.")));
      }
    }
  }

  String _formatDate(String rawDate) {
    try {
      DateTime parsed = DateTime.parse(rawDate);
      return DateFormat('dd MMM yyyy, hh:mm a').format(parsed);
    } catch (e) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Submission History"),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _loadSubmissions),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: TextStyle(color: Colors.red)))
              : _submissions.isEmpty
                  ? Center(child: Text("No submissions yet."))
                  : ListView.builder(
                      itemCount: _submissions.length,
                      itemBuilder: (context, index) {
                        final item = _submissions[index];
                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ExpansionTile(
                            title: Text(item['task_title'] ?? 'Work ID: ${item['work_id']}'),
                            subtitle: Text("Submitted: ${_formatDate(item['created_at'])}"),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['submission_text'], style: TextStyle(fontSize: 14)),
                                    SizedBox(height: 12),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton.icon(
                                        icon: Icon(Icons.edit),
                                        label: Text("Edit"),
                                        onPressed: () => _editSubmission(item['id'], item['submission_text']),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
    );
  }
}
