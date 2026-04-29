class Comment {
  final String name;
  final String email;
  final String body;

  Comment({required this.name, required this.email, required this.body});

  factory Comment.fromJson(Map<String, dynamic> json) =>
      Comment(name: json['name'], email: json['email'], body: json['body']);
}