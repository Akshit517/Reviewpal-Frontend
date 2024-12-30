
class Task {
  final String title;
  String? description;
  final DateTime dueDate;

  Task({
    required this.title,
    required this.dueDate,
    this.description,
  });
}