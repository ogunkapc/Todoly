import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoly/model/task_model.dart';
import 'package:todoly/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter()); // Register the adapter
  await Hive.openBox<TaskModel>('tasks');
  runApp(
    const ProviderScope(
      child: Todoly(),
    ),
  );
}

class Todoly extends StatelessWidget {
  const Todoly({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todoly',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200],
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
