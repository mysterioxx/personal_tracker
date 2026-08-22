class Task {
  String name;
  bool isCompleted;
  DateTime createdDate;

  Task({
    required this.name,
    this.isCompleted = false,
    required this.createdDate,
  });

  // Convert a Task object to a JSON map for saving.
  Map<String, dynamic> toJson() => {
        'name': name,
        'isCompleted': isCompleted,
        'createdDate': createdDate.toIso8601String(),
      };

  // Create a Task object from a JSON map.
  factory Task.fromJson(Map<String, dynamic> json) => Task(
        name: json['name'],
        isCompleted: json['isCompleted'] ?? false,
        createdDate: DateTime.parse(json['createdDate']),
      );
}
