import 'package:flutter/material.dart';
import 'package:todoly/providers/task_provider.dart';

class AddTaskDialog extends StatelessWidget {
  AddTaskDialog({
    super.key,
    required this.tasksNotifier,
  });

  final TextEditingController controller = TextEditingController();
  final TaskNotifier tasksNotifier;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Task'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: 'Enter task title',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
          ),
          onPressed: () {
            if (controller.text.isNotEmpty) {
              tasksNotifier.addTask(controller.text);
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
