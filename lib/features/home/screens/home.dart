// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fruitbox/features/home/screens/search_box.dart';
import '../../../common/widget/category_widget.dart';
import '../../../common/widget/card.dart';
import '../../../constants/global_variables.dart';
import '../../user/models/category_model.dart';
import '../../user/models/product_model.dart';
import 'address_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime? currentBackPressTime;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late ScrollController _homeScrollController;
  final TextEditingController _locationController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _homeScrollController = ScrollController();
  }

  @override
  void dispose() {
    _homeScrollController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvoked: (bool didPop) async {
          final now = DateTime.now();
          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime!) >
                  const Duration(seconds: 2)) {
            currentBackPressTime = now;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Press back again to exit'),
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
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
            title: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddressPage(),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.grey[200],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: const Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.black),
                    Expanded(
                      child: Text(
                        'Search Location',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
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
                    Navigator.pushNamed(context, 'bottomNav');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info, color: Colors.black),
                  title: const Text(
                    'App Info',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    showComingSoonSnackbar(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.group, color: Colors.black),
                  title: const Text(
                    'Invite Friends',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    showComingSoonSnackbar(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.policy, color: Colors.black),
                  title: const Text(
                    'Policies',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    showComingSoonSnackbar(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help, color: Colors.black),
                  title: const Text(
                    'Help and Support',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    showComingSoonSnackbar(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.black),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    logout(context);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
          body: SingleChildScrollView(
            controller: _homeScrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchBox(
                  onSearch: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                ),
                if (_searchQuery
                    .isEmpty) // Display categories section if no search query
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                          top: appPading,
                          left: appPading,
                          bottom: appPading,
                        ),
                        child: Text(
                          "Categories",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      CategoryWidget(scrollController: _homeScrollController),
                    ],
                  ),
                StreamBuilder<QuerySnapshot>(
                  stream: _searchQuery.isEmpty
                      ? FirebaseFirestore.instance
                          .collection('categories')
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection('products')
                          .where('name', isGreaterThanOrEqualTo: _searchQuery)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('No matching results found.'),
                      );
                    }

                    final dataList = snapshot.data!.docs.map((doc) {
                      if (_searchQuery.isEmpty) {
                        return Category.fromSnapshot(
                            doc as DocumentSnapshot<Map<String, dynamic>>);
                      } else {
                        return Product(
                          productId: doc.id,
                          categoryName: doc['category_name'],
                          description: doc['description'],
                          imageUrl: doc['imageUrl'],
                          name: doc['name'],
                          price: doc['price'],
                        );
                      }
                    }).toList();

                    // Print matching items for debugging
                    print('Matching items:');
                    for (final item in dataList) {
                      print(item.toString());
                    }

                    return Column(
                      children: dataList.map((data) {
                        if (data is Category) {
                          return FutureBuilder<bool>(
                            future: hasProductsForCategory(data.name),
                            builder: (context, productSnapshot) {
                              if (productSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }

                              return productSnapshot.data == true
                                  ? buildCategoryProducts(data)
                                  : Container();
                            },
                          );
                        } else if (data is Product) {
                          return ProductCard(product: data);
                        } else {
                          return Container(); // Return an empty container for other types of data
                        }
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }

  void showComingSoonSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Feature is coming soon!'),
      ),
    );
  }

  Widget buildCategoryProducts(Category category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: appPading, left: appPading),
          child: Text(
            category.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        PopularItemsWidget(category: category),
      ],
    );
  }

  Widget buildProfileButton() {
    return _auth.currentUser == null
        ? TextButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, 'register');
              print('Navigate to login');
            },
            icon: const Icon(Icons.login, color: Colors.black),
            label: const Text('Login', style: TextStyle(color: Colors.black)),
          )
        : IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'profile');
              print('Navigate to profile');
            },
            padding: const EdgeInsets.only(right: appPading),
            icon: const Icon(CupertinoIcons.person_alt_circle_fill,
                color: Colors.black, size: 35),
          );
  }

  void checkSignInStatus() {
    if (_auth.currentUser != null) {
      print('User is signed in');
    } else {
      print('User is not signed in');
    }
  }

  void logout(BuildContext context) {
    _auth.signOut().then((_) {
      print('User signed out');
      Navigator.pushReplacementNamed(context, 'register');
    }).catchError((error) {
      print('Error signing out: $error');
    });
  }

  Future<bool> hasProductsForCategory(String categoryName) {
    return FirebaseFirestore.instance
        .collection('products')
        .where('category_name', isEqualTo: categoryName)
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) {
      return snapshot.docs.isNotEmpty;
    }).catchError((error) {
      print('Error checking products: $error');
      return false;
    });
  }
}
