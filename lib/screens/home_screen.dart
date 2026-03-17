// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'add_post_screen.dart';
import 'edit_post_screen.dart';
import 'post_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  // ✅ GET POSTS
  Future<void> fetchPosts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );

      if (response.statusCode == 200) {
        setState(() {
          posts = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load posts");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading posts")),
      );
    }
  }

  // ✅ DELETE POST
  Future<void> deletePost(int id) async {
    final response = await http.delete(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'),
    );

    if (response.statusCode == 200) {
      setState(() {
        posts.removeWhere((post) => post['id'] == id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Post deleted")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete")),
      );
    }
  }

  // ✅ CONFIRM DELETE
  void confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Delete"),
        content: Text("Are you sure you want to delete this post?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              deletePost(id);
              Navigator.pop(ctx);
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts Manager"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchPosts,
          )
        ],
      ),

      // ✅ BODY
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchPosts,
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];

                  return Card(
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(post['title']),
                      subtitle: Text(
                        post['body'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // 👉 CLICK TO VIEW DETAILS
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PostDetailScreen(post: post),
                          ),
                        );
                      },

                      // 👉 ACTION BUTTONS
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ✏️ EDIT
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditPostScreen(post: post),
                                ),
                              );

                              if (result == true) {
                                fetchPosts();
                              }
                            },
                          ),

                          // 🗑 DELETE
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => confirmDelete(post['id']),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

      // ➕ ADD POST BUTTON
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPostScreen(),
            ),
          );

          if (result == true) {
            fetchPosts();
          }
        },
      ),
    );
  }
}