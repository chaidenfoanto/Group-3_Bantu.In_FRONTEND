import 'package:flutter/material.dart';

class TermsConditionsDialog extends StatelessWidget {
  const TermsConditionsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        // Menggunakan warna putih dari ThemeData
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8, // 80% dari lebar layar
          height: MediaQuery.of(context).size.height * 0.7, // 70% dari tinggi layar
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Terms & Conditions',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ), // Menggunakan TextStyle dari ThemeData
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium, // Menggunakan font Poppins dari ThemeData
                        children: [
                          TextSpan(
                            text: 'Terms & Conditions - Pengguna\n\n',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '1. Definisi\n',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const TextSpan(
                            text:
                                '  a. Pengguna: Individu yang menggunakan aplikasi Bantu.In untuk memesan layanan dari Tukang.\n',
                          ),
                          const TextSpan(
                            text:
                                '  b. Tukang: Penyedia jasa yang terdaftar di aplikasi Bantu.In.\n\n',
                          ),
                          TextSpan(
                            text: '2. Persyaratan Penggunaan\n',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const TextSpan(
                            text:
                                '  a. Pengguna wajib memberikan data yang valid, termasuk nama lengkap, nomor telepon aktif, dan alamat yang jelas.\n',
                          ),
                          const TextSpan(
                            text:
                                '  b. Pengguna bertanggung jawab atas keakuratan informasi yang diberikan.\n\n',
                          ),
                          TextSpan(
                            text: '... (Lanjutkan isi sesuai desain)\n',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey.shade600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
                          shadowColor: Colors.grey.shade300.withOpacity(0.7),
                          elevation: 4,
                        ),
                        child: const Text(
                          'Decline',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15), // Memberikan jarak antar tombol
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          // Tambahkan aksi jika diperlukan
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          shadowColor: Colors.grey.shade300.withOpacity(0.7),
                          elevation: 4,
                        ),
                        child: const Text(
                          'Accept',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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