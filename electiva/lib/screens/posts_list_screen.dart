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
      backgroundColor: const Color(0xFFF5F0EB),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8572A),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('PULSE',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 3,
                                fontFamily: 'Georgia')),
                      ),
                      const SizedBox(height: 6),
                      const Text('Lo que\npasa hoy.',
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              height: 1.1,
                              color: Color(0xFF1A1008))),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1008),
                      borderRadius: BorderRadius.circular(21),
                    ),
                    child: const Icon(Icons.person_outline, color: Color(0xFFF5F0EB), size: 22),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Divider(color: const Color(0xFF1A1008).withOpacity(0.15), thickness: 1),
            ),
            const SizedBox(height: 4),

            // List
            Expanded(
              child: FutureBuilder<List<Post>>(
                future: _posts,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xFFE8572A)),
                    );
                  }
                  if (snap.hasError) {
                    return Center(child: Text('Error: ${snap.error}'));
                  }
                  final posts = snap.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: posts.length,
                    itemBuilder: (context, i) {
                      final post = posts[i];
                      final isHighlight = i == 0;
                      return isHighlight
                          ? _HighlightCard(post: post, index: i)
                          : _PostTile(post: post, index: i);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HighlightCard extends StatelessWidget {
  final Post post;
  final int index;
  const _HighlightCard({required this.post, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => PostDetailScreen(post: post))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1008),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8572A),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('DESTACADO',
                      style: TextStyle(color: Colors.white, fontSize: 9, letterSpacing: 2, fontWeight: FontWeight.w800)),
                ),
                const Spacer(),
                Text('#${post.id}',
                    style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12)),
              ],
            ),
            const SizedBox(height: 14),
            Text(post.title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    height: 1.3)),
            const SizedBox(height: 10),
            Text(post.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 13, height: 1.5)),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('Leer más →',
                    style: const TextStyle(color: Color(0xFFE8572A), fontWeight: FontWeight.w700, fontSize: 13)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PostTile extends StatelessWidget {
  final Post post;
  final int index;
  const _PostTile({required this.post, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => PostDetailScreen(post: post))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: const Color(0xFF1A1008).withOpacity(0.1)),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Número
            SizedBox(
              width: 32,
              child: Text(
                '${post.id}'.padLeft(2, '0'),
                style: TextStyle(
                    color: const Color(0xFFE8572A).withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(width: 8),
            // Contenido
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.title,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1008),
                          height: 1.3)),
                  const SizedBox(height: 4),
                  Text(post.body,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xFF1A1008).withOpacity(0.45),
                          height: 1.4)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios,
                size: 12, color: const Color(0xFF1A1008).withOpacity(0.25)),
          ],
        ),
      ),
    );
  }
}