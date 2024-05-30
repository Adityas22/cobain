import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<dynamic> _newsArticles = [];
  bool _isLoading = true;

  // Ganti YOUR_API_KEY dengan kunci API yang Anda miliki
  static const String apiKey = 'adc74bc8ee7c497eae3cd52a1aedff04';

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    final response = await http.get(
      Uri.parse(
          'https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'ok') {
        setState(() {
          _newsArticles = data['articles'];
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load news: ${data['message']}');
      }
    } else {
      throw Exception('Failed to load news: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _newsArticles.length,
              itemBuilder: (context, index) {
                final article = _newsArticles[index];
                return ListTile(
                  title: Text(article['title']),
                  subtitle: Text(
                      article['description'] ?? 'No description available'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NewsDetailScreen(article: article),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class NewsDetailScreen extends StatelessWidget {
  final dynamic article;

  const NewsDetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article['title'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article['title'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(article['description']),
            const SizedBox(height: 20),
            Text(article['content']),
          ],
        ),
      ),
    );
  }
}
