// ignore_for_file: use_build_context_synchronously

import 'package:firebase_app/core/components/custom_button_auth.dart';
import 'package:firebase_app/core/components/custom_logo_auth.dart';
import 'package:firebase_app/core/components/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> loginFormkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Form(
              key: loginFormkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 50),
                  const CustomLogoAuth(),
                  Container(height: 20),
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(height: 10),
                  const Text(
                    "Login To Continue Using The App",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Container(height: 20),
                  const Text(
                    "Email",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Container(height: 10),
                  CustomTextForm(
                    hinttext: "ُEnter Your Email",
                    mycontroller: email,
                  ),
                  Container(height: 10),
                  const Text(
                    "Password",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Container(height: 10),
                  CustomTextForm(
                    hinttext: "ُEnter Your Password",
                    mycontroller: password,
                  ),
                  GestureDetector(
                    onTap: () async {
                      try {
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: email.text,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Check Your Email",
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } on FirebaseAuthException {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Enter Valid Email"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 20),
                      alignment: Alignment.topRight,
                      child: const Text(
                        "Forgot Password ?",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustomButtonAuth(
              title: "login",
              onPressed: () async {
                if (loginFormkey.currentState!.validate()) {
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email.text,
                      password: password.text,
                    );
                    if (FirebaseAuth.instance.currentUser!.emailVerified ==
                        true) {
                      Navigator.of(context).pushReplacementNamed("home");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Welcome Back'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please verify your email"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } on FirebaseAuthException catch (e) {
                    _signInHandleException(e, context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          e.toString(),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
            Container(height: 20),
            MaterialButton(
              onPressed: () async {
                await signInWithGoogle();
              },
              height: 40,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.red[700],
              textColor: Colors.white,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Login With Google  "),
                  Icon(
                    FontAwesomeIcons.google,
                    size: 18,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
            Container(height: 20),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed("signup");
              },
              child: const Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Don't Have An Account ? ",
                      ),
                      TextSpan(
                        text: "Register",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _signInHandleException(FirebaseAuthException e, BuildContext context) {
    if (e.code == 'user-not-found') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No user found for that email.'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (e.code == 'wrong-password') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wrong password provided for that user.'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Check your Email and password!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    //* Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    //* Check if user is signed in
    if (googleUser == null) {
      return;
    }

    //* Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    //* Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    //* Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushReplacementNamed("home");
    
  }
}
