import 'package:flutter/material.dart';
import 'package:todoly/model/task_model.dart';
import 'package:todoly/providers/task_provider.dart';
import 'package:todoly/utils/helpers.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.tasksNotifier,
  });

  final TaskModel task;
  final TaskNotifier tasksNotifier;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 8,
      ),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) {
            tasksNotifier.updateTask(task.id, isCompleted: value);
          },
        ),
        title: GestureDetector(
          onTap: () {
            tasksNotifier.updateTask(
              task.id,
              isCompleted: !task.isCompleted,
            );
          },
          child: Text(
            task.title,
            style: TextStyle(
              decoration: task.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      String newTitle = task.title;
                      return AlertDialog(
                        title: const Text('Edit Task'),
                        content: TextField(
                          controller: TextEditingController(text: newTitle),
                          onChanged: (value) {
                            newTitle = value;
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade500,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              tasksNotifier.updateTask(
                                task.id,
                                title: newTitle,
                              );
                              Navigator.pop(context);
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.edit),
            ),
            GestureDetector(
              onTap: () {
                confirmDeleteTask(context, tasksNotifier, task);
              },
              child: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
