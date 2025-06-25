import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class GalleryGridCountContainer extends StatelessWidget {
  final String imagePaths;
  final int count;
  const GalleryGridCountContainer({
    super.key,
    required this.imagePaths,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: (MediaQuery.of(context).size.width * 0.5) * 0.27,
        height: ((MediaQuery.of(context).size.height * 0.86) * 0.5) * 0.47,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                imagePaths,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  '+${(count - 2).toString()}',
                  style: ThemeController.smallTextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
