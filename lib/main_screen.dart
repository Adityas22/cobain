import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'login_screen.dart';
import 'convert_money.dart';
import 'convert_time.dart';
import 'profile.dart';
import 'feedback.dart';
import 'bookmark_screen.dart';

class MainScreen extends StatefulWidget {
  final String username;

  const MainScreen({Key? key, required this.username}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<dynamic> _newsArticles = [];
  List<dynamic> _filteredNewsArticles = [];
  List<dynamic> _bookmarkedArticles = [];
  bool _isLoading = true;
  static const String apiKey = 'adc74bc8ee7c497eae3cd52a1aedff04';
  final List<bool> _bookmarks = [];
  late Box<dynamic> _bookmarkBox;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bookmarkBox = Hive.box('bookmarks');
    _loadBookmarkedArticles();
    _fetchNews();
    _searchController.addListener(_filterArticles);
  }

  Future<void> _loadBookmarkedArticles() async {
    final bookmarks = _bookmarkBox.get(widget.username) ?? [];
    setState(() {
      _bookmarkedArticles = List<dynamic>.from(bookmarks);
    });
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
          _filteredNewsArticles = _newsArticles;
          _isLoading = false;
          _bookmarks.addAll(_newsArticles.map((article) {
            return _bookmarkedArticles.any((bookmarkedArticle) =>
                bookmarkedArticle['title'] == article['title']);
          }).toList());
        });
      } else {
        throw Exception('Failed to load news: ${data['message']}');
      }
    } else {
      throw Exception('Failed to load news: ${response.reasonPhrase}');
    }
  }

  void _filterArticles() {
    setState(() {
      _filteredNewsArticles = _newsArticles
          .where((article) => article['title']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  void _toggleBookmark(int index) {
    setState(() {
      _bookmarks[index] = !_bookmarks[index];
      if (_bookmarks[index]) {
        _bookmarkedArticles.add(_newsArticles[index]);
      } else {
        _bookmarkedArticles.removeWhere(
            (article) => article['title'] == _newsArticles[index]['title']);
      }
      _bookmarkBox.put(widget.username, _bookmarkedArticles);
    });
  }

  void _onBottomNavigationBarItemTapped(int index) {
    switch (index) {
      case 0:
        // Home
        break;
      case 1:
        // Money
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ConvertMoney()),
        );
        break;
      case 2:
        // Time
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ConvertTime()),
        );
        break;
      case 3:
        // Profile
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
      case 4:
        // Feedback
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FeedbackPage()),
        );
        break;
      case 5:
        // Logout
        _logout();
        break;
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('username');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _navigateToBookmarks() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookmarkPage(
          bookmarks: _bookmarkedArticles,
          removeBookmark: _removeBookmark,
        ),
      ),
    );
  }

  void _removeBookmark(dynamic article) {
    setState(() {
      int index = _newsArticles.indexOf(article);
      if (index != -1) {
        _bookmarks[index] = false;
        _bookmarkedArticles.remove(article);
        _bookmarkBox.put(widget.username, _bookmarkedArticles);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.username}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark, color: Colors.white),
            onPressed: _navigateToBookmarks,
          ),
        ],
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredNewsArticles.length,
                    itemBuilder: (context, index) {
                      final article = _filteredNewsArticles[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article['title'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                article['description'] ??
                                    'No description available',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    article['source']['name'],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      _bookmarks[index]
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () => _toggleBookmark(index),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.black), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.money, color: Colors.black), label: 'Money'),
          BottomNavigationBarItem(
              icon: Icon(Icons.access_time, color: Colors.black),
              label: 'Time'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.black), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.feedback, color: Colors.black),
              label: 'Feedback'),
          BottomNavigationBarItem(
              icon: Icon(Icons.logout, color: Colors.black), label: 'Logout'),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: _onBottomNavigationBarItemTapped,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
