import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:logbook_ukm/auth2/login_auth.dart';

class LoadingScreenState2 extends StatefulWidget {
  const LoadingScreenState2({super.key});

  @override
  State<LoadingScreenState2> createState() => _LoadingScreenState2();
}

class _LoadingScreenState2 extends State<LoadingScreenState2> {
  @override
  Widget build(BuildContext context) {
    const Color ukmRed = Color(0xFFBE1E2D);
    const Color ukmBlue = Color(0xFF005DAA);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Full-screen Lottie animation
          Positioned.fill(
            child: Lottie.asset(
              'lib/assets/rainbow.json', // Change to your Lottie file path
              fit: BoxFit.cover,
              repeat: true,
            ),
          ),

          //Centered overlay content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Welcome to UKM Logbook System',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ukmBlue,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage2()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ukmRed,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 32,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      "Go to Sign In",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

