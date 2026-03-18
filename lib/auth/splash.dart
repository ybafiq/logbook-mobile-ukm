import 'package:flutter/material.dart';
import 'package:logbook_ukm/auth/login.dart';

class LoadingScreenState extends StatefulWidget {
  const LoadingScreenState({super.key});

  @override
  State<LoadingScreenState> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreenState> {
 @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      // Navigate to the next screen after the delay
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center (child: CircularProgressIndicator()));
  }
}


