import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:g_final_project/firebase/fb_auth_controller.dart';
import 'package:g_final_project/screens/home.dart';
import 'package:g_final_project/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Provider.debugCheckInvalidValueType = null;

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FbAuthController().loggedIn ? const HomePage() : const LoginPage(),
    );
  }
}
