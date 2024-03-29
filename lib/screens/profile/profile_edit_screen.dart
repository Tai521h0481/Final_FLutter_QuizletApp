import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/controllers/user.controller.dart';
import 'package:shop_app/screens/profile/components/profile_change_password.dart';

class ProfileEditScreen extends StatefulWidget {
  static String routeName = "/profile_edit";
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _initialUsername;
  String? _profileImageUrl;
  String? _token;
  String? _id;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('data') ?? '';
    _token = prefs.getString('token') ?? '';

    if (dataString.isNotEmpty) {
      try {
        final Map<String, dynamic> data = json.decode(dataString);
        setState(() {
          _usernameController.text = data["username"] ?? "";
          _emailController.text = data["email"] ?? "";
          _profileImageUrl = data["profileImage"];
          _initialUsername = data["username"];
          _id = data["_id"];
        });
      } catch (e) {
        print('Error parsing user data: $e');
      }
    } else {
      print('User data is empty.');
    }
  }

  void _saveChanges() async {
    if (_usernameController.text.isEmpty ||
        _usernameController.text == _initialUsername) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.info,
        text: "Username cannot be empty or unchanged",
      );
      return;
    }

    await updateUser(_id!, _token!, _usernameController.text)
        .then((value) async {
      if ((value?['message'] ?? '') != '') {
        final prefs = await SharedPreferences.getInstance();
        final dataUser = json.encode(value['user']);
        prefs.setString("data", dataUser);
        setState(() {
          _initialUsername = _usernameController.text;
        });
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: value['message'],
          onConfirmBtnTap: () {
            Navigator.of(context).pop();
          },
        );
        Navigator.pop(context, true);
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: value['error'],
        );
      }
    });
  }

  Future<void> _changeProfileImage() async {
    final ImagePicker _picker = ImagePicker();
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () async {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () async {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    XFile? pickedImage = await _picker.pickImage(source: source);

    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);
      const snackBar = SnackBar(
        content: Text("Uploading..."),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      var value = await uploadAvatar(_id!, _token!, imageFile);
      if ((value?['message'] ?? '') != '') {
        final prefs = await SharedPreferences.getInstance();
        final dataUser = json.encode(value['user']);
        prefs.setString("data", dataUser);
        setState(() {
          _profileImageUrl = value['user']['profileImage'];
        });
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: value['message'],
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: value['error'],
        );
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LineAwesomeIcons.angle_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (_profileImageUrl != null)
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(_profileImageUrl!),
                      backgroundColor: Colors.transparent,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: InkWell(
                          onTap: () {
                            _changeProfileImage();
                          },
                          child: const Icon(
                            LineAwesomeIcons.pen,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(LineAwesomeIcons.user),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(LineAwesomeIcons.envelope),
                ),
                onTap: () {
                  const snackBar = SnackBar(
                    content: Text("Email cannot be changed"),
                    duration: Duration(seconds: 2),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  //
                },
                borderRadius: BorderRadius.circular(30),
                child: TextFormField(
                  readOnly: true,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ProfileChangePassword.routeName,
                    );
                  },
                  decoration: const InputDecoration(
                    hintText: "Change Password",
                    hintStyle: TextStyle(fontWeight: FontWeight.bold),
                    prefixIcon: Icon(LineAwesomeIcons.fingerprint),
                    suffixIcon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  _saveChanges();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
