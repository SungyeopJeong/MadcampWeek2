import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudyAdd extends StatefulWidget {
  const StudyAdd({Key? key}) : super(key: key);

  @override
  State<StudyAdd> createState() => _StudyAddState();
}

class _StudyAddState extends State<StudyAdd> {
  // Controller for text fields
  final TextEditingController _studyNameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _participantsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, // Set app bar background to transparent
        elevation: 0, // Remove app bar shadow
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black, // Set back button color to black
          ),
          onPressed: () {
            Navigator.of(context).pop(); // Handle back button press
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Study Name
              TextField(
                controller: _studyNameController,
                decoration: const InputDecoration(labelText: 'Study Name'),
              ),
              const SizedBox(height: 16.0),

              // Category
              TextField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 16.0),

              // Description
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 16.0),

              // Participants
              TextField(
                controller: _participantsController,
                decoration: const InputDecoration(labelText: 'Participants'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),

              // Button to submit
              ElevatedButton(
                onPressed: () {
                  // Handle the submission logic here
                  String studyName = _studyNameController.text;
                  String category = _categoryController.text;
                  String description = _descriptionController.text;
                  int participants =
                      int.tryParse(_participantsController.text) ?? 0;

                  // Clear text field controllers
                  _studyNameController.clear();
                  _categoryController.clear();
                  _descriptionController.clear();
                  _participantsController.clear();
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
