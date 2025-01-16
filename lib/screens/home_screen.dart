import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoly/providers/task_provider.dart';
import 'package:todoly/utils/helpers.dart';
import 'package:todoly/widgets/task_tile.dart';

class HomeSreen extends ConsumerWidget {
  const HomeSreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);
    final tasksNotifier = ref.read(taskProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Schedule",
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text(
                    'Task Stats',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Total Tasks: ${tasks.length}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Completed Tasks: ${tasksNotifier.completedTasksCount}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Pending Tasks: ${tasksNotifier.pendingTasksCount}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
          TextButton(
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
            onPressed: () {
              confirmClearAllTasks(context, tasksNotifier);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              child: tasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.task_alt,
                              size: 100, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'No tasks yet!',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Tap the + button to add your first task.',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return TaskTile(
                          task: task,
                          tasksNotifier: tasksNotifier,
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AddTaskDialog(tasksNotifier: tasksNotifier);
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

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
