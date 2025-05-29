// lib/submit_completion_screen.dart
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'task_model.dart';

class SubmitCompletionScreen extends StatefulWidget {
  final Task task;
  final int workerId;

  SubmitCompletionScreen({required this.task, required this.workerId});

  @override
  _SubmitCompletionScreenState createState() => _SubmitCompletionScreenState();
}

class _SubmitCompletionScreenState extends State<SubmitCompletionScreen> {
  final _formKey = GlobalKey<FormState>();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        ),
      ),
    );
  }
}
