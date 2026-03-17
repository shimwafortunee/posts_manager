// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class ApiService {
  final String baseUrl = "https://jsonplaceholder.typicode.com/posts";

  // GET all posts
  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load posts");
    }
  }

  // CREATE a post
  Future<void> createPost(String title, String body) async {
    await http.post(
      Uri.parse(baseUrl),
      body: {
        "title": title,
        "body": body,
      },
    );
  }

  // DELETE a post
  Future<void> deletePost(int id) async {
    await http.delete(Uri.parse("$baseUrl/$id"));
  }
}