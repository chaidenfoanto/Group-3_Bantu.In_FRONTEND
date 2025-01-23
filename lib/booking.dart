import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:front_end/widgets/service_options.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb; 
import 'dart:io'; // For File
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with SingleTickerProviderStateMixin {
  LatLng markerPosition = const LatLng(-5.150, 119.396);
  String hintText = "Type your Location...";
  late TabController _tabController;
  String selectedService = '';
  final PanelController _panelController = PanelController();
  final ValueNotifier<double> panelPositionNotifier = ValueNotifier(0);
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _images = [];
  List<XFile>? _videos = [];
  DateTime? selectedDate;
  String? selectedTimeSlot;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Method to pick media (images or videos)
  Future<void> _pickMedia(ImageSource source, {required bool isCamera}) async {
    if (isCamera) {
      // Pick media from the camera (photo or video)
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
      // Pick media from the gallery
      final List<XFile>? pickedFiles = await _picker.pickMultiImage();

      if (pickedFiles != null) {
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // Fungsi untuk memilih jam
  void _selectTimeSlot(String timeSlot) {
    setState(() {
      selectedTimeSlot = selectedTimeSlot == timeSlot ? null : timeSlot;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Peta
          CustomMapWidget(
            initialPosition: markerPosition,
            onLocationChanged: (LatLng newPosition, String address) {
              setState(() {
                markerPosition = newPosition;
                hintText = address;
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
              onTap: () async {
                final selectedAddress = await showSearch<String>(
                  context: context,
                  delegate: AddressSearchDelegate(),
                );
                if (selectedAddress != null) {
                  setState(() {
                    hintText = selectedAddress;
                  });
                }
              },
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
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              width: double.infinity, // Membuat lebar Container memenuhi layar
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey.shade300), // Garis di sekeliling
                borderRadius: BorderRadius.circular(10), // Sudut membulat
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tombol DatePicker
                  ElevatedButton.icon(
                    onPressed: () => _selectDate(context),
                    icon: const Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.black,
                    ),
                    label: Text(
                      selectedDate == null
                          ? "Choose a Date"
                          : "${selectedDate!.toLocal()}".split(' ')[0],
                      style: theme.textTheme.bodySmall,
                    ),
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
                  GridView.builder(
                    itemCount: 8,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 4.0,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final timeSlots = [
                        "08:00 - 10:00",
                        "10:00 - 12:00",
                        "12:00 - 14:00",
                        "14:00 - 16:00",
                        "16:00 - 18:00",
                        "18:00 - 20:00",
                        "20:00 - 22:00",
                        "22:00 - 24:00",
                      ];
                      final timeSlot = timeSlots[index];
                      return SizedBox(
                        height: 30, 
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: selectedTimeSlot == timeSlot
                                ? const Color(0xFFFECE2E)
                                : Colors.white,
                            side: BorderSide(
                              color: selectedTimeSlot == timeSlot
                                  ? const Color(0xFFFECE2E)
                                  : Colors.grey.shade300,
                            ),
                            padding: EdgeInsets
                                .zero, 
                          ),
                          onPressed: () {
                            setState(() {
                              selectedTimeSlot = timeSlot;
                            });
                          },
                          child: Text(
                            timeSlot,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      );
                    },
                  ),
                ],
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
        if (_images != null && _images!.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Images:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _images!.map((image) {
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
        if (_videos != null && _videos!.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                "Videos:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _videos!.map((video) {
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
                        Positioned(
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

class NominatimPlace {
  final String displayName;
  final double lat;
  final double lon;

  NominatimPlace({
    required this.displayName,
    required this.lat,
    required this.lon,
  });

  factory NominatimPlace.fromJson(Map<String, dynamic> json) {
    return NominatimPlace(
      displayName: json['display_name'],
      lat: double.parse(json['lat']),
      lon: double.parse(json['lon']),
    );
  }
}

class CustomMapWidget extends StatefulWidget {
  final LatLng initialPosition;
  final Function(LatLng, String)? onLocationChanged;

  const CustomMapWidget({
    super.key,
    required this.initialPosition,
    this.onLocationChanged,
  });

  @override
  State<CustomMapWidget> createState() => _CustomMapWidgetState();
}

class _CustomMapWidgetState extends State<CustomMapWidget> {
  late LatLng markerPosition;
  bool _isLoading = true;
  List<NominatimPlace> searchResults = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    markerPosition = widget.initialPosition;
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
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

        setState(() {
          markerPosition = LatLng(position.latitude, position.longitude);
          _isLoading = false;
        });

        await _reverseGeocode(position.latitude, position.longitude);
      } else {
        setState(() {
          _isLoading = false;
        });
        _showLocationPermissionDialog();
        await _getLocationFromIP();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Error: ${e.toString()}');
      await _getLocationFromIP();
    }
  }

  Future<void> _getLocationFromIP() async {
    try {
      final response = await http.get(Uri.parse('http://ip-api.com/json'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          markerPosition = LatLng(data['lat'], data['lon']);
        });
        await _reverseGeocode(data['lat'], data['lon']);
      }
    } catch (e) {
      _showErrorDialog('Failed to get location from IP: ${e.toString()}');
    }
  }

  Future<void> _searchAddress(String query) async {
    if (query.isEmpty) return;

    setState(() {
      isSearching = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
            'https://nominatim.openstreetmap.org/search?format=json&q=${Uri.encodeComponent(query)}&limit=5'),
        headers: {'User-Agent': 'YourAppName/1.0'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          searchResults =
              data.map((place) => NominatimPlace.fromJson(place)).toList();
          isSearching = false;
        });

        if (searchResults.isNotEmpty) {
          _showSearchResults();
        } else {
          _showErrorDialog('No results found');
        }

        if (searchResults.isNotEmpty) {
          final place = searchResults[0];
          setState(() {
            markerPosition = LatLng(place.lat, place.lon);
          });
          widget.onLocationChanged?.call(markerPosition, place.displayName);
        }
      } else {
        throw Exception('Failed to search address');
      }
    } catch (e) {
      setState(() {
        isSearching = false;
      });
      _showErrorDialog('Failed to search: ${e.toString()}');
    }
  }

  Future<void> _reverseGeocode(double lat, double lon) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon'),
        headers: {'User-Agent': 'YourAppName/1.0'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        widget.onLocationChanged?.call(LatLng(lat, lon), data['display_name']);
      }
    } catch (e) {
      print('Reverse geocoding error: ${e.toString()}');
    }
  }

  void _showSearchResults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Results'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              final place = searchResults[index];
              return ListTile(
                title: Text(place.displayName),
                onTap: () {
                  setState(() {
                    markerPosition = LatLng(place.lat, place.lon);
                  });
                  widget.onLocationChanged
                      ?.call(markerPosition, place.displayName);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission'),
        content: const Text(
            'Location permission is required to get your current location.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Geolocator.openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: markerPosition,
        initialZoom: 15,
        onTap: (tapPosition, point) {
          setState(() {
            markerPosition = point;
          });
          _reverseGeocode(point.latitude, point.longitude);
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
    );
  }
}

class AddressSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null as String);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<NominatimPlace>>(
      future: _searchAddress(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No results found'));
        } else {
          final results = snapshot.data!;
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final place = results[index];
              return ListTile(
                title: Text(place.displayName),
                onTap: () {
                  close(context, place.displayName);
                },
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  Future<List<NominatimPlace>> _searchAddress(String query) async {
    if (query.isEmpty) return [];

    final response = await http.get(
      Uri.parse(
          'https://nominatim.openstreetmap.org/search?format=json&q=${Uri.encodeComponent(query)}&limit=5'),
      headers: {'User-Agent': 'YourAppName/1.0'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((place) => NominatimPlace.fromJson(place)).toList();
    } else {
      throw Exception('Failed to search address');
    }
  }
}
