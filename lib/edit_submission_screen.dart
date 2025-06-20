import 'package:flutter/material.dart';
import 'api_service.dart';

class EditSubmissionScreen extends StatefulWidget {
  final int submissionId;
  final int workId;
  final int workerId;
  final String currentText;

  EditSubmissionScreen({
    required this.submissionId,
    required this.workId,
    required this.workerId,
    required this.currentText,
  });

  @override
  _EditSubmissionScreenState createState() => _EditSubmissionScreenState();
}

class _EditSubmissionScreenState extends State<EditSubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controller;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentText);
  }

  void _updateSubmission() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isUpdating = true);

    final response = await updateSubmission(
  widget.submissionId,
  _controller.text.trim(),
);

    setState(() => _isUpdating = false);

    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Submission updated successfully.")));
      Navigator.pop(context, true); // Return true to trigger a refresh
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'] ?? "Update failed.")));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Submission")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                maxLines: 6,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Edit your submission",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Submission cannot be empty';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isUpdating ? null : _updateSubmission,
                child: _isUpdating
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
