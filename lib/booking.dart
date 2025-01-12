import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  LatLng tukangPosition = LatLng(-5.150, 119.396);
  LatLng markerPosition = LatLng(-5.150, 119.396);
  TextEditingController addressController = TextEditingController();
  TextEditingController issueController = TextEditingController();
  String hintText = "Choose Your Location";
  bool _isLoading = false;
  int selectedTab = 0;
  String selectedTime = "";
  String selectedDate = "Choose a Date";
  final Color orangeColor = const Color(0xFFFECE2E);
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _updateUserLocationAndAddress();
  }

  Future<void> _updateUserLocationAndAddress() async {
    setState(() {
      _isLoading = true;
    });

    try {
      LatLng currentLocation = await _getCurrentLocation();
      markerPosition = currentLocation;

      String address = await _getAddressFromLatLng(
        Position(
          latitude: currentLocation.latitude,
          longitude: currentLocation.longitude,
          timestamp: DateTime.now(),
          accuracy: 1.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          altitudeAccuracy: 0.0,
          headingAccuracy: 0.0,
        ),
      );

      setState(() {
        hintText = address;
        addressController.text = address;
      });
    } catch (e) {
      setState(() {
        hintText = "Choose Your Location";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<LatLng> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        return LatLng(position.latitude, position.longitude);
      } else {
        throw Exception("Location permission is not granted by the user.");
      }
    } catch (e) {
      throw Exception("Failed to obtain location: \${e.toString()}");
    }
  }

  Future<String> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "\${place.name}, \${place.street}, \${place.locality}";
      } else {
        return "Address not found.";
      }
    } catch (e) {
      throw Exception("Failed to retrieve address: \${e.toString()}");
    }
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = DateFormat('dd MMM yyyy').format(pickedDate);
      });
    }
  }

  void _pickFromGallery() async {
    await _picker.pickImage(source: ImageSource.gallery);
  }

  void _takePhoto() async {
    await _picker.pickImage(source: ImageSource.camera);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
                  options: MapOptions(
                    initialCenter: markerPosition,
                    initialZoom: 15,
                    onTap: (tapPosition, point) {
                      setState(() {
                        markerPosition = point;
                      });
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    CurrentLocationLayer(
                      followOnLocationUpdate: FollowOnLocationUpdate.always,
                      turnOnHeadingUpdate: TurnOnHeadingUpdate.never,
                      style: const LocationMarkerStyle(
                        marker: DefaultLocationMarker(
                          child: Icon(
                            Icons.navigation,
                            color: Colors.white,
                          ),
                        ),
                        markerSize: Size(40, 40),
                        markerDirection: MarkerDirection.heading,
                      ),
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: tukangPosition,
                          width: 40.0,
                          height: 40.0,
                          child: const Icon(
                            Icons.home_repair_service,
                            size: 40.0,
                            color: Colors.blue,
                          ),
                        ),
                        Marker(
                          point: markerPosition,
                          width: 40.0,
                          height: 40.0,
                          child: const Icon(
                            Icons.location_on,
                            size: 40.0,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
          Positioned(
            top: 20,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Positioned(
            top: 70,
            left: 16,
            right: 16,
            child: Stack(
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.location_pin, color: Colors.red),
                    hintText: hintText,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => selectedTab = 0),
                        child: Column(
                          children: [
                            Text(
                              'Order now',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            if (selectedTab == 0)
                              Container(
                                height: 4,
                                width: 60,
                                color: orangeColor,
                                margin: const EdgeInsets.only(top: 4),
                              ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => selectedTab = 1),
                        child: Column(
                          children: [
                            Text(
                              'Book first',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            if (selectedTab == 1)
                              Container(
                                height: 4,
                                width: 60,
                                color: orangeColor,
                                margin: const EdgeInsets.only(top: 4),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  selectedTab == 0
                      ? Column(
                          children: [
                            Image.asset('assets/images/order_now.png', height: 120),
                            const SizedBox(height: 8),
                            const Text('Order now for an instant pick..', style: TextStyle(fontSize: 14)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: orangeColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: () {
                                print('Order now pressed');
                              },
                              child: const Text(
                                'Order',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "What's the issue?",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: issueController,
                              decoration: InputDecoration(
                                hintText: 'Describe your issue...',
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'When would you like to start the work?',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: _selectDate,
                                  icon: const Icon(Icons.calendar_today, color: Colors.black),
                                  label: Text(selectedDate, style: const TextStyle(color: Colors.black)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[300],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 10,
                              children: [
                                for (var time in ['08.00', '10.00', '12.00', '14.00', '16.00', '18.00', '20.00', '22.00'])
                                  ChoiceChip(
                                    label: Text(time),
                                    selected: selectedTime == time,
                                    onSelected: (selected) {
                                      setState(() {
                                        selectedTime = selected ? time : "";
                                      });
                                    },
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[300],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: _pickFromGallery,
                                    child: const Text(
                                      'Select from Gallery',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[300],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: _takePhoto,
                                    child: const Text(
                                      'Take a Photo',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Total Cost',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Rp0',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange[700],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: () {},
                              child: const Text(
                                'Next',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
