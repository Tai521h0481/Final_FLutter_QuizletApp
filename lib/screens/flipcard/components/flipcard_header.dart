import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:shop_app/screens/flipcard/components/buildCard.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Header extends StatelessWidget {
  final PageController pageController;
  final int currentPage;
  final List<dynamic> vocabularies; // Add this line

  const Header({
    Key? key, 
    required this.pageController,
    required this.currentPage,
    required this.vocabularies, // Add this line
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 250,
          child: PageView.builder(
            controller: pageController,
            itemCount: vocabularies.length,
            itemBuilder: (context, index) {
              var vocabulary = vocabularies[index];
              String frontText = vocabulary['englishWord'];
              String backText = vocabulary['vietnameseWord'];

              return AnimatedBuilder(
                animation: pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (pageController.hasClients && pageController.position.haveDimensions) {
                    value = pageController.page! - index;
                    value = (1 - (value.abs() * 0.3)).clamp(0.1, 1.0);
                  }
                  return Center(
                    child: SizedBox(
                      height: Curves.easeOut.transform(value) * 200,
                      width: Curves.easeOut.transform(value) * 450,
                      child: child,
                    ),
                  );
                },
                child: FlipCard(
                  direction: FlipDirection.VERTICAL,
                  front: buildCard(frontText),
                  back: buildCard(backText),
                ),
              );
            },
          ),
        ),
        SmoothPageIndicator(
          controller: pageController,
          count: vocabularies.length,
          effect: const ScrollingDotsEffect(
            activeDotScale: 1.5,
            radius: 8,
            spacing: 6,
            dotWidth: 6,
            dotHeight: 6,
            paintStyle: PaintingStyle.fill,
            strokeWidth: 1.5,
            dotColor: Colors.grey,
            activeDotColor: Colors.blue
          ),
        ),
      ],
    );
  }
}
