import 'package:flutter/material.dart';
import 'package:multiprovider/Comment_api/comment_provider.dart';
import 'package:multiprovider/Photi_api/photo_provider.dart';
import 'package:multiprovider/Post_Api/Post_provider.dart';
import 'package:multiprovider/Users_api/user_provider.dart';
import 'package:multiprovider/album_api/AlbumsProvider.dart';
import 'package:multiprovider/Screen/home_screen.dart';
import 'package:multiprovider/todo_api/todo_provider.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider( // Use MultiProvider to provide multiple providers
      providers: [
        ChangeNotifierProvider(create: (_) => PostsProvider()),
        ChangeNotifierProvider(create: (_) => AlbumsProvider()), // Provide AlbumProvider
        ChangeNotifierProvider(create: (_) => CommentProvider()),
        ChangeNotifierProvider(create: (_) => PhotoProvider()), //
        ChangeNotifierProvider(create: (_) => TodoProvider()), // Provide AlbumProvider
        ChangeNotifierProvider(create: (_) => UserProvider()), // Provide AlbumProvider




      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
