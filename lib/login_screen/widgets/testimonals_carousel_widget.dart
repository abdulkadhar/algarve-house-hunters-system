import 'package:algarve_house_hunters_system/assets_controller.dart';
import 'package:algarve_house_hunters_system/login_screen/widgets/navigation_control_widget.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TestimonialCarousel extends StatefulWidget {
  const TestimonialCarousel({super.key});

  @override
  State<TestimonialCarousel> createState() => _TestimonialCarouselState();
}

class _TestimonialCarouselState extends State<TestimonialCarousel> {
  int _currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  final List<Map<String, String>> testimonials = [
    {
      "name": "John Doe",
      "feedback": "This platform made renting so seamless!",
      "image": AssetsController.propertyCarouselImgPath[0],
      "clientDesignation": "Sr. Software Engineer"
    },
    {
      "name": "Jane Smith",
      "feedback": "Effortless property management at its best.",
      "image": AssetsController.propertyCarouselImgPath[1],
      "clientDesignation": "Sr. Software Engineer"
    },
    {
      "name": "Ali Khan",
      "feedback": "Loved the interface and support!",
      "image": AssetsController.propertyCarouselImgPath[2],
      "clientDesignation": "Sr. Software Engineer"
    },
  ];

  @override
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.5,
      height: size.height,
      child: Stack(
        children: [
          CarouselSlider.builder(
            itemCount: testimonials.length,
            carouselController: _controller,
            itemBuilder: (context, index, realIdx) {
              final item = testimonials[index];
              return Container(
                width: size.width * 0.5,
                height: size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(item['image']!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '"${item['feedback']}"',
                            style: ThemeController.titleTextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "${item['name']}",
                            style: ThemeController.smallTextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "${item['clientDesignation']}",
                            style: ThemeController.smallTextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 100,
                          )
                        ],
                      ),
                    ),
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
    );
  }
}
