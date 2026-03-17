// screens/add_post_screen.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  Future<void> createPost() async {
    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      headers: {"Content-type": "application/json"},
      body: jsonEncode({
        "title": _titleController.text,
        "body": _bodyController.text,
        "userId": 1,
      }),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context, true); // success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create post")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Post"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(labelText: "Body"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: createPost,
              child: Text("Create Post"),
            ),
          ],
        ),
      ),
    );
  }
}