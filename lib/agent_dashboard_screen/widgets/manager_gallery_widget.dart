import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/gallery_grid_count_container.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/gallery_grid_main_image_container.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/gallery_grid_secondary_image_container.dart';
import 'package:flutter/material.dart';

class ManagerGalleryWidget extends StatelessWidget {
  final List<dynamic> imagePaths;
  final double width;
  const ManagerGalleryWidget({
    super.key,
    required this.imagePaths,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GalleryGridMainImageContainer(
          imagePath: imagePaths[0],
          width: width,
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
              imagePaths: imagePaths[2],
              count: imagePaths.length,
            )
          ],
        )
      ],
    );
  }
}
