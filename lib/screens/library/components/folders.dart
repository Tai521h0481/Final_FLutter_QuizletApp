import 'package:flutter/material.dart';
import 'package:shop_app/controllers/folder.dart';
import 'package:shop_app/models/Folder.dart';
import 'package:shop_app/screens/folders/components/empty_folder.dart';
import 'package:shop_app/screens/folders/components/folder_factory.dart';
import 'package:shop_app/utils/local/save_local.dart';

class Folders extends StatefulWidget {
  const Folders({Key? key}) : super(key: key);

  @override
  State<Folders> createState() => _FoldersState();
}

class _FoldersState extends State<Folders> {
  List<dynamic> folders = [];
  List<dynamic> filteredFolders = [];
  Map<String, dynamic> userInfo = {};

  @override
  void initState() {
    super.initState();
    loadFolder();
  }

  Future<void> loadFolder() async {
    var storedFolders = await LocalStorageService().getData('folders');
    userInfo = await LocalStorageService().getData('data');
    if (storedFolders != null) {
      setState(() {
        folders = storedFolders;
        filteredFolders = folders;
      });
      return;
    }

    final token = await LocalStorageService().getData('token');
    if (token.isEmpty) {
      print('Token is empty. Cannot load topics.');
      return;
    }

    try {
      var res = await getFolderByID(userInfo["_id"], token);
      setState(() {
        folders = res['folders'] ?? [];
        filteredFolders = folders;
        LocalStorageService().saveData('folders', folders);
      });
    } catch (e) {
      print('Exception occurred while loading topics: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            // child: SectionTitle(title: "Sets", press: () {}),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                folders.length,
                (index) => SpecialFolderFactory.createList(filteredFolders: folders[index], context: context, image: userInfo['profileImage'], name: userInfo["username"])
              ),
            ),
          ),
        ],
      ),
    );
  }
}
