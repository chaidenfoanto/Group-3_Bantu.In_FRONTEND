import 'package:flutter/material.dart';
import 'package:front_end/booking.dart';
import 'package:front_end/widgets/navbar.dart' as navbar;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardScreen> {
  late YoutubePlayerController _youtubeController;
  String userName = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _youtubeController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
        'https://www.youtube.com/embed/swaHYDu84mc?si=65IwETTpcY9gkWMk',
      )!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: true,
      ),
    );
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      
      if (token == null) {
        // Handle case when token is not found
        Navigator.of(context).pushReplacementNamed('/login');
        return;
      }

      final response = await http.get(
        Uri.parse('http://192.168.205.50:8000/api/user-dashboard'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userName = data['name'];
          isLoading = false;
        });
      } else if (response.statusCode == 401) {
        // Token is invalid or expired
        await prefs.remove('access_token');
        Navigator.of(context).pushReplacementNamed('/login');
      } else {
        setState(() {
          userName = 'User';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        userName = 'User';
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch user data')),
      );
    }
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return navbar.BottomNavBar(
      currentIndex: 0,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header dengan Gradient dan Ilustrasi
            Stack(
              children: [
                Container(
                  height: 220,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFEE8A3), Color(0xFFFFF8E1)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 10,
                  child: Image.asset(
                    'assets/images/home-illustration.png',
                    width: 210,
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: _buildHeader(context),
                ),
              ],
            ),
            // Konten Utama
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, -4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildCarouselContainer(),
                    const SizedBox(height: 20),
                    _buildAcSelection(context),
                    const SizedBox(height: 20),
                    _buildLearnMoreSection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset('assets/images/logo.png', width: 40),
            const SizedBox(width: 8),
            Text(
              'Bantu.In',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 115),
        Text(
          'Welcome,',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.black54),
        ),
        isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : Text(
                userName + '!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
      ],
    );
  }

  Widget _buildAcSelection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose your AC type!',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildAcOption(
                context, 'AC Split Wall', 'assets/icons/ac_split_wall.png'),
            _buildAcOption(
                context, 'AC Central', 'assets/icons/ac_central.png'),
            _buildAcOption(
                context, 'AC Standing', 'assets/icons/ac_standing.png'),
            _buildAcOption(context, 'Smart AC', 'assets/icons/smart_ac.png'),
            _buildAcOption(context, 'AC Window', 'assets/icons/ac_window.png'),
            _buildAcOption(
                context, 'AC Inverter', 'assets/icons/ac_inverter.png'),
            _buildAcOption(context, 'AC VRV', 'assets/icons/ac_vrv.png'),
            _buildAcOption(context, 'AC Duct', 'assets/icons/ac_duct.png'),
          ],
        ),
      ],
    );
  }

  Widget _buildAcOption(BuildContext context, String label, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BookingScreen(),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 0),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(imagePath),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselContainer() {
    final List<String> imgList = [
      'assets/images/Carousel-1.png',
      'assets/images/Carousel-2.png',
    ];

    return SizedBox(
      height: 150,
      child: CarouselSlider(
        options: CarouselOptions(
          height: 150,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          enlargeCenterPage: true,
          aspectRatio: 2.0,
          viewportFraction: 1.0,
        ),
        items: imgList
            .map((item) => ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    item,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildLearnMoreSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Learn something fun!',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
        YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _youtubeController,
            showVideoProgressIndicator: true,
          ),
          builder: (context, player) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: player,
              ),
            );
          },
        ),
      ],
    );
  }
}