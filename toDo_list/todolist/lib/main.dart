import 'package:flutter/material.dart';
import 'package:todolist/todolist_interface.dart';

void main() {
  runApp(const ToDoListApp());
}

class ToDoListApp extends StatelessWidget {
  const ToDoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ToDoListInterface(title: 'Add item to the ToDo'),
    );
  }
}
