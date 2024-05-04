import 'package:flutter/material.dart';

class CustomLogoAuth extends StatelessWidget {
  const CustomLogoAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: 80,
        height: 80,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          // color: Colors.grey[200],
          borderRadius: BorderRadius.circular(70),
        ),
        child: Image.network(
          "https://banner2.cleanpng.com/20190430/iwj/kisspng-clip-art-post-it-note-portable-network-graphics-ve-sticky-notes-doodle-transparent-png-amp-svg-ve-5cc8180bede484.2319685415566172279744.jpg",
          height: 40,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
