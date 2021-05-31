import 'package:flutter/cupertino.dart';
import 'package:todo_app_firestore_example/api/firebase_api.dart';
import 'package:todo_app_firestore_example/model/todo.dart';

class TodosProvider extends ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos.where((todo) => todo.isDone == false).toList();

  List<Todo> get todosCompleted =>
      _todos.where((todo) => todo.isDone == true).toList();

  void setTodos(List<Todo> todos) =>
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _todos = todos;
        notifyListeners();
      });

  void addTodo(Todo todo) => FirebaseApi.createTodo(todo);

  Todo getRecentDeadline() {
    var todosHasDeadline = todos.where((todo) => (todo.deadlineTime != null &&
        todo.deadlineTime.millisecondsSinceEpoch >=
            DateTime.now().millisecondsSinceEpoch));

    if (todosHasDeadline.isEmpty) {
      return null;
    }
    return todosHasDeadline.reduce((current, next) {
      return current.deadlineTime.isBefore(next.deadlineTime) ? current : next;
    });
  }

  void removeTodo(Todo todo) => FirebaseApi.deleteTodo(todo);

  bool toggleTodoStatus(Todo todo) {
    todo.isDone = !todo.isDone;
    FirebaseApi.updateTodo(todo);

    return todo.isDone;
  }

  void updateTodo(
      Todo todo, String title, String description, DateTime deadline) {
    todo.title = title;
    todo.description = description;
    todo.deadlineTime = deadline;

    FirebaseApi.updateTodo(todo);
  }
}
