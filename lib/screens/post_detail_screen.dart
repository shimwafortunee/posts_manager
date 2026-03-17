// screens/post_detail_screen.dart
import 'package:flutter/material.dart';

class PostDetailScreen extends StatelessWidget {
  final Map post;

  PostDetailScreen({required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Details"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post['title'],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              post['body'],
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}