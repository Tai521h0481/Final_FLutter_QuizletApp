import 'package:flutter/material.dart';

class TopicInFolder extends StatelessWidget {
  const TopicInFolder({
    Key? key,
    required this.title,
    required this.image,
    required this.words,
    required this.press,
    required this.name,
  });

  final String title, image, name;
  final int words;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 10),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 100,
          // width: 300,
          height: 130,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C2D3A),
                          fontFamily: 'Roboto',
                        ),
                      ),
                      Text(
                        "$words terms",
                        style: const TextStyle(
                            color: Color.fromARGB(255, 72, 71, 71),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
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
