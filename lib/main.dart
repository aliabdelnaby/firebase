import 'package:firebase_app/core/functions/auth_check_state.dart';
import 'package:firebase_app/features/auth/login.dart';
import 'package:firebase_app/features/auth/sign_up.dart';
import 'package:firebase_app/core/firebase_options.dart';
import 'package:firebase_app/features/home/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  checkStateChanges();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Login(),
      routes: {
        "signup": (context) => const SignUp(),
        "login": (context) => const Login(),
        "home": (context) => const HomePage(),
      },
    );
  }
}
