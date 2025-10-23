import 'package:flutter/material.dart';
import 'package:flutter_training/auth2/forgot.dart';
import 'package:flutter_training/auth2/home.dart';
import 'package:flutter_training/auth2/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage2 extends StatefulWidget {
  final String? prefilledEmail;
  final String? prefilledName;

  const LoginPage2({super.key, this.prefilledEmail, this.prefilledName});

  @override
  State<LoginPage2> createState() => LoadingScreenState2();
}

class LoadingScreenState2 extends State<LoginPage2> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _username = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _email.text = widget.prefilledEmail ?? '';
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit2() async {
    if (!_form.currentState!.validate()) return;

    final name = widget.prefilledName ?? 'User';

    setState(() => _loading= true);

    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');
    final savedUsername = prefs.getString('username');

    await Future.delayed(const Duration(seconds: 1));

    if (_email.text.trim() == savedEmail && _password.text.trim() == savedPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login Successful!')));
    }
    else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid email or password!')));
      setState(() => _loading= false);
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage2(username: savedUsername.toString(), email: savedEmail.toString()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // UKM theme colors
    const Color ukmRed = Color(0xFFBE1E2D);
    const Color ukmYellow = Color(0xFFF7B500);
    const Color ukmBlue = Color(0xFF005DAA);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: ukmRed, // UKM red color
        elevation: 1,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(50),
        child: Column(
          children: [
            Image.asset(
              'lib/assets/ukm.png',
              height: 180,
              width: 180,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 30),

            Form(
              key: _form,
              child: Column(
                children: [
                  TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email, color: ukmBlue),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Enter a valid email'
                        : null,
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _password,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock, color: ukmBlue),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'password' : null,
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ukmRed,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 2,
                      ),
                      onPressed: _submit2,
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                      );
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegSkeleton2()),
                      );
                    },
                    child: const Text(
                      "New User? Sign Up",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),

            // Footer section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey, width: 0.3)),
              ),
              child: Column(
                children: const [
                  Text(
                    "Universiti Kebangsaan Malaysia",
                    style: TextStyle(
                      color: ukmRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "© 2025 UKM Logbook System",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
