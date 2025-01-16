import 'package:flutter/material.dart';
import 'package:todoly/model/task_model.dart';
import 'package:todoly/providers/task_provider.dart';

Future<dynamic> confirmClearAllTasks(
    BuildContext context, TaskNotifier tasksNotifier) {
  return showDialog(
    context: context,
    builder: (context) => Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 200),
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Are you sure you want to clear all TODOs?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("No"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 10,
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white),
                onPressed: () {
                  tasksNotifier.removeAllTasks();
                  Navigator.pop(context);
                },
                child: const Text("Yes"),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Future<dynamic> confirmDeleteTask(
    BuildContext context, TaskNotifier tasksNotifier, TaskModel task) {
  return showDialog(
    context: context,
    builder: (context) => Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 200),
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Are you Sure you want to delete?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  tasksNotifier.removeTask(task.id);
                  Navigator.pop(context);
                },
                child: const Text("Delete"),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
