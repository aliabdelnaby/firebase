import 'package:firebase_app/features/categories/widgets/custom_add_text_field.dart';
import 'package:firebase_app/features/categories/widgets/custom_button_category.dart';
import 'package:flutter/material.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> addCategoryformKey = GlobalKey<FormState>();

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
            AddCategoryButton(
              onPressed: () {
                if (addCategoryformKey.currentState!.validate()) {}
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
