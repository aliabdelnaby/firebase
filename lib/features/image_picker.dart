import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ImagePickerView extends StatefulWidget {
  const ImagePickerView({super.key});

  @override
  State<ImagePickerView> createState() => _ImagePickerViewState();
}

class _ImagePickerViewState extends State<ImagePickerView> {
  File? file;
  String? url;
  getImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      file = File(image.path);
      var imageName = basename(image.path);
      var refStorage = FirebaseStorage.instance.ref(imageName);
      await refStorage.putFile(file!);
      url = await refStorage.getDownloadURL();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 350,
          ),
          ElevatedButton(
            onPressed: () async {
              await getImage();
            },
            child: const Text("Pick Image"),
          ),
          if (url != null)
            Center(
              child: Image.network(
                url!,
                fit: BoxFit.cover,
                height: 300,
                width: 300,
              ),
            ),
        ],
      ),
    );
  }
}
