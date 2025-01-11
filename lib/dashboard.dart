import 'package:flutter/material.dart';
import 'package:front_end/widgets/navbar.dart' as navbar;
import 'package:url_launcher/url_launcher.dart'; 

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
                    _buildEducationContainer(),
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
          'Choose Your AC Type!',
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
            _buildAcOption(context, 'AC Split Wall', Icons.ac_unit),
            _buildAcOption(context, 'AC Central', Icons.home_work_outlined),
            _buildAcOption(context, 'AC Standing', Icons.airplay),
            _buildAcOption(context, 'Smart AC', Icons.smartphone),
            _buildAcOption(context, 'AC Window', Icons.window),
            _buildAcOption(context, 'AC / DC', Icons.bolt),
            _buildAcOption(context, 'AC VRV', Icons.hvac),
            _buildAcOption(context, 'AC Duct', Icons.layers),
          ],
        ),
      ],
    );
  }

  Widget _buildEducationContainer() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade300,
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
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAcOption(BuildContext context, String label, IconData icon) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.amber),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
