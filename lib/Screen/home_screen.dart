import 'package:flutter/material.dart';
import 'package:multiprovider/Comment_api/comment_datamodel.dart';
import 'package:multiprovider/Comment_api/comment_view.dart';
import 'package:multiprovider/Photi_api/photo_view.dart';
import 'package:multiprovider/Post_Api/Post_view.dart';
import 'package:multiprovider/Users_api/user_api_view.dart';
import 'package:multiprovider/album_api/Album_view.dart';
import 'package:multiprovider/todo_api/todo_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => _navigateToPostApiView(context),
              child: Text('Post API View'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToAlbumApiView(context),
              child: Text('Album API View'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToCommentApiView(context),
              child: Text('Comment API View'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToPhotoApiView(context),
              child: Text('Photo API View'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToTodoApiView(context),
              child: Text('Todo API View'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToUserApiView(context),
              child: Text('User API View'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPostApiView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JsonPostsView()),
    );
  }

  void _navigateToAlbumApiView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JsonAlbumsview()),
    );
  }

  void _navigateToCommentApiView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CommentScreen()),
    );
  }

  void _navigateToPhotoApiView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PhotoViewPage()),
    );
  }

  void _navigateToTodoApiView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TodoViewPage()),
    );
  }

  void _navigateToUserApiView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserViewPage()),
    );
  }
}
