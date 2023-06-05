import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_assignment/responsive/mediaquery.dart';
import 'package:todo_assignment/screens/home/todo/todo_form.dart';

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
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          if (documents.isEmpty) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add task by clicking',
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.add_circle,
                    size: 25,
                  )
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final task = documents[index];
              final String title = task['title'];
              final String description = task['description'];
              final bool isDone = task['isDone'] ?? false;
              final Color tileColor =
                  Color(int.parse(task['color'], radix: 16));

              return InkWell(
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Edit Task'),
                    content: TodoForm(
                      color: task['color'],
                      userId: userId,
                      initialTitle: title,
                      initialDescription: description,
                      taskId: task.id,
                    ),
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  height: context.height * 0.16,
                  decoration: BoxDecoration(
                    color: tileColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 40,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Checkbox(
                          activeColor: Theme.of(context).primaryColor,
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
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        height: context.height * 0.12,
                        width: context.width * 0.6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                // Truncate long titles with ellipsis
                                title.length > 23
                                    ? '${title.substring(0, 23)}...'
                                    : title,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  decoration: isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                // Truncate long descriptions with ellipsis
                                description.length > 100
                                    ? '${description.substring(0, 100)}...'
                                    : description,
                                style: TextStyle(
                                  decoration: isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            topLeft: Radius.circular(10),
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.black.withOpacity(0.6),
                          ),
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('todos')
                                .doc(userId)
                                .collection('tasks')
                                .doc(task.id)
                                .delete();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error loading tasks');
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
