import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multiprovider/album_api/AlbumsDatamodel.dart';

class AlbumsProvider extends ChangeNotifier {
  List<AlbumsDatamodel> albums = [];
  bool _isLoading = false;
  String? _errorMessage;
  final Dio _dio = Dio();

  List<AlbumsDatamodel> get comments => albums;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPosts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dio.get('https://jsonplaceholder.typicode.com/albums');
      if (response.statusCode == 200) {
        albums = (response.data as List)
            .map((data) => AlbumsDatamodel.fromJson(data))
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

  Future<void> createPost(AlbumsDatamodel comment) async {
    try {
      final response = await _dio.post(
        'https://jsonplaceholder.typicode.com/albums',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: json.encode(comment.toJson()),
      );

      if (response.statusCode == 201) {
        final newPost = AlbumsDatamodel.fromJson(response.data);
        albums.add(newPost);
        Fluttertoast.showToast(msg: 'Post Created Successfully');
        notifyListeners();
      } else {
        throw Exception('Failed to create post');
      }
    } catch (error) {
      throw Exception('Failed to create post');
    }
  }

  Future<void> updatePost(AlbumsDatamodel album) async {
    try {
      final response = await _dio.put(
        'https://jsonplaceholder.typicode.com/albums/${album.id}',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: json.encode(album.toJson()),
      );

      if (response.statusCode == 200) {
        final index = albums.indexWhere((p) => p.id == album.id);
        if (index != -1) {
          albums[index] = album;
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
      final response = await _dio.delete('https://jsonplaceholder.typicode.com/albums/$id');

      if (response.statusCode == 200) {
        albums.removeWhere((post) => post.id == id);
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