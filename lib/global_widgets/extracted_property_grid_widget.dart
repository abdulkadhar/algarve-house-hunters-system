import 'package:flutter/material.dart';

class PropertyImageGrid extends StatelessWidget {
  final List<String> imageUrls;
  final Function(int)? onDelete;

  const PropertyImageGrid({
    super.key,
    required this.imageUrls,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) {
      return const Center(
        child: Text(
          "No images available",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(), // so it can sit inside a scroll view
      itemCount: imageUrls.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6, // number of columns
        crossAxisSpacing: 8.0, // spacing between columns
        mainAxisSpacing: 8.0, // spacing between rows
        childAspectRatio: 1, // square cells
      ),
      itemBuilder: (context, index) {
        final url = imageUrls[index];
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                url,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                right: 10,
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    if (onDelete != null) {
                      onDelete!(index);
                    }
                  },
                  child: const Icon(
                    Icons.delete,
                    color: Colors.grey,
                    size: 16,
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
