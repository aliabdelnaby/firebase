import 'package:firebase_app/features/categories/widgets/custom_add_text_field.dart';
import 'package:firebase_app/features/categories/widgets/custom_button_category.dart';
import 'package:firebase_app/features/notes/views/note_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddNoteView extends StatefulWidget {
  const AddNoteView({super.key, required this.docId});
  final String docId;

  @override
  State<AddNoteView> createState() => _AddCategoryViewState();
}

class _AddCategoryViewState extends State<AddNoteView> {
  TextEditingController note = TextEditingController();
  GlobalKey<FormState> categoryNoteformKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  void dispose() {
    note.dispose();
    super.dispose();
  }

  Future<void> addCategory() {
    CollectionReference collectionNote = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.docId)
        .collection('note');

    return collectionNote.add(
      {
        'note': note.text,
      },
    ).then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note Added'),
            backgroundColor: Colors.orange,
          ),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => NoteView(
              categoryId: widget.docId,
            ),
          ),
          (route) => false,
        );
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
        title: const Text('Add Note'),
      ),
      body: Form(
        key: categoryNoteformKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: CategortyTextFormField(
                hinttext: "Enter your note",
                mycontroller: note,
              ),
            ),
            const SizedBox(height: 10),
            isLoading
                ? const CircularProgressIndicator(
                    color: Colors.orange,
                  )
                : AddCategoryButton(
                    onPressed: () async {
                      if (categoryNoteformKey.currentState!.validate()) {
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
