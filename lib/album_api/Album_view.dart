import 'package:flutter/material.dart';
import 'package:multiprovider/album_api/AlbumsDatamodel.dart';
import 'package:multiprovider/album_api/AlbumsProvider.dart';
import 'package:provider/provider.dart';


class JsonAlbumsview extends StatefulWidget {
  @override
  _JsonAlbumsviewState createState() => _JsonAlbumsviewState();
}

class _JsonAlbumsviewState extends State<JsonAlbumsview> {
  final TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AlbumsProvider>(context, listen: false).fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Json Albums APIs"),
        ),
        body: Consumer<AlbumsProvider>(
            builder: (context, albumsProvider, _) {
              if (albumsProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (albumsProvider.errorMessage != null) {
                return Center(child: Text(albumsProvider.errorMessage!));
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Create a new Album:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          controller: titleController,
                          decoration: const InputDecoration(labelText: 'Title'),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            final newAlbum = AlbumsDatamodel(
                              userId: 1,
                              id: 0,
                              title: titleController.text,
                            );
                            await albumsProvider.createPost(newAlbum);
                            titleController.clear();
                          },
                          child: Text('Add Album'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: albumsProvider.albums.length,
                      itemBuilder: (context, index) {
                        final album = albumsProvider.albums[index];
                        return ListTile(
                          title: Text('Title: ${album.title}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ID: ${album.id}'),
                              Text('User ID: ${album.userId}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  albumsProvider.deletePost(album.id);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  titleController.text = album.title;
                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Update Album'),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              TextField(
                                                controller: titleController,
                                                decoration: const InputDecoration(labelText: 'Title'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              final updatedAlbum = AlbumsDatamodel(
                                                userId: album.userId,
                                                id: album.id,
                                                title: titleController.text,
                                              );
                                              await albumsProvider.updatePost(updatedAlbum);
                                              titleController.clear();
                                              Navigator.pop(context);
                                            },
                                            child: Text('Update'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
            ),
        );
    }
}