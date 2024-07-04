import 'package:firebase_todoapp/models/taskmodel.dart';
import 'package:firebase_todoapp/services/local_database_service.dart';
import 'package:firebase_todoapp/services/todo_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final taskNotifierProvider =
    StateNotifierProvider<TaskNotifier, List<Taskmodel>>((ref) {
  return TaskNotifier();
});

class TaskNotifier extends StateNotifier<List<Taskmodel>> {
  TaskNotifier() : super([]) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    final tasks = await LocalDatabaseService().getTasks();
    state = tasks;
  }

  Future<void> addTask(Taskmodel task) async {
    await LocalDatabaseService().insertTask(task);
    loadTasks();
  }

  Future<void> updateTask(Taskmodel task) async {
    await LocalDatabaseService().updateTask(task);
    await TodoService().updateTask(task);
    loadTasks();
  }

  Future<void> deleteTask(String id) async {
    await LocalDatabaseService().deleteTask(id);
    loadTasks();
  }

  Future<void> fetchTasksFromFirestore() async {
    await TodoService().fetchBackupTasks();
    loadTasks();
  }

  Future<void> backupTasksToFirestore() async {
    await TodoService().backupTasks(state);
  }
}
