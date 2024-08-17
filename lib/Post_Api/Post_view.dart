import 'package:flutter/material.dart';
import 'package:multiprovider/Post_Api/Post_provider.dart';
import 'package:provider/provider.dart';
import 'package:multiprovider/Post_Api/Post_datamodel.dart';

class JsonPostsView extends StatefulWidget {
  @override
  _JsonPostsViewState createState() => _JsonPostsViewState();
}

class _JsonPostsViewState extends State<JsonPostsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostsProvider>(context, listen: false).fetchPosts();
    });
  }

  void _createPost(BuildContext context) {
    final newPost = Post(userId: 1, id: 101, title: 'New Post', body: 'This is a new post');
    Provider.of<PostsProvider>(context, listen: false).createPost(newPost);
  }

  Future<void> _showUpdateDialog(BuildContext context, Post post) async {
    final titleController = TextEditingController(text: post.title);
    final bodyController = TextEditingController(text: post.body);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: bodyController,
                decoration: InputDecoration(labelText: 'Body'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final updatedPost = post.copyWith(
                  title: titleController.text,
                  body: bodyController.text,
                );
                Provider.of<PostsProvider>(context, listen: false).updatePost(updatedPost);
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, int id) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Post'),
          content: Text('Are you sure you want to delete this post?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      Provider.of<PostsProvider>(context, listen: false).deletePost(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _createPost(context),
          ),
        ],
      ),
      body: Consumer<PostsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          } else {
            return ListView.builder(
              itemCount: provider.posts.length,
              itemBuilder: (context, index) {
                final post = provider.posts[index];
                return ListTile(
                  title: Text(post.title),
                  subtitle: Text(post.body),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showUpdateDialog(context, post),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _confirmDelete(context, post.id),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
