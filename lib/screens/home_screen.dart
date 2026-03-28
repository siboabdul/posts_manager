import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/post.dart';
import 'add_edit_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService api = ApiService();
  late Future<List<Post>> posts;

  @override
  void initState() {
    super.initState();
    posts = api.fetchPosts();
  }

  void refresh() {
    setState(() {
      posts = api.fetchPosts();
    });
  }

  // ✅ DELETE CONFIRMATION DIALOG
  void confirmDelete(Post post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text("Delete Post"),
        content: Text("Are you sure you want to delete this post?"),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text("Delete"),
            onPressed: () async {
              Navigator.pop(context);
              await api.deletePost(post.id!);
              refresh();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Post deleted successfully"),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      // ✅ APP BAR
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(249, 0, 62, 44),
        centerTitle: true,
        title: Text(
          "Posts Manager",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      // ✅ ADD BUTTON
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigo,
        icon: Icon(Icons.add),
        label: Text("Add Post"),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddEditScreen()),
          );
          refresh();
        },
      ),

      // ✅ BODY
      body: FutureBuilder<List<Post>>(
        future: posts,
        builder: (context, snapshot) {
          // LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.indigo),
                  SizedBox(height: 10),
                  Text("Loading posts..."),
                ],
              ),
            );
          }

          // ERROR
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error loading data",
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          final data = snapshot.data!;

          // EMPTY
          if (data.isEmpty) {
            return Center(
              child: Text(
                "No posts available",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // LIST
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final post = data[index];

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(14),

                    // ✅ ICON BEFORE TITLE (INNOVATION)
                    leading: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.indigo[100],
                      child: Icon(
                        index % 3 == 0
                            ? Icons.article
                            : index % 3 == 1
                            ? Icons.note
                            : Icons.description,
                        color: Colors.indigo,
                      ),
                    ),

                    // TITLE
                    title: Text(
                      post.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[900],
                      ),
                    ),

                    // BODY
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        post.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),

                    // OPEN DETAILS
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailScreen(post: post),
                        ),
                      );
                    },

                    // ACTIONS
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // EDIT
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          tooltip: "Edit Post",
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddEditScreen(post: post),
                              ),
                            );
                            refresh();
                          },
                        ),

                        // DELETE
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          tooltip: "Delete Post",
                          onPressed: () {
                            confirmDelete(post);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
