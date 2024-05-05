// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/features/categories/views/update_category_view.dart';
import 'package:firebase_app/features/notes/views/note_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<QueryDocumentSnapshot> data = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where(
          'id',
          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
        )
        .get();
    data.addAll(querySnapshot.docs);
    isLoading = false;
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
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: const Text('Firebase App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                GoogleSignIn googleSignIn = GoogleSignIn();
                Navigator.of(context).pushReplacementNamed("login");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("You are logged out"),
                  ),
                );
                await FirebaseAuth.instance.signOut();
                await googleSignIn.signOut();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Error signing out: $e"),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 270,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return UpdateCategoryView(
                            docId: data[index].id,
                            oldName: data[index]["name"],
                          );
                        },
                      ),
                    );
                  },
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Image.network(
                            "https://assets.dryicons.com/uploads/icon/preview/1139/large_1x_folder.png",
                            height: 120,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            data[index]["name"],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return NoteView(
                                          categoryId: data[index].id,
                                        );
                                      },
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.info_outline_rounded,
                                  color: Colors.red,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    "home",
                                    (route) => false,
                                  );
                                  await FirebaseFirestore.instance
                                      .collection("categories")
                                      .doc(data[index].id)
                                      .delete();
                                },
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
