import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fruitbox/router.dart' as custom_router;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const firebaseOptions = FirebaseOptions(
      apiKey: '',
      authDomain: 'fruitbox-4bb62.firebaseapp.com',
      databaseURL:
      'https://fruitbox-4bb62-default-rtdb.asia-southeast1.firebasedatabase.app',
      projectId: 'fruitbox-4bb62',
      storageBucket: 'fruitbox-4bb62.appspot.com',
      messagingSenderId: '573217921792',
      appId: '1:573217921792:web:1d4922b09de944202af1e5',
      measurementId: 'G-GDDE3DRLH1');
  try {
    await Firebase.initializeApp(options: firebaseOptions);
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  // Stripe.publishableKey='pk_test_51OK2OnSAyMVcDGnzXdMy6QHySf4S8FwT617wfi6tQp2YvRepdLeT90ntbp5bWW2XlmwfNUAz9WLb73BEXz0Gl2pK00gao014IJ';
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: user != null ? 'bottomNav' : 'register',
      onGenerateRoute: custom_router.Router.generateRoute,
    );
  }
}
