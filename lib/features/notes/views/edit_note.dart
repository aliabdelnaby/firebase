import 'package:firebase_app/features/categories/widgets/custom_add_text_field.dart';
import 'package:firebase_app/features/categories/widgets/custom_button_category.dart';
import 'package:firebase_app/features/notes/views/note_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateNoteView extends StatefulWidget {
  const UpdateNoteView({
    super.key,
    required this.noteDocId,
    required this.categoryDocId,
    required this.oldNote,
  });

  final String noteDocId;
  final String categoryDocId;
  final String oldNote;

  @override
  State<UpdateNoteView> createState() => _AddCategoryViewState();
}

class _AddCategoryViewState extends State<UpdateNoteView> {
  TextEditingController note = TextEditingController();
  GlobalKey<FormState> updateNoteformKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  void initState() {
    note.text = widget.oldNote;
    super.initState();
  }

  @override
  void dispose() {
    note.dispose();
    super.dispose();
  }

  Future<void> updateNote() async {
    CollectionReference collectionNote = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryDocId)
        .collection('note');

    return collectionNote.doc(widget.noteDocId).update(
      {
        'note': note.text,
      },
    ).then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note Updated'),
            backgroundColor: Colors.orange,
          ),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => NoteView(
              categoryId: widget.categoryDocId,
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
        title: const Text('Update Note'),
      ),
      body: Form(
        key: updateNoteformKey,
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
                      if (updateNoteformKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        await updateNote();
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
