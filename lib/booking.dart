import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:front_end/widgets/map_service.dart';
import 'package:front_end/widgets/custom_map_widget.dart';

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

          // Tombol Back
          Positioned(
            left: 16,
            bottom: MediaQuery.of(context).size.height * 0.65 + 32,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),

          // Panel Sliding
          SlidingUpPanel(
            controller: _panelController,
            minHeight: 60, // Tinggi minimum agar tab terlihat
            maxHeight: MediaQuery.of(context).size.height * 0.65,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            panelBuilder: (scrollController) => _buildSlidingPanel(
              theme,
              scrollController,
            ),
            body: Container(), // Tetap kosong karena peta ada di belakang
          ),
        ],
      ),
    );
  }

  Widget _buildSlidingPanel(ThemeData theme, ScrollController scrollController) {
    return Column(
      children: [
        // Tab Bar
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
              // Tab "Order now"
              _buildOrderNowContent(theme),

              // Tab "Book first"
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _serviceOption(
                context,
                icon: Icons.ac_unit, // Placeholder
                label: "Recharge Freon",
                isSelected: selectedService == "Recharge Freon",
                onTap: () {
                  setState(() {
                    selectedService = "Recharge Freon";
                  });
                },
              ),
              _serviceOption(
                context,
                icon: Icons.cleaning_services, // Placeholder
                label: "Cleaning Up",
                isSelected: selectedService == "Cleaning Up",
                onTap: () {
                  setState(() {
                    selectedService = "Cleaning Up";
                  });
                },
              ),
            ],
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _serviceOption(
                  context,
                  icon: Icons.ac_unit, // Placeholder
                  label: "Recharge Freon",
                  isSelected: selectedService == "Recharge Freon",
                  onTap: () {
                    setState(() {
                      selectedService = "Recharge Freon";
                    });
                  },
                ),
                _serviceOption(
                  context,
                  icon: Icons.cleaning_services, // Placeholder
                  label: "Cleaning Up",
                  isSelected: selectedService == "Cleaning Up",
                  onTap: () {
                    setState(() {
                      selectedService = "Cleaning Up";
                    });
                  },
                ),
              ],
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
                hintText: "Describe your issue...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
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
              child: const Text("Choose a Date"),
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
                  onPressed: () {},
                  icon: const Icon(Icons.photo),
                  label: const Text("Gallery"),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.camera),
                  label: const Text("Camera"),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildCostAndOrderButton(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildCostAndOrderButton(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Total Cost", style: theme.textTheme.bodyMedium),
            Text(
              "Rp0",
              style: theme.textTheme.titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
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
          child: const Text("Order"),
        ),
      ],
    );
  }

  Widget _serviceOption(BuildContext context,
      {required IconData icon,
      required String label,
      required bool isSelected,
      required VoidCallback onTap}) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFECE2E) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border:
              Border.all(color: isSelected ? theme.primaryColor : Colors.grey),
        ),
        child: Column(
          children: [
            Icon(icon, color: theme.primaryColor, size: 40),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}
