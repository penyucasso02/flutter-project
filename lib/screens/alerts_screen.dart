import 'dart:io';
import 'package:flutter/material.dart';
 // For accessing directories
import 'package:flutter/services.dart' show rootBundle; // To load assets

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  // Preset disaster alerts
  final List<Map<String, String>> alerts = const [
    {
      'title': 'Heavy Rain Warning',
      'region': 'Sarawak: Kuching, Sibu, Mukah',
      'severity': 'Severe',
      'description':
          'Heavy rain expected to persist until 20 January 2025. Risk of flooding in low-lying areas.',
    },
    {
      'title': 'Flood Warning',
      'region': 'Johor: Pontian, Kota Tinggi',
      'severity': 'Moderate',
      'description':
          'Flooding has been reported in several districts. Residents are advised to evacuate to higher ground.',
    },
    {
      'title': 'Landslide Alert',
      'region': 'Sabah: Ranau, Kundasang',
      'severity': 'High',
      'description':
          'Landslides reported in hilly areas due to continuous rainfall. Travel with caution.',
    },
    {
      'title': 'Strong Winds',
      'region': 'Penang: Coastal Areas',
      'severity': 'Moderate',
      'description':
          'Strong winds expected in coastal areas. Fishing activities are discouraged.',
    },
    {
      'title': 'Haze Warning',
      'region': 'Klang Valley: Kuala Lumpur, Selangor',
      'severity': 'Mild',
      'description':
          'Air quality has dropped due to haze. Avoid outdoor activities.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disaster Alerts'),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Download Brochure',
            onPressed: () async {
              await _downloadBrochure(context);
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200], // Light gray background
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: alerts.length, // Use the preset data length
            itemBuilder: (context, index) {
              final alert = alerts[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4, // Adds depth
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getSeverityColor(alert['severity']!)
                          .withOpacity(0.2), // Light color for severity
                      child: Icon(
                        Icons.warning,
                        color: _getSeverityColor(alert['severity']!),
                      ),
                    ),
                    title: Text(
                      alert['title']!,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'Region: ${alert['region']}',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          alert['description']!,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      // Add functionality for tap action (e.g., navigate to details screen)
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Get color based on severity
  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'Severe':
        return Colors.red;
      case 'High':
        return Colors.orange;
      case 'Moderate':
        return Colors.yellow;
      case 'Mild':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  // Save the brochure to the Downloads folder
  Future<void> _downloadBrochure(BuildContext context) async {
    try {
      // Load the PDF file from the assets folder
      final byteData = await rootBundle.load('assets/forecast.pdf');

      // Get the Downloads directory
      final directory = Directory('/storage/emulated/0/Download');
      if (!directory.existsSync()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Downloads folder not found.')),
        );
        return;
      }

      // Save the PDF file to the Downloads folder
      final file = File('${directory.path}/forecast.pdf');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Brochure saved to: ${file.path}')),
      );
    } catch (e) {
      // Show an error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save brochure: $e')),
      );
    }
  }
}
