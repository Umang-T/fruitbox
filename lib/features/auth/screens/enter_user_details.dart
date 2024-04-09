import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_register.dart';

class EnterUserDetails extends StatefulWidget {
  const EnterUserDetails({super.key});

  @override
  _EnterUserDetailsState createState() => _EnterUserDetailsState();
}

class _EnterUserDetailsState extends State<EnterUserDetails> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  late String phoneNumber;

  @override
  void initState() {
    super.initState();
    phoneNumber = Register.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCommonHeader(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Name:'),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Enter your name',
              ),
            ),
            const SizedBox(height: 20),
            const Text('Address:'),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                hintText: 'Enter your address',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await saveUserDetails(
                  nameController.text,
                  addressController.text,
                  phoneNumber,
                );
                Navigator.pushReplacementNamed(context, 'bottomNav');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffFFC201), // Set the button color
              ),
              child: const Text('Save Details'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> saveUserDetails(
      String name, String address, String phoneNumber) async {
    try {
      await _firestore.collection('users').doc(auth.currentUser!.uid).set({
        'name': name,
        'address': address,
        'phoneNumber': phoneNumber,
      });
    } catch (e) {
      print("Error saving user details: $e");
    }
  }

  PreferredSizeWidget? buildCommonHeader() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white, // Set the background color to white
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.black,
            size: 35,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      title: const Text(
        'Enter User Details',
        style: TextStyle(color: Colors.black), // Set text color to black
      ),
    );
  }
}
