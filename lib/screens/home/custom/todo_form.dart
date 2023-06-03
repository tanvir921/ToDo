import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              final String title = _titleController.text.trim();
              final String description = _descriptionController.text.trim();

              if (title.isNotEmpty && description.isNotEmpty) {
                if (widget.taskId != null) {
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

                Navigator.pop(context);
              }
            },
            child: Text('Save'),
          ),
        ],
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
