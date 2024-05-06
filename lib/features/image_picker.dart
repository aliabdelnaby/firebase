import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerView extends StatefulWidget {
  const ImagePickerView({super.key});

  @override
  State<ImagePickerView> createState() => _ImagePickerViewState();
}

class _ImagePickerViewState extends State<ImagePickerView> {
  File? file;
  getImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      file = File(image.path);
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
          if (file != null)
            Center(
              child: Image.file(
                file!,
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
