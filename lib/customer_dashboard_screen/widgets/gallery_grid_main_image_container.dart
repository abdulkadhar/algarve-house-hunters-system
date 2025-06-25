import 'package:flutter/material.dart';

class GalleryGridMainImageContainer extends StatelessWidget {
  final String imagePath;
  final double width;
  const GalleryGridMainImageContainer({
    super.key,
    required this.imagePath,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
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
