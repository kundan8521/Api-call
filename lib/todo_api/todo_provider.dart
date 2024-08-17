import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'todo_datamodel.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> todos = [];
  bool _isLoading = false;
  String? _errorMessage;
  final Dio _dio = Dio();

  List<Todo> get todosList => todos;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  TodoProvider() {
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dio.get('https://jsonplaceholder.typicode.com/todos');
      if (response.statusCode == 200) {
        todos = (response.data as List).map((data) => Todo.fromJson(data)).toList();
        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = 'Failed to load todos';
        _isLoading = false;
        notifyListeners();
      }
    } catch (error) {
      _errorMessage = error.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createTodo(Todo todo) async {
    try {
      final response = await _dio.post(
        'https://jsonplaceholder.typicode.com/todos',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: json.encode(todo.toJson()),
      );

      if (response.statusCode == 201) {
        final newTodo = Todo.fromJson(response.data);
        todos.add(newTodo);
        Fluttertoast.showToast(msg: 'Todo Created Successfully');
        notifyListeners();
      } else {
        throw Exception('Failed to create todo');
      }
    } catch (error) {
      throw Exception('Failed to create todo: $error');
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      final response = await _dio.put(
        'https://jsonplaceholder.typicode.com/todos/${todo.id}',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: json.encode(todo.toJson()),
      );

      if (response.statusCode == 200) {
        final index = todos.indexWhere((t) => t.id == todo.id);
        if (index != -1) {
          todos[index] = todo;
          Fluttertoast.showToast(msg: 'Todo Updated Successfully');
          notifyListeners();
        }
      } else {
        throw Exception('Failed to update todo');
      }
    } catch (error) {
      throw Exception('Failed to update todo: $error');
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      final response = await _dio.delete('https://jsonplaceholder.typicode.com/todos/$id');

      if (response.statusCode == 200) {
        todos.removeWhere((todo) => todo.id == id);
        Fluttertoast.showToast(msg: 'Todo Deleted Successfully');
        notifyListeners();
      } else {
        throw Exception('Failed to delete todo');
      }
    } catch (error) {
      throw Exception('Failed to delete todo: $error');
    }
  }
}
