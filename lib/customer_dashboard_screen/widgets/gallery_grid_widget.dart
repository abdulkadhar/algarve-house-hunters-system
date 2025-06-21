import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/gallery_grid_count_container.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/gallery_grid_main_image_container.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/gallery_grid_secondary_image_container.dart';
import 'package:flutter/material.dart';

class GalleryGridWidget extends StatelessWidget {
  final List<String> imagePaths;
  const GalleryGridWidget({
    super.key,
    required this.imagePaths,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GalleryGridMainImageContainer(
          imagePath: imagePaths.first,
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          children: [
            GalleryGridSecondaryImageContainer(
              imagePath: imagePaths[1],
            ),
            const SizedBox(
              height: 10,
            ),
            GalleryGridCountContainer(
              imagePaths: imagePaths,
            )
          ],
        )
      ],
    );
  }
}
