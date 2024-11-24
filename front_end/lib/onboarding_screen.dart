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
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 600;

    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (_currentPage < 2) {
                _nextPage();
              }
            },
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
                  buttonLabel: 'USE MY LOCATION', 
                  extraButton: GestureDetector(
                    onTap: _navigateToLogin,
                    child: Text(
                      'Skip For Now',
                      style: GoogleFonts.poppins(
                        fontSize: isSmallScreen ? 13 : 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_currentPage < 2)
            Positioned(
              bottom: isSmallScreen ? 110 : 130,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: _navigateToLogin,
                child: Center(
                  child: Text(
                    'Skip',
                    style: GoogleFonts.poppins(
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: isSmallScreen ? 80 : 90,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isSmallScreen ? 10 : 12,
                  height: isSmallScreen ? 10 : 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? const Color(0xFFFECE2E)
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
  final Widget? extraButton;

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
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 600;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 36.0 : 40.0,
        vertical: isSmallScreen ? 50 : 70,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          SizedBox(
            height: isSmallScreen ? 200 : 300,
            child: Lottie.asset(image),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: isSmallScreen ? 20 : 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: isSmallScreen ? 13 : 15,
              color: Colors.grey[600],
            ),
          ),
          if (buttonLabel != null)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () {
                  // Kalau mau tmbh action pas di pencet use my location
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFECE2E),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 18),
                  child: Text(
                    buttonLabel!,
                    style: GoogleFonts.poppins(
                      fontSize: isSmallScreen ? 15 : 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          if (extraButton != null) ...[
            const SizedBox(height: 15),
            extraButton!,
          ]
        ],
      ),
    );
  }
}
