import 'package:firebase_app/core/functions/notification/firebase_messaging_background.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/functions/firebase/auth_check_state.dart';
import 'features/auth/views/login.dart';
import 'features/auth/views/sign_up.dart';
import 'core/firebase_options/firebase_options.dart';
import 'features/categories/views/add_category_view.dart';
import 'features/home/views/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  checkStateChanges();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.orange,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: FirebaseAuth.instance.currentUser == null
          ? const Login()
          : FirebaseAuth.instance.currentUser!.emailVerified == true
              ? const HomePage()
              : const Login(),
      routes: {
        "signup": (context) => const SignUp(),
        "login": (context) => const Login(),
        "home": (context) => const HomePage(),
        "AddCategory": (context) => const AddCategoryView(),
      },
    );
  }
}
