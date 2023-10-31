import 'package:flutter/material.dart';

class GlobalVariables {
  // COLORS
  static const appBarGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 253, 250, 1),
      Color.fromARGB(255, 149, 2, 1),
    ],
    stops: [0.5, 1.0],
  );

  static const secondaryColor = Color(0xffFFC201);
  static const backgroundColor = Colors.white;
  static const Color greyBackgroundColor = Color(0xffebecee);
  static const selectedNavBarColor = Color(0xffE7E7E7);

  // STATIC IMAGES
  static final assets = Asset();



}

class Asset {
  final  welcome_img = "assets/images/delivery.png";
  final  cat_01 = "assets/images/cat1.png";
}

// Padding
const double appPading=20.0;