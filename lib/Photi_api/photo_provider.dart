import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'photo_datamodel.dart';

class PhotoProvider extends ChangeNotifier {
  List<Photo> photos = [];
  bool _isLoading = false;
  String? _errorMessage;
  final Dio _dio = Dio();

  List<Photo> get photosList => photos;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  PhotoProvider() {
    fetchPhotos();
  }

  Future<void> fetchPhotos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dio.get('https://jsonplaceholder.typicode.com/photos');
      if (response.statusCode == 200) {
        photos = (response.data as List).map((data) => Photo.fromJson(data)).toList();
        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = 'Failed to load photos';
        _isLoading = false;
        notifyListeners();
      }
    } catch (error) {
      _errorMessage = error.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createPhoto(Photo photo) async {
    try {
      final response = await _dio.post(
        'https://jsonplaceholder.typicode.com/photos',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: json.encode(photo.toJson()),
      );

      if (response.statusCode == 201) {
        final newPhoto = Photo.fromJson(response.data);
        photos.add(newPhoto);
        Fluttertoast.showToast(msg: 'Photo Created Successfully');
        notifyListeners();
      } else {
        throw Exception('Failed to create photo');
      }
    } catch (error) {
      throw Exception('Failed to create photo: $error');
    }
  }

  Future<void> updatePhoto(Photo photo) async {
    try {
      final response = await _dio.put(
        'https://jsonplaceholder.typicode.com/photos/${photo.id}',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: json.encode(photo.toJson()),
      );

      if (response.statusCode == 200) {
        final index = photos.indexWhere((p) => p.id == photo.id);
        if (index != -1) {
          photos[index] = photo;
          Fluttertoast.showToast(msg: 'Photo Updated Successfully');
          notifyListeners();
        }
      } else {
        throw Exception('Failed to update photo');
      }
    } catch (error) {
      throw Exception('Failed to update photo: $error');
    }
  }

  Future<void> deletePhoto(int id) async {
    try {
      final response = await _dio.delete('https://jsonplaceholder.typicode.com/photos/$id');

      if (response.statusCode == 200) {
        photos.removeWhere((photo) => photo.id == id);
        Fluttertoast.showToast(msg: 'Photo Deleted Successfully');
        notifyListeners();
      } else {
        throw Exception('Failed to delete photo');
      }
    } catch (error) {
      throw Exception('Failed to delete photo: $error');
    }
  }
}
