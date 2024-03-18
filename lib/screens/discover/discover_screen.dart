import 'package:flutter/material.dart';
import 'package:shop_app/screens/discover/components/body.dart';
import 'package:shop_app/screens/discover/components/header.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});
  static String routeName = "/discover";

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String searchQuery = '';

  void _handleSearchChange(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(250),
        child: HomeHeader(onSearchChanged: _handleSearchChange),
      ),
      body: Body(searchQuery: searchQuery),
    );
  }
}
