import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_training/auth2/login.dart';
import 'package:flutter_training/auth2/home.dart';
import 'package:lottie/lottie.dart';

class HomePage2 extends StatelessWidget {
  final String username;
  final String? email;

  const HomePage2({super.key, required this.username, required this.email});

  void logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            LoginPage2(prefilledEmail: email, prefilledName: username),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //UKM theme colors
    const Color ukmRed = Color(0xFFBE1E2D);
    const Color ukmYellow = Color(0xFFF7B500);
    const Color ukmBlue = Color(0xFF005DAA);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home Page',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: ukmRed, // UKM red
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'lib/assets/leaf.svg',
              width: 200,
              semanticsLabel: 'Leaf SVG',
              placeholderBuilder: (_) => const SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(),
              ),
            ),

            // //Lottie animation (rainbow)
            // Lottie.asset(
            //   'lib/assets/rainbow.json',
            //   width: 200,
            //   height: 200,
            //   repeat: true,
            // ),
            const SizedBox(height: 20),

            //  Welcome text
            Text(
              "Welcome, $username",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ukmBlue, // UKM blue accent
              ),
            ),

            const SizedBox(height: 10),

            // 📧 Email (optional)
            // if (email != null)
            //   Text(
            //     "$email",
            //     style: const TextStyle(
            //       fontSize: 16,
            //       color: ukmYellow, // UKM yellow for secondary text
            //     ),
            //   ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
