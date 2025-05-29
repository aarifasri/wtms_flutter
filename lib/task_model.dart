// lib/task_model.dart
class Task {
  final int id;
  final String title;
  final String description;
  final int assignedTo;
  final DateTime dateAssigned;
  final DateTime dueDate;
  String status; // Modifiable if you update it locally after submission

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.dateAssigned,
    required this.dueDate,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      assignedTo: json['assigned_to'] != null ? int.parse(json['assigned_to'].toString()) : 0, // Handle potential string from DB
      dateAssigned: DateTime.parse(json['date_assigned'] as String),
      dueDate: DateTime.parse(json['due_date'] as String),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'assigned_to': assignedTo,
      'date_assigned': dateAssigned.toIso8601String().split('T')[0], // Format as YYYY-MM-DD
      'due_date': dueDate.toIso8601String().split('T')[0], // Format as YYYY-MM-DD
      'status': status,
    };
  }
}
