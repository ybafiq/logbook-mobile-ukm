import 'package:flutter/material.dart';
import 'package:flutter_training/auth/login.dart';
import 'package:flutter_training/auth2/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegSkeleton2 extends StatefulWidget {
  const RegSkeleton2({super.key});

  @override
  State<RegSkeleton2> createState() => _RegisterPage2State2();
}

class _RegisterPage2State2 extends State<RegSkeleton2> {
  final _form = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _hidePass = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit2() async {
    if (!_form.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();

    final savedEmail = prefs.getString('email');
    if (savedEmail ==_email.text.trim()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Email already registered!')));
      return;
    }

    await prefs.setString('email', _email.text.trim());
    await prefs.setString('username', _username.text.trim());
    await prefs.setString('password', _password.text.trim());

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Registration Successful!')));

    final username = _username.text;
    final email = _email.text;

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
    // 🎨 UKM theme colors
    const Color ukmRed = Color(0xFFBE1E2D);
    const Color ukmYellow = Color(0xFFF7B500);
    const Color ukmBlue = Color(0xFF005DAA);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Register",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: false,
        backgroundColor: ukmRed, // UKM red
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // UKM logo
                Center(
                  child: Image.asset(
                    'lib/assets/ukm.png',
                    height: 120,
                    width: 120,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 30),

                // Title
                const Text(
                  "Create Your Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: ukmBlue, // UKM blue accent
                  ),
                ),

                const SizedBox(height: 30),

                // Username Field
                TextFormField(
                  controller: _username,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: const Icon(Icons.person, color: ukmBlue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: ukmBlue),
                    ),
                  ),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Please enter your username'
                      : null,
                ),

                const SizedBox(height: 20),

                // Email Field
                TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email, color: ukmBlue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: ukmBlue),
                    ),
                  ),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Please enter your email'
                      : null,
                ),

                const SizedBox(height: 20),

                // Password Field
                TextFormField(
                  controller: _password,
                  obscureText: _hidePass,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock, color: ukmBlue),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hidePass ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _hidePass = !_hidePass;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: ukmBlue),
                    ),
                  ),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Please enter your password'
                      : null,
                ),

                const SizedBox(height: 30),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ukmRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 3,
                    ),
                    onPressed: _submit2,
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Already have account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 15),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage2()),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: ukmBlue,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                // Footer
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey, width: 0.3),
                    ),
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
        ),
      ),
    );
  }
}
