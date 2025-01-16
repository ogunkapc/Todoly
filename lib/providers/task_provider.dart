import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoly/model/task_model.dart';

final taskProvider =
    StateNotifierProvider<TaskNotifier, List<TaskModel>>((ref) {
  return TaskNotifier();
});

class TaskNotifier extends StateNotifier<List<TaskModel>> {
  TaskNotifier() : super([]) {
    _loadTasks();
  }

  final _taskBox = Hive.box<TaskModel>('tasks');

  //! Load tasks from the database
  void _loadTasks() {
    state = _taskBox.values.toList();
  }

  //! Add a new task
  void addTask(String title) async {
    final trimmedTitle = title.trim();
    final newTask = TaskModel(id: DateTime.now().toString(), title: trimmedTitle);
    await _taskBox.add(newTask);
    state = [..._taskBox.values];
  }

  //! Update an existing task
  void updateTask(String id, {bool? isCompleted, String? title}) {
    final taskIndex = state.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      final updatedTask = state[taskIndex].copyWith(
        title: title,
        isCompleted: isCompleted,
      );
      updatedTask.save();
      state = [
        for (final task in state)
          if (task.id == id) updatedTask else task
      ];
    }
  }

  //! Remove a task
  void removeTask(String id) async {
    final task = state.firstWhere((task) => task.id == id);
    await task.delete();
    state = state.where((task) => task.id != id).toList();
  }

  //! Remove all tasks
  void removeAllTasks() {
    _taskBox.clear();
    state = [];
  }

  //! Get the number of completed tasks
  int get completedTasksCount {
    return state.where((task) => task.isCompleted).length;
  }

  //! Get the number of pending tasks
  int get pendingTasksCount {
    return state.where((task) => !task.isCompleted).length;
  }

  //! Get the number of total tasks
  int get totalTasksCount {
    return state.length;
  }
}
