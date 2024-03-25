// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shop_app/controllers/user.controller.dart';
import 'package:shop_app/helper/keyboard.dart';

import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../components/no_account_text.dart';
import '../../../constants.dart';

class ForgotPassForm extends StatefulWidget {
  const ForgotPassForm({super.key});

  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String? email;
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
              if (value.isNotEmpty && errors.contains(kEmailNullError)) {
                setState(() {
                  errors.remove(kEmailNullError);
                });
              } else if (emailValidatorRegExp.hasMatch(value) &&
                  errors.contains(kInvalidEmailError)) {
                setState(() {
                  errors.remove(kInvalidEmailError);
                });
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty && !errors.contains(kEmailNullError)) {
                setState(() {
                  errors.add(kEmailNullError);
                });
              } else if (!emailValidatorRegExp.hasMatch(value) &&
                  !errors.contains(kInvalidEmailError)) {
                setState(() {
                  errors.add(kInvalidEmailError);
                });
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
          const SizedBox(height: 8),
          FormError(errors: errors),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                KeyboardUtil.hideKeyboard(context);
                print("Email: $email");
                // EasyLoading.show(status: 'loading...');
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.loading,
                  title: 'Loading',
                  text: 'Loading...',
                );
                try {
                  final data = await recoverPassword(email: email)
                      .timeout(const Duration(seconds: 15));
                  // EasyLoading.dismiss();
                  Navigator.pop(context);
                  if (data['error'] != null) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      text: data['error'],
                    );
                    return;
                  }
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    text: data['message'],
                  );
                } catch (e) {
                  // EasyLoading.dismiss();
                  Navigator.pop(context);
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.info,
                    text: 'Cannot connect to server',
                  );
                }
              }
            },
            child: const Text("Continue"),
          ),
          const SizedBox(height: 16),
          const NoAccountText(),
        ],
      ),
    );
  }
}
