import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_register.dart';

class EnterUserDetails extends StatefulWidget {
  const EnterUserDetails({Key? key}) : super(key: key);

  @override
  _EnterUserDetailsState createState() => _EnterUserDetailsState();
}

class _EnterUserDetailsState extends State<EnterUserDetails> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  late String phoneNumber;
  @override
  void initState() {
    super.initState();
    phoneNumber = Register.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter User Details'),
      ),
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
            const Text('Email:'),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Enter your email',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await saveUserDetails(
                  nameController.text,
                  emailController.text,
                  phoneNumber,
                );
                Navigator.pushReplacementNamed(context, 'bottomNav');
              },
              child: const Text('Save Details'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveUserDetails(
      String name, String email, String phoneNumber) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .set({
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
      });
    } catch (e) {
      print("Error saving user details: $e");
    }
  }
}
