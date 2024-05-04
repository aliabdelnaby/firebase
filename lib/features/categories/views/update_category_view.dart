import 'package:firebase_app/features/categories/widgets/custom_add_text_field.dart';
import 'package:firebase_app/features/categories/widgets/custom_button_category.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateCategoryView extends StatefulWidget {
  const UpdateCategoryView({
    super.key,
    required this.docId,
    required this.oldName,
  });

  final String docId, oldName;

  @override
  State<UpdateCategoryView> createState() => _AddCategoryViewState();
}

class _AddCategoryViewState extends State<UpdateCategoryView> {
  TextEditingController name = TextEditingController();
  GlobalKey<FormState> updateCategoryformKey = GlobalKey<FormState>();
  bool isLoading = false;

  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  Future<void> updateCategory() {
    return categories.doc(widget.docId).update({
      'name': name.text,
    }).then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Category Updated'),
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
  void initState() {
    super.initState();
    name.text = widget.oldName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Category'),
      ),
      body: Form(
        key: updateCategoryformKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: CategortyTextFormField(
                hinttext: "New Name",
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
                      if (updateCategoryformKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        await updateCategory();
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    title: "Save",
                  ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
