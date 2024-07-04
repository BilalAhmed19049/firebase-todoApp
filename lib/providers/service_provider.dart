import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todoapp/models/taskmodel.dart';
import 'package:firebase_todoapp/services/todo_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final serviceProvider = StateProvider<TodoService>((ref) {
  return TodoService();
});

final fetchStreamProvider = StreamProvider<List<Taskmodel>>((ref) async* {
  final getData = FirebaseFirestore.instance
      .collection('todoApp')
      .snapshots()
      .map((event) => event.docs
          .map((snapshot) => Taskmodel.fromSnapshot(snapshot))
          .toList());
  yield* getData;
});
