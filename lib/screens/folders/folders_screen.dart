import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/controllers/topic.dart';
import 'package:shop_app/screens/flipcard/flipcard_screen.dart';
import 'package:shop_app/screens/folders/components/topic_in_folder.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({super.key});
  static String routeName = "/folders";

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  List<dynamic> topicDetails = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final args = ModalRoute.of(context)?.settings.arguments as Map;
        String folderID = args['folderID'];
        loadTopicDetails(folderID);
      }
    });
  }

  Future<void> loadTopicDetails(String id) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    try {
      Map<String, dynamic> data = await getTopicByFolderID(id, token);
      List<dynamic> topicsFromAPI = data['topics'];
      setState(() {
        topicDetails = topicsFromAPI;
      });
    } catch (e) {
      print("Failed to load topic details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    String _title = args['title'];
    String _username = args['username'];
    String _profileImage = args['image'];
    int _sets = args['sets'];

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
                        _title,
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
                          '$_sets sets',
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
                            _profileImage,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          _username,
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
                    onPressed: () {
                      _showBottomSheet(context);
                    },
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
                itemCount: topicDetails.length,
                itemBuilder: (context, index) {
                  var topic = topicDetails[index]['topic'];

                  return TopicInFolder(
                    image: topic['ownerId']['profileImage'] ?? "",
                    title: topic['topicNameEnglish'] ?? 'Title',
                    words: topic['vocabularyCount'] ?? 0,
                    name: topic['ownerId']['username'] ?? 'Name',
                    press: () {
                      Navigator.pushNamed(context, FlipCardScreen.routeName,
                          arguments: {
                            "_id": topic["_id"],
                            "title": topic["topicNameEnglish"],
                            'image': topic['ownerId']['profileImage'] ?? '',
                            'username': topic['ownerId']['username'] ?? '',
                            'terms': topic['vocabularyCount'].toString() ?? '',
                          });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text(
                        'In original order',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF3F56FF)),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    Container(
                        color: Colors.grey.shade300,
                        child: const SizedBox(
                            height: 1.0, width: double.infinity)),
                    ListTile(
                      title: const Text('Alphabetically',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF3F56FF))),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: ListTile(
                  title: const Text(
                    'Cancel',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF3F56FF),
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                      letterSpacing: -1.0,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 30.0)
            ],
          ),
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor:
          Colors.transparent,
    );
  }
}
