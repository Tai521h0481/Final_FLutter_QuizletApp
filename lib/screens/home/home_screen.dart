import 'package:flutter/material.dart';

import 'components/banner.dart';
import 'components/home_header.dart';
import 'components/folders.dart';
import 'components/topics.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';

  void _handleSearchChange(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double headerHeight = screenHeight * 0.25;
    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(headerHeight),
        child: HomeHeader(onSearchChanged: _handleSearchChange),
      ),
      body: Container(
        color: const Color(0xFFF6F7FB),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              DiscountBanner(),
              Topics(searchQuery: searchQuery),
              SizedBox(height: 20),
              Folders(searchQuery: searchQuery),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
