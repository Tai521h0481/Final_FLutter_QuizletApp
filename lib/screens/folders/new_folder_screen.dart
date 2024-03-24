import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/controllers/folder.dart';
import 'package:shop_app/screens/folders/folders_screen.dart';

class NewFolderScreen extends StatelessWidget {
  static String routeName = "/new-folder";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  NewFolderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F7FB),
        title: const Text(
          'Create set',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final prefs = await SharedPreferences.getInstance();
                String token = prefs.getString('token') ?? '';
                String title = _titleController.text ?? '';
                String description = _descriptionController.text ?? '';
                await createFolder(token, title, description).then((value) {
                  Navigator.pushNamed(
                    context,
                    FolderScreen.routeName,
                    arguments: {
                      'folderID': value['folder']["_id"],
                      'title': value['folder']["folderNameEnglish"],
                      'username': value['folder']['userId']['username'],
                      'image': value['folder']['userId']['profileImage'],
                      'sets': value['folder']["topicCount"]
                    },
                  );
                });
              }
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey, // Associate the Form with the GlobalKey
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                _buildField('Folder title', 'Folder title', _titleController,
                    _titleFocusNode, context),
                _buildField('Description (Optional)', 'Description (Optional)',
                    _descriptionController, null, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
      String hint,
      String subTitle,
      TextEditingController controller,
      FocusNode? focusNode,
      BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: const EdgeInsets.only(bottom: -5, top: 6),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 1.5),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 4.0),
              ),
              errorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1.5),
              ),
              focusedErrorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 4.0),
              ),
              hintStyle: const TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 179, 179, 179),
              ),
            ),
            validator: focusNode != null
                ? (value) {
                    if (value == null || value.isEmpty) {
                      FocusScope.of(context).requestFocus(focusNode);
                      return 'Please enter a folder title'; // This message will be shown as an error for the title field
                    }
                    return null;
                  }
                : null, // No validation for the description field
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              subTitle,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 132, 131, 131),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
