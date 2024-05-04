import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List data = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    data.addAll(querySnapshot.docs);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("AddCategory");
        },
        tooltip: "Add Category",
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Firebase Install'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              GoogleSignIn googleSignIn = GoogleSignIn();
              googleSignIn.disconnect();
              Navigator.of(context).pushReplacementNamed("login");
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 200,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Card(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Image.network(
                    "https://assets.dryicons.com/uploads/icon/preview/1139/large_1x_folder.png",
                    height: 120,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    data[index]["name"],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
