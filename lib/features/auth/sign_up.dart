// ignore_for_file: use_build_context_synchronously
import 'package:firebase_app/core/components/custom_button_auth.dart';
import 'package:firebase_app/core/components/custom_logo_auth.dart';
import 'package:firebase_app/core/components/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> signUpFormkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Form(
              key: signUpFormkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 50),
                  const CustomLogoAuth(),
                  Container(height: 20),
                  const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(height: 10),
                  const Text(
                    "Sign Up To Continue Using The App",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Container(height: 20),
                  const Text(
                    "username",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Container(height: 10),
                  CustomTextForm(
                    hinttext: "ُEnter Your username",
                    mycontroller: username,
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
            CustomButtonAuth(
              title: "SignUp",
              onPressed: () async {
                if (signUpFormkey.currentState!.validate()) {
                  try {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email.text,
                      password: password.text,
                    );
                    Navigator.of(context).pushReplacementNamed("login");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Sign Up Successfully, Check your email",
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                    await FirebaseAuth.instance.currentUser!
                        .sendEmailVerification();
                    await FirebaseAuth.instance.signOut();
                  } on FirebaseAuthException catch (e) {
                    _signUpHandleException(e, context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 40),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed("login");
              },
              child: const Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Have An Account ? ",
                      ),
                      TextSpan(
                        text: "Login",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _signUpHandleException(FirebaseAuthException e, BuildContext context) {
    if (e.code == 'weak-password') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The password provided is too weak.'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (e.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("The account already exists for that email."),
          backgroundColor: Colors.red,
        ),
      );
    } else if (e.code == 'invalid-email') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("The email is invalid."),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
