import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Bagian atas dengan gradient dan ilustrasi
          Column(
            children: [
              Container(
                height: 280, // Tinggi area header
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFEE8A3), Color(0xFFFFF8E1)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
          // Ilustrasi
          Positioned(
            right: 0,
            top: 20, // Posisi ilustrasi
            child: Image.asset(
              'assets/images/home-illustration.png', // Path gambar ilustrasi Anda
              width: 240,
            ),
          ),
          // Konten utama
          Positioned.fill(
            top: 200, // Tinggi awal container putih agar menutupi bagian bawah
            child: Container(
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20), // Jarak awal dari atas
                      // Kontainer pertama
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.shade300,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Pilihan AC
                      Text(
                        'Pilih jenis AC anda!',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
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
                              context, 'AC Split Wall', Icons.ac_unit),
                          _buildAcOption(
                              context, 'AC Central', Icons.home_work_outlined),
                          _buildAcOption(context, 'AC Standing', Icons.airplay),
                          _buildAcOption(context, 'Smart AC', Icons.smartphone),
                          _buildAcOption(context, 'AC Window', Icons.window),
                          _buildAcOption(context, 'AC / DC', Icons.bolt),
                          _buildAcOption(context, 'AC VRV', Icons.hvac),
                          _buildAcOption(context, 'AC Duct', Icons.layers),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Kontainer terakhir
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Belajar dikit yuk!',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
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
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.shade300,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Teks sapaan dan logo (posisi di atas)
          Positioned(
            top: 16, // Posisi dari atas
            left: 16, // Posisi dari kiri
            right: 16, // Posisi dari kanan
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/logo.png', // Path logo Anda
                      width: 40,
                    ),
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
                const SizedBox(height: 90),
                Text(
                  'Welcome,',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
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
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.yellow.shade600,
        unselectedItemColor: Colors.black87,
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Education'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
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
