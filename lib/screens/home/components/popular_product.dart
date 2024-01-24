import 'package:flutter/material.dart';
import 'package:shop_app/screens/home/components/special_offers.dart';

import '../../../components/product_card.dart';
import '../../../models/Product.dart';
import '../../details/details_screen.dart';
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
            title: "Popular Products",
            press: () {
              Navigator.pushNamed(context, ProductsScreen.routeName);
            },
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // ...List.generate(
              //   demoProducts.length,
              //   (index) {
              //     if (demoProducts[index].isPopular) {
              //       return Padding(
              //           padding: const EdgeInsets.only(left: 20),
              //           // child: ProductCard(
              //           //   product: demoProducts[index],
              //           //   onPress: () => Navigator.pushNamed(
              //           //     context,
              //           //     DetailsScreen.routeName,
              //           //     arguments: ProductDetailsArguments(
              //           //         product: demoProducts[index]),
              //           //   ),
              //           // ),
              //           SpecialOfferCard(
              //             image: "assets/images/Image Banner 2.png",
              //             title: "Smartphone",
              //             words: 18,
              //             press: () {
              //               Navigator.pushNamed(
              //                   context, ProductsScreen.routeName);
              //             },
              //           ));
              //     }

              //     return const SizedBox.shrink();
              //   },
              // ),
              SpecialOfferCard(
                image: "https://s.gravatar.com/avatar/3438c2ed73b30d9314358437c0115705?s=100&r=x&d=retro",
                title: "Smartphone",
                words: 18,
                name: "xinzhao",
                press: () {
                  Navigator.pushNamed(context, ProductsScreen.routeName);
                },
              ),
              SpecialOfferCard(
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
