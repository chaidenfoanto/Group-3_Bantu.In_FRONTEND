import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  LatLng tukangPosition = LatLng(-5.150, 119.396); // Lokasi default "tukang"
  LatLng markerPosition = LatLng(-5.150, 119.396); // Lokasi marker awal
  TextEditingController addressController = TextEditingController();
  String hintText = "Choose Your Location"; // Placeholder default
  bool _isLoading = false;

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
        hintText = address; // Perbarui hintText dengan alamat
        addressController.text = address; // Perbarui teks di TextField
      });
    } catch (e) {
      setState(() {
        hintText = "Choose Your Location"; // Kembali ke default jika gagal
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
      throw Exception("Failed to obtain location: ${e.toString()}");
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
        return "${place.name}, ${place.street}, ${place.locality}";
      } else {
        return "Address not found.";
      }
    } catch (e) {
      throw Exception("Failed to retrieve address: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Widget Peta
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
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
          // Widget Bar Atas
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.location_pin, color: Colors.red),
                      hintText: hintText, // Alamat pengguna atau placeholder
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                const Icon(Icons.search, color: Colors.grey),
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          // Widget Panel Bawah
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Order now',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow[800],
                            ),
                          ),
                          Container(
                            height: 4,
                            width: 50,
                            color: Colors.yellow[800],
                            margin: const EdgeInsets.only(top: 4),
                          ),
                        ],
                      ),
                      Text(
                        'Book first',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Image.asset('assets/images/order_now.png', height: 120),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      // Logika pemesanan
                      print('Order now pressed');
                    },
                    child: const Text(
                      'Order',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
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
