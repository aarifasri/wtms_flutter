<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'api_service.dart';
import 'task_model.dart';
import 'edit_submission_screen.dart'; // Make sure this file exists
=======
// lib/submit_completion_screen.dart
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'task_model.dart';
>>>>>>> 8c09b11f198c75afa0393fb462aad473cd62d512

class SubmitCompletionScreen extends StatefulWidget {
  final Task task;
  final int workerId;

  SubmitCompletionScreen({required this.task, required this.workerId});

  @override
  _SubmitCompletionScreenState createState() => _SubmitCompletionScreenState();
}

class _SubmitCompletionScreenState extends State<SubmitCompletionScreen> {
  final _formKey = GlobalKey<FormState>();
<<<<<<< HEAD
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
=======
  final _submissionTextController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitWork() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await submitWorkCompletion(
        widget.task.id,
        widget.workerId,
        _submissionTextController.text.trim(),
      );

      if (!mounted) return;

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? "Work submitted successfully!"), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true); // Pop with true to indicate success and trigger refresh
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? "Failed to submit work."), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _submissionTextController.dispose();
>>>>>>> 8c09b11f198c75afa0393fb462aad473cd62d512
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
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
=======
    return Scaffold(
      appBar: AppBar(
        title: Text("Submit Completion"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Task Title:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700]),
              ),
              SizedBox(height: 4),
              Text(
                widget.task.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
              Text(
                "Task Description:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700]),
              ),
              SizedBox(height: 4),
              Text(
                widget.task.description,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              TextFormField(
                controller: _submissionTextController,
                decoration: InputDecoration(
                  labelText: 'What did you complete?',
                  hintText: 'Enter details of the work you performed...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your work completion details.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitWork,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: _isSubmitting
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                        )
                      : Text('Submit Work', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
>>>>>>> 8c09b11f198c75afa0393fb462aad473cd62d512
        ),
      ),
    );
  }
}
