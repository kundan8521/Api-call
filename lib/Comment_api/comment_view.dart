import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'comment_provider.dart'; // Adjust import path as per your project structure

class CommentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
      ),
      body: ChangeNotifierProvider(
        create: (context) => CommentProvider()..fetchComments(), // Fetch comments once
        child: Consumer<CommentProvider>(
          builder: (context, commentProvider, _) {
            if (commentProvider.comments.isEmpty) {
              if (commentProvider.errorMessage != null) {
                return Center(
                  child: Text(commentProvider.errorMessage!),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: commentProvider.comments.length,
              itemBuilder: (context, index) {
                final comment = commentProvider.comments[index];
                return ListTile(
                  title: Text(comment.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(comment.email),
                      Text(comment.body),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
