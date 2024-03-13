import 'package:flutter/material.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({super.key});
  static String routeName = "/folders";

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
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
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
            IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {},
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        color: Colors.black,
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
                SizedBox(height: 10,),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 70, 45, 208),
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                  ),

                  child: const Text(
                    "Study this folder",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
