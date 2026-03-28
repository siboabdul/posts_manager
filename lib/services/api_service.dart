import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class ApiService {
  final String url = "https://jsonplaceholder.typicode.com/posts";

  Future<List<Post>> fetchPosts() async {
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data.map((e) => Post.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load posts");
      }
    } on TimeoutException {
      throw Exception("Request timeout");
    } catch (e) {
      throw Exception("Network error");
    }
  }

  Future<void> createPost(Post post) async {
    await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(post.toJson()),
    );
  }

  Future<void> updatePost(Post post) async {
    await http.put(
      Uri.parse("$url/${post.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(post.toJson()),
    );
  }

  Future<void> deletePost(int id) async {
    await http.delete(Uri.parse("$url/$id"));
  }
}
