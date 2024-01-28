import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:shop_app/screens/flipcard/components/buildCard.dart';

class Header extends StatelessWidget {
  final PageController pageController;
  final int currentPage;
  final List<Widget> Function(int, int) buildPageIndicators;

  const Header({super.key, 
    required this.pageController,
    required this.currentPage,
    required this.buildPageIndicators,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 250,
          child: PageView.builder(
            controller: pageController,
            itemCount: 4,
            itemBuilder: (context, index) {
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
                  front: buildCard('Front $index'),
                  back: buildCard('Back $index'),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: buildPageIndicators(currentPage, 10),
        ),
      ],
    );
  }
}
