import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'photo_provider.dart';
import 'photo_datamodel.dart';

class PhotoViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photos'),
      ),
      body: Consumer<PhotoProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }
          return ListView.builder(
            itemCount: provider.photosList.length,
            itemBuilder: (context, index) {
              Photo photo = provider.photosList[index];
              return ListTile(
                title: Text(photo.title),
                subtitle: Text('Album ID: ${photo.albumId}'),
                leading: Image.network(photo.thumbnailUrl),
                onTap: () {
                  // Implement onTap behavior
                },
                onLongPress: () {
                  // Implement onLongPress behavior
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement add photo behavior
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
