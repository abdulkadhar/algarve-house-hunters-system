import 'package:flutter/material.dart';

class GalleryGridMainImageContainer extends StatelessWidget {
  final String imagePath;
  const GalleryGridMainImageContainer({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width * 0.5) * 0.7,
      height: (MediaQuery.of(context).size.height * 0.86) * 0.5,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imagePath),
          fit: BoxFit.cover,
        ),
        color: Colors.grey,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
