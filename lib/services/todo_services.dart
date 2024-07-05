import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todoapp/models/taskmodel.dart';
import 'package:firebase_todoapp/services/local_database_service.dart';

class TodoService {
  final todoCollection = FirebaseFirestore.instance.collection('todoApp');


  Future<void> updateTask(Taskmodel task) async {
    await todoCollection.doc(task.id).update(task.toMap());
  }

  Future<void> backupTasks(List<Taskmodel> localTasks) async {
    final firestoreTasks = await todoCollection.get();
    final firestoreTaskIds = firestoreTasks.docs.map((doc) => doc.id).toSet();
    final localTaskIds = localTasks.map((task) => task.id).toSet();

    // Delete tasks from Firestore that no longer exist in local database
    //it will check that if
    for (var doc in firestoreTasks.docs) {
      if (!localTaskIds.contains(doc.id)) {
        await todoCollection.doc(doc.id).delete();
      }
    }

    // Add new tasks to Firestore
    for (var task in localTasks) {
      if (!firestoreTaskIds.contains(task.id)) {
        await todoCollection.doc(task.id).set(task.toMap());
      }
    }
  }

  Future<void> fetchBackupTasks() async {
    final querySnapshot = await todoCollection.get();
    final localTasks = await LocalDatabaseService().getTasks();

    final localTaskIds = localTasks.map((task) => task.id).toSet();
    final remoteTasks =
        querySnapshot.docs.map((doc) => Taskmodel.fromSnapshot(doc)).toList();

    for (var task in remoteTasks) {
      if (!localTaskIds.contains(task.id)) {
        await LocalDatabaseService().insertTask(task);
      }
    }
  }
}
