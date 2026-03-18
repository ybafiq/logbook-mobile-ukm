import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logbook_ukm/auth/login.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatelessWidget {
  
  
  final String username;
  final String? email;

  const HomePage({super.key, required this.username, required this.email});

  void logout(BuildContext context) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => LoginPage(prefilledEmail: email, prefilledName: username)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home Page',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SvgPicture.asset(
            //   'lib/assets/leaf.svg',
            //   width: 200,
            //   semanticsLabel: 'Leaf SVG',
            //   placeholderBuilder: (_) => const SizedBox(
            //     width: 200,
            //     height: 200,
            //     child: CircularProgressIndicator(),
            //   ),
            // ),
            Lottie.asset(
              'lib/assets/rainbow.json',
              width: 200,
              height: 200,
              repeat: true,
            ),
            const SizedBox(height: 20),
            Text(
              "Welcome, $username",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 


