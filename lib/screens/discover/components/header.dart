import 'package:flutter/material.dart';
import 'package:shop_app/screens/home/components/search_field.dart';

class HomeHeader extends StatelessWidget {
  final Function(String)? onSearchChanged;

  const HomeHeader({Key? key, this.onSearchChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageSize = screenWidth * 0.4;

    return Container(
      width: double.infinity,
      height: 250,
      color: Color(0xFFF6F7FB),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            color: const Color(0xFF465BB4), // Màu của container trên cùng
            child: Stack(
              children: [
                const Positioned(
                  top: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'Discover',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 90,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SearchField(
                    onChanged: onSearchChanged,
                  ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Image.asset(
                "assets/images/discover1.png",
                height: 80,
                width: imageSize,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Image.asset(
                "assets/images/discover1.png",
                height: 80,
                width: imageSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
