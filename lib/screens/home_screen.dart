import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoly/providers/task_provider.dart';
import 'package:todoly/utils/constants.dart';
import 'package:todoly/utils/helpers.dart';
import 'package:todoly/widgets/add_task_dialog.dart';
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
          PopupMenuButton<dynamic>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              if (value is TaskFilter) {
                tasksNotifier.setFilter(value);
              } else if (value is TaskSort) {
                tasksNotifier.setSort(value);
              }
            },
            itemBuilder: (context) => [
              // Filtering options with icons
              const PopupMenuItem(
                value: TaskFilter.all,
                child: Row(
                  children: [
                    Icon(Icons.list, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Show All'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: TaskFilter.completed,
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Show Completed'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: TaskFilter.pending,
                child: Row(
                  children: [
                    Icon(Icons.hourglass_bottom, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Show Pending'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              // Sorting options with icons
              const PopupMenuItem(
                value: TaskSort.alphabetical,
                child: Row(
                  children: [
                    Icon(Icons.sort_by_alpha, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Sort Alphabetically'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: TaskSort.creationTime,
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.purple),
                    SizedBox(width: 8),
                    Text('Sort by Creation Time'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: TaskSort.completionStatus,
                child: Row(
                  children: [
                    Icon(Icons.done_all, color: Colors.teal),
                    SizedBox(width: 8),
                    Text('Sort by Completion Status'),
                  ],
                ),
              ),
            ],
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
