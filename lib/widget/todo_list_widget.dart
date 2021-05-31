import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_firestore_example/model/todo.dart';
import 'package:todo_app_firestore_example/provider/notifications.dart';
import 'package:todo_app_firestore_example/provider/todos.dart';
import 'package:todo_app_firestore_example/widget/todo_widget.dart';

class TodoListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodosProvider>(context);
    final todos = provider.todos;
    final notificationProvider = Provider.of<NotificationService>(context);
    Todo recentDeadlineTodo;

    if (todos.isNotEmpty) {
      recentDeadlineTodo = provider.getRecentDeadline();
      if (recentDeadlineTodo != null) {
        notificationProvider.sheduledNotification(recentDeadlineTodo);
      }
    }

    return todos.isEmpty
        ? Center(
            child: Text(
              'No todos to display.',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          )
        : ListView.separated(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(16),
            separatorBuilder: (context, index) => Container(height: 8),
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];

              return TodoWidget(todo: todo);
            },
          );
  }
}
