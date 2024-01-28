import 'package:flutter/material.dart';
import 'package:shop_app/screens/flipcard/components/buildPageIndicators.dart';
import 'components/flipcard_header.dart';
import 'components/flipcard_bottom.dart';
import 'components/flipcard_middle.dart';

class FlipCardScreen extends StatefulWidget {
  static String routeName = "/flipcards";
  final String topicId;

  const FlipCardScreen({Key? key, required this.topicId}) : super(key: key);

  @override
  _FlipCardScreenState createState() => _FlipCardScreenState();
}

class _FlipCardScreenState extends State<FlipCardScreen> {
  PageController pageController = PageController(viewportFraction: 0.9);
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      int next = pageController.page!.round();
      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });

    print("Topic ID: ${widget.topicId}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Flip Card'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: const Color(0xFFF6F7FB),
            child: Column(
              children: <Widget>[
                Header(
                  pageController: pageController,
                  currentPage: currentPage,
                  buildPageIndicators: buildPageIndicators,
                ),
                Middle(
                  listTile: const ListTile(
                    leading: CircleAvatar(),
                    title: Text('Name'),
                  ),
                ),
                const Bottom(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
