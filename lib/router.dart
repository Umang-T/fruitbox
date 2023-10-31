import 'package:flutter/material.dart';
import 'package:fruitbox/features/auth/screens/auth_otp.dart';
import 'package:fruitbox/features/auth/screens/auth_register.dart';
import 'package:fruitbox/common/widget/bottom_navbar.dart';
import 'features/home/screens/edit_user_details.dart';
import 'features/auth/screens/enter_user_details.dart';
import 'features/home/screens/Orders.dart';
import 'features/home/screens/cart.dart';
import 'features/home/screens/inbox.dart';
import 'features/home/screens/profile.dart';
import 'features/home/screens/setting.dart';
import 'features/home/screens/home.dart';

class Router {
  static const String register = 'register';
  static const String otp = 'otp';
  static const String home = 'home';
  static const String bottomNav = 'bottomNav';
  static const String enterUserDetails = 'enterUserDetails';
  static const String editUserDetails = 'editUserDetails';
  static const String cart = 'cart';
  static const String inbox = 'inbox';
  static const String orders = 'orders';
  static const String setting = 'setting';
  static const String profile = 'profile';


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case register:
        return MaterialPageRoute(builder: (_) => const Register());
      case otp:
        return MaterialPageRoute(builder: (_) => const OTPScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const Home());
      case bottomNav:
        return MaterialPageRoute(builder: (_) => const NavigationScreen());
      case enterUserDetails:
        return MaterialPageRoute(builder: (_) => const EnterUserDetails());
      case editUserDetails:
        return MaterialPageRoute(builder: (_) => const EditUserDetails());
      case cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case inbox:
        return MaterialPageRoute(builder: (_) => const InboxScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case orders:
        return MaterialPageRoute(builder: (_) => const OrdersScreen());
      case setting:
        return MaterialPageRoute(builder: (_) => const SettingScreen());
      default:
        return MaterialPageRoute(builder: (_) => const Scaffold());
    }
  }
}
