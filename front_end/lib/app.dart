import 'package:flutter/material.dart';

import 'splash_screen.dart';
import 'onboarding_screen.dart';
import 'login.dart';
import 'register.dart';
class BantuIn extends StatefulWidget {
  const BantuIn({Key? key}) : super(key: key);

  @override
  _BantuInAppState createState() => _BantuInAppState();
}

class _BantuInAppState extends State<BantuIn> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bantu.In',
      theme: ThemeData(
        primaryColor: const Color(0xFFFECE2E), // Warna primer (kuning)
        secondaryHeaderColor: Colors.black, // Warna sekunder (hitam)
        scaffoldBackgroundColor: Colors.white, // Latar belakang putih
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'Poppins', fontSize: 96, fontWeight: FontWeight.bold, color: Colors.black),
          displayMedium: TextStyle(fontFamily: 'Poppins', fontSize: 60, fontWeight: FontWeight.bold, color: Colors.black),
          displaySmall: TextStyle(fontFamily: 'Poppins', fontSize: 48, fontWeight: FontWeight.normal, color: Colors.black),
          headlineMedium: TextStyle(fontFamily: 'Poppins', fontSize: 34, fontWeight: FontWeight.normal, color: Colors.black),
          headlineSmall: TextStyle(fontFamily: 'Poppins', fontSize: 24, fontWeight: FontWeight.normal, color: Colors.black),
          titleLarge: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.normal, color: Colors.black),
          titleMedium: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
          titleSmall: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black),
          bodyLarge: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
          bodyMedium: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black),
          labelLarge: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
          bodySmall: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black),
          labelSmall: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.normal, color: Colors.black),
        ),
      ),
      home: const SplashScreen(), // Tambahkan const di sini untuk meningkatkan performa
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}
