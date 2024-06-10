import 'package:flutter/material.dart';
import 'home.dart';
import 'task.dart';
import 'login_page.dart'; // Remove this line
import 'package:todolist/login_page.dart'; // Remove this line
import 'package:todolist/registration_page.dart';
import 'registration_page.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/signup',
      routes: {
        '/login': (BuildContext context) => LoginPage(),
        '/signup': (BuildContext context) => RegistrationPage(),
        '/home': (BuildContext context) => HomeScreen(),
      },
    );
  }
}
