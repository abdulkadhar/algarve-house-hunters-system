import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

/// Property card for the mobile "List Properties" view.
///
/// Vertical layout: hero image (or a "No Image Available" placeholder) with a
/// price pill, then name, location, feature pills, description and a
/// "View Details" action.
class MobilePropertyTileWidget extends StatelessWidget {
  final Map<String, dynamic> propertyInfo;
  final VoidCallback onViewDetailsPress;
  final VoidCallback? onImagePress;

  const MobilePropertyTileWidget({
    super.key,
    required this.propertyInfo,
    required this.onViewDetailsPress,
    this.onImagePress,
  });

  String? _bathsValue() {
    final raw = (propertyInfo["bathsNumber"] ?? '').toString();
    if (raw.isEmpty) return null;
    final n = int.tryParse(raw);
    if (n != null) return n > 0 ? n.toString() : null;
    return raw;
  }

  String? _parkingValue() {
    final raw = (propertyInfo["parking"] ?? '').toString();
    if (raw.isEmpty) return null;
    final n = int.tryParse(raw);
    if (n != null) return n > 0 ? n.toString() : null;
    return raw.toLowerCase() == 'true' ? '1' : null;
  }

  Widget _featurePill(IconData icon, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.black),
          const SizedBox(width: 8),
          Text(
            value,
            style: ThemeController.normalTextStyle(
              fontWeight: FontWeight.w800,
              size: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.home_outlined,
            size: 56,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 8),
          Text(
            "No Image Available",
            style: ThemeController.normalTextStyle(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List images = (propertyInfo["propertyImages"] as List?) ?? const [];
    final String? imageUrl =
        images.isNotEmpty ? images.first.toString() : null;
    final String name = (propertyInfo["propertyName"] ?? '').toString();
    final String location =
        (propertyInfo["propertyLocationName"] ?? '').toString();
    final String price = (propertyInfo["propertyPrice"] ?? '').toString();
    final String description =
        (propertyInfo["propertyDescription"] ?? '').toString();
    final String createdBy = (propertyInfo["createdBy"] ?? '').toString();
    final String beds = (propertyInfo["bedsNumber"] ?? '').toString();
    final String area = (propertyInfo["propertyM2"] ?? '').toString();

    // Feature pills: beds (always), baths and parking when present; fall back
    // to area when no baths/parking are available.
    final List<Widget> pills = [];
    if (beds.isNotEmpty) {
      pills.add(_featurePill(Icons.bed, beds));
    }
    final baths = _bathsValue();
    if (baths != null) {
      pills.add(_featurePill(Icons.bathtub_outlined, baths));
    }
    final parking = _parkingValue();
    if (parking != null) {
      pills.add(_featurePill(Icons.directions_car_filled_outlined, parking));
    }
    if (pills.length <= 1 && area.isNotEmpty && area != '0') {
      pills.add(_featurePill(Icons.crop_free, "$area m²"));
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // NOTE Hero image + price pill
          Stack(
            children: [
              SizedBox(
                height: 220,
                width: double.infinity,
                child: imageUrl != null
                    ? InkWell(
                        onTap: onImagePress,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              _imagePlaceholder(),
                        ),
                      )
                    : _imagePlaceholder(),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "€$price",
                    style: ThemeController.normalTextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NOTE Name + favourite
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: ThemeController.titleTextStyle(size: 22),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.favorite_border,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // NOTE Location
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        style: ThemeController.normalTextStyle(
                          color: Colors.grey.shade700,
                          size: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // NOTE Feature pills
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: pills,
                ),
                const SizedBox(height: 16),
                // NOTE Description
                if (description.isNotEmpty)
                  Text(
                    description,
                    style: ThemeController.normalTextStyle(
                      color: Colors.grey.shade700,
                      size: 15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                // NOTE Created by + View Details
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Created By",
                            style: ThemeController.smallTextStyle(
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w600,
                              size: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            createdBy,
                            style: ThemeController.normalTextStyle(
                              fontWeight: FontWeight.w900,
                              size: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: onViewDetailsPress,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          "View Details",
                          style: ThemeController.normalTextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
