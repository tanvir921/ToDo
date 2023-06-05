import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  final List<ColorOption> titleColors = [
    ColorOption('Red', Colors.red.withOpacity(0.7)),
    ColorOption('Orange', Colors.orange.withOpacity(0.7)),
    ColorOption('Green', Colors.green.withOpacity(0.7)),
    ColorOption('Blue', Colors.blue.withOpacity(0.7)),
    ColorOption('Indigo', Colors.indigo.withOpacity(0.7)),
    ColorOption('Purple', Colors.purple.withOpacity(0.7)),
  ];
  ColorOption? _selectedColorOption;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.initialTitle ?? '';
    _descriptionController.text = widget.initialDescription ?? '';
    _selectedColorOption = titleColors[0];
  }

  @override
  Widget build(BuildContext context) {
    // Generate a random index
    Random random = Random();
    int randomIndex = random.nextInt(titleColors.length);

    // Retrieve the random color option from the list
    ColorOption randomColorOption = titleColors[randomIndex];

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

            // Selectable dropdown menu for color options
            DropdownButtonFormField<ColorOption>(
              value: _selectedColorOption,
              onChanged: (newValue) {
                setState(() {
                  _selectedColorOption = newValue;
                });
              },
              items: titleColors
                  .map((colorOption) => DropdownMenuItem<ColorOption>(
                        value: colorOption,
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              color: colorOption.color,
                            ),
                            SizedBox(width: 8),
                            Text(
                              colorOption.name,
                              //style: TextStyle(color: colorOption.color),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
              decoration: InputDecoration(labelText: 'Color'),
            ),

            SizedBox(height: 20.0),

            // Save button
            InkWell(
              onTap: () {
                final String title = _titleController.text.trim();
                final String description = _descriptionController.text.trim();
                final String colorHexCode =
                    _selectedColorOption!.color.value.toRadixString(16);

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
                      'createdAt': DateTime.now(),
                      'color': colorHexCode,
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
                      'createdAt': DateTime.now(),
                      'color': colorHexCode,
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

class ColorOption {
  final String name;
  final Color color;

  ColorOption(this.name, this.color);
}
