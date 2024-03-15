import 'package:flutter/material.dart';

import 'components/banner.dart';
import 'components/home_header.dart';
import 'components/folders.dart';
import 'components/topics.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";

  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(165.0),
        child: HomeHeader(),
      ),
      body: Container(
        color: const Color(0xFFF6F7FB),
        height: double.infinity,
        child: const SingleChildScrollView(
          child: Column(
            children: [
              DiscountBanner(),
              Topics(),
              SizedBox(height: 20),
              Folders(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
