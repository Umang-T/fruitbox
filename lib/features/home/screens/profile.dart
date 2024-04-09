import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? profileImageUrl;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String name = 'oops! something went wrong';
  late String address = 'oops! something went wrong';
  late String phoneNumber = 'oops! something went wrong';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final userId = _auth.currentUser?.uid;

      if (userId != null) {
        final DocumentSnapshot<Map<String, dynamic>> userData =
            await _firestore.collection('users').doc(userId).get();

        print('User Data: ${userData.data()}');

        if (mounted && userData.exists) {
          setState(() {
            name = userData.get('name') ?? 'Not Available';
            address = userData.get('address') ?? 'Not Available';
            phoneNumber = userData.get('phoneNumber') ?? 'Not Available';

            final profileImg = userData.get('profileImg');
            profileImageUrl = (profileImg is String && profileImg.isNotEmpty)
                ? profileImg
                : null;
          });
        } else {
          // Handle the case where the document does not exist
          print('User data does not exist');
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCommonHeader(),
      body: FutureBuilder(
        future: Future.value(true), // Replace with a real future if needed
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for the data
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Handle errors
            return Text('Error: ${snapshot.error}');
          } else {
            // Data has been successfully fetched, build the UI
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.black,
                      child: CircleAvatar(
                        radius: 58,
                        backgroundImage: _auth.currentUser?.photoURL != null
                            ? NetworkImage(_auth.currentUser!.photoURL!)
                            : profileImageUrl != null
                                ? NetworkImage(profileImageUrl!)
                                : const AssetImage("assets/images/logo.png")
                                    as ImageProvider,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildInfoCard("Name", name),
                  _buildInfoCard("Address", address),
                  _buildInfoCard("Phone", phoneNumber),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          navigateToEditProfile();
                          print('Navigate to edit profile');
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                        ),
                        child: const Text('Edit Profile'),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        elevation: 3,
        color: Colors.white,
        child: ListTile(
          title: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            value,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget? buildCommonHeader() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      title: const Text(
        'My Profile',
        style: TextStyle(color: Colors.black),
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      automaticallyImplyLeading: true,
    );
  }

  void navigateToEditProfile() async {
    final updatedUserData = await Navigator.pushNamed(
      context,
      'editUserDetails',
    ) as Map<String, dynamic>?;
    if (updatedUserData != null) {
      setState(() {
        name = updatedUserData['name'] ?? 'Not Available';
        address = updatedUserData['address'] ?? 'Not Available';
        phoneNumber = updatedUserData['phoneNumber'] ?? 'Not Available';

        final profileImg = updatedUserData['profileImg'];
        profileImageUrl =
            (profileImg is String && profileImg.isNotEmpty) ? profileImg : null;
      });
    }
  }
}
