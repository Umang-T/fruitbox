import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants/global_variables.dart';
import '../../features/home/screens/home.dart';
import '../../features/home/screens/orders_screen.dart';
import '../../features/home/screens/setting.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int pageIndex = 0;

  List<Widget> pages = [
    const Home(),
    const OrdersScreen(),
    const SettingScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: pageIndex,
          children: pages,
        ),
        floatingActionButton: SafeArea(
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, 'cart');
            },
            backgroundColor: GlobalVariables.secondaryColor,
            child: const Icon(
              Icons.add_shopping_cart_rounded,
              size: 20,
            ),
          ), //cart icon
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar(
            icons: const [
              CupertinoIcons.home,
              CupertinoIcons.doc_plaintext,
            ],
            inactiveColor: Colors.black,
            activeColor: GlobalVariables.secondaryColor,
            gapLocation: GapLocation.center,
            activeIndex: pageIndex,
            notchSmoothness: NotchSmoothness.softEdge,
            leftCornerRadius: 10,
            iconSize: 37,
            rightCornerRadius: 10,
            elevation: 5,
            onTap: (index) {
              setState(() {
                pageIndex = index;
              });
            }));
  }
}
