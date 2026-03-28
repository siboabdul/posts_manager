import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';

class AddEditScreen extends StatefulWidget {
  final Post? post;

  AddEditScreen({this.post});

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService api = ApiService();

  late TextEditingController titleController;
  late TextEditingController bodyController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.post?.title ?? "");
    bodyController = TextEditingController(text: widget.post?.body ?? "");
  }

  Future<void> savePost() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final post = Post(
      id: widget.post?.id,
      title: titleController.text,
      body: bodyController.text,
      userId: 1,
    );

    if (widget.post == null) {
      await api.createPost(post);
    } else {
      await api.updatePost(post);
    }

    setState(() => isLoading = false);

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Post saved successfully"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 28, 99, 83),
        title: Text(widget.post == null ? "Add Post" : "Edit Post"),
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 3,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // TITLE FIELD
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.title),
                    ),
                    validator: (value) => value!.isEmpty ? "Enter title" : null,
                  ),

                  SizedBox(height: 15),

                  // BODY FIELD
                  TextFormField(
                    controller: bodyController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: "Body",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.description),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Enter content" : null,
                  ),

                  SizedBox(height: 20),

                  // SAVE BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 66, 91, 2),
                        padding: EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: isLoading ? null : savePost,
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Save Post"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
