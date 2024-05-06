import 'package:flutter/material.dart';

class UploadImageButton extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final bool isSelected;
  const UploadImageButton({
    super.key,
    this.onPressed,
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 40,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: isSelected ? Colors.green : Colors.orange,
      textColor: Colors.white,
      onPressed: onPressed,
      child: Text(title),
    );
  }
}
