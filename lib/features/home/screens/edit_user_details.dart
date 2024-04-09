import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditUserDetails extends StatefulWidget {
  const EditUserDetails({super.key});

  @override
  _EditUserDetailsState createState() => _EditUserDetailsState();
}

class _EditUserDetailsState extends State<EditUserDetails> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String? _profileImageUrl;
  File? _pickedImage;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCommonHeader(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: InkResponse(
                onTap: () async {
                  await _pickImage();
                },
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.black,
                      child: CircleAvatar(
                        radius: 58,
                        backgroundImage: _pickedImage != null
                            ? FileImage(_pickedImage!)
                            : _profileImageUrl != null
                                ? NetworkImage(_profileImageUrl!)
                                : _auth.currentUser?.photoURL != null
                                    ? NetworkImage(_auth.currentUser!.photoURL!)
                                    : const AssetImage("assets/images/logo.png")
                                        as ImageProvider,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildInfoTextField("Name", _nameController),
            _buildInfoTextField("Address", _emailController),
            _buildInfoTextField("Phone", _phoneController),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: ElevatedButton(
                  onPressed: () {
                    saveUserDetails();
                    print('User details saved');
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                  ),
                  child: const Text('Save Changes'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTextField(String label, TextEditingController controller) {
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
          subtitle: TextFormField(
            controller: controller,
            readOnly: label == "Phone",
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: controller.text.isEmpty ? 'Not Available' : null,
              hintStyle: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fetchUserData() async {
    final userId = _auth.currentUser?.uid;

    if (userId != null) {
      final userData = await _firestore.collection('users').doc(userId).get();
      if (userData.exists) {
        setState(() {
          _nameController.text = userData['name'] ?? '';
          _emailController.text = userData['address'] ?? '';
          _phoneController.text = userData['phoneNumber'] ?? '';
          _profileImageUrl = userData['profileImg'];

          // If there's a profile image URL, clear the picked image
          if (_profileImageUrl != null) {
            _pickedImage = null;
          }
        });
      }
    }
  }

  void saveUserDetails() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      String? imageUrl;
      if (_pickedImage != null) {
        imageUrl = await _uploadImageToStorage(_pickedImage!);
      } else {
        imageUrl = _profileImageUrl;
      }

      await _firestore.collection('users').doc(userId).update({
        'name': _nameController.text,
        'address': _emailController.text,
        'phoneNumber': _phoneController.text,
        'profileImg': imageUrl,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User details saved'),
        ),
      );
      Navigator.pop(context, {
        'name': _nameController.text,
        'address': _emailController.text,
        'phoneNumber': _phoneController.text,
        'profileImg': imageUrl,
      });
    }
  }

  Future<void> _pickImage() async {
    print('Picking image...');
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _pickedImage = File(pickedFile.path);
        });
        print('Image picked, uploading to storage...');
        await _uploadImageToStorage(_pickedImage!);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<String?> _uploadImageToStorage(File imageFile) async {
    print('Start uploading image...');
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        final storage = firebase_storage.FirebaseStorage.instance;
        final ref =
            storage.ref().child('user_profile_images').child('$userId.jpg');
        await ref.putFile(imageFile);
        final String downloadURL = await ref.getDownloadURL();
        print('Image uploaded successfully. Download URL: $downloadURL');
        return downloadURL;
      }
    } catch (e) {
      print('Error uploading image to storage: $e');
      return null;
    }
    return null;
  }

  PreferredSizeWidget? buildCommonHeader() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      title: const Text(
        'Edit Your Details',
        style: TextStyle(color: Colors.black),
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      automaticallyImplyLeading: true,
    );
  }

  void navigateToLogin() {
    Navigator.pushNamed(context, 'register');
    print('Navigate to login');
  }

  void navigateToProfile() {
    Navigator.pushNamed(context, 'profile');
    print('Navigate to profile');
  }
}
