import 'package:flutter/material.dart';

void main() {
  runApp(const MyListApp());
}

class MyListApp extends StatelessWidget {
  const MyListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List Demo',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('List Demo'),
        ),
        body: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: const Text('Afiq'),
              subtitle: const Text('Student'),
              trailing: const Icon(Icons.phone, color: Colors.green),
              onTap: () {
                // Handle tap
              },
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.red),
              title: const Text('Email'),
              subtitle: const Text('afiq@gmail.com'),
              trailing: const Icon(Icons.send, color: Colors.orange),
              onTap: () {
                // Handle tap
              },
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.map, color: Colors.blue),
              title: const Text('Map'),
              subtitle: const Text('Subtitle for Map'),
              trailing: const Icon(Icons.directions_walk, color: Colors.orange),
              onTap: () {
                // Handle tap
              },
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.photo_album, color: Colors.red),
              title: const Text('Album'),
              subtitle: const Text('Subtitle for Album'),
              trailing: const Icon(Icons.send, color: Colors.orange),
              onTap: () {
                // Handle tap
              },
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.blue),
              title: const Text('Phone'),
              subtitle: const Text('Subtitle for Phone'),
              trailing: const Icon(Icons.send, color: Colors.orange),
              onTap: () {
                // Handle tap
              },
            ),
          ],
        ),
      ),
    );
  }
}