import 'package:flutter/material.dart';

class GalleryGridSecondaryImageContainer extends StatelessWidget {
  final String imagePath;
  const GalleryGridSecondaryImageContainer(
      {super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width * 0.5) * 0.27,
      height: ((MediaQuery.of(context).size.height * 0.86) * 0.5) * 0.47,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imagePath),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
