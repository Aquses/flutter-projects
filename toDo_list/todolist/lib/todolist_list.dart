import 'package:flutter/material.dart';

class ToDoList extends StatelessWidget {
  const ToDoList({required this.itemList, required this.onItemTap, super.key});
  final List<String> itemList;
  final Function(String) onItemTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: itemList.map<Widget>((String task) {
        return ToDoListTile(
          task: task,
          onTap: () => onItemTap(task),
        );
      }).toList(),
    );
  }
}

class ToDoListTile extends StatelessWidget {
  const ToDoListTile({super.key, required this.task, required this.onTap});

  final String task;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(task, style: const TextStyle(fontSize: 18)),
    );
  }
}
