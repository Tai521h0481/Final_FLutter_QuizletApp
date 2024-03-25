import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/controllers/topic.dart';
import 'package:shop_app/controllers/user.controller.dart';
import 'package:shop_app/screens/flipcard/components/custom_listtile.dart';
import 'package:shop_app/screens/flipcard/components/edit_topic.dart';
import 'package:shop_app/screens/init_screen.dart';
import 'components/flipcard_header.dart';
import 'components/flipcard_bottom.dart';
import 'components/flipcard_middle.dart';

class FlipCardScreen extends StatefulWidget {
  static const String routeName = "/flipcards";
  const FlipCardScreen({Key? key}) : super(key: key);

  @override
  _FlipCardScreenState createState() => _FlipCardScreenState();
}

class _FlipCardScreenState extends State<FlipCardScreen> {
  final PageController pageController = PageController(viewportFraction: 0.9);
  int currentPage = 0;
  String token = '';
  Map<String, dynamic> topics = {};
  String title = '';
  String description = '';
  late String topicId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadInitialData();
  }

  void _loadInitialData() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic> && args.containsKey("_id")) {
      topicId = args["_id"];
      _loadTopics();
    } else {
      print('Invalid arguments. Cannot load topics.');
    }
  }

  Future<void> _loadTopics() async {
    token = (await SharedPreferences.getInstance()).getString('token') ?? '';
    if (token.isEmpty) {
      print('Token is empty. Cannot load topics.');
      return;
    }
    try {
      await getVocabularyByTopicId(topicId, token)
          .then((value) => _updateTopics(value));
    } catch (e) {
      print('Exception occurred while loading topics: $e');
    }
  }

  void _updateTopics(Map<String, dynamic> value) {
    if (mounted) setState(() => topics = value ?? {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      );

  AppBar _buildAppBar() => AppBar(
        backgroundColor: const Color(0xFFF6F7FB),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back,
                size: 30, color: Color(0xFF444E66)),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, InitScreen.routeName, (route) => false)),
        actions: [_buildMoreOptionsButton(), SizedBox(width: 10)],
      );

  IconButton _buildMoreOptionsButton() => IconButton(
        icon: const Icon(Icons.more_horiz, size: 30, color: Color(0xFF444E66)),
        onPressed: () => _showBottomSheet(context),
      );

  Widget _buildBody() {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    title = args['title'] ?? '';
    description = args['description'] ?? '';
    return SafeArea(
      child: Container(
        color: const Color(0xFFF6F7FB),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Header(
                pageController: pageController,
                currentPage: currentPage,
                vocabularies: topics['vocabularies'] ?? []),
            Middle(
                title: args['title'],
                description: args['description'] ?? '',
                listTile: _buildListTile(args)),
            Bottom(
                currentPage: currentPage,
                vocabularies: topics['vocabularies'] ?? []),
          ],
        ),
      ),
    );
  }

  ListTile _buildListTile(Map<String, dynamic> args) => ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(args['image'])),
        title: Text(args['username'],
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${args['terms']} terms',
            style: const TextStyle(
                color: Colors.grey,
                fontFamily: 'Roboto',
                fontSize: 12,
                fontWeight: FontWeight.bold)),
      );

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Future<void> _showBottomSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize:
              0.4, // Kích thước ban đầu của bottom sheet (ở đây là 50% của màn hình)
          minChildSize:
              0.1, // Kích thước tối thiểu của bottom sheet (ở đây là 10% của màn hình)
          maxChildSize:
              0.8, // Kích thước tối đa của bottom sheet (ở đây là 80% của màn hình)
          expand: false,
          builder: (_, controller) {
            return Container(
              padding: EdgeInsets.all(8.0),
              child: ListView(
                controller: controller,
                children: <Widget>[
                  CustomListTile(
                    title: "Add to folder",
                    icon: Icons.add_box_outlined,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Divider(),
                  CustomListTile(
                    title: "Edit set",
                    icon: Icons.edit,
                    onTap: () {
                      handleEditTopic(context, topicId, title, description,
                          topics['vocabularies']);
                    },
                  ),
                  Divider(),
                  CustomListTile(
                    title: "Delete set",
                    icon: Icons.delete,
                    onTap: () {
                      handleDeleteTopic(context, token, topicId);
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
      },
    );
  }

  void handleEditTopic(BuildContext context, String topicId, String title,
      String description, List<dynamic> vocabularies) async {
    Navigator.pop(context);
    await Navigator.pushNamed(
      context,
      EditTopic.routeName,
      arguments: {
        'topicId': topicId,
        'title': title,
        'description': description,
        'vocabularies': vocabularies,
      },
    );
  }

  void handleDeleteTopic(
      BuildContext context, String token, String topicId) async {
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'Do you want to delete this topic?',
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      confirmBtnColor: Color(0xFF3F56FF),
      onConfirmBtnTap: () async {
        deleteTopic(token, topicId).then((value) async {
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
              text: "Failed to delete topic. Please try again.",
            );
          }
        });
      },
    );
  }
}
