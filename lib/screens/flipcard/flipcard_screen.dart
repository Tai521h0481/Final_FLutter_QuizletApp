import 'package:flutter/material.dart';
import 'components/flipcard_header.dart';
import 'components/flipcard_bottom.dart';
import 'components/flipcard_middle.dart';

class FlipCardScreen extends StatefulWidget {
  static String routeName = "/flipcards";
  const FlipCardScreen({Key? key}) : super(key: key);

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

  List<Widget> buildPageIndicators(int currentPage, int pageCount) {
    List<Widget> list = [];
    int start = currentPage - 2;
    int end = currentPage + 2;

    if (start < 0) {
      end -= start;
      start = 0;
    }
    if (end > pageCount - 1) {
      start -= (end - (pageCount - 1));
      end = pageCount - 1;
    }

    for (int i = start; i <= end; i++) {
      list.add(buildIndicator(i == currentPage));
    }
    return list;
  }

  Widget buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 6,
      width: isActive ? 20 : 6,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
