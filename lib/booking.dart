import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:front_end/widgets/map_service.dart';
import 'package:front_end/widgets/service_options.dart';
import 'package:front_end/widgets/custom_map_widget.dart';
import 'package:image_picker/image_picker.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with SingleTickerProviderStateMixin {
  LatLng markerPosition = const LatLng(-5.150, 119.396);
  String hintText = "Perumahan Purakucing, Jalan Johar...";
  final MapService mapService = MapService();
  late TabController _tabController;
  String selectedService = '';
  final PanelController _panelController = PanelController();
  final ValueNotifier<double> panelPositionNotifier = ValueNotifier(0);
  final ImagePicker _picker = ImagePicker();
  final List<XFile>? _images = []; // Menyimpan daftar gambar
  final List<XFile>? _videos = []; // Menyimpan daftar video

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      LatLng currentLocation = await mapService.getCurrentLocation();
      String address = await mapService.getAddressFromLatLng(currentLocation);
      setState(() {
        markerPosition = currentLocation;
        hintText = address;
      });
    } catch (e) {
      setState(() {
        hintText = "Gagal mendapatkan lokasi.";
      });
    }
  }

  // Fungsi untuk memilih gambar atau video
  Future<void> _pickMedia(ImageSource source, {required bool isCamera}) async {
    if (isCamera) {
      // Pilih media dari kamera (foto atau video)
      final XFile? pickedFile = await _picker.pickVideo(source: source);

      if (pickedFile != null) {
        setState(() {
          _videos!.add(pickedFile);
        });
      } else {
        final XFile? pickedImage = await _picker.pickImage(source: source);
        if (pickedImage != null) {
          setState(() {
            _images!.add(pickedImage);
          });
        }
      }
    } else {
      // Pilih media dari galeri
      final List<XFile> pickedFiles = await _picker.pickMultiImage();

      if (pickedFiles.isNotEmpty) {
        setState(() {
          for (var file in pickedFiles) {
            if (file.path.endsWith('.mp4') || file.path.endsWith('.mov')) {
              _videos!.add(file);
            } else {
              _images!.add(file);
            }
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Peta
          CustomMapWidget(
            markerPosition: markerPosition,
            onMarkerTap: (point) {
              setState(() {
                markerPosition = point;
              });
            },
          ),

          // Input Lokasi di atas peta
          Positioned(
            top: 30,
            left: 16,
            right: 16,
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_pin, color: Colors.red),
                hintText: hintText,
                hintStyle: theme.textTheme.bodyMedium,
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: const Icon(Icons.search, color: Colors.black),
              ),
            ),
          ),

          // Tombol Back yang dinamis
          AnimatedBuilder(
            animation: panelPositionNotifier,
            builder: (context, child) {
              final double maxPanelHeight =
                  MediaQuery.of(context).size.height * 0.65;
              const double minPanelHeight = 60;
              final double panelHeight = panelPositionNotifier.value *
                      (maxPanelHeight - minPanelHeight) +
                  minPanelHeight;
              final double backButtonPosition = panelHeight + 16;

              return Positioned(
                left: 16,
                bottom: backButtonPosition,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              );
            },
          ),

          SlidingUpPanel(
            controller: _panelController,
            minHeight: 60,
            maxHeight: MediaQuery.of(context).size.height * 0.65,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            onPanelSlide: (position) {
              setState(() {
                panelPositionNotifier.value = position;
              });
            },
            panelBuilder: (scrollController) => _buildSlidingPanel(
              theme,
              scrollController,
            ),
            body: Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildSlidingPanel(
      ThemeData theme, ScrollController scrollController) {
    return Column(
      children: [
        TabBar(
          labelStyle: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          controller: _tabController,
          labelColor: theme.secondaryHeaderColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: theme.primaryColor,
          indicatorWeight: 2,
          tabs: const [
            Tab(text: "Order now"),
            Tab(text: "Book first"),
          ],
        ),
        // Isi Konten Tab Bar
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildOrderNowContent(theme),
              _buildBookFirstContent(theme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderNowContent(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "What service do you need?",
            style: theme.textTheme.titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ServiceOptions(
            selectedService: selectedService,
            onServiceSelected: (service) {
              setState(() {
                selectedService = service;
              });
            },
          ),
          const SizedBox(height: 32),
          Text(
            "Order now for an instant pick..",
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          _buildCostAndOrderButton(theme),
        ],
      ),
    );
  }

  Widget _buildBookFirstContent(ThemeData theme) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "What service do you need?",
                style: theme.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            ServiceOptions(
              selectedService: selectedService,
              onServiceSelected: (service) {
                setState(() {
                  selectedService = service;
                });
              },
            ),
            const SizedBox(height: 32),
            Text(
              "What's the issue?",
              style: theme.textTheme.titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: "Type here to let the technician know your problem.",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            Text(
              "When would you like to start the work?",
              style: theme.textTheme.titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.calendar_month_outlined,
                color: Colors.black,
              ),
              label: Text("Choose a Date", style: theme.textTheme.bodySmall),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.black, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                "08:00 - 10:00",
                "10:00 - 12:00",
                "12:00 - 14:00",
                "14:00 - 16:00",
                "16:00 - 18:00",
                "18:00 - 20:00",
                "20:00 - 22:00",
                "22:00 - 24:00",
              ].map((timeSlot) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  onPressed: () {},
                  child: Text(
                    timeSlot,
                    style: theme.textTheme.bodyMedium,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // Bagian Upload Foto
            Center(
              child: Text(
                "Upload a photo of your issue.",
                style: theme.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () =>
                      _pickMedia(ImageSource.gallery, isCamera: false),
                  icon: const Icon(
                    Icons.photo_library,
                    color: Colors.black,
                  ),
                  label: Text("Select from Gallery",
                      style: theme.textTheme.bodySmall),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () =>
                      _pickMedia(ImageSource.camera, isCamera: true),
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                  ),
                  label: Text("Take a Photo", style: theme.textTheme.bodySmall),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.black, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildMediaPreview(),
            const SizedBox(height: 32),
            _buildCostAndOrderButton(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_images != null && _images.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Images:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _images.map((image) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      kIsWeb ? image.path : File(image.path).path,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        if (_videos != null && _videos.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Videos:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _videos.map((video) {
                  return GestureDetector(
                    onTap: () {
                      // Tambahkan logika untuk memutar video (jika diperlukan)
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: kIsWeb
                              ? Image.network(
                                  video.path,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(video.path),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        const Positioned(
                          top: 35,
                          left: 35,
                          child: Icon(
                            Icons.play_circle_fill,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildCostAndOrderButton(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          thickness: 1,
          color: Colors.black26,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total Cost", style: theme.textTheme.bodyMedium),
                Text(
                  "Rp0",
                  style: theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text("Order",
                  style: theme.textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ],
    );
  }
}
