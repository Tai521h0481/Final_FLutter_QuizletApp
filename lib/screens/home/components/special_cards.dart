import 'package:flutter/material.dart';

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
          width: 300,
          height: 140,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                  width: 2,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
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
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundImage: NetworkImage(image),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          name,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 73, 73, 73),
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ],
                    ),
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
