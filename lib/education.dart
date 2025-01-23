import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:front_end/widgets/navbar.dart' as navbar;

class EducationScreen extends StatefulWidget {
  const EducationScreen({Key? key}) : super(key: key);

  @override
  State<EducationScreen> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationScreen> {
  bool showVideos = true;

  final List<Map<String, String>> videos = [
    {
      'title':
          'Cara memperbaiki AC outdoor suara buyinya keras kasar berisik dan ribut',
      'videoId': 'swaHYDu84mc',
    },
    {
      'title':
          'Jangan sampai salah pilih tukang! Berikut merupakan panduan untuk memesan tukang melalui Bantun!',
      'videoId': 'e9vrfEoc8_g',
    },
    {
      'title': 'Masalah Umum pada AC: Penyebab dan Cara Mengatasinya!',
      'videoId': 'tgbNymZ7vqY',
    },
  ];

  final List<Map<String, dynamic>> facts = [
    {
      'title': 'Apa penyebab Freon pada AC habis?',
      'details': [
        'Kebocoran pada Sistem AC: Kebocoran pada pipa atau sambungan freon sering menjadi penyebab utama. Kebocoran ini dapat terjadi akibat korosi, retakan, atau sambungan yang longgar.',
        'Kerusakan pada Komponen Sistem: Seal atau gasket yang rusak atau evaporator dan kondensor bocor dapat menyebabkan freon habis.',
        'Instalasi yang Tidak Tepat: Pemasangan AC yang tidak benar, seperti sambungan pipa yang tidak rapat.',
        'Penggunaan yang Berlebihan atau Tidak Sesuai: Pemakaian AC dalam waktu lama tanpa perawatan bisa meningkatkan tekanan pada sistem.',
        'Kurangnya Perawatan Rutin: Tidak melakukan servis AC secara berkala dapat menyebabkan kerusakan kecil yang tidak terdeteksi.',
      ],
      'isExpanded': false,
    },
    // {
    //   'title': 'Mengapa AC Anda cepat kotor?',
    //   'details': [
    //     'Filter udara yang jarang dibersihkan.',
    //     'Lingkungan sekitar yang berdebu.',
    //     'Kurangnya perawatan rutin pada AC.'
    //   ],
    //   'isExpanded': false,
    // },
    {
      'title': 'Pentingnya Membersihkan Filter Udara pada AC',
      'details': [
        'Filter udara yang kotor dapat menghambat aliran udara dan menurunkan efisiensi pendinginan.',
        'Filter yang bersih membantu menjaga kualitas udara dalam ruangan.',
        'Disarankan untuk membersihkan filter udara setiap 1-2 bulan.',
      ],
      'isExpanded': false,
    },
    {
      'title': 'Tanda-tanda AC Perlu Diisi Ulang Freon',
      'details': [
        'AC tidak lagi dingin seperti biasanya.',
        'Terjadi pembekuan pada pipa refrigeran.',
        'Outdoor unit mengeluarkan suara aneh.',
        'Tekanan freon yang rendah saat diperiksa oleh teknisi.',
      ],
      'isExpanded': false,
    },
    {
      'title': 'Efek Penggunaan AC yang Berlebihan',
      'details': [
        'Meningkatkan konsumsi listrik secara signifikan.',
        'Komponen AC, seperti kompresor, bisa cepat rusak.',
        'Memerlukan perawatan lebih sering karena penggunaan terus-menerus.',
      ],
      'isExpanded': false,
    },
    {
      'title': 'Tips Menghemat Listrik saat Menggunakan AC',
      'details': [
        'Gunakan mode hemat energi (eco mode) jika tersedia.',
        'Atur suhu AC pada 24-26°C untuk efisiensi maksimal.',
        'Gunakan timer untuk mematikan AC saat tidak digunakan.',
        'Pastikan ruangan tertutup rapat agar udara dingin tidak keluar.',
      ],
      'isExpanded': false,
    },
    {
      'title': 'Cara Merawat Outdoor Unit pada AC',
      'details': [
        'Bersihkan debu dan kotoran yang menempel pada outdoor unit setiap 3 bulan.',
        'Pastikan area di sekitar outdoor unit bebas dari penghalang seperti tanaman atau benda lainnya.',
        'Periksa kipas dan pastikan tidak ada kerusakan.',
      ],
      'isExpanded': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return navbar.BottomNavBar(
      currentIndex: 2, // Education tab index
      child: Scaffold(
        body: Column(
          // Perbaikan di sini
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Education',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                      height: 8), // Jarak antara teks "Education" dan Divider
                  const Divider(
                    thickness: 1,
                    color: Colors.black38,
                  ), // Tambahkan jarak antara Divider dan tab
                ],
              ),
            ),
            // Konten utama
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => showVideos = true),
                            child: TabButton(
                                label: 'Videos', isSelected: showVideos),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => showVideos = false),
                            child: TabButton(
                                label: 'Facts', isSelected: !showVideos),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: showVideos ? _buildVideosTab() : _buildFactsTab(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideosTab() {
    return ListView.builder(
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return VideoCard(
          title: video['title']!,
          videoId: video['videoId']!,
        );
      },
    );
  }

  Widget _buildFactsTab() {
    return ListView.builder(
      itemCount: facts.length,
      itemBuilder: (context, index) {
        final fact = facts[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  fact['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                trailing: Icon(
                  fact['isExpanded']
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey[600],
                ),
                onTap: () {
                  setState(() {
                    fact['isExpanded'] = !fact['isExpanded'];
                  });
                },
              ),
              if (fact['isExpanded'])
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: fact['details']
                        .map<Widget>(
                          (detail) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              detail,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black87),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;

  const TabButton({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFECE2E) : Colors.grey[300],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class VideoCard extends StatelessWidget {
  final String title;
  final String videoId;

  const VideoCard({required this.title, required this.videoId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(videoId: videoId),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Container untuk menampung gambar dan ikon play
            Container(
              height: 180, // Atur tinggi sesuai kebutuhan
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  // Gambar thumbnail YouTube
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      'https://img.youtube.com/vi/$videoId/0.jpg',
                      fit: BoxFit.cover, // Menyesuaikan gambar dengan container
                      width: double.infinity, // Lebar menyesuaikan container
                      height: 180, // Tinggi sesuai container
                    ),
                  ),
                  // Ikon play di tengah gambar
                  Positioned.fill(
                    child: Center(
                      child: Icon(
                        Icons.play_circle_outline,
                        size: 64,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Container untuk teks judul
            Container(
              color: Colors.grey[800],
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerScreen extends StatelessWidget {
  final String videoId;

  const VideoPlayerScreen({required this.videoId});

  @override
  Widget build(BuildContext context) {
    final YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Video Player',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
      ),
    );
  }
}
