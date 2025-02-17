import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Emergency Service'),
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildServiceCard(
              context,
              imagePath: 'assets/images/bomba.png', 
              title: 'Firefighter (Bomba)',
              description: 'Emergency fire and rescue services.',
              phoneNumber: '911', // Emergency number for Bomba
            ),
            const SizedBox(height: 16),
            _buildServiceCard(
              context,
              imagePath: 'assets/images/polis.png', 
              title: 'Police (PDRM)',
              description: 'Law enforcement and public safety.',
              phoneNumber: '999', // Emergency number for Police
            ),
            const SizedBox(height: 16),
            _buildServiceCard(
              context,
              imagePath: 'assets/images/jpam.png',
              title: 'Pertahanan Awam',
              description: 'Civil defense and disaster response.',
              phoneNumber: '03-26871400', // Phone number for Pertahanan Awam
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required String imagePath,
    required String title,
    required String description,
    required String phoneNumber,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: InkWell(
        onTap: () {
          _makePhoneCall(phoneNumber); // Call the function to make a phone call
        },
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            // Image Section
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Text Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to make a phone call
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }
}
