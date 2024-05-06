import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_app/features/notes/widgets/custom_add_image_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../../categories/widgets/custom_add_text_field.dart';
import '../../categories/widgets/custom_button_category.dart';
import 'note_view.dart';
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
  File? file;
  String? url;

  Future<void> addNote(context) async {
    CollectionReference collectionNote = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.docId)
        .collection('note');

    return collectionNote.add(
      {
        'note': note.text,
        'image': url ?? 'none',
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

  getImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      file = File(image.path);
      var imageName = basename(image.path);
      var refStorage = FirebaseStorage.instance.ref("images").child(imageName);
      await refStorage.putFile(file!);
      url = await refStorage.getDownloadURL();
    }

    setState(() {});
  }

  @override
  void dispose() {
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
      ),
      body: Form(
        key: categoryNoteformKey,
        child: ListView(
          children: [
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  child: CategortyTextFormField(
                    hinttext: "Enter your note",
                    mycontroller: note,
                  ),
                ),
                const SizedBox(height: 10),
                UploadImageButton(
                  onPressed: () async {
                    await getImage();
                  },
                  title: "Upload Image",
                  isSelected: url == null ? false : true,
                ),
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
                            await addNote(context);
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        title: "Add Note",
                      ),
                const SizedBox(height: 20),
                if (url != null)
                  CachedNetworkImage(
                    imageUrl: url!,
                    placeholder: (context, url) =>
                        const CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.hide_image_rounded),
                    fit: BoxFit.cover,
                    height: 200,
                    width: 200,
                  ),
                if (url == null) const Text("No Image uploaded"),
                const SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
