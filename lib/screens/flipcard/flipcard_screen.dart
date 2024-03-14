import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/controllers/user.controller.dart';
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
  Map<String, dynamic> userInfo = {};
  String token = '';
  Map<String, dynamic> topics = {};
  late String topicId;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args.containsKey("_id")) {
      topicId = args["_id"];
      loadTopics();
    } else {
      print('Invalid arguments. Cannot load topics.');
    }
  }

  Future<void> loadTopics() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      print('Token is empty. Cannot load topics.');
      return;
    }

    try {
      await getTopicByUserAPI(token).then((value) => setState(() {
            userInfo = value['user'] ?? {};
          }));
      await getVocabularyByTopicId(topicId, token).then((value) {
        if (mounted) {
          setState(() {
            topics = value ?? {};
          });
        }
        ;
      });
    } catch (e) {
      print('Exception occurred while loading topics: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    String _title = args['title'];
    String _username = args['username'];
    String _image = args['image'];
    String _terms = args['terms'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F7FB),
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.more_horiz,
              size: 30,
              color: Color(0xFF444E66),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          color: const Color(0xFFF6F7FB),
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              Header(
                pageController: pageController,
                currentPage: currentPage,
                vocabularies: topics['vocabularies'] ?? [],
              ),
              Middle(
                title: _title,
                listTile: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(_image),
                  ),
                  title: Text(
                    _username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '$_terms terms',
                    style: const TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Bottom(
                currentPage: currentPage,
                vocabularies: topics['vocabularies'] ?? [],
              ),
            ],
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
