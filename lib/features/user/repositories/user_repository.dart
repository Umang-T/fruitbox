// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../models/user_model.dart';
//
// class UserRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final CollectionReference _usersCollection =
//   FirebaseFirestore.instance.collection('users');
//
//   Future<void> writeUserData(
//       String userId, Map<String, dynamic> userData) async {
//     try {
//       await _usersCollection.doc(userId).set(userData);
//     } catch (e) {
//       print('Error writing user data: $e');
//       throw Exception('Failed to write user data');
//     }
//   }
//
//   Future<Map<String, dynamic>?> readUserData(String userId) async {
//     try {
//       var docSnapshot = await _usersCollection.doc(userId).get();
//       return docSnapshot.data() as Map<String, dynamic>?;
//     } catch (e) {
//       print('Error reading user data: $e');
//       throw Exception('Failed to read user data');
//     }
//   }
//
//   Future<List<Map<String, dynamic>>> getAllUsers() async {
//     try {
//       var querySnapshot = await _usersCollection.get();
//       return querySnapshot.docs
//           .map((doc) => doc.data() as Map<String, dynamic>)
//           .toList();
//     } catch (e) {
//       print('Error fetching users: $e');
//       throw Exception('Failed to fetch users');
//     }
//   }
//
//   Future<void> updateUserData(
//       String userId, Map<String, dynamic> updatedData) async {
//     try {
//       await _usersCollection.doc(userId).update(updatedData);
//     } catch (e) {
//       print('Error updating user data: $e');
//       throw Exception('Failed to update user data');
//     }
//   }
//
//   Future<void> deleteUser(String userId) async {
//     try {
//       await _usersCollection.doc(userId).delete();
//     } catch (e) {
//       print('Error deleting user: $e');
//       throw Exception('Failed to delete user');
//     }
//   }
//
//   Future<bool> doesUserExist(String userId) async {
//     try {
//       var docSnapshot = await _usersCollection.doc(userId).get();
//       return docSnapshot.exists;
//     } catch (e) {
//       print('Error checking if user exists: $e');
//       throw Exception('Failed to check if user exists');
//     }
//   }
//
//   Future<void> linkUserDataWithAuth(String userId) async {
//     try {
//       User? currentUser = _auth.currentUser;
//       if (currentUser != null) {
//         await _usersCollection.doc(userId).update({
//           'authUid': currentUser.uid,
//         });
//       } else {
//         print('No authenticated user found.');
//       }
//     } catch (error) {
//       print('Error linking user data with authentication UID: $error');
//       rethrow;
//     }
//   }
// }
