import 'package:cloud_firestore/cloud_firestore.dart';

class Taskmodel {
  final String? id;

  // final String title;
  final String time;
  final String date;
  final String note;

  Taskmodel({
    // required this.title,
    required this.time,
    required this.date,
    required this.note,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      //'task': title,
      'time': time,
      'date': date,
      'note': note,
    };
  }

  factory Taskmodel.fromMap(Map<String, dynamic> map) {
    return Taskmodel(
      id: map['id'],
      //  title: map['task'],
      time: map['time'],
      date: map['date'],
      note: map['note'],
    );
  }

  factory Taskmodel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Taskmodel(
      //title: doc['title'],
        time: doc['time'],
        date: doc['date'],
        note: doc['note'],
        id: doc.id);
  }
}
