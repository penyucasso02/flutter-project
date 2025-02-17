import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseServices {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  // Create: Insert a report into Firebase Realtime Database
  Future<void> insertReport(String title, String description, String location) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      String reportId = _databaseReference.child('reports').push().key!;

      Map<String, dynamic> reportData = {
        'id': reportId,
        'userId': user.uid,
        'title': title,
        'description': description,
        'location': location,
        'createdAt': DateTime.now().toIso8601String(),
      };

      await _databaseReference.child('reports/$reportId').set(reportData);
    } catch (e) {
      throw Exception('Failed to add report: $e');
    }
  }

  // Read: Fetch all reports belonging to the logged-in user from Firebase
  Future<List<Map<String, dynamic>>> getReports() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      DatabaseEvent event = await _databaseReference.child('reports').orderByChild('userId').equalTo(user.uid).once();
      if (event.snapshot.value == null) {
        return [];
      }

      Map<dynamic, dynamic> reports = event.snapshot.value as Map<dynamic, dynamic>;
      return reports.entries.map((entry) {
        final report = Map<String, dynamic>.from(entry.value);
        report['id'] = entry.key; // Ensure ID is included
        return report;
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch reports: $e');
    }
  }

  // Update: Edit an existing report in Firebase
  Future<void> updateReport(String reportId, String title, String description, String location) async {
    try {
      Map<String, dynamic> updatedData = {
        'title': title,
        'description': description,
        'location': location,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      await _databaseReference.child('reports/$reportId').update(updatedData);
    } catch (e) {
      throw Exception('Failed to update report: $e');
    }
  }

  // Delete: Remove a report from Firebase Realtime Database
  Future<void> deleteReport(String reportId) async {
    try {
      await _databaseReference.child('reports/$reportId').remove();
    } catch (e) {
      throw Exception('Failed to delete report: $e');
    }
  }

  // Read user profile data
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      DatabaseReference userRef = _databaseReference.child('users/${user.uid}');
      DataSnapshot snapshot = await userRef.get();

      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  // Update user profile data
  Future<void> updateUserProfile(String name, String email) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      await _databaseReference.child('users/${user.uid}').update({
        'name': name,
        'email': email,
      });

      await user.updateEmail(email);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}
