import 'package:flutter/material.dart';
import 'package:shop_app/screens/home/components/search_field.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      color: Color(0xFFF6F7FB),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            color: const Color(0xFF4055FC), // Màu của container trên cùng
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
                const Positioned(
                  top: 90,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SearchField(),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              "assets/images/discovery.jpg",
              height: 100,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              "assets/images/discovery.jpg",
              height: 100,
            ),
          ),
        ],
      ),
    );
  }
}
