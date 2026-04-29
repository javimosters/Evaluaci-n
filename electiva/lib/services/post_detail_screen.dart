import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/comment.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;
  const PostDetailScreen({super.key, required this.post});
  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _api = ApiService();
  late Future<List<Comment>> _comments;
  late Future<User> _user;

  @override
  void initState() {
    super.initState();
    _comments = _api.getComments(widget.post.id);
    _user = _api.getUser(widget.post.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Text(widget.post.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // Contenido
            Text(widget.post.body, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 12),

            // Usuario
            FutureBuilder<User>(
              future: _user,
              builder: (context, snap) {
                if (!snap.hasData) return const Text('Cargando autor...');
                final u = snap.data!;
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(u.name),
                    subtitle: Text('${u.email}\n${u.city}'),
                    isThreeLine: true,
                  ),
                );
              },
            ),

            const Divider(height: 32),
            const Text('Comentarios',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // Comentarios
            FutureBuilder<List<Comment>>(
              future: _comments,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting)
                  return const CircularProgressIndicator();
                if (snap.hasError) return Text('Error: ${snap.error}');

                return Column(
                  children: snap.data!.map((c) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(c.email, style: const TextStyle(color: Colors.blue, fontSize: 12)),
                          const SizedBox(height: 6),
                          Text(c.body),
                        ],
                      ),
                    ),
                  )).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}