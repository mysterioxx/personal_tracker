import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_tracker/dashboard1.dart'; // Ensure this path is correct

void main() {
  group('Task', () {
    test('Task can be converted to and from JSON', () {
      final task = Task(name: 'Test Task', createdDate: DateTime(2025, 10, 3));
      final taskJson = jsonEncode(task.toJson());
      final decodedTask = Task.fromJson(jsonDecode(taskJson));

      expect(decodedTask.name, 'Test Task');
      expect(decodedTask.isCompleted, false);
      expect(decodedTask.createdDate, DateTime(2025, 10, 3));
    });
  });
}