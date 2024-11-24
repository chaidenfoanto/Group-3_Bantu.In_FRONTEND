import 'package:flutter/material.dart';
import 'splash_screen.dart';

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
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Poppins',
              bodyColor: Colors.black,
              displayColor: Colors.black,
            ),
      ),
      home: const SplashScreen(),
    );
  }
}
