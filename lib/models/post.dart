class Post {
  final int? id;
  final int userId; // ✅ ADD THIS
  final String title;
  final String body;

  Post({
    this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['userId'] ?? 1, // ✅ safe default
      title: json['title'],
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId, // ✅ include it
      'title': title,
      'body': body,
    };
  }
}
