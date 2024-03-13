import 'package:flutter/widgets.dart';
import 'package:shop_app/screens/flipcard/flipcard_screen.dart';
import 'package:shop_app/screens/folders/components/topic_in_folder.dart';
import 'package:shop_app/screens/folders/folders_screen.dart';
import 'package:shop_app/screens/products/products_screen.dart';
import 'package:shop_app/screens/profile/components/profile_change_password.dart';
import 'package:shop_app/screens/profile/profile_edit_screen.dart';

import 'screens/details/details_screen.dart';
import 'screens/forgot_password/forgot_password_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/init_screen.dart';
import 'screens/register_success/register_success_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';
import 'screens/splash/splash_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  InitScreen.routeName: (context) => const InitScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  SignInScreen.routeName: (context) => const SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  ProductsScreen.routeName: (context) => const ProductsScreen(),
  DetailsScreen.routeName: (context) => const DetailsScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  ProfileEditScreen.routeName: (context) => const ProfileEditScreen(),
  RegisterSuccessScreen.routeName: (context) => const RegisterSuccessScreen(),
  FlipCardScreen.routeName: (context) {
    final topicId = ModalRoute.of(context)!.settings.arguments as String;
    return FlipCardScreen(topicId: topicId);
  },
  ProfileChangePassword.routeName: (context) => const ProfileChangePassword(),
  FolderScreen.routeName: (context) => const FolderScreen(),
};
