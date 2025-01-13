import 'package:flutter/material.dart';
import 'package:front_end/booking.dart';
import 'package:front_end/widgets/navbar.dart' as navbar;
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardScreen> {
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
        Text(
          'chaidenfoanto!',
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
        const SizedBox(height: 12),
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
            _buildAcOption(context, 'AC Inverter', 'assets/icons/ac_inverter.png'),
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
              color: Colors.white, // Warna background putih sesuai desain Figma
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0), // Padding untuk gambar
              child: Image.asset(imagePath), // Menampilkan gambar kustom
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
        GestureDetector(
          onTap: () async {
            const youtubeUrl = 'https://www.youtube.com/watch?v=swaHYDu84mc';
            if (await canLaunchUrl(Uri.parse(youtubeUrl))) {
              await launchUrl(Uri.parse(youtubeUrl),
                  mode: LaunchMode.externalApplication);
            } else {
              throw 'Unable to open the video';
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/thumbnail-edukasi.png',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 50,
                width: 50,
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
