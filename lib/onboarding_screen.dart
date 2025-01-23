import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

import 'package:front_end/login.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

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

  // Function utk ke login page
  Future<void> _navigateToLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFirstLaunch', false);
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
                  description:
                      'Craftsman will know where you are automatically',
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
              child: TextButton(
                onPressed: _navigateToLogin,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
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
    required this.image,
    required this.title,
    required this.description,
    this.buttonLabel,
    this.extraButton,
  });

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
                onPressed: () async {
                  try {
                    // Periksa apakah layanan lokasi aktif
                    bool isLocationServiceEnabled =
                        await Geolocator.isLocationServiceEnabled();
                    if (!isLocationServiceEnabled) {
                      // Jika layanan lokasi tidak aktif, minta pengguna menyalakannya
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Layanan lokasi tidak aktif. Harap nyalakan GPS."),
                          duration: Duration(seconds: 3),
                        ),
                      );

                      // Buka pengaturan lokasi
                      await Geolocator.openLocationSettings();
                      return;
                    }

                    // Periksa status izin lokasi
                    LocationPermission permission =
                        await Geolocator.checkPermission();
                    if (permission == LocationPermission.denied) {
                      permission = await Geolocator.requestPermission();
                      if (permission == LocationPermission.denied) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Izin lokasi diperlukan untuk melanjutkan."),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      }
                    }

                    if (permission == LocationPermission.deniedForever) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Izin lokasi ditolak permanen. Silakan atur di pengaturan."),
                          duration: Duration(seconds: 3),
                        ),
                      );
                      return;
                    }

                    // Mendapatkan lokasi pengguna
                    Position position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high,
                    );
                    print(
                        "Lokasi user: ${position.latitude}, ${position.longitude}");

                    // Simpan lokasi ke SharedPreferences
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setDouble('latitude', position.latitude);
                    await prefs.setDouble('longitude', position.longitude);

                    // Navigasi ke halaman login
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  } catch (e) {
                    // Tangani error jika ada
                    print("Error lokasi: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Gagal mendapatkan lokasi: $e"),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFECE2E),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
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
