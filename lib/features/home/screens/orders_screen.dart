import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../features/user/models/order_model.dart';
import '../../../common/widget/order_card.dart';
import '../../../constants/global_variables.dart';
import 'order_details_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCommonHeader(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: null,
                ),
                Center(
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 200,
                  ),
                ),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.black),
              title: const Text(
                'Home',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                navigateToHome();
              },
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.black),
              title: const Text(
                'App Info',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                navigateToAppInfo();
              },
            ),
            ListTile(
              leading: const Icon(Icons.group, color: Colors.black),
              title: const Text(
                'Invite Friends',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                navigateToInviteFriends();
              },
            ),
            ListTile(
              leading: const Icon(Icons.policy, color: Colors.black),
              title: const Text(
                'Policies',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                navigateToPolicies();
              },
            ),
            ListTile(
              leading: const Icon(Icons.help, color: Colors.black),
              title: const Text(
                'Help and Support',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                navigateToHelpAndSupport();
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.black),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                logout();
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('orders')
            .where('userId',
                isEqualTo: _auth
                    .currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No orders yet.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final orderData =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                print('Order Data: $orderData');
                final order = UserOrder.fromMap(orderData);
                return OrderCard(
                  order: order,
                  // onTap: () {
                  //   navigateToOrderDetails(order);
                  // },
                );
              },
            );
          }
        },
      ),
    );
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
        'My Orders',
        style: TextStyle(color: Colors.black), // Set text color to black
      ),
      actions: [
        buildProfileButton(),
      ],
    );
  }
  Widget buildProfileButton() {
    return _auth.currentUser == null
        ? TextButton.icon(
            onPressed: () {
              navigateToLogin();
            },
            icon: const Icon(Icons.login, color: Colors.black),
            label: const Text('Login', style: TextStyle(color: Colors.black)),
          )
        : IconButton(
            onPressed: () {
              navigateToProfile();
            },
            padding: const EdgeInsets.only(right: appPading),
            icon: const Icon(CupertinoIcons.person_alt_circle_fill,
                color: Colors.black, size: 35),
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

  void navigateToHome() {
    Navigator.pushNamed(context, 'bottomNav');
  }

  void navigateToAppInfo() {
    Navigator.pushNamed(context, 'appInfo');
    print('Navigate to app info');
  }

  void navigateToInviteFriends() {
    Navigator.pushNamed(context, 'inviteFriends');
    print('Navigate to invite friends');
  }

  void navigateToPolicies() {
    Navigator.pushNamed(context, 'policies');
    print('Navigate to policies');
  }

  void navigateToHelpAndSupport() {
    Navigator.pushNamed(context, 'helpAndSupport');
    print('Navigate to help and support');
  }

  void logout() async {
    await _auth.signOut();
    print('User signed out');
    Navigator.pushReplacementNamed(context, 'register');
  }

  void navigateToOrderDetails(UserOrder order) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderDetailsScreen(order: order)));
  }
}
