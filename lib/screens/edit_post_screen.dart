// screens/edit_post_screen.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EditPostScreen extends StatefulWidget {
  final Map post;

  EditPostScreen({required this.post});

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // ✅ Pre-fill form with existing data
    _titleController.text = widget.post['title'];
    _bodyController.text = widget.post['body'];
  }

  Future<void> updatePost() async {
    final response = await http.put(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/${widget.post['id']}'),
      headers: {"Content-type": "application/json"},
      body: jsonEncode({
        "title": _titleController.text,
        "body": _bodyController.text,
        "userId": widget.post['userId'],
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context, true); // return success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update post")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Post"),
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
              onPressed: updatePost,
              child: Text("Update Post"),
            ),
          ],
        ),
      ),
    );
  }
}