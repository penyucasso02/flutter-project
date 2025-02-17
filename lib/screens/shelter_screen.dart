import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart'; // For getting current location
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart'; // For Polyline

class ShelterScreen extends StatelessWidget {
  const ShelterScreen({super.key});

  // Predefined shelter locations
  final List<Map<String, dynamic>> shelters = const [
    {"name": "Anjung Singgah", "lat": 3.140853, "lng": 101.693207}, 
    {"name": "Pusat Transit Gelandangan Kuala Lumpur", "lat": 3.1735647208457753, "lng":  101.698933472588}, 
    {"name": "Women's Aid Organisation (WAO)", "lat":3.108611571830312, "lng": 101.63886910480028}, 
  ];
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shelter and Evacuation'),
        backgroundColor: Colors.purpleAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: shelters.length,
              itemBuilder: (context, index) {
                final shelter = shelters[index];
                return ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.purple),
                  title: Text(shelter['name']),
                  subtitle: Text(
                      'Lat: ${shelter['lat']}, Lng: ${shelter['lng']}'),
                  onTap: () => _showShelterOnMap(context, shelter),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Show shelter on the map
  void _showShelterOnMap(BuildContext context, Map<String, dynamic> shelter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShelterMapScreen(
          lat: shelter['lat'],
          lng: shelter['lng'],
          name: shelter['name'],
        ),
      ),
    );
  }
}

class ShelterMapScreen extends StatefulWidget {
  final double lat;
  final double lng;
  final String name;

  const ShelterMapScreen({
    super.key,
    required this.lat,
    required this.lng,
    required this.name,
  });

  @override
  State<ShelterMapScreen> createState() => _ShelterMapScreenState();
}

class _ShelterMapScreenState extends State<ShelterMapScreen> {
  GoogleMapController? _mapController;
  LocationData? _currentLocation;
  final Location _location = Location();
  final Set<Polyline> _polylines = {}; // For storing the route polyline

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Get current location of the user
  Future<void> _getCurrentLocation() async {
    final hasPermission = await _location.requestPermission();
    if (hasPermission == PermissionStatus.granted) {
      final location = await _location.getLocation();
      setState(() {
        _currentLocation = location;
      });

      // Draw route to the selected shelter
      _drawRoute();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission is required.')),
      );
    }
  }

  // Draw route from current location to the selected shelter
  Future<void> _drawRoute() async {
    if (_currentLocation == null) return;

    final LatLng origin = LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
    final LatLng destination = LatLng(widget.lat, widget.lng);

    // Generate the polyline for the route (dummy static points for this example)
    setState(() {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: [origin, destination],
          color: Colors.blue,
          width: 5,
        ),
      );
    });

    // Move camera to show the route
    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            origin.latitude < destination.latitude ? origin.latitude : destination.latitude,
            origin.longitude < destination.longitude ? origin.longitude : destination.longitude,
          ),
          northeast: LatLng(
            origin.latitude > destination.latitude ? origin.latitude : destination.latitude,
            origin.longitude > destination.longitude ? origin.longitude : destination.longitude,
          ),
        ),
        50.0, // Padding
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: Colors.purpleAccent,
      ),
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.lat, widget.lng),
                zoom: 12,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('currentLocation'),
                  position: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
                  infoWindow: const InfoWindow(title: 'Your Location'),
                ),
                Marker(
                  markerId: MarkerId(widget.name),
                  position: LatLng(widget.lat, widget.lng),
                  infoWindow: InfoWindow(title: widget.name),
                ),
              },
              polylines: _polylines,
              onMapCreated: (controller) {
                _mapController = controller;
              },
            ),
    );
  }
}
