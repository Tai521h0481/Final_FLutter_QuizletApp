import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PageController pageController = PageController(viewportFraction: 0.7);
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.arrow_back),
          title: Text('Flip Card'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () {},
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              color: Color(0xFFF6F7FB),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 250,
                        child: PageView.builder(
                          controller: pageController,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return AnimatedBuilder(
                              animation: pageController,
                              builder: (context, child) {
                                double value = 1.0;
                                if (pageController.hasClients &&
                                    pageController.position.haveDimensions) {
                                  value = pageController.page! - index;
                                  value =
                                      (1 - (value.abs() * 0.3)).clamp(0.1, 1.0);
                                }
                                return Center(
                                  child: SizedBox(
                                    height:
                                        Curves.easeOut.transform(value) * 200,
                                    width:
                                        Curves.easeOut.transform(value) * 300,
                                    child: child,
                                  ),
                                );
                              },
                              child: FlipCard(
                                direction: FlipDirection.VERTICAL,
                                front: buildCard('Front $index'),
                                back: buildCard('Back $index'),
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: buildPageIndicators(),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        'Title',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: CircleAvatar(),
                    title: Text('Name'),
                  ),
                  SizedBox(height: 10),
                  ListView(
                    physics:
                        NeverScrollableScrollPhysics(), // Để ListView không scroll được và tránh xung đột với SingleChildScrollView
                    shrinkWrap:
                        true, // Để ListView chỉ chiếm không gian cần thiết
                    children: <Widget>[
                      buildListTile(Icons.copy_all, 'Thẻ ghi nhớ',
                          Color.fromARGB(255, 98, 36, 184)),
                      buildListTile(Icons.school, 'Học', Colors.blue),
                      buildListTile(
                          Icons.check_circle, 'Kiểm tra', Colors.blue),
                      buildListTile(Icons.layers, 'Ghép thẻ', Colors.blue),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        'Thuật ngữ',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 250,
                    // color: Colors.white,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.all(15),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Icon(Icons.volume_up_outlined),
                          ),
                        ),
                        Container(
                          // padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(top: 15, right: 20),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Icon(Icons.star_border_purple500_sharp),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildListTile(IconData icon, String title, Color iconColor) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        onTap: () {}, // Thêm hành động của bạn
      ),
    );
  }

  Widget buildCard(String text) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {
                    print("clicked");
                  },
                  child: Icon(
                    Icons.crop_free_outlined,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildPageIndicators() {
    List<Widget> list = [];
    int start = currentPage - 2;
    int end = currentPage + 2;

    if (start < 0) {
      end -= start;
      start = 0;
    }
    if (end > 9) {
      start -= (end - 9);
      end = 9;
    }

    for (int i = start; i <= end; i++) {
      list.add(buildIndicator(i == currentPage));
    }
    return list;
  }

  Widget buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
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
