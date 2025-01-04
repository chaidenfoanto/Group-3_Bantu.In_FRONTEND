import 'package:flutter/material.dart';
import 'package:front_end/dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false; 

  void _login() {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email and Password cannot be empty')),
      );
      return;
    }

    if (email == 'user@example.com' && password == 'password') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your email or password is incorrect.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Nama Aplikasi
              const Text(
                'Bantu.in',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),
              // Gambar
              Image.asset(
                'assets/images/login-image.png',
                height: 250,
              ),
              const SizedBox(height: 30),
              // Email
              SizedBox(
                height: 60,
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email, color: Colors.black),
                    labelText: 'E-mail',
                    labelStyle: const TextStyle(fontSize: 15),
                          floatingLabelStyle: TextStyle(color:Colors.yellow.shade600),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Colors.transparent),  
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Password
              SizedBox(
                height: 60,
                child: TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible, 
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock, color: Colors.black),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    labelText: 'Password',
                    labelStyle: const TextStyle(fontSize: 15),
                          floatingLabelStyle: TextStyle(color:Colors.yellow.shade600),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Colors.transparent),  
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Tombol Login
              SizedBox(
                width: 220,
                height: 50,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    shadowColor: Colors.grey.shade300.withOpacity(0.7),
                    elevation: 4,
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Tombol Sign Up
              SizedBox(
                width: 220,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/register');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow.shade600,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    shadowColor: Colors.yellow.shade600.withOpacity(0.5),
                    elevation: 4,
                  ),
                  child: const Text(
                    'Create an Account',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Forgot Password
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/forgot-password');
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
