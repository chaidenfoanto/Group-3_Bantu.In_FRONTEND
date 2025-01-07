import 'package:flutter/material.dart';

class TermsConditionsDialog extends StatelessWidget {
  const TermsConditionsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Terms & Conditions',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.transparent),
                    ),
                    child: Scrollbar(
                      controller: scrollController, // ScrollController
                      thumbVisibility: true, // spy scrollnya terlihat
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyMedium,
                            children: [
                              TextSpan(
                                text: 'Terms & Conditions - Pengguna\n\n',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: 'Definisi\n',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const TextSpan(
                                text:
                                    'Pengguna: Individu yang menggunakan aplikasi Bantu.In untuk memesan layanan dari Tukang.\n'
                                    'Tukang: Penyedia jasa yang terdaftar di aplikasi Bantu.In.\n'
                                    'Layanan: Jasa yang ditawarkan oleh Tukang, termasuk tetapi tidak terbatas pada layanan perbaikan, perawatan, atau instalasi.\n\n',
                              ),
                              TextSpan(
                                text: 'Persyaratan Penggunaan\n',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const TextSpan(
                                text:
                                    '1. Pengguna wajib memberikan data yang valid, termasuk nama lengkap, nomor telepon aktif, dan alamat yang jelas.\n'
                                    '2. Pengguna bertanggung jawab atas keakuratan informasi pesanan, termasuk deskripsi layanan dan detail alamat.\n'
                                    '3. Pengguna harus berusia minimal 18 tahun atau memiliki izin dari orang tua/wali jika di bawah umur.\n'
                                    '4. Pengguna tidak diperbolehkan menggunakan layanan untuk aktivitas ilegal, tidak etis, atau melanggar hukum.\n\n',
                              ),
                              TextSpan(
                                text: 'Kebijakan Pemesanan\n',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const TextSpan(
                                text:
                                    '1. Pemesanan hanya dapat dilakukan melalui aplikasi resmi Bantu.In.\n'
                                    '2. Pengguna bertanggung jawab atas keakuratan informasi pesanan, termasuk deskripsi layanan dan detail alamat.\n'
                                    '3. Pengguna bertanggung jawab atas pembayaran penuh sesuai tarif yang tertera di aplikasi.\n'
                                    '4. Pembatalan tidak diperbolehkan jika Tukang telah tiba di lokasi pengguna, kecuali terdapat alasan mendesak yang dapat diterima oleh pihak Bantu.In (contoh: keadaan darurat).\n'
                                    '5. Pengguna wajib memberikan akses ke lokasi sesuai dengan alamat yang telah dicantumkan.\n\n',
                              ),
                              TextSpan(
                                text: 'Kebijakan Rating & Review\n',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const TextSpan(
                                text:
                                    '1. Pengguna dapat memberikan rating dan ulasan secara jujur setelah layanan selesai.\n'
                                    '2. Ulasan tidak boleh mengandung unsur penghinaan, SARA, atau konten yang tidak relevan.\n'
                                    '3. Bantu.In berhak menghapus ulasan yang dianggap melanggar aturan tanpa pemberitahuan sebelumnya.\n\n',
                              ),
                              TextSpan(
                                text: 'Kewajiban dan Tanggung Jawab\n',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const TextSpan(
                                text:
                                    '1. Pengguna bertanggung jawab atas keamanan barang dan properti pribadi selama layanan berlangsung.\n'
                                    '2. Kerugian atau kerusakan yang terjadi akibat kelalaian pengguna tidak menjadi tanggung jawab Bantu.In atau Tukang.\n'
                                    '3. Pengguna wajib menjaga etika selama berinteraksi dengan Tukang.\n',
                              ),
                              const WidgetSpan(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child:
                                      Divider(color: Colors.grey, thickness: 1),
                                ),
                              ),
                              TextSpan(
                                text: 'Terms & Conditions - Tukang\n\n',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: 'Definisi\n',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const TextSpan(
                                  text:
                                      'Tukang: Penyedia jasa yang telah diverifikasi dan terdaftar di aplikasi Bantu.In.\n'
                                      'Pengguna: Individu yang menggunakan aplikasi Bantu.In untuk memesan layanan Tukang.\n'),
                              TextSpan(
                                text: 'Persyaratan Pendaftaran\n',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const TextSpan(
                                text:
                                    '1. Tukang wajib memberikan data yang valid, termasuk KTP, nomor telepon aktif, dan spesialisasi layanan.\n'
                                    '2. Tukang hanya dapat menerima pesanan yang sesuai dengan spesialisasi yang telah terverifikasi di aplikasi.\n'
                                    '3. Tukang wajib mematuhi semua aturan hukum dan regulasi yang berlaku dalam pelaksanaan layanan.\n\n',
                              ),
                              TextSpan(
                                text: 'Kebijakan Penerimaan Pesanan\n',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const TextSpan(
                                text:
                                    '1. Tukang memiliki hak untuk menerima atau menolak pesanan. Penolakan pesanan harus disertai alasan yang jelas.\n'
                                    '2. Jika Tukang menerima pesanan, maka wajib menyelesaikan layanan sesuai dengan deskripsi pesanan dan waktu yang telah disepakati.\n'
                                    '3. Ketidakhadiran Tukang tanpa pemberitahuan akan dikenakan penalti berupa suspensi akun sementara atau permanen.\n\n',
                              ),
                              TextSpan(
                                text: 'Kebijakan Rating Pengguna\n',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const TextSpan(
                                text:
                                    '1. Tukang dapat memberikan rating terhadap Pengguna setelah layanan selesai.\n'
                                    '2. Rating hanya berupa angka (1-5) dan tidak disertai ulasan.\n'
                                    '3. Tukang tidak diperbolehkan menyalahgunakan fitur rating untuk kepentingan pribadi atau merugikan pengguna.\n\n',
                              ),
                              TextSpan(
                                text: 'Kewajiban dan Tanggung Jawab\n',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const TextSpan(
                                text:
                                    '1. Tukang wajib menjaga profesionalisme dan etika selama memberikan layanan.\n'
                                    '2. Kerusakan atau kerugian yang terjadi akibat kelalaian Tukang menjadi tanggung jawab Tukang sepenuhnya.\n'
                                    '3. Tukang tidak diperbolehkan menerima pembayaran di luar sistem pembayaran aplikasi.\n\n',
                              ),
                              TextSpan(
                                text: 'Kebijakan History Pesanan\n',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const TextSpan(
                                  text:
                                      '1. Semua riwayat pesanan akan dicatat di aplikasi untuk referensi Tukang.\n'
                                      '2. Tukang tidak diperbolehkan membagikan informasi pengguna yang tercatat di riwayat pesanan kepada pihak ketiga tanpa izin.\n'),
                              const WidgetSpan(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child:
                                      Divider(color: Colors.grey, thickness: 1),
                                ),
                              ),
                              TextSpan(
                                text:
                                    'Ketentuan Umum (Berlaku untuk Pengguna dan Tukang)\n\n',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text:
                                    '1. Bantu.In hanya berperan sebagai platform penghubung antara Pengguna dan Tukang. Bantu.In tidak bertanggung jawab atas tindakan ilegal atau pelanggaran hukum yang dilakukan oleh Pengguna atau Tukang.\n'
                                    '2. Bantu.In berhak melakukan peninjauan ulang terhadap akun yang dianggap melanggar aturan, termasuk penangguhan atau penghapusan akun.\n'
                                    '3. Perubahan terhadap Terms & Conditions ini dapat dilakukan sewaktu-waktu tanpa pemberitahuan sebelumnya.\n',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Decline',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Accept',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
