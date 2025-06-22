import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class PropertyInfoCarousel extends StatefulWidget {
  final List<String> imagePaths;
  const PropertyInfoCarousel({
    super.key,
    required this.imagePaths,
  });

  @override
  State<PropertyInfoCarousel> createState() => _PropertyInfoCarouselState();
}

class _PropertyInfoCarouselState extends State<PropertyInfoCarousel> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CarouselSlider(
              items: widget.imagePaths
                  .map((item) => Image.network(
                        item,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ))
                  .toList(),
              carouselController: _controller,
              options: CarouselOptions(
                autoPlay: true,
                height: 250,
                enlargeCenterPage: true,
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
