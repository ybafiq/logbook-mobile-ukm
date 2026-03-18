import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:logbook_ukm/screen/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // ✅ Added

class PublicApi extends StatefulWidget {
  const PublicApi({super.key});

  @override
  State<PublicApi> createState() => _PublicApiState();
}

class _PublicApiState extends State<PublicApi> {
  List articles = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    final url =
        'your url';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        articles = data['articles'];
        loading = false;
      });
    } else {
      setState(() {
        articles = [];
        loading = false;
      });
    }
  }

  // ✅ Added function to go back to Home with saved user info
  Future<void> _goToHomePage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username') ?? 'User';
    final savedEmail = prefs.getString('email') ?? 'user@example.com';

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage2(username: savedUsername, email: savedEmail, userId: '',),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color ukmRed = Color(0xFFBE1E2D);
    const Color ukmBlue = Color(0xFF005DAA);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Latest News",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        backgroundColor: ukmRed,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: _goToHomePage, // ✅ Fixed navigation
            icon: const Icon(Icons.home),
            tooltip: 'Go to Home Page',
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: ukmRed))
          : articles.isEmpty
          ? const Center(
              child: Text(
                "No news available right now.",
                style: TextStyle(
                  color: ukmBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final news = articles[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            news['title'] ?? 'No Title',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ukmBlue,
                            ),
                          ),
                          content: Text(
                            news['content'] ?? 'No Content Available',
                            style: const TextStyle(fontSize: 15),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text(
                                'Close',
                                style: TextStyle(color: ukmRed),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (news['urlToImage'] != null)
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.network(
                              news['urlToImage'],
                              width: double.infinity,
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                news['title'] ?? 'No Title',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: ukmBlue,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                news['description'] ?? 'No Description',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                            news['title'] ?? 'No Title',
                                          ),
                                          content: Text(
                                            news['content'] ?? 'No Content',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: const Text('Close'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.open_in_new,
                                      color: ukmRed,
                                      size: 18,
                                    ),
                                    label: const Text(
                                      "Read More",
                                      style: TextStyle(color: ukmRed),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

