import 'package:flutter/material.dart';

class ToDoListInput extends StatelessWidget {
  const ToDoListInput({
    required this.text,
    required this.onPressed,
    super.key,
  });

  final String text;
  final Function(String) onPressed;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: text);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Enter text',
            hintStyle: const TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
          ),
          cursorColor: Colors.black,
          controller: controller,
        ),
        ElevatedButton(
          onPressed: () => onPressed(controller.text),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            textStyle: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
          ),
          child: const Text(
            'Add item',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
