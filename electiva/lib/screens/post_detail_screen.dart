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
      backgroundColor: const Color(0xFFF5F0EB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar custom
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1008),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.arrow_back, color: Color(0xFFF5F0EB), size: 18),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8572A),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('PULSE',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 3)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Título
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(widget.post.title,
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1A1008),
                        height: 1.2)),
              ),

              const SizedBox(height: 16),

              // Autor
              FutureBuilder<User>(
                future: _user,
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text('Cargando autor...', style: TextStyle(color: Colors.grey)),
                    );
                  }
                  final u = snap.data!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8572A),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Center(
                            child: Text(u.name[0].toUpperCase(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(u.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: Color(0xFF1A1008))),
                            Text('${u.email}  ·  ${u.city}',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: const Color(0xFF1A1008).withOpacity(0.45))),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Línea decorativa
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Container(width: 40, height: 3, color: const Color(0xFFE8572A)),
                    const SizedBox(width: 6),
                    Container(width: 8, height: 3, color: const Color(0xFFE8572A).withOpacity(0.3)),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Cuerpo del post
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(widget.post.body,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF3D2E1E),
                        height: 1.8)),
              ),

              const SizedBox(height: 32),

              // Separador comentarios
              Container(
                color: const Color(0xFF1A1008),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    const Text('Comentarios',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5)),
                    const Spacer(),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8572A),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),

              // Lista de comentarios
              FutureBuilder<List<Comment>>(
                future: _comments,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: CircularProgressIndicator(color: Color(0xFFE8572A))),
                    );
                  }
                  if (snap.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text('Error: ${snap.error}'),
                    );
                  }
                  return Column(
                    children: snap.data!.asMap().entries.map((entry) {
                      final i = entry.key;
                      final c = entry.value;
                      return _CommentTile(comment: c, index: i);
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final Comment comment;
  final int index;
  const _CommentTile({required this.comment, required this.index});

  @override
  Widget build(BuildContext context) {
    final isEven = index % 2 == 0;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isEven ? const Color(0xFFF5F0EB) : const Color(0xFFEDE8E1),
        border: Border(
          left: BorderSide(
            color: index == 0 ? const Color(0xFFE8572A) : const Color(0xFF1A1008).withOpacity(0.1),
            width: index == 0 ? 3 : 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(comment.name,
              style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: Color(0xFF1A1008))),
          const SizedBox(height: 2),
          Text(comment.email,
              style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFFE8572A),
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Text(comment.body,
              style: TextStyle(
                  fontSize: 13,
                  color: const Color(0xFF1A1008).withOpacity(0.65),
                  height: 1.6)),
        ],
      ),
    );
  }
}