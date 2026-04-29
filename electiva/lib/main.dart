import 'package:flutter/material.dart';
import 'screens/posts_list_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pulse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Georgia',
        scaffoldBackgroundColor: const Color(0xFFF5F0EB),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE8572A)),
        useMaterial3: true,
      ),
      home: const PostsListScreen(),
    );
  }
}