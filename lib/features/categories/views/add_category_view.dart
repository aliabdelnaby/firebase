import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_add_text_field.dart';
import '../widgets/custom_button_category.dart';

class AddCategoryView extends StatefulWidget {
  const AddCategoryView({super.key});

  @override
  State<AddCategoryView> createState() => _AddCategoryViewState();
}

class _AddCategoryViewState extends State<AddCategoryView> {
  TextEditingController name = TextEditingController();
  GlobalKey<FormState> addCategoryformKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  Future<void> addCategory() {
    return categories.add(
      {
        'name': name.text,
        'id': FirebaseAuth.instance.currentUser!.uid,
      },
    ).then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Category Added'),
            backgroundColor: Colors.orange,
          ),
        );
        Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
      },
    ).catchError(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
      ),
      body: Form(
        key: addCategoryformKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: CategortyTextFormField(
                hinttext: "Name",
                mycontroller: name,
              ),
            ),
            const SizedBox(height: 10),
            isLoading
                ? const CircularProgressIndicator(
                    color: Colors.orange,
                  )
                : AddCategoryButton(
                    onPressed: () async {
                      if (addCategoryformKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        await addCategory();
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    title: "Add",
                  ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
