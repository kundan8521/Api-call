import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'user_datamodel.dart';

class UserProvider extends ChangeNotifier {
  List<User> users = [];
  bool _isLoading = false;
  String? _errorMessage;
  final Dio _dio = Dio();

  List<User> get usersList => users;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  UserProvider() {
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dio.get('https://jsonplaceholder.typicode.com/users');
      if (response.statusCode == 200) {
        users = (response.data as List).map((data) => User.fromJson(data)).toList();
        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = 'Failed to load users';
        _isLoading = false;
        notifyListeners();
      }
    } catch (error) {
      _errorMessage = error.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createUser(User user) async {
    try {
      final response = await _dio.post(
        'https://jsonplaceholder.typicode.com/users',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: json.encode(user.toJson()),
      );

      if (response.statusCode == 201) {
        final newUser = User.fromJson(response.data);
        users.add(newUser);
        Fluttertoast.showToast(msg: 'User Created Successfully');
        notifyListeners();
      } else {
        throw Exception('Failed to create user');
      }
    } catch (error) {
      throw Exception('Failed to create user: $error');
    }
  }

  Future<void> updateUser(User user) async {
    try {
      final response = await _dio.put(
        'https://jsonplaceholder.typicode.com/users/${user.id}',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: json.encode(user.toJson()),
      );

      if (response.statusCode == 200) {
        final index = users.indexWhere((u) => u.id == user.id);
        if (index != -1) {
          users[index] = user;
          Fluttertoast.showToast(msg: 'User Updated Successfully');
          notifyListeners();
        }
      } else {
        throw Exception('Failed to update user');
      }
    } catch (error) {
      throw Exception('Failed to update user: $error');
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      final response = await _dio.delete('https://jsonplaceholder.typicode.com/users/$id');

      if (response.statusCode == 200) {
        users.removeWhere((user) => user.id == id);
        Fluttertoast.showToast(msg: 'User Deleted Successfully');
        notifyListeners();
      } else {
        throw Exception('Failed to delete user');
      }
    } catch (error) {
      throw Exception('Failed to delete user: $error');
    }
  }
}
