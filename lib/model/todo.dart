import 'package:flutter/cupertino.dart';
import 'package:todo_app_firestore_example/utils.dart';

class TodoField {
  static const createdTime = 'createdTime';
}

class Todo {
  DateTime createdTime;
  DateTime deadlineTime;
  String title;
  String id;
  String description;
  bool isDone;

  Todo({
    @required this.createdTime,
    @required this.deadlineTime,
    @required this.title,
    this.description = '',
    this.id,
    this.isDone = false,
  });

  static Todo fromJson(Map<String, dynamic> json) => Todo(
        createdTime: Utils.toDateTime(json['createdTime']),
        deadlineTime: Utils.toDateTime(json['deadlineTime']),
        title: json['title'],
        description: json['description'],
        id: json['id'],
        isDone: json['isDone'],
      );

  Map<String, dynamic> toJson() => {
        'createdTime': Utils.fromDateTimeToJson(createdTime),
        'deadlineTime': Utils.fromDateTimeToJson(deadlineTime),
        'title': title,
        'description': description,
        'id': id,
        'isDone': isDone,
      };
}
