import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? profileImageUrl;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String name = 'oops! something went wrong';
  late String email = 'oops! something went wrong';
  late String phoneNumber = 'oops! something went wrong';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final userId = _auth.currentUser?.uid;

    if (userId != null) {
      final userData = await _firestore.collection('users').doc(userId).get();
      if (userData.exists) {
        setState(() {
          name = userData['name'] ?? 'Not Available';
          email = userData['address'] ?? 'Not Available';
          phoneNumber = userData['phoneNumber'] ?? 'Not Available';
          profileImageUrl = userData['profileImg'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
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
                      : const AssetImage("assets/images/logo.png") as ImageProvider,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoCard("Name", name),
            _buildInfoCard("Address", email),
            _buildInfoCard("Phone", phoneNumber),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'editUserDetails');
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
}
