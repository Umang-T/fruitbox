import 'package:flutter/material.dart';
import 'package:fruitbox/features/auth/screens/auth_otp.dart';
import 'package:fruitbox/features/auth/screens/auth_register.dart';
import 'package:fruitbox/common/widget/bottom_navbar.dart';
import 'features/home/screens/appInfo.dart';
import 'features/home/screens/edit_user_details.dart';
import 'features/auth/screens/enter_user_details.dart';
import 'features/home/screens/helpAndSupport.dart';
import 'features/home/screens/inviteFriends.dart';
import 'features/home/screens/orders_screen.dart';
import 'features/home/screens/cart.dart';
import 'features/home/screens/inbox.dart';
import 'features/home/screens/profile.dart';
import 'features/home/screens/setting.dart';
import 'features/home/screens/policies.dart';

class Router {
  static const String register = 'register';
  static const String otp = 'otp';
  static const String bottomNav = 'bottomNav'; //home
  static const String enterUserDetails = 'enterUserDetails';
  static const String editUserDetails = 'editUserDetails';
  static const String cart = 'cart';
  static const String inbox = 'inbox';
  static const String orders = 'orders';
  static const String setting = 'setting';
  static const String profile = 'profile';
  static const String appInfo = 'appInfo'; // New routes
  static const String inviteFriends = 'inviteFriends';
  static const String policies = 'policies';
  static const String helpAndSupport = 'helpAndSupport';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case register:
        return MaterialPageRoute(builder: (_) => const Register());
      case otp:
        return MaterialPageRoute(builder: (_) => const OTPScreen());
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
      case appInfo:
        return MaterialPageRoute(builder: (_) => const AppInfoScreen());
      case inviteFriends:
        return MaterialPageRoute(builder: (_) => const InviteFriendsScreen());
      case policies:
        return MaterialPageRoute(builder: (_) => const PoliciesScreen());
      case helpAndSupport:
        return MaterialPageRoute(builder: (_) => const HelpAndSupportScreen());
      default:
        return MaterialPageRoute(builder: (_) => const Scaffold());
    }
  }
}
