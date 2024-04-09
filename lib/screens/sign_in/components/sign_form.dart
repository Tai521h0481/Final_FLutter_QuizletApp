// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/screens/init_screen.dart';
import 'package:shop_app/utils/local/save_local.dart';

import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../../../helper/keyboard.dart';
import '../../forgot_password/forgot_password_screen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickalert/quickalert.dart';
import '../../../controllers/user.controller.dart';

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool? remember = false;
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => email = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kEmailNullError);
              } else if (emailValidatorRegExp.hasMatch(value)) {
                removeError(error: kInvalidEmailError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kEmailNullError);
                return "";
              } else if (!emailValidatorRegExp.hasMatch(value)) {
                addError(error: kInvalidEmailError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            obscureText: true,
            onSaved: (newValue) => password = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPassNullError);
              } else if (value.length >= 6) {
                removeError(error: kShortPassError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPassNullError);
                return "";
              } else if (value.length < 6) {
                addError(error: kShortPassError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Password",
              hintText: "Enter your password",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              const Text("Remember me"),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: const Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: SizedBox(
                  width: 240,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        KeyboardUtil.hideKeyboard(context);
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.loading,
                          title: 'Loading',
                          text: 'Loading...',
                        );
                        try {
                          final data =
                              await loginAPI(email: email, password: password)
                                  .timeout(const Duration(seconds: 15));
                          Navigator.pop(context);
                          if(data['error'] != null) {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              text: data['error'],
                            );
                            return;
                          }
                          LocalStorageService().saveData('token', data['token']);
                          LocalStorageService().saveData('data', data['user']);
                          Navigator.pushNamedAndRemoveUntil(context, InitScreen.routeName, (route) => false,);
                        } catch (e) {
                          Navigator.pop(context);
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.info,
                            text: 'Cannot connect to server',
                          );
                        }
                      }
                    },
                    child: const Text(
                      "Continue",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () async {
                    var prefs = await SharedPreferences.getInstance();
                    var token = prefs.getString('token') ?? '';
                    if (token.isEmpty) {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.info,
                        text: 'Please login first',
                      );
                      return;
                    }
                    _authenticateWithBiometrics(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 15),
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF7642),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      "assets/images/fingerprint.png",
                      width: 30,
                      height: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _authenticateWithBiometrics(BuildContext context) async {
    final LocalAuthentication auth = LocalAuthentication();
    bool isAuthenticated = false;

    try {
      isAuthenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );
    } on Exception catch (e) {}

    if (isAuthenticated) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      print(token);
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomePage(userId: userId)),
      // );
    }
  }
}
