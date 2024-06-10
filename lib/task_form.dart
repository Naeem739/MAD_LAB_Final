import 'package:flutter/material.dart';
import 'task.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  TaskFormScreen({Key? key, this.task}) : super(key: key);

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contactNameController;
  late TextEditingController _phoneNumberController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _contactNameController =
        TextEditingController(text: widget.task?.contactName ?? '');
    _phoneNumberController =
        TextEditingController(text: widget.task?.phoneNumber ?? '');
    _selectedDate = widget.task?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contactNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveTask() {
    final newTask = Task(
      title: _titleController.text,
      date: _selectedDate,
      id: widget.task?.id ?? 0,
      contactName: _contactNameController.text,
      phoneNumber: _phoneNumberController.text,
    );
    Navigator.of(context).pop(newTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Task Title',
              ),
            ),
            TextField(
              controller: _contactNameController,
              decoration: InputDecoration(
                labelText: 'Contact Name',
              ),
            ),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20.0),
            Row(
              children: <Widget>[
                Text('Select Date:'),
                SizedBox(width: 20.0),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    '${_selectedDate.toLocal()}'.split(' ')[0],
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _saveTask,
              child: Text('Save Task'),
            ),
          ],
        ),
      ),
    );
  }
}
