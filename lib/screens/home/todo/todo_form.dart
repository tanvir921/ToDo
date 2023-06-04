import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_assignment/responsive/mediaquery.dart';

class TodoForm extends StatefulWidget {
  final String userId;
  final String? initialTitle;
  final String? initialDescription;
  final String? taskId;

  TodoForm({
    required this.userId,
    this.initialTitle,
    this.initialDescription,
    this.taskId,
  });

  @override
  _TodoFormState createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.initialTitle ?? '';
    _descriptionController.text = widget.initialDescription ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Text field for entering the title
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16.0),
            // Text field for entering the description
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20.0),
            // Save button
            InkWell(
              onTap: () {
                final String title = _titleController.text.trim();
                final String description = _descriptionController.text.trim();

                if (title.isNotEmpty && description.isNotEmpty) {
                  if (widget.taskId != null) {
                    // Update an existing task
                    FirebaseFirestore.instance
                        .collection('todos')
                        .doc(widget.userId)
                        .collection('tasks')
                        .doc(widget.taskId)
                        .update({
                      'title': title,
                      'description': description,
                    });
                  } else {
                    // Add a new task
                    FirebaseFirestore.instance
                        .collection('todos')
                        .doc(widget.userId)
                        .collection('tasks')
                        .add({
                      'title': title,
                      'description': description,
                      'isDone': false,
                    });
                  }

                  // Navigate back to the previous screen
                  Navigator.pop(context);
                }
              },
              child: Container(
                height: context.height * 0.04,
                width: context.width * 0.2,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'SAVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
