import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fruitbox/router.dart' as custom_router;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const firebaseOptions = FirebaseOptions(
      apiKey: 'AIzaSyAfG7W_M-PdeECHtdEMYFgFgNBlzkz26ic',
      authDomain: 'fruitbox-4bb62.firebaseapp.com',
      databaseURL:
      'https://fruitbox-4bb62-default-rtdb.asia-southeast1.firebasedatabase.app',
      projectId: 'fruitbox-4bb62',
      storageBucket: 'fruitbox-4bb62.appspot.com',
      messagingSenderId: '573217921792',
      appId: '1:573217921792:web:1d4922b09de944202af1e5',
      measurementId: 'G-GDDE3DRLH1');
  await Firebase.initializeApp(options: firebaseOptions);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: user != null ? 'home' : 'register',
      onGenerateRoute: custom_router.Router.generateRoute,
    );
  }

}