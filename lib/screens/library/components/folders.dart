// import 'package:flutter/material.dart';
// import 'package:shop_app/controllers/folder.dart';
// import 'package:shop_app/utils/local/save_local.dart';

// class Folders extends StatefulWidget {
//   const Folders({Key? key}) : super(key: key);

//   @override
//   State<Folders> createState() => _FoldersState();
// }

// class _FoldersState extends State<Folders> {
//   List<dynamic> folders = [];
//   List<dynamic> filteredFolders = [];
//   Map<String, dynamic> userInfo = {};

//   @override
//   void initState() {
//     loadFolder();
//     super.initState();
//   }

//   Future<void> loadFolder() async {
//     var storedFolders = await LocalStorageService().getData('folders');
//     var userInfo = await LocalStorageService().getData('data');
//     if (storedFolders != null) {
//       setState(() {
//         folders = storedFolders;
//         filteredFolders = folders;
//       });
//       return;
//     }

//     final token = await LocalStorageService().getData('token');
//     if (token.isEmpty) {
//       print('Token is empty. Cannot load topics.');
//       return;
//     }

//     try {
//       var res = await getFolderByID(userInfo["_id"], token);
//       setState(() {
//         folders = res['folders'] ?? [];
//         filteredFolders = folders;
//         LocalStorageService().saveData('folders', folders);
//       });
//     } catch (e) {
//       print('Exception occurred while loading topics: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: <Widget>[
//         Padding(
//           padding: EdgeInsets.all(15.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 1),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     _title,
//                     style: const TextStyle(
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF48555A),
//                       fontFamily: 'Roboto',
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10),
//               Container(
//                 margin: const EdgeInsets.only(bottom: 5),
//                 child: Row(
//                   children: [
//                     Text(
//                       '$_sets sets',
//                       style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.grey),
//                     ),
//                     SizedBox(width: 10),
//                     Container(
//                       height: 30,
//                       width: 1,
//                       color: Colors.grey.withOpacity(0.5),
//                     ),
//                     SizedBox(width: 10),
//                     CircleAvatar(
//                       radius: 18,
//                       backgroundImage: NetworkImage(
//                         _profileImage,
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     Text(
//                       _username,
//                       style: const TextStyle(
//                           color: Color.fromARGB(255, 73, 73, 73),
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               if (topicDetails.isNotEmpty)
//                 ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF4454FF),
//                     shape: BeveledRectangleBorder(
//                       borderRadius: BorderRadius.circular(7.0),
//                     ),
//                   ),
//                   child: const Text(
//                     "Study this folder",
//                     style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//         if (topicDetails.isNotEmpty)
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ListView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: topicDetails.length,
//               itemBuilder: (context, index) {
//                 var topic = topicDetails[index]['topic'];

//                 return TopicInFolder(
//                   image: topic['ownerId']['profileImage'] ?? "",
//                   title: topic['topicNameEnglish'] ?? 'Title',
//                   words: topic['vocabularyCount'] ?? 0,
//                   name: topic['ownerId']['username'] ?? 'Name',
//                   press: () {
//                     Navigator.pushNamed(context, FlipCardScreen.routeName,
//                         arguments: {
//                           "_id": topic["_id"],
//                           "title": topic["topicNameEnglish"],
//                           'image': topic['ownerId']['profileImage'] ?? '',
//                           'username': topic['ownerId']['username'] ?? '',
//                           'terms': topic['vocabularyCount'].toString() ?? '',
//                         });
//                   },
//                 );
//               },
//             ),
//           ),
//         if (topicDetails.isEmpty) const EmptyFolder(),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shop_app/models/Folder.dart';
import 'package:shop_app/screens/flipcard/flipcard_screen.dart';
import 'package:shop_app/screens/folders/components/empty_folder.dart';
import 'package:shop_app/screens/folders/components/topic_in_folder.dart';
import 'package:shop_app/utils/local/save_local.dart';

class Folders extends StatefulWidget {
  const Folders({Key? key}) : super(key: key);

  @override
  State<Folders> createState() => _FoldersState();
}

class _FoldersState extends State<Folders> {
  List<Folder> folders = [];

  @override
  void initState() {
    super.initState();
    loadFolder();
  }

  Future<void> loadFolder() async {
    var storedFolders = await LocalStorageService().getData('folders');
    if (storedFolders != null) {
      setState(() {
        folders =
            List<Folder>.from(storedFolders.map((x) => Folder.fromJson(x)));
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Folder> topicDetails = folders;
    return Scaffold(
      appBar: AppBar(
        title: Text("Folders"),
      ),
      body: SafeArea(
          child: ListView(
        children: [
          if (topicDetails.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: topicDetails.length,
                itemBuilder: (context, index) {
                  

                  
                },
              ),
            ),
          if (topicDetails.isEmpty) const EmptyFolder(),
        ],
      )),
    );
  }
}
