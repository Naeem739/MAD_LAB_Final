import 'package:flutter/material.dart';
import 'task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  int _taskIdCounter = 1;

  List<Task> get tasks => _tasks;

  void addTask(Task task) {
    task.id = _taskIdCounter++;
    _tasks.add(task);
    notifyListeners();
  }

  void editTask(Task oldTask, Task newTask) {
    final index = _tasks.indexOf(oldTask);
    _tasks[index] = newTask;
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }
}
