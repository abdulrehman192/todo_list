import 'package:cloud_firestore/cloud_firestore.dart';

class Task
{
  final String title;
  final bool status;
  final String taskId;

  Task({ required this.taskId,required this.title,required this.status});

  factory Task.fromSnapshot(DocumentSnapshot snapshot)
  {
    return Task(
      taskId: snapshot.id,
      title: snapshot.get('title'),
      status: snapshot.get('status') as bool
    );
  }
}