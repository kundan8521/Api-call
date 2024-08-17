import 'package:flutter/material.dart';
import 'package:multiprovider/comment_provider.dart';
import 'package:provider/provider.dart';

class CommentView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Consumer<CommentProvider>(
        builder: (context, provider, child) {
          if (provider.comments.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: provider.comments.length,
              itemBuilder: (context, index) {
                final comment = provider.comments[index];
                return ListTile(
                  title: Text(comment.name),
                  subtitle: Text(comment.body),
                  trailing: Text(comment.email),
                );
              },
            );
          }
        },
      ),
    );
  }
}
