import 'package:flutter/material.dart';
import 'package:shop_app/screens/folders/components/topic_in_folder.dart';
import 'package:shop_app/screens/home/components/special_cards.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({super.key});
  static String routeName = "/folders";

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTopButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        if (_scrollController.offset >= 200) {
          _showBackToTopButton = true;
        } else {
          _showBackToTopButton = false;
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
            color: Color(0xFF444E66),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.add,
                size: 30,
                color: Color(0xFF444E66),
              )),
          IconButton(
            icon: const Icon(
              Icons.more_horiz,
              size: 30,
              color: Color(0xFF444E66),
            ),
            onPressed: () {},
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: SafeArea(
        child: ListView(
          controller: _scrollController,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 1),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Title',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF48555A),
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      children: [
                        Text(
                          '1 set',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        SizedBox(width: 10),
                        Container(
                          height: 30,
                          width: 1,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        SizedBox(width: 10),
                        CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(
                              "https://res.cloudinary.com/dfxqz0959/image/upload/v1710005544/cloudFinalAndroid/wtdzw0iejjznll9dzyo7.jpg"),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Name",
                          style: const TextStyle(
                              color: Color.fromARGB(255, 73, 73, 73),
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF4454FF),
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                    ),
                    child: const Text(
                      "Study this folder",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return TopicInFolder(
                    image: "https://res.cloudinary.com/...",
                    title: 'Food',
                    words: 12,
                    name: 'TaiNguyen',
                    press: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _showBackToTopButton
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              child: Icon(Icons.arrow_upward),
            )
          : null,
    );
  }
}
