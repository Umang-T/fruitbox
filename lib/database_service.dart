import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> writeUserData(String userId, Map<String, dynamic> userData) async {
    try {
      await _firestore.collection('users').doc(userId).set(userData);
    } catch (error) {
      if (kDebugMode) {
        print('Error writing user data: $error');
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> readUserData(String userId) async {
    try {
      final DocumentSnapshot snapshot = await _firestore.collection('users').doc(userId).get();
      final Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        return data;
      }
      return {}; // Return an empty map if no data is found.
    } catch (error) {
      if (kDebugMode) {
        print('Error reading user data: $error');
      }
      rethrow;
    }
  }
}
