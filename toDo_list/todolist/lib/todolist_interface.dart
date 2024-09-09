import 'package:flutter/material.dart';
import 'package:todolist/todolist_input.dart';
import 'package:todolist/todolist_list.dart';

class ToDoListInterface extends StatefulWidget {
  const ToDoListInterface({super.key, required this.title});
  final String title;

  @override
  State<ToDoListInterface> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoListInterface> {
  String newTask = '';
  final List<String> taskList = ['Wake up', 'Open eyes', 'Close eyes', 'Fall asleep', 'Repeat'];

  void addTask(String text) {
    if (text.isEmpty) {
      return;
    }
    setState(() {
      taskList.add(text);
      newTask = '';
    });
  }

  void completeTask(String task) {
    setState(() {
      taskList.remove(task);
      newTask = task;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(child: ToDoList(itemList: taskList, onItemTap: completeTask)),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ToDoListInput(text: newTask, onPressed: addTask),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}