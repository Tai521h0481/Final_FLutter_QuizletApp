import 'package:flutter/material.dart';
import 'package:shop_app/screens/flipcard/flipcard_screen.dart';
// import 'package:shop_app/screens/products/products_screen.dart';

import 'section_title.dart';

class SpecialOffers extends StatelessWidget {
  const SpecialOffers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Sets",
            press: () {},
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SpecialOfferCard(
                image:
                    "https://s.gravatar.com/avatar/3438c2ed73b30d9314358437c0115705?s=100&r=x&d=retro",
                title: "Smartphone",
                words: 18,
                name: "asfag",
                press: () {
                  Navigator.pushNamed(context, FlipCardScreen.routeName);
                },
              ),
              SpecialOfferCard(
                image:
                    "https://s.gravatar.com/avatar/3438c2ed73b30d9314358437c0115705?s=100&r=x&d=retro",
                title: "Fashion",
                words: 24,
                name: "abcacs",
                press: () {
                  Navigator.pushNamed(context, FlipCardScreen.routeName);
                },
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
    required this.title,
    required this.image,
    required this.words,
    required this.press,
    required this.name,
  }) : super(key: key);

  final String title, image, name;
  final int words;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: 242,
          height: 110,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.withOpacity(0.2),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.purple.withOpacity(0.1),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "$words terms",
                            style: const TextStyle(
                                color: Color.fromARGB(255, 72, 71, 71),
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundImage: NetworkImage(image),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        name,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 73, 73, 73),
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
