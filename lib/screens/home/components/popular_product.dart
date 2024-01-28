import 'package:flutter/material.dart';
import 'package:shop_app/screens/home/components/special_folders.dart';

import '../../products/products_screen.dart';
import 'section_title.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Folders",
            press: () {
              Navigator.pushNamed(context, ProductsScreen.routeName);
            },
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SpecialFolder(
                image: "https://s.gravatar.com/avatar/3438c2ed73b30d9314358437c0115705?s=100&r=x&d=retro",
                title: "Smartphone",
                words: 18,
                name: "xinzhao",
                press: () {
                  Navigator.pushNamed(context, ProductsScreen.routeName);
                },
              ),
              SpecialFolder(
                image: "https://s.gravatar.com/avatar/3438c2ed73b30d9314358437c0115705?s=100&r=x&d=retro",
                title: "Fashion",
                words: 24,
                name: "xinzhao",
                press: () {
                  Navigator.pushNamed(context, ProductsScreen.routeName);
                },
              ),
              const SizedBox(width: 20),
            ],
          ),
        )
      ],
    );
  }
}
