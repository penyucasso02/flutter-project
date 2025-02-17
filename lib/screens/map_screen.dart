import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;

  // Locations in Malaysia
  static const LatLng _kualaLumpur = LatLng(3.1390, 101.6869); // Kuala Lumpur

  // Markers to show on the map
  final Set<Marker> _markers = {
    Marker(
      markerId: MarkerId('kualaLumpur'),
      position: _kualaLumpur,
      infoWindow: InfoWindow(
        title: 'Kuala Lumpur',
        snippet: 'Capital city of Malaysia',
      ),
    ),
    Marker(
      markerId: MarkerId('penang'),
      position: LatLng(5.4164, 100.3327),
      infoWindow: InfoWindow(
        title: 'Penang',
        snippet: 'Historical and cultural hub',
      ),
    ),
    Marker(
      markerId: MarkerId('johorBahru'),
      position: LatLng(1.4927, 103.7414),
      infoWindow: InfoWindow(
        title: 'Johor Bahru',
        snippet: 'Southern gateway of Malaysia',
      ),
    ),
    Marker(
      markerId: MarkerId('malacca'),
      position: LatLng(2.1896, 102.2501),
      infoWindow: InfoWindow(
        title: 'Malacca',
        snippet: 'Known for its heritage and history',
      ),
    ),
    Marker(
      markerId: MarkerId('kotaKinabalu'),
      position: LatLng(5.9804, 116.0735),
      infoWindow: InfoWindow(
        title: 'Kota Kinabalu',
        snippet: 'City in Sabah, near Mount Kinabalu',
      ),
    ),
    Marker(
      markerId: MarkerId('kuantan'),
      position: LatLng(3.8077, 103.3260),
      infoWindow: InfoWindow(
        title: 'Kuantan',
        snippet: 'Capital of Pahang',
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disaster Map'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _kualaLumpur, // Default center point (Kuala Lumpur)
              zoom: 8.0, // Initial zoom
            ),
            markers: _markers,
            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),
          // Floating Action Button for GPS
          Positioned(
            bottom: 100, // Adjust position to avoid overlapping with controls
            right: 16,
            child: FloatingActionButton(
              onPressed: _goToKualaLumpur,
              child: const Icon(Icons.my_location),
              backgroundColor: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }

  // Navigate to Kuala Lumpur
  void _goToKualaLumpur() {
    if (_mapController == null) return;

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_kualaLumpur, 15.0), // Zoom level 15 for close view
    );
  }
}
