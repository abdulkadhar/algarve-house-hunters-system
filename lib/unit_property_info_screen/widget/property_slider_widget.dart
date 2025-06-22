import 'package:algarve_house_hunters_system/login_screen/widgets/navigation_control_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class PropertySliderWidget extends StatefulWidget {
  final List<String> imagePaths;
  const PropertySliderWidget({
    super.key,
    required this.imagePaths,
  });

  @override
  State<PropertySliderWidget> createState() => _PropertySliderWidgetState();
}

class _PropertySliderWidgetState extends State<PropertySliderWidget> {
  int _currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: const Radius.circular(20),
        topRight: const Radius.circular(20),
      ),
      child: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.4,
        child: Stack(
          children: [
            CarouselSlider.builder(
              itemCount: widget.imagePaths.length,
              carouselController: _controller,
              itemBuilder: (context, index, realIdx) {
                final item = widget.imagePaths[index];
                return Container(
                  width: double.infinity,
                  height: size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(item),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: size.height,
                viewportFraction: 1.0,
                autoPlay: true,
                enableInfiniteScroll: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
            // Navigation buttons at bottom-right
            Positioned(
              bottom: 20,
              right: 20,
              child: Row(
                children: [
                  NavigationControlWidget(
                    iconData: Icons.arrow_back,
                    onPress: () => _controller.previousPage(),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  NavigationControlWidget(
                    iconData: Icons.arrow_forward,
                    onPress: () => _controller.nextPage(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
