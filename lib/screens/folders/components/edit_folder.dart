import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/controllers/folder.dart';
import 'package:shop_app/screens/folders/folders_screen.dart';

class EditFolder extends StatelessWidget {
  static String routeName = "/edit-folder";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController? _descriptionController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  EditFolder({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    String _title = args['title'];
    String _description = args['description'];
    String _folderID = args['folderID'];

    _titleController.text = _title;
    _descriptionController?.text = _description;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F7FB),
        title: const Text(
          'Edit set',
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
                String description = _descriptionController?.text ?? '';
                await updateFolder(token, _folderID, title, description)
                    .then((value) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    FolderScreen.routeName,
                    arguments: {
                      'folderID': value['folder']["_id"],
                      'title': value['folder']["folderNameEnglish"],
                      'username': value['folder']['userId']['username'],
                      'image': value['folder']['userId']['profileImage'],
                      'sets': value['folder']["topicCount"]
                    },
                    (route) => false,
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
                    _descriptionController!, null, context),
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
                      return 'Please enter a folder title';
                    }
                    return null;
                  }
                : null,
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
