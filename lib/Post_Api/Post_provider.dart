import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multiprovider/Post_Api/Post_datamodel.dart';

class PostsProvider extends ChangeNotifier {
  List<Post> posts = [];
  bool _isLoading = false;
  String? _errorMessage;
  final Dio _dio = Dio();

  List<Post> get comments => posts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPosts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dio.get('https://jsonplaceholder.typicode.com/posts');
      if (response.statusCode == 200) {
        posts = (response.data as List)
            .map((data) => Post.fromJson(data))
            .toList();
        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = 'Failed to load posts';
        _isLoading = false;
        notifyListeners();
      }
    } catch (error) {
      _errorMessage = error.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createPost(Post post) async {
    try {
      final response = await _dio.post(
        'https://jsonplaceholder.typicode.com/posts',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: json.encode(post.toJson()),
      );

      if (response.statusCode == 201) {
        final newPost = Post.fromJson(response.data);
        posts.add(newPost);
        Fluttertoast.showToast(msg: 'Post Created Successfully');
        notifyListeners();
      } else {
        throw Exception('Failed to create post');
      }
    } catch (error) {
      throw Exception('Failed to create post');
    }
  }

  Future<void> updatePost(Post post) async {
    try {
      final response = await _dio.put(
        'https://jsonplaceholder.typicode.com/posts/${post.id}',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: json.encode(post.toJson()),
      );

      if (response.statusCode == 200) {
        final index = posts.indexWhere((p) => p.id == post.id);
        if (index != -1) {
          posts[index] = post;
          Fluttertoast.showToast(msg: 'Post Updated Successfully');
          notifyListeners();
        }
      } else {
        throw Exception('Failed to update post');
      }
    } catch (error) {
      throw Exception('Failed to update post');
    }
  }

  Future<void> deletePost(int id) async {
    try {
      final response = await _dio.delete('https://jsonplaceholder.typicode.com/posts/$id');

      if (response.statusCode == 200) {
        posts.removeWhere((post) => post.id == id);
        Fluttertoast.showToast(msg: 'Post Deleted Successfully');
        notifyListeners();
      } else {
        throw Exception('Failed to delete post');
      }
    } catch (error) {
      throw Exception('Failed to delete post');
    }
  }
}