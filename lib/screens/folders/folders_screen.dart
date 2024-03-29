import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/controllers/folder.dart';
import 'package:shop_app/controllers/topic.dart';
import 'package:shop_app/screens/flipcard/components/custom_listtile.dart';
import 'package:shop_app/screens/flipcard/flipcard_screen.dart';
import 'package:shop_app/screens/folders/components/edit_folder.dart';
import 'package:shop_app/screens/folders/components/empty_folder.dart';
import 'package:shop_app/screens/folders/components/topic_in_folder.dart';
import 'package:shop_app/screens/init_screen.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({super.key});
  static String routeName = "/folders";

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  List<dynamic> topicDetails = [];
  String _token = "";

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
    _token = prefs.getString('token') ?? '';

    try {
      Map<String, dynamic> data = await getTopicByFolderID(id, _token);
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
    String _folderId = args['folderID'];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F7FB),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
            color: Color(0xFF444E66),
          ),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, InitScreen.routeName, (route) => false);
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
            onPressed: () {
              _showBottomSheet(context, _folderId, _title);
            },
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
                  if (topicDetails.isNotEmpty)
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4454FF),
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                      ),
                      child: const Text(
                        "Study this folder",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
            if (topicDetails.isNotEmpty)
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
                              'terms':
                                  topic['vocabularyCount'].toString() ?? '',
                            });
                      },
                    );
                  },
                ),
              ),
            if (topicDetails.isEmpty) const EmptyFolder(),
          ],
        ),
      ),
    );
  }

  Future<void> _showBottomSheet(BuildContext context, String folderId, String title, {String? description}) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: 280,
          width: double.infinity,
          padding: EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              CustomListTile(
                title: "Edit folder",
                icon: Icons.edit_square,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, EditFolder.routeName,
                      arguments: {
                        'folderID': folderId,
                        'title': title,
                        'description': description ?? '',
                      });
                },
              ),
              Divider(),
              CustomListTile(
                title: "Add sets",
                icon: Icons.add_to_photos,
                onTap: () {
                  // handleDeleteTopic(context, token, topicId);
                },
              ),
              Divider(),
              CustomListTile(
                title: "Delete folder",
                icon: Icons.delete,
                onTap: () {
                  handleDeleteFolder(context, _token, folderId);
                },
              ),
              Divider(),
              ListTile(
                title: Center(
                    child: Text(
                  'Cancel',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600]),
                )),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void handleDeleteFolder(
      BuildContext context, String token, String folderId) async {
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'Do you want to delete this folder?',
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      confirmBtnColor: Color(0xFF3F56FF),
      onConfirmBtnTap: () async {
        deleteFolder(token, folderId).then((value) async {
          if ((value?['message'] ?? '') != '') {
            SnackBar snackBar = SnackBar(
              content: Text(value?['message'] ?? ''),
              duration: Duration(seconds: 2),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.pushNamedAndRemoveUntil(
                context, InitScreen.routeName, (route) => false);
          } else {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              text: "Failed to delete folder. Please try again.",
            );
          }
        });
      },
    );
  }
}
