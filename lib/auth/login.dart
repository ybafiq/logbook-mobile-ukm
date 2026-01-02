import 'package:flutter/material.dart';
import 'package:flutter_training/auth/home.dart';
import 'package:flutter_training/auth/register.dart';
import 'package:flutter_training/testing/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final String? prefilledEmail;
  final String? prefilledName;

  const LoginPage({super.key, this.prefilledEmail, this.prefilledName});

  @override
  State<LoginPage> createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _username = TextEditingController();

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

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;

    final name = widget.prefilledName ?? 'User';

    // ✅ Save user info to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', name);
    await prefs.setString('email', _email.text);

    // 🔑 Assign a simple mock user ID (for example, based on email)
    // In a real app, this should come from your auth or database system
    final generatedUserId = _email.text.hashCode.toString();
    await prefs.setString('userId', generatedUserId);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(username: name, email: _email.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Colors.deepOrange,
        elevation: 1,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(50),
        child: Column(
          children: [
            Image.asset(
              'lib/assets/fgv.png',
              height: 180,
              width: 180,
              fit: BoxFit.contain,
            ),
            Form(
              key: _form,
              child: Column(
                children: [
                  TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email, color: Colors.deepOrange),
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
                      prefixIcon: Icon(Icons.lock, color: Colors.deepOrange),
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
                        backgroundColor: Colors.deepOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 2,
                      ),
                      onPressed: _submit,
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
                        MaterialPageRoute(builder: (_) => const RegSkeleton()),
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
          ],
        ),
      ),
    );
  }
}
