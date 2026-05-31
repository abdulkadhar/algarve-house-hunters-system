import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

/// Mobile "Property Overview" section shown on the manager dashboard.
///
/// Renders the latest property as a stacked set of cards:
///  - a hero image card with a PREMIUM badge, location, price and quick stats
///  - a dark listing-reference card with a verified badge
///  - a coast-distance card with a progress indicator
class PropertyOverviewSection extends StatelessWidget {
  final Map<String, dynamic> propertyData;

  /// Total number of properties, shown in the header pill.
  /// When null, the pill is hidden.
  final int? totalCount;

  const PropertyOverviewSection({
    super.key,
    required this.propertyData,
    this.totalCount,
  });

  /// Fallback images shown when the property has no images of its own
  /// (mirrors the web view's behaviour).
  static const List<String> _fallbackImages = [
    "https://images.egorealestate.com/Z640x480/OAYES/S5/C2585/P27440974/TPHOTO/ID4EB7A201-0000-0500-0000-00001694FC1B.JPG",
    "https://images.egorealestate.com/Z640x480/OAYES/S5/C2585/P27440974/TPHOTO/ID4EB7A201-0000-0500-0000-000016359DAF.JPG",
    "https://images.egorealestate.com/Z640x480/OAYES/S5/C2585/P27440974/TPHOTO/ID4EB7A201-0000-0500-0000-000016945A03.JPG",
    "https://images.egorealestate.com/Z640x480/OAYES/S5/C2585/P27440974/TPHOTO/ID4EB7A201-0000-0500-0000-000016945A04.JPG",
    "https://images.egorealestate.com/Z640x480/OAYES/S5/C2585/P27440974/TPHOTO/ID4EB7A201-0000-0500-0000-000016945A05.JPG",
  ];

  @override
  Widget build(BuildContext context) {
    final List rawImages =
        (propertyData["propertyImages"] as List?) ?? const [];
    final List<String> images = rawImages.isNotEmpty
        ? rawImages.map((e) => e.toString()).toList()
        : _fallbackImages;
    final String location =
        (propertyData["propertyLocationName"] ?? '').toString();
    final String price = (propertyData["propertyPrice"] ?? '').toString();
    final String listingRef = (propertyData["listingRef"] ?? '').toString();
    final String area = (propertyData["propertyM2"] ?? '').toString();
    final String beds = (propertyData["bedsNumber"] ?? '').toString();
    final double coastDistance =
        double.tryParse((propertyData["distanceFromCoast"] ?? '0').toString()) ??
            0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // NOTE Section header
        Row(
          children: [
            Text(
              "Property Overview",
              style: ThemeController.titleTextStyle(),
            ),
            const Spacer(),
            if (totalCount != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "$totalCount total",
                  style: ThemeController.smallTextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w700,
                    size: 12,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),

        // NOTE Property card
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero image with PREMIUM badge
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      height: 230,
                      width: double.infinity,
                      child: _PropertyImageSlideshow(images: images),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "PREMIUM",
                        style: ThemeController.smallTextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          size: 12,
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
                    // Location + favourite
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 18,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  location.toUpperCase(),
                                  style: ThemeController.smallTextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w700,
                                    size: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.favorite_border,
                            size: 18,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Price
                    Text(
                      "€$price",
                      style: ThemeController.titleTextStyle(),
                    ),
                    const SizedBox(height: 16),
                    // Quick stats
                    Row(
                      children: [
                        Expanded(
                          child: _statPill(
                            icon: Icons.king_bed_outlined,
                            label: "Beds",
                            value: "$beds Rooms",
                            iconBgColor: Colors.black,
                            iconColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _statPill(
                            icon: Icons.square_foot,
                            label: "Area",
                            value: "$area m²",
                            iconBgColor: const Color(0xFF9ABAEA),
                            iconColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // NOTE Listing ref card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "LISTING REF",
                style: ThemeController.smallTextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w700,
                  size: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                listingRef,
                style: ThemeController.titleTextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Icon(
                    Icons.verified_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Verified Listing",
                    style: ThemeController.normalTextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // NOTE Coast distance card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "COAST DISTANCE",
                    style: ThemeController.smallTextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w700,
                      size: 12,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.beach_access,
                    color: Colors.black,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                "$coastDistance km",
                style: ThemeController.titleTextStyle(),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (1 - (coastDistance / 10)).clamp(0.0, 1.0),
                  minHeight: 8,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation(Colors.black),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statPill({
    required IconData icon,
    required String label,
    required String value,
    required Color iconBgColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: ThemeController.smallTextStyle(
                    color: Colors.grey.shade600,
                    size: 11,
                  ),
                ),
                Text(
                  value,
                  style: ThemeController.normalTextStyle(
                    fontWeight: FontWeight.w800,
                    size: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

/// Swipeable slideshow of property images with page-indicator dots.
class _PropertyImageSlideshow extends StatefulWidget {
  final List<String> images;

  const _PropertyImageSlideshow({required this.images});

  @override
  State<_PropertyImageSlideshow> createState() =>
      _PropertyImageSlideshowState();
}

class _PropertyImageSlideshowState extends State<_PropertyImageSlideshow> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey.shade300,
      child: Icon(
        Icons.home_outlined,
        size: 60,
        color: Colors.grey.shade600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return _placeholder();

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PageView.builder(
          controller: _controller,
          itemCount: widget.images.length,
          onPageChanged: (index) => setState(() => _currentPage = index),
          itemBuilder: (context, index) {
            return Image.network(
              widget.images[index],
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => _placeholder(),
            );
          },
        ),
        if (widget.images.length > 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  height: 8,
                  width: _currentPage == index ? 20 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
