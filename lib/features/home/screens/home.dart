// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fruitbox/features/home/screens/search_box.dart';
import '../../../common/widget/category_widget.dart';
import '../../../common/widget/card.dart';
import '../../../constants/global_variables.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime? currentBackPressTime;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          final now = DateTime.now();
          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
            currentBackPressTime = now;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Press back again to exit'),
              ),
            );
            return false;
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.black, // Set the icon color to black
                  size: 35,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // Open the drawer
                },
              ),
            ),
            actions: [
              buildProfileButton(),
            ],
          ),
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
          body: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchBox(),
                Padding(
                  padding: EdgeInsets.only(top: appPading, left: appPading),
                  child: Text(
                    "Categories",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                CategoryWidget(),

                // Popular Items
                Padding(
                  padding: EdgeInsets.only(top: appPading, left: appPading),
                  child: Text(
                    "Popular",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                // Insert ProductCard widgets here
                PopularItemsWidget(),

                Padding(
                  padding: EdgeInsets.only(top: appPading, left: appPading),
                  child: Text(
                    "Trending",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                PopularItemsWidget(),
              ],
            ),
          ),
        ));
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

  void checkSignInStatus() {
    if (_auth.currentUser != null) {
      print('User is signed in');
      // Perform actions for signed-in user
    } else {
      print('User is not signed in');
      // Perform actions for non-signed-in user, e.g., navigate to login
    }
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
    Navigator.pushReplacementNamed(context, 'home');
    print('Navigate to home');
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

  void navigateToCategory(String category) {
    Navigator.pushNamed(context, 'category', arguments: category);
    print('Navigate to category: $category');
  }

  void navigateToFruitDetails(String fruit) {
    Navigator.pushNamed(context, 'fruitDetails', arguments: fruit);
    print('Navigate to fruit details: $fruit');
  }

  void logout() async {
    await _auth.signOut();
    print('User signed out');
    Navigator.pushReplacementNamed(context, 'register');
  }
}
