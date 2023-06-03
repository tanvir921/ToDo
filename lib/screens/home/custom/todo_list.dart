import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_assignment/screens/home/custom/todo_form.dart';

class TodoList extends StatelessWidget {
  final String userId;

  TodoList({required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('todos')
          .doc(userId)
          .collection('tasks')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final task = documents[index];
              final String title = task['title'];
              final String description = task['description'];
              final bool isDone = task['isDone'] ?? false;

              return ListTile(
                leading: Checkbox(
                  value: isDone,
                  onChanged: (value) {
                    FirebaseFirestore.instance
                        .collection('todos')
                        .doc(userId)
                        .collection('tasks')
                        .doc(task.id)
                        .update({'isDone': value});
                  },
                ),
                title: Text(
                  title,
                  style: TextStyle(
                    decoration: isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text(
                  description,
                  style: TextStyle(
                    decoration: isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Edit Task'),
                            content: TodoForm(
                              userId: userId,
                              initialTitle: title,
                              initialDescription: description,
                              taskId: task.id,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('todos')
                            .doc(userId)
                            .collection('tasks')
                            .doc(task.id)
                            .delete();
                      },
                    ),
                  ],
                ),
                onLongPress: () {
                  FirebaseFirestore.instance
                      .collection('todos')
                      .doc(userId)
                      .collection('tasks')
                      .doc(task.id)
                      .delete();
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error loading tasks');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
