import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';
import 'post_detail_screen.dart';

class PostsListScreen extends StatefulWidget {
  const PostsListScreen({super.key});
  @override
  State<PostsListScreen> createState() => _PostsListScreenState();
}

class _PostsListScreenState extends State<PostsListScreen> {
  final _api = ApiService();
  late Future<List<Post>> _posts;

  @override
  void initState() {
    super.initState();
    _posts = _api.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Publicaciones')),
      body: FutureBuilder<List<Post>>(
        future: _posts,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (snap.hasError)
            return Center(child: Text('Error: ${snap.error}'));

          return ListView.builder(
            itemCount: snap.data!.length,
            itemBuilder: (context, i) {
              final post = snap.data![i];
              return ListTile(
                title: Text(post.title),
                subtitle: Text(post.body, maxLines: 1, overflow: TextOverflow.ellipsis),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => PostDetailScreen(post: post))),
              );
            },
          );
        },
      ),
    );
  }
}