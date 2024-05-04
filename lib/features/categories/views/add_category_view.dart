import 'package:firebase_app/features/categories/widgets/custom_add_text_field.dart';
import 'package:firebase_app/features/categories/widgets/custom_button_category.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> addCategoryformKey = GlobalKey<FormState>();
  bool isLoading = false;

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
              child: AddCategortyTextFormField(
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
