import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CustomMapWidget extends StatelessWidget {
  final LatLng markerPosition;
  final Function(LatLng) onMarkerTap;

  const CustomMapWidget({
    Key? key,
    required this.markerPosition,
    required this.onMarkerTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: markerPosition,
        initialZoom: 15,
        onTap: (tapPosition, point) => onMarkerTap(point),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
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
