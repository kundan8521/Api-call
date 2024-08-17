import 'package:flutter/material.dart';
import 'package:multiprovider/todo_api/todo_datamodel.dart';
import 'package:provider/provider.dart';
import 'todo_provider.dart';

class TodoViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos'),
      ),
      body: Consumer<TodoProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }
          return ListView.builder(
            itemCount: provider.todosList.length,
            itemBuilder: (context, index) {
              Todo todo = provider.todosList[index];
              return ListTile(
                title: Text(todo.title),
                subtitle: Text('Completed: ${todo.completed ? "Yes" : "No"}'),
                leading: Icon(todo.completed ? Icons.check_circle : Icons.cancel),
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
          // Implement add todo behavior
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
