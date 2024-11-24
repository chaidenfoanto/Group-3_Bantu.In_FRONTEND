import 'package:flutter/material.dart';
import 'package:front_end/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _navigateToLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: _nextPage, // Fitur tap layar untuk pindah halaman
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                const _OnboardingItem(
                  image: 'assets/animations/tracking.json',
                  title: 'Tracking Realtime',
                  description: 'Craftsman will know where you are automatically',
                ),
                const _OnboardingItem(
                  image: 'assets/animations/order-anywhere.json',
                  title: 'Order from anywhere',
                  description:
                      'Suggests flexibility and convenience, allowing users to make purchases or book services seamlessly',
                ),
                _OnboardingItem(
                  image: 'assets/animations/enable-location.json',
                  title: 'Enable Your Location',
                  description:
                      'Choose your location to start finding the request around you',
                  buttonLabel: 'Use My Location',
                  extraButton: ElevatedButton(
                    onPressed: () {
                      _navigateToLogin();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50), // Sesuai mockup
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      child: Text(
                        'Skip for now',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Tombol Skip (tidak muncul di halaman ketiga)
          if (_currentPage < 2)
            Positioned(
              bottom: 90,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: _navigateToLogin,
                child: Center(
                  child: Text(
                    'Skip',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ),
          // Indikator halaman (dots)
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Colors.amber
                        : const Color(0xFFE0E0E0),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingItem extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String? buttonLabel;
  final Widget? extraButton; // Tambahan untuk tombol ekstra di halaman tertentu

  const _OnboardingItem({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
    this.buttonLabel,
    this.extraButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 300, // Tinggi tetap untuk image
            child: Lottie.asset(image),
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 50, // Tinggi tetap untuk title
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 60, // Tinggi tetap untuk description
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
          if (buttonLabel != null)
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: ElevatedButton(
                onPressed: () {
                  // Handle button action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50), // Sesuai mockup
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 20),
                  child: Text(
                    buttonLabel!,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          if (extraButton != null) ...[
            const SizedBox(height: 15), // Jarak antara tombol tambahan
            extraButton!,
          ]
        ],
      ),
    );
  }
}
