import 'dart:io';

import 'package:flutter/material.dart';
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
  List<XFile>? _images = [];  // Menyimpan daftar gambar
  List<XFile>? _videos = [];  // Menyimpan daftar video

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
    final pickedFile = isCamera
        ? await _picker.pickVideo(source: source) // Mengambil video dari kamera
        : await _picker.pickImage(source: source); // Mengambil gambar dari kamera

    if (pickedFile != null) {
      setState(() {
        if (pickedFile.path.endsWith('.mp4')) {
          _videos!.add(pickedFile); // Menambahkan video
        } else {
          _images!.add(pickedFile); // Menambahkan gambar
        }
      });
    }
  }

  // Fungsi untuk memilih sumber media
  Future<void> _showMediaPickerDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pilih Sumber Media"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Ambil Foto / Video"),
                leading: const Icon(Icons.camera_alt),
                onTap: () {
                  Navigator.pop(context);
                  _pickMedia(ImageSource.camera, isCamera: true); // Ambil dari kamera
                },
              ),
              ListTile(
                title: const Text("Pilih dari Galeri"),
                leading: const Icon(Icons.photo),
                onTap: () {
                  Navigator.pop(context);
                  _pickMedia(ImageSource.gallery, isCamera: false); // Ambil dari galeri
                },
              ),
            ],
          ),
        );
      },
    );
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
              final double minPanelHeight = 60;
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
            ElevatedButton(
              onPressed: () {},
              child: Text(
                "Choose a Date",
                style: theme.textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                "Upload a photo of your issue.",
                style: theme.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _showMediaPickerDialog(),
                  icon: const Icon(Icons.photo_library),
                  label: Text(
                    "Select from Gallery",
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showMediaPickerDialog(),
                  icon: const Icon(Icons.camera_alt),
                  label: Text(
                    "Take a Photo",
                    style: theme.textTheme.bodySmall,
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
    if (_images!.isNotEmpty || _videos!.isNotEmpty) {
      return Column(
        children: [
          if (_images!.isNotEmpty)
            ..._images!.map((image) => Image.file(File(image.path))),
          if (_videos!.isNotEmpty)
            ..._videos!.map((video) => Text('Video: ${video.path}')),
        ],
      );
    }
    return const Text("No media selected.");
  }

  Widget _buildCostAndOrderButton(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
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
