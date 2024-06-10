import 'package:flutter/material.dart';
import 'task.dart';
import 'task_form.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TodoScreen extends StatefulWidget {
  @override
  TodoScreenState createState() => TodoScreenState();
}

class TodoScreenState extends State<TodoScreen> {
  List<Task> tasks = [];
  int _taskIdCounter = 1;
  bool _isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? taskList = prefs.getStringList('tasks');
    int? taskIdCounter = prefs.getInt('taskIdCounter');
    if (taskList != null) {
      setState(() {
        tasks =
            taskList.map((task) => Task.fromJson(json.decode(task))).toList();
        _taskIdCounter = taskIdCounter ?? 1;
      });
    }
  }

  Future<void> _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskList =
        tasks.map((task) => json.encode(task.toJson())).toList();
    prefs.setStringList('tasks', taskList);
    prefs.setInt('taskIdCounter', _taskIdCounter);
  }

  void addTask(Task task) {
    task.id = _taskIdCounter++;
    setState(() {
      tasks.add(task);
    });
    _saveTasks();
  }

  void editTask(Task oldTask, Task newTask) {
    final index = tasks.indexOf(oldTask);
    setState(() {
      tasks[index] = newTask;
    });
    _saveTasks();
  }

  void deleteTask(Task task) {
    setState(() {
      tasks.remove(task);
    });
    _saveTasks();
  }

  void navigateToTaskForm(BuildContext context, {Task? task}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(task: task),
      ),
    );

    if (result != null) {
      if (task != null) {
        editTask(task, result);
      } else {
        addTask(result);
      }
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('EEEE, d\'th\' MMMM').format(date);
  }

  @override
  Widget build(BuildContext context) {
    Map<DateTime, List<Task>> groupedTasks = {};
    tasks.forEach((task) {
      DateTime dateWithoutTime =
          DateTime(task.date.year, task.date.month, task.date.day);
      if (!groupedTasks.containsKey(dateWithoutTime)) {
        groupedTasks[dateWithoutTime] = [];
      }
      groupedTasks[dateWithoutTime]!.add(task);
    });

    List<DateTime> sortedDates = groupedTasks.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    final Color customColor = Color(0xff9e2ccb);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Habitica'),
          actions: [
            IconButton(
              icon: Icon(Icons.nightlight_round),
              onPressed: () {
                setState(() {
                  _isDarkMode = !_isDarkMode;
                });
              },
            ),
          ],
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: sortedDates.length,
          itemBuilder: (context, index) {
            final date = sortedDates[index];
            final dateTasks = groupedTasks[date]!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  color: customColor.withOpacity(0.1),
                  child: Text(
                    formatDate(date),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: customColor,
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                ...dateTasks
                    .map((task) => Material(
                          elevation: 0,
                          color: Colors.transparent,
                          child: Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            shadowColor: Colors.transparent,
                            child: Container(
                              padding: EdgeInsets.all(16.0),
                              child: ListTile(
                                title: Text(
                                  task.title,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Contact Name: ${task.contactName}'),
                                    Text('Phone Number: ${task.phoneNumber}'),
                                  ],
                                ),
                                onTap: () =>
                                    navigateToTaskForm(context, task: task),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon:
                                          Icon(Icons.edit, color: customColor),
                                      onPressed: () => navigateToTaskForm(
                                          context,
                                          task: task),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete,
                                          color: customColor),
                                      onPressed: () => deleteTask(task),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => navigateToTaskForm(context),
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: customColor,
        ),
      ),
    );
  }
}
