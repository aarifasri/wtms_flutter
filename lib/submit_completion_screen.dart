import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'api_service.dart';
import 'task_model.dart';
import 'edit_submission_screen.dart'; // Make sure this file exists

class SubmitCompletionScreen extends StatefulWidget {
  final Task task;
  final int workerId;

  SubmitCompletionScreen({required this.task, required this.workerId});

  @override
  _SubmitCompletionScreenState createState() => _SubmitCompletionScreenState();
}

class _SubmitCompletionScreenState extends State<SubmitCompletionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _submissionController = TextEditingController();

  bool _isSubmitting = false;
  bool _alreadySubmitted = false;
  String? _existingText;
  int? _submissionId;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _checkIfAlreadySubmitted();
  }

  Future<void> _checkIfAlreadySubmitted() async {
    // Call an endpoint (if available) to get existing submission
    final response = await fetchExistingSubmission(widget.task.id, widget.workerId);
    if (response['success'] == true && response['submission'] != null) {
      setState(() {
        _alreadySubmitted = true;
        _existingText = response['submission']['submission_text'];
        _submissionId = response['submission']['id'];
      });
    }
  }

  void _submitWork() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final response = await submitWorkCompletion(
      widget.task.id,
      widget.workerId,
      _submissionController.text.trim(),
    );

    setState(() => _isSubmitting = false);

    if (response['success'] == true) {
      setState(() {
        _alreadySubmitted = true;
        _statusMessage = "Submission successful!";
      });
      Navigator.pop(context, true); // return true to trigger refresh in parent
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? "Submission failed")),
      );
    }
  }

  void _editSubmission() async {
    if (_submissionId == null || _existingText == null) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditSubmissionScreen(
          submissionId: _submissionId!,
          workId: widget.task.id,
          workerId: widget.workerId,
          currentText: _existingText!,
        ),
      ),
    );

    if (result == true) {
      _checkIfAlreadySubmitted(); // Refresh data
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  void dispose() {
    _submissionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return Scaffold(
      appBar: AppBar(
        title: Text("Task Submission"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            // Task Info
            Text(task.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(task.description),
            SizedBox(height: 8),
            Text("Assigned: ${_formatDate(task.dateAssigned)}"),
            Text("Due Date: ${_formatDate(task.dueDate)}"),
            SizedBox(height: 20),

            if (_alreadySubmitted && _existingText != null) ...[
              Text("Your Submission:", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: Text(_existingText!),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _editSubmission,
                icon: Icon(Icons.edit),
                label: Text("Edit Submission"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              ),
            ] else ...[
              // Submission Form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Submit Your Work", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _submissionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter your completion notes or work details...",
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your submission';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitWork,
                      child: _isSubmitting
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Submit Work"),
                    ),
                  ],
                ),
              ),
            ],

            if (_statusMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(
                  _statusMessage!,
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
