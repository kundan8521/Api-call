import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'comment_datamodel.dart'; // Adjust import path as needed

class CommentProvider extends ChangeNotifier {
  List<Comment> _comments = [];
  final Dio _dio = Dio();
  bool _isLoading = false;
  String? _errorMessage;

  List<Comment> get comments => _comments;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Method for GET requests to fetch comments
  Future<void> fetchComments() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      var response = await _dio.get("https://jsonplaceholder.typicode.com/comments");
      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        _comments = jsonData.map((json) => Comment.fromJson(json)).toList();
      } else {
        _errorMessage = 'Failed to load comments';
      }
    } catch (e) {
      _errorMessage = "Failed to load comments: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method for POST requests to create a comment
  Future<Comment> createComment(Comment comment) async {
    try {
      var commentResponse = await _dio.post(
        "https://jsonplaceholder.typicode.com/comments",
        data: jsonEncode(comment.toJson()),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (commentResponse.statusCode == 201) {
        final newComment = Comment.fromJson(commentResponse.data);
        _comments.add(newComment);
        Fluttertoast.showToast(
          msg: "Comment created successfully",
        );
        notifyListeners();
        return newComment;
      } else {
        throw Exception("Failed to create comment");
      }
    } catch (e) {
      throw Exception("Failed to create comment: $e");
    }
  }

  // Method for PUT requests to update a comment
  Future<Comment> updateComment(Comment comment) async {
    try {
      var putResponse = await _dio.put(
        "https://jsonplaceholder.typicode.com/comments/${comment.id}",
        data: jsonEncode(comment.toJson()),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (putResponse.statusCode == 200) {
        final replaceComment = Comment.fromJson(putResponse.data);
        _comments[_comments.indexWhere((c) => c.id == replaceComment.id)] = replaceComment;
        Fluttertoast.showToast(
          msg: "Comment updated successfully",
        );
        notifyListeners();
        return replaceComment;
      } else {
        throw Exception('Failed to update comment');
      }
    } catch (e) {
      throw Exception('Failed to update comment: $e');
    }
  }
}
