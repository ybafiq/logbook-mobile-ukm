import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_training/screen/daily/daily_screen.dart';
import 'package:flutter_training/auth2/login_auth.dart';
import 'package:flutter_training/auth2/news.dart';
import 'package:flutter_training/screen/project/project_screen.dart';
import 'package:flutter_training/screen/profile_screen.dart';

class HomePage2 extends StatefulWidget {
  final String username;
  final String? email;

  const HomePage2({super.key, required this.username, required this.email, required String userId});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LoginPage2(),
      ),
    );
  }
  
  void _navigateToProfile(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => const UserProfilePage(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color ukmRed = Color(0xFFBE1E2D);
    const Color ukmYellow = Color(0xFFF7B500);
    const Color ukmBlue = Color(0xFF005DAA);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Home Page',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: ukmRed,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: Column(
          children: [
            // 🌿 Animated Logo (clickable)
            GestureDetector(
              onTapDown: (_) => setState(() => _scale = 0.9),
              onTapUp: (_) {
                setState(() => _scale = 1.0);
                Future.delayed(const Duration(milliseconds: 100), () {
                  _navigateToProfile(context);
                });
              },
              onTapCancel: () => setState(() => _scale = 1.0),
              child: AnimatedScale(
                scale: _scale,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      'lib/assets/leaf.svg',
                      width: 160,
                      placeholderBuilder: (_) =>
                          const CircularProgressIndicator(),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: ukmBlue,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: ukmBlue.withOpacity(0.4),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 👋 Welcome Section
            Text(
              "Welcome,\n${widget.username}!",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: ukmBlue,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Select an option to get started 🌟",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 40),

            // 🌟 Action Buttons
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                _buildHomeButton(
                  context,
                  label: "Daily Logbook",
                  icon: Icons.book,
                  color: ukmRed,
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LogbookPage()),
                  ),
                ),
                _buildHomeButton(
                  context,
                  label: "Project Logbook",
                  icon: Icons.assignment,
                  color: ukmBlue,
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProjectLogbookPage(),
                    ),
                  ),
                ),
                _buildHomeButton(
                  context,
                  label: "Project Logbook",
                  icon: Icons.assignment,
                  color: ukmBlue,
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProjectLogbookPage(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // 📜 Footer
            const Text(
              "© 2025 UKM Logbook App. All rights reserved.",
              style: TextStyle(fontSize: 12, color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 160,
      height: 120,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 40),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
