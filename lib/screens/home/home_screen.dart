import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/discount_banner.dart';
import 'components/home_header.dart';
import 'components/popular_product.dart';
import 'components/special_offers.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";

  dynamic getInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('data') ?? '';
    return data;
  }

  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color(0xFFF6F7FB),
          height: double.infinity,
          child: const SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                HomeHeader(),
                DiscountBanner(),
                SpecialOffers(),
                SizedBox(height: 20),
                PopularProducts(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
