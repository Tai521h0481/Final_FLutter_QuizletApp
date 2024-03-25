import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/controllers/user.controller.dart';
import 'package:shop_app/screens/profile/profile_screen.dart';

class ProfileChangePassword extends StatefulWidget {
  static String routeName = "/profile_change_password";

  const ProfileChangePassword({Key? key}) : super(key: key);

  @override
  _ProfileChangePasswordState createState() => _ProfileChangePasswordState();
}

class _ProfileChangePasswordState extends State<ProfileChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _tryChangePassword() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';
      final dataString = prefs.getString('data') ?? '';
      if (token.isNotEmpty && dataString.isNotEmpty) {
        final Map<String, dynamic> data = json.decode(dataString);
        String id = data['_id'];
        // EasyLoading.show(status: 'loading...');
        QuickAlert.show(
          context: context,
          type: QuickAlertType.loading,
          title: 'Loading',
          text: 'Loading...',
        );
        await changePassword(id, token, _oldPasswordController.text,
                _newPasswordController.text)
            .then((value) {
          Navigator.pop(context);
          if ((value?['message'] ?? '') != '') {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: value['message'],
              onConfirmBtnTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    ProfileScreen.routeName, (Route<dynamic> route) => false);
              },
            );
          } else {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              text: value['error'],
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Old Password',
                  prefixIcon: Icon(Icons.fingerprint),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your old password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  if (_newPasswordController.text != value) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _tryChangePassword,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
