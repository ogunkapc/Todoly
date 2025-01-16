import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoly/model/task_model.dart';
import 'package:todoly/utils/constants.dart';

final taskProvider =
    StateNotifierProvider<TaskNotifier, List<TaskModel>>((ref) {
  return TaskNotifier();
});

class TaskNotifier extends StateNotifier<List<TaskModel>> {
  TaskNotifier() : super([]) {
    _loadTasks();
  }

  final _taskBox = Hive.box<TaskModel>('tasks');
  TaskFilter _currentFilter = TaskFilter.all;
  TaskSort _currentSort = TaskSort.creationTime;

  //! Load tasks from the database
  void _loadTasks() {
    state = _taskBox.values.toList();
  }

  //! Add a new task
  void addTask(String title) async {
    final trimmedTitle = title.trim();
    final newTask =
        TaskModel(id: DateTime.now().toString(), title: trimmedTitle);
    await _taskBox.add(newTask);
    state = [..._taskBox.values];
    _applySortAndFilter();
  }

  //! Update an existing task
  void updateTask(String id, {bool? isCompleted, String? title}) {
    final taskIndex =
        _taskBox.values.toList().indexWhere((task) => task.id == id);
    if (taskIndex == -1) {
      throw Exception('Task not found.');
    }
    if (taskIndex != -1) {
      final originalTask = _taskBox.getAt(taskIndex)!;
      final updatedTask = originalTask.copyWith(
        title: title ?? originalTask.title,
        isCompleted: isCompleted ?? originalTask.isCompleted,
      );
      _taskBox.putAt(taskIndex, updatedTask);

      _applySortAndFilter();
    }
  }

  //! Remove a task
  void removeTask(String id) async {
    final task = state.firstWhere((task) => task.id == id);
    await task.delete();
    state = state.where((task) => task.id != id).toList();
    _applySortAndFilter();
  }

  //! Remove all tasks
  void removeAllTasks() {
    _taskBox.clear();
    state = [];
  }

  //! Apply a filter to the task list
  void setFilter(TaskFilter filter) {
    _currentFilter = filter;
    _applySortAndFilter();
  }

  //! Apply sorting to the task list
  void setSort(TaskSort sort) {
    _currentSort = sort;
    _applySortAndFilter();
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

  //! Apply both sorting and filtering
  void _applySortAndFilter() {
    // Filter
    var filteredTasks = _taskBox.values.toList();
    if (_currentFilter == TaskFilter.completed) {
      filteredTasks = filteredTasks.where((task) => task.isCompleted).toList();
    } else if (_currentFilter == TaskFilter.pending) {
      filteredTasks = filteredTasks.where((task) => !task.isCompleted).toList();
    }

    // Sort
    if (_currentSort == TaskSort.alphabetical) {
      filteredTasks.sort((a, b) => a.title.compareTo(b.title));
    } else if (_currentSort == TaskSort.creationTime) {
      filteredTasks.sort((a, b) => a.id.compareTo(b.id));
    } else if (_currentSort == TaskSort.completionStatus) {
      filteredTasks.sort((a, b) =>
          a.isCompleted.toString().compareTo(b.isCompleted.toString()));
    }

    state = filteredTasks;
  }
}
